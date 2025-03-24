#include "Handlers.h"

LEDController ledController;

HandlerRegistry handlerRegistry;      // BLE용
CommandRegistry commandRegistry;      // UART용 ✅ 추가

void registerAllHandlers() {
    // BLE 통신용 UUID → 핸들러
    handlerRegistry.registerHandler("87654321-4321-6789-4321-6789abcdef0", &ledController);
    
    // UART 통신용 키워드 → 핸들러 ✅ 추가
    commandRegistry.registerHandler("LED", &ledController);
}
