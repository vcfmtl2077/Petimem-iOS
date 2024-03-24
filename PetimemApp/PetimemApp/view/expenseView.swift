//
//  expenseView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-22.
//

import SwiftUI

struct expenseView: View {
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var totalAmount = 1000.00
    @State private var selectedCategory: Category = .food
    @State private var showFilterView = false
    @State private var searchText = ""
    @State private var showingAddNewExpense = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView(.vertical){
                    
                    //Date filter Button
                    Button(action: {
                        showFilterView = true
                    }, label: {
                        Text("\(format(date: startDate, format: "dd - MMM yyyy")) to \(format(date: endDate, format: "dd -  MMM yyyy"))")
                            .foregroundStyle(.buttonAdd)
                    })
                    //Card View
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("bgFrameColor"))
                        
                        Text("\(currencyToString(-totalAmount))")
                            .font(.title.bold())
                            .foregroundStyle(.buttonAdd)
                        
                    }
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
                            ForEach(sampleExpenses.filter { $0.category == selectedCategory.rawValue }, id: \.id) { expense in
                                ExpenseCardView(Expense: expense)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddNewExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .background(
                                NavigationLink(destination: addNewExpenseView(), isActive: $showingAddNewExpense) {
                                    EmptyView()
                                }
                            )
            .blur(radius: showFilterView ? 8: 0)
            .disabled(showFilterView)
            .searchable(text: $searchText)
                }
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

struct CategoryView: View {
    let category: Category

    var body: some View {
        VStack {
            Image(category.rawValue)
            Text(category.rawValue)
        }
    }
}

struct ExpenseCardView: View {
    var Expense: expense
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
            .frame(width: 320, height: 50)
            .foregroundColor(Color("expenseCardColor"))
            
                
            
            HStack(spacing:15){
                Spacer()
                Image(Expense.category)
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack{
                    
                    Text(Expense.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text(format(date: Expense.dateAdded, format:"dd MMM yyyy"))
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Text(currencyToString(Expense.amount, allowedDigites: 2))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    var onSubmit:(Date,Date) -> ()
    var onClose: () -> ()
    var body: some View {
        VStack(spacing: 15){
            DatePicker("Start", selection: $start, displayedComponents: [.date])
            DatePicker("End", selection: $end, displayedComponents: [.date])
            
            HStack(spacing: 15){
                Button("Cancel"){
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Filter"){
                    onSubmit(start,end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.buttonAdd)
            }
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}

#Preview {
    //ExpenseCardView(Expense: sampleExpenses[0])
    expenseView()
}
