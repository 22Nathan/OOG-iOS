//
//  Comment.swift
//  OOG-iOS
//
//  Created by Nathan on 08/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftDate

class Comment{
    var content : String
    var username : String
    var created_at : DateInRegion
    
    init(_ content : String,
         _ username : String,
         _ created_at : DateInRegion) {
        self.content = content
        self.username = username
        self.created_at = created_at
    }
}
