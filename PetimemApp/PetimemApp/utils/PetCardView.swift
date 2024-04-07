//
//  PetCardView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-04.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PetCardView: View {
    var pet: DBPets
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
            .frame(width: 320, height: 140)
            .foregroundColor(Color(pet.tint))
            
            HStack(spacing:30){
                Spacer()
                if let photoUrl = pet.photoUrl, let url = URL(string: photoUrl) {
                               AsyncImage(url: url) { phase in
                                   switch phase {
                                   case .empty:
                                       ProgressView() // Display a progress indicator while loading
                                   case .success(let image):
                                       // Display the loaded image
                                       image.resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: 100, height: 100)
                                           .clipShape(Circle())
                                   case .failure:
                                       // In case of failure
                                       Image(systemName: "dog.circle.fill")
                                           .resizable()
                                           .frame(width: 100, height: 100)
                                           .clipShape(Circle())
                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                           } else {
                               //if `photoUrl` is nil
                               Image(systemName: "dog.circle.fill")
                                   .resizable()
                                   .frame(width: 100, height: 100)
                                   .clipShape(Circle())
                           }
                
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

