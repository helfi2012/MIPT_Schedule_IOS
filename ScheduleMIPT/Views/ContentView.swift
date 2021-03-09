//
//  ContentView.swift
//  ScheduleMIPT
//
//  Created by Admin on 03.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI


class ObservableBool: ObservableObject {
    @Published var value: Bool = false
    
    init(value: Bool) {
        self.value = value
    }
}

/**
 Main view of the application. May represent 2 different views:
 `listView` - schedule list
 `startView` - view that shows when no group selected (e.g. on the first run)
 */


struct ContentView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    @EnvironmentObject var schedule: Schedule
    
    @ObservedObject var showBreaks = ObservableBool(value: UserDefaults.standard.bool(forKey: SettingsView.BREAKS_KEY))
    
    /**
        This view decides what view to show next: `searchView` or `tabView`
     */
    var body: some View {
        if userInfo.isEmpty {
            AnyView(OnboardingView().environmentObject(userInfo))
        } else {
            AnyView(tabView())
        }
    }
    
    func tabView() -> some View {
        return TabView {
            ListView(showBreaks: showBreaks)
                .environmentObject(userInfo)
                .environmentObject(schedule)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("schedule_tab")
                }
            
            SettingsView(observableShowBreaks: showBreaks)
                .environmentObject(userInfo)
                .environmentObject(schedule)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("settings_tab")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let userInfo = UserInfo()
    
    //static let userInfo = UserInfo(groupNumber: "Б02-824")
    
    static var previews: some View {
        ContentView()
            .environmentObject(userInfo)
            .environmentObject((UIApplication.shared.delegate as! AppDelegate).schedule)
            .environment(\.locale, .init(identifier: "ru"))
    }
}

