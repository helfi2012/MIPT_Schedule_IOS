//
//  WidgetItemView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 24.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI
import WidgetKit


struct WidgetItemView: View {
    
    var item: ScheduleItem
    
    /**
        - Returns color of the text depending on the theme and type
     */
    func textColor(type: String) -> Color {
        if StringUtils.TYPE_KEYS.contains(type) {
            return Color(type + "_TEXT")
        }
        return Color(StringUtils.TYPE_KEYS[0] + "_TEXT")
    }
    
    
    /**
        - Returns background color depending on the theme and type
     */
    func backgroundColor(type: String) -> Color {
        if StringUtils.TYPE_KEYS.contains(type) {
            return Color(type)
        }
        return Color(StringUtils.TYPE_KEYS[0])
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                Text(item.startTime)
                    .foregroundColor(textColor(type: item.type))
                    .font(.system(size: 12, weight: .heavy, design: .default))
                    .padding(EdgeInsets.init(top: 2, leading: 0, bottom: 0, trailing: 0))
                Rectangle()
                    .fill(textColor(type: item.type))
                    .frame(minWidth: 1, maxWidth: 1, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets.init(top: -2, leading: 0, bottom: 0, trailing: 0))
                Text(item.endTime)
                    .foregroundColor(textColor(type: item.type))
                    .font(.system(size: 12, weight: .heavy, design: .default))
                    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 2, trailing: 0))
            }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor(type: item.type))
                        .opacity(0.8)
                )
                .frame(width: 70)
                .shadow(radius: 3)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                Text(item.prof)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .lineLimit(1)
                Spacer()
                Text(item.place)
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.label))
                    .lineLimit(1)
            }.padding(8)
            
            Spacer()
        }
        .frame(height: CGFloat(75))
        .padding(EdgeInsets.init(top: 2, leading: 8, bottom: 2, trailing: 8))

    }
    
}


struct WidgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetItemView(item: ScheduleItem.example)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
