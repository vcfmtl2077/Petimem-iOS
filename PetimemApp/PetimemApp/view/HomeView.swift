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
                print("Fetched pets: \(fetchedPets)")
            }
        } catch {
            print("Error fetching pets: \(error)")
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showingAddNewPetView = false

    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    VStack{
                        ForEach(viewModel.pets) { pet in
                            NavigationLink{
                                Text("event view")
                            } label: {
                                PetCardView(pet: pet)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Button("Add Your Pet"){
                            showingAddNewPetView = true
                        }
                        .foregroundColor(.white)
                        .frame(width: 330, height: 55)
                        .background(Color("buttonAddColor"))
                        .cornerRadius(20)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Pets")
            .task {
                            await viewModel.getPets()
                        }
        }
        
        NavigationLink(destination: AddNewPetView(), isActive: $showingAddNewPetView) {
                            EmptyView()
                        }.hidden()
    }
}

/*#Preview {
    HomeView(userId: "20CDQsq8YHbmidqxQXHZGttbIT92")
}*/
