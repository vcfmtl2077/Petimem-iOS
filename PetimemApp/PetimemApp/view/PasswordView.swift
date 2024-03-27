//
//  PasswordView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct PasswordView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    
                    Button("Reset Password"){
                        Task{
                            do{
                                try await viewModel.resetPassword()
                                print("Password reset!")
                            }catch{
                                print(error)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 50)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
                    
                    Button("Update Password"){
                        Task{
                            do{
                                try await viewModel.updatePassword()
                                print("Password updated!")
                            }catch{
                                print(error)
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 50)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
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
