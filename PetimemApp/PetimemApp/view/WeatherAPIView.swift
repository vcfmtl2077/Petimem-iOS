//
//  WeatherAPIView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-06.
//

import SwiftUI


struct WeatherAPIView: View {
    @State private var city: String = ""
    @State private var weatherDescription: String = " "
    @State private var isgoodForWalk: Bool = false
    @StateObject private var viewModel = WeatherViewModel()

        var body: some View {
            NavigationStack {
                ZStack{
                    Color("bgHomeColor")
                        .ignoresSafeArea()
                    VStack(spacing: 30) {
                        ZStack{
                            Rectangle()
                                .frame(width: 350, height: 200)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                                .foregroundStyle(Color("bgColor"))
                            VStack(alignment: .leading, spacing: 10) {
                                Text(weatherDescription)
                                    .font(.title2)
                                    .foregroundColor(Color(isgoodForWalk ? "safeGreen" : "warningRed"))
                                    .fontWeight(.bold)
                                
                                HStack{ 
                                    Text("Temperature: \(viewModel.temperature)")
                                        .bold()
                                        .foregroundColor(Color("buttonAddColor"))
                                    Text("Condition: \(viewModel.weatherCondition)")
                                        .bold()
                                        .foregroundColor(Color("buttonAddColor"))
                                }
                            }
                        }
                        .frame(width: 280,height: 200)
                        
                        HStack{
                        TextField("Enter your city", text: $city)
                            .autocapitalization(.none)
                            .padding()
                            .frame(width: 270, height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke( Color.blue)
                            )
                        
                        Button("Check") {
                            Task {
                                await checkWeather()
                            }
                        }
                        .disabled(city.isEmpty)
                        .opacity(city.isEmpty ? 0.5 : 1)
                        .frame(width: 70, height: 40)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        }
                        Spacer()
                    }
                    
                }
                .navigationTitle("Walk Day Checker")
            }
        }
        
        private func checkWeather() async {
            do {
                let weatherData = try await viewModel.fetchCurrentWeather(forCity: city)
                let goodForWalk = viewModel.isGoodWeatherForWalk(weatherData: weatherData)
                isgoodForWalk = goodForWalk
                weatherDescription = goodForWalk ? "Good day for a walk.Let's go!" : "Oh, let's play indoors today!"
            } catch {
                weatherDescription = "oops, something went wrong. Please try again!"
            }
        }
}

#Preview {
    WeatherAPIView()
}
