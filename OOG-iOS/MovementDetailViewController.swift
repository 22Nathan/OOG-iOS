//
//  MovementDetailViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 06/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import SwiftDate

class MovementDetailViewController: UIViewController,UIScrollViewDelegate,UITextViewDelegate {
    //Mark : - Model
    var movement : Movement?
    var commentList : [Comment] = []{
        didSet{
            let commentHeight = CGFloat((commentList.count) * 17)
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 529 + commentHeight)
//            commentsTextView.frame = CGRect(origin: commentsTextView.frame.origin, size: CGSize(width: 375, height: commentHeight))
        }
    }
    
    //Mark : -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        Cache.movementCommentCache.setKeysuffix((movement?.movement_ID)!)
        loadCache()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Mark : - control
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
            pageControl.currentPageIndicatorTintColor = UIColor.blue
            pageControl.hidesForSinglePage = true
            pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var created_atLabel: UILabel!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.isEditable = false
            contentTextView.delegate = self
            contentTextView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var commentsTextView: UITextView!{
        didSet{
            commentsTextView.isEditable = false
            commentsTextView.delegate = self
            commentsTextView.isScrollEnabled = false
        }
    }
    
    @IBOutlet weak var commentTextField: UITextField!{
        didSet{
            commentTextField.placeholder = "评论..."
            commentTextField.contentMode = .left
        }
    }
    //Mark : -Action
    func pageChanged(_ sender:UIPageControl){
        var frame = imageScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        imageScrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if commentTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "评论内容不能为空")
        }else{
            sendCommentRequest((movement?.movement_ID)!,completionHandler: completionHandler)
        }
    }
    
    func completionHandler(){
        commentTextField.text = ""
        refreshCache()
        SVProgressHUD.showInfo(withStatus: "评论成功")
    }
    
    //Mark : - Logic 
    private func loadCache(){
        if Cache.movementCommentCache.isEmpty{
            refreshCache()
            return
        }
        
        let value = Cache.movementCommentCache.value
        let json = JSON.parse(value)
        let comments = json["comments"].arrayValue
        commentList.removeAll()
        for commentJSON in comments{
            let content = commentJSON["comment_content"].stringValue
            let created_at = commentJSON["created_at"].stringValue
            let username = commentJSON["activeCommentUser"]["username"].stringValue
            
            let subRange = NSRange(location: 0,length: 19)
            var subCreated_at = created_at.substring(subRange)
            let fromIndex = created_at.index(subCreated_at.startIndex,offsetBy: 10)
            let toIndex = created_at.index(subCreated_at.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            subCreated_at.replaceSubrange(range, with: " ")
            let createdDate = DateInRegion(string: subCreated_at, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
            let comment = Comment(content,username,createdDate!)
            commentList.append(comment)
        }
        updateUI()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.movementCommentCache.movementComment((movement?.movement_ID)!) {
            self.loadCache()
        }
    }
    
    private func sendCommentRequest(_ objectID : String ,completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["id"] = ApiHelper.currentUser.id
        parameters["comment_content"] = commentTextField.text
        Alamofire.request(ApiHelper.API_Root + "/movements/" + objectID + "/comments/",
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
                                        completionHandler()
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    //Mark: - delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(imageScrollView.contentOffset.x / imageScrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
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
                textView.isScrollEnabled = true   // 允许滚动
            }
            else
            {
                textView.isScrollEnabled = false   // 不允许滚动
            }
        }
        textView.frame = CGRect(x: nowframe.origin.x, y: nowframe.origin.y, width: nowframe.size.width, height: size.height)
    }
    
    private func updateUI(){
        //hook up avator 
        avatarImage.contentMode = UIViewContentMode.scaleToFill
        avatarImage.layer.masksToBounds = true
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 23.0
        
        let profileImageKey = "ProfileImage" + (movement?.owner_userName)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            avatarImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (movement?.owner_avatar)!){
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
                        let resizeImage = UIImage(data: urlContents!)?.reSizeImage(reSize: CGSize(width: (self?.view.frame.width)!, height: (self?.view.frame.width)!))
                        let resizeData = UIImagePNGRepresentation(resizeImage!)
                        Cache.set(movementImageKey, resizeData)
                        if let imageData = resizeData{
                            DispatchQueue.main.async {
                                imageView.image = UIImage(data: imageData)
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
        
        //hook up label
        usernameLabel.text = movement?.owner_userName
        let displayTime = convertFrom((movement?.created_at)!)
        created_atLabel.text = displayTime
        likesNumber.text = (movement?.likesNumber)! + "人喜欢"
        
        //hook up content
        var para = (movement?.owner_userName)! + ":"
        let attributedContent = NSMutableAttributedString.init(string: para)
        let length = (para as NSString).length
        let userNameRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        attributedContent.addAttributes(colorAttribute, range: userNameRange)
        attributedContent.addAttributes(boldFontAttribute, range: userNameRange)
        
        para = " " +  (movement?.content)!
        let secondlength = (para as NSString).length
        let contentRange = NSRange(location: 0,length: secondlength)
        let attributedSuffix = NSMutableAttributedString(string: para)
        let fontAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]
        attributedSuffix.addAttributes(fontAttribute, range: contentRange)
        attributedContent.append(attributedSuffix)
        
        contentTextView.attributedText = attributedContent
        
        //hook up comments
        commentsTextView.text = ""
        let finalAttributedString = NSMutableAttributedString.init(string: "")
        for comment in commentList{
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
