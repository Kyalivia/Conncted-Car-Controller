import Foundation
import SwiftUI
struct LEDView: View {
    @StateObject private var viewModel = LEDViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("LED 제어")
                .font(.title)
                .foregroundColor(.white)
            
            Text("LED 상태: \(viewModel.isLEDOn ? "켜짐" : "꺼짐")")
                .font(.title)
                .foregroundColor(.white)
            
            Button(action: {
                viewModel.toggleLED()
            }) {
                Text("LED 토글")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            viewModel.refreshLEDStatus()
        }
    }
}
