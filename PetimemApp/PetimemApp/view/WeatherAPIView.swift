//
//  WeatherAPIView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-06.
//

import SwiftUI


struct WeatherAPIView: View {
    @State private var city: String = ""
        @State private var weatherDescription: String = "Enter a city to check the weather."
        @StateObject private var viewModel = WeatherViewModel()

        var body: some View {
            NavigationView {
                VStack {
                    TextField("Enter city name", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Check Weather") {
                        Task {
                            await checkWeather()
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)

                    Text(weatherDescription)
                        .padding()
                                    
                    Text("Temperature: \(viewModel.temperature)")
                    Text("Condition: \(viewModel.weatherCondition)")
                }
                .navigationTitle("Walk Day Checker")
            }
        }
        
        private func checkWeather() async {
            do {
                let weatherData = try await viewModel.fetchCurrentWeather(forCity: city)
                let goodForWalk = viewModel.isGoodWeatherForWalk(weatherData: weatherData)
                weatherDescription = goodForWalk ? "Good day for a walk.Let's go!" : "Oh, let's play indoors today!"
            } catch {
                weatherDescription = "Failed to fetch weather."
            }
        }
}

#Preview {
    WeatherAPIView()
}
