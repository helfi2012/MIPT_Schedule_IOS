//
//  ScheduleItem.swift
//  Schedule
//
//  Created by Iakov on 21/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//
import UIKit

/**
    This class stores the data about the lesson.
 */
class ScheduleItem : NSObject, Codable, Identifiable {
    
    // Name of the lesson
    var name: String
    
    // Professors name
    var prof: String
    
    // Place of the lesson (the room number)
    var place: String
    
    // Number of the day (1 == 'Monday')
    var day: Int
    
    /**
        Typy of the lesson:
            - LEC - lecture
            - SEM - seminar
            - LAB - laboratory
            - RST - rest
            - BOT - time to study
     */
    var type: String
    
    // Start time of the lesson
    var startTime: String
    
    // End time of the lesson
    var endTime: String
    
    // Some extra notes
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
    
    // Returns the distance in time (hours) between the end and start time of the lesson
    public var length : Double {
        return TimeUtils.timeDistance(t1: startTime, t2: endTime)
    }

    static let example = ScheduleItem(name: "Теоретическая механика", prof: "Маркеев В.", place: "526 ЛК", day: 4, type: "LEC", startTime: "9:00", endTime: "10:25", notes: "")
    
    static let example2 = ScheduleItem(name: "Ин.яз.", prof: "Шадрина О. В.", place: "427 НК", day: 1, type: "RST", startTime: "15:20", endTime: "16:55", notes: "")
    
    static let exampleList = [
        ScheduleItem(name: "Теоретическая механика", prof: "Маркеев В.", place: "526 ЛК", day: 5, type: "LEC", startTime: "9:00", endTime: "10:25", notes: ""),
        ScheduleItem(name: "Общая физика: термодинамика", prof: "Крымский К. М.", place: "515 ГК", day: 5, type: "LEC", startTime: "10:45", endTime: "12:10", notes: ""),
        ScheduleItem(name: "Математический анализ", prof: "Загрядский", place: "426 ГК", day: 4, type: "SEM", startTime: "12:20", endTime: "13:45", notes: ""),
        ScheduleItem(name: "Квантовая физика", prof: "Невзоров Р. Б.", place: "530 ГК", day: 4, type: "SEM", startTime: "13:55", endTime: "14:20", notes: ""),
        ScheduleItem(name: "Общая физика: лаборатория", prof: "Неизвестный дед", place: "Где-то в ГК", day: 4, type: "SEM", startTime: "14:30", endTime: "15:45", notes: ""),
        ScheduleItem(name: "Теоретическая механика", prof: "Сахаров", place: "112 ГК", day: 4, type: "SEM", startTime: "15:55", endTime: "17:00", notes: ""),
        ScheduleItem(name: "Теоретическая механика", prof: "Маркеев В.", place: "526 ЛК", day: 4, type: "LEC", startTime: "17:05", endTime: "18:30", notes: ""),
        ScheduleItem(name: "Общая физика: термодинамика", prof: "Крымский К. М.", place: "515 ГК", day: 4, type: "LEC", startTime: "18:35", endTime: "20:00", notes: ""),
        ScheduleItem(name: "Математический анализ", prof: "Загрядский", place: "426 ГК", day: 4, type: "SEM", startTime: "20:10", endTime: "21:45", notes: "")
    
    ]

}
