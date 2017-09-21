//
//  GameTabViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet
import Alamofire
import SVProgressHUD
import DGElasticPullToRefresh
class GameTabViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,AMapSearchDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,GameTabViewControllerProtocol {
    let loadingView_1 = DGElasticPullToRefreshLoadingViewCircle()
    let loadingView_2 = DGElasticPullToRefreshLoadingViewCircle()
    let loadingView_3 = DGElasticPullToRefreshLoadingViewCircle()
    var mapView: MAMapView!
    var userID : String = ApiHelper.currentUser.id
    //Mark : - Model
    var toStartGames : [[Game]] = []
    var ingGame : Game?
    var unRatedGame : [[Game]] = []
    var unRateUsers : [[RatedUser]] = []
    var finishedGame : [[Game]] = []
    
    var ifHavingInGame = false
    var inGameCourtFlag = false
    var inGameVCDelegate : InGameUIViewControllerDelegate?
    
    var flags : [Bool] = []
    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
        
        //定位系统
        AMapServices.shared().apiKey = ApiHelper.mapKey
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //pull refresh
        toStartTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Cache.userGameCache.userGameRequest(userID: (self?.userID)!) {
                self?.loadCache()
                self?.toStartTableView.dg_stopLoading()
            }
            }, loadingView: loadingView_1)
        unRatedGameTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Cache.userGameCache.userGameRequest(userID: (self?.userID)!) {
                self?.loadCache()
                self?.toStartTableView.dg_stopLoading()
            }
            }, loadingView: loadingView_2)
        toStartTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Cache.userGameCache.userGameRequest(userID: (self?.userID)!) {
                self?.loadCache()
                self?.toStartTableView.dg_stopLoading()
            }
            }, loadingView: loadingView_3)
        
        //设置delegate,dataSource
        toStartTableView.delegate = self
        unRatedGameTableView.delegate = self
        finishedGameTableView.delegate = self
        toStartTableView.dataSource = self
        unRatedGameTableView.dataSource = self
        finishedGameTableView.dataSource = self
        
        toStartTableView.emptyDataSetSource = self
        toStartTableView.emptyDataSetDelegate = self
        toStartTableView.tableFooterView = UIView()
        toStartTableView.showsVerticalScrollIndicator = false
        
        unRatedGameTableView.emptyDataSetSource = self
        unRatedGameTableView.emptyDataSetDelegate = self
        unRatedGameTableView.tableFooterView = UIView()
        unRatedGameTableView.showsVerticalScrollIndicator = false
        
        finishedGameTableView.emptyDataSetSource = self
        finishedGameTableView.emptyDataSetDelegate = self
        finishedGameTableView.tableFooterView = UIView()
        finishedGameTableView.showsVerticalScrollIndicator = false

        // 设置左滑和右滑手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(swipeLeft)
        scrollView.addGestureRecognizer(swipeRight)
        
        Cache.userGameCache.setKeysuffix(userID)
        Cache.userGameCache.value = ""
        loadCache()
    }
    
    @IBOutlet weak var oneOnoneButton: UIButton!
    @IBOutlet weak var twoOntwoButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var threeOnthreeButton: UIButton!
    @IBOutlet weak var fiveOnfiveButton: UIButton!
    
    @IBOutlet weak var toStartTableView: UITableView!
    @IBOutlet weak var unRatedGameTableView: UITableView!
    @IBOutlet weak var finishedGameTableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
        }
    }
    //Mark: - Logic
    private func loadCache(){
        if Cache.userGameCache.isEmpty{
            refreshCache()
            return 
        }

        toStartGames.removeAll()
        unRatedGame.removeAll()
        finishedGame.removeAll()
        flags.removeAll()
        unRateUsers.removeAll()
        
        var tempToStartGames : [Game] = []
        var tempUnRatedGames : [Game] = []
        var tempFinishedGames : [Game] = []
        var tempRatedUsers : [RatedUser] = []
        
        let value = Cache.userGameCache.value
        let json = JSON.parse(value)
        let gameArray = json["games"].arrayValue
        for gameJSON in gameArray{
            //parse court
            let courtID = gameJSON["place"]["id"].stringValue
            let courtName = gameJSON["place"]["courtName"].stringValue
            let atCity = gameJSON["place"]["atCity"].stringValue
            
            var imageNumber = 0
            let imageUrlsJSON = gameJSON["place"]["court_image_url"].arrayValue
            var imageUrls : [String] = []
            for imageUrl in imageUrlsJSON{
                imageUrls.append(imageUrl.stringValue)
                imageNumber += 1
            }
            let location = gameJSON["place"]["location"].stringValue
            let longitude = gameJSON["place"]["longitude"].stringValue
            let latitude = gameJSON["place"]["latitude"].stringValue
            let courtRate = gameJSON["place"]["courtRate"].stringValue
            let courtStatus = gameJSON["place"]["status"].stringValue
            
            let court = Court(courtID,
                              courtName,
                              "",
                              imageUrls,
                              location,
                              atCity,
                              courtRate,
                              "",
                              courtStatus,
                              longitude,
                              latitude,
                              "",
                              "",
                              "")
            let isEvaluated = gameJSON["isEvaluated"].intValue
            let game_id = gameJSON["id"].stringValue
            let game_type = gameJSON["game_type"].stringValue
            let game_status = gameJSON["game_status"].stringValue
            let participantNumber = gameJSON["participantNumber"].stringValue
            let started_at = gameJSON["started_at"].stringValue
            let game_rate = gameJSON["game_rate"].stringValue
            let game = Game(game_id,
                            game_type,
                            game_status,
                            started_at,
                            court,
                            participantNumber,
                            game_rate
                            )
            if game_status == "1"{
                flags.append(false)
                tempToStartGames.append(game)
            }else if game_status == "2"{
                ifHavingInGame = true
                ingGame = game
                inGameVCDelegate?.initInGame(ingGame!)
            }else if game_status == "3"{
                if isEvaluated == 0{
                    let userArray = gameJSON["usersBeEvaluated"].arrayValue
                    for userJSON in userArray{
                        let username = userJSON["username"].stringValue
                        let id = userJSON["id"].stringValue
                        let avatar_url = userJSON["avatar_url"].stringValue
                        let position = userJSON["position"].stringValue
                        let user = RatedUser(username,id,avatar_url,position)
                        tempRatedUsers.append(user)
                    }
                    tempUnRatedGames.append(game)
                }else if isEvaluated == 1{
                    tempFinishedGames.append(game)
                }
            }else if game_status == "4"{
                tempFinishedGames.append(game)
            }
        }
        unRateUsers.append(tempRatedUsers)
        toStartGames.append(tempToStartGames)
        unRatedGame.append(tempUnRatedGames)
        finishedGame.append(tempFinishedGames)
        
        toStartTableView.reloadData()
        unRatedGameTableView.reloadData()
        finishedGameTableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.userGameCache.userGameRequest(userID: userID) { 
            self.loadCache()
        }
    }
    
    //Mark: - Action
    @IBAction func refresh(_ sender: Any) {
        refreshCache()
    }
    
    
    @IBAction func tapChanged(_ sender: Any) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        offset = CGFloat(index) * self.view.frame.width
    }
    
    var offset: CGFloat = 0.0 {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.scrollView.contentOffset = CGPoint(x: self.offset, y: 0.0)
            }
        }
    }
    
    func swipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if offset != self.view.frame.width*3{
                offset = offset + self.view.frame.width
                segmented.selectedSegmentIndex = segmented.selectedSegmentIndex + 1
            }else{
                
            }
        }
        else {
            if offset != 0.0{
                offset = offset - self.view.frame.width
                segmented.selectedSegmentIndex = segmented.selectedSegmentIndex - 1
            }else{
                
            }
        }
    }
    
    //Mark : -Deleagte
    
    func callToRefresh() {
        self.refreshCache()
    }
    
    func callToRate(sender cell: UITableViewCell) {
        self.performSegue(withIdentifier: "toRate", sender: cell)
    }
    
    //Mark: - AMapLocationManagerDelegate
    //更新用户位置
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        var count = 0
        let userLocationCoordinate = userLocation.coordinate
        ApiHelper.currentLongitude = userLocation.coordinate.longitude.description
        ApiHelper.currentLatitude = userLocation.coordinate.latitude.description
        let point_2 = MAMapPointForCoordinate(userLocationCoordinate)
        if toStartGames.count != 0{
            for game in toStartGames[0]{
//                print("有未开始的比赛")
                let gameLocation = CLLocationCoordinate2DMake(Double(game.court.latitude)!, Double(game.court.longitude)!)
                let point_1 = MAMapPointForCoordinate(gameLocation)
                let distance = MAMetersBetweenMapPoints(point_1, point_2)
                if distance < 1000 && flags[count] == false{
                    let closureCount = count
                    changeGameStatus(game.gameID, "1" ,completionHandler: {
                        print("到达比赛场地")
                        self.refreshCache()
                        self.flags[closureCount] = true
                    })
                }
                count += 1
            }
        }
        if ifHavingInGame{
            let gameLocation = CLLocationCoordinate2DMake(Double((ingGame?.court.latitude)!)!, Double((ingGame?.court.longitude)!)!)
            let point_1 = MAMapPointForCoordinate(gameLocation)
            let distance = MAMetersBetweenMapPoints(point_1, point_2)
            if distance > 1000 && inGameCourtFlag == false{
//                print("有正进行的比赛")
                changeGameStatus((ingGame?.gameID)!, "2" ,completionHandler: {
                    print("离开比赛场地")
                    self.refreshCache()
                    self.inGameCourtFlag = true
                })
            }
        }
    }
    
    //Mark : -network
    private func changeGameStatus(_ gameID : String, _ status : String,completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        parameters["adminID"] = ApiHelper.currentUser.id
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["arrivalStatus"] = status
        Alamofire.request(ApiHelper.API_Root + "/games/" + gameID + "/status/",
                          method: .put,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response game status ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "状态更新失败")
                                    }
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "您的状态已更新")
                                        completionHandler()
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 201{
            return toStartGames.count
        }else if tableView.tag == 203{
            return unRatedGame.count
        }else if tableView.tag == 204{
            return finishedGame.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 201{
            return toStartGames[section].count
        }else if tableView.tag == 203{
            return unRatedGame[section].count
        }else if tableView.tag == 204{
            return finishedGame[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 201 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "To Start", for: indexPath) as! ToStartTableViewCell
            cell.game = toStartGames[indexPath.section][indexPath.row]
            return cell
        }else if tableView.tag == 203{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnRated", for: indexPath) as! UnRatedGameTableViewCell
            cell.game = unRatedGame[indexPath.section][indexPath.row]
            cell.unRatedUser = unRateUsers[indexPath.section]
            cell.deleagte = self
            return cell
        }else if tableView.tag == 204{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Finished", for: indexPath) as! FinishedTableViewCell
            cell.game = finishedGame[indexPath.section][indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "whatwhat", for: indexPath)
        return cell
    }
    
    //Mark : - DZNEmptyDataSetDelegate
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "logo.png").reSizeImage(reSize: CGSize(width: 100, height: 100))
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    //Mark : - DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var para = ""
        switch scrollView.tag {
        case 201:
            para = "您没有未开始的比赛"
        case 203:
            para = "您没有未评价的比赛"
        case 204:
            para = "您没有未完成的比赛"
        default:
            para = ""
        }
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
        let para = "快去参与比赛吧~"
        let attributedDescription = NSMutableAttributedString.init(string: para)
        let length = (para as NSString).length
        let titleRange = NSRange(location: 0,length: length)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.gray ]
        let boldFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) ]
        attributedDescription.addAttributes(colorAttribute, range: titleRange)
        attributedDescription.addAttributes(boldFontAttribute, range: titleRange)
        return attributedDescription
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "addGame"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.delegate = self
            }
        }
        if segue.identifier == "toInGame"{
            if let inGameVC = destinationViewController as? InGameUIViewController{
                self.inGameVCDelegate = inGameVC
            }
        }
        if segue.identifier == "toRate"{
            if let rateGameVC = destinationViewController as? RateGameTableViewController{
                if let cell = sender as? UnRatedGameTableViewCell{
                    rateGameVC.game = cell.game
                    rateGameVC.unRatedUser = cell.unRatedUser
                }
            }
        }
    }
}

protocol GameTabViewControllerProtocol {
    func callToRefresh()
    func callToRate(sender cell: UITableViewCell)
}
