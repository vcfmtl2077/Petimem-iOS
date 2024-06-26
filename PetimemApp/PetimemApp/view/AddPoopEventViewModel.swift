//
//  AddPoopEventViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-07.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseAuth

struct DBPoop: Codable,Identifiable {
    let id: String
    let dateAndTime: Date
    let consistency: String
    let color: String
    let bloodOrMucus: Bool
    let foreignObjects: Bool
    let tint: String
    let petId: String
    
    init(id: String, dateAndTime: Date, consistency: String, color: String, bloodOrMucus: Bool, foreignObjects: Bool, tint: String, petId: String) {
        self.id = id
        self.dateAndTime = dateAndTime
        self.consistency = consistency
        self.color = color
        self.bloodOrMucus = bloodOrMucus
        self.foreignObjects = foreignObjects
        self.tint = tint
        self.petId = petId
    }
}

@MainActor
class AddPoopEventViewModel: ObservableObject {
    @Published var dateAndTime: Date = .now
    @Published var consistency: String = "Select"
    @Published var color: String = "Select"
    @Published var bloodOrMucus: Bool = false
    @Published var foreignObjects: Bool = false
    @Published var tint: String = "expenseCardColor"
    @Published var selectedPetId: String = ""
    
    @Published var alertMessage = ""
    @Published var isPoopAddedSuccessfully = false
    
// -----------------------------------------------for updates-----------------------------------------
    var poopEventToEdit: DBPoop?
    
    func addPoopEvent() async {

        guard validate() else{
            return
        }
        
//----------------------------------------------get current userId-----------------------------------
        guard let userId = Auth.auth().currentUser?.uid else {
                alertMessage = "Authentication Error. Please sign in."
                return
            }
        
// ---------------------------------------------create model-----------------------------------------
        let newId = UUID().uuidString
        let newPoopEvent = DBPoop(
            id: newId,
            dateAndTime: dateAndTime,
            consistency: consistency,
            color: color,
            bloodOrMucus: bloodOrMucus,
            foreignObjects: foreignObjects,
            tint: tint,
            petId: selectedPetId
        )
        
//----------------------------------------------save model--------------------------------------------
        do{
            try await Firestore.firestore().collection("users").document(userId)
                        .collection("poops").document(newId).setData(from: newPoopEvent)
            alertMessage = "Event added successfully."
            
            isPoopAddedSuccessfully = true
        } catch{
            alertMessage = "Failed to add event: \(error.localizedDescription)"
            
        }
    }
    
    private func validate () -> Bool {
//----------------------whenver the function be called; Reset alertMessage----------------------------
        alertMessage = ""
        guard !selectedPetId.isEmpty else{
            alertMessage = "Please select a pet!"
            
            return false
        }
        
        guard !consistency.contains("Select") else{
            alertMessage = "Please select a consistency!"
            
            return false
        }
        
        guard !color.contains("Select") else{
            alertMessage = "Please select a color of poop!"
            
            return false
        }
        return true
    }
    
    func updatePoop() async {
        guard validate() else {
            return
        }

//----------------------------------- ensure poop event selected----------------------------------
        guard let poopEventToEdit = poopEventToEdit else {
            alertMessage = "No poop event selected for update."
            return
        }
        
//---------------------------- Use the existing poop event's ID----------------------------------
        let poopEventId = poopEventToEdit.id
// -----------------------------------Get current user ID------------------------------------------
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "User not logged in."
            return
        }

//---------------------------create updated poop event model----------------------------------
        let updatedPoopEvent = DBPoop(
            id: poopEventId,
            dateAndTime: dateAndTime,
            consistency: consistency,
            color: color,
            bloodOrMucus: bloodOrMucus,
            foreignObjects: foreignObjects,
            tint: tint,
            petId: poopEventToEdit.petId)

        do {
            try await Firestore.firestore().collection("users").document(userId)
                .collection("poops").document(poopEventToEdit.id).setData(from: updatedPoopEvent, merge: true)

            alertMessage = "Poop event updated successfully."
            isPoopAddedSuccessfully = true
        } catch {
            alertMessage = "Failed to poop event : \(error.localizedDescription)"
        }
    }
    
    func deletePoop() async {
//--------------------------- ensure poop event selected--------------------------------------
          guard let poopEventId = poopEventToEdit?.id else {
              print("No poop event selected for deletion")
              return
          }

// ------------------------------------get current user ID------------------------------------
          guard let userId = Auth.auth().currentUser?.uid else {
              print("User not logged in")
              return
          }

// ----------------------------------- path to the document to delete--------------------------
          let documentReference = Firestore.firestore().collection("users").document(userId).collection("poops").document(poopEventId)

          do {
//-------------------------------------------deletion------------------------------------------
              try await documentReference.delete()
              print("Poop event successfully deleted")
          } catch {
              print("Error deleting poop event: \(error)")
          }
      }
    
}



final class PoopEventManager{
    static let shared = PoopEventManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    func getPoopEvents(forPetId petId: String) async throws -> [DBPoop] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let querySnapshot = try await Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("poops")
            .whereField("petId", isEqualTo: petId)
            .getDocuments()

        let poopEvents = querySnapshot.documents.compactMap { document -> DBPoop? in
            try? document.data(as: DBPoop.self)
        }
        return poopEvents
    }
    
}
