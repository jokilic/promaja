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
    let data = UserDefaults.init(suiteName:widgetGroupId)
    let filePath: String?
    var PromajaImage: some View {
           if let uiImage = UIImage(contentsOfFile: entry.filePath) {
               let image = Image(uiImage: uiImage)
                   .resizable()
                   .frame(width: entry.displaySize.height, height: entry.displaySize.height, alignment: .center)
               return AnyView(image)
           }
           print("The image file could not be loaded")
           return AnyView(EmptyView())
       }
    
    init(entry: Provider.Entry) {
        self.entry = entry
        filePath = data?.string(forKey: "filePath")
        
    }
    
    var body: some View {
        VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            if(filePath == nil) {
                Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).frame(width: entry.displaySize.height, height: entry.displaySize.height, alignment: .center).background(Color(hex: 0x344966)).foregroundColor(Color.white)
            } else {
                PromajaImage
            }
        }
        )
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
