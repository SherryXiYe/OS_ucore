#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <mmu.h>
#include <memlayout.h>
#include <pmm.h>
#include <default_pmm.h>
#include <sync.h>
#include <error.h>

/* *
 * Task State Segment:
 *
 * The TSS may reside anywhere in memory. A special segment register called
 * the Task Register (TR) holds a segment selector that points a valid TSS
 * segment descriptor which resides in the GDT. Therefore, to use a TSS
 * the following must be done in function gdt_init:
 *   - create a TSS descriptor entry in GDT
 *   - add enough information to the TSS in memory as needed
 *   - load the TR register with a segment selector for that segment
 *
 * There are several fileds in TSS for specifying the new stack pointer when a
 * privilege level change happens. But only the fields SS0 and ESP0 are useful
 * in our os kernel.
 *
 * The field SS0 contains the stack segment selector for CPL = 0, and the ESP0
 * contains the new ESP value for CPL = 0. When an interrupt happens in protected
 * mode, the x86 CPU will look in the TSS for SS0 and ESP0 and load their value
 * into SS and ESP respectively.
 * */
static struct taskstate ts = {0};

// virtual address of physicall page array
struct Page *pages;
// amount of physical memory (in pages)
size_t npage = 0;

// virtual address of boot-time page directory
extern pde_t __boot_pgdir;
pde_t *boot_pgdir = &__boot_pgdir;
// physical address of boot-time page directory
uintptr_t boot_cr3;     //一级页表的起始物理地址(存放在 cr3 寄存器中)。ucore 用boot_cr3（mm/pmm.c）记录这个值

// physical memory management
const struct pmm_manager *pmm_manager;

/* *
 * The page directory entry corresponding to the virtual address range
 * [VPT, VPT + PTSIZE) points to the page directory itself. Thus, the page
 * directory is treated as a page table as well as a page directory.
 *
 * One result of treating the page directory as a page table is that all PTEs
 * can be accessed though a "virtual page table" at virtual address VPT. And the
 * PTE for number n is stored in vpt[n].
 *
 * A second consequence is that the contents of the current page directory will
 * always available at virtual address PGADDR(PDX(VPT), PDX(VPT), 0), to which
 * vpd is set bellow.
 * */
pte_t * const vpt = (pte_t *)VPT;
pde_t * const vpd = (pde_t *)PGADDR(PDX(VPT), PDX(VPT), 0);

/* *
 * Global Descriptor Table:
 *
 * The kernel and user segments are identical (except for the DPL). To load
 * the %ss register, the CPL must equal the DPL. Thus, we must duplicate the
 * segments for the user and the kernel. Defined as follows:
 *   - 0x0 :  unused (always faults -- for trapping NULL far pointers)
 *   - 0x8 :  kernel code segment
 *   - 0x10:  kernel data segment
 *   - 0x18:  user code segment
 *   - 0x20:  user data segment
 *   - 0x28:  defined for tss, initialized in gdt_init
 * */
static struct segdesc gdt[] = {
    SEG_NULL,
    [SEG_KTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_KERNEL),
    [SEG_KDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_KERNEL),
    [SEG_UTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_USER),
    [SEG_UDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_USER),
    [SEG_TSS]   = SEG_NULL,
};

static struct pseudodesc gdt_pd = {
    sizeof(gdt) - 1, (uintptr_t)gdt
};

static void check_alloc_page(void);
static void check_pgdir(void);
static void check_boot_pgdir(void);

/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
    asm volatile ("lgdt (%0)" :: "r" (pd));
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
}

