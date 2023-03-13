#include <proc.h>
#include <kmalloc.h>
#include <string.h>
#include <sync.h>
#include <pmm.h>
#include <error.h>
#include <sched.h>
#include <elf.h>
#include <vmm.h>
#include <trap.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/* ------------- process/thread mechanism design&implementation -------------
(an simplified Linux process/thread mechanism )
introduction:
  ucore implements a simple process/thread mechanism. process contains the independent memory sapce, at least one threads
for execution, the kernel data(for management), processor state (for context switch), files(in lab6), etc. ucore needs to
manage all these details efficiently. In ucore, a thread is just a special kind of process(share process's memory).
------------------------------
process state       :     meaning               -- reason
    PROC_UNINIT     :   uninitialized           -- alloc_proc
    PROC_SLEEPING   :   sleeping                -- try_free_pages, do_wait, do_sleep
    PROC_RUNNABLE   :   runnable(maybe running) -- proc_init, wakeup_proc, 
    PROC_ZOMBIE     :   almost dead             -- do_exit

-----------------------------
process state changing:
                                            
  alloc_proc                                 RUNNING
      +                                   +--<----<--+
      +                                   + proc_run +
      V                                   +-->---->--+ 
PROC_UNINIT -- proc_init/wakeup_proc --> PROC_RUNNABLE -- try_free_pages/do_wait/do_sleep --> PROC_SLEEPING --
                                           A      +                                                           +
                                           |      +--- do_exit --> PROC_ZOMBIE                                +
                                           +                                                                  + 
                                           -----------------------wakeup_proc----------------------------------
-----------------------------
process relations
parent:           proc->parent  (proc is children)
children:         proc->cptr    (proc is parent)
older sibling:    proc->optr    (proc is younger sibling)
younger sibling:  proc->yptr    (proc is older sibling)
-----------------------------
related syscall for process:
SYS_exit        : process exit,                           -->do_exit
SYS_fork        : create child process, dup mm            -->do_fork-->wakeup_proc
SYS_wait        : wait process                            -->do_wait
SYS_exec        : after fork, process execute a program   -->load a program and refresh the mm
SYS_clone       : create child thread                     -->do_fork-->wakeup_proc
SYS_yield       : process flag itself need resecheduling, -- proc->need_sched=1, then scheduler will rescheule this process
SYS_sleep       : process sleep                           -->do_sleep 
SYS_kill        : kill process                            -->do_kill-->proc->flags |= PF_EXITING
                                                                 -->wakeup_proc-->do_wait-->do_exit   
SYS_getpid      : get the process's pid

*/

// the process set's list
// 所有进程控制块的双向线性链表，proc_struct中的成员变量list_link将链接入这个链表中。
list_entry_t proc_list;     

#define HASH_SHIFT          10
#define HASH_LIST_SIZE      (1 << HASH_SHIFT)
#define pid_hashfn(x)       (hash32(x, HASH_SHIFT))     // libs/hash.c中

// has list for process set based on pid
//所有进程控制块的哈希表，proc_struct中的成员变量hash_link将基于pid(process id)链接入这个哈希表中。
static list_entry_t hash_list[HASH_LIST_SIZE];

// idle proc
struct proc_struct *idleproc = NULL;
// init proc
struct proc_struct *initproc = NULL;
// current proc
struct proc_struct *current = NULL;

static int nr_process = 0;

void kernel_thread_entry(void);
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
//通过kmalloc函数获得proc_struct结构的一块内存块——作为进程控制块。并把proc进行初步初始化（即把proc_struct中的各个成员变量清零）。但有些成员变量设置了特殊的值
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
    //LAB4:EXERCISE1 YOUR CODE
    /*
     * below fields in proc_struct need to be initialized
     *       enum proc_state state;                      // Process state
     *       int pid;                                    // Process ID
     *       int runs;                                   // the running times of Proces
     *       uintptr_t kstack;                           // Process kernel stack
     *       volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
     *       struct proc_struct *parent;                 // the parent process
     *       struct mm_struct *mm;                       // Process's memory management field
     *       struct context context;                     // Switch here to run process
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;      //设置进程的状态为“初始”态。这表示进程已经 “出生”了，正在获取资源茁壮成长中
        proc->pid = -1;                 //设置进程pid的未初始化值。
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
        proc->tf = NULL;
        proc->cr3 = boot_cr3;   //使用内核页目录表的基址。由于该内核线程在内核中运行，故采用为uCore内核已经建立的页表，即设置为在uCore内核页表的起始地址boot_cr3。后续实验中可进一步看出所有内核线程的内核虚地址空间（也包括物理地址空间）是相同的。
        proc->flags = 0;
        memset(proc->name, 0, PROC_NAME_LEN);
    }
    return proc;
}

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
    memset(proc->name, 0, sizeof(proc->name));
    return memcpy(proc->name, name, PROC_NAME_LEN);
}

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
    return memcpy(name, proc->name, PROC_NAME_LEN);
}

// get_pid - alloc a unique pid for process 为进程分配唯一的pid
static int
get_pid(void) {
    //定义了MAX_PID=2*MAX_PROCESS，意味着ID的总数目是大于PROCESS的总数目的,因此不会出现部分PROCESS无ID可分的情况
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
    static int next_safe = MAX_PID, last_pid = MAX_PID;
     //++last_pid>-MAX_PID,说明pid分到尽头，需要从头再找
    if (++ last_pid >= MAX_PID) {
        last_pid = 1;
        goto inside;
    }
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        //le等于线程的链表头
        le = list;
        //循环扫描每一个当前进程：当一个现有的进程号和last_pid相等时，则将last_pid+1；
        //当现有的进程号大于last_pid时，这意味着在已经扫描的进程中
          //[last_pid,min(next_safe, proc->pid)] 这段进程号尚未被占用，继续扫描。
        while ((le = list_next(le)) != list) {  //遍历进程控制块双向链表
            proc = le2proc(le, list_link);
            //如果proc的pid与last_pid相等，则将last_pid加1
            //当然，如果last_pid>=MAX_PID,then 将其变为1
            //确保了没有一个进程的pid与last_pid重合
            if (proc->pid == last_pid) {
                if (++ last_pid >= next_safe) {
                    if (last_pid >= MAX_PID) {
                        last_pid = 1;
                    }
                    next_safe = MAX_PID;
                    goto repeat;
                }
            }
            //last_pid<pid<next_safe，确保最后能够找到这么一个满足条件的区间，获得合法的pid；
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
}

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
// proc_run函数: 保存当前进程current的执行现场（进程上下文），恢复新进程(proc)的执行现场，完成进程切换。
// 在lab4中，只有两个内核线程，且idleproc要让出CPU给initproc执行。schedule函数到的待切换的内核进程proc其实就是initproc。
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        local_intr_save(intr_flag);
        {
            //1. 让current指向next内核线程
            current = proc;     
            //2. 设置任务状态段ts中特权态0下的栈顶指针esp0为next内核线程(initproc)的内核栈的栈顶，即next->kstack + KSTACKSIZE ；
            load_esp0(next->kstack + KSTACKSIZE);   
            //3. 设置CR3寄存器的值为next内核线程(initproc)的页目录表起始地址next->cr3，这实际上是完成进程间的页表切换.
            // lab4中，由于idleproc和initproc都是共用一个内核页表boot_cr3，所以此时第三步其实没用
            lcr3(next->cr3);
            //4. 由switch_to函数完成具体的两个线程的执行现场切换，即切换各个寄存器，当switch_to函数执行完“ret”指令后，就切换到initproc执行了。
            switch_to(&(prev->context), &(next->context));  //switch.S中
        }
        local_intr_restore(intr_flag);
    }
}
/* 在第二步设置任务状态段ts中特权态0下的栈顶指针esp0的目的是: 建立好内核线程 或 
    将来用户线程在执行特权态切换时（从特权态0<-->特权态3，或从特权态3<-->特权态3）,能够正确定位处于特权态0时进程的内核栈的栈顶，而这个栈顶其实放了一个trapframe结构的内存空间。
    
    如果是在特权态3发生了中断/异常/系统调用，则CPU会从特权态3-->特权态0，且CPU从此栈顶（当前被打断进程的内核栈顶）开始压栈来保存被中断/异常/系统调用打断的用户态执行现场；
    如果是在特权态0发生了中断/异常/系统调用，则CPU会从从当前内核栈指针esp所指的位置开始压栈保存被中断/异常/系统调用打断的内核态执行现场。
    
    当执行完对中断/异常/系统调用打断的处理后，最后会执行一个“iret”指令。
    在执行此指令之前，CPU的当前栈指针esp一定指向上次产生中断/异常/系统调用时CPU保存的被打断的指令地址CS和EIP，
    “iret”指令会根据ESP所指的保存的指令地址CS和EIP恢复到上次被打断的地方继续执行。
*/



// forkret -- the first kernel entry point of a new thread/process 新线程/进程的第一个内核入口点
// NOTE: the addr of forkret is setted in copy_thread function  orkret的地址在copy_thread函数中设置。
//       after switch_to, the current proc will execute here. 在switch_to之后，当前proc将在这里执行。
// 当执行switch_to函数并返回后,initproc将执行其实际上的执行入口地址forkret。
/* lab4中，tf变量的作用在于在构造出了新的线程的时候，如果要将控制权交给这个线程，是使用中断返回的方式进行的，
 因此需要构造出一个伪造的中断返回现场，使得可以正确地将控制权转交给新的线程。
*/
static void
forkret(void) {
    forkrets(current->tf);  //forkret会调用位于kern/trap/trapentry.S中的forkrets函数执行。
}

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
}

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
            struct proc_struct *proc = le2proc(le, hash_link);
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
}

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
/*kernel_thread函数采用了局部变量tf来放置保存内核线程的临时中断帧，并把中断帧的指针传递给do_fork函数，
而do_fork函数会调用copy_thread函数来在新创建的进程内核栈上（顶部）专门给进程的中断帧分配一块空间。
*/
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
    struct trapframe tf;            //kernel_thread函数采用了局部变量tf来放置保存内核线程的临时中断帧

    //构造新进程的中断帧

    memset(&tf, 0, sizeof(struct trapframe));   //给tf进行清零初始化
    //设置中断帧的代码段（tf.tf_cs）和数据段(tf.tf_ds/tf_es/tf_ss)为内核空间的段（KERNEL_CS/KERNEL_DS）
    //这实际上也说明了initproc内核线程在内核空间中执行
    tf.tf_cs = KERNEL_CS;   
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
    tf.tf_regs.reg_ebx = (uint32_t)fn;
    tf.tf_regs.reg_edx = (uint32_t)arg;
    //tf.tf_eip指出了initproc内核线程开始执行的位置：kernel_thread_entry（位于kern/process/entry.S中）
    tf.tf_eip = (uint32_t)kernel_thread_entry;
    //kernel_thread函数通过调用do_fork函数最终完成了内核线程的创建工作。do_fork成功，则返回创建的内核线程的pid
    return do_fork(clone_flags | CLONE_VM, 0, &tf);     //把中断帧的指针传递给do_fork函数
    //若成功，则返回创建的内核线程的pid
    //CLONE_VM            0x00000100  // set if VM shared between processes
}

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
// 分配大小为KSTACKPAGE的页面(2个页大小)作为进程的内核栈
static int
setup_kstack(struct proc_struct *proc) {
    struct Page *page = alloc_pages(KSTACKPAGE);
    if (page != NULL) {
        proc->kstack = (uintptr_t)page2kva(page);
        return 0;
    }
    return -E_NO_MEM;
}

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
}

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
// process“proc”根据clone_flags复制或共享进程“current”的mm。如果clone_flags&clone_VM为真，则为“共享”；否则为“复制”
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
    //由于目前在lab4中只能创建内核线程, 而proc->mm描述的是进程用户态空间的情况，
    //所以目前mm还用不上。copy_mm函数目前只是把current->mm设置为NULL
    assert(current->mm == NULL);
    /* do nothing in this project */
    return 0;
}

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
// 在进程的内核堆栈顶部设置trapframe，并设置内核入口点和进程堆栈
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
    //在内核堆栈的顶部设置中断帧大小的一块栈空间
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
    *(proc->tf) = *tf;  //拷贝在kernel_thread函数建立的临时中断帧的初始值
    proc->tf->tf_regs.reg_eax = 0;
    //设置子进程/线程执行完do_fork后的返回值
    proc->tf->tf_esp = esp;  //设置中断帧中的栈指针esp。do_fork传入的参数stack=0，因此表示fork一个内核线程。
    proc->tf->tf_eflags |= FL_IF;   //使能中断。FL_IF标志：表示此内核线程在执行过程中，能响应中断，打断当前的执行。
    
    //执行到这步后，此进程的中断帧就建立好了

    //最后就是设置initproc的进程上下文（process context，也称执行现场）
    //只有设置好执行现场后，一旦uCore调度器选择了initproc执行，就需要根据initproc->context中保存的执行现场来恢复initproc的执行。
    proc->context.eip = (uintptr_t)forkret;     //设置上次停止执行时的下一条指令地址context.eip
    proc->context.esp = (uintptr_t)(proc->tf);  //上次停止执行时的堆栈地址context.esp
    /*此处由于initproc还没有执行过，所以这其实就是initproc实际执行的第一条指令地址和堆栈指针。
      栈顶指针context.esp：由于initproc的中断帧占用了实际给initproc分配的栈空间的顶部，所以initproc就只能把栈顶指针context.esp设置在initproc的中断帧的起始位置。
      context.eip：initproc实际开始执行的地方在forkret函数（主要完成do_fork函数返回的处理工作）处。
    */
}

