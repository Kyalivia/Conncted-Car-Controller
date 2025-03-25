#pragma once

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID              "12345678-1234-5678-1234-56789abcdef0"
#define LED_CHARACTERISTIC_UUID   "87654321-4321-6789-4321-6789abcdef01"
#define FAN_CHARACTERISTIC_UUID   "11111111-2222-3333-4444-5555abcdef01"
#define MP3_CHARACTERISTIC_UUID   "22222222-3333-4444-5555-6666abcdef01"
#define TEMP_CHARACTERISTIC_UUID  "33333333-4444-5555-6666-7777abcdef01"
#define SEARCH_CHARACTERISTIC_UUID "44444444-5555-6666-7777-8888abcdef01"


class BLEManager {
public:
    void init();
    void update();
    void sendToApp(const String& msg, const String& characteristicUUID);

private:
    BLEServer* pServer;

    // 각 특성 포인터
    BLECharacteristic* ledCharacteristic;
    BLECharacteristic* fanCharacteristic;
    BLECharacteristic* mp3Characteristic;
    BLECharacteristic* tempCharacteristic;
    BLECharacteristic* searchCharacteristic;

    static void onWrite(BLECharacteristic* pCharacteristic);
};
