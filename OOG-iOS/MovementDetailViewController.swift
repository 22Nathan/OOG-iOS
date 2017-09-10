//
//  MovementDetailViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 06/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MovementDetailViewController: UIViewController,UIScrollViewDelegate,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()        
        updateUI()
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var movementImage: UIImageView!
    @IBOutlet weak var created_atLabel: UILabel!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate = self
        }
    }
    @IBOutlet weak var commentsTextView: UITextView!{
        didSet{
            commentsTextView.delegate = self
        }
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
    
    //Mark : - Model
    var movement : Movement?
    
    private func updateUI(){
        //hook up avator 
        avatarImage.contentMode = UIViewContentMode.scaleToFill
        avatarImage.clipsToBounds = true
        
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
        usernameLabel.text = movement?.owner_userName
        let displayTime = convertFrom((movement?.created_at)!)
        created_atLabel.text = displayTime
        likesNumber.text = (movement?.likesNumber)! + "人喜欢"
        
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
