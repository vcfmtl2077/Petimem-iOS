//
//  EventListView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-08.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class EventListViewModel: ObservableObject {
    @Published private(set) var poopEvents: [DBPoop] = []
    
    
    func loadPoopEvents(forPetId petId: String) async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        do {
            
            let fetchedEvents = try await PoopEventManager.shared.getPoopEvents(forPetId: petId)
            self.poopEvents = fetchedEvents.sorted { $0.dateAndTime > $1.dateAndTime }
        } catch {
            print("Error fetching poop events: \(error)")
        }
    }
}

struct EventListView: View {
    let petId: String
    @StateObject private var viewModel = EventListViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                  .ignoresSafeArea()
                ScrollView {
                    VStack {
                        ForEach(viewModel.poopEvents) { PoopEvent in
                            NavigationLink(destination: Text("Edit View Placeholder")) {
                                PoopEventCardView(poop: PoopEvent)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .navigationTitle("Poop Events")
                    .onAppear {
                        Task {
                            await viewModel.loadPoopEvents(forPetId: petId)
                        }
                    }
                }
            }
        }
    }
}

