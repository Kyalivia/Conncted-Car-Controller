#pragma once

#include <map>
#include <Arduino.h>
#include "CommandHandler.h"

class HandlerRegistry {
private:
    std::map<String, CommandHandler*> registry;

public:
    void registerHandler(const String& uuid, CommandHandler* handler) {
        registry[uuid] = handler;
    }

    CommandHandler* getHandler(const String& uuid) {
        if (registry.count(uuid)) return registry[uuid];
        return nullptr;
    }
};


