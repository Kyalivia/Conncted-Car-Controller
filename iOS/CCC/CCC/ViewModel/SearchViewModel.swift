import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var isSearchSheetPresented: Bool = false
    @Published var searchText: String = ""

    func startSearch() {
        isSearchSheetPresented = true
        searchText = ""
        BluetoothService.shared.sendCommand(command: "NAV:1", characteristicUUID: Constants.searchCharacteristicUUID)
    }

    func endSearch() {
        isSearchSheetPresented = false
        BluetoothService.shared.sendCommand(command: "NAV:0", characteristicUUID: Constants.searchCharacteristicUUID)
    }

    func sendSearchText() {
        Task {
            for char in searchText {
                let lowercaseChar = String(char).lowercased()
                let command = "NAV:\(lowercaseChar)"
                BluetoothService.shared.sendCommand(command: command, characteristicUUID: Constants.searchCharacteristicUUID)
                try? await Task.sleep(nanoseconds: 50_000_000)
            }
            endSearch()
            isSearchSheetPresented = false
        }
    }

}
