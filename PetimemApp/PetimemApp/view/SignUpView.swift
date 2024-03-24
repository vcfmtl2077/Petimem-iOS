//
//  signUpView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-17.
//

import SwiftUI

final class SignupEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var signUpSuccess = false
    func signup() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Invalid input or passwords do not match."
            showAlert = true
            return
        }
        
        Task{
            do{
                _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = "User Signup Successful!"
                    self?.showAlert = true
                    self?.signUpSuccess = true
                }
                
            }catch{
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                    self?.signUpSuccess = false
                }
            }
        }
    }
}

struct SignUpView: View {
    
    @StateObject private var viewModel = SignupEmailViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showAlert: Bool = false
    var body: some View {
        ZStack{
            Color("bgColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Image("logoText")
                    .resizable()
                    .frame(width: 280, height: 170, alignment: .leading)
                Spacer()
                Rectangle()
                    .frame(width: 340, height: 400)
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
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Signup Successful."))
                })
                Spacer()
            }
            VStack(spacing: 20){
                Text("")
                Text("")
                Text("Create Your Account")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.blue)
                //                TextField("Username", text: $viewModel.username)
                //                    .padding()
                //                    .frame(width: 300, height: 50)
                //                    .background(Color.white)
                //                    .cornerRadius(20)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 20)
                //                            .stroke( Color.blue)
                //                    )
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
        .alert(isPresented: $viewModel.showAlert) {
            if viewModel.signUpSuccess {
                return Alert(
                    title: Text("Signup Successful"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.signUpSuccess = true
                        dismiss()
                    })
                )
            } else {
                return Alert(
                    title: Text("Signup Failed"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("Try Again"))
                )
            }
        }
    }
    
}

#Preview {
    SignUpView()
}
