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
    var username : String   //用户名
    var tel : String        //账号
    var password : String   //密码
    var userID : String     //用户id
    var authCode : String   //登录验证码
    var position : String   //场上位置
    var avatar_url : String //头像url
    var followings : String    //关注的人数
    var followers : String     //粉丝分数
    var likes : String         //点赞的动态数量
    var description : String   //个人描述
    var height : Int           //身高
    var weight : Int           //体重
    
    init(_ username : String = "",
         _ tel : String,
         _ password : String = "",
         _ userID : String = "",
         _ authCode : String = "",
         _ position : String = "",
         _ avatar_url : String = "",
         _ followings : String = "",
         _ followers : String = "",
         _ likes : String = "",
         _ description : String = "",
         _ height : Int = 0,
         _ weight : Int = 0) {
        self.username = username
        self.tel = tel
        self.password = password
        self.userID = userID
        self.authCode = authCode
        self.position = position
        self.avatar_url = avatar_url
        self.followings = followings
        self.followers = followers
        self.likes = likes
        self.description = description
        self.height = height
        self.weight = weight
    }
    
    convenience init(_ json : JSON){
        self.init(json["username"].stringValue,
                  json["tel"].stringValue,
                  json["password"].stringValue,
                  json["userID"].stringValue,
                  "",
                  json["position"].stringValue,
                  json["avatar_url"].stringValue,
                  json["followingNumber"].stringValue,
                  json["followedNumber"].stringValue,
                  json["likes"].stringValue,
                  json["description"].stringValue,
                  json["height"].intValue,
                  json["weight"].intValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "username" : username,
            "tel" : tel,
            "password" : password,
            "userID" : userID,
            "position" : position,
            "avatar_url" : avatar_url,
            "followingNumber" : followings,
            "followedNumber" : followers,
            "likes" : likes,
            "description"  : description,
            "height" : height,
            "weight" : weight
            ])
    }
}
