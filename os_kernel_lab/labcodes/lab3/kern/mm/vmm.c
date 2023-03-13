#include <vmm.h>
#include <sync.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <error.h>
#include <pmm.h>
#include <x86.h>
#include <swap.h>

/* 
  vmm design include two parts: mm_struct (mm) & vma_struct (vma)
  mm is the memory manager for the set of continuous virtual memory  
  area which have the same PDT. vma is a continuous virtual memory area.
  There a linear link list for vma & a redblack link list for vma in mm.
---------------
  mm related functions:
   golbal functions
     struct mm_struct * mm_create(void)
     void mm_destroy(struct mm_struct *mm)
     int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
--------------
  vma related functions:
   global functions
     struct vma_struct * vma_create (uintptr_t vm_start, uintptr_t vm_end,...)
     void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
     struct vma_struct * find_vma(struct mm_struct *mm, uintptr_t addr)
   local functions
     inline void check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
---------------
   check correctness functions
     void check_vmm(void);
     void check_vma_struct(void);
     void check_pgfault(void);
*/

static void check_vmm(void);
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));

    if (mm != NULL) {
        list_init(&(mm->mmap_list));
        mm->mmap_cache = NULL;
        mm->pgdir = NULL;
        mm->map_count = 0;

        if (swap_init_ok) swap_init_mm(mm);
        else mm->sm_priv = NULL;
    }
    return mm;
}

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
//创建vma
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));

    if (vma != NULL) {
        vma->vm_start = vm_start;
        vma->vm_end = vm_end;
        vma->vm_flags = vm_flags;
    }
    return vma;
}


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
//查找在mm变量中的mmap_list（双向链表头）对应的双向链表中的某个包含此addr的vma
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
    struct vma_struct *vma = NULL;
    if (mm != NULL) {
        vma = mm->mmap_cache;   //首先查找对应vma在不在cache中（是不是上一次访问的vma）
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {    //如果不是
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {      //从双向链表头开始遍历
                    vma = le2vma(le, list_link);
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
                    vma = NULL;
                }
        }
        if (vma != NULL) {
            mm->mmap_cache = vma;       //找到了就重置cache
        }
    }
    return vma;
}


// check_vma_overlap - check if vma1 overlaps vma2 ?  检查vma1是否与vma2重叠
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
}


// insert_vma_struct -insert vma in mm's list link
//把一个vma变量按照其空间位置[vma->vm_start,vma->vm_end]从小到大的顺序插入到所属的mm变量中的mmap_list双向链表中
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {      //从双向链表头开始遍历
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {      //找到插入位置，此时le指向地址更大的下一个节点，le_prev指向地址更小的上一个节点。应插入在二者之间
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);   //若能插入，应插入在le_prev和le_next之间

    /* check overlap 检查重叠 */
    if (le_prev != list) {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
    }
    if (le_next != list) {
        check_vma_overlap(vma, le2vma(le_next, list_link));
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));     //插入

    mm->map_count ++;
}

// mm_destroy - free mm and mm internal fields
//删除mm。释放包括用kmalloc分配的空间，以及mmap_list中的vma
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
    mm=NULL;
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
    check_vmm();
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
    
    check_vma_struct();
    check_pgfault();

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
        assert(le != &(mm->mmap_list));
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
        struct vma_struct *vma1 = find_vma(mm, i);
        assert(vma1 != NULL);
        struct vma_struct *vma2 = find_vma(mm, i+1);
        assert(vma2 != NULL);
        struct vma_struct *vma3 = find_vma(mm, i+2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i+3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i+4);
        assert(vma5 == NULL);

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
        struct vma_struct *vma_below_5= find_vma(mm,i);
        if (vma_below_5 != NULL ) {
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vma_struct() succeeded!\n");
}

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
    assert(pgdir[0] == 0);

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
    free_page(pde2page(pgdir[0]));
    pgdir[0] = 0;

    mm->pgdir = NULL;
    mm_destroy(mm);
    check_mm_struct = NULL;

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_pgfault() succeeded!\n");
}
//page fault number
volatile unsigned int pgfault_num=0;

