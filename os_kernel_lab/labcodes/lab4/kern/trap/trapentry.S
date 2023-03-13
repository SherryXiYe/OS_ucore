#include <memlayout.h>

# vectors.S sends all traps here.
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    # 把DS、ES和其他通用寄存器都压栈。自此,被打断的程序执行现场(context)被保存在内核栈中
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
    movw %ax, %ds
    movw %ax, %es

    # push %esp to pass a pointer to the trapframe as an argument to trap() 将指针传递到trapframe作为trap()的参数
    pushl %esp

    # call trap(tf), where tf=%esp
    # 在trap.c的trap函数开始了中断服务例程的处理流程
    # 大致调用关系为: trap--> trap_dispatch-->pgfault_handler-->do_pgfault
    call trap

    # pop the pushed stack pointer
    popl %esp

    # return falls through to trapret...
.globl __trapret
__trapret:                  # 结合kern/trap/trap.h中trapframe的结构进行理解
    # restore registers from stack 即pop出trapframe的第一个字段struct pushregs tf_regs
    popal

    # restore %ds, %es, %fs and %gs 依次pop出后续几个字段,直到uint16_t tf_padding3;
    popl %gs
    popl %fs
    popl %es
    popl %ds

    # get rid of the trap number and error code 清除陷阱编号和错误代码,即跳过字段tf_trapno和tf_err
    addl $0x8, %esp
    # 因此，此时,esp指向了current->tf.tf_eip
    # 而lab4中执行的是initproc,则current->tf.tf_eip=kernel_thread_entry,initproc->tf.tf_cs = KERNEL_CS
    
    iret        
    # 因此,lab4中,当执行完iret后,就开始在内核中执行kernel_thread_entry函数了(在kern/process/entry.S中)

.globl forkrets
forkrets:                   # forkrets(current->tf),参数是当前进程的trapframe(中断帧)的地址(lab4中为initproc的tf)
    # set stack to this new process's trapframe
    movl 4(%esp), %esp      # 把esp指向当前进程的中断帧(即第一个参数,4(%esp))
    jmp __trapret
