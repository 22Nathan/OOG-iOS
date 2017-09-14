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
    @IBOutlet weak var relationshipButton: UIButton!
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
        
        followingButton.titleLabel?.numberOfLines = 0
        followingButton.titleLabel?.textAlignment = .center
        followingButton.setTitle("关注\n" + (user?.followings)!, for: UIControlState(rawValue: 0))
        
        followerButton.titleLabel?.numberOfLines = 0
        followerButton.titleLabel?.textAlignment = .center
        followerButton.setTitle("粉丝\n" + (user?.followers)!, for: UIControlState(rawValue: 0))
        
        likesButton.titleLabel?.numberOfLines = 0
        likesButton.titleLabel?.textAlignment = .center
        likesButton.setTitle("喜欢\n" + (user?.likes)!, for: UIControlState(rawValue: 0))
        
        descriptionLabel.text = user?.description
        usernameLabel.text = user?.username
        
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
    }
}
