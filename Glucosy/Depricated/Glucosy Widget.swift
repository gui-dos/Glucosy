//import SwiftUI
//import WidgetKit
//
//struct Provider: AppIntentTimelineProvider {    
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
//    }
//    
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//        
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date
//        let currentDate = Date()
//        
//        for hourOffset in 0..<5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            
//            entries.append(entry)
//        }
//        
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
//
//struct GlucosyWidgetEntryView: View {
//    var entry: Provider.Entry
//    
//    var body: some View {
//        VStack {
//            Text("Time:")
//            
//            Text(entry.date, style: .time)
//            
//            Text("Favorite Emoji:")
//            
//            Text(entry.configuration.favoriteEmoji)
//        }
//    }
//}
//
//struct GlucosyWidget: Widget {
//    let kind = "GlucosyWidget"
//    
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            GlucosyWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//    }
//}
//
//extension ACGlucoseConfiguration {
//    fileprivate static var preview: ACGlucoseConfiguration {
//        ACGlucoseConfiguration()
//    }
//}
//
//#Preview(as: .accessoryCircular) {
//    GlucosyWidget()
//} timeline: {
//    GlucoseEntry(
//        glucose: "16.4",
//        measureDate: Date(),
//        unit: "mmol/L",
//        date: Date(),
//        configuration: .preview
//    )
//}
