#pragma once
#define LED_CONTROLLER_H

#include "CommandHandler.h"

class LEDController : public CommandHandler {
public:
    void handleCommand(const String& command) override;
};

