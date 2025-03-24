#include "callback.h"

extern uint8_t isConnect;
extern UART_HandleTypeDef huart1;


// UART: ESP - STM  
 void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if (huart->Instance == huart1.Instance) {
			isConnect = 1;
		}
}