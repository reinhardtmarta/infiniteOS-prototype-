#pragma once
#include <stdint.h>

void timer_init(void);
uint32_t timer_get_ticks(void);
void timer_tick(void);
