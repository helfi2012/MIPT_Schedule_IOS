//
//  GridView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 05.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI


struct GridView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var schedule: Schedule
    
    @ObservedObject var showBreaks: ObservableBool
    
    let sp = CGFloat(5)
    
    var gridRows: Array<GridItem> { Array(repeating: GridItem(spacing: sp), count: 7) }
    
    var body: some View {
        
        let menu = getMenu()
        NavigationView {
            
            GeometryReader { gp in
                LazyHGrid(rows: gridRows, spacing: sp) {
                    ForEach(0..<7) { i in
                        ForEach(0..<7) { j in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
                                    
                                
                                if (j < menu[i].items.count) {
                                    ItemView(
                                        groupNumber: self.userInfo.groupNumber,
                                        item: menu[i].items[j],
                                        showBreaks: showBreaks,
                                        nextItem: j < menu[i].items.count - 1 ? menu[i].items[j + 1] : nil
                                    )
                                    .environmentObject(self.schedule)
                                }
                            }.frame(width: gp.size.width / 7 - 2*sp)
                        }
                     }
                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                NavigationLink(destination: SearchView().environmentObject(userInfo)) {
                    Text(userInfo.groupNumber)
                }, trailing:
                NavigationLink(destination: EditView(groupNumber: userInfo.groupNumber, isCreatingMode: true).environmentObject(schedule)) {
                    Image(systemName: "plus").imageScale(.large)
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    /**
        - Returns array of MenuSection containing lessons grouped by the days of the week
     */
    private func getMenu() -> [MenuSection] {
        if (userInfo.isEmpty) {
            return []
        }
        return self.schedule.getSectionedMenu(groupNumber: self.userInfo.groupNumber)!
    }
    
}


struct GridView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo(groupNumber: "Б02-824")
    
    static var previews: some View {
        GridView(showBreaks: ObservableBool(value: true))
            .environmentObject(userInfo)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environment(\.locale, .init(identifier: "ru"))
    }
}

