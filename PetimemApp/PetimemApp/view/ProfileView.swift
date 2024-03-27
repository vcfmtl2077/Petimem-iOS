//
//  ProfileView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                
                Button(role: .destructive){
                    Task{
                        do{
                            try await viewModel.deleteAccount()
                            print("Account deleted!")
                        }catch{
                            print(error)
                        }
                    }
                } label: {
                    Text("Delete Account")
                }
                .foregroundColor(.white)
                .frame(width: 330, height: 50)
                .background(.red)
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    ProfileView()
}
