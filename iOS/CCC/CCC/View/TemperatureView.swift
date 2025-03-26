import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: TemperatureViewModel
    @ObservedObject var weatherViewModel: WeatherViewModel
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 24) {

            // 🚗 차량 내부 온도 카드
            VStack(spacing: 8) {
                HStack {
                    Text("🚗 차량 내부 온도")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }

                HStack(spacing: 16) {
                    Image(systemName: "thermometer.sun")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.currentTemperature)
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)

                        Button("온도 다시 요청") {
                            viewModel.fetchTemperature()
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }

                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.cyan.opacity(1)) // 🚗 내부 카드 색상
            .cornerRadius(16)

            // 🌤 외부 날씨 카드
            VStack(spacing: 8) {
                HStack {
                    Text("🌤 외부 날씨")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(weatherViewModel.cityName)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }

                HStack(spacing: 16) {
                    if let image = weatherViewModel.iconImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        // 🔸 온도를 크게 강조
                        Text(weatherViewModel.temperature)
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.white)
                        HStack{
                            // 🔸 부가 정보: 날씨 설명 + 습도
                            Text(weatherViewModel.weatherDescription.capitalized)
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("습도: \(weatherViewModel.humidity)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                    }

                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.indigo.opacity(0.25))
            .cornerRadius(16)
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            viewModel.fetchTemperature()
            weatherViewModel.fetchWeather()
            }
        }
        .onDisappear {
                timer?.invalidate()
                timer = nil
        }
    }
}
