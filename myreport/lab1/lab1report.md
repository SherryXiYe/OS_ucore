# Lab1 report
## 一些相关源码文件
    boot
        asm.h:有关GDT的常量声明，设置GDT表项的宏代码
        bootasm.S：启动到跳转到bbotmain阶段的所有汇编代码。先开始执行，它开启保护态，并设置C代码能够运行的栈，最后调用bootmain()函数
        bootmain.c：从磁盘读取ELF格式的内核程序，并跳转到内核头程序执行（将kernel读入内存并跳转到它）
    kern/init
        entry.S：为内核运行做准备，然后跳转到kern_init()
    kern/trap
        trap.c/trap.h:定义中断相关的宏、中断帧、中断入口函数
        trapentry.S:定义中断进入，中断返回，fork返回程序
        vector.S:256个中断处理程序入口代码
    tools
        sign.c:把引导代码读入512B缓冲区，再把合法的引导代码写入磁盘镜像第一个扇区
## 练习一
### 第一题
    操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
1. 将一些.S、.c的内核文件编译为.o文件，构建出内核kernel
2. 生成bootblock引导程序
   * 将bootasm.S bootmain.c编译成.o文件，并将bootblock依赖的.o文件链接成obj/bootblock.o
   * 将sign.c编译为sign.o
   * 使用sign.o规范化bootblock.o，生成bin/bootblock引导扇区
3. 生成ucore.img虚拟磁盘（使用dd命令，将生成的两个文件的数据拷贝至img文件中，形成映像文件）

### 第二题
    一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？
观察sign.c，发现会先进行文件大小检查，超过510字节则报错，之后再为最后两个字节（结束符）赋值0x55、0xAA。最后还会检查文件大小是否为512.

因此，符合规范的硬盘主引导扇区总体大小为512字节。其中，512字节的组成为：
1. 启动代码：不超过466字节
2. 硬盘分区表：不超过64字节
3. 两个字节的结束符（0x55、0xAA）
### 遇到的问题

Makefile中的指令太多，比较复杂，看起来比较费劲。

解决办法：多搜索各种指令的用法。
## 练习二
### 第一题
    从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行

由于BIOS是在实模式下运行的，因此需要在tools/gdbinit里进行相应设置

    set arch i8086
    target remote: 1234

1. 采用gdb指令info reg可以查看各个寄存器值，可以发现CPU加电后CS，EIP寄存器的数值分别被初始化为0xf000, 0xfff0, 即第一个执行的指令位于内存中的0xffff0处。
2. 执行si，单步调试。可以发现EIP变为0x0000e05b，CS的值仍为0xf000。执行命令x/2i 0xfffffff0,打印该地址的值，发现第一条指令是长跳转指令，即：
    
        0xfffffff0:  ljmp   $0x3630,$0xf000e05b

遇到问题：一开始没有删去gdbnit中的后两行，会报错。
解决方法：删去后两行。应该是因为break kern_init的存在，直接跳到断点了。

### 第二题
    在初始化位置0x7c00设置实地址断点,测试断点正常

0x7c00是bootloader的入口位置，此时CPU仍然处于实模式下，因此只需要设置实地址断点在0x7c00处即可.

遇到问题：
1. make debug后报错：

    tools/gdbinit:1: Error in sourced command file:
    Junk after item "i8086": //设置当前调试的CPU是8086

    解决：原来是因为我在配置文件中添加了注释，删去就好了。

2. 在上述bug解决后，又产生了新的error。可以识别断点为0x7c00处，但后续出错，大概是说没有继续。

    解决：重新写了一遍gdbinit，但感觉和之前一样啊，莫名就不报错了，搞不懂。

采用i r指令观察寄存器的值，可以发现cs的值0，EIP的值为0x7c00，说明断点设置正常。

### 第三题
    从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较

可以根据实验指导书的提示设置hook-stop，再进行单步调试。

    set architecture i8086
    target remote :1234
    b *0x7c00
    define hook-stop
    x/i $pc
    end

可以看到成功地反汇编了从0x7c00开始的执行的指令的汇编代码。发现除了gdb反汇编出来的指令中没有指定位宽w（word）之外，其余内容与bootasm.S和bootblock.asm的入口处的代码相同。

### 第四题（略）

## 练习三

### 如何开启A20

1. 等待8042控制器Inpute Buffer为空
2. 发送P2命令到Input Buffer(往0x64写入0xd1,表示请求修改8042的端口P2)
3. 等待Input Buffer为空
4. 将P2得到的第二个位（A20选通）置为1(往0x60端口写入0xDF,表示将P2 port的第二个位A20选通置为1)

主要完成的操作为请求修改P2第二个位（A20选通）和实际修改（置为1），而这两个操作都需要先等待数据缓冲区中没有数据后，才能执行。
### 如何初始化GDT表

