#include "lcd.h"

// en-pin pulse creation func
void lcdPulseEN() {
    HAL_GPIO_WritePin(EN_1602_GPIO_Port, EN_1602_Pin, 1);
		delayUs(50);
    HAL_GPIO_WritePin(EN_1602_GPIO_Port, EN_1602_Pin, 0);
		delayUs(50);
}

// send 4bit data to LCD
void lcdSend4bit(char data, uint16_t us) {
    HAL_GPIO_WritePin(D7_1602_GPIO_Port, D7_1602_Pin, ((data >> 3) & 0x01)); 
    HAL_GPIO_WritePin(D6_1602_GPIO_Port, D6_1602_Pin, ((data >> 2) & 0x01)); 
    HAL_GPIO_WritePin(D5_1602_GPIO_Port, D5_1602_Pin, ((data >> 1) & 0x01));
    HAL_GPIO_WritePin(D4_1602_GPIO_Port, D4_1602_Pin, (data & 0x01));
    lcdPulseEN();
		delayUs(us);
}

// send 8bit data to LCD
void lcdSend8bit(char data, uint16_t us) {
		lcdSend4bit((data >> 4) & 0x0F, 0);
		lcdSend4bit(data & 0x0F, 0);
		delayUs(us);
}

// setting LCD cursor
void lcdSetCursor(int row, int col) {
	HAL_GPIO_WritePin(RS_1602_GPIO_Port, RS_1602_Pin, 0);
    switch (row) {
        case 0:
            col |= 0x80;
            break;
        case 1:
            col |= 0xC0;
            break;
    }
    lcdSend8bit(col , 0);
}

// erase LCD
void lcdClearDisplay() {
	HAL_GPIO_WritePin(RS_1602_GPIO_Port, RS_1602_Pin, 0); 
	lcdSend8bit(0b00000001, 3000);
}

// send string
void lcdSendString(char *str) {
	HAL_GPIO_WritePin(RS_1602_GPIO_Port, RS_1602_Pin, 1);
	while (*str) {
		lcdSend8bit(*str++, 0);
	}
}

// LCD Initialization
void lcdInit(void) {
	HAL_GPIO_WritePin(RS_1602_GPIO_Port, RS_1602_Pin, 0);

	// 4 bit
	// booting
	delayUs(50000);
	// setting
  lcdSend4bit(0b0011, 5000);
  lcdSend4bit(0b0011, 1000); 
  lcdSend4bit(0b0011, 1000); 
  lcdSend4bit(0b0010, 1000); 

  // Display Init
	// Function set
  lcdSend8bit(0b00101000, 1000); 
	// Display Switch
  lcdSend8bit(0b00001000, 1000);
	// Screen Clear
  lcdSend8bit(0b00000001, 2000); 
	// Input Set
  lcdSend8bit(0b00000110, 1000);

  // Display On
	// Display Switch
  lcdSend8bit(0b00001100, 1000); 
}