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
    
    @Published var newPetId: String?
    
    var petToEdit: DBPets?
    
    func loadImage() async throws {
        guard let item = selectedItem else{ return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func loadImage(from urlString: String?) async {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.profileImage = Image(systemName: "photo") // Fallback image
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            } else {
                self.profileImage = Image(systemName: "photo") // Fallback image
            }
        } catch {
            print("Failed to load image from URL: \(error)")
            self.profileImage = Image(systemName: "photo") // Fallback image in case of error
        }
    }
    
    
    func saveProfileImage(item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            guard let userId = Auth.auth().currentUser?.uid else {
                self.alertMessage = "Authentication Error. Please sign in."
                self.showAlert = true
                return
            }
            // Save the image to Firebase Storage
            let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: userId)
            // Generate the download URL
            let imageURL = try await StorageManager.shared.getUrlForImage(path: path)
            // get the petId
            guard let newId = self.newPetId else { return }
            // Save the imageURL to Firestore in the pet's document
            try await updatePetImageURL(userId: userId, petId: newId, imageURL: imageURL.absoluteString)
            self.alertMessage = "Pet and Image added successfully."
            self.showAlert = true
        } catch {
            self.alertMessage = "Failed to save profile image: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    func updatePetImageURL(userId: String, petId: String, imageURL: String) async throws {
        let petDocumentRef = Firestore.firestore().collection("users").document(userId).collection("pets").document(petId)
        try await petDocumentRef.updateData(["photoUrl": imageURL])
    }
    
    func addPet() async {
        guard validate() else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let newId = UUID().uuidString
        self.newPetId = newId
        let newPet = DBPets(
            id: newId,
            photoUrl: "", // Initially empty, will be updated later
            name: name,
            gender: gender,
            birthday: birthday,
            dateCreated: Date(),
            tint: tint
        )

        do {
            let data = try Firestore.firestore().collection("users").document(userId)
                .collection("pets").document(newId)
            try await data.setData(from: newPet)
            alertMessage = "Pet added successfully."
            showAlert = true
            isPetAddedSuccessfully = true
        } catch {
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
        
        guard name.count <= 12 else {
            alertMessage = "Name must be within 12 characters!"
            showAlert = true
            return false
        }
        return true
    }
    
    func updatePet() async {
        guard validate(), let userId = Auth.auth().currentUser?.uid, let petToEdit = self.petToEdit else {
            alertMessage = "Please ensure all fields are filled and you are signed in."
            showAlert = true
            return
        }

        var newImageUrl: String? = petToEdit.photoUrl // Start with the existing URL

        // If a new image was selected, upload it and get the new URL
        if let selectedItem = selectedItem {
            do {
                if let data = try await selectedItem.loadTransferable(type: Data.self) {
                    let (path, _) = try await StorageManager.shared.saveImage(data: data, userId: userId)
                    let imageURL = try await StorageManager.shared.getUrlForImage(path: path)
                    newImageUrl = imageURL.absoluteString
                } else {
                    print("No image data available")
                }
            } catch {
                alertMessage = "Failed to upload new image: \(error.localizedDescription)"
                showAlert = true
                return
            }
        }

        // Construct the updated pet object, including the new or existing image URL
        let updatedPet = DBPets(id: petToEdit.id, photoUrl: newImageUrl, name: name, gender: gender, birthday: birthday, dateCreated: petToEdit.dateCreated, tint: tint)

        // Update Firestore document
        do {
            let petDocumentRef = Firestore.firestore().collection("users").document(userId).collection("pets").document(petToEdit.id)
            try await petDocumentRef.setData(from: updatedPet)
            alertMessage = "Pet updated successfully."
            showAlert = true
            isPetAddedSuccessfully = true
        } catch let error {
            alertMessage = "Failed to update pet: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func deletePet(petId: String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            alertMessage = "User not logged in"
            showAlert = true
            return
        }
        
        await deletePoopEvents(forPetId: petId, userId: userId)

        let documentReference = Firestore.firestore().collection("users").document(userId).collection("pets").document(petId)

        do {
            try await documentReference.delete()
            print("Pet successfully deleted")
            alertMessage = "Pet successfully deleted"
            showAlert = true
        } catch {
            print("Error deleting pet: \(error)")
            alertMessage = "Error deleting pet: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func deletePoopEvents(forPetId petId: String, userId: String) async {
        let poopEventsCollection = Firestore.firestore().collection("users").document(userId).collection("poops")
        let querySnapshot = try? await poopEventsCollection.whereField("petId", isEqualTo: petId).getDocuments()

        guard let documents = querySnapshot?.documents else {
            print("No poop events found for petId: \(petId)")
            return
        }
        
        for document in documents {
            do {
                try await document.reference.delete()
                print("Poop event \(document.documentID) deleted successfully")
            } catch {
                print("Error deleting poop event \(document.documentID): \(error)")
            }
        }
    }
}
