//
//  TeamTitleModel.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class TeamTitleModel{
    var teamNumber : String
    var teamRate : String
    
    init(_ teamNumber : String,
         _ teamRate : String) {
        self.teamNumber = teamNumber
        self.teamRate = teamRate
    }
}
