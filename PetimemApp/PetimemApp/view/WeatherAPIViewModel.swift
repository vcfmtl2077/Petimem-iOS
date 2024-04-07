//
//  WeatherAPIViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-06.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp: Double
    }
}

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = ""
    @Published var weatherCondition: String = ""
    @Published var weatherIcon: String = ""

    func fetchCurrentWeather(forCity city: String) async throws -> WeatherData {
        let apiKey = "c7085cac54130397c97481f549d20aa6"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            fatalError("Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        DispatchQueue.main.async {
                   self.temperature = "\(weatherData.main.temp)°C"
                   self.weatherCondition = weatherData.weather.first?.main ?? "Not Available"
                   self.weatherIcon = weatherData.weather.first?.icon ?? ""
               }
        return weatherData
    }
    
    
    func isGoodWeatherForWalk(weatherData: WeatherData) -> Bool {
        let mainWeatherCondition = weatherData.weather.first?.main ?? ""
        let temperature = weatherData.main.temp
        
        //conditions: not raining and between 10°C and 25°C
        return !mainWeatherCondition.contains("Rain") && (10...25).contains(temperature)
    }
}
