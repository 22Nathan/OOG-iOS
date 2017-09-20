//
//  CourtRateTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 17/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class CourtRateTableViewCell: UITableViewCell {
    @IBOutlet weak var priceRateView: SwiftyStarRatingView!{
        didSet{
            priceRateView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var transportRateView: SwiftyStarRatingView!{
        didSet{
            transportRateView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var facilityRateView: SwiftyStarRatingView!{
        didSet{
            facilityRateView.isUserInteractionEnabled = false
        }
    }
    var court : Court?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        let floatPriceValue = Float((court?.priceRate)!)
        priceRateView.value = CGFloat(floatPriceValue!)
        
        print(court?.facilityRate)
        let floatFacilityValue = Float((court?.facilityRate)!)
        facilityRateView.value = CGFloat(floatFacilityValue!)
        
        let floatTransValue = Float((court?.transportRate)!)
        transportRateView.value = CGFloat(floatTransValue!)
    }
    
}
