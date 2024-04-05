//
//  AddNewExpenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI

struct AddNewExpenseView: View {
    // Environment property
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AddExpenseViewModel()
    var expenseToEdit: DBExpense?
    let colors: [String] = ["expenseCardColor","expenseCardColor1","expenseCardColor2","expenseCardColor3","expenseCardColor4"]
    @State private var tint: String = "expenseCardColor"
    @State private var shouldNavigateToExpenseView = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack{
                    //--------------------------------preview--------------------------------
                    ExpenseCardView(expense: .init(
                        id: "preview",
                        title: viewModel.title.isEmpty ? "Title" : viewModel.title,
                        amount: viewModel.amount,
                        category: viewModel.selectedCategory,
                        dateAdded: viewModel.dateAdded,
                        tint: viewModel.tint))
                    
                    Rectangle()
                        .foregroundColor(Color("bgFrameColor"))
                        .frame(width: 330,height: 450)
                        .cornerRadius(20)
                    
                    //--------------------------------Save button--------------------------------
                    Button {
                        Task {
                            if expenseToEdit == nil {
                                await viewModel.addExpense()
                            } else {
                                await viewModel.updateExpense()
                            }
                            dismiss()
                        }
                    } label: {
                        Text(expenseToEdit == nil ? "Add" : "Save")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width: 330, height: 56)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                    .disabled(viewModel.title.isEmpty)
                    .opacity(viewModel.title.isEmpty ? 0.5 : 1)
                }
                    VStack(spacing: 25){
                        
                        //Category Section
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                CategoryView(category: category)
                                    .tag(category)
                            }
                        }
                        //Title Section
                        VStack(spacing: 0){
                            Text("Title:")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("buttonAddColor"))
                                .frame(width: 300, alignment: .leading)
                            TextField("within 12 characters", text: $viewModel.title)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( Color.blue)
                                )
                                .frame(width: 300)
                            //constraint 12 characters
                                .onChange(of: viewModel.title) { newValue in
                                    if newValue.count > 12 {
                                        viewModel.title = String(newValue.prefix(12))
                                    }
                                }
                            
                        }
                        
                        //Amount Section
                        VStack(spacing: 0){
                            Text("Amount:")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("buttonAddColor"))
                                .frame(width: 300, alignment: .leading)
                            TextField("Amount Spent", value: $viewModel.amount, formatter: numberFormatter )
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( Color.blue)
                                )
                                .frame(width: 300)
                                .keyboardType(.decimalPad)
                        }
                        
                        //Date added section
                        HStack{
                            Spacer()
                            Text("Date:")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("buttonAddColor"))
                            Spacer()
                            Spacer()
                            Spacer()
                            DatePicker("", selection: $viewModel.dateAdded, displayedComponents: [.date])
                                .labelsHidden()
                            Spacer()
                        }
                        
                        //selection of card color
                        VStack(spacing: 0){
                            Text("Card Color:")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("buttonAddColor"))
                                .frame(width: 300, alignment: .leading)
                            HStack(spacing: 20){
                                ForEach(colors, id: \.self){ color in
                                    Circle()
                                        .foregroundColor(Color(color))
                                        .frame(width: 40, height: 40)
                                        .onTapGesture {
                                            withAnimation(.snappy){
                                                tint = color
                                                viewModel.tint = tint
                                            }
                                        }
                                }
                            }
                            
                        }
                    }
                }
            .navigationTitle("\(expenseToEdit == nil ? "Add": "Edit") Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let _ = expenseToEdit {
                        Button(action: {
                            // Use a Task to call the asynchronous deleteExpense function
                            Task {
                                await viewModel.deleteExpense()
                                // After deleting, you might want to perform additional actions, like navigating away
                                dismiss()
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }            .onAppear(perform: {
                if let expenseToEdit{
                    viewModel.title = expenseToEdit.title
                    viewModel.amount = expenseToEdit.amount
                    if let category = Category(rawValue: expenseToEdit.category) {
                                viewModel.selectedCategory = category
                            } else {
                                print("Unknown category: \(expenseToEdit.category)")
                            }
                    viewModel.dateAdded = expenseToEdit.dateAdded ?? Date()
                    viewModel.tint = expenseToEdit.tint
                    viewModel.expenseToEdit = expenseToEdit
                }
            })
            }
        }
        
        var numberFormatter: NumberFormatter{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            return formatter
        }
    }


#Preview {
    AddNewExpenseView()
}
