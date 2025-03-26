import SwiftUI

struct RemoteControlPanel: View {
    @State private var selectedTab = 0
    let fanViewModel = FanViewModel()
    let mp3ViewModel = MP3ViewModel()
    let serachViewModel = SearchViewModel()
    let tempViewModel = TemperatureViewModel()
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // 상단 탭바 스타일 선택 뷰
            HStack {
                TabButton(title: "온도", icon: "thermometer.medium", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabButton(title: "에어컨", icon: "wind", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabButton(title: "MP3", icon: "music.note.list", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                TabButton(title: "검색", icon: "magnifyingglass", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
            }

            .padding(.horizontal)
            
            // 선택된 탭에 따른 뷰 전환
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer(minLength: 0)
                    switch selectedTab {
                    case 0:
                        TemperatureView(viewModel: tempViewModel, weatherViewModel: weatherViewModel)
                    case 1:
                        FanView(viewModel: fanViewModel)
                    case 2:
                        MP3View(viewModel: mp3ViewModel)
                    case 3:
                        SearchView(viewModel: serachViewModel)

                    default:
                        EmptyView()
                    }
                    Spacer(minLength: 0)
                }
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

