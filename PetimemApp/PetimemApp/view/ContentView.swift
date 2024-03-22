//
//  ContentView.swift
//  PetimemApp
//
//  Created by wei feng on 2024-03-15.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack {
                    switch selectedTab {
                    case .home:
                        Button("Add Your Pet"){
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 330, height: 55)
                        .background(Color("buttonAddColor"))
                        .cornerRadius(20)
                        
                    case .event:
                        Text("Event Content")
                    case .moment:
                        Text("Moment Content")
                    case .expense:
                        Text("Expense Content")
                    case .more:
                        Text("More Content")
                    }
                    
                    Spacer()
                    tabView(selectedTab: $selectedTab)
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
