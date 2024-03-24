//
//  addNewExpenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-20.
//

import SwiftUI

struct AddNewExpenseView: View {
    var body: some View {
        ZStack{
            Color("bgHomeColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Rectangle()
                    .foregroundColor(Color("bgFrameColor"))
                    .frame(width: 330,height: 450)
                    .cornerRadius(20)
                Spacer()
                Button(action: {
                    // Input validation or action to perform
                }) {
                    Text("Add")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 330, height: 56)
                        .background(Color("buttonAddColor"))
                        .cornerRadius(20)
                }
                Spacer()
                
            }
        }
    }
}

#Preview {
    AddNewExpenseView()
}
