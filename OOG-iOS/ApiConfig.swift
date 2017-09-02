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
    case userInfo(username: String)
}

extension ApiConfig: TargetType{
    var baseURL: URL { return URL(string: "http://127.0.0.1:8000")! }
    
    var path: String{
        switch self {
        case .userInfo(let username):
            return "/users/infos/" + username
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .userInfo:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .userInfo(let username):
            return ["username" : username]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .userInfo:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        }
    }
    
    var sampleData: Data {
        switch self {
        case .userInfo(let username):
            return "{\"Username\": \(username)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .userInfo:
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
