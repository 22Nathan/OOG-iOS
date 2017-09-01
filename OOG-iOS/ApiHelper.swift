//
//  ApiHelper.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiHelper{
    static let API_Root : String = "http://127.0.0.1:8000"
    
    static var uuid : String = ""
    static var currentUser: User{
        get{
            return User(SwiftyJSON.JSON.parse(Cache.currentUserCache.value))
        }
        set{
            Cache.currentUserCache.value = (newValue.toJSON().rawString()!)
        }
    }
    
}