/* *
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
    ts.ts_esp0 = esp0;
}

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
    ts.ts_ss0 = KERNEL_DS;

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);

    // reload all segment registers
    lgdt(&gdt_pd);

    // load the TSS
    ltr(GD_TSS);
}

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {       //在pmm_init函数中调用
    pmm_manager = &default_pmm_manager;     //！！初始化pmm_manager，指向了default_pmm_manager
    cprintf("memory management: %s\n", pmm_manager->name);
    pmm_manager->init();
}

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
//调用pmm_manager->init_memmap，即调用default_init_memmap函数
//根据page_init函数中传递过来的参数（某个连续地址的空闲块的起始页，页个数）来建立一个连续内存空闲块的双向链表
//(假定page_init函数是按地址从小到大的顺序传来的连续内存空闲块的)
static void
init_memmap(struct Page *base, size_t n) {
    pmm_manager->init_memmap(base, n);
}

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
    struct Page *page=NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
    }
    local_intr_restore(intr_flag);
    return page;
}

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
    }
    local_intr_restore(intr_flag);
}

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
    }
    local_intr_restore(intr_flag);
    return ret;
}

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;
    //首先根据bootloader给出的内存布局信息找出最大的物理内存地址maxpa
    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {  //type=1,address range memory
            if (maxpa < end && begin < KMEMSIZE) {  //KMEMSIZE: the maximum amount of physical memory
                maxpa = end;
            }   //全局指针变量end:记录bootloader加载ucore的结束地址
        }
    }
    if (maxpa > KMEMSIZE) {
        maxpa = KMEMSIZE;
    }

    extern char end[];

    npage = maxpa / PGSIZE;     //需要管理的物理页个数(x86的起始物理内存地址为0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    //把end按页大小为边界取整(把end向上取PGSIZE的倍数)。
    //得到pages作为管理页级物理内存空间所需的Page结构的内存空间的首地址指针

    //因此，从地址0到地址pages+ sizeof(struct Page) * npage)结束的物理内存空间设定为已占用物理内存空间（起始0~640KB的空间是空闲的），
    //地址pages+ sizeof(struct Page) * npage)以上的空间为空闲物理内存空间

    for (i = 0; i < npage; i ++) {
        SetPageReserved(pages + i);  //实现占用标记。即：把page的标志位flags置为PG_reserved。表示这些页已经被使用了，将来不能被用于分配
    }

    //空闲物理内存空间的起始地址
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    //根据探测到的空闲物理空间，通过如下语句实现空闲标记
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        if (memmap->map[i].type == E820_ARM) {
            if (begin < freemem) {
                begin = freemem;
            }
            if (end > KMEMSIZE) {
                end = KMEMSIZE;
            }
            if (begin < end) {
                begin = ROUNDUP(begin, PGSIZE);
                end = ROUNDDOWN(end, PGSIZE);
                //获得空闲空间的起始地址begin和结束地址end
                if (begin < end) {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                    //init_memmap函数(最终调用default_init_memmap)是把空闲物理页对应的Page结构中的flags和引用计数ref清零，
                    //并加到free_area.free_list指向的双向列表中，为将来的空闲页管理做好初始化准备工作
                    //参数1：某个连续地址的空闲块的起始页。参数2：页个数
                }
            }
        }
    }
}

//boot_map_segment - setup&enable the paging mechanism
// parameters
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
    struct Page *p = alloc_page();
    if (p == NULL) {
        panic("boot_alloc_page failed.\n");
    }
    return page2kva(p);
}

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
//将页目录表项补充完成（从0~4M扩充到0~KMEMSIZE）。
//还更新了段映射机制，使用了一个新的段表。这个新段表除了包括内核态的代码段和数据段描述符，还包括用户态的代码段和数据段描述符以及TSS（段）的描述符。
void
pmm_init(void) {
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);

    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    //我们需要分配/释放物理内存（粒度为4KB或其他大小）。
    //首先,我们应该基于pmm.h中定义了物理内存管理器的框架(结构pmm_manager),初始化物理内存管理器（pmm）。
    //然后pmm可以分配/释放物理内存。
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();

    check_pgdir();

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();

    print_pgdir();

}

//get_pte - get pte and return the kernel virtual address of this pte for la
//        - if the PT contians this pte didn't exist, alloc a page for PT
// parameter:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
//getpte-获取pte并为la返回该pte的内核虚拟地址
//-如果包含此pte的PT不存在，就分配一个包含此项的二级页表
//参数：
//pgdir：PDT的内核虚拟基址
//la：需要映射的线性地址
//create：一个逻辑值，用于决定是否为PT分配页面
//return vaule：此pte的内核虚拟地址
//此函数找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。
/*主要功能为根据给定的page directory以及线性地址，查询出该linear address对应的page table entry，
并且根据输入参数要求判断是否创建不存在的页表*/
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    /* LAB2 EXERCISE 2: YOUR CODE
     *
     * If you need to visit a physical address, please use KADDR()
     * please read pmm.h for useful macros
     *
     * Maybe you want help comment, BELOW comments can help you finish the code
     *
     * Some Useful MACROs and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   PDX(la) = the index of page directory entry of VIRTUAL ADDRESS la.
     *   KADDR(pa) : takes a physical address and returns the corresponding kernel virtual address.
     *   set_page_ref(page,1) : means the page be referenced by one time
     *   page2pa(page): get the physical address of memory which this (struct Page *) page  manages
     *   struct Page * alloc_page() : allocation a page
     *   memset(void *s, char c, size_t n) : sets the first n bytes of the memory area pointed by s
     *                                       to the specified value c.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    /*LAB2练习2：你的代码
    *如果您需要访问物理地址，请使用KADDR（）
    *请阅读pmm.h中有用的宏
    *
    *一些有用的宏和定义，您可以在下面的实现中使用它们。

    *MACROs(宏)或函数：
    *PDX（la）=虚拟地址la的页目录项的索引。
    *KADDR（pa）：通过物理地址返回相应的内核虚拟地址。
    *set_page_ref（page，1）：表示页面被一次引用
    *page2pa（page）：获取这个(struct Page *)页面管理的内存的物理地址
    *struct Page * alloc_page()：分配一个page
    *memset（void*s，char c，size_tn）：将s指向的内存区域的前n个字节设置为c

    *定义：
    *PTE_P 0x001    页表项/页目录项的标志位：表示存在
    *PTE_W 0x002    页表项/页目录项的标志位：表示内容可写
    *PTE_U 0x004    页表项/页目录项的标志位：表示用户可以访问 表示用户态的软件可以读取对应地址的物理内存页内容
    */
