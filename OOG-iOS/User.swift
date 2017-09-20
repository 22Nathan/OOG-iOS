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
    var id : String     //用户id
    var uuid : String       //用户uuid
    var authCode : String   //登录验证码
    var position : String   //场上位置
    var avatar_url : String //头像url
    var followings : String    //关注的人数
    var followers : String     //粉丝分数
    var likes : String         //点赞的动态数量
    var description : String   //个人描述
    var height : String           //身高
    var weight : String           //体重
    var followType : String        //关注关系，1为相互关注，0表示没有互相关注
    var userRate : String          //用户总平均分
    var skillRate : String         //用户技术平均分
    var physicalRate : String       //身体素质平均分
    var BQRate : String         //球商评分
    var atCity : String             //所在城市
    var gender : String         //性别
    
    init(_ username : String = "",
         _ tel : String,
         _ password : String = "",
         _ id : String = "",
         _ uuid : String = "",
         _ authCode : String = "",
         _ position : String = "",
         _ avatar_url : String = "",
         _ followings : String = "",
         _ followers : String = "",
         _ likes : String = "",
         _ description : String = "",
         _ height : String = "",
         _ weight : String = "",
         _ followType : String = "",
         _ userRate : String = "",
         _ skillRate : String = "",
         _ physicalRate : String = "",
         _ BQRate : String = "",
         _ atCity : String = "",
         _ gender : String = "") {
        self.username = username
        self.tel = tel
        self.password = password
        self.id = id
        self.uuid = uuid
        self.authCode = authCode
        self.position = position
        self.avatar_url = avatar_url
        self.followings = followings
        self.followers = followers
        self.likes = likes
        self.description = description
        self.height = height
        self.weight = weight
        self.followType = followType
        self.userRate = userRate
        self.physicalRate = physicalRate
        self.skillRate = skillRate
        self.BQRate = BQRate
        self.atCity = atCity
        self.gender = gender
    }
    
    convenience init(_ json : JSON){
        self.init(json["username"].stringValue,
                  json["tel"].stringValue,
                  json["password"].stringValue,
                  json["id"].stringValue,   //重要
                  json["uuid"].stringValue,
                  json["authCode"].stringValue,
                  json["position"].stringValue,
                  json["avatar_url"].stringValue,
                  json["followingNumber"].stringValue,
                  json["followedNumber"].stringValue,
                  json["likes"].stringValue,
                  json["description"].stringValue,
                  json["height"].stringValue,
                  json["weight"].stringValue,
                  json["followType"].stringValue,
                  json["userRate"].stringValue,
                  json["physicalRate"].stringValue,
                  json["skillRate"].stringValue,
                  json["BQRate"].stringValue,
                  json["atCity"].stringValue,
                  json["gender"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "username" : username,
            "tel" : tel,
            "password" : password,
            "id" : id,
            "uuid" : uuid,
            "authCode": authCode,
            "position" : position,
            "avatar_url" : avatar_url,
            "followingNumber" : followings,
            "followedNumber" : followers,
            "likes" : likes,
            "description"  : description,
            "height" : height,
            "weight" : weight,
            "followType" : followType,
            "userRate" :userRate,
            "physicalRate" :userRate,
            "skillRate" :userRate,
            "BQRate" :userRate,
            "atCity" : atCity,
            "gender" : gender
            ])
    }
}
