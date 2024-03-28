//
//  signUpView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-17.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignupEmailViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationStack{
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
                        Task {
                                do {
                                    try await viewModel.signup()
                                } catch {
                                    // Handle errors
                                }
                            }
                    }
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(Color.blue)
                    .cornerRadius(20)
                   /* .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Signup Successful."))
                    })*/
                    .onChange(of: viewModel.signUpSuccess, initial: false) {
                        dismiss()
                    }
                    Spacer()
                }
                VStack(spacing: 20){
                    Text("")
                    if !viewModel.alertMessage.isEmpty{
                        Text(viewModel.alertMessage)
                            .foregroundStyle(.red)
                    }
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
          /*  .alert(isPresented: $viewModel.showAlert) {
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
            }*/
        }
    }
    
}

#Preview {
    SignUpView()
}
