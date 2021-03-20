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
    
    private func isCurrent() -> Bool {
        if entry.lessons.isEmpty {
            return false
        }
        let item = entry.lessons[0]
        let currentTime = TimeUtils.getCurrentTime()
        return (item.day == TimeUtils.getCurrentDay() &&
                TimeUtils.timeDistance(t1: item.startTime, t2: currentTime) >= 0 &&
                TimeUtils.timeDistance(t1: item.endTime, t2: currentTime) < 0)
    }
    
    
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
                VStack(alignment: .center, spacing: 4) {
                    HStack {
                        Text(StringUtils.getWeekLabels()[lesson!.day - 1].uppercased())
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                            .foregroundColor(Color(UIColor.systemRed))
                            .font(.system(size: 11, weight: .medium, design: .default))
                        
                        Spacer()
                    }
                    
                    Text(lesson!.startTime)
                        .font(.title)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
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
