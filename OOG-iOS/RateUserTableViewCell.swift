//
//  RateUserTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class RateUserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar_image: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var techRateingView: SwiftyStarRatingView!
    @IBOutlet weak var physicalRatingView: SwiftyStarRatingView!
    @IBOutlet weak var BQRatingView: SwiftyStarRatingView!
    
    var delegate : RateGameTableViewControllerProtocol?
    var userNumber : Int?{
        didSet{
            print(userNumber)
        }
    }
    var rateUser : RatedUser?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func techChange(_ sender: Any) {
        delegate?.userValueChanged(userNumber!, (rateUser?.id)!, "," + String(describing: techRateingView.value), ","+String(describing: physicalRatingView.value), "," + String(describing: BQRatingView.value))
    }
    @IBAction func physicalChange(_ sender: Any) {
        delegate?.userValueChanged(userNumber!, (rateUser?.id)!, "," + String(describing: techRateingView.value), ","+String(describing: physicalRatingView.value), "," + String(describing: BQRatingView.value))
    }
    @IBAction func BQChange(_ sender: Any) {
        delegate?.userValueChanged(userNumber!, (rateUser?.id)!, "," + String(describing: techRateingView.value), ","+String(describing: physicalRatingView.value), "," + String(describing: BQRatingView.value))
    }
    
    private func updateUI(){
        
        avatar_image.layer.masksToBounds = true
        avatar_image.clipsToBounds = true
        avatar_image.layer.cornerRadius = 25
        let profileImageKey = "ProfileImageKey" + (rateUser?.id)!
        Cache.keySet.insert(profileImageKey)
        if let imageData = Cache.tempImageCache.data(forKey: profileImageKey){
            avatar_image.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (rateUser?.avatar_url)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.tempImageSet(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.avatar_image.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                avatar_image.image = nil
            }
        }
        
        usernameLabel.text = rateUser?.username
    }
    

}
