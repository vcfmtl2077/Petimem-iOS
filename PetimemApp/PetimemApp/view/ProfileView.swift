//
//  ProfileView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject{
    
  //--------------------------Load User profile--------------------------------
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
    
    //--------------------------Update User profile--------------------------------
    func updateCurrentUser(first: String, last: String){
        guard let user else{ return }
        Task{
            try await UserManager.shared.updateUserProfile(userID: user.userId,first:first,last:last)
            self.user = try await UserManager.shared.getUser(userID: user.userId)
        }
    }
}



struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var viewModelB = ProfileViewModel()
    @State private var first = ""
    @State private var last = ""
    @State private var isEditMode = false
    @State private var isCompleted = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                Rectangle()
                    .frame(width: 340, height: 300)
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(20)
                VStack(spacing: 30){
                    
                    if isEditMode {
                        TextField("First Name", text: $first)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke( Color.blue)
                            )
                        
                        
                        
                        TextField("Last Name", text: $last)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke( Color.blue)
                            )
                        
                        
                        Button("Update"){
                            //input validation
                            Task {
                                viewModelB.updateCurrentUser(first: first, last: last)
                                dismiss()
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(20)
                        
                        Button("Cancel"){
                            //input validation
                            isEditMode = false
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.gray)
                        .cornerRadius(20)
                        
                        Button(role: .destructive){
                            Task{
                                do{
                                    try await viewModel.deleteAccount()
                                    print("Account deleted!")
                                }catch{
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Delete Account")
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.red)
                        .cornerRadius(20)
                    }else {
                        if let user = viewModelB.user {
                           HStack{
                               Text("")
                               Text("")
                               Text("")
                               Text("")
                               Text("")
                               Text("Email:")
                                        .bold()
                                        .font(.title3)
                                        .foregroundColor(Color("buttonAddColor"))
                                    Text("\(user.email ?? "")")
                               Spacer()
                                }
                            HStack{
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                                Text("First Name:")
                                         .bold()
                                         .font(.title3)
                                         .foregroundColor(Color("buttonAddColor"))
                                     
                                Text("\(user.firstName ?? "")")
                                Spacer()
                                 }
                            HStack{
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                                Text("")
                                Text("Last Name:")
                                         .bold()
                                         .font(.title3)
                                         .foregroundColor(Color("buttonAddColor"))
                                     
                                Text("\(user.lastName ?? "")")
                                Spacer()
                                 }
                            
                            if user.firstName?.isEmpty != false || user.lastName?.isEmpty != false {
                                                Text("*Please complete your user profile")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                        }
                        
                        Button("Edit") {
                                                isEditMode.toggle()
                                                if isEditMode, let user = viewModelB.user {
                                                    first = user.firstName ?? ""
                                                    last = user.lastName ?? ""
                                                }
                                            }
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50)
                                            .background(Color.blue)
                                            .cornerRadius(20)
                                            .padding(.top, 10)
                    }
                }
            }
            .task {
                do {
                    try await viewModelB.loadCurrentUser()
                } catch {
                    print("Error loading user: \(error)")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
