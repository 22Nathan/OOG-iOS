//
//  Cache.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya

class Cache{
    
    
    //Mark: - currentUser
    static let currentUserKey = "currentUser"
    static let currentUserCache = AppCache(currentUserKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
}
