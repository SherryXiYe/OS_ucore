.text
.globl switch_to
switch_to:                      # switch_to(from, to) 参数是前一个进程和后一个进程的执行现场:process context

    # save from's registers 保存前一个进程的执行现场(各个寄存器的值)
    movl 4(%esp), %eax          # eax points to from 将eax指向前一个进程的context的地址(第一个参数)。
    popl 0(%eax)                # save eip !popl  
                                # 因为esp此时指向返回地址(即进程在返回switch_to函数后的指令地址),
                                # 故采用popl将前一个进程在返回switch_to函数后的指令地址存到prev->context的第一个字段eip(地址为:0(%eax))中
    movl %esp, 4(%eax)          # save esp::context of from 按context中字段顺序依次保存前一个进程的各个寄存器值
    movl %ebx, 8(%eax)          # save ebx::context of from
    movl %ecx, 12(%eax)         # save ecx::context of from
    movl %edx, 16(%eax)         # save edx::context of from
    movl %esi, 20(%eax)         # save esi::context of from
    movl %edi, 24(%eax)         # save edi::context of from
    movl %ebp, 28(%eax)         # save ebp::context of from

    # restore to's registers 恢复下一个进程的执行现场
    movl 4(%esp), %eax          # not 8(%esp): popped return address already 
                                # 将eax指向下一个进程的context的地址(第二个参数)。
                                # 不是8(%esp),因为之前的指令popl 0(%eax)已经将返回地址pop出去了,现在第二个参数的地址应该是4(%esp)
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to 从context的高地址的成员变量ebp开始,逐一把相关成员变量的值赋值给对应的寄存器
    movl 24(%eax), %edi         # restore edi::context of to
    movl 20(%eax), %esi         # restore esi::context of to
    movl 16(%eax), %edx         # restore edx::context of to
    movl 12(%eax), %ecx         # restore ecx::context of to
    movl 8(%eax), %ebx          # restore ebx::context of to
    movl 4(%eax), %esp          # restore esp::context of to

    pushl 0(%eax)               # push eip 
                                # 把context中保存的下一个进程要执行的指令地址context.eip放到了堆栈顶

    ret             
    # 执行最后一条指令“ret”时,会把栈顶的内容赋值给EIP寄存器,
    # 而由pushl 0(%eax) 指令可知,当前栈顶为next->context中保存的eip的值(即下一个进程的下一条要执行的指令的地址)
    # 这样就切换到下一个进程执行了，即当前进程已经是下一个进程了。

    # 而在lab4中,uCore会切换到initProc执行。而initproc->context.eip = (uintptr_t)forkret,
    # 这样,当执行switch_to函数并返回后,initproc将执行其实际上的执行入口地址forkret。
    # 而forkret会调用位于kern/trap/trapentry.S中的forkrets函数执行。

