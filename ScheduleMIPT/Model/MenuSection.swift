//
//  MenuSection.swift
//  ScheduleMIPT
//
//  Created by Admin on 04.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

/**
 `MenuSection` represents one day in the week.
 */

class MenuSection: Codable, Identifiable {
    // name == day of the week (e.g. 'Monday')
    var name: String
    
    // Lessons within this day
    var items = [ScheduleItem]()
    
    init(name: String) {
        self.name = name
    }
}
