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
    @State private var showingDeleteConfirmation = false
    @State private var deletionErrorMessage = ""
    @State private var showingDeletionError = false
    @State private var showLoginScreen = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                Rectangle()
                    .frame(width: 340, height: 400)
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(20)
                VStack(spacing: 20){
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
    //-------------------------------Update Button-----------------------------
                        Button{
                            Task {
                                viewModelB.updateCurrentUser(first: first, last: last)
                                dismiss()
                            }
                        }label: {
                            Text("Update")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
    //-------------------------------Update Button-----------------------------
                        Button{
                            isEditMode = false
                        }label: {
                            Text("Cancel")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
    //----------------------------Delete Account Button Button-----------------------------
                        Button{
                            showingDeleteConfirmation = true
                        }label: {
                            Text("Delete Account")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.red)
                                .cornerRadius(20)
                        }
                        NavigationLink(destination: LoginView(), isActive: $showLoginScreen) {
                                            EmptyView()
                                        }
                        
                    }else {
                        if let user = viewModelB.user {
                           HStack{
                               Text("")
                               Text("")
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
                        
                        Button{
                            isEditMode.toggle()
                            if isEditMode, let user = viewModelB.user {
                                                first = user.firstName ?? ""
                                                last = user.lastName ?? ""
                                            }
                        }label: {
                            Text("Edit")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
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
            .alert("Are you sure you want to delete your account?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showLoginScreen = true
                            print("Account deleted successfully.")
                        } catch {
                            deletionErrorMessage = error.localizedDescription
                            showingDeletionError = true
                            print("Failed to delete account: \(error)")
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
            .alert("Error Deleting Account", isPresented: $showingDeletionError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(deletionErrorMessage)
            }
            .alert("Account Deleted", isPresented: $viewModel.isAccountDeleted) {
                Button("OK") {
                    // Perform additional cleanup
                    Task{
                        do{
                            try viewModel.signOut()
                            
                        }catch{
                            
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
