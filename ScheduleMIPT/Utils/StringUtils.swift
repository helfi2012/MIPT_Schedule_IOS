//
//  StringUtils.swift
//  Schedule
//
//  Created by Iakov on 24/03/2020.
//  Copyright © 2020 Iakov. All rights reserved.
//

import UIKit

class StringUtils {
    static let DAY_KEYS = ["Monday_Label", "Tuesday_Label", "Wednesday_Label", "Thursday_Label", "Friday_Label", "Saturday_Label", "Sunday_Label"]
    static let TYPE_KEYS = ["LEC", "SEM", "LAB", "BOT", "RST"]
    
    // initializing localized days of week
    static func getWeekLabels() -> [String] {
        var labels = [String]()
        for key in DAY_KEYS {
            labels.append(NSLocalizedString(key, comment: ""))
        }
        return labels
    }
    
    static func getTypeLabels() -> [String] {
        var labels = [String]()
        for key in TYPE_KEYS {
            labels.append(NSLocalizedString(key, comment: ""))
        }
        return labels
    }
}
