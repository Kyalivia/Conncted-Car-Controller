import Foundation
import Combine
import SwiftUI


class MainViewModel: ObservableObject {
    @Published var isBluetoothOn: Bool = false
    @Published var isDeviceConnected: Bool = false
    @Published var isConnecting: Bool = false
    @Published var selectedDevice: BLEDevice? = nil
    @Published var showConnectAlert: Bool = false

    private var bluetoothService = BluetoothService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        observeBluetoothState()
        observeConnectionState()
    }

    // 🔄 블루투스 상태 감지
    private func observeBluetoothState() {
        bluetoothService.$isBluetoothOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isBluetoothOn, on: self)
            .store(in: &cancellables)
    }

    // 🔄 연결 상태 감지 → 끊기면 뷰 해제
    private func observeConnectionState() {
        bluetoothService.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                if !connected {
                    withAnimation {
                        self?.isDeviceConnected = false
                        self?.isConnecting = false
                    }
                }
            }
            .store(in: &cancellables)
    }

    // ✅ BLE 검색 시작
    func toggleBluetooth(_ isOn: Bool) {
        if isOn {
            bluetoothService.startScanning()
        } else {
            bluetoothService.stopScanning()
            bluetoothService.disconnect()
            isDeviceConnected = false
            isConnecting = false
        }
    }

    // ✅ 연결 시도
    func connectToDevice() {
        guard let device = selectedDevice else { return }

        isConnecting = true
        bluetoothService.connect(to: device)

        let startTime = Date()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }

            let elapsed = Date().timeIntervalSince(startTime)
            if self.bluetoothService.isConnected && elapsed >= 1.0 {
                timer.invalidate()
                withAnimation {
                    self.isDeviceConnected = true
                    self.isConnecting = false
                }
            } else if elapsed >= 5.0 {
                timer.invalidate()
                withAnimation {
                    self.isConnecting = false
                }
            }
        }
    }
}
