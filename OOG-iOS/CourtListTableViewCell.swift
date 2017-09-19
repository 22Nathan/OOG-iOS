//
//  CourtListTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 20/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class CourtListTableViewCell: UITableViewCell {
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var rateView: SwiftyStarRatingView!{
        didSet{
            rateView.isUserInteractionEnabled = false
        }
    }
    var court : Court?{
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
        courtImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "CourtImageKey" + (court?.id)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            courtImage.image = UIImage(data: imageData)?.reSizeImage(reSize: CGSize(width: 90, height: 80))
        }else{
            if let imageUrl = URL(string: (court!.court_image_url[0])){
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
        
        courtNameLabel.text = court?.courtName
        let floatValue = Float((court?.rate)!)
        rateView.value = CGFloat(floatValue!)
    }
}
