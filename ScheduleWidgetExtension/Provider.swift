//
//  Provider.swift
//  ScheduleWidgetExtensionExtension
//
//  Created by Яков Каюмов on 02.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents


struct Provider: TimelineProvider {
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), lessons: [ScheduleItem.example])
        completion(entry)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lessons: [ScheduleItem.example])
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        
        // Get UserDefaults instance to load user's informations
        let userDefaults = UserDefaults(suiteName: Constants.SUITE_NAME)
        
        // Loading group number
        let groupNumber = userDefaults?.string(forKey: DataUtils.MAIN_KEY) ?? ""
        // Loading schedule for current group
        var lessons = DataUtils.loadScheduleFromUserDefaults()?.timetable[groupNumber] ?? []
        // Leave only necessary items
        lessons = chooseAppropriateLessons(lessons: lessons)
        
        // Create Entry
        let date = Date()
        let entry = SimpleEntry(date: date, lessons: lessons)
        

        // Create the timeline with the entry and a reload policy with the date
        // for the next update.
        let timeline = Timeline(
            entries: [entry],
            policy: .after(chooseBestUpdateDate(lessons: lessons))
        )
        
        // debug
        let formatter = DateFormatter()
        formatter.timeStyle = .full
        formatter.dateStyle = .full
        print("Updating widget. Current time:")
        print(formatter.string(from: Date()))
        print()
        
        completion(timeline)
    }
    
    
    /**
        This method allows to choose the best time to update widget. It returns the date corresponding to the
        end of the next lesson if there is any lessons today left. Otherwise, it returns the nearest future midnight time.
     
        It is crucial that `lessons` parameter should be from `chooseAppropriateLessons` function.
     */
    private func chooseBestUpdateDate(lessons: [ScheduleItem]) -> Date {
        let date = Date()
        // seconds - number of seconds from current time
        var seconds: Double = 3600 * 24 // one day forward if no lessons ahead
        
        if !lessons.isEmpty {
            let currentDay = TimeUtils.getCurrentDay()
            if currentDay != lessons[0].day {
                // If no lessons today, then set the date to the nearest midnight
                let midnight = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .hour, value: 24, to: date)!)
                seconds = midnight.timeIntervalSinceNow
            } else {
                // If there is a lesson today, set the date to its end
                let split = lessons[0].endTime.split(separator: ":")
                let hour = Int(split[0])!
                let minute = Int(split[1])!
                
                let endDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
                
                seconds = Double(endDate.timeIntervalSinceNow)
            }
        }
        // Create update date (+3.0 seconds for reliablity)
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: Int(seconds + 3.0), to: date)!
        
        // debug
        let formatter = DateFormatter()
        formatter.timeStyle = .full
        formatter.dateStyle = .full
        print("Next update date")
        print(formatter.string(from: nextUpdateDate))
        
        return nextUpdateDate
    }
    
    
    /**
        This function chooses lessons, which are in the future or currently running according to now.
        It return maximum of `Constants.WIDGET_MAX_ITEMS` lessons.
        First lesson is always in the future or currenly running.
        It returns `[]` if no lessons today and tommorow
     */
    private func chooseAppropriateLessons(lessons: [ScheduleItem]) -> [ScheduleItem] {
        guard (lessons.count != 0) else { return [] }
        
        let date = Date()
        var day = TimeUtils.getCurrentDay()
        
        // Trying to find today's next lesson
        var lessonsToday = lessons.filter({$0.day == day})
        lessonsToday.sort {
            TimeUtils.compareTime(t1: $0.startTime, t2: $1.startTime)
        }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.string(from: date)
        for i in 0..<lessonsToday.count {
            if TimeUtils.timeDistance(t1: lessonsToday[i].endTime, t2: currentTime) + 5.0 / 60.0 < 0 {
                return Array(lessonsToday[i..<(min(i + Constants.WIDGET_MAX_ITEMS, lessonsToday.count))])
            }
        }
        
        // If no lessons today, search for next day
        
        // Next day (if day == Sunday => nextday == Monday)
        day = day == 7 ? 1 : day + 1
        var lessonsTommorow = lessons.filter({$0.day == day})
        lessonsTommorow.sort {
            TimeUtils.compareTime(t1: $0.startTime, t2: $1.startTime)
        }
        if lessonsTommorow.count != 0 {
            return Array(lessonsTommorow[0..<(min(Constants.WIDGET_MAX_ITEMS, lessonsTommorow.count))])
        }
        
        // If no lessons found return []
        return []
    }
    
}
