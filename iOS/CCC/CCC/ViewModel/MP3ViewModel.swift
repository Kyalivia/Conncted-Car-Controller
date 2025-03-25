import Foundation

class MP3ViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    enum MP3Command: String, CaseIterable {
        case play = "1"
        case stop = "0"
        case random = "r"
        case previous = "p"
        case next = "n"
        case volumeUp = "u"
        case volumeDown = "d"
        
        var systemImage: String {
            switch self {
            case .play: return "play.fill"
            case .stop: return "stop.fill"
            case .random: return "shuffle"
            case .previous: return "backward.fill"
            case .next: return "forward.fill"
            case .volumeUp: return "speaker.wave.3.fill"
            case .volumeDown: return "speaker.wave.1.fill"
            }
        }
    }
    
    func sendCommand(_ command: MP3Command) {
        let formatted = "MP3:\(command.rawValue)"
        BluetoothService.shared.sendCommand(command: formatted, characteristicUUID: Constants.mp3CharacteristicUUID)
        
        // 상태 토글
        switch command {
        case .play:
            isPlaying = true
        case .stop:
            isPlaying = false
        default:
            break
        }
    }
}
