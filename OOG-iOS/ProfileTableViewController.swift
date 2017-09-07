//
//  ProfileTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 01/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileTableViewController: UITableViewController {
    enum profileItem{
        case Title(TitleModel)
        case Info(String)
        case MovementItem([Movement])
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.showsVerticalScrollIndicator = false
        //动态设置用户Cache
        Cache.userMovementCache.setKeysuffix(userID)
        Cache.userMovementCache.value = ""
        loadCache()
        let seconds = 100 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: - Model
    var profiles : [[profileItem]] = []
    var profileUserName : String = ApiHelper.currentUser.username
    var userID : String = ApiHelper.currentUser.uuid
    
    //MARK: - Logic
    func timeChanged() {
        refreshCache()
        // 到下一分钟的剩余秒数，这里虽然接近 60，但是不写死，防止误差累积
        let seconds = 100 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
    }
    
    private func loadCache(){
        if(Cache.currentUserCache.isEmpty || Cache.userMovementCache.isEmpty){
            refreshCache()
            return
        }
        
        var titleProfiles : [profileItem] = []
        var infoProfiles : [profileItem] = []
        var movementProfilesList : [Movement] = []
        var movemntProfiles : [profileItem] = []
        titleProfiles.removeAll()
        infoProfiles.removeAll()
        movemntProfiles.removeAll()
        profiles.removeAll()
        let userValue = Cache.currentUserCache.value
        var json = JSON.parse(userValue)
        
        //parse TitleModel
        let username = json["username"].stringValue
        let tel = json["tel"].stringValue
        let position = json["position"].stringValue
        let avatar_url = json["avatar_url"].stringValue
        let followings = json["followingNumber"].intValue
        let followingsString = String(followings)
        let followers = json["followedNumber"].intValue
        let followersString = String(followers)
        let likes = json["likes"].stringValue
        let description = json["description"].stringValue
        
        let title = profileItem.Title(TitleModel(username,tel,position,avatar_url,followingsString,followersString,likes,description))
        titleProfiles.append(title)
        
        //parse Info
        let firstLabelText = "我的动态"
        let secondLabelText = "我的评分"
        infoProfiles.append(profileItem.Info(firstLabelText))
        infoProfiles.append(profileItem.Info(secondLabelText))
        
        //parse userMovemnt
        let movementValue = Cache.userMovementCache.value
        json = JSON.parse(movementValue)
        let movements = json["movements"].arrayValue
        for movementJSON in movements{
            //parse basic info
            //            print(movementJSON)
            let movment_ID = movementJSON["movement_ID"].stringValue
            let content = movementJSON["content"].stringValue
            let created_at = movementJSON["created_at"].stringValue
            let likesNumber = movementJSON["likesNumber"].stringValue
            let repostsNumber = movementJSON["repostsNumber"].stringValue
            let commentsNumber = movementJSON["commentsNumber"].stringValue
            
            //parse imageUrl
            var imageNumber = 0
            let imageUrlsJSON = movementJSON["image_url"].arrayValue
            var imageUrls : [String] = []
            for imageUrl in imageUrlsJSON{
                imageUrls.append(imageUrl.stringValue)
                imageNumber += 1
            }
            let imageNumber_literal = String(imageNumber)
            
            //parse owner info
            let owner_avatar = movementJSON["owner"]["avatar_url"].stringValue
            let owner_userName = movementJSON["owner"]["username"].stringValue
            let owner_position = movementJSON["owner"]["position"].stringValue
            
            let movement_Model = Movement(movment_ID,
                                         content,
                                         imageNumber_literal,
                                         imageUrls,
                                         owner_avatar,
                                         owner_userName,
                                         owner_position,
                                         created_at,
                                         likesNumber,
                                         repostsNumber,
                                         commentsNumber)
            movementProfilesList.append(movement_Model)
        }
        movemntProfiles.append(profileItem.MovementItem(movementProfilesList))
        
        //finish
        profiles.append(titleProfiles)
//        profiles.append(infoProfiles)
        profiles.append(movemntProfiles)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.currentUserCache.userInfoRequest(profileUserName) { 
            Cache.userMovementCache.userMovementsRequest(self.userID) {
                self.loadCache()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return profiles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile{
        case .Title( _):
            return 240
        case .Info( _):
            return 50
        case .MovementItem( _):
            return 375
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile {
        case .Title(let tempTitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell", for: indexPath) as! TitleTableViewCell
            cell.title = tempTitle
            return cell
        case .Info(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Info Cell", for: indexPath) as! InfoTableViewCell
            cell.infoLabel.text = text
            return cell
        case .MovementItem(let movements):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovementDisplay", for: indexPath) as! MovementDisplayTableViewCell
            cell.movements = movements
            return cell
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
