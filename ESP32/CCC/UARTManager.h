#pragma once
#include <Arduino.h>

class UARTManager {
public:
    void init();  // UART 초기화 함수
    void sendUARTToSTM(const String& msg);
private:
    static void uartEventTask(void* pvParameters);  // UART 이벤트 처리 태스크
};
