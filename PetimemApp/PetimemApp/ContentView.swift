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
        VStack {
            
            switch selectedTab {
                case .home:
                Text("Home Content")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
