//
//  UserListTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 08/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SwiftyStarRatingView

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rateView: SwiftyStarRatingView!{
        didSet{
            rateView.isUserInteractionEnabled = false
            rateView.value = 3
        }
    }
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var relationshipButton: UIButton!{
        didSet{
            relationshipButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    var user : User?{
        didSet{
            updateUI()
        }
    }
    var listType : String?
    var isFollow : Bool = false
    
    private func initialIsFollow(){
        if listType == "1"{
            isFollow = true
        }else if user?.followType == "1"{
            isFollow = true
        }else{
            isFollow = false
        }
    }
    @IBAction func AskTeamAction(_ sender: Any) {
        requestTeam((user?.id)!)
    }
    
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
    
    private func requestTeam(_ objectID : String){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = objectID
        print(ApiHelper.currentUser.uuid)
        print(ApiHelper.currentUser.id)
        Alamofire.request(ApiHelper.API_Root + "/users/" + ApiHelper.currentUser.id + "/team/",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response teamAsk ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "对方已同意请求")
                                    }
                                    if result == "failed"{
                                        let reason = json["reason"].stringValue
                                        if reason == "the team has already full"{
                                            SVProgressHUD.showInfo(withStatus: "您的队伍人数已满")
                                        }
                                        else if reason == "the user has already joined one team"{
                                            SVProgressHUD.showInfo(withStatus: "该用户已有组队")
                                        }
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    private func updateUI(){
        //hook up image
        avatarImage.layer.masksToBounds = true
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 32.0
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
        
        let floatValue = Float((user?.userRate)!)
        rateView.value = CGFloat(floatValue!)
        
        initialIsFollow()
        
        //hook up button
        var word = "未关注"
        if isFollow{
            word = "已关注"
        }
        relationshipButton.backgroundColor = UIColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0)
        relationshipButton.setTitle(word, for: UIControlState.normal)
    }
}
