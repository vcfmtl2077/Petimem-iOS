//
//  AddNewPetView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import PhotosUI

struct AddNewPetView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AddPetViewModel()
    
    let gender = ["Female","Male"]
    let colors: [String] = ["expenseCardColor","expenseCardColor1","expenseCardColor2","expenseCardColor3","expenseCardColor4"]
    @State private var tint: String = "expenseCardColor"
    
    var body: some View {
        ZStack{
            Color("bgHomeColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Rectangle()
                    .foregroundColor(Color("bgFrameColor"))
                    .frame(width: 330,height: 500)
                    .cornerRadius(20)
                Spacer()
                    Button("Add"){
                        Task {
                            await viewModel.addPet()
                    }
                }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 55)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
                    .onChange(of: viewModel.isPetAddedSuccessfully, initial: false) {
                        dismiss()
                    }
                Spacer()
                Text("")
                
            }
            VStack(spacing: 15){
                Spacer()
    //---------------------------profile picture selection---------------------------
                PhotosPicker(selection: $viewModel.selectedItem){
                    if let profileImage = viewModel.profileImage{
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }else{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(Color(.systemGray))
                    }
                }
    //------------------------------------Name row--------------------------------------
                VStack(spacing:0){
                    
                    Text("Name:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                        .frame(width: 300, alignment: .leading)
                    
                    TextField("Your pet name", text: $viewModel.name)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.blue)
                        )
                    
                }
                
    //------------------------------------Gender row------------------------------------
                HStack(spacing: 40){
                    Text("Gender:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                    
                    ForEach(gender, id: \.self) { option in
                        HStack {
                            Text(option)
                            if viewModel.gender == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            // This sets the selected option to the one that was tapped
                            self.viewModel.gender = option
                        }
                    }
                    
                }
                
    //------------------------------------Birthday row----------------------------------
                HStack(spacing:100){
                    Text("Birthday:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                    
                    DatePicker("",selection: $viewModel.birthday,in: ...Date(),displayedComponents: .date) // Only show the date picker, not time
                        .labelsHidden()
                    }
       //---------------------------selection of card color---------------------------
                VStack(spacing: 0){
                    Text("Card Color:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                        .frame(width: 300, alignment: .leading)
                    HStack(spacing: 20){
                        ForEach(colors, id: \.self){ color in
                            Circle()
                                .foregroundColor(Color(color))
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    withAnimation(.snappy){
                                        tint = color
                                        viewModel.tint = tint 
                                    }
                                }
                        }
                    }
                    
                }
                Spacer()
                Spacer()
                }
            }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Notification"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Add New Pet")
        }
    }

#Preview {
    AddNewPetView()
}
