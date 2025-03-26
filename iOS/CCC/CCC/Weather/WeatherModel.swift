import Foundation

// OpenWeatherMap의 JSON 응답 중 일부만 모델링 (필요 시 확장 가능)
struct WeatherResponse: Codable {
    let name: String        // 도시 이름
    let main: MainWeather
    let weather: [Weather]
}

struct MainWeather: Codable {
    let temp: Double        // 현재 온도
    let humidity: Int       // 습도
}

struct Weather: Codable {
    let description: String
    let icon: String        
}
