//
//  Game.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class Game{
    var gameID : String
    var game_type : String
    var game_status : String
    var started_at : String
    var court : Court
    var participantNumber : String
    var game_rate : String
    
    init(_ gameID : String,
         _ game_type : String,
         _ game_status : String,
         _ started_at : String,
         _ court : Court,
         _ participantNumber : String,
         _ game_rate : String) {
        self.gameID = gameID
        self.game_type = game_type
        self.game_status = game_status
        self.started_at = started_at
        self.court = court
        self.participantNumber = participantNumber
        self.game_rate = game_rate
    }
}
