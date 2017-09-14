//
//  DiscoveryViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DiscoveryViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate,UIGestureRecognizerDelegate {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var courtList : [Court] = []
    var annotationList : [MAAnnotation?] = []
    var tempLocation : CLLocationCoordinate2D?
    var selectedAnnotation : MAAnnotation?
    
    var emptyView = UIView()
    let dropDownView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().apiKey = ApiHelper.mapKey
        AMapServices.shared().enableHTTPS = true
        
        let locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView = MAMapView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.showsScale = false
        tempLocation = mapView.userLocation.coordinate
        self.view.addSubview(mapView!)
        let centerLogo = UIButton(frame: CGRect(x: mapView.frame.width/2 - 10, y: mapView.frame.height/2 - 10, width: 20, height: 20))
        centerLogo.setImage(#imageLiteral(resourceName: "like.png"), for: UIControlState.normal)
        mapView.addSubview(centerLogo)
        
        let backToWhereIAmButton = UIButton(frame: CGRect(x: mapView.frame.width/2 - 10, y: mapView.frame.height - 140, width: 20, height: 20))
        backToWhereIAmButton.setImage(#imageLiteral(resourceName: "message.png"), for: UIControlState.normal)
        mapView.addSubview(backToWhereIAmButton)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapEvent(byReactingTo:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        backToWhereIAmButton.addGestureRecognizer(tapRecognizer)
        
        //initSearch
        search = AMapSearchAPI()
        search.delegate = self
//        demoRequest()
        
        //初始定位
        requestCourtsNearBy(coordinate: mapView.centerCoordinate, completionHandler: addAnnotationFromCourt)
    }
    
    
//    func demoRequest(){
//        let request = AMapPOIKeywordsSearchRequest()
//        request.keywords = "篮球场"
//        request.requireExtension = true
//        request.city = "南京"
//        request.cityLimit = true
//        request.requireSubPOIs = true
//        search.aMapPOIKeywordsSearch(request)
//    }
    
//    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
//        
//        if response.count == 0 {
//            return
//        }
//        for add in response.pois{
//            print(add.address)
//            let coordinate = CLLocationCoordinate2DMake(Double(add.location.latitude), Double(add.location.longitude))
//            
//            let annotation = MAPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = add.address
//            annotation.subtitle = add.city
//            mapView!.addAnnotation(annotation)
//        }
//
//        //解析response获取POI信息，具体解析见 Demo
//    }
    
    // 请求后台服务器最近5km的球场信息
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
                                            let court_image_url = courtJson["court_image_url"].stringValue
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
                                                              court_image_url,
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
//        print("删去annotationList")
//        print(annotationList.count)
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
//        print("增加annotationList")
//        print(annotationList.count)
    }
    
    //Mark: - AMapLocationManagerDelegate
    //更新用户位置
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
////        if (location.coordinate.longitude != tempLocation?.longitude) || (location.coordinate.latitude != tempLocation?.latitude){
////            tempLocation = location.coordinate
////            requestCourtsNearBy(coordinate: CLLocationCoordinate2DMake(32.01,118.74), completionHandler: addAnnotationFromCourt)
////        }
//    }
    
    //用户移动中心标时
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        requestCourtsNearBy(coordinate: mapView.centerCoordinate, completionHandler: addAnnotationFromCourt)
    }
    
    
//    //MARK:- MAMapViewDelegate
//    //更新用户位置
//    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
//        if (userLocation.coordinate.longitude != tempLocation?.longitude) || (userLocation.coordinate.latitude != tempLocation?.latitude){
//            tempLocation = userLocation.coordinate
//            requestCourtsNearBy(coordinate: CLLocationCoordinate2DMake(32.01,118.74), completionHandler: addAnnotationFromCourt)
//        }
//    }

    
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let annotationReuseIndetifier = "annotationReuseIndetifier"
//            var annotationView: CustomAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIndetifier) as! CustomAnnotationView?
//            
//            if annotationView == nil {
//                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseIndetifier)
//            }
//            annotationView?.setSelected(true, animated: true)
//            annotationView?.canShowCallout = false
////            annotationView?.centerOffset = CGPoint(x: 0, y: -18)
////            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//            return annotationView!
//        }
//        return nil
//    }
    
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
            annotationView!.image = #imageLiteral(resourceName: "like.png")
            
            //设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView!.centerOffset = CGPoint(x: 0, y: -18);
            return annotationView!
        }
        return nil
    }
    
    //annotation点击事件
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        showDropDownView(view.annotation)
        
    }
    
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

        
        // 设置 播放列表视图 的背景图片、大小、透明度
        dropDownView.backgroundColor = UIColor.white
        dropDownView.frame = CGRect(origin: originDropDownView, size: sizeDropDownView)
        dropDownView.alpha = 1
        
        // 转场动画
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dropDownView.frame.origin = CGPoint(x: 0, y: 64)
        }
        
        //加载控件与数据
        let courtNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        courtNameLabel.text = "text"
        courtNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dropDownView.addSubview(courtNameLabel)
        
        // 加载视图
        emptyView.addSubview(dropDownView)
        self.view.addSubview(emptyView)
    }
    
    func dismissDropDownView(_ sender: UITapGestureRecognizer) {
        popOffDropDownView()
    }
    
    private func popOffDropDownView(){
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
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude+0.4), animated: true)
        }else if gesture.direction == .right{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude-0.4), animated: true)
        }else if gesture.direction == .up{
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude-0.4, mapView.centerCoordinate.longitude), animated: true)
        }else if gesture.direction == .down{
            print("here")
            mapView.setCenter(CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude+0.4, mapView.centerCoordinate.longitude), animated: true)
        }

    }
    
    // tap手势
    func tapEvent(byReactingTo tapRecognizer: UITapGestureRecognizer){
        if tapRecognizer.state == .ended{
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        }
    }
    
    //MARK:- AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
}
