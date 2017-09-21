//
//  TitleTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var avatorImage: UIImageView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var title : TitleModel?{ didSet{ updateUI() } }
    
    private func updateUI(){
        let underLine = UIView(frame: CGRect(x: 0, y: 124, width: 375, height: 1))
        underLine.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        self.contentView.addSubview(underLine)
        
        //avator image
        avatorImage.contentMode = UIViewContentMode.scaleAspectFit
        avatorImage.layer.masksToBounds = true
        avatorImage.clipsToBounds = true
        avatorImage.layer.cornerRadius = 36.0
        
//        avatorImage.layer.borderWidth = 2.0
//        avatorImage.layer.borderColor = UIColor.white.cgColor

//        let profileImageKey = "ProfileImageKey" + (title?.userID)!
//        Cache.keySet.insert(profileImageKey)
//        if let imageData = Cache.tempImageCache.data(forKey: profileImageKey){
//            avatorImage.image = UIImage(data: imageData)
//        }else{
//            if let imageUrl = URL(string: (title?.avatar_url)!){
//                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
//                    let urlContents = try? Data(contentsOf: imageUrl)
//                    Cache.tempImageSet(profileImageKey, urlContents)
//                    if let imageData = urlContents{
//                        DispatchQueue.main.async {
//                            self?.avatorImage.image = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }else{
//                avatorImage.image = nil
//            }
//        }
        
//        avatorImage.contentMode = UIViewContentMode.scaleAspectFill
        avatorImage.sd_setImage(with: URL(string: (title?.avatar_url)!), placeholderImage: #imageLiteral(resourceName: "default_picture.png"))
        
        let blackColorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let greyColorAttribute = [ NSForegroundColorAttributeName: UIColor.gray]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 23) ]
        let systemFontAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        
        //followingButton
        followingButton.titleLabel?.numberOfLines = 0
        followingButton.titleLabel?.textAlignment = .center
        
        var para = (title?.followings)! + "\n"
        let attributedFollowingNumber = NSMutableAttributedString.init(string: para)
        var length = (para as NSString).length
        var numberRange = NSRange(location: 0,length: length)
        attributedFollowingNumber.addAttributes(blackColorAttribute, range: numberRange)
        attributedFollowingNumber.addAttributes(boldFontAttribute, range: numberRange)
        
        para = "关注"
        let attributedFollowing = NSMutableAttributedString.init(string : para)
        length = (para as NSString).length
        numberRange = NSRange(location: 0,length: length)
        attributedFollowing.addAttributes(greyColorAttribute, range: numberRange)
        attributedFollowing.addAttributes(systemFontAttribute, range: numberRange)
        
        attributedFollowingNumber.append(attributedFollowing)
        
        followingButton.setAttributedTitle(attributedFollowingNumber, for: UIControlState.normal)
        
        
        //followerButton
        followerButton.titleLabel?.numberOfLines = 0
        followerButton.titleLabel?.textAlignment = .center
        
        para = (title?.followers)! + "\n"
        let attributedFollowerNumber = NSMutableAttributedString.init(string: para)
        length = (para as NSString).length
        numberRange = NSRange(location: 0,length: length)
        attributedFollowerNumber.addAttributes(blackColorAttribute, range: numberRange)
        attributedFollowerNumber.addAttributes(boldFontAttribute, range: numberRange)
        
        para = "粉丝"
        let attributedFollower = NSMutableAttributedString.init(string : para)
        length = (para as NSString).length
        numberRange = NSRange(location: 0,length: length)
        attributedFollower.addAttributes(greyColorAttribute, range: numberRange)
        attributedFollower.addAttributes(systemFontAttribute, range: numberRange)
        
        attributedFollowerNumber.append(attributedFollower)
        
        followerButton.setAttributedTitle(attributedFollowerNumber, for: UIControlState.normal)
        
        
        //likesButton
        likesButton.titleLabel?.numberOfLines = 0
        likesButton.titleLabel?.textAlignment = .center
        
        para = (title?.likes)! + "\n"
        let attributedLikeNumber = NSMutableAttributedString.init(string: para)
        length = (para as NSString).length
        numberRange = NSRange(location: 0,length: length)
        attributedLikeNumber.addAttributes(blackColorAttribute, range: numberRange)
        attributedLikeNumber.addAttributes(boldFontAttribute, range: numberRange)
        
        para = "喜欢"
        let attributedLike = NSMutableAttributedString.init(string : para)
        length = (para as NSString).length
        numberRange = NSRange(location: 0,length: length)
        attributedLike.addAttributes(greyColorAttribute, range: numberRange)
        attributedLike.addAttributes(systemFontAttribute, range: numberRange)
        
        attributedLikeNumber.append(attributedLike)
        
        likesButton.setAttributedTitle(attributedLikeNumber, for: UIControlState.normal)
        
        
//        positionButton.setTitle(title?.position, for: UIControlState(rawValue: 0))
        usernameButton.setTitle(title?.username, for: UIControlState(rawValue: 0))
        //Label
        if title?.description == ""{
            descriptionLabel.text = "快去编辑你的个性简介吧~"
        }else{
            descriptionLabel.text = title?.description
        }
        
    }
}
