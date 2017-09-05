//
//  MovementListTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 04/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MovementListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let profileViewController = sb.instantiateViewController(withIdentifier: "Profile")
//        profileVCDelegate = (profileViewController as! ProfileViewControllerDelegate)
        tableView.isScrollEnabled = false
    }
//    var profileVCDelegate : ProfileViewControllerDelegate?

//    dynamic var tapDistance = NSNumber()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTable", for: indexPath) as! MovementTableViewCell
        cell.testtect.text = "详细动态"
//        tapDistance.setValue(NSNumber(integerLiteral: 10), forKey: "tapDistance")
//        tapDistance.setValue(NSNumber(integerLiteral: 10) , forKey: "tapDistance")
//        profileVCDelegate?.addScrollViewContentSizeY(CGFloat(50))
        return cell
    }
}
