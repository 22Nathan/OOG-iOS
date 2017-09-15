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
        case GameItem(Game)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var court : Court?{
        didSet{
            courtItems.append([courtItem.Title(court!)])
            Cache.courtGameCache.setKeysuffix((court?.id)!)
            loadCache()
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
    
    private func refreshCache(){
        Cache.courtGameCache.courtGameRequest(courtID: (self.court?.id)!) {
            self.loadCache()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return courtItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courtItems[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courtItem = courtItems[indexPath.section][indexPath.row]
        switch courtItem {
        case .Title(let court):
            let cell = tableView.dequeueReusableCell(withIdentifier: "courtTitle", for: indexPath) as! CourtTitleTableViewCell
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
