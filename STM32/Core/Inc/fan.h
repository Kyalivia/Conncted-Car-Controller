#ifndef FAN_H
#define FAN_H

#include "stm32l0xx_hal.h"
#include "gpio.h"
#include "lcd.h"


typedef enum {
    FAN_OFF = 0,
    FAN_ON
} FanState;


void fanInit(void);                  
void fanControl(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, FanState state);
char fanSet(uint8_t fan_count); 
void fanAll(FanState state);

#endif /* FAN_H */