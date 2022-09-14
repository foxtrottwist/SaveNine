//
//  PhotoPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/13/22.
//

import PhotosUI
import SwiftUI

struct PhotoPickerView: View {
    @Binding var selectedImage: UIImage?
    
    @State private var selectedItem: [PhotosPickerItem] = []
    
    init(uiImage: Binding<UIImage?>) {
        _selectedImage = uiImage
    }
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
            if let uiImage = selectedImage, let image = Image(uiImage: uiImage) {
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                        .frame(width: 350, height: 250)
                    
                    Text("Update")
                }
            } else {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 150)
                        .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                    
                    Text("Add Photo")
                }
            }
            
        }
        .onChange(of: selectedItem) { _ in
            guard let item = selectedItem.first else { return }
            
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView(uiImage:  .constant(UIImage()))
    }
}
