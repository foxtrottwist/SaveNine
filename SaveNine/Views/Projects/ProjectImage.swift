//
//  ProjectImage.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import PhotosUI
import SwiftUI

struct ProjectImage: View {
    var project: Project
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = nil
    
    init(project: Project) {
        self.project = project
        
        if let image = project.image {
            if let uiImage = FileManager.getImage (named: image) {
                _uiImage = State(wrappedValue: uiImage)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                RoundedRectProjectImage(uiImage: uiImage)
                    .onChange(of: selectedImage) {
                        guard let image = selectedImage else { return }
                        
                        Task {
                            if let data = try? await image.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                                self.uiImage = uiImage
                                let name = project.id?.uuidString ?? ""
                                project.image = name
                                FileManager.save(uiImage: uiImage, named: name)
                            }
                        }
                    }
                Spacer()
            }
            
            PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "pencil.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 30))
                    .foregroundColor(.accent)
            }
            .buttonStyle(.borderless)
        }
    }
}

struct RoundedRectProjectImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .projectImage()
        } else {
            Image(systemName: "photo")
                .projectImage()
                .foregroundColor(.accent)
        }
    }
}

#Preview {
    ProjectImage(project: Project.preview)
}
