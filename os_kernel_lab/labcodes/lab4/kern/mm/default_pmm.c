#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>

/*  In the First Fit algorithm, the allocator keeps a list of free blocks
 * (known as the free list). Once receiving a allocation request for memory,
 * it scans along the list for the first block that is large enough to satisfy
 * the request. If the chosen block is significantly larger than requested, it
 * is usually splitted, and the remainder will be added into the list as
 * another free block.
 *  Please refer to Page 196~198, Section 8.2 of Yan Wei Min's Chinese book
 * "Data Structure -- C programming language".
*/
// LAB2 EXERCISE 1: YOUR CODE
// you should rewrite functions: `default_init`, `default_init_memmap`,
// `default_alloc_pages`, `default_free_pages`.
/*
 * Details of FFMA
 * (1) Preparation:
 *  In order to implement the First-Fit Memory Allocation (FFMA), we should
 * manage the free memory blocks using a list. The struct `free_area_t` is used
 * for the management of free memory blocks.
 *  First, you should get familiar with the struct `list` in list.h. Struct
 * `list` is a simple doubly linked list implementation. You should know how to
 * USE `list_init`, `list_add`(`list_add_after`), `list_add_before`, `list_del`,
 * `list_next`, `list_prev`.
 *  There's a tricky method that is to transform a general `list` struct to a
 * special struct (such as struct `page`), using the following MACROs: `le2page`
 * (in memlayout.h), (and in future labs: `le2vma` (in vmm.h), `le2proc` (in
 * proc.h), etc).
 * (2) `default_init`:
 *  You can reuse the demo `default_init` function to initialize the `free_list`
 * and set `nr_free` to 0. `free_list` is used to record the free memory blocks.
 * `nr_free` is the total number of the free memory blocks.
 * (3) `default_init_memmap`:
 *  CALL GRAPH: `kern_init` --> `pmm_init` --> `page_init` --> `init_memmap` -->
 * `pmm_manager` --> `init_memmap`.
 *  This function is used to initialize a free block (with parameter `addr_base`,
 * `page_number`). In order to initialize a free block, firstly, you should
 * initialize each page (defined in memlayout.h) in this free block. This
 * procedure includes:
 *  - Setting the bit `PG_property` of `p->flags`, which means this page is
 * valid. P.S. In function `pmm_init` (in pmm.c), the bit `PG_reserved` of
 * `p->flags` is already set.
 *  - If this page is free and is not the first page of a free block,
 * `p->property` should be set to 0.
 *  - If this page is free and is the first page of a free block, `p->property`
 * should be set to be the total number of pages in the block.
 *  - `p->ref` should be 0, because now `p` is free and has no reference.
 *  After that, We can use `p->page_link` to link this page into `free_list`.
 * (e.g.: `list_add_before(&free_list, &(p->page_link));` )
 *  Finally, we should update the sum of the free memory blocks: `nr_free += n`.
 * (4) `default_alloc_pages`:
 *  Search for the first free block (block size >= n) in the free list and reszie
 * the block found, returning the address of this block as the address required by
 * `malloc`.
 *  (4.1)
 *      So you should search the free list like this:
 *          list_entry_t le = &free_list;
 *          while((le=list_next(le)) != &free_list) {
 *          ...
 *      (4.1.1)
 *          In the while loop, get the struct `page` and check if `p->property`
 *      (recording the num of free pages in this block) >= n.
 *              struct Page *p = le2page(le, page_link);
 *              if(p->property >= n){ ...
 *      (4.1.2)
 *          If we find this `p`, it means we've found a free block with its size
 *      >= n, whose first `n` pages can be malloced. Some flag bits of this page
 *      should be set as the following: `PG_reserved = 1`, `PG_property = 0`.
 *      Then, unlink the pages from `free_list`.
 *          (4.1.2.1)
 *              If `p->property > n`, we should re-calculate number of the rest
 *          pages of this free block. (e.g.: `le2page(le,page_link))->property
 *          = p->property - n;`)
 *          (4.1.3)
 *              Re-caluclate `nr_free` (number of the the rest of all free block).
 *          (4.1.4)
 *              return `p`.
 *      (4.2)
 *          If we can not find a free block with its size >=n, then return NULL.
 * (5) `default_free_pages`:
 *  re-link the pages into the free list, and may merge small free blocks into
 * the big ones.
 *  (5.1)
 *      According to the base address of the withdrawed blocks, search the free
 *  list for its correct position (with address from low to high), and insert
 *  the pages. (May use `list_next`, `le2page`, `list_add_before`)
 *  (5.2)
 *      Reset the fields of the pages, such as `p->ref` and `p->flags` (PageProperty)
 *  (5.3)
 *      Try to merge blocks at lower or higher addresses. Notice: This should
 *  change some pages' `p->property` correctly.
 */