/* do_pgfault - interrupt handler to process the page fault execption
 * @mm         : the control struct for a set of vma using the same PDT
 * @error_code : the error code recorded in trapframe->tf_err which is setted by x86 hardware
 * @addr       : the addr which causes a memory access exception, (the contents of the CR2 register)
 *
 * CALL GRAPH: trap--> trap_dispatch-->pgfault_handler-->do_pgfault
 * The processor provides ucore's do_pgfault function with two items of information to aid in diagnosing
 * the exception and recovering from it.
 *   (1) The contents of the CR2 register. The processor loads the CR2 register with the
 *       32-bit linear address that generated the exception. The do_pgfault fun can
 *       use this address to locate the corresponding page directory and page-table
 *       entries.
 *   (2) An error code on the kernel stack. The error code for a page fault has a format different from
 *       that for other exceptions. The error code tells the exception handler three things:
 *         -- The P flag   (bit 0) indicates whether the exception was due to a not-present page (0)
 *            or to either an access rights violation or the use of a reserved bit (1).
 *         -- The W/R flag (bit 1) indicates whether the memory access that caused the exception
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
/*  do_pgfault-处理页访问异常(page fault)的中断处理程序
    参数：  @mm：使用相同PDT的一组vma的控制结构
            @error_code：由x86硬件设置的trapframe->tf_err中记录的错误码errorCode，说明了页访问异常的类型
            @addr：导致内存访问异常的地址（CR2寄存器的内容）（产生页访问异常后，CPU把引起页访问异常的线性地址装到寄存器CR2中）
    调用图：trap-->trap_dispatch-->pgfault_handler-->do_pgfault
    处理器为ucore的do_pgfault函数提供两项信息，以帮助诊断异常并从中恢复。
    （1）CR2寄存器的内容。
        处理器将产生异常的32位线性地址加载到CR2寄存器。do_pgfault函数可以使用该地址来定位相应的页目录和页表项。
    （2）内核栈上的错误码。
        页面访问异常错误码的格式与其他异常的格式不同。错误码告诉异常处理程序三件事：
        --P(present)标志（位0）指示异常是由于不存在页面（0）还是由于访问权限冲突或使用了保留位（1）。
        --W/R标志（位1）指示导致异常的内存访问是读（0）还是写（1）。         （位１为１表示写异常，比如写了只读页）
        --U/S标志（位2）指示异常发生时处理器是在用户模式（1）还是在管理模式（0）下执行。    （位２为１表示访问权限异常，比如用户态程序访问内核空间的数据）
*/
//do_pgfault函数是完成页访问异常处理的主要函数
/*它根据从CPU的控制寄存器CR2中获取的页访问异常的物理地址以及根据errorCode的错误类型
  来查找此地址是否在某个VMA的地址范围内以及是否满足正确的读写权限，
  如果在此范围内并且权限也正确，这认为这是一次合法访问，但没有建立虚实对应关系。
    所以需要分配一个空闲的内存页，并修改页表完成虚地址到物理地址的映射，刷新TLB，
    然后调用iret中断，返回到产生页访问异常的指令处重新执行此指令。
  如果该虚地址不在某VMA范围内，则认为是一次非法访问。
*/
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
    int ret = -E_INVAL;
    //try to find a vma which include addr
    //首先查询mm_struct中的合法的虚拟地址链表(事实上是线性地址，但是由于在ucore中弱化了段机制，段仅仅起到对等映射的作用，因此虚拟地址等于线性地址)，
    //用于确定当前出现page fault的线性地址是否合法，如果合法则继续执行调出物理页，否则直接返回NULL；
    struct vma_struct *vma = find_vma(mm, addr);    //查找此地址是否在某个vma的地址范围内,找到包含这个地址的vma

    pgfault_num++;
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {          //没有找到包含这个地址的vma
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }
    //check the error_code
    switch (error_code & 3) {       //判断是否出现了读/写不允许读/写的页这种情况，如果出现了上述情况，则应该直接返回
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {      //对应的vma不可写,出现了写不允许写的页的情况，直接返回
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
        goto failed;
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
            goto failed;
        }
    }
    /* IF (write an existed addr ) OR
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    //根据合法虚拟地址（mm_struct中保存的合法虚拟地址链表中可查询到）的标志，来生成对应产生的物理页的权限
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
        perm |= PTE_W;
    }
    addr = ROUNDDOWN(addr, PGSIZE);

    ret = -E_NO_MEM;

    pte_t *ptep=NULL;
    /*LAB3 EXERCISE 1: YOUR CODE
    * Maybe you want help comment, BELOW comments can help you finish the code
    *
    * Some Useful MACROs and DEFINEs, you can use them in below implementation.
    * MACROs or Functions:
    *   get_pte : get an pte and return the kernel virtual address of this pte for la
    *             if the PT contians this pte didn't exist, alloc a page for PT (notice the 3th parameter '1')
    *   pgdir_alloc_page : call alloc_page & page_insert functions to allocate a page size memory & setup
    *             an addr map pa<--->la with linear address la and the PDT pgdir
    * DEFINES:
    *   VM_WRITE  : If vma->vm_flags & VM_WRITE == 1/0, then the vma is writable/non writable
    *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
    *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    
    一些有用的MACRO（宏）和DEFINE，您可以在下面的实现中使用它们。
    MACRO或函数：
        get_pte：获取一个pte，并为线性地址la返回该pte的内核虚拟地址
                 如果包含该页表项pte的页表PT不存在，则为PT分配一个页面（注意第3个参数“1”）
        pgdir_alloc_page：在kern/mm/pmm.c中，调用alloc_page和page_insert函数来分配一个页面大小的内存，并使用线性地址la和PDT pgdir建立映射 pa<--->la
    定义：
        VM_WRITE：  如果vma->vm_flags&VM_WRITE==1/0，则vma是可写/不可写的
        PTE_W      0x002        页表/页目录项的标志位：可写
        PTE_U      0x004        页表/页目录项的标志位：用户可以访问
    变量：
        mm->pgdir：这些vma的PDT
    */
