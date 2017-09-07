//
//  MovementListTableViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 04/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MovementListTableViewController: UITableViewController,MovementListTableViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.decelerationRate = 0
    }
    
    var containerCanScroll = false
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.containerCanScroll{
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
        if (self.tableView.contentOffset.y <= 0){
            self.containerCanScroll = false
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "onTop"), object: nil)
        }
        self.tableView.showsVerticalScrollIndicator = containerCanScroll
    }
    
    func changeScrollEnabled(_ value: Bool) {
//        if(value == true){
//            print("true")
//        }else{
//            print("false")
//        }
        containerCanScroll = value
//        synchronized(self) {
//            self.tableView.isScrollEnabled = value
//            self.tableView.isUserInteractionEnabled = value
//        }
    }
    
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
        return cell
    }
}

protocol MovementListTableViewControllerDelegate {
    func changeScrollEnabled(_ value : Bool)
}
