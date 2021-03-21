//
//  EventUtils.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 21.03.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import EventKit
import SwiftUI

class EventUtils {
    
    // End of the semester
    private static let FINAL_DATE = "2021-06-01"
    private static let DATE_FORMAT = "yyyy-MM-dd"
    
    private static func generateDate(time: String, weekday: Int) -> Date {
        let split = time.split(separator: ":")
        let hour = Int(split[0])!
        let minute = Int(split[1])!
        var date = Date()
        
        date = Calendar.current.date(bySetting: .weekday, value: TimeUtils.myDayToIOSDay(weekday: weekday), of: date)!
        date = Calendar.current.date(bySetting: .hour, value: hour, of: date)!
        date = Calendar.current.date(bySetting: .minute, value: minute, of: date)!
        return date
    }
    
    
    static func bestPossibleEKSource(eventStore: EKEventStore) -> EKSource? {
        
        let defaultSource = eventStore.defaultCalendarForNewEvents?.source
        let iCloud = eventStore.sources.first(where: { $0.title == "iCloud" })
        let local = eventStore.sources.first(where: { $0.sourceType == .local })

        return defaultSource ?? iCloud ?? local
    }
    
    
    static func createNewCalendar(eventStore: EKEventStore) -> EKCalendar? {
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.title = NSLocalizedString("MIPT", comment: "")
        calendar.cgColor = UIColor.purple.cgColor
        
        guard let source = bestPossibleEKSource(eventStore: eventStore) else {
            return nil
        }
        calendar.source = source
        do {
            try eventStore.saveCalendar(calendar, commit: true)
        } catch {
            return nil
        }
        return calendar
    }
    
    
    /**
     - Returns `true` if successul
     */
    static func exportToCalendar(lessons: Array<ScheduleItem>) -> Bool {
        let eventStore = EKEventStore()
        
        // Creating new calendar
        let calendar = createNewCalendar(eventStore: eventStore)
        
        // Final date (end of the semester)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        let finalDate = dateFormatter.date(from: FINAL_DATE)!
        
        for lesson in lessons {
            let startDate = generateDate(time: lesson.startTime, weekday: lesson.day)
            let endDate = generateDate(time: lesson.endTime, weekday: lesson.day)
            
            // Number of weeks before the end of the semester
            let weeks = Int(startDate.distance(to: finalDate) / (3600 * 24 * 7))
            
            for i in 0..<weeks {
                // Initialize event
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = lesson.name
                event.location = lesson.place
                event.notes = lesson.prof
                event.startDate = Calendar.current.date(byAdding: .day, value: i * 7, to: startDate)!
                event.endDate = Calendar.current.date(byAdding: .day, value: i * 7, to: endDate)!
                event.calendar = calendar
                
                // Saving event
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    return false
                }
            }
        }
        return true
    }
    
}
