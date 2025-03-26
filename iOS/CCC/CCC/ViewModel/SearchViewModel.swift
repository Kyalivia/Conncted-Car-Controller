import Foundation
import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var isSearchSheetPresented: Bool = false
    @Published var searchText: String = ""
    @Published var searchResultMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        BluetoothService.shared.$searchResultResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result == "NAV:FAIL" {
                    self?.searchResultMessage = "주소를 다시 확인해주세요."
                } else if result.hasPrefix("NAV:OK=") {
                    let city = result.replacingOccurrences(of: "NAV:OK=", with: "")
                    self?.searchResultMessage = "\(city)로 주소를 설정합니다."
                }
            }
            .store(in: &cancellables)
    }


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
            
            BluetoothService.shared.sendCommand(command: "NAV:0", characteristicUUID: Constants.searchCharacteristicUUID)
            isSearchSheetPresented = false
        }
    }

}
