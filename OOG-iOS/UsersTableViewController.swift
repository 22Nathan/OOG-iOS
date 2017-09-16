//
//  UsersTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 08/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsersTableViewController: UITableViewController {

    var ownerUserID = ApiHelper.currentUser.id
    var listType = "1"  //1为关注的人，2为粉丝
    
    //Mark : LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Cache.userListCache.setKeysuffix(self.ownerUserID + self.listType)
        Cache.userListCache.value = ""
        loadCache()
    }
    
    //Mark : Model
    var usersModel : [[User]] = []
    
    private func loadCache(){
        if Cache.userListCache.isEmpty{
            refreshCache()
            return
        }
        
        let value = Cache.userListCache.value
        let json = JSON.parse(value)
        
        var userList : [User] = []
        usersModel.removeAll()
        
        //parse
        let users = json["users"].arrayValue
        for userJSON in users{
            let userID = userJSON["id"].stringValue
            let username = userJSON["username"].stringValue
            let tel = userJSON["tel"].stringValue
            let position = userJSON["position"].stringValue
            let avatar_url = userJSON["avatar_url"].stringValue
            let followings = userJSON["followingNumber"].stringValue
            let followers = userJSON["followedNumber"].stringValue
            let likes = userJSON["likes"].stringValue
            let followType = userJSON["followType"].stringValue
            let description = userJSON["description"].stringValue
            
            let user = User(username,
                            tel,
                            "",
                            userID,
                            "",
                            "",
                            position,
                            avatar_url,
                            followings,
                            followers,
                            likes,
                            description,
                            "",
                            "",
                            followType)
            userList.append(user)
        }
        usersModel.append(userList)
        tableView.reloadData()
    }
    
    private func refreshCache(){
        Cache.userListCache.userFollowersOrFollowings(ownerUserID, listType) { 
            self.loadCache()
        }
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return usersModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersModel[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User List", for: indexPath) as! UserListTableViewCell
        cell.user = usersModel[indexPath.section][indexPath.row]
        cell.listType = listType
        return cell
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "user detail"{
            if let userVC = destinationViewController as? UserTableViewController{
                if let cell = sender as? UserListTableViewCell{
                    print("what")
                    userVC.user = cell.user
                    userVC.navigationItem.title = cell.user?.username
                    userVC.followList = cell.listType!
                }
            }
        }
    }
    

}
