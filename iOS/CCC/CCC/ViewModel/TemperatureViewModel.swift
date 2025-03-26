import Foundation
import SwiftUI
import Combine

class TemperatureViewModel: ObservableObject {
    @Published var currentTemperature: String = "연결이 필요합니다"
    @Published var oneTimeCheck : Bool = false
    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        bluetoothService.$receivedTemperature
            .receive(on: DispatchQueue.main)
            .map { "\($0)°C" }
            .assign(to: \.currentTemperature, on: self)
            .store(in: &cancellables)

        // ✅ notify 완료되면 온도 요청
        bluetoothService.$isTempNotifyReady
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.fetchTemperature()
            }
            .store(in: &cancellables)
    }

    func fetchTemperature() {
        bluetoothService.sendCommand(
            command: "TEM:1",
            characteristicUUID: Constants.tempCharacteristicUUID
        )
    }
}
