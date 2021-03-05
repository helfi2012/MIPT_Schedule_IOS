//
//  DataUtils.swift
//  Schedule
//
//  Created by Iakov on 21/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class DataUtils {
    
    // Key that is used to store 'MainKey' (or user's group name)
    static let SCHEDULE_KEY = "schedule_key"
    static let MAIN_KEY = "main_key"
    static let FAVORITE_KEY = "favorite_key"
    
    // Loading list with professors names from assets
    static func loadProfessorsList() -> [String] {
        let path = Bundle.main.path(forResource: "professors", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let list = try! JSONDecoder().decode([String].self, from: data)
        return list
    }

    /**
        Loading main key (user's group name) from preferences
     */
    static func loadGroupNumber() -> String! {
        // return UserDefaults.standard.string(forKey: MAIN_KEY)
        return UserDefaults(suiteName: Constants.SUITE_NAME)!.string(forKey: MAIN_KEY)
    }

    /**
        Saving main key (user's group name) to preferences
     */
    static func modifyGroupNumber(key: String) {
        // UserDefaults.standard.set(key, forKey: MAIN_KEY)
        return UserDefaults(suiteName: Constants.SUITE_NAME)!.set(key, forKey: MAIN_KEY)
    }
    
    
    static func loadRecentGroups() -> [String]! {
        return UserDefaults.standard.stringArray(forKey: FAVORITE_KEY)
    }
    
    
    static func modifyRecentGroups(groups: [String]) {
        UserDefaults.standard.set(groups, forKey: FAVORITE_KEY)
    }

    /**
        Auxiliary function that
        - Returns the URL of the documents directory
     */
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /**
        Saving schedule
     */
    static func saveSchedule(schedule: Schedule) {
        do {
            let json = try JSONEncoder().encode(schedule)
            UserDefaults(suiteName: Constants.SUITE_NAME)?.set(json, forKey: DataUtils.SCHEDULE_KEY)
        } catch {
            print(error.localizedDescription)
        }
        
//        let url = getDocumentsDirectory().appendingPathComponent("schedule.json")
//
//        do {
//            let json = try JSONEncoder().encode(schedule)
//            try json.write(to: url)
//        } catch {
//            print(error.localizedDescription)
//        }
    }

    /**
        Loading schedule (automatically chooses where to load from)
     */
    static func loadSchedule() -> Schedule {
        /*
        let url = getDocumentsDirectory().appendingPathComponent("schedule.json")
        if !FileManager.default.fileExists(atPath: url.path) {
            // Load from assets if there is no local version
            let schedule = loadScheduleFromAssets()
            saveSchedule(schedule: schedule)
            return schedule
        } else {
            // Load local version if possible
            let data = try! Data(contentsOf: url, options: .mappedIfSafe)
            let schedule = try! JSONDecoder().decode(Schedule.self, from: data)
            return schedule
        }
        */
        let data = UserDefaults(suiteName: Constants.SUITE_NAME)!.data(forKey: DataUtils.SCHEDULE_KEY)
        if data == nil {
            let schedule = loadScheduleFromAssets()
            saveSchedule(schedule: schedule)
            return schedule
        } else {
            let schedule = try! JSONDecoder().decode(Schedule.self, from: data!)
            return schedule
        }
        
    }
    
    
    /**
        Loading schedule directly from UserDefaults. This method is safe.
     */
    static func loadScheduleFromUserDefaults() -> Schedule! {
        let data = UserDefaults(suiteName: Constants.SUITE_NAME)!.data(forKey: DataUtils.SCHEDULE_KEY)
        if data == nil {
            return nil
        }
        do {
            let schedule = try JSONDecoder().decode(Schedule.self, from: data!)
            return schedule
        } catch {
            return nil
        }
    }
    
    /**
        Loading schedule directly from assets. This method is not safe. Must be called only from ScheduleMIPT (never from ScheduleWidgetExtenstion)
     */
    static func loadScheduleFromAssets() -> Schedule {
        let path = Bundle.main.path(forResource: "schedule", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let schedule = try! JSONDecoder().decode(Schedule.self, from: data)
        return schedule
    }

}
