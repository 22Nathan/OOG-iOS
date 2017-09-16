//
//  ChangeInfoTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ChangeInfoTableViewController: UITableViewController {
    
    enum ChangeInfoItem{
        case image(String)
        case basic(String)
        case description(String)
    }
    
    //Mark : LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadCache(){
        let username = ApiHelper.currentUser.username
        let avatar_url = ApiHelper.currentUser.avatar_url
        let gender = ApiHelper.currentUser.gender
        let position = ApiHelper.currentUser.position
        let height = ApiHelper.currentUser.height
        let weight = ApiHelper.currentUser.weight
        
    }
    
    //Mark : Model
    var changeInfoItem : [[ChangeInfoItem]] = []

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return changeInfoItem.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changeInfoItem[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
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
