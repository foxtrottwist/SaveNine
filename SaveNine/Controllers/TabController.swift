//
//  TabController.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/19/23.
//

import Combine
import Foundation

final class TabController: ObservableObject {
    @Published var selectedView: String? {
        willSet {
            if selectedView == newValue {
                subject.send(newValue)
            }
        }
    }
    
    let subject = PassthroughSubject<String?, Never>()
}
