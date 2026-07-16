import WidgetKit
import SwiftUI

let widgetGroupId = "group.promaja.widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PromajaWidgetEntry {
        PromajaWidgetEntry(
            date: Date(),
            filePath: "",
            displaySize: context.displaySize
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PromajaWidgetEntry) -> Void) {
        let data = UserDefaults(suiteName: widgetGroupId)
        let entry = PromajaWidgetEntry(
            date: Date(),
            filePath: data?.string(forKey: "filePath") ?? "",
            displaySize: context.displaySize
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PromajaWidgetEntry>) -> Void) {
        getSnapshot(in: context) { entry in
            completion(Timeline(entries: [entry], policy: .atEnd))
        }
    }
}

struct PromajaWidgetEntry: TimelineEntry {
    let date: Date
    let filePath: String
    let displaySize: CGSize
}

struct PromajaWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let widgetImage = UIImage(contentsOfFile: entry.filePath) {
                Image(uiImage: widgetImage)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: entry.displaySize.height,
                        height: entry.displaySize.height,
                        alignment: .center
                    )
                    .clipped()
            } else {
                Image("PromajaIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 32)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .widgetURL(URL(string: "promaja://open?homeWidget"))
        .containerBackground(for: .widget) {
            Color(hex: 0x17181E)
        }
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
        .description("Current weather from Promaja.")
        .contentMarginsDisabled()
    }
}

struct PromajaWidget_Previews: PreviewProvider {
    static var previews: some View {
        PromajaWidgetEntryView(
            entry: PromajaWidgetEntry(
                date: Date(),
                filePath: "",
                displaySize: CGSize(width: 200, height: 200)
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
