//
//  ProfileViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 03/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController ,UIScrollViewDelegate {

    //Mark : - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ScrollView
        scrollView.decelerationRate = 0
//        self.scrollView.showsVerticalScrollIndicator = false
        
        //Notification
        let notificationName = "onTop"
        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollStatus), name: NSNotification.Name(rawValue: notificationName), object: nil)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let myTableViewController = sb.instantiateViewController(withIdentifier: "myTable")
        
        delegate = myTableViewController as? MovementListTableViewControllerDelegate
        
        let myCollectionViewController = sb.instantiateViewController(withIdentifier: "myCollection")
        myTableViewController.view.tag = 100
        myCollectionViewController.view.tag = 200
        
        containerView.addSubview(myTableViewController.view)
        containerView.addSubview(myCollectionViewController.view)
        addChildViewController(myTableViewController)
        addChildViewController(myCollectionViewController)
        displayButton.addTarget(self, action: #selector(changeView), for: .touchDown)
        DetailButton.addTarget(self, action: #selector(changeView), for: .touchDown)
        delegate?.changeScrollEnabled(false)
        
        updateUI()
    }
    
    var delegate : MovementListTableViewControllerDelegate?
    
    func changeScrollStatus(){
        print("收到通知思密达")
        mainCanScroll = true
        containerCanScroll = false
    }

    //手动设置contentSize
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.scrollView.contentSize = CGSize(width: 375, height: 1000)
    }

    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var DetailButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = CGSize(width: 375, height: 1000)
            scrollView.delegate = self
        }
    }
    
    var mainCanScroll = true
    var containerCanScroll = false
    
    func changeView(){
        containerView.exchangeSubview(at: 0, withSubviewAt: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(scrollView.contentOffset.y >= 199){
//            scrollView.contentOffset.y = 199
//            if self.mainCanScroll{
//                self.mainCanScroll = false
//                self.containerCanScroll = true
//                delegate?.changeScrollEnabled(true)
//            }
//        }else{
//            if self.containerCanScroll{
//                self.mainCanScroll = true
//                self.containerCanScroll = false
//                delegate?.changeScrollEnabled(false)
//            }
//        }
        if(scrollView.contentOffset.y >= 199){
            scrollView.contentOffset.y = 199
            if self.mainCanScroll{
                self.mainCanScroll = false
                self.containerCanScroll = true
                delegate?.changeScrollEnabled(true)
            }
        }else{
            if !self.mainCanScroll{
                self.scrollView.contentOffset.y = 199
            }
        }
        self.scrollView.showsVerticalScrollIndicator = mainCanScroll
    }
    
    private func updateUI(){
        userNameLabel.text = ApiHelper.currentUser.username
    }
}

