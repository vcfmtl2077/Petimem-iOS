//
//  signUpView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-17.
//

import SwiftUI

final class SignupEmailViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    func signup() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        Task{
            do{
                let userData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("success")
                print(userData)
            }catch{
                print("Error: \(error)")
            }
        }
    }
}

struct SignUpView: View {
    
    @StateObject private var viewModel = SignupEmailViewModel()
    
    var body: some View {
        ZStack{
            Color("bgColor")
                .ignoresSafeArea()
            VStack{
                Image("logoText")
                    .resizable()
                    .frame(width: 280, height: 170, alignment: .leading)
                Spacer()
                Rectangle()
                    .frame(width: 340, height: 450)
                    .foregroundColor(.white.opacity(0.6))
                    .cornerRadius(20)
                Spacer()
                Spacer()
                Button("Sign Up"){
                    //input validation
                    viewModel.signup()
                }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(20)
                Spacer()
            }
            VStack(spacing: 20){
                Text("")
                Text("")
                Text("Create Your Account")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.blue)
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke( Color.blue)
                    )
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke( Color.blue)
                    )
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke( Color.blue)
                    )
                SecureField("confirmPassword", text: $viewModel.confirmPassword)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke( Color.blue)
                    )
                Text("By creating an account, you agree to our Terms of Service and Privacy policy")
                    .foregroundColor(.blue)
                    .font(.footnote)
                    .frame(width: 250)
            }
        }
    }
}

#Preview {
    SignUpView()
}
