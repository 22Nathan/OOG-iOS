//
//  MovementTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 20/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import DGElasticPullToRefresh
import SwiftDate

class MovementTableViewController: UITableViewController,HomeViewControllerProtocol{
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var userID : String = ApiHelper.currentUser.id
    var movementListType = "1"  //1为我的动态，2为点过赞的动态
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.refreshCache()
            self.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        
        //初始化颜色
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleButton.setImage(#imageLiteral(resourceName: "number2.png"), for: UIControlState.normal)
        self.navigationItem.titleView = titleButton
        
        loadCache()
    }
    
    func cellMessageButtonDidPress(sender cell: UITableViewCell) {
        performSegue(withIdentifier: "movementDetail", sender: cell)
    }
    
    //Mark : -Model
    var movements : [[Movement]] = []
    
    //Mark : -Logic
    private func loadCache(){
        if movementListType == "1"{
            if Cache.userMovementCache.isEmpty{
                refreshCache()
                return
            }
        }else if movementListType == "2"{
            if Cache.userLikeMovementCache.isEmpty{
                refreshCache()
                return
            }
        }
        var movementList : [Movement] = []
        movements.removeAll()
        var value = ""
        if movementListType == "1"{
            value = Cache.userMovementCache.value
        }else{
            value = Cache.userLikeMovementCache.value
        }
        let json = JSON.parse(value)
        let movments = json["movements"].arrayValue
        for movementJSON in movments{
            let movementsType = movementJSON["movementType"].intValue
            if movementsType == 3{
                continue
            }
            //parse basic info
            let movment_ID = movementJSON["id"].stringValue
            let content = movementJSON["content"].stringValue
            let likesNumber = movementJSON["likesNumber"].stringValue
            let repostsNumber = movementJSON["repostsNumber"].stringValue
            let commentsNumber = movementJSON["commentsNumber"].stringValue
            let movementType = movementJSON["movementType"].intValue
            let likeStatus = movementJSON["likedStatus"].stringValue
            
            //parse Date
            var created_at = movementJSON["created_at"].stringValue
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
            
            //parse display comment
            var displayComments : [Comment] = []
            let comments = movementJSON["displayedComments"].arrayValue
            for comment in comments{
                let content = comment["comment_content"].stringValue
                let created_at = comment["created_at"].stringValue
                let username = comment["activeCommentUser"]["username"].stringValue
                
                let subRange = NSRange(location: 0,length: 19)
                var subCreated_at = created_at.substring(subRange)
                let fromIndex = created_at.index(subCreated_at.startIndex,offsetBy: 10)
                let toIndex = created_at.index(subCreated_at.startIndex,offsetBy: 11)
                let range = fromIndex..<toIndex
                subCreated_at.replaceSubrange(range, with: " ")
                let createdDate = DateInRegion(string: subCreated_at, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
                let displayComment = Comment(content,username,createdDate!)
                displayComments.append(displayComment)
            }
            
            let movment_Model = Movement(movment_ID,
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
                                         movementType,
                                         displayComments,
                                         likeStatus)
            movementList.append(movment_Model)
        }
        movements.append(movementList)
        tableView.reloadData()
        hideProgressDialog()
    }
    private func refreshCache(){
        showProgressDialog()
        if movementListType == "1"{
            Cache.userMovementCache.userMovementsRequest(userID) {
                self.loadCache()
            }
        }else{
            Cache.userLikeMovementCache.userLikeMovementsRequest(userID) {
                self.loadCache()
            }
        }
    }
    
    //Mark : - tableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return movements.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements[section].count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let movement = movements[indexPath.section][indexPath.row]
        let commentHeight = CGFloat(movement.comments.count * 29)
        return 520 + commentHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "someMovement", for:indexPath) as! HomeMovementTableViewCell
        cell.movement = movements[indexPath.section][indexPath.row]
        cell.delegate = self
        return cell
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "movementDetail"{
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let movementDetailController = destinationViewController as? MovementDetailViewController{
                if let cell = sender as? HomeMovementTableViewCell{
                    movementDetailController.movement = cell.movement
                    movementDetailController.navigationItem.title = "Post"
                }
            }
        }
    }
}
