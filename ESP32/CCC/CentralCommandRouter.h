#pragma once

#include "BaseCommandHandler.h"


class CentralCommandRouter : public BaseCommandHandler {
public:
    void handleSendCommand(const String& command) override;
    void handleReceiveCommand(const String& command) override;
};

