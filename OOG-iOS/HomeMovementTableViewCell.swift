//
//  HomeMovementTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 05/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class HomeMovementTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerAvatarImgae: UIImageView!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    //Model
    var movement : Movement?{ didSet{updateUI()} }
    
    private func updateUI(){
        //hook up avator avatar image
        ownerAvatarImgae.contentMode = UIViewContentMode.scaleAspectFit
        
        let profileImageKey = "ProfileImage" + (movement?.owner_userName)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            ownerAvatarImgae.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (movement?.owner_avatar)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.ownerAvatarImgae.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                ownerAvatarImgae.image = nil
            }
        }
        
        //hook up movement image
        movementImage.contentMode = UIViewContentMode.scaleAspectFill
        
        let movementImageKey = "MovementImage" + (movement?.movement_ID)!
        if let imageData = Cache.imageCache.data(forKey: movementImageKey){
            movementImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (movement?.imageUrls[0])!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(movementImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.movementImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                movementImage.image = nil
            }
        }
        
        //hook up label
        username.text = movement?.owner_userName
        createdAtLabel.text = movement?.created_at
        
    }
}
