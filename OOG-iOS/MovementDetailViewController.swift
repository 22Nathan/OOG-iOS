//
//  MovementDetailViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 06/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MovementDetailViewController: UIViewController,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        item.tintColor = UIColor.black
//        self.navigationItem.backBarButtonItem = item
        
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
    
    @IBAction func backAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    //Mark : - Model
    var movement : Movement?
    
    private func updateUI(){
        //hook up avator 
        avatarImage.contentMode = UIViewContentMode.scaleAspectFit
        
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
