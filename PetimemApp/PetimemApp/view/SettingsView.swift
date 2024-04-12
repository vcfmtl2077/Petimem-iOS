//
//  SettingsView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//---------------------------remember to customize error later----------------------------
        guard let email = authUser.email else{
            throw URLError(.fileDoesNotExist)
        }
       try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword(oldPassword: String, newPassword: String) async throws {
        guard let authUser = try? AuthenticationManager.shared.getAuthenticatedUser(), let email = authUser.email else {
            throw URLError(.userAuthenticationRequired)
        }
        
// --------------------re-authenticate the user with the old password---------------------
        try await AuthenticationManager.shared.reauthenticateUser(email: email, password: oldPassword)
        
//---------------------------------updating the password----------------------------------
        try await AuthenticationManager.shared.updatePassword(password: newPassword)
    }
    
    @Published var isAccountDeleted = false
    func deleteAccount() async throws {
          guard let uid = Auth.auth().currentUser?.uid else {
              throw URLError(.userAuthenticationRequired)
          }
//-------------------------------- Delete the account from auth----------------------------
          try await AuthenticationManager.shared.delete()

// -------------------------------------Sign out user-------------------------------------
          self.isAccountDeleted = true
      }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showingHomeScreen: Bool
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                  List {
                    Section(header: Text("Account")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Profile", destination: ProfileView())
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                            NavigationLink("Password", destination: PasswordView())
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                                .cornerRadius(40)


                        }
                    
                    Section(header: Text("Setting")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Permissions", destination: Text("Permissions View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                            NavigationLink("Storage", destination: Text("Storage View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                        }
                    
                    Section(header: Text("Premium")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Upgrade to premium", destination: Text("Premium View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                        }
                    
                    Section(header: Text("Other")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                        .foregroundColor(Color("buttonAddColor"))) {
                            Button(action: {
                                Task{
                                    do{
                                        try viewModel.signOut()
                                        showingHomeScreen = false
                                    }catch{
                                        
                                    }
                                }
                                   }) {
                                       Text("Log out")
                                           .frame(minWidth: 0, maxWidth: .infinity)
                                           .foregroundColor(.red)
                                           .font(.system(size: 20))
                                           .padding()
                                           .background(Color("bgFrameColor"))
                                           .cornerRadius(30)
                                   }
                                   .background(Color("bgHomeColor"))
                                   .listRowInsets(EdgeInsets())
                                   .buttonStyle(PlainButtonStyle())
                        }
                    
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    SettingsView(showingHomeScreen: .constant(true))
}
