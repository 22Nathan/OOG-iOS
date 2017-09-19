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
    case userGame(userID: String)
    case courtGame(courtID : String)
    case changeUserInfo(userID : String)
}

extension ApiConfig: TargetType{
    var baseURL: URL { return URL(string: "http://101.132.41.248:8000")! }
    
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
        case .userGame(_):
            return "/games/all/"
        case .courtGame(let courtID):
            return "/courts/" + courtID + "/games/"
        case .changeUserInfo(let userID):
            return "/users/" + userID + "/"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .userInfo, .homeMovement, .userMovement, .movementComment ,.userFollowersOrFollowings , .userTeam, .userGame, .courtGame:
            return .get
        case .changeUserInfo:
            return .put
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
        case .userGame(let userID):
            return ["id" : userID]
        case .courtGame(_):
            return nil
        case .changeUserInfo(_):
            return ["uuid" : ApiHelper.currentUser.uuid,
                    "username" : ApiHelper.currentUser.username,
                    "password" : ApiHelper.currentUser.password,
                    "gender" : ApiHelper.currentUser.gender,
                    "position" : ApiHelper.currentUser.position,
                    "height" : ApiHelper.currentUser.height,
                    "weight" : ApiHelper.currentUser.weight,
                    "description" : ApiHelper.currentUser.description,
                    "atCity" : ApiHelper.currentUser.atCity,
                    "avatar_url" : ApiHelper.currentUser.avatar_url
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .userInfo, .homeMovement, .userMovement, .movementComment , .userFollowersOrFollowings,.userTeam , .userGame , .courtGame, .changeUserInfo:
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
        case .userGame(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .courtGame(let courtID):
            return "{\"UserID\": \(courtID)}".utf8Encoded
        case .changeUserInfo(let userID):
            return "{\"UserID\": \(userID)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .userInfo , .homeMovement, .userMovement, .movementComment , .userFollowersOrFollowings , .userTeam , .userGame , .courtGame ,.changeUserInfo :
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
