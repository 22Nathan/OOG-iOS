//
//  UserTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 12/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate
import SVProgressHUD

class UserTableViewController: UITableViewController {
    
    enum profileItem{
        case Title(User)
        case MovementItem([Movement])
    }
    
    //Mark : - Model
    var profiles : [[profileItem]] = []
    var user : User?
    var followList = ""
    var isFollow = false
    
    var movementProfilesList : [Movement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        Cache.userMovementCache.setKeysuffix((user?.id)!)
        loadCache()
    }
    
    private func loadCache(){
        if Cache.userMovementCache.isEmpty{
            refreshCache()
            return
        }
        
        var titleProfiles : [profileItem] = []
        var movemntProfiles : [profileItem] = []
        
        
        profiles.removeAll()
        //parse TitleModel
        let userCell = profileItem.Title(user!)
        titleProfiles.append(userCell)
        
        
        //parse userMovemnt
        let movementValue = Cache.userMovementCache.value
        let json = JSON.parse(movementValue)
        let movements = json["movements"].arrayValue
        for movementJSON in movements{
            //parse basic info
            //            print(movementJSON)
            let movment_ID = movementJSON["id"].stringValue
            let content = movementJSON["content"].stringValue
            let likesNumber = movementJSON["likesNumber"].stringValue
            let repostsNumber = movementJSON["repostsNumber"].stringValue
            let commentsNumber = movementJSON["commentsNumber"].stringValue
            let movementType = movementJSON["movementType"].intValue
            
            //parse date
            let created_at = movementJSON["created_at"].stringValue
            let subRange = NSRange(location: 0,length: 19)
            var subCreated_at = created_at.substring(subRange)
            let fromIndex = created_at.index(subCreated_at.startIndex,offsetBy: 10)
            let toIndex = created_at.index(subCreated_at.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            subCreated_at.replaceSubrange(range, with: " ")
            let createdDate = DateInRegion(string: subCreated_at, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
            
            //parse imageUrl
            var imageNumber = 0
            let imageUrlsJSON = movementJSON["image_url"].arrayValue
            var imageUrls : [String] = []
            for imageUrl in imageUrlsJSON{
                imageUrls.append(imageUrl.stringValue)
                imageNumber += 1
            }
            //            let imageNumber_literal = String(imageNumber)
            
            //parse owner info
            let owner_avatar = movementJSON["owner"]["avatar_url"].stringValue
            let owner_userName = movementJSON["owner"]["username"].stringValue
            let owner_position = movementJSON["owner"]["position"].stringValue
            
            let movement_Model = Movement(movment_ID,
                                          content,
                                          Float(imageNumber),
                                          imageUrls,
                                          owner_avatar,
                                          owner_userName,
                                          owner_position,
                                          createdDate!,
                                          likesNumber,
                                          repostsNumber,
                                          commentsNumber,
                                          movementType)
            movementProfilesList.append(movement_Model)
        }
        movemntProfiles.append(profileItem.MovementItem(movementProfilesList))
        profiles.append(titleProfiles)
        profiles.append(movemntProfiles)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.userMovementCache.userMovementsRequest((self.user?.id)!) {
            self.loadCache()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile{
        case .Title( _):
            return 190
        case .MovementItem( _):
            var lines = CGFloat(movementProfilesList.count / 3)
            if movementProfilesList.count % 3 > 0{
                lines += 1
            }
            return lines * 125 - 3
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile {
        case .Title(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: "User Basic", for: indexPath) as! UserTableViewCell
            cell.user = user
            cell.listType = followList
            return cell
        case .MovementItem(let movements):
            let cell = tableView.dequeueReusableCell(withIdentifier: "User Movement", for: indexPath) as! UserMovementTableViewCell
            cell.movements = movements
            return cell
        }
    }
 

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "otherFollowing"{
            if let userListVC = destinationViewController as? UsersTableViewController{
                userListVC.ownerUserID = (user?.id)!
                userListVC.listType = "1"
                userListVC.navigationItem.title = (user?.username)! + "的关注"
            }
        }
        if segue.identifier == "otherFollower"{
            if let userListVC = destinationViewController as? UsersTableViewController{
                userListVC.ownerUserID = (user?.id)!
                userListVC.listType = "2"
                userListVC.navigationItem.title = (user?.username)! + "的粉丝"
            }
        }
    }
}
