//
//  FindGameViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 09/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import JNDropDownMenu
import SVProgressHUD
import SwiftDate
import Alamofire
import SwiftyJSON

class FindGameViewController: UIViewController,JNDropDownMenuDelegate, JNDropDownMenuDataSource,UIPopoverPresentationControllerDelegate,FindGameViewControllerProtocol{
    
    @IBOutlet weak var gameListTableView: UITableView!
    @IBOutlet weak var teamInfoButton: UIButton!
    @IBOutlet weak var siteButton: UIButton!

    var courtName : String?
    var gameTypeIndex : Int = 0
    var gameTimeIndex : Int = 0

    var gameTypeArray = ["1V1" , "2V2" , "3V3" , "5V5" , "Free"]
    var gameTimeArray : [String]{
        get{
            var returnArray : [String] = []
            let nowTime = DateInRegion(absoluteDate: Date(), in: Region.Local())
            var startHour = nowTime.hour + 1
            while(startHour <= 24){
                returnArray.append(makeArrayString(startHour))
                startHour += 1
            }
            return returnArray
        }
    }
    
    func makeArrayString(_ hour : Int) -> String{
        let nowTime = DateInRegion(absoluteDate: Date(), in: Region.Local())
        let templateString = String(nowTime.year) + "年" +
            String(nowTime.month) + "月" +
            String(nowTime.day) + "日" +
            String(hour) + "时"
        return templateString
    }
    
    func setSite(_ courtName: String, _ location: String) {
        self.siteButton.setTitle(courtName, for: UIControlState.normal)
        self.courtName = courtName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial menu
        let menu = JNDropDownMenu(origin: CGPoint(x: 0, y: 64), height: 35, width: self.view.frame.size.width)
        menu.datasource = self
        menu.delegate = self
        menu.arrowPostion = .Left
        
        self.view.addSubview(menu)
    }
    
    @IBAction func createGame(_ sender: Any) {
        var parameters = [String : String]()
        parameters["adminID"] = ApiHelper.currentUser.id
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["courtName"] = self.courtName
        let range = NSRange(location: 0, length: 1)
        parameters["game_type"] =  gameTypeArray[gameTypeIndex].substring(range)
        parameters["started_at"] = gameTimeArray[gameTimeIndex]
        Alamofire.request(ApiHelper.API_Root + "/games/creation/",
                          method: .post,
                            parameters: parameters,
                            encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                            if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response Creation Game###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "创建比赛成功")
                                    }else{
                                        SVProgressHUD.showInfo(withStatus: "你没有权限，请联系队长")
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    //Mark : - Delegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //Mark : - menu source
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 2
    }
    
    func numberOfRows(in column: NSInteger, for forMenu: JNDropDownMenu) -> Int {
        switch column {
        case 0:
            return gameTypeArray.count
        case 1:
            return gameTimeArray.count
        default:
            return 0
        }
    }
    
    func titleForRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) -> String {
        switch indexPath.column {
        case 0:
            return gameTypeArray[indexPath.row]
        case 1:
            return gameTimeArray[indexPath.row]
            
        default:
            return ""
        }
    }
    
    func didSelectRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) {
        switch indexPath.column {
        case 0:
            gameTypeIndex = indexPath.row
            break
        case 1:
            gameTimeIndex = indexPath.row
            break
        default:
            gameTimeIndex = 0
            gameTypeIndex = 0
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "team info"{
            if let vc = destinationViewController as? PopTeamInfoViewController {
                if let ppc = vc.popoverPresentationController{
                    ppc.delegate = self
                    ppc.permittedArrowDirections = .up
                    ppc.sourceView = teamInfoButton.superview
                    ppc.sourceRect = teamInfoButton.frame
                }
            }
        }
        if segue.identifier == "select site"{
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let vc = destinationViewController as? ModalStieInfoViewController{
                vc.delegate = self
            }
        }
    }
}

protocol FindGameViewControllerProtocol {
    func setSite(_ courtID : String , _ loacation : String)
}

