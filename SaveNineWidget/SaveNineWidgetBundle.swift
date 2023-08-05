//
//  SaveNineWidgetBundle.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import WidgetKit
import SwiftUI

@main
struct SaveNineWidgetBundle: WidgetBundle {
    var body: some Widget {
        MostRecentlyTrackedWidget()
        TimerActivity()
    }
}
