#ifndef LCD_H
#define LCD_H

#include "stm32l0xx_hal.h"
#include "gpio.h"
#include "delay.h"
#include <stdio.h>


void lcdPulseEN();
void lcdSend4bit(char data, uint16_t us);
void lcdSend8bit(char data, uint16_t us);
void lcdSetCursor(int row, int col);
void lcdClearDisplay();
void lcdSendString(char *str);
void lcdInit(void);


#endif 