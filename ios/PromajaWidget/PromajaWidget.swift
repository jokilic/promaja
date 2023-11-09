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
                   .frame(width: entry.displaySize.height*0.5, height: entry.displaySize.height*0.5, alignment: .center)
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
            Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            PromajaImage
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
