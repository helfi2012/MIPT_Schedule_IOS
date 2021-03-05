//
//  SmallWidgetView.swift
//  ScheduleWidgetExtensionExtension
//
//  Created by Яков Каюмов on 25.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import WidgetKit


struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        let lesson = entry.lessons.isEmpty ? nil : entry.lessons[0]
        ZStack {
            Color("WidgetBackground").ignoresSafeArea()
            
            if lesson == nil {
                VStack {
                    Text("Сегодня нет занятий!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.label))
                        .padding(8)
                }
            } else {
                VStack(spacing: 4) {
                    HStack {
                        Text(StringUtils.getWeekLabels()[lesson!.day - 1].uppercased()
                        )
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                            .foregroundColor(Color(UIColor.systemRed))
                            .font(.system(size: 11, weight: .medium, design: .default))
                        
                        Spacer()
                    }
                    
                    Text(lesson!.startTime)
                        .font(.title)
                    Text(lesson!.place)
                        .font(.title2)
                    Text(lesson!.name)
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray))
                    
                    Spacer()
                }
            }
        }
    }
}


struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView(entry: SimpleEntry(date: Date(), lessons: [ScheduleItem.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
