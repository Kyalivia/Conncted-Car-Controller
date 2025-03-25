#pragma once

#include <map>
#include <Arduino.h>
#include "BaseCommandHandler.h"

class BLEUUIDRouter {
private:
    std::map<String, BaseCommandHandler*> registry;

public:
    void registerHandler(const String& uuid, BaseCommandHandler* handler) {
        registry[uuid] = handler;
    }

    BaseCommandHandler* getHandler(const String& uuid) {
        if (registry.count(uuid)) return registry[uuid];
        return nullptr;
    }
};


