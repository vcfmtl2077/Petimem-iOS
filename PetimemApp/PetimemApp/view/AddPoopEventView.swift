//
//  AddPoopEventView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-04-07.
//

import SwiftUI

struct AddPoopEventView: View {
    // Environment property
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AddPoopEventViewModel()
    
    let pets: [DBPets]
    let consistencyOptions = ["Select","Liquid", "Soft", "Firm", "Hard"]
    let colorOptions = ["Select","Brown", "Black", "Red", "Green"]
    let colors = ["expenseCardColor1","alertRed"]
    
    //for update
    var poopEventToEdit: DBPoop?
    
    // for deletetion
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("bgHomeColor").ignoresSafeArea()
                VStack{
                    Rectangle()
                        .foregroundColor(Color("bgFrameColor"))
                        .frame(width: 330,height: 550)
                        .cornerRadius(20)
//---------------------------------------------Add/Edit button------------------------------------
                    Button {
                        Task {
                              if poopEventToEdit == nil{
                                  await viewModel.addPoopEvent()
                              } else {
                                  await viewModel.updatePoop()
                              }
                          }
                    }label: {
                        Text(poopEventToEdit == nil ? "Add" : "Save")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width: 330, height: 56)
                            .background(Color("buttonAddColor"))
                            .cornerRadius(20)
                    }
                }
                VStack(spacing: 15) {
                    Text(viewModel.alertMessage)
                        .foregroundStyle(.red)
                    ZStack{
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color("bgColor"))
                        Image("poop")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
//---------------------------------------------pet picker---------------------------------------
                    PetPickerView(selectedPetId: $viewModel.selectedPetId, pets: pets)
//---------------------------------------------Time---------------------------------------
                    HStack(){
                        Text("Time:")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Color("buttonAddColor"))
                        DatePicker("Date & Time", selection: $viewModel.dateAndTime, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
//---------------------------------------------Consistency---------------------------------------
                    ConsistencyPickerView(selectedConsistency: $viewModel.consistency, options: consistencyOptions)
//---------------------------------------------Poop color---------------------------------------
                    ColorPickerView(selectedColor: $viewModel.color, options: colorOptions)
//---------------------------------------------blood or mucus---------------------------------------
                    EventTogglesView(bloodOrMucus: $viewModel.bloodOrMucus, foreignObjects: $viewModel.foreignObjects)
//---------------------------------------------Card color selection---------------------------------------
                    TintSelectionView(colors: colors, selectedTint: $viewModel.tint)
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("\(poopEventToEdit == nil ? "Add": "Edit") Poop Event")

//-----------------------------------------pop existing values to the form----------------------------------
            .onAppear(perform: {
                if let poopEventToEdit{
                    viewModel.selectedPetId = poopEventToEdit.petId
                    viewModel.dateAndTime = poopEventToEdit.dateAndTime
                    viewModel.consistency = poopEventToEdit.consistency
                    viewModel.color = poopEventToEdit.color
                    viewModel.bloodOrMucus = poopEventToEdit.bloodOrMucus
                    viewModel.foreignObjects = poopEventToEdit.foreignObjects
                    viewModel.tint = poopEventToEdit.tint
                    viewModel.poopEventToEdit = poopEventToEdit
                }
            })
            
// -----------------------------------------deletion button--------------------------------------------------
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let _ = poopEventToEdit {
                        Button(action: {
                            showingDeleteAlert = true // Show the alert when the button is pressed
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .alert("Confirm Deletion", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deletePoop()
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this expense?")
            }
            
//-------------------------------dismiss the view when event was added/ updated successfully------------------------------------
            .onChange(of: viewModel.isPoopAddedSuccessfully) { success in
                            if success {
                                dismiss()
                            }
                        }
        }
    }
}
struct PetPickerView: View {
    @Binding var selectedPetId: String
    let pets: [DBPets]
    
    var body: some View {
        Picker("Pet", selection: $selectedPetId) {
            Text("Select a pet").tag("Select a pet")
            ForEach(pets, id: \.id) { pet in
                Text(pet.name).tag(pet.id)
            }
        }
        .pickerStyle(.menu)
    }
}

struct ConsistencyPickerView: View {
    @Binding var selectedConsistency: String
    let options: [String]
    
    var body: some View {
        HStack(spacing: 70){
            Text("Consistency:")
                .bold()
                .font(.title3)
                .foregroundColor(Color("buttonAddColor"))
            Picker("Consistency", selection: $selectedConsistency) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let options: [String]
    
    var body: some View {
        HStack(spacing: 130){
            Text("Color:")
                .bold()
                .font(.title3)
                .foregroundColor(Color("buttonAddColor"))
            Picker("Color", selection: $selectedColor) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
        }
    }
}

struct EventTogglesView: View {
    @Binding var bloodOrMucus: Bool
    @Binding var foreignObjects: Bool
    
    var body: some View {
        VStack {
            Toggle(isOn: $bloodOrMucus) {
                Text("Blood or Mucus")
                    .bold()
                    .font(.title3)
                    .foregroundColor(Color("buttonAddColor"))
            }
            .frame(width: 275)
            
            Toggle(isOn: $foreignObjects) {
                Text("Foreign Objects")
                    .bold()
                    .font(.title3)
                    .foregroundColor(Color("buttonAddColor"))
            }
            .frame(width: 275)
        }
    }
}

struct TintSelectionView: View {
    let colors: [String]
    @Binding var selectedTint: String
    
    var body: some View {
        VStack(spacing: 0){
            Text("Card Color:")
                .bold()
                .font(.title3)
                .foregroundColor(Color("buttonAddColor"))
                .frame(width: 275, alignment: .leading)
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(Color(color).opacity(color == selectedTint ? 1 : 0.5))
                        .frame(width: color == selectedTint ? 50 : 40, height: color == selectedTint ? 50 : 40)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedTint = color
                            }
                        }
                }
            }
        }
    }
}
