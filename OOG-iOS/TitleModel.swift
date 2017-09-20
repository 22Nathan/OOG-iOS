//
//  TitleModule.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class TitleModel{
    var username : String   //用户名
    var userID : String     //用户ID
    var tel : String        //账号
    var position : String   //场上位置
    var avatar_url : String //头像url
    var followings : String    //关注的人数
    var followers : String     //粉丝分数
    var likes : String         //点赞的动态数量
    var description : String    //个人描述
    var followType : String
    
    init(_ username : String = "",
         _ userID : String = "",
         _ tel : String,
         _ position : String = "",
         _ avatar_url : String = "",
         _ followings : String = "",
         _ followers : String = "",
         _ likes : String = "",
         _ description : String,
         _ followType : String = "") {
        self.username = username
        self.userID = userID 
        self.tel = tel
        self.position = position
        self.avatar_url = avatar_url
        self.followings = followings
        self.followers = followers
        self.likes = likes
        self.description = description
        self.followType = followType
    }
}
