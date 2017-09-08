//
//  Movement.swift
//  OOG-iOS
//
//  Created by Nathan on 03/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftDate

class Movement{
    var movement_ID : String
    var content : String
    var imageNumber : String
    var imageUrls : [String]
    var owner_avatar : String
    var owner_userName : String
    var owner_position : String
    var created_at : DateInRegion     //动态发布时间
    var likesNumber : String
    var repostsNumber : String
    var commentsNumber : String
    var movementType : Int  // 用户关注的人的动态为1
                            // 热门动态为2
                            // 用户自己发的动态为0
//    var comments : [Comment]
    
    init(_ movement_ID : String,
         _ content : String,
         _ imageNumber : String,
         _ imageUrls : [String],
         _ owner_avatar : String,
         _ owner_userName : String,
         _ owner_position : String,
         _ created_at : DateInRegion,
         _ likesNumber : String,
         _ repostsNumber : String,
         _ commentsNumber : String,
         _ movementType : Int
//         _ comments : [Comment]
         ) {
        self.movement_ID = movement_ID
        self.content = content
        self.imageNumber = imageNumber
        self.imageUrls = imageUrls
        self.owner_avatar = owner_avatar
        self.owner_position = owner_position
        self.owner_userName = owner_userName
        self.created_at = created_at
        self.likesNumber = likesNumber
        self.repostsNumber = repostsNumber
        self.commentsNumber = commentsNumber
        self.movementType = movementType
//        self.comments = comments
    }
}
