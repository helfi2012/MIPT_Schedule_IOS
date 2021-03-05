//
//  StringUtils.swift
//  Schedule
//
//  Created by Iakov on 24/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class StringUtils {
    // Auxilary days keys
    static let DAY_KEYS = ["Monday_Label", "Tuesday_Label", "Wednesday_Label", "Thursday_Label", "Friday_Label", "Saturday_Label", "Sunday_Label"]
    
    // Auxilary keys that represents types of lessons
    static let TYPE_KEYS = ["LEC", "SEM", "LAB", "BOT", "RST"]
    
    static let MINUTE_KEYS = ["settings_1minute", "settings_5minute", "settings_10minute"]
    

    /**
        This function initializes localized days of week
        - Returns list of names of weekdays (according to the language)
     */
    static func getWeekLabels() -> [String] {
        var labels = [String]()
        for key in DAY_KEYS {
            labels.append(NSLocalizedString(key, comment: ""))
        }
        return labels
    }
    
    /**
        This function initializes localized types of lesson
        - Returns list of names of lesson's types (according to the language)
     */
    static func getTypeLabels() -> [String] {
        var labels = [String]()
        for key in TYPE_KEYS {
            labels.append(NSLocalizedString(key, comment: ""))
        }
        return labels
    }
    
    /**
        This function initializes localized labels for settings picker
        - Returns list of optoins (1 minute, 5 ...)
     */
    static func getMinutesLabels() -> [String] {
        var labels = [String]()
        for key in MINUTE_KEYS {
            labels.append(NSLocalizedString(key, comment: ""))
        }
        return labels
    }
}
