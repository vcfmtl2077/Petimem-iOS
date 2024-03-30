//
//  HomeView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI

struct HomeView: View {
    @State private var showingAddNewPetView = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                Button("Add Your Pet"){
                    showingAddNewPetView = true
                }
                .foregroundColor(.white)
                .frame(width: 330, height: 55)
                .background(Color("buttonAddColor"))
                .cornerRadius(20)
            }
            .navigationTitle("Pets")
        }
        
        NavigationLink(destination: AddNewPetView(), isActive: $showingAddNewPetView) {
                            EmptyView()
                        }.hidden()
    }
}

#Preview {
    HomeView()
}
