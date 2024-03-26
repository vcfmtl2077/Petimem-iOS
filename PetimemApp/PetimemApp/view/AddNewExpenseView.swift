//
//  AddNewExpenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import SwiftData

struct AddNewExpenseView: View {
    // Environment property
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    var editExpense: Expense?
    
    @State private var title: String = ""
    @State private var amount: Double = .zero
    @State private var selectedCategory: Category = .food
    @State private var dateAdded: Date = .now
    @State private var tint: String = "expenseCardColor"
    let colors: [String] = ["expenseCardColor","expenseCardColor1","expenseCardColor2","expenseCardColor3","expenseCardColor4"]
    @State private var shouldNavigateToExpenseView = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    //preview
                    ExpenseCardView(Expense: .init(
                        title: title.isEmpty ? "Title" : title,
                        amount: amount,
                        category: selectedCategory,
                        dateAdded: dateAdded,
                        tint: tint))
                    Spacer()
                    Rectangle()
                        .foregroundColor(Color("bgFrameColor"))
                        .frame(width: 330,height: 450)
                        .cornerRadius(20)
                    Spacer()
                    
                    Button(action: save) {
                        Text("\(editExpense == nil ? "Add": "Save")")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width: 330, height: 56)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                    .disabled(title.isEmpty)
                    .opacity(title == "" ? 0.5 : 1)
                }
                VStack(spacing: 25){
                    
                    //Category Section
                    Picker("Category", selection: $selectedCategory) {
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
                        TextField("within 12 characters", text: $title)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke( Color.blue)
                            )
                            .frame(width: 300)
                        //constraint 12 characters
                            .onChange(of: title) { newValue in
                                if newValue.count > 12 {
                                    title = String(newValue.prefix(12))
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
                        TextField("Amount Spent", value: $amount, formatter: numberFormatter )
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
                        DatePicker("", selection: $dateAdded, displayedComponents: [.date])
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
                                        }
                                    }
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("\(editExpense == nil ? "Add": "Edit") Expense")
            .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if let editExpense = editExpense {
                                Button(action: deleteExpense) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
            .onAppear(perform: {
                if let editExpense{
                    title = editExpense.title
                    amount = editExpense.amount
                    if let category = editExpense.rawCategory{
                        self.selectedCategory = selectedCategory
                    }
                    dateAdded = editExpense.dateAdded
                    tint = editExpense.tint
                    
                }
            })
        }
    }
    //saving items to swiftData
    func save(){
        if editExpense != nil {
            editExpense?.title = title
            editExpense?.amount = amount
            editExpense?.category = selectedCategory.rawValue
            editExpense?.dateAdded = dateAdded
            editExpense?.tint = tint
        } else {
            let expense = Expense(title: title, amount: amount, category: selectedCategory, dateAdded: dateAdded, tint: tint)
            
            context.insert(expense)
        }
        dismiss()
    }
    
    //deleting items from swiftData
    func deleteExpense() {
        if let editExpense = editExpense {
            context.delete(editExpense)
            dismiss()
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
