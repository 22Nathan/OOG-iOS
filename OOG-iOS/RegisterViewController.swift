//
//  RegisterViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class RegisterViewController: UIViewController,UITextFieldDelegate {

    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthCodeButton.addTarget(self, action: #selector
            (getAutHCode), for: .touchDown)
        nextButton.backgroundColor = UIColor(red: 0/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        requestAuthCodeButton.tintColor = UIColor(red: 0/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
    }
    
    //Mark: - model
    var user = User("")
    
    @IBOutlet weak var requestAuthCodeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var telTextField: UITextField!{
        didSet{
            telTextField.delegate = self
        }
    }
    @IBOutlet weak var authCodeTextField: UITextField!{
        didSet{
            authCodeTextField.delegate = self
        }
    }

    func getAutHCode(){
        if let tel = telTextField.text{
            let nsTel = tel as NSString
            if nsTel.length == 11{
                user.tel = tel
                requestAuthCode(tel, completionHandler: completionHandler)
            }else{
                SVProgressHUD.showInfo(withStatus: "非法手机号")
            }
        }
    }
    
    //TimeChanged
    func setButtonEable(){
        requestAuthCodeButton.isEnabled = true
        requestAuthCodeButton.setTitle("获取验证码", for: .normal)
    }
    
    func completionHandler(){
        requestAuthCodeButton.setTitle("重发", for: .normal)
        requestAuthCodeButton.isEnabled = false
        let seconds = 10
        perform(#selector(self.setButtonEable), with: nil, afterDelay: TimeInterval(seconds))
    }
    
    private func requestAuthCode(_ tel : String ,completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        parameters["tel"] = tel
        Alamofire.request(ApiHelper.API_Root + "/users/register/validation/",
                          method: .get,
                          parameters: ["tel":tel],
                          encoding: URLEncoding.default).responseJSON {response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    //Mark: - print
                    print("################### Response authCode ###################")
                    print(json)
                    let result = json["result"].stringValue
                    if result == "no"{
                        SVProgressHUD.showInfo(withStatus: "手机号已经注册")
                    }
                    if result == "ok"{
                        let authCode = json["authCode"].stringValue
                        self.user.authCode = authCode
                        completionHandler()
                    }
                }
            case false:
                print(response.result.error!)
            }
        }
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "next"{
            if authCodeTextField.text != user.authCode{
                SVProgressHUD.showInfo(withStatus: "验证码错误")
                return false
            }
            if authCodeTextField.text == ""{
                SVProgressHUD.showInfo(withStatus: "不能为空")
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if segue.identifier == "next"{
            if let completeInfoVC = destinationVC as? CompleteInfoViewController{
                completeInfoVC.user = user
            }
        }
    }
}
