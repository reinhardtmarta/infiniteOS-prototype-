#include "scheduler.h"

#define MAX_TASKS 8

static task_fn tasks[MAX_TASKS];
static int task_count = 0;
static int current = 0;

void scheduler_init(void) {
    task_count = 0;
    current = 0;
}

void scheduler_add(task_fn fn) {
    if (task_count < MAX_TASKS) {
        tasks[task_count++] = fn;
    }
}

void scheduler_tick(void) {
    if (task_count == 0) return;

    current = (current + 1) % task_count;
    tasks[current]();
}
