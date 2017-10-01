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

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,HomeViewControllerProtocol,MAMapViewDelegate,AMapSearchDelegate,UIScrollViewDelegate {
    let loadingView_1 = DGElasticPullToRefreshLoadingViewCircle()
    let loadingView_2 = DGElasticPullToRefreshLoadingViewCircle()
    var userID : String = ApiHelper.currentUser.id
    
    //Mark : - map stuff
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var request = AMapReGeocodeSearchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置NavigationBar
//        segmented.backgroundColor = UIColor.flatBlack
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
        
        // 设置delegate和dataSource
        MovementsTableView.delegate = self
        HotTableView.delegate = self
        MovementsTableView.dataSource = self
        HotTableView.dataSource = self
        
        //定位系统
        AMapServices.shared().apiKey = ApiHelper.mapKey
        AMapServices.shared().enableHTTPS = true
//        let locationManager = AMapLocationManager()
//        locationManager.distanceFilter = 200
//        locationManager.delegate = self
//        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.locatingWithReGeocode = true
//        locationManager.startUpdatingLocation()
        mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        search = AMapSearchAPI()
        search.delegate = self
        let seconds = 90
        perform(#selector(self.startSearch), with: nil, afterDelay: TimeInterval(seconds))
        
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
        
        //初始化颜色
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let titleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleButton.setImage(#imageLiteral(resourceName: "number2.png"), for: UIControlState.normal)
        self.navigationItem.titleView = titleButton
        
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15) ]
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(boldFontAttribute, for: UIControlState.normal)
        
        let changedSeconds = 100 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100)
        perform(#selector(self.timeChanged), with: nil, afterDelay: TimeInterval(changedSeconds))
        
        //初始化Segmented
        segmented.tintColor = UIColor.clear
        let unselectedTextAttributes: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor ( red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0 )];
        segmented.setTitleTextAttributes(unselectedTextAttributes as [NSObject : AnyObject], for: UIControlState.normal)
        let selectedTextAttributes: NSDictionary = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.black]
        segmented.setTitleTextAttributes(selectedTextAttributes as [NSObject : AnyObject], for: UIControlState.selected)
        
        //初始化scrollView
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        let scrollViewFrame = scrollView.bounds
        scrollView.contentSize = CGSize(width: scrollViewFrame.size.width * CGFloat(segmented.numberOfSegments), height: scrollViewFrame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        //load Cache
        Cache.homeMovementsCache.value = ""
        loadCache()
    }
    @IBOutlet weak var segmented: UISegmentedControl!{
        didSet{
            segmented.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slider: UISlider!{
        didSet{
            slider.setThumbImage(#imageLiteral(resourceName: "empty.png"), for: UIControlState.normal)
        }
    }
    @IBOutlet weak var MovementsTableView: UITableView!
    @IBOutlet weak var HotTableView: UITableView!
    
    //Mark : -delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let segments = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        segmented.selectedSegmentIndex = segments
        segmentChanged(segmented)
    }
    //Mark : -Action
    func timeChanged() {
        refreshCache()
        // 到下一分钟的剩余秒数，这里虽然接近 60，但是不写死，防止误差累积
        let seconds = 100 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
    }

    func segmentChanged(_ sender : UISegmentedControl){
        let index = sender.selectedSegmentIndex
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(index)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
        if index == 0{
            slider.minimumTrackTintColor = UIColor.black
            slider.maximumTrackTintColor = UIColor ( red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0 )
        }else{
            slider.minimumTrackTintColor = UIColor ( red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0 )
            slider.maximumTrackTintColor = UIColor.black
        }
    }
    
    @IBAction func postMovement(from segue : UIStoryboardSegue){
        if let vc = segue.source as? HomePopViewController{
            let seconds = 0.4
            perform(#selector(self.performSegueToPost), with: nil, afterDelay: TimeInterval(seconds))
        }
    }
    
    func performSegueToPost(){
        performSegue(withIdentifier: "postMovementFromHome", sender: self)
    }
    
    //Mark : - delegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func cellMessageButtonDidPress(sender cell: UITableViewCell) {
        performSegue(withIdentifier: "movementDetail", sender: cell)
    }
    
    //Mark : -Model
    var movements : [[Movement]] = []
    var hotMovements : [[Movement]] = []
    
    //Mark : -Logic
    private func loadCache(){
        if Cache.homeMovementsCache.isEmpty{
            refreshCache()
            return
        }
        
        var movementList : [Movement] = []
        var hotMovementList : [Movement] = []
        movements.removeAll()
        hotMovements.removeAll()
        let value = Cache.homeMovementsCache.value
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
            if movementType == 1{
                movementList.append(movment_Model)
            }
            if movementType == 2{
                hotMovementList.append(movment_Model)
            }
        }
        movements.append(movementList)
        hotMovements.append(hotMovementList)
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
    
    //Mark: - AMapLocationManagerDelegate
    //更新用户位置
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(userLocation.coordinate.latitude), longitude: CGFloat(userLocation.coordinate.longitude))
//        search.aMapReGoecodeSearch(request)
        
    }
    
    //90秒确认一次地理位置
    func startSearch(){
        search.aMapReGoecodeSearch(request)
        let seconds = 90
        perform(#selector(self.startSearch), with: nil, afterDelay: TimeInterval(seconds))
    }
    
    //搜索回调函数
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode == nil {
            return
        }
        var city = response.regeocode.addressComponent.city! as NSString
        let range = NSMakeRange(0, city.length-1)
        ApiHelper.currentUser.atCity = city.substring(with: range)
        self.navigationItem.leftBarButtonItem?.title = ApiHelper.currentUser.atCity
    }
    
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 101{
            return movements.count
        }else{
            return hotMovements.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 101{
            return movements[section].count
        }else{
            return hotMovements[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 101{
            let movement = movements[indexPath.section][indexPath.row]
            let commentHeight = CGFloat(movement.comments.count * 29)
            return 520 + commentHeight
        }else{
            let movement = hotMovements[indexPath.section][indexPath.row]
            let commentHeight = CGFloat(movement.comments.count * 29)
            return 520 + commentHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusedID: String!
        if tableView.tag == 101 {
            reusedID = "HomeMovement"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! HomeMovementTableViewCell
            cell.movement = movements[indexPath.section][indexPath.row]
            cell.delegate = self
            return cell
        }
        else{
            reusedID = "HomeHot"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! HomeMovementTableViewCell
            cell.movement = hotMovements[indexPath.section][indexPath.row]
            cell.delegate = self
            return cell
        }
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
        if segue.identifier == "addMore"{
            if let vc = destinationViewController as? HomePopViewController {
                if let ppc = vc.popoverPresentationController{
                    ppc.delegate = self
                }
            }
        }
        if segue.identifier == "postMovementFromHome"{
            if let publishMovementVC = destinationViewController as? PublishMovementViewController{
                publishMovementVC.userID = userID
            }
        }
    }
}

protocol HomeViewControllerProtocol {
    func cellMessageButtonDidPress(sender cell: UITableViewCell)
}
