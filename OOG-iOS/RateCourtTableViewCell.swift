//
//  RateCourtTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class RateCourtTableViewCell: UITableViewCell {
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var courtName: UILabel!
    @IBOutlet weak var priceRatingView: SwiftyStarRatingView!{
        didSet{
            priceRatingView.value = 3
        }
    }
    @IBOutlet weak var faciltyRatingView: SwiftyStarRatingView!{
        didSet{
            faciltyRatingView.value = 3
        }
    }
    @IBOutlet weak var transportRatingView: SwiftyStarRatingView!{
        didSet{
            transportRatingView.value = 3
        }
    }
    
    @IBAction func priceChanged(_ sender: Any) {
        delegate?.gameValueChanged( "," + String(describing: priceRatingView.value),"," + String(describing: faciltyRatingView.value), "," + String(describing: transportRatingView.value))
    }
    @IBAction func facilityChanged(_ sender: Any) {
        delegate?.gameValueChanged( "," + String(describing: priceRatingView.value),"," + String(describing: faciltyRatingView.value), "," + String(describing: transportRatingView.value))
    }
    
    @IBAction func transportRatingView(_ sender: Any) {
        delegate?.gameValueChanged( "," + String(describing: priceRatingView.value),"," + String(describing: faciltyRatingView.value), "," + String(describing: transportRatingView.value))
    }
    
    var court : Court?{
        didSet{
            updateUI()
        }
    }
    
    var delegate : RateGameTableViewControllerProtocol?
    
    private func updateUI(){
        courtImage.layer.masksToBounds = true
        courtImage.clipsToBounds = true
        courtImage.layer.cornerRadius = 25
        
        courtImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "CourtImageKey" + (court?.id)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            courtImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (court!.court_image_url[0])){
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
        
        courtName.text = court?.courtName
        
    }
}
