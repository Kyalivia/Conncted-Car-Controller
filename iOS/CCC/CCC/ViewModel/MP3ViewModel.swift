import Foundation
import Combine

class MP3ViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var volumeLevel: Int = 0  // 🔊 0 ~ 6 단계
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeVolumeData()
    }
    
    enum MP3Command: String, CaseIterable {
        case play = "1"
        case stop = "0"
        case random = "r"
        case previous = "p"
        case next = "n"
        case volumeUp = "u"
        case volumeDown = "d"
        case getVolume = "s"
        
        var systemImage: String {
            switch self {
            case .play: return "play.fill"
            case .stop: return "stop.fill"
            case .random: return "shuffle"
            case .previous: return "backward.fill"
            case .next: return "forward.fill"
            case .volumeUp: return "speaker.wave.3.fill"
            case .volumeDown: return "speaker.wave.1.fill"
            case .getVolume: return "chart.bar.fill"
            }
        }
    }
    
    func sendCommand(_ command: MP3Command) {
        let formatted = "MP3:\(command.rawValue)"
        BluetoothService.shared.sendCommand(command: formatted, characteristicUUID: Constants.mp3CharacteristicUUID)
        
        switch command {
        case .play:
            isPlaying = true
            requestVolume() // 🔸 플레이 시 최초 1회 요청
        case .stop:
            isPlaying = false
            volumeLevel = 0 // 🔸 정지 시 리셋
        case .volumeUp:
            if isPlaying && volumeLevel < 7 {
                volumeLevel += 1
            }
        case .volumeDown:
            if isPlaying && volumeLevel > 0 {
                volumeLevel -= 1
            }
        default:
            break
        }
    }
    
    private func requestVolume() {
           sendCommand(.getVolume)  // MP3:S 명령 전송
       }
    
    private func observeVolumeData() {
        BluetoothService.shared.$receivedMP3Data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if message.hasPrefix("MP3:") {
                    let value = message.replacingOccurrences(of: "MP3:", with: "")
                    if let intVal = Int(value), (0...6).contains(intVal) {
                        self.volumeLevel = intVal
                    }
                }
            }
            .store(in: &cancellables)
    }
}
