//
//  TeamTitleTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyStarRatingView

class TeamTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNumbersLabel: UILabel!
    @IBOutlet weak var outTeamButton: UIButton!{
        didSet{
            outTeamButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var teamRateView: SwiftyStarRatingView!
    
    var teamTitle : TeamTitleModel?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func quitTeamAction(_ sender: Any) {
        
    }
    
    private func updateUI(){
        teamNumbersLabel.text = "组队人数: " + (teamTitle?.teamNumber)!
        let value = Float((teamTitle?.teamRate)!)
        teamRateView.value = CGFloat(value!)
    }
}
