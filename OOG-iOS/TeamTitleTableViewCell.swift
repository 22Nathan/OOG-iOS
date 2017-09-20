//
//  TeamTitleTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyStarRatingView
import SVProgressHUD

class TeamTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNumbersLabel: UILabel!
    @IBOutlet weak var outTeamButton: UIButton!{
        didSet{
            outTeamButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
        }
    }
    @IBOutlet weak var teamRateView: SwiftyStarRatingView!
    
    var teamTitle : TeamTitleModel?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func quitTeamAction(_ sender: Any) {
        quitTeamRequest()
    }
    
    func quitTeamRequest(){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        Alamofire.request(ApiHelper.API_Root + "/users/" + ApiHelper.currentUser.id + "/team/",
                          method: .delete,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response quit Team ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "退出组队失败")
                                    }
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "您已退出组队")
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    private func updateUI(){
        teamNumbersLabel.text = "组队人数: " + (teamTitle?.teamNumber)!
        let value = Float((teamTitle?.teamRate)!)
        teamRateView.value = CGFloat(value!)
    }
}
