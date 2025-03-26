#ifndef COMMAND_H
#define COMMAND_H

#define NAV_BUFFER_SIZE 128

#include "stm32l0xx_hal.h"
#include <string.h>
#include "fan.h"
#include "mp3.h"
#include "navigation.h"
#include "lcd.h"
#include "temperature.h"

void handleTemperatureCommand(void);
void parseCommand(char *rxBuffer);
void handleFanCommand(char val);
void handleMp3Command(char val);
void handleNavCommand(char val);
void sendVolumeData(void);

#endif 