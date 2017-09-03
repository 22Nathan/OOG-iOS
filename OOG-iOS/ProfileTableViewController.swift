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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCache()
        let seconds = 60 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 60)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: - Model
    var profiles : [[TitleModel]] = []
    var profileUserName : String = ApiHelper.currentUser.username
    
    //MARK: - Logic
    func timeChanged() {
        refreshCache()
        // 到下一分钟的剩余秒数，这里虽然接近 60，但是不写死，防止误差累积
        let seconds = 60 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 60)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
    }
    
    private func loadCache(){
        if(Cache.currentUserCache.isEmpty){
            refreshCache()
            return
        }
        
        var titleProfiles : [TitleModel] = []
        profiles.removeAll()
        let value = Cache.currentUserCache.value
        let json = JSON.parse(value)
        
        //parse TitleModel
        let username = json["username"].stringValue
        let tel = json["tel"].stringValue
        let position = json["position"].stringValue
        let avator_Url = json["avator_Url"].stringValue
        let followings = json["followings"].stringValue
        let followers = json["followers"].stringValue
        let likes = json["likes"].stringValue
        
        let title = TitleModel(username,tel,position,avator_Url,followings,followers,likes)
        titleProfiles.append(title)
        
        //parse MovementModel
        
        
        //finish
        profiles.append(titleProfiles)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.currentUserCache.userInfoRequest(profileUserName) { 
            self.loadCache()
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
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleModel = profiles[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell", for: indexPath) as! TitleTableViewCell
        cell.title = titleModel
        return cell
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
