#ifndef __LIBS_ELF_H__
#define __LIBS_ELF_H__

#include <defs.h>

#define ELF_MAGIC    0x464C457FU            // "\x7FELF" in little endian

/* file header */
// ELF header在文件开始处描述了整个文件的组织。ELF的文件头包含整个执行文件的控制结构
struct elfhdr {
    uint32_t e_magic;     // must equal ELF_MAGIC 必须等于ELF_MAGIC魔数
    uint8_t e_elf[12];      
    // 12 字节，每字节对应意义如下：
    // 0 : 1 = 32 位程序；2 = 64 位程序
    // 1 : 数据编码方式，0 = 无效；1 = 小端模式；2 = 大端模式
    // 2 : 只是版本，固定为 0x1
    // 3 : 目标操作系统架构
    // 4 : 目标操作系统版本
    // 5 ~ 11 : 固定为 0

    uint16_t e_type;      // 1=可重定位, 2=可执行, 3=共享对象, 4=核心镜像 // 1=relocatable, 2=executable, 3=shared object, 4=core image
    uint16_t e_machine;   // 3=x86, 4=68K, etc.
    uint32_t e_version;   // file version, always 1
    uint32_t e_entry;     // 程序入口的虚拟地址地址（如果可执行）// entry point if executable
    uint32_t e_phoff;     // 程序段表头（program header表）相对elfhdr偏移位置 // file position of program header or 0
    uint32_t e_shoff;     // file position of section header or 0
    uint32_t e_flags;     // architecture-specific flags, usually 0
    uint16_t e_ehsize;    // 这个ELF头的大小 // size of this elf header
    uint16_t e_phentsize; // 程序头部长度 // size of an entry in program header
    uint16_t e_phnum;     // 段个数 也就是program header表中入口数目 // number of entries in program header or 0
    uint16_t e_shentsize; // size of an entry in section header
    uint16_t e_shnum;     // number of entries in section header or 0
    uint16_t e_shstrndx;  // section number that contains section name strings
};

/* program section header 程序段表头 */
struct proghdr {
    uint32_t p_type;   // 段类型 // loadable code or data, dynamic linking info,etc.
    uint32_t p_offset; // 段相对文件头的偏移值 // file offset of segment
    uint32_t p_va;     // 段的第一个字节将被放到内存中的虚拟地址 // virtual address to map segment
    uint32_t p_pa;     //段的第一个字节在内存中的物理地址 // physical address, not used
    uint32_t p_filesz; //段在文件中的长度 // size of segment in file
    uint32_t p_memsz;  // 段在内存映像中占用的字节数  // size of segment in memory (bigger if contains bss）
    uint32_t p_flags;  // read/write/execute bits
    uint32_t p_align;  // required alignment, invariably hardware page size
};

#endif /* !__LIBS_ELF_H__ */

