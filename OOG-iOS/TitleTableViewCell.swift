//
//  TitleTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    var title : TitleModel?{ didSet{ updateUI() } }
    
    private func updateUI(){
        //avator image
        avatorImage.contentMode = UIViewContentMode.scaleAspectFit
        
        if let imageUrl = URL(string: (title?.avator_Url)!){
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                let urlContents = try? Data(contentsOf: imageUrl)
                if let imageData = urlContents{
                    DispatchQueue.main.async {
                        self?.avatorImage.image = UIImage(data: imageData)
                    }
                }
            }
        }else{
            avatorImage.image = nil
        }
        
        //Button
        followingButton.titleLabel?.numberOfLines = 0
        followingButton.titleLabel?.textAlignment = .center
        followingButton.setTitle("关注\n" + (title?.followings)!, for: UIControlState(rawValue: 0))
        
        followerButton.titleLabel?.numberOfLines = 0
        followerButton.titleLabel?.textAlignment = .center
        followerButton.setTitle("粉丝\n" + (title?.followers)!, for: UIControlState(rawValue: 0))
        
        likesButton.titleLabel?.numberOfLines = 0
        likesButton.titleLabel?.textAlignment = .center
        likesButton.setTitle("喜欢\n" + (title?.likes)!, for: UIControlState(rawValue: 0))
        
        //Label
        usernameLabel.text = title?.username
        positionLabel.text = title?.position
    }
}
