#pragma once
#include <Arduino.h>

class UARTManager {
public:
    void init();  // UART 초기화 함수

private:
    static void uartEventTask(void* pvParameters);  // UART 이벤트 처리 태스크
};
