import Foundation
import SwiftUI
import Combine

class FanViewModel: ObservableObject {
    @Published var currentFanLevel: FanLevel = .off
    @Published var sliderValue: Double = 0
    @Published var rotationAngle: Double = 0
    
    private var timer: Timer?
    private var rotationIncrement: Double = 0
    private var cancellables = Set<AnyCancellable>()
    
    enum FanLevel: String, CaseIterable {
        case off = "0"
        case level1 = "a"
        case level2 = "b"
        case level3 = "c"
        
        var description: String {
            switch self {
            case .off: return "OFF"
            case .level1: return "1단계"
            case .level2: return "2단계"
            case .level3: return "3단계"
            }
        }
    }
    
    var iconName: String {
        return "fanblades"
    }
    
    var rotationSpeed: Double {
        switch currentFanLevel {
        case .off: return 0
        case .level1: return 1.5
        case .level2: return 1.0
        case .level3: return 0.5
        }
    }
    
    init() {
        observeFanLevelUpdates()
        requestCurrentFanState()
        startFanRotationTimer()
    }
    
    func setFanLevel(_ level: FanLevel) {
        currentFanLevel = level
        sliderValue = Double(FanLevel.allCases.firstIndex(of: level) ?? 0)
        
        switch level {
        case .off: rotationIncrement = 0
        case .level1: rotationIncrement = 1.0
        case .level2: rotationIncrement = 2.5
        case .level3: rotationIncrement = 4.0
        }
        
        let command = "FAN:\(level.rawValue)"
        BluetoothService.shared.sendCommand(command: command, characteristicUUID: Constants.fanCharacteristicUUID)
    }
    
    func setFanLevelFromSlider(_ value: Int) {
        let level = FanLevel.allCases[value]
        setFanLevel(level)
    }
    
    private func startFanRotationTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if self.currentFanLevel != .off {
                self.rotationAngle += self.rotationIncrement
            }
        }
    }
    
    func requestCurrentFanState() {
            // STM에 현재 상태 요청
            BluetoothService.shared.sendCommand(command: "FAN:s", characteristicUUID: Constants.fanCharacteristicUUID)
    }
    
    private func observeFanLevelUpdates() {
        BluetoothService.shared.$receivedFANData
            .filter { !$0.isEmpty }
            .map { fanString in
                return String(fanString.dropFirst(4)) // "FAN:x" → "x"
            }
            .sink { [weak self] value in
                self?.updateFanLevelFromReceived(value)
            }
            .store(in: &cancellables)
    }
    
    func updateFanLevelFromReceived(_ value: String) {
        if let level = FanLevel(rawValue: value) {
            currentFanLevel = level
            print("팬 레벨 수신: \(level)")
            sliderValue = Double(FanLevel.allCases.firstIndex(of: level) ?? 0)
            
            // 회전 속도도 같이 반영해야 하므로 rotationIncrement도 직접 설정
            switch level {
            case .off: rotationIncrement = 0
            case .level1: rotationIncrement = 1.0
            case .level2: rotationIncrement = 2.5
            case .level3: rotationIncrement = 4.0
            }
        } else {
            print("⚠️ 잘못된 팬 레벨 수신: \(value)")
        }
    }



    
    deinit {
        timer?.invalidate()
    }
}
