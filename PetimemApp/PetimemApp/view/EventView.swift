//
//  EventView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-07.
//

import SwiftUI
import FirebaseAuth

struct EventView: View {
    @State private var pets: [DBPets] = []
    @State private var showingAddPoopEventView = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                ScrollView{
                    VStack(spacing: 30){
                        VStack(spacing: 0){
                            Text("Rountine")
                                .bold()
                                .foregroundStyle(Color("buttonAddColor"))
//------------------------------Dividing sections line-------------------------------------
                            Rectangle()
                                .frame(width: 320, height: 2)
                                .foregroundColor(Color("buttonAddColor"))
                        }
// ---------------------------------------First line--------------------------------------
                        HStack(spacing: 40){
                            Button(action: {
//---------------------------------------pass feed view------------------------------------
                                print("Image Button tapped!")
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("feed")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            
                            Button(action: {
                                Task {
                                  if let userID = Auth.auth().currentUser?.uid {
                                                   do {
                                                       pets = try await PetManager.shared.getPets(forUserID: userID)
                                                   } catch {
                                                       print("Error fetching pets: \(error)")
                                                   }
                                               }
                                           }
                                showingAddPoopEventView = true
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("poop")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .sheet(isPresented: $showingAddPoopEventView) {
                                       AddPoopEventView(pets: pets)
                                   }
                            
                            
                        }
                        //second line
                        HStack(spacing: 40){
                            Button(action: {
//-----------------------------------------pass feed view---------------------------------
                                print("Image Button tapped!")
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("walk")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                        VStack(spacing: 0){
                            Text("Care")
                                .bold()
                                .foregroundStyle(Color("buttonAddColor"))
//------------------------------------Dividing sections line-----------------------------
                            Rectangle()
                                .frame(width: 330, height: 2)
                                .foregroundColor(Color("buttonAddColor"))
                        }
                        // Third line
                        HStack(spacing: 40){
                            Button(action: {
//-------------------------------------pass feed view-------------------------------------
                                print("Image Button tapped!")
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("med")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            
                            Button(action: {
//---------------------------------------pass feed view------------------------------------
                                print("Image Button tapped!")
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("vaccine")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
// ---------------------------------------fourth line--------------------------------------
                        HStack(spacing: 40){
                            Button(action: {
//-------------------------------------pass feed view--------------------------------------
                                print("Image Button tapped!")
                            }) {
                                ZStack{
                                    Circle()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(Color("bgFrameColor"))
                                    Image("tooth")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Event")
        }
    }
}

#Preview {
    EventView()
}
