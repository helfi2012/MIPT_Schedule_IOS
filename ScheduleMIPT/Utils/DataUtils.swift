//
//  DataUtils.swift
//  Schedule
//
//  Created by Iakov on 21/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class DataUtils {
    
    private static let MAIN_KEY = "main_key"
    
    static func loadProfessorsList() -> [String] {
        let path = Bundle.main.path(forResource: "professors", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let list = try! JSONDecoder().decode([String].self, from: data)
        return list
    }

    static func loadMainKey() -> String! {
        let preferences = UserDefaults.standard
        return preferences.string(forKey: MAIN_KEY)
    }

    static func modifyMainKey(key: String) {
        UserDefaults.standard.set(key, forKey: MAIN_KEY)
    }

    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func saveSchedule(schedule: Schedule) {
        let url = getDocumentsDirectory().appendingPathComponent("schedule.json")

        do {
            let json = try JSONEncoder().encode(schedule)
            try json.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func loadSchedule() -> Schedule {
        let url = getDocumentsDirectory().appendingPathComponent("schedule.json")
        if !FileManager.default.fileExists(atPath: url.path) {
            let schedule = loadScheduleFromAssets()
            saveSchedule(schedule: schedule)
            return schedule
        } else {
            let data = try! Data(contentsOf: url, options: .mappedIfSafe)
            let schedule = try! JSONDecoder().decode(Schedule.self, from: data)
            return schedule
        }
    }
    
    static func loadScheduleFromAssets() -> Schedule {
        let path = Bundle.main.path(forResource: "schedule", ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let schedule = try! JSONDecoder().decode(Schedule.self, from: data)
        return schedule
    }

}
