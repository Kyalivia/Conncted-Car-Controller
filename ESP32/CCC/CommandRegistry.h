#pragma once

#include <map>
#include <Arduino.h>
#include "CommandHandler.h"

class CommandRegistry {
private:
    std::map<String, CommandHandler*> registry;
public:
    void registerHandler(const String& keyword, CommandHandler* handler) {
        registry[keyword] = handler;
    }
    CommandHandler* getHandler(const String& keyword) {
        if (registry.count(keyword)) return registry[keyword];
        return nullptr;
    }
};
