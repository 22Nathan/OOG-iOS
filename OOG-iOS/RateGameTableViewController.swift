//
//  RateGameTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class RateGameTableViewController: UITableViewController,RateGameTableViewControllerProtocol {
    //Mark : - Delegate
    func gameValueChanged(_ priceValue: String, _ faciltyValue: String, _ transportValue: String) {
        commitCourtData = (game?.court.id)! + priceValue + faciltyValue + transportValue
    }
    
    func userValueChanged(_ userNumber: Int, _ userID: String, _ techValue: String, _ physicalValue: String, _ BQValue: String) {
        commitUserData[userNumber] = userID + techValue + physicalValue + BQValue
    }
    
    func commitRate() {
        print(commitCourtData)
        for what in commitUserData{
            print(what)
        }
        var parameters = [String : String]()
        parameters["adminID"] = ApiHelper.currentUser.id
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["courtEvaluation"] = commitCourtData
        var count = 0
        for userData in commitUserData{
            if count == 0{
                parameters["userEvaluation"] = userData
            }else{
                parameters["userEvaluation"] = parameters["userEvaluation"]! + "," + userData
            }
            count += 1
        }
        parameters["userNumber"] = String(commitUserData.count)
        Alamofire.request(ApiHelper.API_Root + "/games/" + (game?.gameID)! + "/evaluation/",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response rate ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "操作失败")
                                    }
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "评分成功")
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
        presentedViewController?.dismiss(animated: true)
    }
    
    enum rateItem{
        case RateCourt(Court)
        case RateUser(RatedUser)
        case Commit(String)
    }
    //Mark : - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
    }
    //Mark : - commit
    var numberOfRateUser : Int = 0{
        didSet{
            //清除提交的用户的数据
            commitUserData.removeAll()
            for _ in 0..<numberOfRateUser{
                commitUserData.append("")
            }
        }
    }
    var commitUserData : [String] = []{
        didSet{
            
        }
    }
    var commitCourtData : String = ""

    //Mark: - Model
    var rateItems : [[rateItem]] = []
    var game : Game?
    var unRatedUser : [RatedUser] = []{
        didSet{
            rateItems.removeAll()
            numberOfRateUser = unRatedUser.count
            
            let ratedCourt = rateItem.RateCourt((game?.court)!)
            rateItems.append([ratedCourt])
            
            var tempUserItems : [rateItem] = []
            for user in unRatedUser{
                let userItem = rateItem.RateUser(user)
                tempUserItems.append(userItem)
            }
            rateItems.append(tempUserItems)
            
            let string = rateItem.Commit("alallala")
            rateItems.append([string])
            
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rateItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = rateItems[indexPath.section][indexPath.row]
        switch item{
        case .RateCourt( _):
            return 173
        case .RateUser( _):
            return 174
        case .Commit( _):
            return 41
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rateItems[indexPath.section][indexPath.row]
        switch item {
        case .RateCourt(let court):
            let cell = tableView.dequeueReusableCell(withIdentifier: "rate court", for: indexPath) as! RateCourtTableViewCell
            cell.court = court
            cell.delegate = self
            return cell
        case .RateUser(let user) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "rate user", for: indexPath) as! RateUserTableViewCell
            cell.rateUser = user
            cell.userNumber = indexPath.row
            cell.delegate = self
            return cell
        case .Commit(let what):
            let cell = tableView.dequeueReusableCell(withIdentifier: "commit", for: indexPath) as! RateCommitTableViewCell
            cell.buttonText = what
            cell.delegate = self
            return cell
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

protocol RateGameTableViewControllerProtocol {
    func gameValueChanged(_ priceValue : String ,_ faciltyValue : String , _ transportValue : String )
    func userValueChanged(_ userNumber : Int, _ userID : String , _ techValue : String , _ physicalValue : String, _ BQValue : String)
    func commitRate()
}
