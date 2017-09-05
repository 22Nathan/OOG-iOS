//
//  ProfileViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 03/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController ,UIScrollViewDelegate,ProfileViewControllerDelegate {

    //Mark : - LifeCycle
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
        
//        self.addObserver(self, forKeyPath: "tapDistance", options: NSKeyValueObservingOptions.new, context: &self.mycontext)
        updateUI()
    }
    
//    private var mycontext = 0
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if context == &mycontext{
//            print("dsadsadas")
//        }
//    }
//    
//    deinit {
//        removeObserver(self, forKeyPath: "tapDistance")
//    }
    
    //手动设置contentSize
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.scrollView.contentSize = CGSize(width: 375, height: 1000)
    }
    
    //滑动Model
//    var offset: CGFloat = 0.0 {
//        didSet {
//            UIView.animate(withDuration: 0.3) { () -> Void in
//                self.scrollView.contentOffset = CGPoint(x: 0, y: self.offset)
//            }
//        }
//    }

//    var contentSizeY : CGFloat = 0.0{
//        didSet{
//            print(self.scrollView.contentSize)
//            self.scrollView.contentSize = CGSize(width: 375, height: self.scrollView.contentSize.height+contentSizeY)
//        }
//    }
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
    
    func addScrollViewContentSizeY(_ addSizeY: CGFloat) {
//        contentSizeY += addSizeY
    }
    
    
    func changeView(){
        containerView.exchangeSubview(at: 0, withSubviewAt: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }

    private func updateUI(){
        userNameLabel.text = ApiHelper.currentUser.username
    }
}

protocol ProfileViewControllerDelegate {
    func addScrollViewContentSizeY(_ addSizeY : CGFloat)
}
