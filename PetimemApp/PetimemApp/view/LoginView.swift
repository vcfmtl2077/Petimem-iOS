//
//  loginView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-17.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var logInSuccess = false

    func signIn() {
        guard !email.isEmpty,!password.isEmpty else {
            alertMessage = "Invalid input or passwords do not match."
            showAlert = true
            return
        }

        Task{
            do{
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = "User Login Successful!"
                    self?.showAlert = true
                    self?.logInSuccess = true
                }
                
            }catch{
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                    self?.logInSuccess = false
                }
            }
        }
    }
}


struct LoginView: View {
    @State private var wrongEmail = 0
    @State private var wrongPassword = 0
    @State  var showingHomeScreen = false
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
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
                        .frame(width: 340, height: 350)
                        .foregroundColor(.white.opacity(0.6))
                        .cornerRadius(20)
                    Spacer()
                    Spacer()
                    HStack{
                        Text("No account yet?")
                        NavigationLink(destination: SignUpView()){
                            Text("Create an account")
                        }
                    }
                    Spacer()
                }
                VStack(spacing: 20){
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                    TextField("Email", text: $viewModel.email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                    .stroke(wrongEmail > 0 ? Color.red : Color.blue, lineWidth:CGFloat(wrongEmail > 0 ? wrongEmail : 1))
                                        )
                    SecureField("Password", text: $viewModel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(20)
                            .border(.red, width: CGFloat(wrongPassword))
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                    .stroke(wrongEmail > 0 ? Color.red : Color.blue, lineWidth:CGFloat(wrongEmail > 0 ? wrongEmail : 1))
                                        )
                        Button("Login"){
                            //Authenticate user
                            viewModel.signIn()
                        }
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(20)
                     Rectangle()
                        .frame(width: 280, height: 1)
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 20){
                        ZStack{
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.white.opacity(0.1))
                                .overlay(
                                    Circle().stroke(Color.blue)
                                           )
                            Image("facebookLogin")
                                .resizable()
                                .frame(width: 50, height: 40)
                            
                        }
                        ZStack{
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.white.opacity(0.1))
                                .overlay(
                                    Circle().stroke(Color.blue)
                                           )
                            Image("appleLogin")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        ZStack{
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.white.opacity(0.1))
                                .overlay(
                                    Circle().stroke(Color.blue)
                                           )
                            Image("googleLogin")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                   
                }
                
            }
            .alert(isPresented: $viewModel.showAlert) {
                if viewModel.logInSuccess {
                    return Alert(
                        title: Text("Login Successful"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"), action: {
                            self.showingHomeScreen = true
                        })
                    )
                } else {
                    return Alert(
                        title: Text("Login Failed"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("Try Again"))
                    )
                }
            }
            .onAppear{
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showingHomeScreen = authUser == nil ? true : false
            }
            .fullScreenCover(isPresented: $showingHomeScreen) {
                NavigationStack{
                    ContentView(showingHomeScreen: $showingHomeScreen).navigationBarHidden(true)
                }
            }
        }.navigationTitle("Sign Up")
    }
}

#Preview {
    LoginView()
}
