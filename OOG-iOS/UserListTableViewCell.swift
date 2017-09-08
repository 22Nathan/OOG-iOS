//
//  UserListTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 08/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var relationshipButton: UIButton!
    
    var user : User?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        //hook up image
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
        
        //hook up button
        relationshipButton.backgroundColor = UIColor.flatBlue
        relationshipButton.setTitle("待开发", for: UIControlState.normal)
    }
}
