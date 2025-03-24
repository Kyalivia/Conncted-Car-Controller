#ifndef __TEMPERATURE_H__
#define __TEMPERATURE_H__

#include "main.h"

extern volatile float latest_temperature;
extern volatile uint8_t temp_ready;

void temperatureInit(ADC_HandleTypeDef* hadc_ptr);
void temperatureProcess(void);  // ADC 변환 완료 후 실행할 함수
void temperatureTrigger(void);  // TIM 이벤트 발생 시 호출할 함수
void Printing_t(int fan_count);

#endif /* __TEMPERATURE_H__ */