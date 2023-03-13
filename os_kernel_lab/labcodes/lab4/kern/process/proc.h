#ifndef __KERN_PROCESS_PROC_H__
#define __KERN_PROCESS_PROC_H__

#include <defs.h>
#include <list.h>
#include <trap.h>
#include <memlayout.h>


// process's state in his life cycle
enum proc_state {
    PROC_UNINIT = 0,  // uninitialized
    PROC_SLEEPING,    // sleeping
    PROC_RUNNABLE,    // runnable(maybe running)
    PROC_ZOMBIE,      // almost dead, and wait parent proc to reclaim his resource
};

// Saved registers for kernel context switches. 已保存内核上下文开关的寄存器。
// Don't need to save all the %fs etc. segment registers, 不需要保存所有的%fs等段寄存器，
// because they are constant across kernel contexts.  因为它们在内核上下文中是恒定的。
// Save all the regular registers so we don't need to care  保存所有常规寄存器，这样我们就不必关心调用方保存的寄存器，而不必关心返回寄存器%eax。（不保存%eax只是简化了切换代码。）
// which are caller save, but not the return register %eax.
// (Not saving %eax just simplifies the switching code.)
// The layout of context must match code in switch.S.   上下文的布局必须与switch.S中的代码匹配。
//使用 context 保存寄存器的目的就在于在内核态中能够进行上下文之间的切换。
//实际利用context进行上下文切换的函数是在kern/process/switch.S中定义switch_to。
struct context {
    uint32_t eip;
    uint32_t esp;
    uint32_t ebx;
    uint32_t ecx;
    uint32_t edx;
    uint32_t esi;
    uint32_t edi;
    uint32_t ebp;
};

#define PROC_NAME_LEN               15
#define MAX_PROCESS                 4096
#define MAX_PID                     (MAX_PROCESS * 2)

extern list_entry_t proc_list;

//进程管理信息
struct proc_struct {
    enum proc_state state;                      // 进程所处的状态 Process state
    int pid;                                    // Process ID
    int runs;                                   // the running times of Proces
    uintptr_t kstack;                           // kstack记录了分配给该进程/线程的内核栈的位置 Process kernel stack
    volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
    struct proc_struct *parent;                 // 用户进程的父进程（创建它的进程） the parent process  在所有进程中，只有一个进程没有父进程，就是内核创建的第一个内核线程idleproc。
    struct mm_struct *mm;                       // Process's memory management field  其中，内核线程的proc_struct的成员变量*mm=0
    struct context context;                     // 进程的上下文，(使用context保存寄存器)用于进程切换（参见switch.S）Switch here to run process 使用context保存寄存器的目的就在于在内核态中能够进行上下文之间的切换。实际利用context进行上下文切换的函数是在kern/process/switch.S中定义switch_to。
    struct trapframe *tf;                       // 中断帧的指针，总是指向内核栈的某个位置 Trap frame for current interrupt
    uintptr_t cr3;                              // 保存页目录表的首地址 CR3 register: the base addr of Page Directroy Table(PDT)  由于内核线程的*mm=NULL，所以在proc_struct数据结构中需要有一个代替pgdir项来记录页表起始地址，这就是proc_struct数据结构中的cr3成员变量
    uint32_t flags;                             // Process flag
    char name[PROC_NAME_LEN + 1];               // Process name
    list_entry_t list_link;                     // Process link list 
    list_entry_t hash_link;                     // Process hash list
};
//在实际OS中，内核线程常驻内存，不需要考虑swap page问题，在lab5中涉及到了用户进程，才考虑进程用户内存空间的swap page问题，mm才会发挥作用。所以在lab4中mm对于内核线程就没有用了，这样内核线程的proc_struct的成员变量*mm=0是合理的。
/*中断帧的指针tf，总是指向内核栈的某个位置：当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。
当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。
uCore内核允许嵌套中断。因此为了保证嵌套中断发生时tf 总是能够指向当前的trapframe，uCore在内核栈上维护了tf的链，可以参考trap.c::trap函数做进一步的了解。
*/
/*  cr3的目的就是进程切换的时候方便直接使用lcr3实现页表切换，避免每次都根据mm来计算 cr3
当某个进程是一个普通用户态进程的时候，PCB 中的 cr3 就是 mm 中页表（pgdir）的物理地址（应该就是物理地址吧，pmm.c中boot_cr3就是物理地址）；
而当它是内核线程的时候，cr3 等于boot_cr3。而boot_cr3指向了uCore启动时建立好的内核虚拟空间的页目录表首地址。
*/
/* 每个线程都有一个内核栈，并且位于内核地址空间的不同位置。kstack记录了分配给该进程/线程的内核栈的位置。
对于内核线程，该栈就是运行时的程序使用的栈；而对于普通进程，该栈是发生特权级改变的时候使保存被打断的硬件信息用的栈。
uCore在创建进程时分配了 2 个连续的物理页（参见memlayout.h中KSTACKSIZE的定义）作为内核栈的空间。
kstack的主要作用：
1. 首先，当内核准备从一个进程切换到另一个的时候，需要根据kstack的值正确的设置好 tss，以便在进程切换以后再发生中断时能够使用正确的栈。 （tss保存有当前程序的内核栈地址，即包括内核态的ss和esp的值。可以回顾一下在实验一中讲述的 tss 在中断处理过程中的作用）
2. 其次，内核栈位于内核地址空间，并且是不共享的（每个线程都拥有自己的内核栈），因此不受到 mm 的管理，当进程退出的时候，内核能够根据 kstack 的值快速定位栈的位置并进行回收。
*/
#define le2proc(le, member)         \
    to_struct((le), struct proc_struct, member)

extern struct proc_struct *idleproc, *initproc, *current;   
//current：当前占用CPU且处于“运行”状态进程控制块指针。通常这个变量是只读的，只有在进程切换的时候才进行修改，并且整个切换和修改过程需要保证操作的原子性，目前至少需要屏蔽中断。可以参考 switch_to 的实现。
//initproc：lab4中，指向一个内核线程。lab4以后，此指针将指向第一个用户态进程。


void proc_init(void);
void proc_run(struct proc_struct *proc);
int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);

char *set_proc_name(struct proc_struct *proc, const char *name);
char *get_proc_name(struct proc_struct *proc);
void cpu_idle(void) __attribute__((noreturn));

struct proc_struct *find_proc(int pid);
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
int do_exit(int error_code);

#endif /* !__KERN_PROCESS_PROC_H__ */

