//
//  ApiConfig.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya

enum ApiConfig{
    case registerAuth(tel: String, password: String, authCode: String)
}

extension ApiConfig: TargetType{
    var baseURL: URL { return URL(string: "http://127.0.0.1:8000")! }
    
    var path: String{
        switch self {
        case .registerAuth(_,_,_):
            return "/register/auth"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .registerAuth:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .registerAuth(let tel, let password, let authCode):
            return ["tel" : tel, "password" : password, "authCode" : authCode]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .registerAuth:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        }
    }
    
    var sampleData: Data {
        switch self {
        case .registerAuth(let tel, let password, let authCode):
            return "{\"Tel\": \(tel) , \"Password\": \(password) , \"AuthCode\": \(authCode)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .registerAuth:
            return .request
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}
