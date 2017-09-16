//
//  TeamTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import SwiftyJSON

class TeamTableViewController: UITableViewController,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{

    enum teamItem{
        case Title(TeamTitleModel)
        case UserItem(User)
    }
    
    var ifEmpty = false
    var userID = ApiHelper.currentUser.id
    
    //Mark : - Model
    var teamItems : [[teamItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        //Cache后缀
        Cache.userTeamCache.setKeysuffix(userID)
//        Cache.userTeamCache.value = ""
        loadCache()
    }
    
    //Mark : -  Logic
    func loadCache(){
        if Cache.userTeamCache.isEmpty{
            refreshCache()
            return
        }
        
        var memberList : [teamItem] = []
        teamItems.removeAll()
        
        let teamValue = Cache.userTeamCache.value
        var json = JSON.parse(teamValue)
        let teamMember = json["users"].arrayValue
        let peopleNumber = json["peopleNumber"].stringValue
        let averageRate = json["averageRate"].stringValue
        let teamTitle = teamItem.Title(TeamTitleModel(peopleNumber,averageRate))
        teamItems.append([teamTitle])
        
        for memberJSON in teamMember{
            if memberJSON["id"].stringValue == ApiHelper.currentUser.id{
                continue
            }
            let userID = memberJSON["id"].stringValue
            let username = memberJSON["username"].stringValue
            let tel = memberJSON["tel"].stringValue
            let position = memberJSON["position"].stringValue
            let avatar_url = memberJSON["avatar_url"].stringValue
            let followings = memberJSON["followingNumber"].stringValue
            let followers = memberJSON["followedNumber"].stringValue
            let likes = memberJSON["likes"].stringValue
            let description = memberJSON["description"].stringValue
            
            let user = teamItem.UserItem(User(username,
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
                                              ""))
            memberList.append(user)
        }
        teamItems.append(memberList)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    func refreshCache(){
        showProgressDialog()
        Cache.userTeamCache.userTeamInfo(userID) { (isEmpty) in
            if isEmpty{
                self.ifEmpty = false
                self.tableView.reloadData()
                self.hideProgressDialog()
            }else{
                self.loadCache()
            }
        }
    }
    
    //Mark : - DZNEmptyDataSetDelegate
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return ifEmpty
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "like.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    //Mark : - DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let para = "您目前没有组队呢~"
        let attributedTitle = NSMutableAttributedString.init(string: para)
        let length = (para as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.black ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18) ]
        attributedTitle.addAttributes(colorAttribute, range: titleRange)
        attributedTitle.addAttributes(boldFontAttribute, range: titleRange)
        return attributedTitle
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let para = "快去邀请用户吧~"
        let attributedDescription = NSMutableAttributedString.init(string: para)
        let length = (para as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.gray ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        attributedDescription.addAttributes(colorAttribute, range: titleRange)
        attributedDescription.addAttributes(boldFontAttribute, range: titleRange)
        return attributedDescription
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return teamItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teamItem = teamItems[indexPath.section][indexPath.row]
        switch teamItem {
        case .Title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Team Title", for: indexPath) as! TeamTitleTableViewCell
            cell.teamTitle = title
            return cell
        case .UserItem(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Team User", for: indexPath) as! TeamUserTableViewCell
            cell.user = user
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
