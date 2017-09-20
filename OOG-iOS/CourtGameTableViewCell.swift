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
    
    @IBOutlet weak var joinGameButton: UIButton!{
        didSet{
            joinGameButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func joinGame(_ sender: Any) {
        Cache.postCache.joinGame((game?.gameID)!)
    }
    
    
    private func updateUI(){
        gameTypeLabel.text = convertNumberToDisplayedGameType((game?.game_type)!)
        gameStatusLabel.text = "比赛状态:" + converNumberToDisplayedGameStatus((game?.game_status)!)
        
        let NStime = ((game?.started_at)!) as NSString
        let length = NStime.length
        let range = NSRange(location: 5, length: length)
        let displayedTime = ((game?.started_at)!).substring(range)
        gameTimeLabel.text = "开始时间:" + displayedTime
    }
}
