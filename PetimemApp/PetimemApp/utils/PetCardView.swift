//
//  PetCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-04.
//

import SwiftUI

struct PetCardView: View {
    var pet: DBPets
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
            .frame(width: 320, height: 140)
            .foregroundColor(Color(pet.tint))
            
            HStack(spacing:30){
                Spacer()
                Image("test")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                VStack{
                    Text(pet.name)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    HStack{
                        Image("birthdayIcon")
                        Text(format(date: pet.birthday, format:"dd MMM yyyy"))
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Spacer()
            }
        }
    }
}

