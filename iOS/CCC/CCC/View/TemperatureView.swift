import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: TemperatureViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("차량 내부 온도")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Text(viewModel.currentTemperature)
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.cyan)
                .padding()

            Button("온도 다시 요청") {
                viewModel.fetchTemperature()
            }
            .padding()
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
        .onAppear {
            viewModel.fetchTemperature() // 화면 진입 시 자동 요청
        }
    }
}
