//
//  CourtGameTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class CourtGameTableViewCell: UITableViewCell {
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    
    @IBOutlet weak var joinGameButton: UIButton!
    
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        gameTypeLabel.text = "比赛类型\n" + (game?.game_type)!
        gameStatusLabel.text = "比赛状态\n" + (game?.game_status)!
        gameTimeLabel.text = "开始时间\n" + (game?.started_at)!
        
    }
}
