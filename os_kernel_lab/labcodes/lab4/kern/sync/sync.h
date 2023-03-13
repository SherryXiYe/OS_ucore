#ifndef __KERN_SYNC_SYNC_H__
#define __KERN_SYNC_SYNC_H__

#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
    if (read_eflags() & FL_IF) {    
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void
__intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

//语句local_intr_save(intr_flag);…local_intr_restore(intr_flag)：保护进程切换、添加进程到列表等操作不会被中断，以免进程切换时其他进程再进行调度，相当于互斥锁
#define local_intr_save(x)      do { x = __intr_save(); } while (0)
#define local_intr_restore(x)   __intr_restore(x);

#endif /* !__KERN_SYNC_SYNC_H__ */

