//
//  PetManager.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBPets: Codable {
    let id: String
    let photoUrl: String?
    let name: String
    let gender: String
    let birthday: Date
    let dateCreated: Date?
}


final class PetManager {
    static let shared = PetManager()
    private init() {}
    
    private let db = Firestore.firestore()
   
}