#if 0
    pde_t *pdep = NULL;   // (1) find page directory entry 查找页目录项
    if (0) {              // (2) check if entry is not present 检查页表项（二级页表项）是否不存在
                          // (3) check if creating is needed, then alloc page for page table
                            根据create参数的值来处理是否创建新的二级页表。如果create参数为0，则get_pte返回NULL；
                            如果create参数不为0，则get_pte需要申请一个新的物理页（通过alloc_page来实现)
                          // CAUTION: this page is used for page table, not for common data page
                            注意：此页用于页表，而非通用数据页
                          // (4) set page reference
                            在一级页表中添加页目录项指向表示二级页表的新物理页
        uintptr_t pa = 0; // (5) get linear address of page 获取页面的线性地址
                          // (6) clear page content using memset  使用memset清除页面内容。
                            新申请的页必须全部设定为零，因为这个页所代表的虚拟地址都没有被映射。
                          // (7) set page directory entry's permission
                            设置页目录项的权限（设置控制位）
    }
    return NULL;          // (8) return page table entry 返回页表项
#endif
    pde_t *pdep = &pgdir[PDX(la)];      // 获取到页目录表中给定线性地址对应到的页目录项
    pte_t *ptep = ((pte_t *) (KADDR(*pdep & ~0XFFF)) + PTX(la)); // 从找到的页目录项中查询到线性地址对应到的页表中的页表项，即:页表基址加上线性地址的中的offset（第12...21位，从0开始）
    if (*pdep & PTE_P) 
        return ptep; // 检查查找到的页目录项是否存在，如果存在直接返回找到的页表项即可
    if (!create) 
        return NULL; // 如果该页目录项是不存在的，并且参数要求不创建新的页表，则直接返回
    struct Page* pt = alloc_page(); // 如果需要按需创建新的页表，则请求一个物理页来存储新创建的页表
    if (pt == NULL) 
        return NULL; // 如果物理空间不足，直接返回
    set_page_ref(pt, 1);    // 更新该物理页的引用计数
    uintptr_t pa = page2pa(pt);   //获取pt页面管理的内存的物理地址
    ptep = KADDR(pa);           // 获取到该物理页的虚拟地址（此时已经启动了page机制，内核地址空间），这是因为CPU执行的指令中使用的已经是虚拟地址了
    memset(ptep, 0, PGSIZE);    // 新创建的页表进行初始化
    *pdep = (pa & ~0XFFF) | PTE_U | PTE_W | PTE_P; // 对原先的页目录项进行设置，包括设置其对应的页表的物理地址，以及包括存在位在内的标志位
    return &ptep[PTX(la)];      // 返回线性地址对应的页目录项
}

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
    pte_t *ptep = get_pte(pgdir, la, 0);
    if (ptep_store != NULL) {
        *ptep_store = ptep;
    }
    if (ptep != NULL && *ptep & PTE_P) {
        return pte2page(*ptep);
    }
    return NULL;
}

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
//释放某虚地址所在的页并且取消PTE表项的映射
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    /* LAB2 EXERCISE 3: YOUR CODE
     *
     * Please check if ptep is valid, and tlb must be manually updated if mapping is updated
     *
     * Maybe you want help comment, BELOW comments can help you finish the code
     *
     * Some Useful MACROs and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   struct Page *page pte2page(*ptep): get the according page from the value of a ptep
     *   free_page : free a page
     *   page_ref_dec(page) : decrease page->ref. NOTICE: ff page->ref == 0 , then this page should be free.
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    /*实验2练习3：你的代码
    *请检查ptep是否有效，如果映射已更新，则必须手动更新tlb
    *一些有用的宏和定义，您可以在下面的实现中使用它们。

    *MACRO或函数：

    *struct Page *page pte2page(*ptep): 从ptep(页表项指针)的值获取相应的页
    *free_page:释放页面
    *page_ref_dec（页面）：减少page_ref。注意：若 page->ref==0，则这个page应该是free的。
    *tlb_invalidate（pde_t*pgdir，uintptr_t la）：使tlb条目无效，但仅当正在编辑的页表是处理器当前使用的页表时

    *定义：
    *PTE_P 0x001    //页表/目录条目标志位：存在

    */
