//
//  ProfileView.swift
//  PetimemApp
//
//  Created by wei feng on 2024-03-24.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showingHomeScreen: Bool
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                List {
                    Section(header: Text("Account")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Profile", destination: Text("Profile View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                            NavigationLink("Password", destination: Text("Password View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                                .cornerRadius(40)


                        }
                    
                    Section(header: Text("Setting")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Permissions", destination: Text("Permissions View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                            NavigationLink("Storage", destination: Text("Storage View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                        }
                    
                    Section(header: Text("Premium")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("buttonAddColor"))) {
                            NavigationLink("Upgrade to premium", destination: Text("Premium View"))
                                .font(.system(size: 18))
                                .foregroundColor(Color("buttonAddColor"))
                                .listRowBackground(Color("bgFrameColor"))
                        }
                    
                    Section(header: Text("Other")
                        .textCase(nil)
                        .font(.system(size: 30, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                        .foregroundColor(Color("buttonAddColor"))) {
                            Button(action: {
                                Task{
                                    do{
                                        try viewModel.signOut()
                                        showingHomeScreen = false
                                    }catch{
                                        
                                    }
                                }
                                   }) {
                                       Text("Log out")
                                           .frame(minWidth: 0, maxWidth: .infinity)
                                           .foregroundColor(.red)
                                           .font(.system(size: 20))
                                           .padding()
                                           .background(Color("bgFrameColor"))
                                           .cornerRadius(30)
                                   }
                                   .background(Color("bgHomeColor"))
                                   .listRowInsets(EdgeInsets())
                                   .buttonStyle(PlainButtonStyle())
                        }
                    
                }
                .scrollContentBackground(.hidden)
            }
            //            .navigationTitle("Pets")
        }
    }
}

#Preview {
    SettingsView(showingHomeScreen: .constant(true))
}
