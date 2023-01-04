//
//  UserDefaults+Extension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        guard let defaults = UserDefaults(suiteName: AppGroupContainer.groupID.rawValue) else {
            fatalError("Missing app group")
        }
        
        return defaults
    }
}
