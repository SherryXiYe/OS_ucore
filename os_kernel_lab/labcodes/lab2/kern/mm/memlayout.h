#ifndef __KERN_MM_MEMLAYOUT_H__
#define __KERN_MM_MEMLAYOUT_H__

/* This file contains the definitions for memory management in our OS. */

/* global segment number */
#define SEG_KTEXT   1
#define SEG_KDATA   2
#define SEG_UTEXT   3
#define SEG_UDATA   4
#define SEG_TSS     5

/* global descrptor numbers */
#define GD_KTEXT    ((SEG_KTEXT) << 3)      // kernel text
#define GD_KDATA    ((SEG_KDATA) << 3)      // kernel data
#define GD_UTEXT    ((SEG_UTEXT) << 3)      // user text
#define GD_UDATA    ((SEG_UDATA) << 3)      // user data
#define GD_TSS      ((SEG_TSS) << 3)        // task segment selector

#define DPL_KERNEL  (0)
#define DPL_USER    (3)

#define KERNEL_CS   ((GD_KTEXT) | DPL_KERNEL)
#define KERNEL_DS   ((GD_KDATA) | DPL_KERNEL)
#define USER_CS     ((GD_UTEXT) | DPL_USER)
#define USER_DS     ((GD_UDATA) | DPL_USER)

/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *
 *     4G ------------------> +---------------------------------+
 *                            |                                 |
 *                            |         Empty Memory (*)        |
 *                            |                                 |
 *                            +---------------------------------+ 0xFB000000
 *                            |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT -----------------> +---------------------------------+ 0xFAC00000
 *                            |        Invalid Memory (*)       | --/--
 *     KERNTOP -------------> +---------------------------------+ 0xF8000000
 *                            |                                 |
 *                            |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                            |                                 |
 *     KERNBASE ------------> +---------------------------------+ 0xC0000000
 *                            |                                 |
 *                            |                                 |
 *                            |                                 |
 *                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 *
 * */

/* All physical memory mapped at this address */
#define KERNBASE            0xC0000000
#define KMEMSIZE            0x38000000                  // the maximum amount of physical memory
#define KERNTOP             (KERNBASE + KMEMSIZE)

/* *
 * Virtual page table. Entry PDX[VPT] in the PD (Page Directory) contains
 * a pointer to the page directory itself, thereby turning the PD into a page
 * table, which maps all the PTEs (Page Table Entry) containing the page mappings
 * for the entire virtual address space into that 4 Meg region starting at VPT.
 * */
#define VPT                 0xFAC00000

#define KSTACKPAGE          2                           // # of pages in kernel stack
#define KSTACKSIZE          (KSTACKPAGE * PGSIZE)       // sizeof kernel stack

#ifndef __ASSEMBLER__

#include <defs.h>
#include <atomic.h>
#include <list.h>

//pde_t全称为 page directory entry，也就是一级页表的表项。
//pte_t全称为 page table entry，表示二级页表的表项。
//uintptr_t表示为线性地址，由于段式管理只做直接映射，所以它也是逻辑地址。
//实际上，它们其实都是unsigned int类型。在此做区分，是为了分清概念
typedef uintptr_t pte_t;
typedef uintptr_t pde_t;

// some constants for bios interrupt 15h AX = 0xE820
#define E820MAX             20      // number of entries in E820MAP
#define E820_ARM            1       // address range memory
#define E820_ARR            2       // address range reserved

//e820映射结构
struct e820map {
    int nr_map;
    struct {
        uint64_t addr;      //内存块基地址
        uint64_t size;      //内存大小
        uint32_t type;      //内存类型
    } __attribute__((packed)) map[E820MAX];
};

/* *
 * struct Page - Page descriptor structures. Each Page describes one
 * physical page. In kern/mm/pmm.h, you can find lots of useful functions
 * that convert Page to other data types, such as phyical address.
 * */
struct Page {
    int ref;                        //映射此物理页的虚拟页个数。 ref表示这页被页表的引用记数，如果这个页被页表引用了，即在某页表中有一个页表项设置了一个虚拟页到这个Page管理的物理页的映射关系，就会把Page的ref加一；反之，若页表项取消，即映射关系解除，就会把Page的ref减一。page frame's reference counter
    uint32_t flags;                 //此物理页的状态标记  array of flags that describe the status of the page frame
    unsigned int property;          //记录某连续内存空闲块的大小（即地址连续的空闲页的个数） the num of free block, used in first fit pm manager
    list_entry_t page_link;         //双向链接各个Page结构的page_link双向链表 free list link
};
//用到property成员变量的Page,是这个连续内存空闲块地址最小的一页（即头一页,Head Page）。连续内存空闲块利用这个页的成员变量property来记录在此块内的空闲页的个数。
//page_link是便于把多个连续内存空闲块链接在一起的双向链表指针。用到此成员变量的Page是这个连续内存空闲块地址最小的一页（即头一页,Head Page）。连续内存空闲块利用这个页的成员变量page_link来链接比它地址小和大的其他连续内存空闲块。

/* Flags describing the status of a page frame */
//PG_reserved(bit 0)表示此页是否被保留（reserved），
//如果是被保留的页，则bit 0会设置为1，且不能放到空闲页链表中，即这样的页不是空闲页，不能动态分配与释放。比如目前内核代码占用的空间就属于这样“被保留”的页。
//在本实验中，PG_property(bit 1)表示此页是否是free的，如果设置为1，表示这页是free的，可以被分配；如果设置为0，表示这页已经被分配出去了，不能被再二次分配。
#define PG_reserved                 0       // if this bit=1: the Page is reserved for kernel, cannot be used in alloc/free_pages; otherwise, this bit=0 
#define PG_property                 1       // if this bit=1: the Page is the head page of a free memory block(contains some continuous_addrress pages), and can be used in alloc_pages; if this bit=0: if the Page is the the head page of a free memory block, then this Page and the memory block is alloced. Or this Page isn't the head page.

#define SetPageReserved(page)       set_bit(PG_reserved, &((page)->flags))
#define ClearPageReserved(page)     clear_bit(PG_reserved, &((page)->flags))
#define PageReserved(page)          test_bit(PG_reserved, &((page)->flags))
#define SetPageProperty(page)       set_bit(PG_property, &((page)->flags))
#define ClearPageProperty(page)     clear_bit(PG_property, &((page)->flags))
#define PageProperty(page)          test_bit(PG_property, &((page)->flags))

// convert list entry to page
//获取链表节点所在的基于Page数据结构的变量
//to_struct宏在lab2/libs/defs.h
#define le2page(le, member)                 \
    to_struct((le), struct Page, member)
//其中le,是指向数据结构XXX中list_entry_t成员变量的指针，也就是存储在双向循环链表中的节点地址值
//member则是XXX数据类型中包含的链表节点的成员变量（不是其地址）

/* free_area_t - maintains a doubly linked list to record free (unused) pages */
//空闲内存块列表的头指针定义
typedef struct {
    list_entry_t free_list;         //空闲块双向链表的头 the list header
    unsigned int nr_free;           //空闲块的总数（以页为单位）。记录当前空闲页的个数 # of free pages in this free list
} free_area_t;

#endif /* !__ASSEMBLER__ */

#endif /* !__KERN_MM_MEMLAYOUT_H__ */

