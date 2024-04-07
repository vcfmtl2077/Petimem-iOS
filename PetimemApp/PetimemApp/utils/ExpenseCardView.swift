//
//  ExpenseCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct ExpenseCardView: View {
    var expense: DBExpense
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
            .frame(width: 320)
            .foregroundColor(Color(expense.tint))
            
            HStack(alignment: .center, spacing: 15){
                Image(expense.category)
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack{
                    
                    Text(expense.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text(format(date: expense.dateAdded ?? .now, format:"dd MMM yyyy"))
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                Text(currencyToString(expense.amount, allowedDigites: 2))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
        }
    }
}
