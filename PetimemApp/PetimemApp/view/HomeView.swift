//
//  HomeView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var pets: [DBPets] = []
    
    func getPets() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        do {
            let fetchedPets = try await PetManager.shared.getPets(forUserID: userID)
            DispatchQueue.main.async {
                self.pets = fetchedPets
            }
        } catch {
            print("Error fetching pets: \(error)")
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showingAddNewPetView = false
    @State private var showingWeatherAPIView = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    VStack{
                        ForEach(viewModel.pets) { pet in
                                                    NavigationLink(destination: EventListView(petId: pet.id)) {
                                                        PetCardView(pet: pet)
                                                    }
                                                }
                            
                        Button(action: {
                            showingAddNewPetView = true
                        }) {
                            Text("Add Your Pet")
                                .frame(width: 330, height: 55)
                                .foregroundColor(.white)
                                .background(Color("buttonAddColor"))
                                .cornerRadius(20)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Pets")
            .navigationDestination(isPresented: $showingAddNewPetView){
                AddNewPetView(showingAddNewPet: $showingAddNewPetView)
            }
            .task {
                await viewModel.getPets()
           }
            .toolbar{
                Button("weather", systemImage: "cloud.sun"){
                    showingWeatherAPIView = true
                }
            }
            .navigationDestination(isPresented: $showingWeatherAPIView ){
                WeatherAPIView()
            }
        }
    }
}

/*#Preview {
    HomeView(userId: "20CDQsq8YHbmidqxQXHZGttbIT92")
}*/
