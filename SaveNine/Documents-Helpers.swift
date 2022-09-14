//
//  Documents-Helpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/13/22.
//

import Foundation
import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths.first!
}

func save(uiImage: UIImage, named name: String) {
        if let data = uiImage.pngData() {
            let path = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: path)
        }
}

func getImage(named name: String) -> UIImage? {
    let path = getDocumentsDirectory().appendingPathComponent(name).path
    
    guard FileManager.default.fileExists(atPath: path) else {
           print("Image does not exist at path: \(path)")
           
           return nil
       }
    
    if let uiImage = UIImage(contentsOfFile: path) {
           return uiImage
       } else {
           print("UIImage could not be created.")
           
           return nil
       }
}

func deleteImage(named name: String) {
    let url = getDocumentsDirectory().appendingPathComponent(name)
       
    guard FileManager.default.fileExists(atPath: url.path) else {
           print("Image does not exist at path: \(url)")
           
           return
       }
       
       do {
           try FileManager.default.removeItem(at: url)
           
           print("\(name) was deleted.")
       } catch let error as NSError {
           print("Could not delete \(name): \(error)")
       }
}

