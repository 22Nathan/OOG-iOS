//
//  Court.swift
//  OOG-iOS
//
//  Created by Nathan on 13/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Court{
    var id : String
    var courtName : String
    var courtType : String
    var court_image_url : [String]
    var location : String
    var atCity : String
    var rate : String
    var game_now_url : String
    var status : String
    var longitude : String
    var latitude : String
    var priceRate : String
    var transportRate : String
    var facilityRate : String
    
    init(_ id : String,
         _ courtName : String,
         _ courtType : String = "",
         _ court_image_url : [String] = [],
         _ location : String,
         _ atCity : String = "",
         _ rate : String = "",
         _ game_now_url : String = "",
         _ status : String = "1",
         _ longitude : String,
         _ latitude : String,
         _ priceRate : String = "",
         _ transportRate : String = "",
         _ facilityRate : String = "") {
        self.id = id
        self.courtName = courtName
        self.courtType = courtType
        self.court_image_url = court_image_url
        self.location = location
        self.atCity = atCity
        self.rate = rate
        self.game_now_url = game_now_url
        self.status = status
        self.longitude = longitude
        self.latitude = latitude
        self.priceRate = priceRate
        self.transportRate = transportRate
        self.facilityRate = facilityRate
    }
}
