#pragma once

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include "HandlerRegistry.h"


class BLEManager {
public:
    void init();
    void update();
    //void sendLEDStatusToSwiftUI(const char* status);
    void sendToApp(const String& msg);
private:
    BLEServer* pServer;
    BLECharacteristic* ledCharacteristic; //  LED 상태 전송을 위한 특성 추가
    static void onWrite(BLECharacteristic* pCharacteristic);
};

