#include "fan.h"

void fanInit(void) 
{
		HAL_GPIO_WritePin(FAN1_GPIO_Port, FAN1_Pin, GPIO_PIN_SET);
    HAL_GPIO_WritePin(FAN2_GPIO_Port, FAN2_Pin, GPIO_PIN_SET);
    HAL_GPIO_WritePin(FAN3_GPIO_Port, FAN3_Pin, GPIO_PIN_SET);
}

void fanControl(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, FanState state) 
{
    HAL_GPIO_WritePin(GPIOx, GPIO_Pin, (state == FAN_ON) ? GPIO_PIN_RESET : GPIO_PIN_SET);
}

void fanStatusPrint(int fan_count)
{
	char buffer[16];
	lcdInit();
	// FAN ON/OFF
	// STEP 1 2 3
	if (fan_count)
	{
		lcdClearDisplay();
		lcdSetCursor(0, 0);
		lcdSendString("FAN ON");
		lcdSetCursor(1, 0);
		sprintf(buffer, "STEP: %d", fan_count);
		lcdSendString(buffer);
	}
	else
	{
		lcdClearDisplay();
		lcdSetCursor(0, 0);
		lcdSendString("FAN OFF");		
	}
}

void fanSet(uint8_t fan_count) {
    fanAll(FAN_OFF);
	
		if (fan_count >= 1) fanControl(FAN1_GPIO_Port, FAN1_Pin, FAN_ON);
    if (fan_count >= 2) fanControl(FAN2_GPIO_Port, FAN2_Pin, FAN_ON);
    if (fan_count >= 3) fanControl(FAN3_GPIO_Port, FAN3_Pin, FAN_ON);
	
		fanStatusPrint(fan_count);        
}

void fanAll(FanState state) 
{
		fanControl(FAN1_GPIO_Port, FAN1_Pin, state);
    fanControl(FAN2_GPIO_Port, FAN2_Pin, state);
    fanControl(FAN3_GPIO_Port, FAN3_Pin, state);
}
