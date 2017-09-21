//
//  ChangeInfoTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import DKImagePickerController
import Qiniu
import Photos
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ChangeInfoTableViewController: UITableViewController {
    var userID : String = ApiHelper.currentUser.id
    
    enum ChangeInfoItem{
        case image(String)
        case basic(String)
        case description(String)
    }
    
    //Mark : LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCache()
    }
    //Mark : Model
    var changeInfoItems : [[ChangeInfoItem]] = []
    var basicItems : [ChangeInfoItem] = []
    
    var uploadImage : UIImage?
    var uploadAsset : PHAsset?
    var token : String?
    
    func loadCache(){
        changeInfoItems.removeAll()
        basicItems.removeAll()
        
        let username = ApiHelper.currentUser.username
        let avatar_url = ApiHelper.currentUser.avatar_url
        let gender = ApiHelper.currentUser.gender
        let position = ApiHelper.currentUser.position
        let height = ApiHelper.currentUser.height
        let weight = ApiHelper.currentUser.weight
        let description = ApiHelper.currentUser.description
        
        let imageItem = ChangeInfoItem.image(avatar_url)
        changeInfoItems.append([imageItem])
        
        let basicUsernameItem = ChangeInfoItem.basic(username)
        let basicGenderItem = ChangeInfoItem.basic(gender)
        let basicPositionItem = ChangeInfoItem.basic(position)
        basicItems.append(basicUsernameItem)
        basicItems.append(basicGenderItem)
        basicItems.append(basicPositionItem)
        changeInfoItems.append(basicItems)
        
        let descriptionItem = ChangeInfoItem.description(description)
        changeInfoItems.append([descriptionItem])
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return changeInfoItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changeInfoItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = changeInfoItems[indexPath.section][indexPath.row]
        switch item{
        case .image( _):
            return 71
        case .basic( _):
            return 40
        case .description( _):
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = changeInfoItems[indexPath.section][indexPath.row]
        switch item {
        case .image(let url):
            let pickerController = DKImagePickerController()
            pickerController.maxSelectableCount = 1
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                if assets.count > 0{
                    self.uploadImage = convertPHAssetToUIImage(asset: assets[0].originalAsset!,71)
                    self.uploadAsset = assets[0].originalAsset!
                    self.requestToken()
                }
            }
            self.present(pickerController, animated: true)
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = changeInfoItems[indexPath.section][indexPath.row]
        switch item {
        case .image(let url):
            let cell = tableView.dequeueReusableCell(withIdentifier: "change image", for: indexPath) as! ChangeImageTableViewCell
            cell.imageUrl = url
            return cell
        case .basic(let info):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Info", for: indexPath) as! ChangeBasicTableViewCell
            cell.info = info
            return cell
        case .description(let des):
            let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath) as! ChangeDesciptionTableViewCell
//            cell.desciption = des
            return cell
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
            let key = userID + String(timeInterval)
            upManager?.put(uploadAsset, key: key, token: token, complete: { (responseInfo, key, dict) in
                if (responseInfo?.isOK)!{
                    SVProgressHUD.showInfo(withStatus: "头像修改成功")
                    let user = ApiHelper.currentUser
                    user.avatar_url = ApiHelper.qiniu_Root + key!
                    ApiHelper.currentUser = user
                    print(ApiHelper.currentUser.avatar_url)
                    Cache.currentUserCache.changeUserInfo(ApiHelper.currentUser.id, completionHandler: self.completionHandler)
                }else{
                    SVProgressHUD.showInfo(withStatus: "头像上传失败")
                }
            }, option: nil)
    }
    
    func completionHandler(){
        Cache.clearTempImage()
        self.loadCache()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "ChangeUsername"{
            if let detailVC = destinationViewController as? ChangeUsernameViewController{
                if let cell = sender as? ChangeBasicTableViewCell{
                    detailVC.navigationItem.title = cell.titleLabel.text
                    detailVC.text = cell.infoLabel.text
                }
            }
        }
        if segue.identifier == "changeDescription"{
            if let desVC = destinationViewController as? ChangeDescriptionViewController{
                if let cell = sender as? ChangeDesciptionTableViewCell{
                    desVC.navigationItem.title = cell.desLabel.text
                    desVC.text = ApiHelper.currentUser.description
                }
            }
        }
    }
    

}
