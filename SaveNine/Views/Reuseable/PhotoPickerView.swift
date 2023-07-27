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
    
    @Environment(\.isEnabled) private var isEnabled
    
    @State private var selectedItem: [PhotosPickerItem] = []
    
    init(uiImage: Binding<UIImage?>) {
        _selectedImage = uiImage
    }
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, matching: .images) {
                if let uiImage = selectedImage {
                    VStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                    }
                }
            }
            .onChange(of: selectedItem) {
                guard let item = selectedItem.first else { return }
                
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            
            if isEnabled, selectedImage != nil {
                Button {
                    selectedImage = nil
                } label: {
                    Label("Clear Image", systemImage: "x.circle")
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
