#include "CentralCommandRouter.h"
#include "HeaderInstance.h"

void CentralCommandRouter::handleSendCommand(const String& command) {
    Serial.println("[CMD] STM으로 보낼 명령: " + command);
    uartManager.sendUARTToSTM(command);
}

void CentralCommandRouter::handleReceiveCommand(const String& command) {
    Serial.println("[CMD] 앱으로 보낼 응답: " + command);

    // 명령 파싱: 예) "LED:1"
    int separatorIndex = command.indexOf(':');
    if (separatorIndex == -1) {
        Serial.println("[CMD] 잘못된 명령 형식");
        return;
    }

    String key = command.substring(0, separatorIndex);   // "LED"
    String value = command.substring(separatorIndex + 1); // "1"

    String response;
    String uuid;

    // 기능별 UUID 및 응답 포맷 매핑
    if (key == "LED") {
        uuid = LED_CHARACTERISTIC_UUID;
        response = (value == "1") ? "LED:O" : "LED:X";
    }
    else if (key == "MP3") {
        uuid = MP3_CHARACTERISTIC_UUID;
        response = command;  // 변환 없이 그대로 전송
    }
    else if (key == "FAN") {
        uuid = FAN_CHARACTERISTIC_UUID;
        response = command;
    }
    else if (key == "TEM") {
        uuid = TEMP_CHARACTERISTIC_UUID;
        response = command;
    }
    else {
        Serial.println("[CMD] 처리할 수 없는 키워드: " + key);
        return;
    }

    bleManager.sendToApp(response, uuid);
}
