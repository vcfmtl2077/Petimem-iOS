//
//  CategoryView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    
    var body: some View {
        VStack {
            Image(category.rawValue)
            Text(category.rawValue)
        }
    }
}
