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
__trapret:
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
    iret

