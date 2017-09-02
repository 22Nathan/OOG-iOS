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
    var tel : String        //账号
    var position : String   //场上位置
    var avator_Url : String //头像url
    var followings : String    //关注的人数
    var followers : String     //粉丝分数
    var likes : String         //点赞的动态数量
    
    init(_ username : String = "",
         _ tel : String,
         _ position : String = "",
         _ avator_Url : String = "",
         _ followings : String = "",
         _ followers : String = "",
         _ likes : String = "") {
        self.username = username
        self.tel = tel
        self.position = position
        self.avator_Url = avator_Url
        self.followings = followings
        self.followers = followers
        self.likes = likes
    }
}
