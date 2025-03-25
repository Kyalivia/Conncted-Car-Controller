#include "RouterInitializer.h"
#include "BLEManager.h"
#include "CentralCommandRouter.h"
#include "HeaderInstance.h"
CentralCommandRouter centralCommandRouter;


void registerAllHandlers() {
    // BLE 통신용 UUID → 핸들러
    bleUUIDRouter.registerHandler(TEMP_CHARACTERISTIC_UUID, &centralCommandRouter);
    bleUUIDRouter.registerHandler(LED_CHARACTERISTIC_UUID, &centralCommandRouter);
    bleUUIDRouter.registerHandler(FAN_CHARACTERISTIC_UUID, &centralCommandRouter);
    bleUUIDRouter.registerHandler(MP3_CHARACTERISTIC_UUID, &centralCommandRouter);
    bleUUIDRouter.registerHandler(SEARCH_CHARACTERISTIC_UUID, &centralCommandRouter);
    
    // UART 통신용 키워드 → 핸들러 ✅ 추가
    uartCommandRouter.registerHandler("LED", &centralCommandRouter);
    uartCommandRouter.registerHandler("NAV", &centralCommandRouter);
    uartCommandRouter.registerHandler("TEM", &centralCommandRouter);
    uartCommandRouter.registerHandler("MP3", &centralCommandRouter);
    uartCommandRouter.registerHandler("FAN", &centralCommandRouter);
}
