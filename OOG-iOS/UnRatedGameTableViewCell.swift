//
//  UnRatedGameTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UnRatedGameTableViewCell: UITableViewCell {
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!{
        didSet{
            rateButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
            rateButton.contentMode = UIViewContentMode.scaleAspectFit
            rateButton.layer.masksToBounds = true
            rateButton.clipsToBounds = true
            rateButton.layer.cornerRadius = 6
        }
    }
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    
    var unRatedUser : [RatedUser] = []
    var deleagte : GameTabViewControllerProtocol?
    
    @IBAction func toRate(_ sender: Any) {
        deleagte?.callToRate(sender: self)
    }
    private func updateUI(){
        courtImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "CourtImageKey" + (game?.court.id)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            courtImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (game?.court.court_image_url[0])!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.courtImage.image = UIImage(data: imageData)
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
        
        endTimeLabel.text = "比赛开始于" + displayedTime
        locationLabel.text = game?.court.location
        gameTypeLabel.text = convertNumberToDisplayedGameType((game?.game_type)!)
    }
}
