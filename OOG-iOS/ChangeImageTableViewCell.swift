//
//  ChangeImageTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ChangeImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    var imageUrl : String?{
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
        avatarImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "ProfileImageKey" + ApiHelper.currentUser.id
//        if let imageData = Cache.tempImageCache.data(forKey: profileImageKey){
//            avatarImage.image = UIImage(data: imageData)
//        }else{
            if let imageUrl = URL(string: (imageUrl)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.tempImageSet(profileImageKey, urlContents)
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
}
