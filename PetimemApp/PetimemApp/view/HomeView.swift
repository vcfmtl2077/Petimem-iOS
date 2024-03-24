//
//  homeView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Button("Add Your Pet"){
        }
        .foregroundColor(.white)
        .frame(width: 330, height: 55)
        .background(Color("buttonAddColor"))
        .cornerRadius(20)
    }
}

#Preview {
    HomeView()
}
