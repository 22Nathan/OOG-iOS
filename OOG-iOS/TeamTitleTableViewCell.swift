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

class TeamTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNumbersLabel: UILabel!
    @IBOutlet weak var averageRateLabel: UILabel!
    @IBOutlet weak var outTeamButton: UIButton!
    
    var teamTitle : TeamTitleModel?{
        didSet{
            updateUI()
        }
    }
    @IBAction func quitTeamAction(_ sender: Any) {
        
    }
    
    private func updateUI(){
        teamNumbersLabel.text = "组队人数" + (teamTitle?.teamNumber)!
        averageRateLabel.text = "组队平均分" + (teamTitle?.teamRate)!
    }
}
