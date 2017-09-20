//
//  ChangeActionViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangeUsernameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
    }
    
    var text : String?
    
    @IBOutlet weak var changeTextField: UITextField!{
        didSet{
            changeTextField.text = text
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        if changeTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "昵称不能为空")
        }else{
            let user = ApiHelper.currentUser
            user.username = changeTextField.text!
            ApiHelper.currentUser = user
            Cache.currentUserCache.changeUserInfo(ApiHelper.currentUser.id, completionHandler: completionHandler)
        }
    }

    func completionHandler(){
        SVProgressHUD.showInfo(withStatus: "修改成功")
        performSegue(withIdentifier: "finishChange", sender: self)
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
