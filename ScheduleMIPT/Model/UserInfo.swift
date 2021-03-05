//
//  UserInfo.swift
//  ScheduleMIPT
//
//  Created by Admin on 06.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

/**
    Main class of the application, that is used to store and transfer data between Views.
 */

class UserInfo: ObservableObject {
    // Auxilary variable, that is used as a message
    @Published var isEmpty: Bool
    
    // User's group number (key)
    @Published var groupNumber: String
    
    /**
        `init()` with `groupNumber` parameter means that `UserInfo` is not empty.
     */
    init(groupNumber: String) {
        self.groupNumber = groupNumber
        self.isEmpty = false
    }
    
    /**
        `init()` without parameters means that `UserInfo` is empty.
     */
    init() {
        self.groupNumber = ""
        self.isEmpty = true
    }
}
