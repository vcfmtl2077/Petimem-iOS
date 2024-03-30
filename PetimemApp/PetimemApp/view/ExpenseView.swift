//
//  ExpenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    //Environment property
    @Environment(\.modelContext) var context
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var totalAmount = 1000.00
    @State private var selectedCategory: Category = .food
    @State private var showFilterView = false
    @State private var searchText = ""
    @State private var showingAddNewExpense = false
    @State private var tint = "expenseCardColor"
    
    @Query(sort: [SortDescriptor(\Expense.dateAdded, order: .reverse)], animation: .snappy) var expenses: [Expense]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    
            //---------------------Date filter Button---------------------
                    Button(action: {
                        showFilterView = true
                    }, label: {
                        Text("\(format(date: startDate, format: "dd - MMM yyyy")) to \(format(date: endDate, format: "dd -  MMM yyyy"))")
                            .foregroundStyle(.buttonAdd)
                    })
           //-------------------Top summary of total amount spent card-------------------
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("bgFrameColor"))
                        
                        Text("\(currencyToString(-totalAmount))")
                            .font(.title.bold())
                            .foregroundStyle(.buttonAdd)
                        
                    }
          //---------------------List of expenses---------------------
                    ZStack{
                        Color("bgExpenseFrameColor")
                            .frame(width: 350)
                            .cornerRadius(25.0)
                            
                        VStack{
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(Category.allCases, id: \.self) { category in
                                    CategoryView(category: category)
                                        .tag(category)
                                }
                                .frame(width: 300, height: 80)
                            }
                            
                            ForEach(expenses.filter { $0.category == selectedCategory.rawValue }, id: \.id){ expense in
                                NavigationLink{
                                    AddNewExpenseView(editExpense: expense)
                                } label: {
                                    ExpenseCardView(Expense: expense)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    Button("Add New Expense"){
                        showingAddNewExpense = true
                    }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 55)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
                }
            }
            .navigationTitle("Expense")
            /*.toolbar {
                    Button("Add", systemImage: "plus") {
                        showingAddNewExpense = true
                    }
            }
            .navigationDestination(isPresented: $showingAddNewExpense){
                AddNewExpenseView()
            }*/
            .blur(radius: showFilterView ? 8: 0)
            .disabled(showFilterView)
            .searchable(text: $searchText)
                }
        NavigationLink(destination: AddNewExpenseView(), isActive: $showingAddNewExpense) {
                            EmptyView()
                        }.hidden()
        .overlay{
            ZStack{
                if showFilterView{
                    DateFilterView(start: startDate, end: endDate, onSubmit: {
                        start, end in
                        startDate = start
                        endDate = end
                        showFilterView = false
                    }, onClose: {
                        showFilterView = false
                    })
                    .transition(.move(edge: .leading))
                }
            }
        }
        .animation(.snappy, value: showFilterView)
    }
}
    

func format(date: Date, format: String) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func currencyToString(_ value: Double, allowedDigites: Int = 2) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = allowedDigites
    
    return formatter.string(from: .init(value: value)) ?? ""
}



#Preview {
    //ExpenseCardView(Expense: sampleExpenses[0])
    ExpenseView()
}
