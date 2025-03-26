#include "command.h"

// Current Volume
extern uint8_t currentVolume;
extern uint8_t currentTrack;
extern uint8_t receivedTrack;
extern uint8_t receivedNum;
extern uint8_t stopTrack;
extern uint8_t mp3StopFlag;
// Current NavBuffer
extern char navBuffer[NAV_BUFFER_SIZE];
extern uint8_t navIndex;
extern uint8_t nav_input_mode;
uint8_t fanState;

extern UART_HandleTypeDef huart1;

// Parse Command
void parseCommand(char *rxBuffer) {
		char module[4] = { 0 };  // 3 letters + null
		char value = 0;
		
		// Module name Parcing
    strncpy(module, (char*)rxBuffer, 3);  // "FAN", "MP3", "NAV"
    value = rxBuffer[4]; // Last 1 Letter (Num, Char...)

    if (strncmp(module, "FAN", 3) == 0) {
        handleFanCommand(value);
    }
    else if (strncmp(module, "MP3", 3) == 0) {
        handleMp3Command(value);
    }
		else if (strncmp(module, "TEM", 3) == 0) {
        handleTemperatureCommand();
    }
    else if (strncmp(module, "NAV", 3) == 0) {
        handleNavCommand(value);
		}
    
}

void handleTemperatureCommand(void) {
    int temperature = getTemperature();

    char uartBuffer[32];
		int len = snprintf(uartBuffer, sizeof(uartBuffer), "TEM:%d", temperature);

    HAL_UART_Transmit(&huart1, (uint8_t*)uartBuffer, len, HAL_MAX_DELAY);
}

// Fan Control Command
void handleFanCommand(char val) {
		char uartBuffer[32];
		int len;
    switch (val) {
    // Fan Off
    case '0':
        fanState = fanSet(0);
        break;

    // Fan Strength Control
    case 'a':
        fanState = fanSet(1);
        break;
    case 'b':
        fanState = fanSet(2);
				break;
    case 'c':
        fanState = fanSet(3);
        break;
		case 's':
			len = snprintf(uartBuffer, sizeof(uartBuffer), "FAN:%c", fanState);
			HAL_UART_Transmit(&huart1, (uint8_t*)uartBuffer, len, HAL_MAX_DELAY);
			break;
    }
}


// Mp3 Control Command
void handleMp3Command(char val) {
    switch (val) {
    case '1': // Start Current Track
        mp3Play(currentTrack);
        break;
    case '0': // Stop(when mp3Stop flag is false)
		if (mp3StopFlag == 0) mp3Stop();
        break;
    case 'r': // Play Random Track
        currentTrack = mp3GetRandomTrack();
        mp3Play(currentTrack);
        break;
    case 'u': // Volume Up
        mp3IncreaseVolume();
        break;
    case 'd': // Volume Down
        mp3DecreaseVolume();
        break;
    case 'n': // Next Track
        mp3Next();
        break;
    case 'p': // Previous Track
        mp3Previous();
		case 's':
				sendVolumeData();
        break;
    }
}

void sendVolumeData(void) {
    
    char uartBuffer[32];
		int len = snprintf(uartBuffer, sizeof(uartBuffer), "MP3:%d&%d", currentVolume/5,currentTrack);

    HAL_UART_Transmit(&huart1, (uint8_t*)uartBuffer, len, HAL_MAX_DELAY);
}


// Navigation Control Command
void handleNavCommand(char val) {
		char uartBuffer[32];
		int len;
	
    if (val == '1') {
        nav_input_mode = 1;      // Input Mode Start
        navIndex = 0;            // Buffer Reset
        memset(navBuffer, 0, NAV_BUFFER_SIZE);
    }
    else if (val == '0') {
        nav_input_mode = 0;      // Finish Input
        navBuffer[navIndex] = '\0';  // End Letter Null
				findLocation(navBuffer);
				if (findLocation(navBuffer) == 1) {
					len = snprintf(uartBuffer, sizeof(uartBuffer), "NAV:OK=%s",navBuffer);
				}
				else {
					len = snprintf(uartBuffer, sizeof(uartBuffer), "NAV:FAIL");
				}
				HAL_UART_Transmit(&huart1, (uint8_t*)uartBuffer, len, HAL_MAX_DELAY);
			
    }
    else if (nav_input_mode && navIndex < NAV_BUFFER_SIZE - 1) {
        // a~z Input
        if (val >= 'a' && val <= 'z') {
            navBuffer[navIndex++] = val;
						lcdClearDisplay();
						lcdSetCursor(0, 0);
						lcdSendString("Location...");
						lcdSetCursor(1, 0);
						lcdSendString(navBuffer);
						//HAL_Delay(1000);
        }
    }
}
