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

class HomeMovementTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var ownerAvatarImgae: UIImageView!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!{
        didSet{
            commentsTextView.delegate = self
//            textViewDidChange(commentsTextView)
            commentsTextView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate = self
//            textViewDidChange(contentTextView)
        }
    }
    //Model
    var movement : Movement?{ didSet{updateUI()} }
    
    var isLike = false
    
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight : CGFloat = CGFloat(300)
        let nowframe = textView.frame
        let constraintSize = CGSize(width: nowframe.size.width, height: 300)
        var size = textView.sizeThatFits(constraintSize)
        if (size.height <= nowframe.size.height) {
            size.height = nowframe.size.height
        }else{
            if (size.height >= maxHeight)
            {
                size.height = maxHeight
//                textView.isScrollEnabled = true   // 允许滚动
            }
            textView.isScrollEnabled = false
//            else
//            {
//                textView.isScrollEnabled = false   // 不允许滚动
////                contentTextView.isScrollEnabled = false
//            }
        }
        textView.frame = CGRect(x: nowframe.origin.x, y: nowframe.origin.y, width: nowframe.size.width, height: size.height)
    }
    
    @IBAction func likesAction(_ sender: Any) {
        if isLike{
            //发请求取消
            isLike = false
            likeButton.isEnabled = false
            requestDisLike((movement?.movement_ID)!, completionHandler: completionHandler)
        }else{
            isLike = true
            likeButton.isEnabled = false
            requestLikes((movement?.movement_ID)!, completionHandler: completionHandler)
        }
    }
    
    func completionHandler(plus number: Int){
        let previousNumber = Int((movement?.likesNumber)!)
        let newNumber = previousNumber! + number
        likesNumberLabel.text = String(newNumber) + "人喜欢"
        likeButton.isEnabled = true
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
    
    private func requestDisLike(_ movementID : String, completionHandler: @escaping (_ number : Int) -> ()){
        Alamofire.request(ApiHelper.API_Root + "/movements/" + movementID + "/likes/",
                          method: .delete,
                          parameters: nil,
                          encoding: URLEncoding.default).responseJSON{response in
                            switch response.result.isSuccess{
                            case true:
                                if let value = response.value{
                                    let json = SwiftyJSON.JSON(value)
                                    print(json)
                                    print("################### Response Dislikes ###################")
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "操作失败")
                                    }
                                    if result == "ok"{
                                        completionHandler(-1)
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
        
        //hook up textView
        //hook up content
        var para = movement?.owner_userName
        let attributedContent = NSMutableAttributedString.init(string: para!)
        let length = (para! as NSString).length
        let userNameRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        attributedContent.addAttributes(colorAttribute, range: userNameRange)
        attributedContent.addAttributes(boldFontAttribute, range: userNameRange)
        
        para = " " +  (movement?.content)!
        let secondlength = (para! as NSString).length
        let contentRange = NSRange(location: 0,length: secondlength)
        let attributedSuffix = NSMutableAttributedString(string: para!)
        let fontAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 14) ]
        attributedSuffix.addAttributes(fontAttribute, range: contentRange)
        attributedContent.append(attributedSuffix)
        
        contentTextView.attributedText = attributedContent
        
        //hook up comments
        commentsTextView.text = ""
        let finalAttributedString = NSMutableAttributedString.init(string: "")
        for comment in (movement?.comments)!{
            let attributedUserName = NSMutableAttributedString.init(string: comment.username)
            let attributedComment = NSMutableAttributedString.init(string: " " + comment.content + "\n")
            
            let length_1 = (comment.username as NSString).length
            let length_2 = (comment.content as NSString).length
            let userNameRange = NSRange(location: 0,length: length_1)
            let contentRange = NSRange(location: 0,length: length_2)
            
            attributedUserName.addAttributes(boldFontAttribute, range: userNameRange)
            attributedComment.addAttributes(fontAttribute, range: contentRange)
            
            attributedUserName.append(attributedComment)
            finalAttributedString.append(attributedUserName)
        }
        commentsTextView.attributedText = finalAttributedString
//        commentsTextView.insertText(comment.username + " " + comment.content + "\n")
    }
}
