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
    case userInfo(userID: String)
    case homeMovement(userID: String)
    case userMovement(userID: String)
    case movementComment(movementID: String)
    case userFollowersOrFollowings(userID: String,listType : String)
    case userTeam(userID: String)
}

extension ApiConfig: TargetType{
    var baseURL: URL { return URL(string: "http://127.0.0.1:8000")! }
    
    var path: String{
        switch self {
        case .userInfo(let userID):
            return "/users/" + userID
        case .homeMovement:
            return "/movements/all/"
        case .userMovement(let userID):
            return "/users/" + userID + "/movements/"
        case .movementComment(let movementID):
            return "/movements/" + movementID + "/comments/"
        case .userFollowersOrFollowings(let userID , _):
            return "/users/" + userID + "/followList/"
        case .userTeam(let userID):
            return "/users/" + userID + "/team/"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .userInfo, .homeMovement, .userMovement, .movementComment ,.userFollowersOrFollowings , .userTeam:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .userInfo(let userID):
            return ["userID" : userID]
        case .homeMovement(let userID):
            return ["id" : userID]
        case .userMovement( _):
            return nil
        case .movementComment( _):
            return nil
        case .userFollowersOrFollowings( _,let listType):
            return ["followListType" : listType]
        case .userTeam(_):
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .userInfo, .homeMovement, .userMovement, .movementComment , .userFollowersOrFollowings,.userTeam:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        }
    }
    
    var sampleData: Data {
        switch self {
        case .userInfo(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .homeMovement, .movementComment , .userMovement :
            return "HomeMovements".utf8Encoded
        case .userFollowersOrFollowings(let userID, _):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .userTeam(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .userInfo , .homeMovement, .userMovement, .movementComment , .userFollowersOrFollowings , .userTeam :
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
