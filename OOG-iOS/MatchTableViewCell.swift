//
//  MatchTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 19/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class MatchTableViewCell: UITableViewCell {
    @IBOutlet weak var joinGameButton: UIButton!{
        didSet{
            joinGameButton.backgroundColor = UIColor(red: 250/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var rateView: SwiftyStarRatingView!{
        didSet{
            rateView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var courtImage: UIImageView!
    
    @IBOutlet weak var peopleNumberLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func joinGame(_ sender: Any) {
        Cache.postCache.joinGame((game?.gameID)!)
    }
    
    private func updateUI(){
        courtImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "CourtImageKey" + (game?.court.id)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            courtImage.image = UIImage(data: imageData)?.reSizeImage(reSize: CGSize(width: 90, height: 80))
        }else{
            if let imageUrl = URL(string: (game?.court.court_image_url[0])!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.courtImage.image = UIImage(data: imageData)?.reSizeImage(reSize: CGSize(width: 80, height: 80))
                        }
                    }
                }
            }else{
                courtImage.image = nil
            }
        }
        courtNameLabel.text = game?.court.courtName
        let NStime = ((game?.started_at)!) as NSString
        let length = NStime.length
        let range = NSRange(location: 5, length: length)
        let displayedTime = ((game?.started_at)!).substring(range)
        
        timeLabel.text = "预计" + displayedTime + "开始"
        
        gameTypeLabel.text = convertNumberToDisplayedGameType((game?.game_type)!)
        peopleNumberLabel.text = "现人数: " + (game?.participantNumber)!
    }
}
