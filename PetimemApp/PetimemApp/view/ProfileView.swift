//
//  ProfileView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject{
    @Published var selectedItem: PhotosPickerItem?{
        didSet{ Task { try await loadImage() }}
    }
    @Published var profileImage: Image? //display the seleted item
    
    func loadImage() async throws {
        guard let item = selectedItem else{ return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
  //--------------------------Load User profile--------------------------------
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authDataResult.uid)
    }
}



struct ProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var viewModelB = ProfileViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("bgHomeColor")
                    .ignoresSafeArea()
                VStack{
                    Section{
                        if let user = viewModelB.user{
                            Text("UserID:\(user.userID)")
                        }
                    }
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
            .task {
                try? await viewModelB.loadCurrentUser()
            }
        }
    }
}

#Preview {
    ProfileView()
}
