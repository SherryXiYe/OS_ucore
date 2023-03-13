#ifndef __KERN_MM_SWAP_H__
#define __KERN_MM_SWAP_H__

#include <defs.h>
#include <memlayout.h>
#include <pmm.h>
#include <vmm.h>

//当一个PTE用来描述一般意义上的物理页时，显然它应该维护各种权限和映射关系，以及应该有PTE_P标记；
//但当它用来描述一个被置换出去的物理页时，它被用来维护该物理页与 swap 磁盘上扇区的映射关系(没有PTE_P标记,对应的权限交由 mm_struct 来维护)
//
/* *
 * swap_entry_t
 * --------------------------------------------
 * |         offset        |   reserved   | 0 |
 * --------------------------------------------
 *           24 bits            7 bits    1 bit
 * */
//一个页(4KB/页)对应硬盘的8个扇区(0.5KB/扇区)
/*描述被置换出去的物理页的PTE，即swap_entry_t：
     它的最低位--present位应该为0 (即 PTE_P 标记为空，表示虚实地址映射关系不存在)
     接下来的7位暂时保留，可以用作各种扩展；
     而包括原来高20位页帧号的高24位数据，恰好可以用来表示此页在硬盘上的起始扇区的位置（其从第几个扇区开始）。
     另外，为了在页表项中区别 0 和 swap 分区的映射，将 swap 分区的一个 page 空出来不用，
          也就是说一个高24位不为0，而最低位为0的PTE表示了一个放在硬盘上的页的起始扇区号（见swap.h中对swap_entry_t的描述）
*/


#define MAX_SWAP_OFFSET_LIMIT                   (1 << 24)

extern size_t max_swap_offset;

/* *
 * swap_offset - takes a swap_entry (saved in pte), and returns
 * the corresponding offset in swap mem_map.
 * */
#define swap_offset(entry) ({                                       \
               size_t __offset = (entry >> 8);                        \
               if (!(__offset > 0 && __offset < max_swap_offset)) {    \
                    panic("invalid swap_entry_t = %08x.\n", entry);    \
               }                                                    \
               __offset;                                            \
          })

//实现页替换算法类框架struct swap_manager
struct swap_manager
{
     const char *name;
     /* swap管理器的全局初始化 Global initialization for the swap manager */
     int (*init)            (void);
     /*初始化mm_struct中的priv数据 Initialize the priv data inside mm_struct */
     int (*init_mm)         (struct mm_struct *mm);
     /*发生时钟中断时调用。结合定时产生的中断，可以实现一种积极的换页策略 Called when tick interrupt occured */
     int (*tick_event)      (struct mm_struct *mm);
     /* 将一个可交换页面映射到mm_struct之中，用于记录页访问情况相关属性 Called when map a swappable page into the mm_struct */
     int (*map_swappable)   (struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in);
     /* When a page is marked as shared, this routine is called to
      * delete the addr entry from the swap manager 
      当页面标记为共享时，调用此例程以从交换管理器中删除addr条目
      */
     int (*set_unswappable) (struct mm_struct *mm, uintptr_t addr);
     /*挑选需要换出的页 Try to swap out a page, return then victim */
     int (*swap_out_victim) (struct mm_struct *mm, struct Page **ptr_page, int in_tick);
     /* check the page relpacement algorithm */
     int (*check_swap)(void);     
};

extern volatile int swap_init_ok;
int swap_init(void);
int swap_init_mm(struct mm_struct *mm);
int swap_tick_event(struct mm_struct *mm);
int swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in);
int swap_set_unswappable(struct mm_struct *mm, uintptr_t addr);
int swap_out(struct mm_struct *mm, int n, int in_tick);
int swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result);

//#define MEMBER_OFFSET(m,t) ((int)(&((t *)0)->m))
//#define FROM_MEMBER(m,t,a) ((t *)((char *)(a) - MEMBER_OFFSET(m,t)))

#endif
