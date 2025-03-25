#include "command.h"

// Current Volume
extern uint8_t currentVolume;
extern uint8_t currentTrack;
extern uint8_t receivedTrack;
extern uint8_t receivedNum;
extern uint8_t stopTrack;
// Current NavBuffer
extern char navBuffer[NAV_BUFFER_SIZE];
extern uint8_t navIndex;
extern uint8_t nav_input_mode;

// Parse Command
void parseCommand(uint8_t *rxBuffer) {
		char module[4] = { 0 };  // 3 letters + null
		char value = 0;
		
    // parsing module name
		// Module name Parcing
    strncpy(module, (char*)rxBuffer, 3);  // "FAN", "MP3", "NAV"
    value = rxBuffer[4]; // Last 1 Letter (Num, Char...)

    if (strncmp(module, "FAN", 3) == 0) {
        handleFanCommand(value);
    }
    else if (strncmp(module, "MP3", 3) == 0) {
        handleMp3Command(value);
    }
    else if (strncmp(module, "NAV", 3) == 0) {
        handleNavCommand(value);
    }
}


// Fan Control Command
void handleFanCommand(char val) {
    switch (val) {
    // Fan Off
    case '0':
        fanSet(0);
        break;

    // Fan Strength Control
    case 'a':
        fanSet(1);
        break;
    case 'b':
        fanSet(2);
    case 'c':
        fanSet(3);
        break;
    }
}


// Mp3 Control Command
void handleMp3Command(char val) {
    switch (val) {
    case '1': // Start Current Track
        mp3Play(currentTrack);
        break;
		/*
    case '0': // Stop(when mp3Stop flag is false)
				if (mp3stopFlag == 0) {
            mp3Stop();
        }
        break;
		*/
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
        break;
    }
}


// Navigation Control Command
void handleNavCommand(char val) {
    if (val == '1') {
        nav_input_mode = 1;      // Input Mode Start
        navIndex = 0;            // Buffer Reset
        memset(navBuffer, 0, NAV_BUFFER_SIZE);
    }
    else if (val == '0') {
        nav_input_mode = 0;      // Finish Input
        navBuffer[navIndex] = '\0';  // End Letter Null
				findLocation(navBuffer);
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
						HAL_Delay(1000);
        }
    }
}
