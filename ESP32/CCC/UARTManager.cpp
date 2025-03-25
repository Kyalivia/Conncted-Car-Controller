#include "UARTManager.h"
#include "driver/uart.h"
#include "HeaderInstance.h"

#define UART_PORT UART_NUM_1
#define STM32_RX 16
#define STM32_TX 17

QueueHandle_t uartQueue;

void UARTManager::init() {
    uart_config_t uart_config = {
        .baud_rate = 9600,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .source_clk = UART_SCLK_APB
    };

    uart_param_config(UART_PORT, &uart_config);
    uart_set_pin(UART_PORT, STM32_TX, STM32_RX, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    uart_driver_install(UART_PORT, 1024, 0, 20, &uartQueue, 0);

    xTaskCreate(uartEventTask, "uart_event_task", 4096, NULL, 12, NULL);
}

void UARTManager::uartEventTask(void* pvParameters) {
    uart_event_t event;
    uint8_t buffer[128];

    while (true) {
        if (xQueueReceive(uartQueue, &event, portMAX_DELAY)) {
            if (event.type == UART_DATA) {
                int len = uart_read_bytes(UART_PORT, buffer, event.size, portMAX_DELAY);
                buffer[len] = '\0';

                String msg = String((char*)buffer);
                msg.trim(); 

                Serial.print("[UART] 수신: ");
                Serial.println(msg);

                int sepIndex = msg.indexOf(':');
                 if (sepIndex != -1) {
                    String key = msg.substring(0, sepIndex);     // 예: LED
                    String value = msg.substring(sepIndex + 1);  // 예: 1

                    BaseCommandHandler* handler = uartCommandRouter.getHandler(key);
                    if (handler) {
                        handler->handleReceiveCommand(value);
                    } else {
                        Serial.println("[UART] 등록되지 않은 핸들러: " + key);
                    }
                } else {
                    Serial.println("[UART] 잘못된 명령 형식: " + msg);
                }
            }
        }
    }
}

void UARTManager::sendUARTToSTM(const String& msg) {
    const char* cstr = msg.c_str();
    uart_write_bytes(UART_PORT, cstr, strlen(cstr));
}