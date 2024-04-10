//
//  ExpenseManager.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExpense: Codable,Identifiable {
    //properties
    let id: String
    let title: String
    let amount: Double
    let category: String
    let dateAdded: Date?
    let tint: String
    
    init(id: String, title: String, amount: Double, category: Category, dateAdded: Date, tint: String) {
        self.id = id
        self.title = title
        self.amount = amount
        self.category = category.rawValue
        self.dateAdded = dateAdded
        self.tint = tint
    }
}

final class ExpenseManager{
    static let shared = ExpenseManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    

    func getExpenses(forUserID userID: String) async throws -> [DBExpense] {
            let snapshot = try await userCollection.document(userID).collection("expenses").getDocuments()
            let expenses = try snapshot.documents.compactMap { document -> DBExpense? in
                try document.data(as: DBExpense.self)
            }
            return expenses
        }
}
