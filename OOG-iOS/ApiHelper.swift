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
    static let qiniuAccessKey : String = "grZGx8nwW3KAqOUIXevdwn8Ht8uKMzSvPw6b8w_a"
    static let qiniuSecretKey : String = "gnZX22yH4cpzUsi3lwtP4oklAuXwTHfLdzO1iruA"
    static let mapKey : String = "0649b306751082e053265984131c6503"
    
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
