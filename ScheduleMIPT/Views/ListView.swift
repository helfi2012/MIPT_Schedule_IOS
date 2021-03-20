//
//  ListView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 24.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI


/**
    `EmptyView` shows Text with a message ("no lessons today")
 */
struct EmptyView: View {
    var body: some View {
        Text("no_lessons_text")
            .font(.subheadline).bold()
            .padding(8)
            .listRowBackground(Color(UIColor.systemBackground))
    }
}

/**
    `ImageView` shows centered Image with appropriate background and fixed maximum size
 */
struct ImageView: View {
    var body: some View {
        HStack {
            Spacer()
            Image("bg_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 500, alignment: .center)
            Spacer()
        }.listRowBackground(Color(UIColor.systemBackground))
    }
}

struct ListView: View {
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var schedule: Schedule
    
    @ObservedObject var showBreaks: ObservableBool
    
    @State var scrollCount: Int = 0
    
    var body: some View {
        let menu = getMenu()
        NavigationView {
            ScrollViewReader { scrollView in
                
                List {
                    ForEach(menu, id: \.self.name) { section in
                        Section(header: Text(section.name).font(.callout)) {
                            let items = section.items
                            ForEach(0..<items.count, id: \.self) { i in
                                if (items[i].day == -1) {
                                    // Show image if no lessons
                                    if (section.name == NSLocalizedString("Sunday_Label", comment: "")) {
                                        
                                        ImageView()
                                    } else {
                                        EmptyView()
                                    }
                                } else {
                                    // Show ItemView otherwise
                                    ItemView(
                                        groupNumber: self.userInfo.groupNumber,
                                        item: items[i],
                                        showBreaks: showBreaks,
                                        nextItem: i < items.count - 1 ? items[i + 1] : nil
                                    )
                                    .environmentObject(self.schedule)
                                    
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("schedule", displayMode: .inline)
                .navigationBarItems(leading:
                    NavigationLink(destination: SearchView().environmentObject(userInfo)) {
                        Text(userInfo.groupNumber)
                    }, trailing:
                    NavigationLink(destination: EditView(groupNumber: userInfo.groupNumber, isCreatingMode: true).environmentObject(schedule)) {
                        Image(systemName: "plus").imageScale(.large)
                    })
                .onAppear {
                    // Automatic scrolling
                    if scrollCount < 2 {
                        withAnimation {
                            scrollView.scrollTo(menu[TimeUtils.getCurrentDay() - 1].name, anchor: .top)
                        }
                        scrollCount += 1
                    }
                }
            }
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


struct ListView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo(groupNumber: "Б02-824")
    
    static var previews: some View {
        ListView(showBreaks: ObservableBool(value: true))
            .environmentObject(userInfo)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environment(\.locale, .init(identifier: "ru"))
    }
}
