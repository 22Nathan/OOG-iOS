//
//  PopTeamInfoViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 10/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class PopTeamInfoViewController: UIViewController {
    var ifEmpty = false
    var userID : String = ApiHelper.currentUser.id
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 120, height: 80)
        Cache.userTeamCache.setKeysuffix(userID)
        loadCache()
    }
    @IBOutlet weak var showLabel: UILabel!

    func loadCache(){
        if Cache.userTeamCache.isEmpty{
            refreshCache()
            return
        }
        
        let value = Cache.userTeamCache.value
        let json = JSON.parse(value)
        let peopleNumber = json["peopleNumber"].stringValue
        let averageRate = json["averageRate"].stringValue
        showLabel.text = "队伍人数:" + peopleNumber + "\n均分:" + averageRate
    }
    
    func refreshCache(){
        showProgressDialog()
        Cache.userTeamCache.userTeamInfo(userID) { (isEmpty) in
            if isEmpty{
                self.ifEmpty = false
                self.showLabel.text = "您未组队"
            }else{
                self.loadCache()
            }
        }
    }
}
