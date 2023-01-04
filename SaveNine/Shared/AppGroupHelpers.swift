//
//  AppGroupHelper.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/2/23.
//

import Foundation

let groupID = "group.com.pawpawpixel.SaveNine"
let widgetDirectory = "Widgets"

extension UserDefaults {
    static var shared: UserDefaults {
        guard let defaults = UserDefaults(suiteName: groupID) else {
            fatalError("Missing app group")
        }
        
        return defaults
    }
}

extension FileManager {
    static var sharedContainer: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)!
    }
    
    static var widgetsDirectory: URL {
        self.sharedContainer.appending(path: widgetDirectory)
    }
    
    static func readWidgetData<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        let url = self.widgetsDirectory.appending(path: file + ".json")
        
        guard self.default.fileExists(atPath: url.path()) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
    
    static func writeWidget<T: Encodable>(data object: T, to fileName: String) {
        let url = self.widgetsDirectory
        
        if !self.default.fileExists(atPath: url.path()) {
             do {
                 try self.default.createDirectory(at: url, withIntermediateDirectories: false)
             } catch {
                 fatalError("Unable to create directory at \(url)")
             }
        }
        
        let path = url.appending(path: fileName + ".json")
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        
        do {
            try data?.write(to: path)
        } catch {
            print("Failed to write to \(path). Error: \(error.localizedDescription)")
        }
    }
}



