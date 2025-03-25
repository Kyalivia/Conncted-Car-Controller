#pragma once
#include <Arduino.h>

class BaseCommandHandler {
public:
    virtual void handleSendCommand(const String& command) = 0;
    virtual void handleReceiveCommand(const String& command) = 0;
};

