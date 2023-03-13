#ifndef __LIBS_DEFS_H__
#define __LIBS_DEFS_H__

#ifndef NULL
#define NULL ((void *)0)
#endif

#define __always_inline inline __attribute__((always_inline))
#define __noinline __attribute__((noinline))
#define __noreturn __attribute__((noreturn))

/* Represents true-or-false values */
typedef int bool;

/* Explicitly-sized versions of integer types */
typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;

/* *
 * Pointers and addresses are 32 bits long.
 * We use pointer types to represent addresses,
 * uintptr_t to represent the numerical values of addresses.
 * */
typedef int32_t intptr_t;
typedef uint32_t uintptr_t;

/* size_t is used for memory object sizes */
typedef uintptr_t size_t;

/* used for page numbers */
typedef size_t ppn_t;

/* *
 * Rounding operations (efficient when n is a power of 2)
 * Round down to the nearest multiple of n 向下取n的倍数
 * */
#define ROUNDDOWN(a, n) ({                                          \
            size_t __a = (size_t)(a);                               \
            (typeof(a))(__a - __a % (n));                           \
        })

/* Round up to the nearest multiple of n 向上取n的倍数 */
#define ROUNDUP(a, n) ({                                            \
            size_t __n = (size_t)(n);                               \
            (typeof(a))(ROUNDDOWN((size_t)(a) + __n - 1, __n));     \
        })


/* Return the offset of 'member' relative to the beginning of a struct type */
//求得type数据结构中member成员相对于数据结构变量的偏移量
//对于给定一个结构，offsetof(type,member)是一个常量，to_struct宏正是利用这个不变的偏移量来求得链表数据项的变量地址。
#define offsetof(type, member)                                      \
    ((size_t)(&((type *)0)->member))
//本实验都采用Intel X86-32 CPU，故szie_t等价于 unsigned int
//((type *)0)->member首先将0地址强制"转换"为type数据结构（比如struct Page）的指针，再访问到type数据结构中的member成员（比如page_link）的地址，即是type数据结构中member成员相对于数据结构变量的偏移量。
//在offsetof宏中，这个member成员的地址（即“&((type *)0)->member)”）实际上就是type数据结构中member成员相对于数据结构变量的偏移量。


/* *
 * to_struct - get the struct from a ptr
 * @ptr:    a struct pointer of member
 * @type:   the type of the struct this is embedded in
 * @member: the name of the member within the struct
 * */
//先通过offsetof宏求得type数据结构的成员变量member在本宿主数据结构(type)中的偏移量，
//然后根据成员变量member的地址反过来得出宿主数据结构的变量的地址
#define to_struct(ptr, type, member)                               \
    ((type *)((char *)(ptr) - offsetof(type, member)))
/*to_struct宏中用到的ptr变量是链表节点的地址，
把它减去offsetof宏所获得的数据结构内偏移量，
即就得到了包含链表节点的属主数据结构type的变量的地址。*/

#endif /* !__LIBS_DEFS_H__ */

