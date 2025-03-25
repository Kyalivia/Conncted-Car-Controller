# ESP 통신 아키텍처 및 모듈화

상태: 시작 전
태그: 정운관

# 📘 ESP32 BLE-UART 통신 아키텍처 및 모듈화 설명

이 문서는 ESP32와 STM32 간 BLE-UART 기반 스마트 제어 시스템을 위한 구조 및 파일별 역할, 그리고 각 모듈을 분리한 이유를 설명합니다.

---

## 📁 최신 디렉토리 구조

```
📁 /ESP32/CCC
├── CCC.ino                         ← 메인 진입점 (setup/loop)
│
├── BLEManager.h / .cpp            ← BLE 초기화, 수신 처리, 앱으로 응답 전송
├── UARTManager.h / .cpp           ← UART 초기화, STM32와 데이터 송수신
│
├── BaseCommandHandler.h           ← 모든 핸들러가 상속하는 인터페이스
├── CentralCommandRouter.h / .cpp  ← BLE → STM, STM → BLE 명령 처리 핵심 로직
│
├── BLEUUIDRouter.h                ← BLE UUID → 핸들러 매핑 라우터
├── UARTCommandRouter.h            ← UART 키워드 → 핸들러 매핑 라우터
│
├── RouterInitializer.h / .cpp     ← 라우터에 UUID/키워드 등록하는 초기화 함수
├── HeaderInstance.h / .cpp        ← 전역 인스턴스(매니저/라우터/컨트롤러) 선언 및 정의

```

---

## 🔁 전체 통신 흐름 요약

```
[SwiftUI 앱]
  ↓ BLE Write (예: LED:1)
[BLEManager]
  ↓ UUID 매핑 (BLEUUIDRouter)
[CentralCommandRouter]
  ↓ UART 전송
[UARTManager]
  ↓
[STM32]

(STM32 응답: LED:O)

[UARTManager]
  ↓ 키워드 매핑 (UARTCommandRouter)
[CentralCommandRouter]
  ↓ BLE Notify
[BLEManager]
  ↓
[SwiftUI 앱]

```

---

## 🔧 모듈화 설계 철학

### ✅ 역할 기반 분리 (Responsibility Separation)

- 각 클래스는 하나의 역할에만 집중
    - BLEManager: BLE 서비스 및 수신 관리
    - UARTManager: UART 이벤트 처리 및 송신
    - CentralCommandRouter: 명령 파싱 및 처리
    - BLEUUIDRouter / UARTCommandRouter: 핸들러 매핑 전용

### ✅ 전역 인스턴스 통합 관리

- `HeaderInstance.h/cpp` 파일에서 전역 객체(`bleManager`, `commandRouter` 등)를 선언/정의
- 모든 모듈은 `#include "HeaderInstance.h"`만으로 접근 가능

---

## ⚙️ 주요 컴포넌트 설명

| 컴포넌트 | 설명 |
| --- | --- |
| `BLEManager` | BLE 초기화, 특성 생성, 데이터 수신 시 콜백 호출, notify 전송 |
| `UARTManager` | UART 초기화 및 이벤트 수신, 수신 메시지를 파싱 후 라우터에 전달 |
| `CentralCommandRouter` | 실제 명령 전송/응답 처리 (BLE → STM, STM → BLE) |
| `BLEUUIDRouter` | UUID 기준으로 핸들러를 매핑하여 BLE 명령 분기 처리 |
| `UARTCommandRouter` | 명령 키워드 기준으로 핸들러 매핑하여 UART 수신 분기 처리 |
| `BaseCommandHandler` | 모든 핸들러가 상속하는 추상 인터페이스 (확장 가능성 고려) |
| `RouterInitializer` | BLE / UART용 UUID 및 키워드 등록을 한 곳에서 관리 |
| `HeaderInstance` | 모든 전역 인스턴스를 한 파일에서 정의/선언하여 중복 제거 |

---

## 📦 구조적 장점

| 항목 | 설명 |
| --- | --- |
| ✅ 단방향 흐름 | BLE → ESP32 → STM32 또는 반대 방향 모두 명확하게 처리 |
| ✅ 역할 분리 | 통신, 명령처리, 라우팅 등 모듈 별 기능 독립 |
| ✅ 유지보수성 | 파일 단위로 로직 분리 → 수정 영향 최소화 |
| ✅ 확장성 | UUID/키워드만 추가하면 새로운 기능 쉽게 추가 |
| ✅ 테스트 가능성 | 각 컴포넌트 단위 테스트 용이 (BLE/UART 모킹 가능) |
| ✅ 전역 객체 통합 | `HeaderInstance`로 extern 중복 제거 및 일관성 확보 |

---

## ✨ 예시 사용 흐름

```cpp
// BLE 수신 시
MyCharacteristicCallbacks::onWrite() {
    String uuid = ...;
    String command = ...;

    auto handler = bleUUIDRouter.getHandler(uuid);
    handler->handleSendCommand(command);  // → CentralCommandRouter 호출됨
}

// STM 수신 시
UARTManager::uartEventTask() {
    String msg = ...;
    auto handler = uartCommandRouter.getHandler("LED");
    handler->handleReceiveCommand(msg);   // → CentralCommandRouter 호출됨
}

```

---

## 🔮 향후 확장 계획

- UUID 별 BLE notify 전용 핸들러 분기 개선
- 기능별 전용 핸들러 분리 가능성 (`LEDHandler`, `MP3Handler`)
- 로깅 기능 또는 통신 로그 버퍼 도입
- BLE 응답 메시지 암호화/압축 처리