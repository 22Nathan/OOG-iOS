//
//  MainTarBarViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 01/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MainTarBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeImage = #imageLiteral(resourceName: "tab_home").withRenderingMode(.alwaysOriginal)
        let homeSelectedImage = #imageLiteral(resourceName: "tab_home_selected").withRenderingMode(.alwaysOriginal)
        let homeTabBarItem = UITabBarItem(title: "首页", image: homeImage,selectedImage: homeSelectedImage)
        homeTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        //        homeTabBarItem.selectedImage = homeImage.
        self.viewControllers?[0].tabBarItem = homeTabBarItem

        let gameImage = #imageLiteral(resourceName: "tab_game").withRenderingMode(.alwaysOriginal)
        let gameSelectedImage = #imageLiteral(resourceName: "tab_game_selected").withRenderingMode(.alwaysOriginal)
        let gameTabBarItem = UITabBarItem(title: "比赛", image: gameImage,selectedImage: gameSelectedImage)
        gameTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[1].tabBarItem = gameTabBarItem
        
        let discoverImage = #imageLiteral(resourceName: "tab_discover").withRenderingMode(.alwaysOriginal)
        let discoverSelectedImage = #imageLiteral(resourceName: "tab_discover_selected").withRenderingMode(.alwaysOriginal)
        let discoverTabBarItem = UITabBarItem(title: "发现", image: discoverImage,selectedImage: discoverSelectedImage)
        discoverTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[2].tabBarItem = discoverTabBarItem
        
        let messageImage = #imageLiteral(resourceName: "tab_chat").withRenderingMode(.alwaysOriginal)
        let messageSelectedImage = #imageLiteral(resourceName: "tab_chat_selected").withRenderingMode(.alwaysOriginal)
        let messageTabBarItem = UITabBarItem(title: "聊天", image: messageImage,selectedImage: messageSelectedImage)
        messageTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[3].tabBarItem = messageTabBarItem
        
        let profileImage = #imageLiteral(resourceName: "tab_profile").withRenderingMode(.alwaysOriginal)
        let profileSelectedImage = #imageLiteral(resourceName: "tab_profile_selected").withRenderingMode(.alwaysOriginal)
        let profileTabBarItem = UITabBarItem(title: "我的", image: profileImage,selectedImage: profileSelectedImage)
        profileTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[4].tabBarItem = profileTabBarItem
        
        self.tabBar.barTintColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
