//
//  UserMovementCollectionViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 12/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UserMovementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var displayMovementImage: UIImageView!
    
    var movement : Movement?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        displayMovementImage.contentMode = UIViewContentMode.scaleAspectFit
        let movementImageKey = "movementImageKey" + (movement?.movement_ID)!
        //        Cache.set(movementImageKey, "")
        if let imageData = Cache.imageCache.data(forKey: movementImageKey){
            displayMovementImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (movement?.imageUrls[0])!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    let resizeImage = UIImage(data: urlContents!)?.reSizeImage(reSize: CGSize(width: 123, height: 123))
                    let resizeData = UIImagePNGRepresentation(resizeImage!)
                    Cache.set(movementImageKey, resizeData)
                    if let imageData = resizeData,imageUrl == URL(string: (self?.movement?.imageUrls[0])!){
                        DispatchQueue.main.async {
                            self?.displayMovementImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                displayMovementImage.image = nil
            }
        }
    }
}
