//
//  ItemView.swift
//  ScheduleMIPT
//
//  Created by Admin on 03.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI
import UIKit


/**
 This view represents lesson information
 */
struct ItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // schedule holds app-level schedule
    @EnvironmentObject var schedule: Schedule

    // groupNumber == name of the group
    var groupNumber: String
    
    // item holds information about the lesson
    var item: ScheduleItem
    
    @ObservedObject var showBreaks: ObservableBool
    
    // If not nil nextItem holds information about next lesson; nil means no next lesson
    var nextItem: ScheduleItem? = nil
    
    
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
    
    
    private func getBreakText(length: Int) -> String {
        if length <= 10 {
            return String.localizedStringWithFormat(NSLocalizedString("break_extra_short", comment: ""), length)
        } else if length <= 20 {
            return String.localizedStringWithFormat(NSLocalizedString("break_short", comment: ""), length)
        } else if length <= 60 {
            return String.localizedStringWithFormat(NSLocalizedString("break_medium", comment: ""), length)
        }
        return String.localizedStringWithFormat(NSLocalizedString("break_long", comment: ""), length)
    }
    
    
    private func getBreakImage(length: Int) -> String {
        if length <= 10 {
            return "ic_run"
        } else if length <= 20 {
            return "ic_cafe"
        } else if length <= 60 {
            return "ic_restaurant"
        }
        return "ic_hotel"
    }

    
    /**
        `NavigationLink` is used to open `EditView`
     */
    var body: some View {
        NavigationLink(destination: EditView(groupNumber: groupNumber, isCreatingMode: false, item: item).environmentObject(schedule)) {
            VStack {
                HStack {
                    VStack(alignment: .center) {
                        Text(item.startTime)
                            .foregroundColor(textColor(type: item.type))
                            .font(.system(size: 13, weight: .heavy, design: .default))
                            .padding(EdgeInsets.init(top: 2, leading: 0, bottom: 0, trailing: 0))
                        Rectangle()
                            .fill(textColor(type: item.type))
                            .frame(minWidth: 1, maxWidth: 1, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                            .padding(EdgeInsets.init(top: -2, leading: 0, bottom: 0, trailing: 0))
                        Text(item.endTime)
                            .foregroundColor(textColor(type: item.type))
                            .font(.system(size: 13, weight: .heavy, design: .default))
                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 2, trailing: 0))
                    }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(backgroundColor(type: item.type))
                                .opacity(0.8)
                                .shadow(radius: 4)
                        )
                        .frame(width: 70)
                        
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.label))
                            .lineLimit(2)
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
                .frame(height: CGFloat(65 * min(2, max(1, item.length))))
                .padding(EdgeInsets.init(top: 4, leading: 0, bottom: 4, trailing: 4))
                
                if (showBreaks.value && nextItem != nil) {
                    let length = Int(TimeUtils.timeDistance(t1: item.endTime, t2: nextItem!.startTime) * 60)
                    
                    HStack {
                        Image(getBreakImage(length: length))
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(UIColor.secondaryLabel)) //Color("BreakColor"))
                        
                        Text(getBreakText(length: length))
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        
                        Spacer()
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 8, bottom: 4, trailing: 8))
                }
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(groupNumber: "Б02-824",
                 item: ScheduleItem.example,
                 showBreaks: ObservableBool(value: true),
                 nextItem: ScheduleItem.example2)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environmentObject(ObservableBool(value: true))
//            .environment(\.locale, .init(identifier: "ru"))
            .preferredColorScheme(.light)
    }
}
