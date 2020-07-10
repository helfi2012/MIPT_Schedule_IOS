//
//  MenuSection.swift
//  ScheduleMIPT
//
//  Created by Admin on 04.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

class MenuSection: Codable, Identifiable {
    var name: String
    var items = [ScheduleItem]()
    
    init(name: String) {
        self.name = name
    }
}
