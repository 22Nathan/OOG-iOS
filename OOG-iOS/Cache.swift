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
    
    //Mark: - userMovements
    static let userMovementsKey = "userMovements"
    static let userMovementCache = AppCache(userMovementsKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - userFollowers OR Follings list
    static let userListKey = "userList"
    static let userListCache = AppCache(userListKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - otherUsers
    static let otherUsersKey = "otherUsers"
    static let otherUsersCache = AppCache(otherUsersKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - userTeam
    static let userTeamKey = "userTeam"
    static let userTeamCache = AppCache(userTeamKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - userGame
    static let userGameKey = "userGame"
    static let userGameCache = AppCache(userGameKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - courtGame
    static let courtGameKey = "courtGame"
    static let courtGameCache = AppCache(courtGameKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
}
