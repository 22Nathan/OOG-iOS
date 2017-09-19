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
import JNDropDownMenu
import DKImagePickerController
import Qiniu
import Photos

class CompleteInfoViewController: UIViewController,UITextFieldDelegate,JNDropDownMenuDelegate, JNDropDownMenuDataSource {

    //Mark: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        completeButton.addTarget(self, action: #selector(completeUserInfo), for: .touchDown)
        completeButton.backgroundColor = UIColor(red: 0/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        
//        let positionMenu = JNDropDownMenu(origin: CGPoint(x: 57, y: 263), height: 30, width: 261)
//        positionMenu.datasource = self
//        positionMenu.delegate = self
//        positionMenu.arrowPostion = .Left
//        //        playerMenu.textFont = UIFont.boldSystemFont(ofSize: 11)
//        self.view.addSubview(positionMenu)
    }
    
    var uploadAsset : PHAsset?
    var token : String?
    
    //Mark: - Model
    var user = User("")
    var avatarUrl = ""
    var positionIndex : Int = 0
    
    var positionArray = ["控球后卫","得分后卫","小前锋","大前锋","中锋"]
    
    @IBOutlet weak var avatarImage: UIButton!{
        didSet{
            avatarImage.setBackgroundImage(#imageLiteral(resourceName: "logo.png").reSizeImage(reSize: CGSize(width: 80, height: 80)), for: UIControlState.normal)
            avatarImage.contentMode = UIViewContentMode.scaleAspectFit
            avatarImage.layer.masksToBounds = true
            avatarImage.clipsToBounds = true
            avatarImage.layer.cornerRadius = 40.0
        }
    }
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
            user.avatar_url = avatarUrl
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
        parameters["avatar_url"] = user.avatar_url
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
                    let avatar_url = json["avatar_url"].stringValue
                    self.user.id = userID
                    self.user.uuid = uuid
                    ApiHelper.uuid = uuid
                    self.user.position = position
                    self.user.avatar_url = avatar_url
                    completionHandler()
                }
            case false:
                print(response.result.error!)
            }
        }
    }
    
    private func requestToken(){
        Alamofire.request(ApiHelper.API_Root + "/users/picture/authentication/",
                          method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    self.token = json["result"].stringValue
                                    self.uploadData()
                                }
                            case false:
                                print(response.result.error!)
                                SVProgressHUD.showInfo(withStatus: "上传凭证获取失败")
                            }
        }
    }
    
    private func uploadData(){
        let upManager = QNUploadManager()
        let date = NSDate()
        let timeInterval = date.timeIntervalSince1970 * 1000
        let key = String(timeInterval)
        upManager?.put(uploadAsset, key: key, token: token, complete: { (responseInfo, key, dict) in
            if (responseInfo?.isOK)!{
                SVProgressHUD.showInfo(withStatus: "头像修改成功")
                self.avatarUrl = ApiHelper.qiniu_Root + key!
            }else{
                SVProgressHUD.showInfo(withStatus: "头像上传失败")
            }
        }, option: nil)
    }
    
    @IBAction func selectAvatarImage(_ sender: Any) {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            let uploadImage = convertPHAssetToUIImage(asset: assets[0].originalAsset!,80)
            self.avatarImage.setBackgroundImage(uploadImage, for: UIControlState.normal)
            self.uploadAsset = assets[0].originalAsset!
            self.requestToken()
        }
        self.present(pickerController, animated: true)
    }
    
    //Mark : - menu source
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 1
    }
    
    func numberOfRows(in column: NSInteger, for forMenu: JNDropDownMenu) -> Int {
        switch column {
        case 0:
            return positionArray.count
        default:
            return 0
        }
    }
    
    func titleForRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) -> String {
        switch indexPath.column {
        case 0:
            return positionArray[indexPath.row]
            
        default:
            return ""
        }
    }
    
    func didSelectRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) {
        switch indexPath.column {
        case 0:
            positionIndex = indexPath.row
            break
        default:
            positionIndex = 0
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
