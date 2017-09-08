//
//  HomeMovementTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 05/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

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
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    //Model
    var movement : Movement?{ didSet{updateUI()} }
    
    var isLike = false
    
    @IBAction func likesAction(_ sender: Any) {
        if isLike{
            //发请求取消
            
            isLike = false
        }else{
            isLike = true
            requestLikes((movement?.movement_ID)!, completionHandler: completionHandler)
        }
    }
    
    func completionHandler(plus number: Int){
        let previousNumber = Int((movement?.likesNumber)!)
        let newNumber = previousNumber! + number
        likesNumberLabel.text = String(newNumber) + "人喜欢"
    }
    
    private func requestLikes(_ movementID : String ,completionHandler: @escaping (_ number : Int) -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        Alamofire.request(ApiHelper.API_Root + "/movements/" + movementID + "/likes/",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response likes ###################")
//                                    print(json)
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
        let displayTime = convertFrom((movement?.created_at)!)
        createdAtLabel.text = displayTime
        likesNumberLabel.text = (movement?.likesNumber)! + "人喜欢"
        contentTextView.text = (movement?.owner_userName)! + " " + (movement?.content)!
        
        
    }
}
