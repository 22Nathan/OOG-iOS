//
//  HomeViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 04/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import DGElasticPullToRefresh
import SwiftDate

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var userID : String = ApiHelper.currentUser.uuid
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        segmented.backgroundColor = UIColor.flatBlack
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
        
        // 设置delegate和dataSource
        MovementsTableView.delegate = self
        HotTableView.delegate = self
        MovementsTableView.dataSource = self
        HotTableView.dataSource = self
        
        
        // Refresh stuff
        loadingView_1.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        loadingView_2.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        MovementsTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Cache.homeMovementsCache.homeMovementRequest(userID: (self?.userID)!) {
                self?.loadCache()
                self?.MovementsTableView.dg_stopLoading()
            }
        }, loadingView: loadingView_1)
        HotTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Cache.homeMovementsCache.homeMovementRequest(userID: (self?.userID)!) {
                self?.loadCache()
                self?.HotTableView.dg_stopLoading()
            }
            }, loadingView: loadingView_2)
        
        // 设置左滑和右滑手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(swipeLeft)
        scrollView.addGestureRecognizer(swipeRight)
        
//        Cache.homeMovementsCache.value = ""
        loadCache()
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var MovementsTableView: UITableView!
    @IBOutlet weak var HotTableView: UITableView!
    
    let loadingView_1 = DGElasticPullToRefreshLoadingViewCircle()
    let loadingView_2 = DGElasticPullToRefreshLoadingViewCircle()
    
    //Mark: - Action
    var offset: CGFloat = 0.0 {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.scrollView.contentOffset = CGPoint(x: self.offset, y: 0.0)
            }
        }
    }
    
    func swipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // 向左滑时展示第二个tableview,同时设置选中的segmented item
            offset = self.view.frame.width
            segmented.selectedSegmentIndex = 1
        }
        else {
            offset = 0.0
            segmented.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func tabChanged(_ sender: Any) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        offset = CGFloat(index) * self.view.frame.width
    }
    
    //Mark : -Model
    var movements : [[Movement]] = []
    
    //Mark : -Logic
    private func loadCache(){
        if Cache.homeMovementsCache.isEmpty{
            refreshCache()
            return
        }
        
        var movementList : [Movement] = []
        movements.removeAll()
        let value = Cache.homeMovementsCache.value
        let json = JSON.parse(value)
        let movments = json["movements"].arrayValue
        for movementJSON in movments{
            //parse basic info
//            print(movementJSON)
            let movment_ID = movementJSON["movement_ID"].stringValue
            let content = movementJSON["content"].stringValue
            let likesNumber = movementJSON["likesNumber"].stringValue
            let repostsNumber = movementJSON["repostsNumber"].stringValue
            let commentsNumber = movementJSON["commentsNumber"].stringValue
            let movementType = movementJSON["movementType"].intValue
            
            //parse Date
            var created_at = movementJSON["created_at"].stringValue
            let subRange = NSRange(location: 0,length: 19)
            var subCreated_at = created_at.substring(subRange)
            let fromIndex = created_at.index(subCreated_at.startIndex,offsetBy: 10)
            let toIndex = created_at.index(subCreated_at.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            subCreated_at.replaceSubrange(range, with: " ")
//            print(subCreated_at)
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
                                         displayComments)
            
            movementList.append(movment_Model)
        }
        movements.append(movementList)
        MovementsTableView.reloadData()
        HotTableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.homeMovementsCache.homeMovementRequest(userID: userID) {
            self.loadCache()
        }
    }
    
    
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return movements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusedID: String!
        if tableView.tag == 101 {
            reusedID = "HomeMovement"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! HomeMovementTableViewCell
            cell.movement = movements[indexPath.section][indexPath.row]
            return cell
        }
        else{
            reusedID = "HomeHot"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath)
            cell.textLabel!.text = "第二个TableView"
            return cell
        }
    }
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController{
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let movementDetailController = destinationViewController as? MovementDetailViewController{
            if segue.identifier == "movementDetail"{
                if let cell = sender as? HomeMovementTableViewCell{
                    movementDetailController.movement = cell.movement
                    movementDetailController.navigationItem.title = "Post"
                }
            }
        }
    }
}
