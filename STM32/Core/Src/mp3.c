#include "mp3.h"
#include <stdlib.h>

// UART Handler
extern UART_HandleTypeDef huart1;
extern UART_HandleTypeDef huart4;

// Current Volume
extern uint8_t currentVolume;
extern uint8_t currentTrack;
extern uint8_t receivedTrack;
extern uint8_t receivedNum;
extern uint8_t stopTrack;
extern uint8_t mp3StopFlag;

// Send Command to DFPlayer Mini 
void mp3SendCommand(uint8_t cmd, uint8_t param1, uint8_t param2) {
	uint8_t command[10] = {0x7E, 0xFF, 0x06, cmd, 0x00, param1, param2, 0x00, 0x00, 0xEF};
  uint16_t checksum = -(command[1] + command[2] + command[3] + command[4] + command[5] + command[6]);

  command[7] = (checksum >> 8) & 0xFF;
  command[8] = checksum & 0xFF;

  HAL_UART_Transmit(&huart4, command, 10, HAL_MAX_DELAY);
}

// Play MP3 track 
void mp3Play(uint8_t trackNum) {
	lcdClearDisplay();
	if (mp3StopFlag == 0) { // Normal Case
		if (trackNum >= 1 && trackNum <= 8) {
			currentTrack = trackNum;
			mp3SendCommand(0x03, 0x00, currentTrack);

			lcdSetCursor(0, 0); // Line 1
			char buffer1[16];
			sprintf(buffer1, "Music Track: %d", currentTrack);
			lcdSendString(buffer1);

			lcdSetCursor(1, 0); // Line 2
			char buffer2[16];
			sprintf(buffer2, "Volume: %d", currentVolume);
			lcdSendString(buffer2);
		}
		else {
			lcdSetCursor(0, 0); // Line 1
			char buffer[16];
			sprintf(buffer, "Invalid Track");
			lcdSendString(buffer);
		}
	}
	else { // If Music is Already Stopped
		currentTrack = stopTrack;
		mp3SendCommand(0x03, 0x00, currentTrack);
		mp3StopFlag = 0;

		lcdSetCursor(0, 0); // Line 1
		char buffer1[16];
		sprintf(buffer1, "Resume Track: %d", currentTrack);
		lcdSendString(buffer1);

		lcdSetCursor(1, 0); // Line 2
		char buffer2[16];
		sprintf(buffer2, "Volume: %d", currentVolume);
		lcdSendString(buffer2);
	}
}

// Stop Playing mp3
void mp3Stop(void) {
	stopTrack = currentTrack;
	mp3StopFlag = 1;
	mp3SendCommand(0x16, 0x00, 0x00);  // Stop

	lcdClearDisplay();
	lcdSetCursor(0, 0); // Line 1
	char buffer1[16];
	sprintf(buffer1, "Music Stop");
	lcdSendString(buffer1);
}

// Volume Set (0 ~ 30)
void mp3SetVolume(uint8_t level) {
	if (level > 30) level = 30;
	currentVolume = level;
	mp3SendCommand(0x06, 0x00, currentVolume);
}

// Volume Increase (+5)
void mp3IncreaseVolume(void) {
	if (currentVolume + 5 <= 30) 
		currentVolume += 5;
	else
		currentVolume = 30;
	mp3SendCommand(0x06, 0x00, currentVolume);
	
	lcdClearDisplay();
	lcdSetCursor(0,0); // Line 1
	char buffer1[16];
	sprintf(buffer1, "Volume: %d", currentVolume);
	lcdSendString(buffer1);
	
	if (currentVolume == 30) {
		lcdSetCursor(1,0); // Line 2
		char buffer2[16];
		sprintf(buffer2, "Volume Max");
		lcdSendString(buffer2);
	}
}

// Volume Decrease (-5)
void mp3DecreaseVolume(void) {
	if (currentVolume - 5 >= 0)
		currentVolume -= 5;
	else
		currentVolume = 0;
	mp3SendCommand(0x06, 0x00, currentVolume);
	
	lcdClearDisplay();
	lcdSetCursor(0,0); // Line 1
	char buffer1[16];
	sprintf(buffer1, "Volume: %d", currentVolume);
	lcdSendString(buffer1);
	
	if (currentVolume == 0) {
		lcdSetCursor(1,0); // Line 2
		char buffer2[16];
		sprintf(buffer2, "Volume Min");
		lcdSendString(buffer2);
	}
}

// DFPlayer Mini Reset
void mp3DfplayerInit(void) {
  mp3SendCommand(0x3F, 0x00, 0x00);
  mp3SetVolume(15);
}

// Play Next Track
void mp3Next(void) {
	if (currentTrack < 8) {
		mp3Play(currentTrack + 1);
	}
	else if (currentTrack == 8) {
		mp3Play(1);
	}
}

// Play Previous Track
void mp3Previous(void) {
  if (currentTrack > 1) {
		mp3Play(currentTrack - 1);
	}
	else if (currentTrack == 1) {
		mp3Play(8);
	}
}

// Get Random Number
uint8_t mp3GetRandomTrack(void) {
    return (rand() % 8) + 1;  // 1 ~ 8
}

// System Time
void mp3InitRandomSeed(void) {
    srand(HAL_GetTick());
}