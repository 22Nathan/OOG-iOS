//
//  CourtTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 14/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class CourtTableViewController: UITableViewController {
    enum courtItem{
        case Title(Court)
        case CourtRate(Court)
        case GameItem(Game)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Cache.courtGameCache.setKeysuffix((court?.id)!)
        Cache.courtGameCache.value = ""
        loadCache()
    }
    
    var court : Court?{
        didSet{
            courtItems.append([courtItem.Title(court!)])
            courtItems.append([courtItem.CourtRate(court!)])
//            Cache.courtGameCache.setKeysuffix((court?.id)!)
//            loadCache()
        }
    }
    //Mark : - Model
    var courtItems : [[courtItem]] = []
    var gameItems : [courtItem] = []
    var gameList : [Game] = []
    
    //Mark : -Logic
    private func loadCache(){
        if Cache.courtGameCache.isEmpty{
            refreshCache()
            return
        }
        let value = Cache.courtGameCache.value
        let json = JSON.parse(value)
        let gamesArray = json["games"].arrayValue
        for gameJSON in gamesArray{
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
                            court!,
                            participantNumber,
                            game_rate)
            gameItems.append(courtItem.GameItem(game))
        }
        courtItems.append(gameItems)
        tableView.reloadData()
    }

    @IBAction func back(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func refreshCache(){
        Cache.courtGameCache.courtGameRequest(courtID: (self.court?.id)!) {
            self.loadCache()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return courtItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courtItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let greyColorAttribute = [ NSForegroundColorAttributeName: UIColor.gray]
        let systemFontAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        var header = UILabel(frame: CGRect(x: 6, y: 6, width: 200, height: 15))
        var para = ""
        switch section {
        case 0:
            break
        case 1:
            para = "球场评分详细信息"
            let attributedText_2 = NSMutableAttributedString.init(string: para)
            var length = (para as NSString).length
            var numberRange = NSRange(location: 0,length: length)
            attributedText_2.addAttributes(greyColorAttribute, range: numberRange)
            attributedText_2.addAttributes(systemFontAttribute, range: numberRange)
            header.attributedText = attributedText_2
        case 2:
            para = "比赛信息"
            let attributedText_2 = NSMutableAttributedString.init(string: para)
            var length = (para as NSString).length
            var numberRange = NSRange(location: 0,length: length)
            attributedText_2.addAttributes(greyColorAttribute, range: numberRange)
            attributedText_2.addAttributes(systemFontAttribute, range: numberRange)
            header.attributedText = attributedText_2
        default:
            header.text = ""
        }
        view.addSubview(header)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 25
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let courtItem = courtItems[indexPath.section][indexPath.row]
        switch courtItem {
        case .Title( _):
            return 84
        case .CourtRate(_):
            return 90
        case .GameItem( _):
            return 87
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courtItem = courtItems[indexPath.section][indexPath.row]
        switch courtItem {
        case .Title(let court):
            let cell = tableView.dequeueReusableCell(withIdentifier: "courtTitle", for: indexPath) as! CourtTitleTableViewCell
            cell.court = court
            return cell
        case .CourtRate(let court):
            let cell = tableView.dequeueReusableCell(withIdentifier: "courtRate", for: indexPath) as! CourtRateTableViewCell
            cell.court = court
            return cell
        case .GameItem(let game):
            let cell = tableView.dequeueReusableCell(withIdentifier: "courtGame", for: indexPath) as! CourtGameTableViewCell
            cell.game = game
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
