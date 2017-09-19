//
//  SearchViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 17/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import JNDropDownMenu

class SearchViewController: UIViewController,UIScrollViewDelegate,JNDropDownMenuDelegate,JNDropDownMenuDataSource{

    //Mark : - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "搜索球员、球场"
        let rightNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        let playerMenu = JNDropDownMenu(origin: palyerMenuOrigin, height: 35, width: self.view.frame.size.width)
        playerMenu.datasource = self
        playerMenu.delegate = self
        playerMenu.arrowPostion = .Left
        playerMenu.tag = 401
//        playerMenu.textFont = UIFont.boldSystemFont(ofSize: 11)
        scrollView.addSubview(playerMenu)
        
        let courtMenu = JNDropDownMenu(origin: CGPoint(x: self.view.frame.size.width, y: 0), height: 35, width: self.view.frame.size.width)
        courtMenu.datasource = self
        courtMenu.delegate = self
        courtMenu.arrowPostion = .Left
        courtMenu.tag = 402
//        courtMenu.textFont = UIFont.boldSystemFont(ofSize: 11)
        scrollView.addSubview(courtMenu)
//        scrollView.canCancelContentTouches = true
        
        //
//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panWhere(byReactingTo:)))
//        scrollView.addGestureRecognizer(panRecognizer)
    }

    //Mark : -控件
    
    @IBOutlet weak var userTableView: UITableView!{
        didSet{
//            userTableView.respo
        }
    }
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 30, y: 0, width: 330, height: 30))
    var palyerMenuOrigin = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var pageControl: UISegmentedControl!{
        didSet{
            pageControl.addTarget(self, action: #selector(pageChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            let scrollViewFrame = scrollView.bounds
            scrollView.contentSize = CGSize(width: scrollViewFrame.size.width * CGFloat(pageControl.numberOfSegments), height: scrollViewFrame.size.height)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.scrollsToTop = false
            scrollView.bounces = false
        }
    }
    
    //Mark : - action
//    func panWhere(byReactingTo panRecgnizer: UIPanGestureRecognizer)
//    {
//        let point : CGPoint = panRecgnizer.translation(in: nil)
//        scrollView.contentOffset = point
//        
//    }
    
    //Mark : -delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedSegmentIndex = page
    }
    
    
    func pageChanged(_ sender:UISegmentedControl){
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.selectedSegmentIndex)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    //Mark : -- menu var source
    var userOrderIndex : Int = 0
    var userPositionIndex : Int = 0
    var userInfoIndex : Int = 0
    
    var userInfoArray = ["不限","身高最高","体重最高"]
    var userOrderArray = ["智能排序" , "总评分最高" , "技术评分最高" , "身体评分最高" , "球商评分最高"]
    var userPositionArray = ["不限","控球后卫","得分后卫","小前锋","大前锋","中锋"]
    
    var courtOrderIndex : Int = 0
    var courtWhatIndex : Int = 0
    var courtInfoIndex : Int = 0
    
    var courtInfoArray = ["不限","水泥地","塑胶地","木地板"]
    var courtOrderArray = ["智能排序" , "总评分最高" , "价格评分最高" , "设施评分最高" , "球商分最高"]
    var courtWhatArray = ["不限","距离最近","价格最低","比赛最多"]
    
    //Mark : - menu source
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 3
    }
    
    func numberOfRows(in column: NSInteger, for forMenu: JNDropDownMenu) -> Int {
        if forMenu.tag == 401{
            switch column {
            case 0:
                return userInfoArray.count
            case 1:
                return userPositionArray.count
            case 2:
                return userOrderArray.count
            default:
                return 0
            }
        }else if forMenu.tag == 402{
            switch column {
            case 0:
                return courtWhatArray.count
            case 1:
                return courtInfoArray.count
            case 2:
                return courtOrderArray.count
            default:
                return 0
            }
        }
        return 0
    }
    
    func titleForRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) -> String {
        if forMenu.frame.origin == palyerMenuOrigin{
            switch indexPath.column {
            case 0:
                return userInfoArray[indexPath.row]
            case 1:
                return userPositionArray[indexPath.row]
            case 2:
                return userOrderArray[indexPath.row]
            default:
                return ""
            }
        }else{
            switch indexPath.column {
            case 0:
                return courtWhatArray[indexPath.row]
            case 1:
                return courtInfoArray[indexPath.row]
            case 2:
                return courtOrderArray[indexPath.row]
            default:
                return ""
            }
        }
        return ""
    }

    func didSelectRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) {
        if forMenu.tag == 401{
            switch indexPath.column {
            case 0:
                userInfoIndex = indexPath.row
                break
            case 1:
                userPositionIndex = indexPath.row
                break
            case 2:
                userOrderIndex = indexPath.row
            default:
                userInfoIndex = 0
                userPositionIndex = 0
                userOrderIndex = 0
            }
        }else if forMenu.tag == 402{
            switch indexPath.column {
            case 0:
                courtWhatIndex = indexPath.row
                break
            case 1:
                courtInfoIndex = indexPath.row
                break
            case 2:
                courtOrderIndex = indexPath.row
            default:
                courtWhatIndex = 0
                courtInfoIndex = 0
                courtOrderIndex = 0
            }
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
