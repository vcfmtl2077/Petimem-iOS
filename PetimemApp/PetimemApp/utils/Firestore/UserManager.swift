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
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let dateCreated: Date?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.firstName = ""
        self.lastName = ""
        self.email = auth.email
        self.dateCreated = Date()
    }
    
    init(userID: String, firstName: String? = nil, lastName: String? = nil, email: String? = nil, dateCreated: Date? = nil) {
        self.userId = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dateCreated = dateCreated
    }
    
    func updateCurrentUser(first: String, last: String) -> DBUser {
        return DBUser(userID: userId, firstName: first, lastName: last, email: email, dateCreated: dateCreated)
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
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
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    func getUser(userID: String) async throws -> DBUser {
        try await userDocument(userID: userID).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func updateUserProfile(user: DBUser) async throws {
        try userDocument(userID: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
    
    @Published var alertMessage = ""
    
    func updateUserProfile(userID: String, first: String, last: String) async throws {
        var data: [String: Any] = [
            "first_name": first,
            "last_name": last
        ]
        try await userDocument(userID: userID).updateData(data)
    }
}
