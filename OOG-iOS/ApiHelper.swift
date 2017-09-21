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
    static let API_Root : String = "http://101.132.41.248:8000/v1"
    static let mapKey : String = "0649b306751082e053265984131c6503"
    static let qiniu_Root : String = "http://ovx4pa4rs.bkt.clouddn.com/"
    
    static var uuid : String = ""
    static var currentUser: User{
        get{
            return User(SwiftyJSON.JSON.parse(Cache.currentUserCache.value))
        }
        set{
            Cache.currentUserCache.value = (newValue.toJSON().rawString()!)
        }
    }
    
    static var currentLongitude : String = ""
    static var currentLatitude : String = ""
    
}
