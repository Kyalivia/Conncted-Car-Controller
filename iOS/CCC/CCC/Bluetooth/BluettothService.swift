import Foundation
import CoreBluetooth

protocol BluetoothServiceDelegate: AnyObject {
    func didUpdateBluetoothState(isOn: Bool)
    func didDiscoverDevice(device: BLEDevice)
    func didConnectToDevice(device: BLEDevice)
    func didDisconnectFromDevice()
    func didUpdateLEDStatus(isOn: Bool)
}

final class BluetoothService: NSObject, ObservableObject {
    
    static let shared = BluetoothService() // ✅ 싱글톤
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    // ✅ 외부에서 구독할 수 있도록 상태 제공
    @Published var isBluetoothOn = false
    @Published var isConnected = false
    @Published var discoveredDevices: [BLEDevice] = []
    @Published var connectedDeviceName: String?
    
    // 구독해야하는 수신 데이터들
    @Published var receivedTemperature: String = "--"
    @Published var ledStatus: Bool = false
    @Published var isTempNotifyReady = false
    @Published var receivedMP3Data: String = ""
    @Published var searchResultResponse: String = ""
    @Published var receivedFANData: String = ""
    
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public Methods
    
    func startScanning() {
        guard isBluetoothOn else {
            print("⚠️ 블루투스 꺼져 있음")
            return
        }
        print("🔍 BLE 스캔 시작")
        let serviceUUID = CBUUID(string: Constants.serviceUUID)
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func stopScanning() {
        print("🛑 BLE 스캔 중지")
        discoveredDevices.removeAll()
        centralManager.stopScan()
    }
    
    func connect(to device: BLEDevice) {
        print("🔗 BLE 연결 시도: \(device.name)")
        peripheral = device.peripheral
        peripheral?.delegate = self
        centralManager.connect(device.peripheral, options: nil)
    }
    
    func disconnect() {
        guard let peripheral = peripheral else {
            print("⚠️ 연결된 기기 없음")
            return
        }
        print("🔌 BLE 연결 해제 요청")
        centralManager.cancelPeripheralConnection(peripheral)
        self.peripheral = nil
        self.isConnected = false
    }
    
    func sendCommand(command: String, characteristicUUID: String) {
        guard let peripheral = peripheral else {
            print("⚠️ peripheral이 nil 상태")
            return
        }
        
        let data = command.data(using: .utf8)!
        let uuid = CBUUID(string: characteristicUUID)
        
        for service in peripheral.services ?? [] {
            for characteristic in service.characteristics ?? [] {
                if characteristic.uuid == uuid {
                    peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    print("🟢 명령 전송: \(command) to \(characteristicUUID)")
                    return
                }
            }
        }
        
        print("🚨 특성 \(characteristicUUID) 찾지 못함")
    }
    
}


// MARK: - CBCentralManagerDelegate
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = (central.state == .poweredOn)
        print("🔵 블루투스 상태: \(isBluetoothOn ? "ON" : "OFF")")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newDevice = BLEDevice(
            id: peripheral.identifier,
            name: peripheral.name ?? "알 수 없음",
            uuid: peripheral.identifier.uuidString,
            peripheral: peripheral
        )
        
        if !discoveredDevices.contains(where: { $0.id == newDevice.id }) {
            discoveredDevices.append(newDevice)
            print("📡 기기 발견: \(newDevice.name)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("✅ 연결 성공: \(peripheral.name ?? "알 수 없음")")
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        isConnected = true
        connectedDeviceName = peripheral.name
        peripheral.discoverServices([CBUUID(string: Constants.serviceUUID)])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("🔴 연결 해제됨")
        isConnected = false
        connectedDeviceName = nil
        discoveredDevices.removeAll()
        self.startScanning()
        self.peripheral = nil
    }
}


// MARK: - CBPeripheralDelegate
extension BluetoothService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("🚨 서비스 검색 실패: \(error.localizedDescription)")
            return
        }
        
        for service in peripheral.services ?? [] {
            if service.uuid == CBUUID(string: Constants.serviceUUID) {
                peripheral.discoverCharacteristics([CBUUID(string: Constants.ledUUID)], for: service)
                peripheral.discoverCharacteristics([CBUUID(string: Constants.fanCharacteristicUUID)], for: service)
                peripheral.discoverCharacteristics([CBUUID(string: Constants.mp3CharacteristicUUID)], for: service)
                peripheral.discoverCharacteristics([CBUUID(string: Constants.searchCharacteristicUUID)], for: service)
                peripheral.discoverCharacteristics([CBUUID(string: Constants.tempCharacteristicUUID)], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("🚨 특성 검색 실패: \(error.localizedDescription)")
            return
        }
        
        for characteristic in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: characteristic)
            print("✅ \(characteristic.uuid) Notify 등록 완료")
            if self.isTempNotifyReady == false && characteristic.uuid == CBUUID(string: Constants.tempCharacteristicUUID) {
                DispatchQueue.main.async {
                    self.isTempNotifyReady = true
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value,
              let message = String(data: value, encoding: .utf8) else { return }
        
        print("📡 수신 데이터: \(message)")
        
        if message.hasPrefix("TEM:") {
            let tempValue = message.replacingOccurrences(of: "TEM:", with: "")
            DispatchQueue.main.async {
                self.receivedTemperature = tempValue
            }
        } else if message.hasPrefix("MP3:") {
            DispatchQueue.main.async {
                self.receivedMP3Data = message
            }
        } else if message.hasPrefix("NAV:") {
            DispatchQueue.main.async {
                self.searchResultResponse = message
            }
        } else if message.hasPrefix("FAN:") {
            DispatchQueue.main.async {
                self.receivedFANData = message
            }
        }
        // LED, NAV 등의 분기는 위에 계속 추가
    }
    
}
