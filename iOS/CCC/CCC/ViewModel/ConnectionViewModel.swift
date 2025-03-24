import Foundation
import Combine

class ConnectionViewModel: ObservableObject {
    @Published var isConnected = false
    @Published var connectedDeviceName: String? = nil

    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        // 연결 상태 구독
        bluetoothService.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)

        // 연결된 디바이스 이름 구독
        bluetoothService.$connectedDeviceName
            .receive(on: DispatchQueue.main)
            .assign(to: \.connectedDeviceName, on: self)
            .store(in: &cancellables)
    }

    func disconnect() {
        bluetoothService.disconnect()
    }
}
