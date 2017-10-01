//
//  TeamUserTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class TeamUserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var relationshipButton: UIButton!{
        didSet{
            relationshipButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var rateView: SwiftyStarRatingView!{
        didSet{
            rateView.isUserInteractionEnabled = false
        }
    }
    var user : User?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        avatarImage.layer.masksToBounds = true
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 33.0
        avatarImage.contentMode = .scaleAspectFit
        let profileImageKey = "ProfileImageKey" + (user?.username)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            avatarImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (user?.avatar_url)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.avatarImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                avatarImage.image = nil
            }
        }
        
        //hook up label
        usernameLabel.text = user?.username
        positionLabel.text = user?.position
        
        let value = Float((user?.userRate)!)
        rateView.value = CGFloat(value!)
    }
}
