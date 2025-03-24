#include "LEDController.h"
#include "UARTManager.h"  // UART 전송 함수 사용을 위해 필요
#include "BLEManager.h"

extern void sendUARTToSTM(const String& msg);  // UARTManager에서 제공 예정
extern BLEManager bleManager;

void LEDController::handleCommand(const String& command) {
    Serial.println("[LED] STM32로 전송할 명령: " + command);
    if(command == "LED:O" || command == "LED:X") {
      bleManager.sendToApp(command);
    }
    else {sendUARTToSTM(command);}
}
