import Foundation
import Combine
import UIKit

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "Seoul"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = ""
    @Published var humidity: String = "--"
    @Published var iconImage: UIImage?

    private let apiKey = "781b7d33ec52ebfbcb2314e37b46ab15"
    private var iconCode: String?
    private var cancellables = Set<AnyCancellable>()

    func fetchWeather() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric&lang=kr"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let result = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                return
            }

            DispatchQueue.main.async {
                self.temperature = "\(Int(result.main.temp))℃"
                self.weatherDescription = result.weather.first?.description ?? ""
                self.humidity = "\(result.main.humidity)%"
                
                let newIconCode = result.weather.first?.icon
                if let newIconCode = newIconCode, newIconCode != self.iconCode {
                    // 아이콘이 이전과 다를 때만 다시 로드
                    self.iconCode = newIconCode
                    self.loadIconImage(code: newIconCode)
                }
            }
        }.resume()
    }

    private func loadIconImage(code: String) {
        let iconURL = URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png")!
        
        URLSession.shared.dataTask(with: iconURL) { [weak self] data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.iconImage = image
            }
        }.resume()
    }
}
