#include "BLEManager.h"
#include "HeaderInstance.h"

class MyCharacteristicCallbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic* pCharacteristic) override {
        String uuid = pCharacteristic->getUUID().toString().c_str();
        String command = pCharacteristic->getValue();

        Serial.println("[BLE] 수신 - UUID: " + uuid + " / 명령: " + command);

        BaseCommandHandler* handler = bleUUIDRouter.getHandler(uuid);
        if (handler) {
            handler->handleSendCommand(command);
        } else {
            Serial.println("[BLE] 등록되지 않은 UUID입니다.");
        }
    }
};

void BLEManager::init() {
    BLEDevice::init("Group1 G70");
    BLEDevice::getAdvertising()->stop();
    pServer = BLEDevice::createServer();

    BLEService *pService = pServer->createService(SERVICE_UUID);

    ledCharacteristic = pService->createCharacteristic(LED_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
    fanCharacteristic = pService->createCharacteristic(FAN_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
    mp3Characteristic = pService->createCharacteristic(MP3_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
    tempCharacteristic = pService->createCharacteristic(TEMP_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
    searchCharacteristic = pService->createCharacteristic(SEARCH_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

    ledCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
    fanCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
    mp3Characteristic->setCallbacks(new MyCharacteristicCallbacks());
    tempCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
    searchCharacteristic->setCallbacks(new MyCharacteristicCallbacks());

    pService->start();

    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    BLEDevice::startAdvertising();

    Serial.println("[BLE] ESP32 BLE 서버 시작됨...");
}

void BLEManager::sendToApp(const String& msg, const String& characteristicUUID) {
    BLECharacteristic* target = nullptr;

    if (characteristicUUID == LED_CHARACTERISTIC_UUID) target = ledCharacteristic;
    else if (characteristicUUID == FAN_CHARACTERISTIC_UUID) target = fanCharacteristic;
    else if (characteristicUUID == MP3_CHARACTERISTIC_UUID) target = mp3Characteristic;
    else if (characteristicUUID == TEMP_CHARACTERISTIC_UUID) target = tempCharacteristic;
    else if (characteristicUUID == SEARCH_CHARACTERISTIC_UUID) target = searchCharacteristic;

    if (target) {
        target->setValue(msg);
        target->notify();

        Serial.print("[BLE] 앱으로 데이터 전송: ");
        Serial.println(msg);
    } else {
        Serial.println("[BLE] 알 수 없는 특성 UUID입니다.");
    }
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
