//
//  ToStartTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ToStartTableViewCell: UITableViewCell {
    @IBOutlet weak var courtImage: UIImageView!
    @IBOutlet weak var courtLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var courtNameLabel: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var quitGameButton: UIButton!{
        didSet{
            quitGameButton.backgroundColor = UIColor(red: 56/255.0, green: 151/255.0, blue: 239/255.0, alpha: 1.0)
            quitGameButton.contentMode = UIViewContentMode.scaleAspectFit
            quitGameButton.layer.masksToBounds = true
            quitGameButton.clipsToBounds = true
            quitGameButton.layer.cornerRadius = 6
        }
    }
    var game : Game?{
        didSet{
            updateUI()
        }
    }
    
    @IBAction func quitGameAcion(_ sender: Any) {
        quitGameRequest((game?.gameID)!)
    }
    
    func quitGameRequest(_ gameID : String){
        var parameters = [String : String]()
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["adminID"] = ApiHelper.currentUser.id
        Alamofire.request(ApiHelper.API_Root + "/games/" + gameID + "/quit/",
                          method: .delete,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print("################### Response quit Game ###################")
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "退出比赛失败")
                                    }
                                    if result == "ok"{
                                        SVProgressHUD.showInfo(withStatus: "您已退出比赛")
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
    }
    
    private func updateUI(){
//        courtImage.layer.masksToBounds = true
//        courtImage.clipsToBounds = true
//        courtImage.layer.cornerRadius = 48.0
        courtImage.contentMode = UIViewContentMode.scaleAspectFit
        let profileImageKey = "CourtImageKey" + (game?.court.id)!
        if let imageData = Cache.imageCache.data(forKey: profileImageKey){
            courtImage.image = UIImage(data: imageData)?.reSizeImage(reSize: CGSize(width: 90, height: 80))
        }else{
            if let imageUrl = URL(string: (game?.court.court_image_url[0])!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(profileImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.courtImage.image = UIImage(data: imageData)?.reSizeImage(reSize: CGSize(width: 80, height: 80))
                        }
                    }
                }
            }else{
                courtImage.image = nil
            }
        }
        
        courtNameLabel.text = game?.court.courtName
        
        let NStime = ((game?.started_at)!) as NSString
        let length = NStime.length
        let range = NSRange(location: 5, length: length)
        let displayedTime = ((game?.started_at)!).substring(range)
        
        startTimeLabel.text = "预计" + displayedTime + "开始"
        
        gameTypeLabel.text = convertNumberToDisplayedGameType((game?.game_type)!)
        courtLocationLabel.text = game?.court.location

    }
}
