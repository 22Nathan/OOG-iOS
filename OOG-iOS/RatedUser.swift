//
//  RatedUser.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class RatedUser{
    var username : String
    var id : String
    var avatar_url : String
    var position : String
    
    init(_ username : String,
         _ id : String,
         _ avatar_url : String,
         _ position : String) {
        self.username = username
        self.id = id
        self.avatar_url = avatar_url
        self.position = position
    }
}
