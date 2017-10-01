//
//  UserTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 12/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var relationshipButton: UIButton!{
        didSet{
            relationshipButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    
    var user : User?{
        didSet{
            updateUI()
        }
    }
    var isFollow = false
    var listType = ""
    @IBAction func followAction(_ sender: Any) {
        if isFollow{
            isFollow = false
            relationshipButton.isEnabled = false
            requestUnFollow((user?.id)!, completionHandler: completionHandler)
        }else{
            isFollow = true
            relationshipButton.isEnabled = false
            requestFollow((user?.id)!, completionHandler: completionHandler)
        }
    }
    
    func completionHandler(_ number: Int){
        if number == 1{
            relationshipButton.setTitle("已关注", for: UIControlState.normal)
        }else if number == 2{
            relationshipButton.setTitle("未关注", for: UIControlState.normal)
        }
        relationshipButton.isEnabled = true
    }
    
    private func requestFollow(_ objectID : String ,completionHandler: @escaping (_ number : Int) -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = objectID
        Alamofire.request(ApiHelper.API_Root + "/users/" + ApiHelper.currentUser.id + "/follow/",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response follow ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "操作失败")
                                    }
                                    if result == "ok"{
                                        completionHandler(1)
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    private func requestUnFollow(_ objectID : String ,completionHandler: @escaping (_ number : Int) -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = objectID
        print("mark")
        print(ApiHelper.currentUser.uuid)
        print(ApiHelper.currentUser.id)
        print("mark")
        Alamofire.request(ApiHelper.API_Root + "/users/" + ApiHelper.currentUser.id + "/follow/",
                          method: .delete,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response unfollow ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "操作失败")
                                    }
                                    if result == "ok"{
                                        completionHandler(2)
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    private func updateUI(){
        let underLine = UIView(frame: CGRect(x: 0, y: 124, width: self.contentView.frame.width, height: 1))
        underLine.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        self.contentView.addSubview(underLine)
        
        avatarImage.layer.masksToBounds = true
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 36.0
        avatarImage.contentMode = .scaleAspectFill
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
        
        let blackColorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let greyColorAttribute = [ NSForegroundColorAttributeName: UIColor.gray]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 23) ]
        let systemFontAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        
        //followingButton
        followingButton.titleLabel?.numberOfLines = 0
        followingButton.titleLabel?.textAlignment = .center
        
        var para = (user?.followings)! + "\n"
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
        
        para = (user?.followers)! + "\n"
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
        
        para = (user?.likes)! + "\n"
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
        
        if listType == "1"{
            isFollow = true
        }else if user?.followType == "1"{
            isFollow = true
        }else{
            isFollow = false
        }
        
        if isFollow{
            relationshipButton.setTitle("已关注", for: UIControlState.normal)
        }else{
            relationshipButton.setTitle("未关注", for: UIControlState.normal)
        }
        
        usernameLabel.text = user?.username
        descriptionLabel.text = user?.description
    }
}
