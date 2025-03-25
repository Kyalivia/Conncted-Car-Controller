#pragma once

#include <map>
#include <Arduino.h>
#include "BaseCommandHandler.h"
#include "HeaderInstance.h"

class UARTCommandRouter {
private:
    std::map<String, BaseCommandHandler*> registry;
public:
    void registerHandler(const String& keyword, BaseCommandHandler* handler) {
        registry[keyword] = handler;
    }
    BaseCommandHandler* getHandler(const String& keyword) {
        if (registry.count(keyword)) return registry[keyword];
        return nullptr;
    }
};
