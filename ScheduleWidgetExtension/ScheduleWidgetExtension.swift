//
//  ScheduleWidgetExtension.swift
//  ScheduleWidgetExtension
//
//  Created by Яков Каюмов on 24.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct SimpleEntry: TimelineEntry {
    let date: Date
    var lessons: [ScheduleItem]
}


struct ScheduleWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
            case .systemSmall: SmallWidgetView(entry: entry)
            case .systemLarge: LargeWidgetView(entry: entry)
            default: SmallWidgetView(entry: entry)
        }
    }
}

@main
struct ScheduleWidgetExtension: Widget {

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: Constants.WIDGET_KIND,
            provider: Provider()
        ) { entry in
            ScheduleWidgetExtensionEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemLarge])
        .configurationDisplayName("widget_display_name")
        .description("widget_description")
    }
}

struct ScheduleWidgetExtension_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), lessons: ScheduleItem.exampleList))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.dark)
        
        ScheduleWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), lessons: ScheduleItem.exampleList))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.dark)
    }
}
