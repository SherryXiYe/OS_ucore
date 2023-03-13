#include <defs.h>
#include <x86.h>
#include <elf.h>

/* *********************************************************************
 * This a dirt simple boot loader, whose sole job is to boot
 * an ELF kernel image from the first IDE hard disk.
 *
 * DISK LAYOUT
 *  * This program(bootasm.S and bootmain.c) is the bootloader.
 *    It should be stored in the first sector of the disk.
 *
 *  * The 2nd sector onward holds the kernel image.
 *
 *  * The kernel image must be in ELF format.
 *
 *  *这个程序（bootasm.S和bootmain.c）是bootloader，
 *    它应该被存储在磁盘的第一个扇区内；第二个扇区之后存储的是映像，必须是ELF格式的

 *
 * BOOT UP STEPS
 *  * when the CPU boots it loads the BIOS into memory and executes it
 *
 *  * the BIOS intializes devices, sets of the interrupt routines, and
 *    reads the first sector of the boot device(e.g., hard-drive)
 *    into memory and jumps to it.
 *
 *  * Assuming this boot loader is stored in the first sector of the
 *    hard-drive, this code takes over...
 *
 *  * control starts in bootasm.S -- which sets up protected mode,
 *    and a stack so C code then run, then calls bootmain()
 *
 *  * bootmain() in this file takes over, reads in the kernel and jumps to it.
  * BOOT步骤：
 *  * 当 CPU 启动时，它会将 BIOS 加载到内存中并执行它。
 *
 *  * BIOS初始化设备、设置中断程序，并将bootloader的第一个扇区（如硬盘）读入内存并跳转到这一部分。
 *
 *  * 假设bootloader存储在硬盘的第一个扇区中，那么它就开始工作了
 *
 *  * bootasm.S中的代码先开始执行，它开启保护态，并设置C代码能够运行的栈;
 *  * 最后调用本文件中的bootmain()函数；
 *  * bootmain()函数将kernel读入内存并跳转到它。
 * */

#define SECTSIZE        512
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/* waitdisk - wait for disk ready */
// 连续不断地从0x1F7地址读取磁盘的状态，直到磁盘不忙为止
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}

/* readsect - read a single sector at @secno into @dst */
// 基本功能为读取一个磁盘扇区
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();     // 等待磁盘到不忙为止

    outb(0x1F2, 1);          // 往0X1F2地址中写入要读取的扇区数，由于此处需要读一个扇区，因此参数为1               // count = 1
    outb(0x1F3, secno & 0xFF);      // 输入LBA参数的0...7位；
    outb(0x1F4, (secno >> 8) & 0xFF);   // 输入LBA参数的8-15位
    outb(0x1F5, (secno >> 16) & 0xFF);  // 输入LBA参数的16-23位
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);  // 输入LBA参数的24-27位（对应到0-3位），第四位为0表示从主盘读取，其余位被强制置为1；
    outb(0x1F7, 0x20);       // 向磁盘发出读命令0x20               // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);     // 从数据端口0x1F0读取数据，读一个扇区到dst位置，除以4是因为此处是以4个字节为单位的，这个从指令是以l(long)结尾这点可以推测出来；
}

/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
 /* *
 * readseg 
 * 从内核的offset处读count个字节到虚拟地址va中。
 * 复制的内容可能比count个字节多。
 * */
 //readseg封装了readsect，通过迭代使其可以读取任意长度内容
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    // 向下舍入到扇区边
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    // 从字节转换到扇区；ELF文件从1扇区开始，因为0扇区被引导占用
    // 此处secno初始化为溢出（舍入）后的va所对应的扇区
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    // 如果这个函数太慢，我们可以同时读多个扇区。
    // 我们在写到内存时会比请求的更多，但这没有关系
    // 我们是以内存递增次序加载的
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    // 从磁盘读出kernel映像的第一页，得到ELF头
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
    //首先，从磁盘的第一个扇区（第零个扇区为bootloader）中读取OS kenerl最开始的4kB代码
    //然后判断其最开始四个字节是否等于指定的ELF_MAGIC，用于判断读入的ELF文件是否合法
    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    // 从ELF头文件中获取program header表的位置，以及该表的入口数目
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    //遍历该表的每一项，并且从每一个program header中获取到段应该被加载到内存中的位置（Load Address，虚拟地址），以及段的大小
    //然后调用readseg函数将每一个段加载到特定的内存中，至此完成了将OS加载到内存中的操作；
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    // 从ELF header中查询到OS kernel的入口地址，然后使用函数调用的方式跳转到该地址上去（跳转至ELF文件的程序入口点）
    //tools/kernel.ld：ld形成执行文件的地址所用到的链接脚本。修改了ucore的起始入口(从kern_init修改为kern_entry)和代码段的起始地址。
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}

