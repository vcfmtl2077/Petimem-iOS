//
//  ProfileViewModel.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI
import PhotosUI

class ProfileViewModel: ObservableObject{
    @Published var selectedItem: PhotosPickerItem?{
        didSet{ Task { try await loadImage() }}
    }
    @Published var profileImage: Image? //display the seleted item
    
    func loadImage() async throws{
        guard let item = selectedItem else{ return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
}
