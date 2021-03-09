//
//  AppDelegate.swift
//  ScheduleMIPT
//
//  Created by Admin on 03.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WidgetKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var schedule: Schedule!
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        schedule = DataUtils.loadSchedule()
        
        // If there is new version in assets, update schedule in memory
        let initialSchedule = DataUtils.loadScheduleFromAssets()
        if (schedule.version != initialSchedule.version) {
            schedule = initialSchedule
            DataUtils.saveSchedule(schedule: schedule)
        }
        
        // Set default options
        SettingsView.registerDefaults()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SettingsBundleHelper.setVersionAndBuildNumber()
    }

    // MARK: Schedule operations

    /**
        Save changes in schedule made by the user and updates notifications
     */
    func updateTimeTable(updatedSchedule: Schedule) {
        let key = DataUtils.loadGroupNumber()
        schedule = updatedSchedule
        DispatchQueue(label: "queue_saving").async {
            // Update schedule file in the memory
            DataUtils.saveSchedule(schedule: self.schedule)
            // Update notifications
            NotificationUtils.scheduleNotifications(key: key!, schedule: self.schedule)
            // Update widgets
            WidgetCenter.shared.reloadTimelines(ofKind: Constants.WIDGET_KIND)
        }
    }
    
    
    func addNewGroup(groupNumber: String) {
        schedule.timetable[groupNumber] = Array<ScheduleItem>()
        updateTimeTable(updatedSchedule: schedule)
    }
    
    /**
        Allows to just update notifications
     */
    func updateNotifications(updatedUserInfo: UserInfo) {
        NotificationUtils.scheduleNotifications(key: updatedUserInfo.groupNumber, schedule: self.schedule)
    }

}

