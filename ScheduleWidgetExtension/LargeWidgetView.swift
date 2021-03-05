//
//  LargeWidgetView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 25.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import WidgetKit


struct LargeWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        let lessons = entry.lessons
        
        ZStack {
            Color("WidgetBackground").ignoresSafeArea()
            
            VStack {
                // Header
                Text("Предстоящие занятия")
                    .font(.title2)
                    .foregroundColor(Color(UIColor.label))
                    .multilineTextAlignment(.leading)
                
                if lessons.count != 0 {
                    Text(StringUtils.getWeekLabels()[lessons[0].day - 1].uppercased())
                        .font(.system(size: 11, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.systemRed))
                        .multilineTextAlignment(.center)
                }
                
                Rectangle()
                    .fill(Color(UIColor.separator))
                    .frame(minWidth: 10, maxWidth: .infinity, minHeight: 1, maxHeight: 1, alignment: .topLeading)
                    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 4, trailing: 0))
                
                
                if lessons.count == 0 {
                    // Empty view
                    Image("bg_empty")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Text("В ближайшие два дня занятий нет!")
                        .foregroundColor(Color(UIColor.label))
                        .multilineTextAlignment(.leading)
                        .padding(8)
                } else {
                    // List
                    ForEach(lessons) {lesson in
                        WidgetItemView(item: lesson)
                    }
                }
                
                Spacer()
            }.padding(EdgeInsets.init(top: 16, leading: 8, bottom: 8, trailing: 8))
        }
    }
}


struct LargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView(entry: SimpleEntry(date: Date(), lessons: [ScheduleItem.example]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
