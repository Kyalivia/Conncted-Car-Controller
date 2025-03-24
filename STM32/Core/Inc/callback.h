#ifndef CALLBACK_H
#define CALLBACK_H

#include "stm32l0xx_hal.h"

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart);
// TIM7: Temperature(LM35)
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim);
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc);
 

#endif 