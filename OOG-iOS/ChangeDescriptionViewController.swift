//
//  ChangeDescriptionViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangeDescriptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.isScrollEnabled = false
            textView.text = text
        }
    }
    var text : String?

    @IBAction func saveAction(_ sender: Any) {
        let user = ApiHelper.currentUser
        user.description = textView.text!
        ApiHelper.currentUser = user
        Cache.currentUserCache.changeUserInfo(ApiHelper.currentUser.id, completionHandler: completionHandler)
    }
    
    func completionHandler(){
        SVProgressHUD.showInfo(withStatus: "修改成功")
        performSegue(withIdentifier: "change", sender: self)
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
