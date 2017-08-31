//
//  User.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class User{
    var username : String
    var tel : String
    var password : String
    var uuid : String
    var authCode : String
    
    init(_ username : String = "",
         _ tel : String,
         _ password : String = "",
         _ uuid : String = "",
         _ authCode : String = "") {
        self.username = username
        self.tel = tel
        self.password = password
        self.uuid = uuid
        self.authCode = authCode
    }
    
    convenience init(_ json : JSON){
        self.init(json["username"].stringValue,
                  json["tel"].stringValue,
                  json["password"].stringValue,
                  json["uuid"].stringValue,
                  json["authCode"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "username" : username,
            "tel" : tel,
            "password" : password,
            ])
    }
}
