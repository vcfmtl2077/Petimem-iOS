//
//  PetManager.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-03.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBPets: Codable,Identifiable {
    let id: String
    let photoUrl: String?
    let name: String
    let gender: String
    let birthday: Date
    let dateCreated: Date?
    let tint: String

}

final class PetManager {
    static let shared = PetManager()
    private init() {}
   
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    func getPets(forUserID userID: String) async throws -> [DBPets] {
        let snapshot = try await userCollection.document(userID).collection("pets").getDocuments()
        let pets = snapshot.documents.compactMap { document -> DBPets? in
            guard let pet = try? document.data(as: DBPets.self) else {
                print("Error decoding pet: \(document.documentID)")
                return nil
            }
            return pet
        }
        return pets
    }
}
