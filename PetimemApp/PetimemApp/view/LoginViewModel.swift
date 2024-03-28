//
//  LoginViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-27.
//

import Foundation
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var logInSuccess = false

    func signIn() {
        //try to validate information; if fail, will stop
        guard validate() else{
            return
        }
        //information validated; try to sign in
        Task{
            do{
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = "Login Successful!"
                   // self?.showAlert = true
                    self?.logInSuccess = true
                }
                
            }catch{
                DispatchQueue.main.async { [weak self] in
                    self?.alertMessage = error.localizedDescription
                    //self?.showAlert = true
                    self?.logInSuccess = false
                }
            }
        }
    }
    
    private func validate () -> Bool{
        //whenver the function be called; Reset alertMessage
        alertMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,!password.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return false
        }
        
        guard email.contains("@") && email.contains(".") else{
            alertMessage = "Please enter a valid email."
            return false
        }
        
        return true
    }
    
}
