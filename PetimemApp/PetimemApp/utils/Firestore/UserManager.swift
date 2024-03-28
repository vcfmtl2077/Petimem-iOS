//
//  UserManager.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-27.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userID: String
    let email: String?
    let dateCreated: Date?
}

final class UserManager{
    static let shared = UserManager()
    private init(){ }
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    //private let encoder: Firestore.Encoder{
        
    //}()encoder: Firestore.Encoder
    
    func createNewUser(user: DBUser) async throws{
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        
        var userData:[String: Any ] = [
            "userID" : auth.uid,
            "email" : auth.email ?? "",
            "dateCreated" : Timestamp()
        ]
        
        try await userDocument(userID: auth.uid).setData(userData, merge: false)
        
    }
    
    func getUser(userID: String) async throws -> DBUser {
        let snapshot = try await userDocument(userID: userID).getDocument()
        
        guard let data = snapshot.data(), let userID = data["userID"] as? String else {
            throw URLError(.badServerResponse)
        }
        let email = data["email"] as? String
        let dateCreated = data["dateCreated"] as? Date
        
        return DBUser(userID: userID, email: email, dateCreated: dateCreated)

    }
}

