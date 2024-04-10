//
//  PasswordView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct PasswordView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @State private var oldPassword: String = ""
        @State private var newPassword: String = ""
        @State private var showError: Bool = false
        @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    Text("\(errorMessage)")
                        .foregroundStyle(.red)
                    // Divider
                    VStack(spacing: 0){
                        Text("Reset Password")
                            .bold()
                            .foregroundStyle(Color("buttonAddColor"))
                        //Dividing sections line
                        Rectangle()
                            .frame(width: 350, height: 2)
                            .foregroundColor(Color("buttonAddColor"))
                    }
                    Button{
                        Task{
                            do{
                                try await viewModel.resetPassword()
                                print("Password reset!")
                                errorMessage = "Reset email sent! Please check you inbox."
                            }catch{
                                print(error)
                                errorMessage = "Something went wrong, please try again!"
                            }
                        }
                    }label: {
                        Text("Reset Password")
                            .foregroundColor(.white)
                            .frame(width: 330, height: 55)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                    // Divider
                    VStack(spacing: 0){
                        Text("Update Password")
                            .bold()
                            .foregroundStyle(Color("buttonAddColor"))
                        //Dividing sections line
                        Rectangle()
                            .frame(width: 350, height: 2)
                            .foregroundColor(Color("buttonAddColor"))
                    }
                    
                    SecureField("Old Password", text: $oldPassword)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 330, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.blue)
                        )
                    SecureField("New Password", text: $newPassword)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 330, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.blue)
                        )
                    Button{
                        Task{
                            do{
                                try await viewModel.updatePassword(oldPassword: oldPassword, newPassword: newPassword)
                                print("Password updated!")
                                errorMessage = "Your password was updated successfully!"
                            }catch{
                                print(error)
                                errorMessage = "Something went wrong, please try again!"
                            }
                        }
                    }label: {
                        Text("Update Password")
                            .foregroundColor(.white)
                            .frame(width: 330, height: 55)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                    .disabled(oldPassword.isEmpty || newPassword.isEmpty )
                    .opacity(oldPassword.isEmpty || newPassword.isEmpty  ? 0.5 : 1)
                    Spacer()
                }
            }
            .navigationTitle("Password")
        }
    }
}

#Preview {
    PasswordView()
}