#if 0
    if (0) {                      //(1) check if this page table entry is present
        struct Page *page = NULL; //(2) find corresponding page to pte
                                  //(3) decrease page reference
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    assert(*ptep & PTE_P); // 确保传入的二级页表项是存在的
    struct Page *page = pte2page(*ptep); // 获取该页表项对应的物理页对应的Page结构
    // 减少该物理页的引用计数，并判断该物理页的引用计数是否变为0
    if (page_ref_dec(page) == 0) {     
        free_page(page);    // ref变成0，即不存在任何虚拟页指向该物理页，释放该物理页
    *ptep &= (~PTE_P);      // 将PTE的存在位设置为0，表示该映射关系无效
    tlb_invalidate(pgdir, la);  //刷新TLB，保证TLB中的缓存不会有错误的映射关系
    }
}

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
    pte_t *ptep = get_pte(pgdir, la, 0);
    if (ptep != NULL) {
        page_remove_pte(pgdir, la, ptep);
    }
}

//page_insert - build the map of phy addr of an Page with the linear addr la
// paramemters:
//  pgdir: the kernel virtual base address of PDT  PDT的内核虚拟基址
//  page:  the Page which need to map  需要映射的页面
//  la:    the linear address need to map  需要映射的线性地址
//  perm:  the permission of this Page which is setted in related pte 在相关pte中设置的本页面的权限
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate  PT已更改，因此TLB需要作废
// 用线性地址la构建页面的物理地址映射 将物理页映射到页表上
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
    pte_t *ptep = get_pte(pgdir, la, 1);
    if (ptep == NULL) {
        return -E_NO_MEM;
    }
    page_ref_inc(page);     //page->ref += 1
    if (*ptep & PTE_P) {
        struct Page *p = pte2page(*ptep);
        if (p == page) {
            page_ref_dec(page);
        }
        else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
    tlb_invalidate(pgdir, la);
    return 0;
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    if (rcr3() == PADDR(pgdir)) {
        invlpg((void *)la);
    }
}

static void
check_alloc_page(void) {
    pmm_manager->check();
    cprintf("check_alloc_page() succeeded!\n");
}

static void
check_pgdir(void) {
    assert(npage <= KMEMSIZE / PGSIZE);
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
    assert(pte2page(*ptep) == p1);
    assert(page_ref(p1) == 1);

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);

    p2 = alloc_page();
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
    assert(*ptep & PTE_U);
    assert(*ptep & PTE_W);
    assert(boot_pgdir[0] & PTE_U);
    assert(page_ref(p2) == 1);

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
    assert(page_ref(p1) == 2);
    assert(page_ref(p2) == 0);
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
    assert(pte2page(*ptep) == p1);
    assert((*ptep & PTE_U) == 0);

    page_remove(boot_pgdir, 0x0);
    assert(page_ref(p1) == 1);
    assert(page_ref(p2) == 0);

    page_remove(boot_pgdir, PGSIZE);
    assert(page_ref(p1) == 0);
    assert(page_ref(p2) == 0);

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
    free_page(pde2page(boot_pgdir[0]));
    boot_pgdir[0] = 0;

    cprintf("check_pgdir() succeeded!\n");
}

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));

    assert(boot_pgdir[0] == 0);

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
    assert(page_ref(p) == 1);
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
    assert(page_ref(p) == 2);

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);

    *(char *)(page2kva(p) + 0x100) = '\0';
    assert(strlen((const char *)0x100) == 0);

    free_page(p);
    free_page(pde2page(boot_pgdir[0]));
    boot_pgdir[0] = 0;

    cprintf("check_boot_pgdir() succeeded!\n");
}

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
    str[1] = 'r';
    str[2] = (perm & PTE_W) ? 'w' : '-';
    str[3] = '\0';
    return str;
}

//get_pgtable_items - In [left, right] range of PDT or PT, find a continuous linear addr space
//                  - (left_store*X_SIZE~right_store*X_SIZE) for PDT or PT
//                  - X_SIZE=PTSIZE=4M, if PDT; X_SIZE=PGSIZE=4K, if PT
// paramemters:
//  left:        no use ???
//  right:       the high side of table's range
//  start:       the low side of table's range
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
    }
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
            start ++;
        }
        if (right_store != NULL) {
            *right_store = start;
        }
        return perm;
    }
    return 0;
}

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
}

