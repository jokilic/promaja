import WidgetKit
import SwiftUI

private let widgetGroupId = "group.promaja.widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PromajaWidgetEntry {
        PromajaWidgetEntry(date: Date(), title: "Promaja", filePath: "No file path", displaySize: context.displaySize)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PromajaWidgetEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        let entry = PromajaWidgetEntry(date: Date(), title: data?.string(forKey: "title") ?? "Promaja", filePath: data?.string(forKey: "filePath") ?? "No file path", displaySize: context.displaySize)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct PromajaWidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let filePath: String
    let displaySize: CGSize
}

struct PromajaWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let uiImage = UIImage(contentsOfFile: entry.filePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let previewImage = UIImage(named: "widget_preview") {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFit()
                    .padding(12)
                    .background(Color(hex: 0x344966))
            } else {
                Text(entry.title)
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: 0x344966))
                    .foregroundColor(Color.white)
            }
        }
        .frame(width: entry.displaySize.width, height: entry.displaySize.height)
        .clipped()
    }
}

@main
struct PromajaWidget: Widget {
    let kind: String = "PromajaWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PromajaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Promaja")
        .description("This is a Promaja widget.")
    }
}

struct PromajaWidget_Previews: PreviewProvider {
    static var previews: some View {
        PromajaWidgetEntryView(entry: PromajaWidgetEntry(date: Date(), title: "Promaja", filePath:  "No file path", displaySize: CGSize(width: 200, height: 200)
))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
