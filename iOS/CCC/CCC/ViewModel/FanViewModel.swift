import Foundation

class FanViewModel: ObservableObject {
    @Published var currentFanLevel: FanLevel = .off
    @Published var sliderValue: Double = 0
    @Published var rotationAngle: Double = 0
    
    private var timer: Timer?
    private var rotationIncrement: Double = 0
    
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
    
    deinit {
        timer?.invalidate()
    }
}
