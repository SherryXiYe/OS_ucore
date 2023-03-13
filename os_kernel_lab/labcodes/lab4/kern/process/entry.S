.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void) 主要为内核线程的主体fn函数做了一个准备开始和结束运行的“壳”

    pushl %edx              # push arg 把函数fn的参数arg(保存在edx寄存器中)压栈
    call *%ebx              # call fn 调用fn函数
    # 这是因为kernel_thread函数中,tf.tf_regs.reg_ebx = (uint32_t)fn,
    # 而lab4中调用kernel_thread创建的内核线程是initproc,传入的参数fn是函数init_main,
    # 因此initproc->tf.tf_regs.reg_ebx = init_main,
    # 所以在kernl_thread_entry中执行“call %ebx”后,就开始执行initproc的主体init_main了。

    pushl %eax              # save the return value of fn(arg) 把函数返回值eax寄存器内容压栈
    call do_exit            # call do_exit to terminate current thread 调用do_exit函数退出线程执行

