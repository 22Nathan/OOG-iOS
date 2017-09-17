//
//  ModalStieInfoViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 10/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ModalStieInfoViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate,UIGestureRecognizerDelegate {
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var courtList : [Court] = []
    var annotationList : [MAAnnotation?] = []
    var selectedAnnotation : MAAnnotation?
    var selectedCourt : Court? //点击发请求后才获得
    var displayedGame : Game?  //点击发请求后才获得
    var ifHaveDisplayedGame = false
    var tempLocation : CLLocationCoordinate2D?
    
    var delegate : FindGameViewControllerProtocol?
    
    var emptyView = UIView()
    let dropDownView = UIView()
    
    var noGmaeLabel = UILabel()
    var gameTimeLabel = UILabel()
    var gameTypeLabel = UILabel()
    var gameRateLabel = UILabel()
    var joinGameButton = UIButton()
    var moreButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().apiKey = ApiHelper.mapKey
        AMapServices.shared().enableHTTPS = true
        
        mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.showsScale = false
        
        tempLocation = mapView.userLocation.coordinate
        
        self.view.addSubview(mapView!)
        let centerLogo = UIButton(frame: CGRect(x: mapView.frame.width/2 - 10, y: mapView.frame.height/2 - 10, width: 20, height: 20))
        centerLogo.setImage(#imageLiteral(resourceName: "tab_game_selected"), for: UIControlState.normal)
        mapView.addSubview(centerLogo)
        
        let backToWhereIAmButton = UIButton(frame: CGRect(x: mapView.frame.width/2 - 10, y: mapView.frame.height - 40, width: 20, height: 20))
        backToWhereIAmButton.setImage(#imageLiteral(resourceName: "tab_home_selected"), for: UIControlState.normal)
        mapView.addSubview(backToWhereIAmButton)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapEvent(byReactingTo:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        backToWhereIAmButton.addGestureRecognizer(tapRecognizer)
        
        //initSearch
        search = AMapSearchAPI()
        search.delegate = self
        
        //初始定位
        requestCourtsNearBy(coordinate: mapView.centerCoordinate, completionHandler: addAnnotationFromCourt)    }
    
    //Mark : - RequestCourt
    private func requestCourtInfo(_ courtID : String , annotation : MAAnnotation,completionHandler: @escaping (_ annotation: MAAnnotation) -> ()){
        Alamofire.request(ApiHelper.API_Root + "/courts/" + courtID + "/",
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response Court Info ###################")
                                    //                                    print(json)
                                    let courtID = json["id"].stringValue
                                    let courtName = json["courtName"].stringValue
                                    let atCity = json["atCity"].stringValue
                                    
                                    var imageNumber = 0
                                    let imageUrlsJSON = json["court_image_url"].arrayValue
                                    var imageUrls : [String] = []
                                    for imageUrl in imageUrlsJSON{
                                        imageUrls.append(imageUrl.stringValue)
                                        imageNumber += 1
                                    }
                                    let location = json["location"].stringValue
                                    let longitude = json["longitude"].stringValue
                                    let latitude = json["latitude"].stringValue
                                    let courtRate = json["courtRate"].stringValue
                                    let courtStatus = json["status"].stringValue
                                    let priceRate = json["priceRate"].stringValue
                                    let transportRate = json["transportRate"].stringValue
                                    let facilityRate = json["facilityRate"].stringValue
                                    let status = json["status"].stringValue
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
                                                      priceRate,
                                                      transportRate,
                                                      facilityRate)
                                    self.selectedCourt = court
                                    if status != "1"{
                                        //parse displayedGame
                                        self.ifHaveDisplayedGame = true
                                        let game_id = json["displayedGame"]["id"].stringValue
                                        let game_rate = json["displayedGame"]["game_rate"].stringValue
                                        let game_type = json["displayedGame"]["game_type"].stringValue
                                        let game_status = json["displayedGame"]["game_status"].stringValue
                                        let participantNumber = json["displayedGame"]["participantNumber"].stringValue
                                        let started_at = json["displayedGame"]["started_at"].stringValue
                                        let game = Game(game_id,
                                                        game_type,
                                                        game_status,
                                                        started_at,
                                                        court,
                                                        participantNumber,
                                                        game_rate)
                                        self.displayedGame = game
                                    }
                                }
                                completionHandler(annotation)
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    func requestCourtsNearBy(coordinate: CLLocationCoordinate2D!,completionHandler: @escaping () -> ()){
        var parameters = [String : String]()
        let longitude = CGFloat(coordinate.longitude)
        let latitude = CGFloat(coordinate.latitude)
        parameters["longitude"] = String(describing: longitude)
        parameters["latitude"] = String(describing: latitude)
        parameters["atCity"] = "南京"
        Alamofire.request(ApiHelper.API_Root + "/courts/nearby/",
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response courts ###################")
                                    //                                    print(json)
                                    if json["result"].exists(){
                                        if json["result"] == "No service in your city"{
                                            SVProgressHUD.showInfo(withStatus: "您所在城市未开放服务")
                                        }
                                        self.courtList.removeAll()
                                        completionHandler()
                                    }else{
                                        //清空之前记录
                                        self.courtList.removeAll()
                                        let courts = json["courts"].arrayValue
                                        for courtJson in courts{
                                            let courtID = courtJson["id"].stringValue
                                            let courtName = courtJson["courtName"].stringValue
                                            let courtType = courtJson["courtType"].stringValue
                                            
                                            var imageNumber = 0
                                            let imageUrlsJSON = courtJson["court_image_url"].arrayValue
                                            var imageUrls : [String] = []
                                            for imageUrl in imageUrlsJSON{
                                                imageUrls.append(imageUrl.stringValue)
                                                imageNumber += 1
                                            }
                                            
                                            let location = courtJson["location"].stringValue
                                            let atCity = courtJson["atCity"].stringValue
                                            let rate = courtJson["rate"].stringValue
                                            let game_now_url = courtJson["game_now_url"].stringValue
                                            let status = courtJson["status"].stringValue
                                            let longitude = courtJson["longitude"].stringValue
                                            let latitude = courtJson["latitude"].stringValue
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
                                                              latitude)
                                            self.courtList.append(court)
                                            completionHandler()
                                        }
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }

    // 回调函数 更新Annotation
    func addAnnotationFromCourt(){
        for annotation in self.annotationList{
            self.mapView!.removeAnnotation(annotation)
        }
        annotationList.removeAll()
        
        for court in courtList{
            let annotation = MAPointAnnotation()
            annotationList.append(annotation)
            annotation.coordinate = CLLocationCoordinate2DMake(Double(court.latitude)!, Double(court.longitude)!)
            annotation.title = court.courtName
            annotation.subtitle = court.location
            mapView!.addAnnotation(annotation)
        }
    }
    
    //用户移动中心标时
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        requestCourtsNearBy(coordinate: mapView.centerCoordinate, completionHandler: addAnnotationFromCourt)
    }
    
    //弹出的callout
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView!.canShowCallout = true
            annotationView?.isDraggable = false
            annotationView!.image = #imageLiteral(resourceName: "tab_game_selected")
            
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x: 0, y: -18);
            return annotationView!
        }
        return nil
    }
    
    //annotation点击事件
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        let annotation = view.annotation
        var courtID = ""
        for court in courtList{
            if court.courtName == annotation?.title{
                courtID = court.id
            }
        }
        requestCourtInfo(courtID, annotation: annotation!, completionHandler: showDropDownView)
    }
    
    // 下弹视图
    func showDropDownView(_ annotation: MAAnnotation!) {
        mapView.setZoomLevel(mapView.zoomLevel*1.1, animated: true)
        selectedAnnotation = annotation
        // 定义下弹视图的位置和大小
        let originDropDownView = CGPoint(x: 0, y: -36)
        let sizeDropDownView = CGSize(width: 375, height: 100)
        
        // 定义手势动作并关联手势触发的行为
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissDropDownView(_:)))
        
        //滑动手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        
        // 手势需要遵循的代理：UIGestureRecognizerDelegate
        tapGestureRecognizer.delegate = self
        
        // 设置空视图的大小，打开交互，添加手势
        emptyView.frame = self.view.frame
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(tapGestureRecognizer)
        emptyView.addGestureRecognizer(swipeLeft)
        emptyView.addGestureRecognizer(swipeRight)
        emptyView.addGestureRecognizer(swipeDown)
        emptyView.addGestureRecognizer(swipeUp)
        
        dropDownView.backgroundColor = UIColor.white
        dropDownView.frame = CGRect(origin: originDropDownView, size: sizeDropDownView)
        dropDownView.alpha = 1
        
        // 转场动画
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dropDownView.frame.origin = CGPoint(x: 0, y: 64)
        }
        
        //加载控件与数据
        if !ifHaveDisplayedGame{
            noGmaeLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 375, height: 40))
            noGmaeLabel.text = "当前球场没有比赛,去看看其他球场吧~"
            noGmaeLabel.textAlignment = .center
            noGmaeLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            moreButton = UIButton(frame: CGRect(x: 0, y: 50, width: 375, height: 25))
            moreButton.backgroundColor = UIColor.flatBlue
            moreButton.titleLabel?.textAlignment = .center
            moreButton.setTitle("查看更多", for: UIControlState.normal)
            moreButton.addTarget(self, action: #selector(seeMore), for: UIControlEvents.touchDown)
            
            dropDownView.addSubview(noGmaeLabel)
            dropDownView.addSubview(moreButton)
        }else{
            gameTypeLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 125, height: 40))
            gameTypeLabel.textAlignment = .center
            gameTypeLabel.numberOfLines = 0
            gameTypeLabel.text = convertNumberToDisplayedGameType((displayedGame?.game_type)!) + "\n比赛类型"
            gameTypeLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            gameRateLabel = UILabel(frame: CGRect(x: 125, y: 5, width: 125, height: 40))
            gameRateLabel.text = (displayedGame?.game_rate)! + "\n参赛者平均分"
            gameRateLabel.textAlignment = .center
            gameRateLabel.numberOfLines = 0
            gameRateLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            gameTimeLabel = UILabel(frame: CGRect(x: 250, y: 5, width: 125, height: 40))
            let nsString = (displayedGame?.started_at)! as NSString
            let range = NSRange(location: 7, length: nsString.length)
            let displayedTime = (displayedGame?.started_at)!.substring(range)
            gameTimeLabel.text = displayedTime + "\n比赛开始时间"
            gameTimeLabel.textAlignment = .center
            gameTimeLabel.numberOfLines = 0
            gameTimeLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            joinGameButton = UIButton(frame: CGRect(x: 0, y: 50, width: 375, height: 23))
            joinGameButton.backgroundColor = UIColor.flatBlue
            joinGameButton.titleLabel?.textAlignment = .center
            joinGameButton.setTitle("加入比赛", for: UIControlState.normal)
            joinGameButton.addTarget(self, action: #selector(joinGame), for: UIControlEvents.touchDown)
            
            moreButton = UIButton(frame: CGRect(x: 0, y: 75, width: 375, height: 23))
            moreButton.backgroundColor = UIColor.flatBlue
            moreButton.titleLabel?.textAlignment = .center
            moreButton.setTitle("查看更多", for: UIControlState.normal)
            moreButton.addTarget(self, action: #selector(seeMore), for: UIControlEvents.touchDown)
            
            dropDownView.addSubview(gameTypeLabel)
            dropDownView.addSubview(gameRateLabel)
            dropDownView.addSubview(gameTimeLabel)
            dropDownView.addSubview(joinGameButton)
            dropDownView.addSubview(moreButton)
        }
        ifHaveDisplayedGame = false
        
        // 加载视图
        emptyView.addSubview(dropDownView)
        self.view.addSubview(emptyView)
    }
    
    func dismissDropDownView(_ sender: UITapGestureRecognizer) {
        popOffDropDownView()
    }
    
    //下弹视图收回
    private func popOffDropDownView(){
        noGmaeLabel.removeFromSuperview()
        gameTypeLabel.removeFromSuperview()
        gameTimeLabel.removeFromSuperview()
        gameRateLabel.removeFromSuperview()
        moreButton.removeFromSuperview()
        joinGameButton.removeFromSuperview()
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dropDownView.frame.origin = CGPoint(x: 0, y: -36)
        }
        mapView.setZoomLevel(mapView.zoomLevel/1.1, animated: true)
        let seconds = 0.3
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
        mapView.deselectAnnotation(selectedAnnotation, animated: false)
    }
    
    //延时操作，等待下弹视图转场动画结束
    func timeChanged(){
        emptyView.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: emptyView)
        // 如果touchPoint在播放列表的视图范围内，则不响应手势
        if dropDownView.frame.contains(touchPoint) {
            return false
        } else {
            return true
        }
    }    
    //滑动手势
    func swipe(gesture: UISwipeGestureRecognizer) {
        popOffDropDownView()
        if gesture.direction == .left{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude+0.1), animated: true)
        }else if gesture.direction == .right{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude-0.1), animated: true)
        }else if gesture.direction == .up{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude-0.1, mapView.centerCoordinate.longitude), animated: true)
        }else if gesture.direction == .down{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude+0.1, mapView.centerCoordinate.longitude), animated: true)
        }
        
    }
    
    // tap手势
    func tapEvent(byReactingTo tapRecognizer: UITapGestureRecognizer){
        if tapRecognizer.state == .ended{
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
    }
    
    func joinGame(){
        //        print("funck")
    }
    
    func seeMore(){
        performSegue(withIdentifier: "seeMoreModal", sender: self)
    }
    
    //MARK:- AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }

    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func doneSelect(_ sender: Any) {
        if selectedAnnotation != nil{
            delegate?.setSite((selectedAnnotation?.title)! , (selectedAnnotation?.subtitle)!)
            presentingViewController?.dismiss(animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus: "您未选择球场")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "seeMoreModal"{
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let courtVC = destinationViewController as? CourtTableViewController{
                courtVC.court = selectedCourt
                courtVC.navigationItem.title = selectedCourt?.courtName
            }
        }
    }
    
}
