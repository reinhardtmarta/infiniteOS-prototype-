#include "scheduler.h"

#define MAX_TASKS 5

static task_fn tasks[MAX_TASKS];
static int task_count = 0;

void scheduler_init(void) {
    task_count = 0;
}

void scheduler_add(task_fn fn) {
    if (task_count < MAX_TASKS) {
        tasks[task_count++] = fn;
    }
}

void scheduler_run(void) {
    while (1) {
        for (int i = 0; i < task_count; i++) {
            tasks[i]();
        }
    }
}
