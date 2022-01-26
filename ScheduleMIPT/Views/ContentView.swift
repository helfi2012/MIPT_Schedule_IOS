//
//  ContentView.swift
//  ScheduleMIPT
//
//  Created by Admin on 03.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var userInfo: UserInfo = UserInfo()
    
    @ObservedObject var schedule: Schedule = (UIApplication.shared.delegate as! AppDelegate).schedule
    
    @AppStorage(OnboardingView.VERSION_KEY) var savedVersion: String = ""
    
    init() {
        if let key = DataUtils.loadGroupNumber() {
            userInfo = UserInfo(groupNumber: key)
            if !schedule.timetable.keys.contains(key) {
                userInfo = UserInfo()
            }
        }
    }
    
    /**
        This view decides what view to show next: `OnboardingView` or `ListView`
     */
    var body: some View {
        if userInfo.isEmpty || savedVersion != OnboardingView.getCurrentAppVersion() {
            OnboardingView()
                .environmentObject(userInfo)
        } else {
            ListView()
                .environmentObject(userInfo)
                .environmentObject(schedule)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "ru"))
    }
}

