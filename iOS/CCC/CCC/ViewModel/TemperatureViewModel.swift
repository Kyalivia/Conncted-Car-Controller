import Foundation
import SwiftUI
import Combine

class TemperatureViewModel: ObservableObject {
    @Published var currentTemperature: String = "연결이 필요합니다"
    
    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        bluetoothService.$receivedTemperature
            .receive(on: DispatchQueue.main)
            .map { "\($0)°C" }
            .assign(to: \.currentTemperature, on: self)
            .store(in: &cancellables)
    }

    func fetchTemperature() {
        bluetoothService.sendCommand(
            command: "TEM:1",
            characteristicUUID: Constants.tempCharacteristicUUID
        )
    }
}
