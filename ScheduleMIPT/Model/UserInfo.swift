//
//  UserInfo.swift
//  ScheduleMIPT
//
//  Created by Admin on 06.05.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

class UserInfo: ObservableObject {
    @Published var isEmpty: Bool
    @Published var groupNumber: String
    
    init(groupNumber: String) {
        self.groupNumber = groupNumber
        self.isEmpty = false
    }
    
    init() {
        self.groupNumber = ""
        self.isEmpty = true
    }
}
