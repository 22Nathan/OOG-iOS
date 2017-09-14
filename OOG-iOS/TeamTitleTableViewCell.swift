//
//  TeamTitleTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class TeamTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNumbersLabel: UILabel!
    @IBOutlet weak var averageRateLabel: UILabel!
    @IBOutlet weak var outTeamButton: UIButton!
    
    var teamTitle : TeamTitleModel?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        teamNumbersLabel.text = teamTitle?.teamNumber
        averageRateLabel.text = teamTitle?.teamRate
    }
}
