//
//  TextFile.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/11/22.
//

import SwiftUI
import UniformTypeIdentifiers
// Currently not in use.
struct TextFile: FileDocument, Transferable {
    // Added for use with ShareLink.
    static var transferRepresentation: some TransferRepresentation {
          DataRepresentation(exportedContentType: .text) { data in
              data.text.data(using: .ascii) ?? Data()
          }
      }
    
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
