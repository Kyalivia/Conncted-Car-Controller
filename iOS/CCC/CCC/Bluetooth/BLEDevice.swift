import Foundation
import CoreBluetooth

struct BLEDevice: Identifiable {
    let id: UUID
    let name: String
    let uuid: String
    let peripheral: CBPeripheral // BLE 기기 자체를 저장
}
