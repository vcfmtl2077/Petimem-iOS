//
//  SignUpViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-27.
//

import Foundation
import FirebaseAuth

@MainActor
final class SignupEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var signUpSuccess = false
    
    func signup() async throws {
        guard validate() else{
            return
        }
        
        do{
            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            print("AuthenticationManager successfully created a user.")
            alertMessage = "Account successfully created!"
            signUpSuccess = true
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.createNewUser(user: user)
            print("UserManager successfully added the user to Firestore.")
            alertMessage = "Account successfully created!"
        } catch {
            print("Error during sign up: \(error.localizedDescription)")
            alertMessage = "An unexpected error occurred. Please try again later."
                    throw error
        }
    }
    
    
    private func validate () -> Bool {
//---------------------------------------whenver the function be called; Reset alertMessage--------------------------------------
        alertMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,!password.trimmingCharacters(in: .whitespaces).isEmpty else{
            alertMessage = "Please fill in all fields"
            showAlert = true
            return false
        }
        
        guard email.contains("@") && email.contains(".") else{
            alertMessage = "Please enter a valid email."
            return false
        }
        
        guard password.count >= 6 else{
            alertMessage = "Password must contains 6 characters!"
            return false
        }
        
        guard password == confirmPassword else {
                   alertMessage = "Passwords do not match!"
                   showAlert = true
                   return false
               }
        
        return true
    }
}
