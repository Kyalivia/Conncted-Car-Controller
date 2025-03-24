#include "BLEManager.h"
#include "LEDController.h"
#include "CommandRegistry.h"
#include "HandlerRegistry.h"
// BLE UUID 설정 (서비스 UUID 하나, 특성 UUID 개별 설정)
//#define SERVICE_UUID "12345678-1234-5678-1234-56789abcdef0"

#define SERVICE_UUID        "12345678-1234-5678-1234-56789abcdef0"
#define LED_CHARACTERISTIC_UUID "87654321-4321-6789-4321-6789abcdef01"

extern HandlerRegistry handlerRegistry;
extern CommandRegistry commandRegistry;
BLEServer* pServer = NULL;

// BLE 데이터 수신 콜백
class MyCharacteristicCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic* pCharacteristic) {
        String characteristicUUID = pCharacteristic->getUUID().toString().c_str();
        String command = pCharacteristic->getValue();

        Serial.println("[BLE] 데이터 수신 - 특성: " + characteristicUUID + " / 명령: " + command);

        // 특성 UUID에 따라 적절한 컨트롤러 호출
        CommandHandler* handler = handlerRegistry.getHandler(characteristicUUID);
        if (handler) {
            handler->handleCommand(command);
        } else {
            Serial.println("[BLE] 등록되지 않은 UUID입니다.");
        }
    }
};

void BLEManager::init() {
    BLEDevice::init("ESP32-BLE-WoonKwan");
    BLEDevice::getAdvertising()->stop();
    pServer = BLEDevice::createServer();

    BLEService *pService = pServer->createService(SERVICE_UUID);

    ledCharacteristic = pService->createCharacteristic(
        LED_CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE
    );
    ledCharacteristic->setCallbacks(new MyCharacteristicCallbacks());


    pService->start();

    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    BLEDevice::startAdvertising();
    
    Serial.println("[BLE] ESP32 BLE 서버 시작됨...");
}

//앱에 데이터 전송 , LED 예시
void BLEManager::sendToApp(const String& msg) {
    ledCharacteristic->setValue(msg);
    ledCharacteristic->notify();

    Serial.print("[BLE] SwiftUI에 LED 상태 전송: ");
    Serial.println(msg);
}

void BLEManager::update() {
    static bool oldDeviceConnected = false;
    bool deviceConnected = pServer->getConnectedCount() > 0;

    if (oldDeviceConnected && !deviceConnected) {
        delay(500);
        pServer->startAdvertising();
        Serial.println("[BLE] BLE 광고 다시 시작됨...");
    }

    oldDeviceConnected = deviceConnected;
}

