//
//  AddNewPetView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import PhotosUI

struct AddNewPetView: View {
@StateObject var viewModel = AddPetViewModel()
let gender = ["Female","Male"]

    
    var body: some View {
        ZStack{
            Color("bgHomeColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Rectangle()
                    .foregroundColor(Color("bgFrameColor"))
                    .frame(width: 330,height: 450)
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
                Spacer()
                Text("")
                
            }
            VStack(spacing: 15){
                Spacer()
                //profile picture selection
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
                Text("")
                // rest of the form inputs
                // Name row
                HStack{
                    Spacer()
                    Text("Name:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                    Text("")
                    Text("")
                    TextField("Your pet name", text: $viewModel.name)
                        .padding()
                        .frame(width: 200, height: 35)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.blue)
                        )
                    Spacer()
                }
               
                
                
                //Gender row
                HStack{
                    Spacer()
                    Text("Gender:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                    Spacer()
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
                    Spacer()
                }
                
                //Birthday row
                HStack{
                    Spacer()
                    Text("Birthday:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("buttonAddColor"))
                    
                    Spacer()
                    Text("")
                    Text("")
                    
                    DatePicker("",selection: $viewModel.birthday,in: ...Date(),displayedComponents: .date) // Only show the date picker, not time
                        .labelsHidden()
                    Spacer()
                    }
                Spacer()
                Spacer()
                }
            }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Notification"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        }
    
    }

#Preview {
    AddNewPetView()
}
