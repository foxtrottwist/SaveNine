//
//  FileManager+Widgets.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

extension FileManager {
    static var widgetsDirectory: URL {
        self.sharedContainer.appending(path: AppGroupContainer.widgetDirectory.rawValue)
    }
   
    /// Retrieves and decodes data from the App Groups container to be displayed in a widget.
    /// - Parameters:
    ///   - type: The data structure Type that conforms to Decodable.
    ///   - file: The name of the file to be retrieved. The ".json" extension is appended by the method.
    /// - Returns: The decoded data structure.
    static func readWidgetData<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        let url = self.widgetsDirectory.appending(path: FileExtension.append(to: file, using: .json))
        
        guard self.default.fileExists(atPath: url.path()) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode \(file) from disk: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Writes an Encodable date structure to the App Groups container.
    /// - Parameters:
    ///   - object: The data structure to be written.
    ///   - file: The name of the file to be written. The ".json" extension is appended by the method.
    static func writeWidget<T: Encodable>(data object: T, to file: String) {
        let url = self.widgetsDirectory
        
        createDirectoryIfNoneExist(at: url)
        let path = url.appending(path: FileExtension.append(to: file, using: .json))
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        
        do {
            try data?.write(to: path)
        } catch {
            print("Failed to write to \(path). Error: \(error.localizedDescription)")
        }
    }
}
