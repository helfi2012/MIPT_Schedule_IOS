//
//  ScheduleItem.swift
//  Schedule
//
//  Created by Iakov on 21/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//
import UIKit

class ScheduleItem : NSObject, Codable, Identifiable {
    var name: String
    var prof: String
    var place: String
    var day: Int
    var type: String
    var startTime: String
    var endTime: String
    var notes: String
    
    init(name: String, prof: String, place: String, day: Int, type: String, startTime: String, endTime: String, notes: String) {
        self.name = name
        self.prof = prof
        self.place = place
        self.day = day
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
    }
    
    override init() {
        self.name = ""
        self.prof = ""
        self.place = ""
        self.day = -1
        self.type = ""
        self.startTime = ""
        self.endTime = ""
        self.notes = ""
    }
    
    public override var description : String {
        return "name: \(name), prof: \(prof), place: \(place), day: \(day)"
    }

    func equalTo(rhs: ScheduleItem) -> Bool {
        return (self.name == rhs.name) && (self.day == rhs.day) && (self.startTime == rhs.startTime)
    }
    
    public var length : Double {
        return TimeUtils.timeDistance(t1: startTime, t2: endTime)
    }
    
    #if DEBUG
    static let example = ScheduleItem(name: "Теоретическая механика", prof: "Маркеев В.", place: "526", day: 1, type: "SEM", startTime: "13:25", endTime: "15:10", notes: "")
    
    static let example2 = ScheduleItem(name: "Ин.яз.", prof: "555", place: "555", day: 1, type: "SEM", startTime: "13:25", endTime: "15:10", notes: "")
    #endif
}
