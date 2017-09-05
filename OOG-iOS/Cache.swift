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
    //MARK: - image
    static let imageCache = UserDefaults.standard
    static func set(_ key : String , _ value : Any?){
        Cache.imageCache.set(value,forKey: key)
    }
    
    //Mark: - currentUser
    static let currentUserKey = "currentUser"
    static let currentUserCache = AppCache(currentUserKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - HomeMovements
    static let homeMovementsKey = "homeMovements"
    static let homeMovementsCache = AppCache(homeMovementsKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
}
