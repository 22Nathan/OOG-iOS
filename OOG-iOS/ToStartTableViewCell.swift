//
//  ToStartTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ToStartTableViewCell: UITableViewCell {
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var courtLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var quitGameButton: UIButton!{
        didSet{
            quitGameButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
//        courtImage.layer.masksToBounds = true
//        courtImage.clipsToBounds = true
//        courtImage.layer.cornerRadius = 48.0
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
        
        startTimeLabel.text = "预计" + displayedTime + "开始"
        
        gameTypeLabel.text = convertNumberToDisplayedGameType((game?.game_type)!)
        courtLocationLabel.text = game?.court.location

    }
}
