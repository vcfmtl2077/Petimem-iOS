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
            signUpSuccess = true
            try await UserManager.shared.createNewUser(auth: authDataResult)
            print("UserManager successfully added the user to Firestore.")
        } catch {
            print("Error during sign up: \(error.localizedDescription)")
                    throw error
        }
            //let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            //try await UserManager.shared.createNewUser(auth: authDataResult)
        
        /*Task{
            do{
                let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
                try await UserManager.shared.createNewUser(auth: authDataResult)
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
        }*/
    }
    
    private func validate () -> Bool {
        //whenver the function be called; Reset alertMessage
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
        return true
    }
}
