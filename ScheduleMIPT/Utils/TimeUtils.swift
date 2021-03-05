//
//  TimeUtils.swift
//  Schedule
//
//  Created by Iakov on 23/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class TimeUtils {
    
    /**
        - Returns `true` if `t1` is less than `t2`
     */
    static func compareTime(t1: String, t2: String) -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let d1 = dateFormatter.date(from: t1), let d2 = dateFormatter.date(from: t2) {
            return d1.distance(to: d2) > 0
        } else {
            return true
        }
    }

    /**
        - Returns distance in hours between t1 and t2 in hours
    */
    static func timeDistance(t1: String, t2: String) -> Double {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let d1 = dateFormatter.date(from: t1), let d2 = dateFormatter.date(from: t2) {
            return d1.distance(to: d2) / 3600.0
        } else {
            return 1.0
        }
    }

    
    /**
        - Returns day number from Monday == 1 to Sunday == 7
     */
    static func getCurrentDay() -> Int {
        let currentDay = Date().dayNumberOfWeek()! - 2
        if (currentDay >= 0 && currentDay <= 6) {
            return currentDay + 1
        } else {
            return 7
        }
    }
    
    static func getDayComponents(time: String, day: Int) -> DateComponents {
        let split = time.split(separator: ":")
        let hour = Int(split[0])!
        let minute = Int(split[1])!
        
        var comp = DateComponents()
        comp.weekday = myDayToIOSDay(weekday: day)
        comp.hour = hour
        comp.minute = minute
        
        return comp
    }
    
    static func myDayToIOSDay(weekday: Int) -> Int {
        if (weekday <= 6) {
            return weekday + 1
        } else {
            return 1
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
