#ifndef DFPLAYER_H
#define DFPLAYER_H

#include "stm32l0xx_hal.h"
#include "lcd.h"

// Send Command to DFPlayer Mini 
void mp3SendCommand(uint8_t cmd, uint8_t param1, uint8_t param2);
// Play MP3 track 
void mp3Play(uint8_t trackNum);
// Stop Playing mp3
void mp3Stop(void);
// Set Volume
void mp3SetVolume(uint8_t level);
// Volume Increase (+5)
void mp3IncreaseVolume(void);
// Volume Decrease (-5)
void mp3DecreaseVolume(void);
// DFPlayer Mini Reset
void mp3DfplayerInit(void);
// Next Track
void mp3Next(void);
// Previous Track
void mp3Previous(void);
// Get Random Number
uint8_t mp3GetRandomTrack(void);
// System Time
void mp3InitRandomSeed(void);
#endif /* DFPLAYER_H */