/*
在First Fit算法中，分配器保持空闲块列表（称为free list）。
一旦接收到存储器的分配请求，它沿着列表扫描第一个足以满足要求的块（large enough to satisfy the request）
*如果所选块明显大于请求的块。它通常被拆分，其余的将加入空闲列表作为另一个空闲块。
*/
//实验2练习1：你的代码
//您应该重写函数：`default_init`、`default_ init_memmap`、`default_alloc_pages`，`default_free_pages'。

/*
*FFMA详情
*（1）准备：
*为了实现First Fit Memory Allocation（FFMA），我们应该
 使用列表管理可用内存块。使用结构“free_area_t”用于管理空闲内存块。
*首先，您应该熟悉list.h.struct中的结构“list”。“list”是一个简单的双链表实现。你应该知道如何
 使用`list_init`、`list_add`（`list_aadd_after`）、`list_add_before`、`list_del`，`list_next`，`list_prev`。
*有一个棘手的方法是将一般的“list”结构转换为特殊结构（如结构“page”），使用以下宏：“le2page”`
（在memlayout.h中），（在未来的实验中：`le2vma`（在vmm.h中），`le2proc`（在proc.h中）等）。

*（2）`default_init`：
*您可以重用演示“default_init”函数来初始化“free_list”，并将“nr_free”设置为0。
 “free_list”用于记录空闲内存块。“nr_free”是空闲内存块的总数。

*（3）`default_init_memmap`：
*调用图形：`kern_init`-->`pmm_init`-->`page_init`-->`init_emmap`-->`pmm_manager->init_memap`。
*此函数用于初始化空闲块（具有参数“addr_base”，*`page_number`）。
 为了初始化空闲块，首先，您应该初始化这个空闲块中的每个页面（在memlayout.h中定义）。
 这程序包括：
 -设置“p->flags”的位“PG_property”，这意味着此页是有效。
  P.S.在函数“pmm_init”（在pmm.c中）中“p->flags”已设置。
 -如果该页是空闲的，并且不是空闲块的第一页，“p->property”应设置为0。
 -如果此页是空闲的并且是空闲块的第一页，`p->property`应设置为块中的总页数。
 -`p->ref`应该是0，因为现在`p`是空闲的，没有引用。
*之后，我们可以使用“p->page_link”将此页面链接到“free_list”中。
（例如：`list_add_before（&free_list，&（p->page_link））；`）
*最后，我们应该更新空闲内存块的总和：`nr_free+=n`。

*（4）`default_alloc_pages`：
*搜索空闲列表中的第一个空闲块（块大小>=n）并resize找到的块，
 返回该块的地址作为“malloc”所需的地址。
* (4.1)
    所以你应该像这样搜索free list：
        list_entry_t le=&free_list；
        while((le=list_next(le)) != &free_list) {
           ...
* (4.1.1)
    在while循环中，获取结构“page”并检查"p-property"（记录此块中的可用页面数）是否>=n。
        struct Page *p = le2page(le, page_link);
        if(p->property >= n){ ...
* (4.1.2)
    *如果我们找到这个“p”，这意味着我们找到了一个大小>=n的空闲块，它的前“n”页可以被malloced。
     此页面的某些标志位应设置如下：`PG_reserved=1`，`PG_property=0`。
    *然后，从“free_list”中取消页面链接。
* (4.1.2.1)
    如果`p->property>n`，我们应该重新计算这个空闲块的剩余页面数
     (e.g.: `le2page(le,page_link))->property= p->property - n;`)
* (4.1.3)
    重新计算“nr_free”（所有空闲块的剩余数）。
* (4.1.4)
    返回“p”。
* (4.2)
    如果找不到大小>=n的空闲块，则返回NULL。

*（5）`default_free_pages`：
*将页面重新链接到空闲列表中，并可能将小的空闲块合并到大的空闲块中。
* (5.1)
    根据释放的块的基址，在空闲列表中搜索其正确位置（地址从低到高），然后插入页面。
    （可以使用`list_next`、`le2page`、`list_add_before`）
* (5.2)
    重置页面的字段，如“p->ref”和“p->flags”（PageProperty）
* (5.3)
    尝试合并较低或较高地址的块。注意：这应该正确更改某些页面的“p->property”。

*/
free_area_t free_area;
//free_area是空闲块管理结构，free_area.free_list是空闲块链表头

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);  //对空闲内存块链表的初始化
    nr_free = 0;    //将总空闲块数目置零的操作
}
//default_init与具体物理内存分配算法无关，因此直接使用默认的函数实现即可

