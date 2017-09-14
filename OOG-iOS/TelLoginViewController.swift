//
//  TelLoginViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class TelLoginViewController: UIViewController,UITextFieldDelegate {

    //Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.backgroundColor = UIColor.flatBlue
        loginButton.addTarget(self, action: #selector(loginRequest), for: .touchDown)
    }
    
    //Mark: - model
    var user = User("")
    
    @IBOutlet weak var cellPhoneTextField: UITextField!{
        didSet{
            cellPhoneTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    func loginRequest(){
        if cellPhoneTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "账号为空")
        }
        else if passwordTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "密码为空")
        }else{
            user.tel = cellPhoneTextField.text!
            user.password = passwordTextField.text!
            requestLogin(self.user, completionHandler: completionHandler)
        }
    }
    
    func completionHandler(){
        ApiHelper.currentUser = user
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let tarBarController = sb.instantiateViewController(withIdentifier: "mainTarBarController")
        self.present(tarBarController, animated: true)
    }
    
    func requestLogin(_ user : User , completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        parameters["password"] = user.password
        parameters["tel"] = user.tel
        
        Alamofire.request(ApiHelper.API_Root + "/users/login/",
                          method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    //Mark: - print
                    print("################### Response login #####################")
                    print(json)
                    let result = json["result"]
                    if result == "ok"{
                        let userID = json["id"].stringValue
                        let uuid = json["uuid"].stringValue
                        let username = json["username"].stringValue
                        let avatar_url = json["avatar_url"].stringValue
                        let followers = json["followers"].stringValue
                        let followings = json["followings"].stringValue
                        let likes = json["likes"].stringValue
                        let position = json["position"].stringValue
                        
                        self.user.id = userID
                        self.user.uuid = uuid
                        self.user.followers = followers
                        self.user.followings = followings
                        self.user.likes = likes
                        self.user.position = position
                        self.user.username = username
                        self.user.avatar_url = avatar_url
                        completionHandler()
                    }
                    else{
                        let reason = json["reason"]
                        if reason == "wrong tel"{
                            SVProgressHUD.showInfo(withStatus: "账号不存在")
                        }
                        if reason == "wrong password"{
                            SVProgressHUD.showInfo(withStatus: "密码错误")
                        }
                    }
                }
            case false:
                print(response.result.error!)
            }
        }
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
