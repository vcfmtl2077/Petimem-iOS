//
//  ContentView.swift
//  PetimemApp
//
//  Created by wei feng on 2024-03-15.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @Binding var showingHomeScreen:Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                    Color("bgHomeColor")
                        .ignoresSafeArea()
                    VStack {
                        switch selectedTab {
                        case .home:
                            HomeView()
                        case .event:
                            EventView()
                        case .moment:
                            Text("Moment Content")
                        case .expense:
                            ExpenseView()
                        case .more:
                            SettingsView(showingHomeScreen: $showingHomeScreen)
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
        ContentView(showingHomeScreen: .constant(true))
       
    }
}

