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

class HomeMovementTableViewCell: UITableViewCell,UITextViewDelegate,UIScrollViewDelegate {

    //Mark : initial
    @IBOutlet weak var imageScrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.currentPageIndicatorTintColor = UIColor.blue
            pageControl.hidesForSinglePage = true
            pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var ownerAvatarImgae: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!{
        didSet{
            commentsTextView.isEditable = false
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
            contentTextView.isEditable = false
            contentTextView.delegate = self
            contentTextView.isScrollEnabled = false
//            textViewDidChange(contentTextView)
        }
    }
    //Mark: -  Model
    var movement : Movement?{ didSet{updateUI()} }
    var isLike = false
    var delegate : HomeViewControllerProtocol?
    
    //Mark: - Action
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
    
    @IBAction func commentAction(_ sender: Any) {
        delegate?.cellMessageButtonDidPress(sender: self)
    }
    
    func pageChanged(_ sender:UIPageControl){
        var frame = imageScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        imageScrollView.scrollRectToVisible(frame, animated: true)
    }
    
    //Mark : - delegate
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(imageScrollView.contentOffset.x / imageScrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    //Mark: - Logic
    func completionHandler(plus number: Int){
        let previousNumber = Int((movement?.likesNumber)!)
        let newNumber = previousNumber! + number
        movement?.likesNumber = String(newNumber)
        self.likesNumberLabel.text = String(newNumber) + "人喜欢"
        self.likeButton.isEnabled = true
    }
    
    private func requestLikes(_ movementID : String ,completionHandler: @escaping (_ number : Int) -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = ApiHelper.currentUser.id
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
    
    private func requestDisLike(_ movementID : String, completionHandler: @escaping (_ number : Int) -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = ApiHelper.currentUser.id
        Alamofire.request(ApiHelper.API_Root + "/movements/" + movementID + "/likes/",
                          method: .delete,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON{response in
                            switch response.result.isSuccess{
                            case true:
                                if let value = response.value{
                                    let json = SwiftyJSON.JSON(value)
                                    print("################### Response Dislikes ###################")
                                    print(json)
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
        //hook up movement image
        for subView in imageScrollView.subviews{
            subView.removeFromSuperview()
        }
        
        imageScrollView.delegate = self
        let scrollViewFrame = imageScrollView.bounds
        let numOfPages = (movement?.imageNumber)!
        
        //设置imageScrollView
        imageScrollView.contentSize = CGSize(width: scrollViewFrame.size.width * CGFloat(numOfPages), height: scrollViewFrame.size.height)
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.scrollsToTop = false
        imageScrollView.bounces = false
        
        let intFormat = Int(numOfPages)
        //添加image
        for index in 0..<intFormat{
            let imageView = UIImageView(image: UIImage(named: "MovementImage\(index + 1)"))
            imageView.frame = CGRect(x: scrollViewFrame.size.width * CGFloat(index), y: 0, width: scrollViewFrame.size.width, height: scrollViewFrame.size.height)
            
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            let movementImageKey = "MovementImage" + (movement?.movement_ID)! + String(index)
            if let imageData = Cache.imageCache.data(forKey: movementImageKey){
                imageView.image = UIImage(data: imageData)
            }else{
                if let imageUrl = URL(string: (movement?.imageUrls[index])!){
                    DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                        let urlContents = try? Data(contentsOf: imageUrl)
                        let resizeImage = UIImage(data: urlContents!)?.reSizeImage(reSize: CGSize(width: 375, height: 375))
                        let resizeData = UIImagePNGRepresentation(resizeImage!)
                        Cache.set(movementImageKey, resizeData)
                        if let imageData = resizeData{
                            DispatchQueue.main.async {
                                self?.imageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }else{
                    imageView.image = nil
                }
            }
            imageScrollView.addSubview(imageView)
        }
        
        pageControl.numberOfPages = Int((movement?.imageNumber)!)
        pageControl.currentPage = 0
        pageControl.isHidden = false

        //hook up avator avatar image
        ownerAvatarImgae.layer.masksToBounds = true
        ownerAvatarImgae.clipsToBounds = true
        ownerAvatarImgae.layer.cornerRadius = 23.0
        
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
        //hook up label
        username.text = movement?.owner_userName
        let displayTime = convertFrom((movement?.created_at)!)
        createdAtLabel.text = displayTime
        likesNumberLabel.text = (movement?.likesNumber)! + "人喜欢"
        
        //hook up content
        var para = (movement?.owner_userName)! + ":"
        let attributedContent = NSMutableAttributedString.init(string: para)
        let length = (para as NSString).length
        let userNameRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16) ]
        attributedContent.addAttributes(colorAttribute, range: userNameRange)
        attributedContent.addAttributes(boldFontAttribute, range: userNameRange)
        
        para = " " +  (movement?.content)!
        let secondlength = (para as NSString).length
        let contentRange = NSRange(location: 0,length: secondlength)
        let attributedSuffix = NSMutableAttributedString(string: para)
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
