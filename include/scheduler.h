#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <stdint.h>

typedef void (*task_fn)(void);

void scheduler_init(void);
void scheduler_add(task_fn fn);
void scheduler_tick(void);
void scheduler_yield(void);
void scheduler_exit(void);

#endif
