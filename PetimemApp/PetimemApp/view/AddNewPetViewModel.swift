//
//  AddNewPetViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import SwiftUI
import FirebaseAuth

@MainActor
class AddPetViewModel: ObservableObject {
    @Published var name = ""
    @Published var gender = ""
    @Published var birthday = Date()
    @Published var tint = "expenseCardColor"
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isPetAddedSuccessfully = false
    //--------------------------Add pet profile picture--------------------------------
    @Published var selectedItem: PhotosPickerItem?{
        didSet{ Task { try await loadImage() }}
    }
    @Published var profileImage: Image? //display the seleted item
    
    func loadImage() async throws {
        guard let item = selectedItem else{ return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    func addPet() async {
        guard validate() else{
            return
        }
        //get current userId
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        // create model
        let newId = UUID().uuidString
        let photoUrl = ""
        let newPet = DBPets(
            id: newId,
            photoUrl:photoUrl,
            name: name,
            gender: gender,
            birthday: birthday,
            dateCreated: Date(),
            tint: tint)
        //save model
        
        do {
                // Await the setData operation to ensure it completes.
                try await Firestore.firestore().collection("users").document(userId)
                    .collection("pets").document(newId).setData(from: newPet, merge: false, encoder: encoder)
                // Handle success
                alertMessage = "Pet added successfully."
                showAlert = true
                isPetAddedSuccessfully = true
            } catch {
                // Handle error
                alertMessage = "Failed to add pet: \(error.localizedDescription)"
                showAlert = true
            } 
        
    }
    
    private func validate () -> Bool {
        //whenver the function be called; Reset alertMessage
        alertMessage = ""
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,!gender.isEmpty else{
            alertMessage = "Please fill in all fields"
            showAlert = true
            return false
        }
        
        guard name.count <= 12 else{
            alertMessage = "Name must be within 12 characters!"
            showAlert = true
            return false
        }
        return true
    }
}
