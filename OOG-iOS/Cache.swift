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
    
    //Mark: - updateImage
    static let tempImageCache = UserDefaults.standard
    static var keySet = Set<String>()
    
    static func tempImageSet(_ key : String, _ value : Any?){
        Cache.tempImageCache.set(value, forKey: key)
    }
    static func clearTempImage(){
        for key in keySet{
            Cache.tempImageCache.removeObject(forKey: key)
        }
    }
    
    static func createMoyaProvider() -> MoyaProvider<ApiConfig>{
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - currentUser
    static let currentUserKey = "currentUser"
    static let currentUserCache = AppCache(currentUserKey){
        createMoyaProvider()
    }
    
    //Mark: - HomeMovements
    static let homeMovementsKey = "homeMovements"
    static let homeMovementsCache = AppCache(homeMovementsKey){
        createMoyaProvider()
    }
    
    //Mark: - userMovements
    static let userMovementsKey = "userMovements"
    static let userMovementCache = AppCache(userMovementsKey){
        createMoyaProvider()
    }
    
    //Mark: - userLikeMovements
    static let userLikeMovementsKey = "userLikeMovements"
    static let userLikeMovementCache = AppCache(userLikeMovementsKey){
        createMoyaProvider()
    }
    
    //Mark : - movementComment
    static let movementCommentKey = "movementComments"
    static let movementCommentCache = AppCache(movementCommentKey){
        createMoyaProvider()
    }
    
    //Mark: - userFollowers OR Follings list
    static let userListKey = "userList"
    static let userListCache = AppCache(userListKey){
        createMoyaProvider()
    }
    
    //Mark: - otherUsers
    static let otherUsersKey = "otherUsers"
    static let otherUsersCache = AppCache(otherUsersKey){
        createMoyaProvider()
    }
    
    //Mark: - userTeam
    static let userTeamKey = "userTeam"
    static let userTeamCache = AppCache(userTeamKey){
        createMoyaProvider()
    }
    
    //Mark: - userGame
    static let userGameKey = "userGame"
    static let userGameCache = AppCache(userGameKey){
        createMoyaProvider()
    }
    
    //Mark: - courtGame
    static let courtGameKey = "courtGame"
    static let courtGameCache = AppCache(courtGameKey){
        createMoyaProvider()    }
    
    //Mark: - postCache
    static let postCacheKey = "post"
    static let postCache = AppCache(postCacheKey){
        createMoyaProvider()
    }
}
