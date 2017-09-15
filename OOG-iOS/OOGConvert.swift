//
//  OOGConvert.swift
//  OOG-iOS
//
//  Created by Nathan on 15/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

func convertNumberToDisplayedGameType(_ number : String) -> String{
    if number == "1"{
        return "1V1"
    }else if number == "2"{
        return "2V2"
    }else if number == "3"{
        return "3V3"
    }else if number == "5"{
        return "5V5"
    }
    return "Free"
}
