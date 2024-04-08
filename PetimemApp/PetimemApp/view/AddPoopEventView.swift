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
    let colors = ["expenseCardColor1","warningRed"]
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("bgHomeColor").ignoresSafeArea()
                VStack{
                    Rectangle()
                        .foregroundColor(Color("bgFrameColor"))
                        .frame(width: 330,height: 550)
                        .cornerRadius(20)
                    Button("Add") {
                        Task {
                            await viewModel.addPoopEvent()
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 55)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
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
                    PetPickerView(selectedPetId: $viewModel.selectedPetId, pets: pets)
                    HStack(spacing: 20){
                        Text("Time:")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Color("buttonAddColor"))
                        DatePicker("Date & Time", selection: $viewModel.dateAndTime, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                    ConsistencyPickerView(selectedConsistency: $viewModel.consistency, options: consistencyOptions)
                    ColorPickerView(selectedColor: $viewModel.color, options: colorOptions)
                    EventTogglesView(bloodOrMucus: $viewModel.bloodOrMucus, foreignObjects: $viewModel.foreignObjects)
                    TintSelectionView(colors: colors, selectedTint: $viewModel.tint)
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Poop Event")
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
