//
//  AppIconImageView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/21/23.
//

import SwiftUI

struct AppIconImageView: View {
    let icon: String
    
    var body: some View {
        if let uiImage = UIImage(named: icon) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 25, height: 25)
                .clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }
}

struct AppIconImageView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconImageView(icon: "AppIcon")
    }
}
