//
//  ExpenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class ExpenseViewModel: ObservableObject {
    @Published private(set) var expenses: [DBExpense] = []
    
    func getExpenses() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        do {
            let fetchedexpenses = try await ExpenseManager.shared.getExpenses(forUserID: userID)
            DispatchQueue.main.async {
                self.expenses = fetchedexpenses
                print("Fetched expenses: \(fetchedexpenses)")
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }
    
    func expensesSortedByCategory(for category: Category) -> [DBExpense] {
            expenses.filter { $0.category == category.rawValue }
            .sorted { $0.dateAdded ?? .now > $1.dateAdded ?? .now }
        }
}


struct ExpenseView: View {
    //Environment property
    @Environment(\.modelContext) var context
    @StateObject var viewModel = ExpenseViewModel()
    
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var totalAmount = 1000.00
    @State private var selectedCategory: Category = .food
    @State private var showFilterView = false
    @State private var searchText = ""
    @State private var showingAddNewExpense = false
    @State private var selectedExpense: DBExpense?
    @State private var showingExpenseDetail = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    
//--------------------------------Date filter Button-----------------------------------------
                    Button(action: {
                        showFilterView = true
                    }, label: {
                        Text("\(format(date: startDate, format: "dd - MMM yyyy")) to \(format(date: endDate, format: "dd -  MMM yyyy"))")
                            .foregroundStyle(.buttonAdd)
                    })
//---------------------------Top summary of total amount spent card--------------------------
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("bgFrameColor"))
                        
                        Text("\(currencyToString(-totalAmount))")
                            .font(.title.bold())
                            .foregroundStyle(.buttonAdd)
                        
                    }
//-------------------------------------List of expenses--------------------------------------
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
                            
                            ForEach(viewModel.expensesSortedByCategory(for: selectedCategory)) { expense in
                                NavigationLink{
                                AddNewExpenseView(expenseToEdit: expense)
                                    } label: {
                                        ExpenseCardView(expense: expense)
                                    }
                                    .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Expense")
            .onAppear {
                Task {
                    await viewModel.getExpenses()
                }
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    showingAddNewExpense = true
                }
            }
            .background(
                        NavigationLink(destination: AddNewExpenseView(), isActive: $showingAddNewExpense) {
                            EmptyView()
                                }
                            )
            .navigationDestination(isPresented: $showingExpenseDetail) {
                            if let expenseToEdit = selectedExpense {
                                AddNewExpenseView(expenseToEdit: expenseToEdit)
                            } else {
                                AddNewExpenseView()
                            }
                        }
            .blur(radius: showFilterView ? 8: 0)
            .disabled(showFilterView)
            .searchable(text: $searchText)
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
    ExpenseView()
}
