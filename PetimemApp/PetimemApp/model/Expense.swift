//
//  Expense.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import Foundation
import SwiftData

@Model
class Expense {
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
    
    //Extracting category value
    // This property wrapper tells SwiftData not to persist in the annotated property
    @Transient
    var rawCategory: Category? {
    return Category.allCases.first(where: {category == $0.rawValue})
    }
}
