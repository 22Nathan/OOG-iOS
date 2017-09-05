//
//  GameTabViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class GameTabViewController: UIViewController,UITableViewDataSource {

    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toStartTableView.dataSource = self
        
        
        // 设置左滑和右滑手势
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        
        scrollView.addGestureRecognizer(swipeLeft)
        scrollView.addGestureRecognizer(swipeRight)
    }
    
    @IBOutlet weak var oneOnoneButton: UIButton!
    @IBOutlet weak var twoOntwoButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var threeOnthreeButton: UIButton!
    @IBOutlet weak var fiveOnfiveButton: UIButton!
    @IBOutlet weak var toStartTableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
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
            offset = self.view.frame.width
            segmented.selectedSegmentIndex = 1
        }
        else {
            offset = 0.0
            segmented.selectedSegmentIndex = 0
        }
    }
    
    
    
    //Mark : - tableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusedID: String!
        if tableView.tag == 201 {
            reusedID = "To start"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath)
            cell.textLabel?.text = "dsadasdsa"
            return cell
        }
        else{
            reusedID = "To start"
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath)
            cell.textLabel?.text = "dsadasdsa"
            return cell
        }
    }

}
