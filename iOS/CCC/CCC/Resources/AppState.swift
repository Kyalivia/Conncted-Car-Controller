// AppState.swift
import Foundation

class AppState: ObservableObject {
    @Published var fanViewModel = FanViewModel()
    @Published var mp3ViewModel = MP3ViewModel()
    // 추후 에어컨, 검색 등 추가 가능
}
