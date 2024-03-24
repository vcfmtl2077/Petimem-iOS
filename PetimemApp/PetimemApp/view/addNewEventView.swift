//
//  addNewEventView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-20.
//

import SwiftUI

struct addNewEventView: View {
    @State private var title = ""
    
    var body: some View {
        ZStack{
            Color("bgHomeColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Rectangle()
                    .foregroundColor(Color("bgFrameColor"))
                    .frame(width: 330,height: 500)
                    .cornerRadius(20)
                Spacer()
                Button("Add"){
                    //input validation
                }
                .foregroundColor(.white)
                .frame(width: 330, height: 55)
                .background(Color("buttonAddColor"))
                .cornerRadius(20)
                Spacer()
                Text("")
            }
        }
    }
}

#Preview {
    addNewEventView()
}
