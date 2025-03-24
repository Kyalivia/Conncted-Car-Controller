#pragma once

#include "HandlerRegistry.h"
#include "CommandRegistry.h"

#include "LEDController.h"


extern LEDController ledController;

extern HandlerRegistry handlerRegistry;    // BLE용
extern CommandRegistry commandRegistry;    // UART용 ✅ 추가

void registerAllHandlers();
