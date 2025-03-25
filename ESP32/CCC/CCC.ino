#include "RouterInitializer.h"
#include "HeaderInstance.h"

void setup() {
  // 시리얼 디버깅 시작
  Serial.begin(115200);
  delay(1000);
  Serial.println("[시스템] CCC 초기화 시작...");

  // 핸들러 등록 (BLE UUID + UART 키워드)
  registerAllHandlers();

  // BLE 및 UART 초기화
  bleManager.init();
  uartManager.init();

  Serial.println("[시스템] CCC 초기화 완료");
}

void loop() {
  // loop는 비워두거나 타이머/센서 등 확장 기능을 넣을 수 있음
  bleManager.update();
  delay(10);
}
