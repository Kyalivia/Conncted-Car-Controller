import SwiftUI

struct FanView: View {
    @StateObject private var viewModel = FanViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Image(systemName: viewModel.iconName)
                .resizable()
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(viewModel.currentFanLevel == .off ? 0 : viewModel.rotationAngle))
                .animation(viewModel.currentFanLevel == .off ? .none : .linear(duration: viewModel.rotationSpeed), value: viewModel.rotationAngle)
                .foregroundColor(.white)
            
            Slider(value: $viewModel.sliderValue, in: 0...3, step: 1)
                .accentColor(.blue)
                .onChange(of: viewModel.sliderValue) {
                    viewModel.setFanLevelFromSlider(Int(viewModel.sliderValue))
                }
            
            Text("현재 단계: \(viewModel.currentFanLevel.description)")
                .foregroundColor(.white)
        }
        .padding()
    }
}

