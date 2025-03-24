import SwiftUI

struct RemoteControlPanel: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // 상단 탭바 스타일 선택 뷰
            HStack {
                TabButton(title: "LED", icon: "lightbulb", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabButton(title: "에어컨", icon: "thermometer.sun", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabButton(title: "MP3", icon: "fanblades", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal)
            
            // 선택된 탭에 따른 뷰 전환
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer(minLength: 0)
                    switch selectedTab {
                    case 0:
                        LEDView()
                    case 1:
                        Text("온습도 센서 뷰")
                            .foregroundColor(.white)
                    case 2:
                        Text("팬 제어 뷰")
                            .foregroundColor(.white)
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

