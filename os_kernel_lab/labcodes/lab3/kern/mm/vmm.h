#ifndef __KERN_MM_VMM_H__
#define __KERN_MM_VMM_H__

#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <sync.h>

//pre define
struct mm_struct;

//连续的虚拟内存空间[vm_start, vm_end) the virtual continuous memory area(vma), [vm_start, vm_end), 
// addr belong to a vma means  vma.vm_start<= addr <vma.vm_end 
//描述应用程序对虚拟内存“需求”的数据结构
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT  指向数据结构mm_struct,这个数据结构通过双向链表链接了所有属于同一页目录表的虚拟内存空间
    uintptr_t vm_start;      //一个连续地址的虚拟内存空间的起始位置(PGSIZE 对齐) start addr of vma      
    uintptr_t vm_end;        //一个连续地址的虚拟内存空间的结束位置(PGSIZE 对齐) end addr of vma, not include the vm_end itself
    uint32_t vm_flags;       //表示了这个虚拟内存空间的属性 flags of vma
    list_entry_t list_link;  //双向链表，按照从小到大的顺序把一系列用vma_struct表示的虚拟内存空间链接起来，并且还要求这些链起来的vma_struct应该是不相交的，即vma之间的地址空间无交集 linear list link which sorted by start addr of vma
};

//获取链表节点所在的基于vma_struct数据结构的变量
//to_struct宏在lab3/libs/defs.h
#define le2vma(le, member)                  \
    to_struct((le), struct vma_struct, member)

//vm_flags,虚拟内存空间的属性
#define VM_READ                 0x00000001          //只读
#define VM_WRITE                0x00000002          //可读写
#define VM_EXEC                 0x00000004          //可执行

// the control struct for a set of vma using the same PDT
//使用相同PDT的一组vma的控制结构
struct mm_struct {
    list_entry_t mmap_list;        //双向链表头，链接了所有属于同一页目录表的虚拟内存空间 linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; //指向当前正在使用的虚拟内存空间。通过局部性原理，提高查询速度 current accessed vma, used for speed purpose
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 //记录mmap_list里面链接的vma_struct的个数 the count of these vma
    void *sm_priv;                 //sm_priv指向用来链接记录页访问情况的链表头，这建立了mm_struct和后续要讲到的swap_manager之间的联系 the private data for swap manager
};
//在lab3中的swap_fifo.c中，sm_priv指向了将Page结构按页的第一次访问时间进行排序的双向链表的链表头pra_list_head

struct vma_struct *find_vma(struct mm_struct *mm, uintptr_t addr);  //查询vma
//查找在mm变量中的mmap_list（双向链表头）对应的双向链表中的某个包含此addr的vma
struct vma_struct *vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags);     //创建vma
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma);      //插入一个vma
//把一个vma变量按照其空间位置[vma->vm_start,vma->vm_end]从小到大的顺序插入到所属的mm变量中的mmap_list双向链表中

struct mm_struct *mm_create(void);      //创建mm
void mm_destroy(struct mm_struct *mm);      //删除mm。释放包括用kmalloc分配的空间，以及mmap_list中的vma

void vmm_init(void);

int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr);

extern volatile unsigned int pgfault_num;
extern struct mm_struct *check_mm_struct;
#endif /* !__KERN_MM_VMM_H__ */

