import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), filename: "No screenshot available", displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.josipkilic.promaja")
        let filename = userDefaults?.string(forKey: "widgetFile") ?? "No screenshot available"
        let entry = SimpleEntry(date: Date(), filename: filename, displaySize: context.displaySize)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
          getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
                      completion(timeline)
                  }
        }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let filename: String
    let displaySize: CGSize
}

struct PromajaWidgetEntryView : View {
    var entry: Provider.Entry
    var CustomImage: some View {
            if let uiImage = UIImage(contentsOfFile: entry.filename) {
                let image = Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                return AnyView(image)
            }
            print("The image file could not be loaded")
            return AnyView(EmptyView())
        }
    var body: some View {
        CustomImage
            .scaledToFill()
            .padding(0)
    }
}

struct PromajaWidget: Widget {
    let kind: String = "PromajaWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PromajaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Promaja")
        .description("This is a weather widget from Promaja.")
        .supportedFamilies([.systemSmall])
    }
}
