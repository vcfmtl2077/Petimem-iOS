//
//  AddNewPetView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-25.
//

import SwiftUI
import PhotosUI

struct AddNewPetView: View {
    // Environment property
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AddPetViewModel()
    
    let gender = ["Female","Male"]
    let colors: [String] = ["expenseCardColor","expenseCardColor1","expenseCardColor2","expenseCardColor3","expenseCardColor4"]
    @State private var tint: String = "expenseCardColor"
    
    @Binding var showingAddNewPet: Bool
    //for deletion
    @State private var showingDeleteAlert = false
    
    //for update
    var petToEdit: DBPets?
   
    var body: some View {
        ZStack{
            Color("bgHomeColor")
                .ignoresSafeArea()
            VStack{
                Spacer()
                Rectangle()
                    .foregroundColor(Color(tint))
                    .frame(width: 330,height: 500)
                    .cornerRadius(20)
                    .opacity(0.5)
                Spacer()
//--------------------------------------------Add/Edit Button------------------------------
                    Button{
                        Task {
                            if petToEdit == nil{
                                await viewModel.addPet()
                                if viewModel.isPetAddedSuccessfully, let selectedItem = viewModel.selectedItem {
                                    await viewModel.saveProfileImage(item: selectedItem)
                                    showingAddNewPet = false
                                } else {
                                    viewModel.alertMessage = viewModel.isPetAddedSuccessfully ? "No picture selected to save." : "Please fill in all fields."
                                    print("No picture selected to save.")
                                }
                            } else {
                                await viewModel.updatePet()
                                            // If a new image was selected, save it. Otherwise, retain the existing image.
                                            if let selectedItem = viewModel.selectedItem {
                                                await viewModel.saveProfileImage(item: selectedItem)
                                            }
                                            showingAddNewPet = false
                                
                            }
                    }
                    }label: {
                        Text(petToEdit == nil ? "Add" : "Save")
                            .foregroundColor(.white)
                            .frame(width: 330, height: 55)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                    .disabled(viewModel.name.isEmpty || viewModel.profileImage == nil )
                    .opacity(viewModel.name.isEmpty || viewModel.profileImage == nil ? 0.5 : 1)
                Spacer()
                Text("")
            }
            VStack(spacing: 15){
                Spacer()
//------------------------------------------profile picture selection---------------------------
                PhotosPicker(selection: $viewModel.selectedItem){
                    if let profileImage = viewModel.profileImage{
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }else{
                        Image(systemName: "dog.circle.fill")
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
                        .autocapitalization(.none)
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
                                .foregroundColor(Color(color).opacity(color == tint ? 1 : 0.5))
                                .frame(width: color == tint ? 50 : 40, height: color == tint ? 50 : 40)
                                .onTapGesture {
                                    withAnimation(.spring()){
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
        .navigationTitle("\(petToEdit == nil ? "Add": "Edit") Pet")
        .onChange(of: viewModel.isPetAddedSuccessfully, initial: false) {
            dismiss()
        }
        //pop existing values to the form
        .onAppear(perform: {
            
            if let petToEdit{
                if let photoUrl = petToEdit.photoUrl {
                            Task {
                                await viewModel.loadImage(from: photoUrl)
                            }
                        }
                viewModel.name = petToEdit.name
                viewModel.gender = petToEdit.gender
                viewModel.birthday = petToEdit.birthday
                viewModel.tint = petToEdit.tint
                viewModel.petToEdit = petToEdit
            }
        })
        }
    }

