#ifndef SYSCALL_H
#define SYSCALL_H

#define SYS_WRITE   1
#define SYS_EXIT    2
#define SYS_YIELD   3

int syscall(int num, int a, int b, int c);

#endif
