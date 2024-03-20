//
//  tabView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-19.
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
                HStack(spacing: 25) {
                    Button(action: { selectedTab = .home }) {
                        VStack {
                            Image("homeIcon")
                                .resizable()
                                .frame(width: selectedTab == .home ? 60 : 50, height: selectedTab == .home ? 75 : 65)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .event }) {
                        VStack {
                            Image("eventIcon")
                                .resizable()
                                .frame(width: selectedTab == .event ? 60 : 50, height: selectedTab == .event ? 75 : 65)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .moment }) {
                        VStack {
                            Image("momentIcon")
                                .resizable()
                                .frame(width: selectedTab == .moment ? 63 : 53, height: selectedTab == .moment ? 75 : 65)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .expense}) {
                        VStack {
                            Image("expenseIcon")
                                .resizable()
                                .frame(width: selectedTab == .expense ? 63 : 53, height: selectedTab == .expense ? 78 : 68)
                        }
                    }
                    
                    
                    Button(action: { selectedTab = .more}) {
                        VStack {
                            Image("moreIcon")
                                .resizable()
                                .frame(width: selectedTab == .more ? 50 : 40, height: selectedTab == .more ? 65 : 55)
                        }
                    }
                }
            }
        }
        .frame(height: 80)
    }
}

