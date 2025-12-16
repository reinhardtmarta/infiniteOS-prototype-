#pragma once

typedef void (*task_fn)(void);

void scheduler_init(void);
void scheduler_add(task_fn fn);
void scheduler_run(void);
