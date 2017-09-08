//
//  ConvertISOToDisplay.swift
//  OOG-iOS
//
//  Created by Nathan on 08/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftDate

func convertFrom(_ timeISO : DateInRegion) -> String{
    var displayTime = ""
    let nowDate = DateInRegion(absoluteDate: Date(), in: Region.Local())
    let intervalInMonth = (timeISO - nowDate).in(.month)
    let intervalInDay = (timeISO - nowDate).in(.day)
    let intervalInHour = (timeISO - nowDate).in(.hour)
    let intervalInMinute = (timeISO - nowDate).in(.minute)
    let intervalInSecond = (timeISO - nowDate).in(.second)
        
    if intervalInMonth != 0 {
        displayTime = String(describing: intervalInMonth!) + " month"
    }else if intervalInDay != 0{
        displayTime = String(describing: intervalInDay!) + " day"
    }else if intervalInHour != 0{
        displayTime = String(describing: intervalInHour!) + " hour"
    }else if intervalInMinute != 0{
        displayTime = String(describing: intervalInMinute!) + " minute"
    }else if intervalInSecond != 0{
        displayTime = String(describing: intervalInSecond!) + " second"
    }
    if !displayTime.hasPrefix("1"){
        displayTime += "s"
    }
    displayTime += " ago"
    return displayTime
}
