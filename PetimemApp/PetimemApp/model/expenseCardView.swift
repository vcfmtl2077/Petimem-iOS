//
//  expenseCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-23.
//

import SwiftUI

struct expenseCardView: View {
    var totalAmount: Double
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(.bgFrame)
            VStack(spacing: 0){
                HStack(spacing: 10){
                    Text("\(currencyToString(totalAmount))")
                        .font(.title.bold())
                    
                }
                
                HStack(spacing: 0){
                    ForEach(Category.allCases, id: \.rawValue){ category in
                        
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView{
        expenseCardView(totalAmount: 1000)
    }
}
