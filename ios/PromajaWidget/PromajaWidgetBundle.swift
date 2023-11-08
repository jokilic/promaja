//
//  PromajaWidgetBundle.swift
//  PromajaWidget
//
//  Created by Josip Kilić on 08.11.2023..
//

import WidgetKit
import SwiftUI

@main
struct PromajaWidgetBundle: WidgetBundle {
    var body: some Widget {
        PromajaWidget()
        PromajaWidgetLiveActivity()
    }
}
