import Foundation
import Combine

class ScanViewModel: ObservableObject {
    @Published var devices: [BLEDevice] = []
    @Published var isBluetoothOn: Bool = false
    
    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        // 발견된 기기 구독
        bluetoothService.$discoveredDevices
            .receive(on: DispatchQueue.main)
            .assign(to: \.devices, on: self)
            .store(in: &cancellables)
        
        // 블루투스 상태 구독
        bluetoothService.$isBluetoothOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isBluetoothOn, on: self)
            .store(in: &cancellables)
    }

    func startScan() {
        bluetoothService.startScanning()
    }

    func stopScan() {
        bluetoothService.stopScanning()
    }

    func connect(to device: BLEDevice) {
        bluetoothService.connect(to: device)
    }
}
