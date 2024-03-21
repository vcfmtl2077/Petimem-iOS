//
//  addNewPetView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-19.
//

import SwiftUI
import PhotosUI

struct addNewPetView: View {
    
@StateObject var viewModel = ProfileViewModel()
@State private var petName = ""
@State private var selectedDate: Date = Date()
let gender = ["Female","Male"]
@State private var selectedOption = ""
    
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
                    //input validation
                }
                    .foregroundColor(.white)
                    .frame(width: 330, height: 50)
                    .background(Color("buttonAddColor"))
                    .cornerRadius(20)
                Spacer()
                Text("")
                
            }
            VStack{
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
                Text("")
                Text("")
                // rest of the form inputs
                // Name row
                HStack{
                    Spacer()
                    Text("Name:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("")
                    Text("")
                    TextField("Your pet name", text: $petName)
                        .padding()
                        .frame(width: 200, height: 30)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke( Color.blue)
                        )
                    Spacer()
                }
               
                Text("")
                
                //Gender row
                HStack{
                    Spacer()
                    Text("Gender:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.blue)
                    Spacer()
                    ForEach(gender, id: \.self) { option in
                        HStack {
                            Text(option)
                            if selectedOption == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            // This sets the selected option to the one that was tapped
                            self.selectedOption = option
                        }
                    }
                    Spacer()
                }
                
                //Birthday row
                Text("")
                
                HStack{
                    Spacer()
                    Text("Birthday:")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    Text("")
                    Text("")
                    
                    DatePicker("",selection: $selectedDate,in: ...Date(),displayedComponents: .date) // Only show the date picker, not time
                        .labelsHidden()
                    Spacer()
                    }
                Spacer()
                Spacer()
                }
            }
        }
    }

#Preview {
    addNewPetView()
}
