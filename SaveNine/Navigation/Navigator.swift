//
//  Navigator.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import Combine
import Foundation
import Observation
import SwiftUI

@Observable
final class Navigator {
    var path = NavigationPath()
    var selection: Screen? = .open
    let subject = PassthroughSubject<String?, Never>()
    
    var selectedTab: String? {
        willSet {
            if selectedTab == newValue {
                subject.send(newValue)
            }
        }
    }
    
    static let shared = Navigator()
}
