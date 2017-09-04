//
//  ProfileViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 03/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController ,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let myTableViewController = sb.instantiateViewController(withIdentifier: "myTable")
        let myCollectionViewController = sb.instantiateViewController(withIdentifier: "myCollection")
        myTableViewController.view.tag = 100
        myCollectionViewController.view.tag = 200
        containerView.addSubview(myTableViewController.view)
        containerView.addSubview(myCollectionViewController.view)
        addChildViewController(myTableViewController)
        addChildViewController(myCollectionViewController)
        displayButton.addTarget(self, action: #selector(changeView), for: .touchDown)
        DetailButton.addTarget(self, action: #selector(changeView), for: .touchDown)
        updateUI()
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
    
    func changeView(){
        containerView.exchangeSubview(at: 0, withSubviewAt: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if(scrollView.tag == 22){
            print("tableview在化")
        }else if scrollView.tag == 50{
            print("scrollView在化")
        }
    }

    private func updateUI(){
        userNameLabel.text = ApiHelper.currentUser.username
    }
}