//对最初的一整块未被占用的物理内存空间中的每一页所对应的Page结构（用于描述这些页的状态）进行初始化
//根据每个物理页帧的情况来建立空闲页链表，且空闲页块应该是根据地址高低形成一个有序链表
//参数1：某个连续地址的空闲块的起始页。参数2：页个数
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {   //把空闲物理页对应的Page结构中的flags和引用计数ref和地址连续的空闲页的个数property清零
        assert(PageReserved(p));    //如果是被保留的页，则不能放到空闲页链表中
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;     //该成员变量只有在整个空闲块的第一个Page中才有意义,描述块中页数
    SetPageProperty(base);  //设置这页是free的，可以被分配
    nr_free += n;       //更新存储所有空闲页数量的全局变量
    list_add_before(&free_list, &(base->page_link));   //将这个空闲块插入到空闲内存块链表中（只需要将第一个Page的page_link插入即可）
}

//分配指定页数(n)的连续空闲物理空间，并且将第一页的Page结构的指针作为结果返回
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {  //查询总的空闲物理页数目是否足够进行分配
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    //从空闲链表头开始查找最小的地址
    //如果找到某一个连续内存块的大小不小于当前需要的连续内存块大小，则说明可以进行成功分配（选择第一个遇到的满足条件的空闲内存块来完成内存分配）
    while ((le = list_next(le)) != &free_list) {    //通过list_next找到下一个空闲块元素
        struct Page *p = le2page(le, page_link);    //通过le2page宏可以由链表元素获得对应的Page指针p
        if (p->property >= n) {     //通过p->property可以获得此空闲块的大小
            page = p;   
            break;
        }
    }
    if (page != NULL) {     //找到后，就要重新组织空闲块，然后把找到的page返回
        //如果该内存块的大小大于需要的内存大小，则将空闲内存块分裂成两块，
        //物理地址较小的一块分配出来进行使用（大小恰好为需要的物理内存的大小），
        //而物理地址较大的那一块重新进行初始化
        if (page->property > n) {   
            struct Page *p = page + n;  //放回空闲链表的空闲块的第一个Page
            p->property = page->property - n;   // 更新新的空闲块的大小信息
            SetPageProperty(p);
            list_add(&(page->page_link), &(p->page_link)); // 将新空闲块插入空闲块列表中（该链表中的空闲块按照物理地址从小到大排序）
        }
        list_del(&(page->page_link));   // 删除空闲链表中的原先的空闲块
        nr_free -= n;
        ClearPageProperty(page); //将分配出去的内存块的第一页标记为非空闲
    }
    return page;
}

//释放指定的某一物理页开始的若干个连续物理页
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(!PageReserved(p) && !PageProperty(p));   //检查这些物理页是否不是保留的且真的被占用了
        p->flags = 0;       //标记为空闲
        set_page_ref(p, 0);     //清空这些物理页的引用计数
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    list_entry_t *position=NULL;     //新的空闲块在空闲块链表中应当处于的位置
    list_entry_t *endp=list_next(&(base->page_link));
    p = le2page(le, page_link);
    while (le != &free_list &&  base + base->property >= p ) {
        p = le2page(le, page_link);
        le = list_next(le);
        if (base + base->property == p) {   //释放的块在前面的空闲块合并
            base->property += p->property;
            position=list_next(p);
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
        else if (p + p->property == base) { //释放的块在后面的空闲块合并
            p->property += base->property;
            position=list_next(p);
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
    le = list_next(&free_list);
    while (le != &free_list) {          //找到该空闲块在空闲链表中的位置（地址从低到高）
        p = le2page(le, page_link);
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
    // if(position==NULL){
    //     position=le;
    // }
    // nr_free += n;
    // list_add_before(position, &(base->page_link));
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);
    assert(!list_empty(&free_list));

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    free_list = free_list_store;
    nr_free = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    assert(p0 != NULL);
    assert(!PageProperty(p0));

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    assert(alloc_pages(4) == NULL);
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    assert((p1 = alloc_pages(3)) != NULL);
    assert(alloc_page() == NULL);
    assert(p0 + 2 == p1);

    p2 = p0 + 1;
    free_page(p0);
    free_pages(p1, 3);
    assert(PageProperty(p0) && p0->property == 1);
    assert(PageProperty(p1) && p1->property == 3);

    assert((p0 = alloc_page()) == p2 - 1);
    free_page(p0);
    assert((p0 = alloc_pages(2)) == p2 + 1);

    free_pages(p0, 2);
    free_page(p2);

    assert((p0 = alloc_pages(5)) != NULL);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
    assert(total == 0);
}

const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};

