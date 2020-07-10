//
//  ItemView.swift
//  ScheduleMIPT
//
//  Created by Admin on 03.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI
import UIKit

struct ItemView: View {
     @EnvironmentObject var schedule: Schedule
    
    var groupNumber: String
    var item: ScheduleItem
    
    func textColor(type: String) -> Color {
        return Color(type + "_TEXT")
    }

    var body: some View {
        NavigationLink(destination: EditView(groupNumber: groupNumber, isCreatingMode: false, item: item).environmentObject(schedule)) {
            HStack {
                VStack(alignment: .center) {
                    Text(item.startTime)
                        .foregroundColor(textColor(type: item.type))
                        .font(.body).bold()
                    Rectangle()
                        .fill(textColor(type: item.type))
                        //.frame(width: 2, height: CGFloat(10 * max(1, item.length)))
                    .frame(minWidth: 1, maxWidth: 1, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .padding(EdgeInsets.init(top: -6, leading: 0, bottom: 0, trailing: 0))
                    Text(item.endTime)
                        .foregroundColor(textColor(type: item.type))
                        .font(.body).bold()
                }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(item.type))
                    )
                    .frame(width: 70)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.subheadline).bold()
                        .lineLimit(2)
                    Text(item.prof)
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                    Text(item.place)
                        .font(.headline)
                        .lineLimit(1)
                }.padding(8)
            }.frame(height: CGFloat(75 * min(2, max(1, item.length))))
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(groupNumber: "Б02-824", item: ScheduleItem.example)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
    }
}
