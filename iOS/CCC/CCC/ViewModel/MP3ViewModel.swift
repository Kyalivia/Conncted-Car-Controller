import Foundation
import Combine

class MP3ViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var volumeLevel: Int = 0      // 🔊 0 ~ 6 단계
    @Published var trackNumber: Int = 1      // 🎵 현재 트랙 번호

    private var cancellables = Set<AnyCancellable>()

    init() {
        observeMP3Data()
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
            requestVolume()
        case .stop:
            isPlaying = false
            volumeLevel = 0
        case .volumeUp:
            if isPlaying && volumeLevel < 6 {
                volumeLevel += 1
            }
        case .volumeDown:
            if isPlaying && volumeLevel > 0 {
                volumeLevel -= 1
            }
        case .next:
            requestVolume()
        case .previous:
            requestVolume()
        case .random:
            requestVolume()
            
        default:
            break
        }
    }

    private func requestVolume() {
        sendCommand(.getVolume)
    }

    private func observeMP3Data() {
        BluetoothService.shared.$receivedMP3Data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                guard message.hasPrefix("MP3:") else { return }

                let payload = message.replacingOccurrences(of: "MP3:", with: "")
                let parts = payload.components(separatedBy: "&")

                if parts.count == 2,
                   let vol = Int(parts[0]),
                   let track = Int(parts[1]),
                   (0...6).contains(vol) {

                    self.volumeLevel = vol
                    self.trackNumber = track
                }
            }
            .store(in: &cancellables)
    }
}
