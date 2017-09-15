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
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    
    var game : Game?{
        didSet{
            updateUI()
        }
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
        startTimeLabel.text = game?.started_at
        rateLabel.text = game?.court.rate
        gameTypeLabel.text = game?.game_type
        courtLocationLabel.text = game?.court.location

    }
}
