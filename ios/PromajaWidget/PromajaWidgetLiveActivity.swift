//
//  PromajaWidgetLiveActivity.swift
//  PromajaWidget
//
//  Created by Josip Kilić on 08.11.2023..
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PromajaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PromajaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PromajaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PromajaWidgetAttributes {
    fileprivate static var preview: PromajaWidgetAttributes {
        PromajaWidgetAttributes(name: "World")
    }
}

extension PromajaWidgetAttributes.ContentState {
    fileprivate static var smiley: PromajaWidgetAttributes.ContentState {
        PromajaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PromajaWidgetAttributes.ContentState {
         PromajaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PromajaWidgetAttributes.preview) {
   PromajaWidgetLiveActivity()
} contentStates: {
    PromajaWidgetAttributes.ContentState.smiley
    PromajaWidgetAttributes.ContentState.starEyes
}