/* do_fork -     parent process for a new child process 新子进程的父进程
 * @clone_flags: used to guide how to clone the child process 用于指导如何克隆子进程
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread. 父进程的用户堆栈指针。如果stack==0，则表示fork一个内核线程。
 * @tf:          the trapframe info, which will be copied to child process's proc->tf  trapframe信息，将复制到子进程的proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    //LAB4:EXERCISE2 YOUR CODE
    /*
     * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
     * MACROs or Functions:
     *   alloc_proc:   create a proc struct and init fields (lab4:exercise1)
     *   setup_kstack: alloc pages with size KSTACKPAGE as process kernel stack
     *   copy_mm:      process "proc" duplicate OR share process "current"'s mm according clone_flags
     *                 if clone_flags & CLONE_VM, then "share" ; else "duplicate"
     *   copy_thread:  setup the trapframe on the  process's kernel stack top and
     *                 setup the kernel entry point and stack of process
     *   hash_proc:    add proc into proc hash_list
     *   get_pid:      alloc a unique pid for process
     *   wakeup_proc:  set proc->state = PROC_RUNNABLE
     * VARIABLES:
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     * 一些有用的MACRO、函数和DEFINE，您可以在下面的实现中使用它们。
        *MACRO或函数：
        *alloc_proc：创建proc_struct结构，并初始化字段（lab4:exercise1）
        *setup_kstack：分配大小为KSTACKPAGE的页面(2个页大小)作为进程的内核栈
        *copy_mm: process“proc”根据clone_flags复制或共享进程“current”的mm。如果clone_flags&clone_VM为真，则为“共享”；否则为“复制”
        *copy_thread：在进程的内核堆栈顶部设置trapframe，并设置内核入口点和进程堆栈
        *hash_proc：将proc添加到proc hash_list中
        *get_pid：为进程分配唯一的pid
        *wakeup_proc:设置proc->state=PROC_RUNNABLE
        *变量：
        *proc_list：进程集列表（所有进程控制块的双向线性链表，proc_struct中的成员变量list_link将链接入这个链表中）
        *nr_process:进程（集）的数量
     */
    // do_fork函数主要做了以下6件事情：
    //  1. 分配并初始化进程控制块（alloc_proc函数）；
    //  2. 分配并初始化内核栈（setup_stack函数）；
    //  3. 根据clone_flag标志复制或共享进程内存管理结构（copy_mm函数）；
    //  4. 设置进程在内核（将来也包括用户态）正常运行和调度所需的中断帧和执行上下文（copy_thread函数）；
    //  5. 把设置好的进程控制块放入hash_list和proc_list两个全局进程链表中；
    //  6. 自此，进程已经准备好执行了，把进程状态设置为“就绪”态；
    //  7. 设置返回码为子进程的id号。
    //    1. call alloc_proc to allocate a proc_struct      调用alloc_proc来分配一个proc_struc
    //    2. call setup_kstack to allocate a kernel stack for child process     调用setup_kstack为子进程分配内核堆栈
    //    3. call copy_mm to dup OR share mm according clone_flag       调用copy_mm来根据clone_flag重复或共享mm
    //    4. call copy_thread to setup tf & context in proc_struct      调用copy_thread来设置proc_struct中的tf和context(中断帧和执行上下文)
    //    5. insert proc_struct into hash_list && proc_list             将proc_struct插入hash_list和proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE    调用wakeup_proc以使新的子进程RUNNABLE
    //    7. set ret vaule using child proc's pid                       使用子进程的pid设置ret vaule
    
    //1. 分配并初始化进程控制块（alloc_proc函数）
    if ((proc = alloc_proc()) == NULL) {       
        goto fork_out;
    }
    proc->parent = current;         //设置当前进程为要创建的子进程的父进程
    //2. 分配并初始化内核栈（setup_stack函数）
    if (setup_kstack(proc) != 0) {      
        goto bad_fork_cleanup_proc;
    }
    //3. 根据clone_flag标志来复制或共享进程内存管理结构mm（copy_mm函数）
    if (copy_mm(clone_flags, proc) != 0) {      
        goto bad_fork_cleanup_kstack;   //上述前3步执行没有成功，则需要做对应的出错处理，把相关已经占有的内存释放掉。
    }
    //4. 调用copy_thread来设置proc_struct中的tf和context(中断帧和执行上下文)
    copy_thread(proc, stack, tf);       //kernel_thread传入的stack=0，tf为kernel_thread中构造的tf。（如果stack==0，则表示fork一个内核线程。）
    //5. 把设置好的进程控制块放入hash_list和proc_list两个全局进程链表中；
    bool intr_flag;
    local_intr_save(intr_flag);     //应该是if (read_eflags() & FL_IF),intr_flag=true
    {
        proc->pid = get_pid();
        hash_proc(proc);
        list_add(&proc_list, &(proc->list_link));
        nr_process ++;
    }
    local_intr_restore(intr_flag);
    //自此，进程已经准备好执行了, 调用wakeup_proc以使新的子进程RUNNABLE
    wakeup_proc(proc);      //设置proc->state=PROC_RUNNABLE，在kern/schedule/sched.c
    //使用子进程的pid设置ret vaule
    ret = proc->pid;

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);   // put_kstack - free the memory space of process kernel stack
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}

// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
    return 0;
}

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
/* 这个函数完成了idleproc内核线程和initproc内核线程的创建或复制工作
  idleproc内核线程的工作就是不停地查询，看是否有其他内核线程可以执行了，如果有，马上让调度器选择那个内核线程执行（请参考cpu_idle函数的实现）。所以idleproc内核线程是在ucore操作系统没有其他内核线程可执行的情况下才会被调用。
  接着就是调用kernel_thread函数来创建initproc内核线程。lab4中initproc内核线程的工作就是显示“Hello World”，表明自己存在且能正常工作了。
*/
/* 首先，从kern_init启动至执行到proc_init函数的执行上下文就可以看成是uCore内核（也可看做是内核进程）中的一个内核线程的上下文。
为此，uCore通过给当前执行的上下文分配一个进程控制块以及对它进行相应初始化，将其打造成第0个内核线程 -- idleproc。
*/
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    //调用alloc_proc函数来通过kmalloc函数获得proc_struct结构的一块内存块——作为第0个进程控制块。并把proc进行初步初始化
    if ((idleproc = alloc_proc()) == NULL) {        
        panic("cannot alloc idleproc.\n");
    }

    //proc_init函数对idleproc内核线程进行进一步初始化
    idleproc->pid = 0;                  //表明了idleproc是第0个内核线程。通常可以通过pid的赋值来表示线程的创建和身份确定。
    idleproc->state = PROC_RUNNABLE;    //改变idleproc的状态，使它从“出生”转到“准备工作”，就差uCore调度它执行了
    idleproc->kstack = (uintptr_t)bootstack;        //设置了idleproc所使用的内核栈的起始地址（uCore启动时设置的内核栈直接分配给idleproc使用）。因此以后的其他线程的内核栈都需要通过分配获得。
    idleproc->need_resched = 1;         //初始化idleproc的进程控制块时,idleproc->need_resched 就置为1
    set_proc_name(idleproc, "idle");
    nr_process ++;

    current = idleproc;

    //调用kernel_thread函数创建了一个内核线程init_main。在实验四中，这个子内核线程的工作就是输出一些字符串，然后就返回了（参看init_main函数）。但在后续的实验中，init_main的工作就是创建特定的其他内核线程或用户进程（实验五涉及）
    int pid = kernel_thread(init_main, "Hello world!!", 0);  //调用kernel_thread函数来创建initproc内核线程
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);      //// find_proc - find proc frome proc hash_list according to pid
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
    assert(initproc != NULL && initproc->pid == 1);
}

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
// 如果发现当前进程（也就是idleproc）的need_resched置为1（在初始化idleproc的进程控制块时就置为1了），则调用schedule函数，完成进程调度和进程切换（调用schedule函数要求调度器切换其他进程执行）。
void
cpu_idle(void) {
    while (1) {
        if (current->need_resched) {
            schedule();     //调用schedule函数找其他处于“就绪”态（PROC_RUNNABLE）的进程执行。
        }
    }
}
