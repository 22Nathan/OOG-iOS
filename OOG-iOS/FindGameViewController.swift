//
//  FindGameViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 09/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import PanelKit
import JNDropDownMenu
import SVProgressHUD
import SwiftDate

class FindGameViewController: UIViewController,JNDropDownMenuDelegate, JNDropDownMenuDataSource,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var gameListTableView: UITableView!
    @IBOutlet weak var teamInfoButton: UIButton!
    @IBOutlet weak var siteButton: UIButton!

    var gameTypeArray = ["1V1" , "2V2" , "3V3" , "5V5" , "Free"]
    var gameTimeArray : [String]{
        get{
            var returnArray : [String] = []
            let nowTime = DateInRegion(absoluteDate: Date(), in: Region.Local())
            var startHour = nowTime.hour
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial menu
        let menu = JNDropDownMenu(origin: CGPoint(x: 0, y: 64), height: 35, width: self.view.frame.size.width)
        menu.datasource = self
        menu.delegate = self
        menu.arrowPostion = .Left
        
        self.view.addSubview(menu)
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
        var str = ""
        switch indexPath.column {
        case 0:
            str = gameTypeArray[indexPath.row]
            break
        case 1:
            str = gameTimeArray[indexPath.row]
            break
        default:
            str = ""
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
    }
}

