//
//  ExpenseCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct ExpenseCardView: View {
    var Expense: Expense
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
            .frame(width: 320, height: 50)
            .foregroundColor(Color("expenseCardColor"))
            
                
            
            HStack(spacing:15){
                Spacer()
                Image(Expense.category)
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack{
                    
                    Text(Expense.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text(format(date: Expense.dateAdded, format:"dd MMM yyyy"))
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(currencyToString(Expense.amount, allowedDigites: 2))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}
