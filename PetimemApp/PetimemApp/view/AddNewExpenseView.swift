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
    @State private var showingDeleteAlert = false
    
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
                        .frame(width: 330,height: 520)
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
                            TextField("within 35 characters", text: $viewModel.title)
                                .autocapitalization(.none)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( Color.blue)
                                )
                                .frame(width: 300)
                            // Disablesss automatic capitalization
                                .textInputAutocapitalization(.none)
                            //constraint 12 characters
                                .onChange(of: viewModel.title) { newValue in
                                    if newValue.count > 35 {
                                        viewModel.title = String(newValue.prefix(35))
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
                        
                        VStack(spacing: 0){
                            Text("Card Color:")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color("buttonAddColor"))
                                .frame(width: 300, alignment: .leading)
                            HStack(spacing: 20){
                                ForEach(colors, id: \.self){ color in
                                    Circle()
                                        .foregroundColor(Color(color).opacity(color == tint ? 1 : 0.5))
                                        .frame(width: color == tint ? 50 : 40, height: color == tint ? 50 : 40)
                                        .onTapGesture {
                                            withAnimation(.spring()){
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
                            showingDeleteAlert = true // Show the alert when the button is pressed
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }            
            .onAppear(perform: {
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
            .alert("Confirm Deletion", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteExpense()
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this expense?")
            }
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
