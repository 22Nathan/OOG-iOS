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
    var uuid : String       //uuid
    var authCode : String   //登录验证码
    var position : String   //场上位置
    var avator_Url : String //头像url
    var followings : String    //关注的人数
    var followers : String     //粉丝分数
    var likes : String         //点赞的动态数量
    
    init(_ username : String = "",
         _ tel : String,
         _ password : String = "",
         _ uuid : String = "",
         _ authCode : String = "",
         _ position : String = "",
         _ avator_Url : String = "",
         _ followings : String = "",
         _ followers : String = "",
         _ likes : String = "") {
        self.username = username
        self.tel = tel
        self.password = password
        self.uuid = uuid
        self.authCode = authCode
        self.position = position
        self.avator_Url = avator_Url
        self.followings = followings
        self.followers = followers
        self.likes = likes
    }
    
    convenience init(_ json : JSON){
        self.init(json["username"].stringValue,
                  json["tel"].stringValue,
                  json["password"].stringValue,
                  json["uuid"].stringValue,
                  "",
                  json["position"].stringValue,
                  json["avator_Url"].stringValue,
                  json["followings"].stringValue,
                  json["followers"].stringValue,
                  json["likes"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "username" : username,
            "tel" : tel,
            "password" : password,
            "uuid" : uuid,
            "position" : position,
            "avator_Url" : avator_Url,
            "followings" : followings,
            "followers" : followers,
            "likes" : likes
            ])
    }
}
