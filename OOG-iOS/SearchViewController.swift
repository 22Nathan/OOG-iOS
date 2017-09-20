//
//  SearchViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 17/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import JNDropDownMenu
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController,UIScrollViewDelegate,JNDropDownMenuDelegate,JNDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    //Mark : - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let underLine = UIView(frame: CGRect(x: 0, y: 94, width: 375, height: 1))
        underLine.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        self.view.addSubview(underLine)
        
        searchBar.placeholder = "搜索球员、球场"
        searchBar.delegate = self
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        let playerMenu = JNDropDownMenu(origin: palyerMenuOrigin, height: 35, width: self.view.frame.size.width)
        playerMenu.datasource = self
        playerMenu.delegate = self
        playerMenu.arrowPostion = .Left
        playerMenu.tag = 401
        scrollView.addSubview(playerMenu)
        
        let courtMenu = JNDropDownMenu(origin: CGPoint(x: self.view.frame.size.width, y: 0), height: 35, width: self.view.frame.size.width)
        courtMenu.datasource = self
        courtMenu.delegate = self
        courtMenu.arrowPostion = .Left
        courtMenu.tag = 402
        scrollView.addSubview(courtMenu)
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tag = 501
        courtTableView.delegate = self
        courtTableView.dataSource = self
        courtTableView.tag = 502
        //default
        searchUserRequest()
    }
    
    //Mark : Model
    var userModels : [[User]] = []
    var courtModels : [[Court]] = []
    var usersValue : JSON?
    var courtsValue : JSON?

    //Mark : -控件
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var courtTableView: UITableView!
    
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 30, y: 0, width: 330, height: 30))
    var palyerMenuOrigin = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var pageControl: UISegmentedControl!{
        didSet{
            pageControl.addTarget(self, action: #selector(pageChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            let scrollViewFrame = scrollView.bounds
            scrollView.contentSize = CGSize(width: scrollViewFrame.size.width * CGFloat(pageControl.numberOfSegments), height: scrollViewFrame.size.height)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.scrollsToTop = false
            scrollView.bounces = false
        }
    }
    
    //Mark : - action
//    func panWhere(byReactingTo panRecgnizer: UIPanGestureRecognizer)
//    {
//        let point : CGPoint = panRecgnizer.translation(in: nil)
//        scrollView.contentOffset = point
//        
//    }
    
    //Mark : -delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedSegmentIndex = page
    }
    
    func pageChanged(_ sender:UISegmentedControl){
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.selectedSegmentIndex)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchUserByName(searchBar.text!)
//    }
    
    var flag = 0
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if flag == 0{
//            flag = 1
        print(searchBar.text!)
            searchUserByName(searchBar.text!)
//        }
    }
    
    //Mark : - networ
    func searchUserRequest(){
        Alamofire.request(ApiHelper.API_Root + "/users/search/",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response user serach ###################")
                                    //                                    print(json)
                                    self.usersValue = json
                                    self.searchCourtRequest(completionHandler: self.completionHandler)
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    func searchUserByName(_ username : String){
        var parameters = [String : String]()
        parameters["username"] = username
        Alamofire.request(ApiHelper.API_Root + "/users/search/",
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response user serach ###################")
                                    //                                    print(json)
                                    self.usersValue = json
                                    self.searchCourtByName(username)
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    func searchCourtByName(_ courtName : String){
        var parameters = [String : String]()
        parameters["courtName"] = courtName
        Alamofire.request(ApiHelper.API_Root + "/courts/search/",
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response court serach ###################")
                                    //                                                                        print(json)
                                    self.courtsValue = json
                                    self.completionHandler()
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    func searchCourtRequest(completionHandler: @escaping () -> ()){
        Alamofire.request(ApiHelper.API_Root + "/courts/search/",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response court serach ###################")
//                                                                        print(json)
                                    self.courtsValue = json
                                    completionHandler()
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    func completionHandler(){
        userModels.removeAll()
        courtModels.removeAll()
        var tempUserList : [User] = []
        //parse users
        let value = self.usersValue
        let userList = value?["users"].arrayValue
        for userJSON in userList!{
            let userID = userJSON["id"].stringValue
            let username = userJSON["username"].stringValue
            let tel = userJSON["tel"].stringValue
            let position = userJSON["position"].stringValue
            let avatar_url = userJSON["avatar_url"].stringValue
            let followings = userJSON["followingNumber"].stringValue
            let followers = userJSON["followedNumber"].stringValue
            let likes = userJSON["likes"].stringValue
            let description = userJSON["description"].stringValue
            let rate = userJSON["userRate"].stringValue
            
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
                            "",
                            rate)
            tempUserList.append(user)
        }
        userModels.append(tempUserList)
        
        let courtValue = self.courtsValue
        var tempCourtList : [Court] = []
        let courtList = courtValue?["courts"].arrayValue
        for courtJSON in courtList!{
            let courtID = courtJSON["id"].stringValue
            let courtName = courtJSON["courtName"].stringValue
            let courtType = courtJSON["courtType"].stringValue
            
            var imageNumber = 0
            let imageUrlsJSON = courtJSON["court_image_url"].arrayValue
            var imageUrls : [String] = []
            for imageUrl in imageUrlsJSON{
                imageUrls.append(imageUrl.stringValue)
                imageNumber += 1
            }
            let court_image_url = courtJSON["court_image_url"].stringValue
            let location = courtJSON["location"].stringValue
            let atCity = courtJSON["atCity"].stringValue
            let rate = courtJSON["courtRate"].stringValue
            let game_now_url = courtJSON["game_now_url"].stringValue
            let status = courtJSON["status"].stringValue
            let longitude = courtJSON["longitude"].stringValue
            let latitude = courtJSON["latitude"].stringValue
            let tel = courtJSON["tel"].stringValue
            let priceRate = courtJSON["priceRate"].stringValue
            let transportRate = courtJSON["transportRate"].stringValue
            let facilityRate = courtJSON["facilityRate"].stringValue
            let court = Court(courtID,
                              courtName,
                              courtType,
                              imageUrls,
                              location,
                              atCity,
                              rate,
                              game_now_url,
                              status,
                              longitude,
                              latitude,
                              priceRate,
                              transportRate,
                              facilityRate,
                              tel)
            tempCourtList.append(court)
        }
        courtModels.append(tempCourtList)
        self.userTableView.reloadData()
        self.courtTableView.reloadData()
    }
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 501{
            return userModels.count
        }else{
            return courtModels.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 501{
            return userModels[section].count
        }else{
            return courtModels[section].count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 501{
            return 80
        }else{
            return 88
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusedID: String!
        if tableView.tag == 501 {
            reusedID = "search user"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! UserListTableViewCell
            cell.user = userModels[indexPath.section][indexPath.row]
            return cell
        }
        else{
            reusedID = "search court"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! CourtListTableViewCell
            cell.court = courtModels[indexPath.section][indexPath.row]
            return cell
        }
    }
    //Mark : -- menu var source
    var userOrderIndex : Int = 0
    var userPositionIndex : Int = 0
    var userInfoIndex : Int = 0
    
    var userInfoArray = ["不限","身高最高","体重最高"]
    var userOrderArray = ["智能排序" , "总评分最高" , "技术评分最高" , "身体评分最高" , "球商评分最高"]
    var userPositionArray = ["不限","控球后卫","得分后卫","小前锋","大前锋","中锋"]
    var courtOrderIndex : Int = 0
    var courtWhatIndex : Int = 0
    var courtInfoIndex : Int = 0
    var courtInfoArray = ["不限","水泥地","塑胶地","木地板"]
    var courtOrderArray = ["智能排序" , "总评分最高" , "价格评分最高" , "设施评分最高" , "球商分最高"]
    var courtWhatArray = ["不限","距离最近","价格最低","比赛最多"]
    
    //Mark : - menu source
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 3
    }
    func numberOfRows(in column: NSInteger, for forMenu: JNDropDownMenu) -> Int {
        if forMenu.tag == 401{
            switch column {
            case 0:
                return userInfoArray.count
            case 1:
                return userPositionArray.count
            case 2:
                return userOrderArray.count
            default:
                return 0
            }
        }else if forMenu.tag == 402{
            switch column {
            case 0:
                return courtWhatArray.count
            case 1:
                return courtInfoArray.count
            case 2:
                return courtOrderArray.count
            default:
                return 0
            }
        }
        return 0
    }
    func titleForRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) -> String {
        if forMenu.frame.origin == palyerMenuOrigin{
            switch indexPath.column {
            case 0:
                return userInfoArray[indexPath.row]
            case 1:
                return userPositionArray[indexPath.row]
            case 2:
                return userOrderArray[indexPath.row]
            default:
                return ""
            }
        }else{
            switch indexPath.column {
            case 0:
                return courtWhatArray[indexPath.row]
            case 1:
                return courtInfoArray[indexPath.row]
            case 2:
                return courtOrderArray[indexPath.row]
            default:
                return ""
            }
        }
        return ""
    }
    func didSelectRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) {
        if forMenu.tag == 401{
            switch indexPath.column {
            case 0:
                userInfoIndex = indexPath.row
                break
            case 1:
                userPositionIndex = indexPath.row
                break
            case 2:
                userOrderIndex = indexPath.row
            default:
                userInfoIndex = 0
                userPositionIndex = 0
                userOrderIndex = 0
            }
        }else if forMenu.tag == 402{
            switch indexPath.column {
            case 0:
                courtWhatIndex = indexPath.row
                break
            case 1:
                courtInfoIndex = indexPath.row
                break
            case 2:
                courtOrderIndex = indexPath.row
            default:
                courtWhatIndex = 0
                courtInfoIndex = 0
                courtOrderIndex = 0
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "userDetailFromSearch"{
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let userVC = destinationViewController as? UserTableViewController{
                if let cell = sender as? UserListTableViewCell{
                    userVC.user = cell.user
                    userVC.navigationItem.title = cell.user?.username
//                    userVC.followList = cell.listType!
                }
            }
        }
        if segue.identifier == "courtDetailFromSearch"{
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let courtVC = destinationViewController as? CourtTableViewController{
                if let cell = sender as? CourtListTableViewCell{
                    courtVC.court = cell.court
                    courtVC.navigationItem.title = cell.court?.courtName
                }
            }
        }
    }
}
