import Foundation
import Combine

class LEDViewModel: ObservableObject {
    @Published var isLEDOn = false
    @Published var isConnected = false
    
    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()  // 구독을 저장할 공간
    
    init() {
        // BluetoothService의 ledStatus를 구독
        bluetoothService.$ledStatus
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLEDOn, on: self)
            .store(in: &cancellables)
        
        // 연결 상태도 구독
        bluetoothService.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)
    }
    
    // LED 상태 전환 요청
    func toggleLED() {
        isLEDOn = isLEDOn ? false : true
        let command = isLEDOn ? "LED:0" : "LED:1"
        bluetoothService.sendCommand(command: command, characteristicUUID: Constants.ledUUID)
    }

    // LED 상태 요청
    func refreshLEDStatus() {
        bluetoothService.sendCommand(command: "LED:2", characteristicUUID: Constants.ledUUID)
    }
}
