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
    @State private var showDeleteAction: Bool = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        if showDeleteAction{
            HStack{
                
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 280, height: 140)
                        .foregroundColor(Color(pet.tint))
                    
                    HStack(spacing:30){
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
                .gesture(swipeGesture)
                .transition(.move(edge: .trailing))
                .animation(.snappy, value: showDeleteAction)
                
                Button(action: {
                                  // Handle delete action
                                  print("Delete tapped")
                              }) {
                                  Text("Delete")
                                      .foregroundColor(.white)
                                      .padding()
                                      .background(Color.red)
                                      .cornerRadius(10)
                              }
            }
        } else {
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
                                ProgressView()
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
            .gesture(swipeGesture)
        }
        
    }
}


extension PetCardView {
    var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.dragOffset = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                let horizontalAmount = value.translation.width as CGFloat

                withAnimation {
                    if abs(horizontalAmount) > threshold {
                        if horizontalAmount < 0 {
                            // Exceeding left swipe threshold
                            showDeleteAction = true
                        } else {
                            // Swiping right
                            dragOffset = 0
                            showDeleteAction = false
                        }
                    } else {
                        // Not reaching the threshold > reset
                        dragOffset = 0
                        showDeleteAction = false
                    }
                }
            }
    }
}
