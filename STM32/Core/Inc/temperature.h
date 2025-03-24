#ifndef __TEMPERATURE_H__
#define __TEMPERATURE_H__

#include "main.h"

extern volatile float latest_temperature;
extern volatile uint8_t temp_ready;

void temperatureInit(ADC_HandleTypeDef* hadc_ptr);
void temperatureProcess(void);  // ADC ��ȯ �Ϸ� �� ������ �Լ�
void temperatureTrigger(void);  // TIM �̺�Ʈ �߻� �� ȣ���� �Լ�
void Printing_t(int fan_count);

#endif /* __TEMPERATURE_H__ */