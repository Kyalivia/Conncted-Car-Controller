#pragma once
#include <Arduino.h>

class CommandHandler {
public:
    virtual void handleCommand(const String& command) = 0;
};

