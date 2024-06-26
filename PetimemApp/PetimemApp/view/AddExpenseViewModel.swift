//
//  AddExpenseViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-04.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import SwiftUI
import FirebaseAuth

@MainActor
class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amount: Double = .zero
    @Published var selectedCategory: Category = .food
    @Published var dateAdded: Date = .now
    @Published var tint: String = "expenseCardColor"
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isExpenseAddedSuccessfully = false
    var expenseToEdit: DBExpense?
    
    func addExpense() async {
        guard validate() else{
            return
        }
        
//-----------------------------------------------get current userId--------------------------------------------
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // create model
        let newId = UUID().uuidString
        let newExpense = DBExpense(id: newId,
                                   title: title,
                                   amount: amount,
                                   category: selectedCategory,
                                   dateAdded: dateAdded,
                                   tint: tint)
//--------------------------------------------------save model------------------------------------------------------
        do {
                try await Firestore.firestore().collection("users").document(userId)
                    .collection("expenses").document(newId).setData(from: newExpense)
               
                alertMessage = "Expense added successfully."
                showAlert = true
                isExpenseAddedSuccessfully = true
            } catch {

                alertMessage = "Failed to add expense: \(error.localizedDescription)"
                showAlert = true
            }
    }
    
    private func validate () -> Bool {
//-------------------------------------whenver the function be called; Reset alertMessage-----------------------------------------
        alertMessage = ""
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            alertMessage = "Please fill in all fields"
            showAlert = true
            return false
        }
        
        guard title.count <= 35 else{
            alertMessage = "title must be within 50 characters!"
            showAlert = true
            return false
        }
        return true
    }
    
    func updateExpense() async {
        guard validate() else {
            return
        }

// ---------------------------------------Ensure there's an existing expense to update------------------------------------------
        guard let expenseToUpdate = expenseToEdit else {
            alertMessage = "No expense selected for update."
            showAlert = true
            return
        }
        
        // Use the existing expense's ID
        let expenseId = expenseToUpdate.id

        // Get current user ID
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "User not logged in."
            showAlert = true
            return
        }

        // Create updated expense model
        let updatedExpense = DBExpense(id: expenseId,
                                       title: title,
                                       amount: amount,
                                       category: selectedCategory,
                                       dateAdded: dateAdded,
                                       tint: tint)

        do {

            try await Firestore.firestore().collection("users").document(userId)
                .collection("expenses").document(expenseId).setData(from: updatedExpense, merge: true)
          
            alertMessage = "Expense updated successfully."
            showAlert = true
            isExpenseAddedSuccessfully = true
        } catch {
           
            alertMessage = "Failed to update expense: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func deleteExpense() async {
// --------------------------------------------Ensure there's an expense selected to delete-------------------------------------
          guard let expenseId = expenseToEdit?.id else {
              print("No expense selected for deletion")
              return
          }

// -------------------------------------------------Get current user ID--------------------------------------------------------
          guard let userId = Auth.auth().currentUser?.uid else {
              print("User not logged in")
              return
          }

//-------------------------------------- Define the path to the document to delete----------------------------------------------
          let documentReference = Firestore.firestore().collection("users").document(userId).collection("expenses").document(expenseId)

          do {
//-------------------------------------------------Perform the deletion----------------------------------------------------------
              try await documentReference.delete()
              print("Expense successfully deleted")
          } catch {
              print("Error deleting expense: \(error)")
              
          }
      }
}