一个简单的GDT表和其描述符已经静态储存在引导区中，载入即可。 lgdt gdtdesc指令载入全局描述符表，即把gdtdesc的内容放入寄存器GDTR中。
### 如何使能和进入保护模式

x86引入了几个新的控制寄存器 (Control Registers) cr0 cr1… cr7 ，每个长 32 位。这其中的某些寄存器的某些位被用来控制 CPU 的工作模式，其中 cr0 的最低位，就是用来控制 CPU 是否处于保护模式的。因为控制寄存器不能直接拿来运算，所以需要通过通用寄存器来进行一次存取，设置 cr0 最低位为1 之后就已经进入保护模式。但是由于现代 CPU 的一些特性 （乱序执行和分支预测等），在转到保护模式之后 CPU 可能仍然在跑着实模式下的代码，这显然会造成一些问题。因此必须强制 CPU 清空一次缓冲，最有效的方法就是执行一次long jump指令。

长跳转可以设置cs寄存器，CPU 发现了 cr0 寄存器第 0 位的值是 1，就会按 GDTR 的指示找到全局描述符表GDT，然后根据索引值把新的段描述符信息加载到 cs 影子寄存器，更新cs基地址。至此CPU真正进入了保护模式，拥有了 32 位的处理能力。

    综上，bootloader 从实模式进入保护模式的过程：
    1. 关闭中断，清理环境：将flag和寄存器AX,DS,ES,SS清零
    2. 开启A20
    3. 加载GDT全局描述符表
    4. 将cr0寄存器的bit 0置为1，标志着从实模式转换到保护模式
    5. 使用一个长跳转ljmp $PROT_MODE_CSEG, $protcseg以更新cs基地址，至此CPU真正进入了保护模式，拥有了 32 位的处理能力。
    6. 设置ds，es，fs，gs，ss段寄存器，开辟从0到0x7c00(从地址0到bootloader的起始地址)的栈空间，最后进入bootmain函数。
   
## 练习四

### bootloader如何读取硬盘扇区的
读取一个磁盘扇区过程（readsect）：
1. 等待磁盘直到其不忙（连续不断地从0x1F7地址读取磁盘的状态，直到磁盘不忙为止）
2. 往0x1F2到0X1F6中设置读取扇区需要的参数，包括读取扇区的数量以及LBA参数
3. 往0x1F7端口发送读命令0X20
4. 等待磁盘完成读取操作
5. 从数据端口0X1F0读取出数据到指定内存中

readseg封装了readsect，通过迭代使其可以读取任意长度内容。
### bootloader是如何加载ELF格式的OS
1. 读取磁盘上的1页（8个扇区，4KB），得到ELF头部
2. 校验读入的ELF头部的e_magic字段（是否为指定的ELF_MAGIC）,判断是否为合法ELF文件
3. 从ELF头中获得程序头（program header）的位置，以及该表的入口数目（段个数）
4. 分别读取每段的信息，根据偏移量分别把程序段的数据读取到内存中(调用readseg函数将每一个段加载到特定的内存中)。至此完成了将OS加载到内存中的操作
5. 根据ELF头部储存的入口信息找到内核的入口并跳转（跳转至ELF文件的程序入口点）

## 练习五
最后一行：

    ebp:0x00007bf8 eip:0x00007d74 arg :0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
        <unknow>: -- 0x00007d73 --

其中，ebp是第一个被调用函数的栈帧的base pointer，eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（即下一个栈帧对应函数的返回地址），而args是传递给这第一个被调用的函数的参数。

观察bootblock.asm,可以发现跳转至ELF文件的程序入口点部分的汇编代码为：

    7d68:	a1 18 00 01 00       	mov    0x10018,%eax
    7d6d:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d72:	ff d0                	call   *%eax

因此，eip的地址0x00007d74正好是bootmain函数中调用OS kernel入口函数的指令的下一条。证明这最后一行确实是第一个被调用函数bootmain的栈帧。

同理，也可发现后面的unknow之后的0x00007d73是bootmain函数内调用OSkernel入口函数的指令的地址。

## 练习六
### 第一题

    中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

中断描述符表中的一个表现（描述符）占8字节。

1. Bit 16—31: gd_ss,中断服务例程的段选择子，用于索引全局描述符表GDT来获取中断处理代码对应的段地址（索引GDT——相应段描述符——相应段基址）
2. Bit 0—15: gd_odd_15_0，偏移量的低16位；bit 48—63: gd_odd_31_16 ,为偏移量的高16位。两者构成段内偏移量，根据段选择子和段内偏移地址就可以得出中断处理程序的地址。
3. Bit 45-46：gd_dpl，DPL。

### 第二题

首先通过__vectors[]获得所有中断的入口，再通过循环为每个中断设置权限（默认为内核态权限），为T_SYSCALL设置用户态权限，最后通过lidt将IDT的起始地址装入IDTR寄存器即可。

只有T_SYSCALL是用户态权限(DPL_USER)，其他都为内核态权限(DPL_KERNEL)。

### 第三题
略