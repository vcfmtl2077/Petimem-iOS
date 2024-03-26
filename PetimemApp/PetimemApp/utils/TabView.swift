//
//  TabView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

enum Tab {
    case home
    case event
    case moment
    case expense
    case more
}

struct tabView: View {
    @Binding var selectedTab: Tab
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.blue)
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: 80)
             
            VStack{
                Text("")
                Text("")
                HStack(spacing: 34) {
                    Button(action: { selectedTab = .home }) {
                        VStack {
                            Image("homeIcon")
                                .resizable()
                                .frame(width: selectedTab == .home ? 50 : 40, height: selectedTab == .home ? 65 : 55)
                                .opacity(selectedTab == .home ? 1.0 : 0.7)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .event }) {
                        VStack {
                            Image("eventIcon")
                                .resizable()
                                .frame(width: selectedTab == .event ? 50 : 40, height: selectedTab == .event ? 65 : 55)
                                .opacity(selectedTab == .event ? 1.0 : 0.7)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .moment }) {
                        VStack {
                            Image("momentIcon")
                                .resizable()
                                .frame(width: selectedTab == .moment ? 54 : 44, height: selectedTab == .moment ? 65 : 55)
                                .opacity(selectedTab == .moment ? 1.0 : 0.7)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .expense}) {
                        VStack {
                            Image("expenseIcon")
                                .resizable()
                                .frame(width: selectedTab == .expense ? 57 : 47, height: selectedTab == .expense ? 68 : 58)
                                .opacity(selectedTab == .expense ? 1.0 : 0.7)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .more}) {
                        VStack {
                            Image("moreIcon")
                                .resizable()
                                .frame(width: selectedTab == .more ? 40 : 30, height: selectedTab == .more ? 55 : 50)
                                .opacity(selectedTab == .more ? 1.0 : 0.7)
                        }
                    }
                }
            }
        }
        .frame(height: 75)
    }
}
