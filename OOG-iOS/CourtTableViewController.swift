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
        case GameItem([Game])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var court : Court?{
        didSet{
            Cache.courtGameCache.setKeysuffix((court?.id)!)
            loadCache()
        }
    }
    //Mark : - Model
    var courtItems : [[courtItem]] = []
    
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
            
        }
    }
    
    private func refreshCache(){
        Cache.courtGameCache.courtGameRequest((self.court?.id)!) {
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
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
