#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_fifo.h>
#include <list.h>

/* [wikipedia]The simplest Page Replacement Algorithm(PRA) is a FIFO algorithm. The first-in, first-out
 * page replacement algorithm is a low-overhead algorithm that requires little book-keeping on
 * the part of the operating system. The idea is obvious from the name - the operating system
 * keeps track of all the pages in memory in a queue, with the most recent arrival at the back,
 * and the earliest arrival in front. When a page needs to be replaced, the page at the front
 * of the queue (the oldest page) is selected. While FIFO is cheap and intuitive, it performs
 * poorly in practical application. Thus, it is rarely used in its unmodified form. This
 * algorithm experiences Belady's anomaly.
 *
 * Details of FIFO PRA
 * (1) Prepare: In order to implement FIFO PRA, we should manage all swappable pages, so we can
 *              link these pages into pra_list_head according the time order. At first you should
 *              be familiar to the struct list in list.h. struct list is a simple doubly linked list
 *              implementation. You should know howto USE: list_init, list_add(list_add_after),
 *              list_add_before, list_del, list_next, list_prev. Another tricky method is to transform
 *              a general list struct to a special struct (such as struct page). You can find some MACRO:
 *              le2page (in memlayout.h), (in future labs: le2vma (in vmm.h), le2proc (in proc.h),etc.
 * 最简单的页面替换算法（PRA）是FIFO算法。先进先出页面替换算法是一种低开销的算法，操作系统需要很少的book-keeping。
 * 这个想法从名字就很明显了——操作系统会跟踪队列中内存中的所有页面，最新的页面在后面，最早的页面在前面。
 * 当需要替换页面时，将选择队列前面的页面（最旧的页面）。虽然先进先出（FIFO）价格便宜且直观，但在实际应用中表现不佳。因此，它很少以未修改的形式使用。这种算法经历了Belady的异常。
    FIFO PRA详情
    （1） 准备：为了实现FIFO PRA，我们应该管理所有可交换页面，这样我们就可以根据时间顺序将这些页面链接到PRA_list_head中。
        首先，您应该熟悉list.h中的struct list。struct list是一个简单的双链接列表实现。
        您应该知道如何使用：list_init、list_add（list_add_after）、list_add_before、list_del、list_next和list_prev。
        另一个棘手的方法是将常规列表结构转换为特殊结构（如struct page）。您可以找到一些MACRO:le2page（在memlayout.h中），（在未来的实验中：le2vma（在vmm.h中），le2proc（在proc.h中）等。
 */

list_entry_t pra_list_head;         //按页的第一次访问时间进行排序的双向链表的链表头
/*
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 *      初始化链表头pra_list_head，并让mm->sm_priv指向pra_list-head的地址。
        现在，通过内存控制结构mm_struct，我们可以访问FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
                        将一个可交换页面映射到mm_struct之中，用于记录页访问情况相关属性
                        根据FIFO PRA，我们应该在pra_list_head 队列后面链接最近到达的页面
 */
//用于将指定的物理页面设置为可被换出
//将当前的物理页面插入到FIFO算法中维护的可被交换出去的物理页面链表中的末尾，
//从而保证该链表中越接近链表头的物理页面在内存中的驻留时间越长
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv; // 找到链表入口
    list_entry_t *entry=&(page->pra_page_link); // 找到当前物理页用于组织成链表的list_entry_t
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
        //连接pra_list_head队列后面的最新到达页面。
    list_add_before(head, entry); // 将当前指定的物理页插入到链表的末尾
    return 0;
}
/*
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 *                             根据FIFO PRA，我们应该取消pra_list_head queue前面最早到达页面的链接，然后将*ptr_page的值分配给该页面的地址。
 */
/*调用swap_in函数的时候，会进一步调用alloc_page函数进行分配物理页，
一旦没有足够的物理页，则会使用swap_out函数将当前物理空间的某一页换出到外存，
该函数会进一步调用sm（swap manager）中封装的swap_out_victim函数来选择需要换出的物理页，
该函数是一个函数指针进行调用的，具体对应到了_fifo_swap_out_victim函数（因为在本练习中使用了FIFO替换算法）
*/
/*在FIFO算法中，按照物理页面换入到内存中的顺序建立了一个链表，
因此链表头处便指向了最早进入的物理页面，也就在在本算法中需要被换出的页面，
因此只需要将链表头的物理页面取出，然后删掉对应的链表项即可
*/
//第二个参数ptr_page为即将被换出的物理页面的指针
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;    // 找到链表的入口
         assert(head != NULL);
     assert(in_tick==0);
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
            //取消pra_list_head 队列前面的最早到达页面的连接
     //(2)  assign the value of *ptr_page to the addr of this page
            //将*ptr_page的值分配给此页的地址
    list_entry_t *le = list_next(head); // 取出链表头，即最早进入的物理页面
    assert(le != head); // 确保链表非空
    struct Page *page = le2page(le, pra_page_link); // 找到对应的物理页面的Page结构
    list_del(le); // 从链表上删除取出的即将被换出的物理页面
    *ptr_page = page;
     return 0;
}

static int
_fifo_check_swap(void) {
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}


static int
_fifo_init(void)
{
    return 0;
}

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_fifo =
{
     .name            = "fifo swap manager",
     .init            = &_fifo_init,
     .init_mm         = &_fifo_init_mm,
     .tick_event      = &_fifo_tick_event,
     .map_swappable   = &_fifo_map_swappable,
     .set_unswappable = &_fifo_set_unswappable,
     .swap_out_victim = &_fifo_swap_out_victim,
     .check_swap      = &_fifo_check_swap,
};