/*
    LAB3 EXERCISE 1: YOUR CODE
    ptep = ???              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
                                尝试查找pte，如果pte的PT（页表）不存在，则创建一个PT
    if (*ptep == 0) {
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
                                如果物理地址不存在，那么分配一个页面，并且用逻辑地址映射物理地址
    }
    else {
    LAB3 EXERCISE 2: YOUR CODE
    * Now we think this pte is a  swap entry, we should load data from disk to a page with phy addr,
    * and map the phy addr with logical addr, trigger swap manager to record the access situation of this page.
    *
    *  Some Useful MACROs and DEFINEs, you can use them in below implementation.
    *  MACROs or Functions:
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
        现在我们认为这个pte是一个交换条目，我们应该将数据从磁盘加载到具有物理地址的页面，并将物理地址映射到逻辑地址，
        触发交换管理器来记录该页面的访问情况。
        MACRO或函数：
            swap_in(mm, addr, &page)：swap.c中，分配一个内存页，然后根据PTE中addr的交换条目swap entry，找到磁盘页的addr，将磁盘页的内容读入该内存页
            page_insert：使用线性地址la构建page的phy-addr映射（将物理页与虚拟页建立映射关系）
            swap_map_swappable：设置页面可交换

        if(swap_init_ok) {
            struct Page *page=NULL;
                                    //(1）According to the mm AND addr, try to load the content of right disk page
                                    //    into the memory which page managed.
                                    根据mm和addr，尝试将正确的磁盘页面的内容加载到页面管理的内存中。
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                     根据mm，addr和page，设置phy-addr<--->逻辑地址的映射（将物理页与虚拟页建立映射关系）
                                    //(3) make the page swappable.
                                    使页面可交换
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
*/
    ptep = get_pte(mm->pgdir, addr, 1); // 获取当前发生缺页的虚拟页对应的PTE (获取出错的线性地址对应的虚拟页的起始地址对应到的页表项)
    if (*ptep == 0) {   //如果需要的物理页没有被分配
        struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm); // 分配物理页，并且与对应的虚拟页建立映射关系（如果物理地址不存在，那么分配一个页面，并且用逻辑地址映射物理地址）
    } else {   //如果查询到的PTE不为0，则表示对应的物理页在外存中（P位为0，且高24位不为0） 
        if (swap_init_ok) { // 判断当前交换机制是否正确被初始化
            struct Page *page = NULL;
            swap_in(mm, addr, &page); // 将物理页换入到内存中
            page_insert(mm->pgdir, page, addr, perm); // 将物理页与虚拟页建立映射关系.(用线性地址la(addr)构建页面的物理地址映射 将物理页映射到页表上)
            swap_map_swappable(mm, addr, page, 1); // 设置当前的物理页为可交换的
            page->pra_vaddr = addr; // 同时在物理页中维护其对应到的虚拟页的信息
        } else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
    }
    ret = 0;
failed:
    return ret;
}

