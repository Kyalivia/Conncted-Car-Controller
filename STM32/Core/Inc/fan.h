#ifndef FAN_H
#define FAN_H

#include "stm32l0xx_hal.h"
#include "lcd.h"
#include "gpio.h"

/*
#define FAN1_PORT GPIOB
#define FAN1_PIN  GPIO_PIN_13

#define FAN2_PORT GPIOB
#define FAN2_PIN  GPIO_PIN_14

#define FAN3_PORT GPIOB
#define FAN3_PIN  GPIO_PIN_15
*/


typedef enum {
    FAN_OFF = 0,
    FAN_ON
} FanState;

// ?? ?????
void fanInit(void);                   // ? ???
void fanControl(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, FanState state); // ?? ? ON/OFF
void fanSet(uint8_t fan_count);        // ? ??? ?? ?? (1?, 2?, 3?)
void fanAll(FanState state);           // ?? ? ON/OFF

#endif /* FAN_H */