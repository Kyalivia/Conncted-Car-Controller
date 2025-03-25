#include "temperature.h"
#include <stdio.h>
#include "lcd.h"
static ADC_HandleTypeDef* local_hadc = NULL;

volatile uint32_t adc_val = 0;
volatile float latest_temperature = 0;
volatile uint8_t temp_ready = 0;
volatile uint8_t start_conversion_flag = 0;
volatile uint8_t adc_ready_flag = 0;

void temperatureInit(ADC_HandleTypeDef* hadc_ptr)
{
    local_hadc = hadc_ptr;
}

void temperatureTrigger(void)
{
    start_conversion_flag = 1;
}

void temperatureProcess(void)
{
    if (start_conversion_flag)
    {
        start_conversion_flag = 0;
        HAL_ADC_Start_IT(local_hadc);
    }

    if (adc_ready_flag)
    {
        adc_ready_flag = 0;

        adc_val = HAL_ADC_GetValue(local_hadc);
        float vref = 3.3f;
        float voltage = (float)adc_val * vref / 4095.0f;
        latest_temperature = voltage * 100.0f;

        temp_ready = 1;
    }
}

 void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) 
{
    if (htim->Instance == TIM7)
    {
        temperatureTrigger();
    }
}

 void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{
    if (hadc->Instance == ADC1)
    {
        HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
        adc_ready_flag = 1;
    }
}


void Printing_t(int fan_count)
{
    char buffer[16];
    lcdClearDisplay();
    lcdSetCursor(0, 0);
    lcdSendString("FAN ON");
    lcdSetCursor(1, 0);
    sprintf(buffer, "Temperature: %d", fan_count);
    lcdSendString(buffer);
}
int getTemperature(void)
{
    return latest_temperature;
}