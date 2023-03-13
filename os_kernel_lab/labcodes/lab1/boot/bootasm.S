#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
.set CR0_PE_ON,             0x1                     # protected mode enable flag

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment
    # CLI汇编指令全称为Clear Interupt,该指令的作用是禁止中断发生,在CLI起效之后,所有外部中断都被屏蔽，这样可以保证当前运行的代码不被打断，起到保护代码运行的作用
    # CLD汇编指令将标志寄存器Flag(的方向标志位DF)清零

    # Set up the important data segment registers (DS, ES, SS).
    # 将AX,DS,ES,SS寄存器清零
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:

#从0x64内存地址中(映射到8042的status register)中读取8042的状态,直到读取到的该字节第二位(input buffer是否有数据)为0,此时input buffer中无数据
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al         # 测试读取到的字节的第二位(input buffer是否有数据)
    jnz seta20.1            # 结果不为0则跳转(input buffer中有数据)
    # inb 从I/O端口读取一个字节。%al:AX寄存器的低八位。该指令读取状态寄存器,等待8042键盘控制器闲置
    

# 接下来往0x64写入0xd1,表示请求修改8042的端口P2(发送P2命令到Input Buffer)
    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:

# 继续等待input buffer为空
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

#往0x60端口写入0xDF,表示将P2 port的第二个位(A20)选通置为1
    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc        #载入全局描述符表。把gdtdesc的内容放入寄存器GDTR中
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0      #将cr0寄存器的PE位置1,即可从实模式切换到保护模式

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
# 接下来则使用一个长跳转指令,将cs修改为32位段寄存器,以及跳转到protcseg这一32位代码入口处,此时CPU进入32位模式
# 通过长跳转更新cs的基地址


.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers

# 设置ds、es, fs, gs, ss这几个段寄存器
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

#初始化栈的frame pointer和stack pointer,然后调用使用C语言编写的bootmain函数,进行操作系统内核的加载,至此,bootloader已经完成了从实模式进入到保护模式的任务
# 开辟了从0到0x7c00(从地址0到bootloader的起始地址)的栈空间后,将控制权交给bootmain。
    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

# Bootstrap GDT
# GDT中将代码段和数据段的base均设置为了0,而limit设置为了2^32-1即4G,此时就使得逻辑地址等于线性地址,方便后续对于内存的操作
.p2align 2     # 向后移动位置计数器置为4字节的倍数 为了内存对齐                                     # force 4 byte alignment
gdt:
    SEG_NULLASM    # GDT中的第一项描述符设置为空                                 # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)  # GDT中的第二项描述符为代码段使用,设置属性为可读写可执行         # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)      # GDT中的第三项描述符为数据段使用,设置属性为可读写           # data seg for bootloader and kernel

# 但是注意,创建这两个段描述符的base参数为0x0, limit参数为0xffffffff
# 即无论段选择子定位到了哪个段描述符,用于将逻辑地址(虚拟地址)映射为线性地址的段base都是0,
# 且段的可寻址范围是整块4G内存
# linear address = base + logical address, 当base = 0时,线性地址就与逻辑地址相等了
# 这相当于强行绕过了Intel的段机制(逻辑地址经过段映射后不变),只应用了后来建立的页机制

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
# 由GDT的大小和GDT的物理起始地址组成