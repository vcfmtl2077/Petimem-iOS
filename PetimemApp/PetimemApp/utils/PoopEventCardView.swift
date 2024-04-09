//
//  PoopEventCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-08.
//

import SwiftUI

struct PoopEventCardView: View {
    var poop: DBPoop
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
            .frame(width: 320,height: 50)
            .foregroundColor(Color(poop.tint))
            
            HStack(alignment: .center, spacing: 25){
                Image("poop")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("On \(poop.dateAndTime.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.caption)
            }
            .padding(.horizontal, 40)
            
        }
    }
}

