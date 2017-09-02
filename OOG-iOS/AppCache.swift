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
    func userInfoRequest(_ username : String, completionHandler: @escaping ()->() ){
        provider.request(.userInfo(username: username)) {result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print("##################Request User Info###########################")
                print(json)
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
