//
//  GameTabViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameTabViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var userID : String = ApiHelper.currentUser.id
    //Mark : - Model
    var toStartGames : [[Game]] = []
    var ingGame : Game?
    var hasIngGame = false
    var unRatedGame : [[Game]] = []
    var finishedGame : [[Game]] = []
    
    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        item.tintColor = UIColor.black
        self.navigationItem.backBarButtonItem = item
        
        //设置delegate,dataSource
        toStartTableView.delegate = self
        unRatedGameTableView.delegate = self
        finishedGameTableView.delegate = self
        toStartTableView.dataSource = self
        unRatedGameTableView.dataSource = self
        finishedGameTableView.dataSource = self
        
        // 设置左滑和右滑手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(swipeLeft)
        scrollView.addGestureRecognizer(swipeRight)
        
        Cache.userGameCache.setKeysuffix(userID)
        Cache.userGameCache.value = ""
        loadCache()
    }
    
    @IBOutlet weak var oneOnoneButton: UIButton!
    @IBOutlet weak var twoOntwoButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var threeOnthreeButton: UIButton!
    @IBOutlet weak var fiveOnfiveButton: UIButton!
    
    @IBOutlet weak var toStartTableView: UITableView!
    @IBOutlet weak var unRatedGameTableView: UITableView!
    @IBOutlet weak var finishedGameTableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!

    
    //Mark: - Logic
    private func loadCache(){
        if Cache.userGameCache.isEmpty{
            refreshCache()
            return 
        }
        
        hasIngGame = false
        toStartGames.removeAll()
        unRatedGame.removeAll()
        finishedGame.removeAll()
        
        var tempToStartGames : [Game] = []
        var tempUnRatedGames : [Game] = []
        var tempFinishedGames : [Game] = []
        
        let value = Cache.userGameCache.value
        let json = JSON.parse(value)
        let gameArray = json["games"].arrayValue
        for gameJSON in gameArray{
            //parse court
            let courtID = gameJSON["place"]["id"].stringValue
            let courtName = gameJSON["place"]["courtName"].stringValue
            let atCity = gameJSON["place"]["atCity"].stringValue
            
            var imageNumber = 0
            let imageUrlsJSON = gameJSON["place"]["court_image_url"].arrayValue
            var imageUrls : [String] = []
            for imageUrl in imageUrlsJSON{
                imageUrls.append(imageUrl.stringValue)
                imageNumber += 1
            }
            let location = gameJSON["place"]["location"].stringValue
            let longitude = gameJSON["place"]["longitude"].stringValue
            let latitude = gameJSON["place"]["latitude"].stringValue
            let courtRate = gameJSON["place"]["courtRate"].stringValue
            let courtStatus = gameJSON["place"]["status"].stringValue
            
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
                              "",
                              "",
                              "")
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
                            court,
                            participantNumber,
                            game_rate
                            )
            if game_status == "1"{
                tempToStartGames.append(game)
            }else if game_status == "2"{
                hasIngGame = true
                ingGame = game
            }else if game_status == "3"{
                tempUnRatedGames.append(game)
            }else if game_status == "4"{
                tempFinishedGames.append(game)
            }
        }
        if hasIngGame{
            ApiHelper.inGame = ingGame!
        }
        toStartGames.append(tempToStartGames)
        unRatedGame.append(tempUnRatedGames)
        finishedGame.append(tempFinishedGames)
        
        toStartTableView.reloadData()
        unRatedGameTableView.reloadData()
        finishedGameTableView.reloadData()
        hideProgressDialog()
    }
    
    private func refreshCache(){
        showProgressDialog()
        Cache.userGameCache.userGameRequest(userID: userID) { 
            self.loadCache()
        }
    }
    
    
    //Mark: - Action
    @IBAction func tapChanged(_ sender: Any) {
        let index = (sender as! UISegmentedControl).selectedSegmentIndex
        offset = CGFloat(index) * self.view.frame.width
    }
    
    var offset: CGFloat = 0.0 {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.scrollView.contentOffset = CGPoint(x: self.offset, y: 0.0)
            }
        }
    }
    
    func swipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            // 向左滑时展示第二个tableview,同时设置选中的segmented item
            if offset != 0.0{
                offset = offset - self.view.frame.width
                segmented.selectedSegmentIndex = segmented.selectedSegmentIndex - 1
            }else{
                
            }
        }
        else {
            if offset != self.view.frame.width*3{
                offset = offset + self.view.frame.width
                segmented.selectedSegmentIndex = segmented.selectedSegmentIndex + 1
            }else{
                
            }
        }
    }
    
    
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 201{
            return toStartGames.count
        }else if tableView.tag == 203{
            return unRatedGame.count
        }else if tableView.tag == 204{
            return finishedGame.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 201{
            return toStartGames[section].count
        }else if tableView.tag == 203{
            return unRatedGame[section].count
        }else if tableView.tag == 204{
            return finishedGame[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 201 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "To Start", for: indexPath) as! ToStartTableViewCell
            cell.game = toStartGames[indexPath.section][indexPath.row]
            return cell
        }else if tableView.tag == 203{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnRated", for: indexPath) as! UnRatedGameTableViewCell
            cell.game = unRatedGame[indexPath.section][indexPath.row]
            return cell
        }else if tableView.tag == 204{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Finished", for: indexPath) as! FinishedTableViewCell
            cell.game = finishedGame[indexPath.section][indexPath.row]
            return cell
        }
        print("if here")
        let cell = tableView.dequeueReusableCell(withIdentifier: "whatwhat", for: indexPath)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if segue.identifier == "1V1"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.gameTypeArray = ["1V1" , "2V2" , "3V3" , "5V5" , "Free"]
            }
        }
        if segue.identifier == "2V2"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.gameTypeArray = ["2V2" , "1V1" , "3V3" , "5V5" , "Free"]
            }
        }
        if segue.identifier == "Free"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.gameTypeArray = ["Free" , "1V1" , "2V2" , "3V3" , "5V5"]
            }
        }
        if segue.identifier == "3V3"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.gameTypeArray = ["3V3" , "1V1" , "2V2" , "5V5" , "Free"]
            }
        }
        if segue.identifier == "5V5"{
            if let findGameVC = destinationViewController as? FindGameViewController {
                findGameVC.gameTypeArray = ["5V5" , "1V1" , "2V2" , "3V3" , "Free"]
            }
        }
    }

}
