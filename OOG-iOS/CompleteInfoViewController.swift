//
//  CompleteInfoViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 31/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CompleteInfoViewController: UIViewController,UITextFieldDelegate {

    //Mark: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        completeButton.addTarget(self, action: #selector(completeUserInfo), for: .touchDown)
    }
    
    //Mark: - Model
    var user = User("")
    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var positionTextField: UITextField!{
        didSet{
            positionTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var completeButton: UIButton!
    
    func completeUserInfo(){
        if usernameTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "昵称为空")
        }
        else if positionTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "位置为空")
        }
        else if passwordTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "密码为空")
        }else{
            user.username = usernameTextField.text!
            user.position = positionTextField.text!
            user.password = passwordTextField.text!
            requestRegister(self.user, completionHandler: completionHandler)
        }
    }
    
    func completionHandler(){
        ApiHelper.currentUser = user
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let tarBarController = sb.instantiateViewController(withIdentifier: "mainTarBarController")
        self.present(tarBarController, animated: true)
    }
    
    func requestRegister(_ user : User , completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        parameters["username"] = user.username
        parameters["password"] = user.password
        parameters["position"] = user.position
        parameters["tel"] = user.tel
        print(parameters)
        
        Alamofire.request(ApiHelper.API_Root + "/users/register/",
                          method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON {response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    //Mark: - print
                    print("response register")
                    print(json)
                    let userID = json["id"].stringValue
                    let uuid = json["uuid"].stringValue
                    let position = json["position"].stringValue
                    self.user.id = userID
                    self.user.uuid = uuid
                    ApiHelper.uuid = uuid
                    self.user.position = position
                    completionHandler()
                }
            case false:
                print(response.result.error!)
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
