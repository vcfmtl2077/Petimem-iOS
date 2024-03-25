//
//  expense.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-23.
//

import SwiftUI
import Firebase

struct Expense: Identifiable{
    let id: UUID = .init()
    //properties
    var title: String
    var amount: Double
    var category: String
    var dateAdded: Date
    var tint: String //give background color
    
    init(title: String, amount: Double, category: Category, dateAdded: Date, tint: String) {
        self.title = title
        self.amount = amount
        self.category = category.rawValue
        self.dateAdded = dateAdded
        self.tint = tint
    }
}

var sampleExpenses: [Expense] = [
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "RoyalCanin", amount: 90.00, category: .food, dateAdded: .now, tint: "White"),
    .init(title: "Didi", amount: 75.00, category: .grooming, dateAdded: .now, tint: "White"),
    .init(title: "ChouchouLeash", amount: 70.00, category: .accessories, dateAdded: .now, tint: "White")
] 
