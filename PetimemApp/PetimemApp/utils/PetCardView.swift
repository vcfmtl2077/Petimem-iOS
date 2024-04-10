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
    var onEditTapped: () -> Void
    var onPetDeleted: () -> Void
    var viewModel: AddPetViewModel
    @State private var showingDeletionAlert = false
    
    var body: some View {
//--------------------------------------------swipe left to show delete and edit button-------------------------------------------
        if showDeleteAction{
            HStack{
        
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 270, height: 140)
                        .foregroundColor(Color(pet.tint))
                    
                    HStack(spacing:30){
                        if let photoUrl = pet.photoUrl, let url = URL(string: photoUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    // Display the loaded image
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                case .failure:
                                    // In case of failure
                                    Image(systemName: "dog.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            //if `photoUrl` is nil
                            Image(systemName: "dog.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
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
                    }
                }
                .gesture(swipeGesture)
                .transition(.move(edge: .trailing))
                .animation(.snappy, value: showDeleteAction)
                VStack{
                    Button{
                        showingDeletionAlert = true
                    }label: {
                        Label("", systemImage: "trash")
                            .foregroundColor(.white)
                            .frame(width: 70, height: 60)
                            .background(Color.red)
                            .cornerRadius(20)
                    }
                    Button{
                        onEditTapped() 
                    }label: {
                        Label("", systemImage: "pencil")
                            .foregroundColor(.white)
                            .frame(width: 70, height: 60)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .alert("Delete Pet", isPresented: $showingDeletionAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Confirm", role: .destructive) {
                            Task {
                                await viewModel.deletePet(petId: pet.id)
                                onPetDeleted()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this pet?")
                    }
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
                            
                            showDeleteAction = true
                        } else {
                            // Swiping right
                            dragOffset = 0
                            showDeleteAction = false
                        }
                    } else {
                        
                        dragOffset = 0
                        showDeleteAction = false
                    }
                }
            }
    }
}
