//
//  AppCache.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Moya

class AppCache{
    static let myCache = UserDefaults.standard
    
    var initialKey : String
    var suffixKey : String
    
    var key : String{
        return initialKey + suffixKey
    }
    
    var value : String{
        set{
            set(key, newValue)
        }
        get{
            return get(key)
        }
    }
    
    var isEmpty : Bool{
        return value == ""
    }
    
    
    var provider : MoyaProvider<ApiConfig>{
        return providerCreator()
    }
    
    //闭包，动态生成请求
    let providerCreator : ()->MoyaProvider<ApiConfig>
    
    init(_ key : String , provider : @escaping () -> MoyaProvider<ApiConfig>) {
        self.initialKey = key
        self.suffixKey = ""
        self.providerCreator = provider
    }
    
    
    //MARK: - Request
    
    //获取用户个人信息
    func userInfoRequest(_ userID : String, completionHandler: @escaping ()->() ){
        provider.request(.userInfo(userID: userID)) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                var json = JSON(data)
                print("##################Request User Info###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求用户详情失败###########################")
                print(error)
            }
        }
    }
    
    //获取首页动态列表
    func homeMovementRequest(userID : String , completionHandler: @escaping ()->()) {
        provider.request(.homeMovement(userID: userID) ) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request Home Movements###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求首页动态列表失败###########################")
                print(error)
            }
        }
    }
    
    //获取个人动态列表
    func userMovementsRequest(_ userID : String, completionHandler: @escaping ()->() ){
        provider.request(.userMovement(userID: userID)) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request User Movements###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求用户动态列表失败###########################")
                print(error)
            }
        }
    }
    
    //获取动态评论列表
    func movementComment(_ movementID : String, completionHandler: @escaping ()->()){
        provider.request(.movementComment(movementID: movementID)){result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request Movement Comment###########################")
                //                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求动态评论列表失败###########################")
                print(error)
            }
        }
    }
    
    //获取用户关注或粉丝列表
    func userFollowersOrFollowings(_ userID: String,_ listType : String,completionHandler: @escaping ()->()){
        provider.request(.userFollowersOrFollowings(userID: userID , listType: listType)){result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request User Followers OR Followings " + listType +  "###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求用户关注或粉丝列表失败###########################")
                print(error)
            }
        }
    }
    
    //获取用户组队信息
    func userTeamInfo(_ userID : String , completionHandler: @escaping (_ ifEmpty : Bool)->()){
        provider.request(.userTeam(userID: userID)){result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request User Team Info###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                let result = json["result"].stringValue
                if result == "failed"{
                    completionHandler(true)
                }else{
                    completionHandler(false)
                }
            case let .failure(error):
                print("##################请求用户组队信息失败###########################")
                print(error)
            }
        }
    }
    
    //获得用户比赛信息
    func userGameRequest(userID : String , completionHandler: @escaping ()->()) {
        provider.request(.userGame(userID: userID) ) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request User Game###########################")
//                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求用户比赛列表失败###########################")
                print(error)
            }
        }
    }
    
    //获取球馆比赛信息
    func courtGameRequest(courtID : String, completionHandler: @escaping ()->()){
        provider.request(.courtGame(courtID: courtID) ) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request Court Game###########################")
                //                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求球馆比赛列表失败###########################")
                print(error)
            }
        }
    }
    
    //更改个人信息
    func changeUserInfo(_ userID : String, completionHandler: @escaping ()->() ){
        provider.request(.userInfo(userID: userID)) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Change User Info###########################")
                //                print(json)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print("##################请求用户详情失败###########################")
                print(error)
            }
        }
    }
    
    func set(_ key : String, _ value : String) {
        AppCache.myCache.set(value, forKey: key)
    }
    
    func setKeysuffix(_ key : String){
        suffixKey = key
    }
    
    private func get(_ key : String) -> String {
        if let value = AppCache.myCache.string(forKey: key){
            return value
        }
        return ""
    }
}
