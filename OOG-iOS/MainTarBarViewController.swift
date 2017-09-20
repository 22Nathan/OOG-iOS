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
        let homeImage = #imageLiteral(resourceName: "home_default.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let homeSelectedImage = #imageLiteral(resourceName: "home_chosen.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let homeTabBarItem = UITabBarItem(title: "首页", image: homeImage,selectedImage: homeSelectedImage)
        homeTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        //        homeTabBarItem.selectedImage = homeImage.
        self.viewControllers?[0].tabBarItem = homeTabBarItem

        let gameImage = #imageLiteral(resourceName: "game_default.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let gameSelectedImage = #imageLiteral(resourceName: "game_chosen.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let gameTabBarItem = UITabBarItem(title: "比赛", image: gameImage,selectedImage: gameSelectedImage)
        gameTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[1].tabBarItem = gameTabBarItem
        
        let discoverImage = #imageLiteral(resourceName: "discover_default.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let discoverSelectedImage = #imageLiteral(resourceName: "discover_chosen.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let discoverTabBarItem = UITabBarItem(title: "发现", image: discoverImage,selectedImage: discoverSelectedImage)
        discoverTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[2].tabBarItem = discoverTabBarItem
        
        let messageImage = #imageLiteral(resourceName: "chat_default.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let messageSelectedImage = #imageLiteral(resourceName: "chat_chosen.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let messageTabBarItem = UITabBarItem(title: "聊天", image: messageImage,selectedImage: messageSelectedImage)
        messageTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[3].tabBarItem = messageTabBarItem
        
        let profileImage = #imageLiteral(resourceName: "profile_default.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let profileSelectedImage = #imageLiteral(resourceName: "profile_chosen.png").reSizeImage(reSize: CGSize(width: 29, height: 29)).withRenderingMode(.alwaysOriginal)
        let profileTabBarItem = UITabBarItem(title: "我的", image: profileImage,selectedImage: profileSelectedImage)
        profileTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[4].tabBarItem = profileTabBarItem
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
        
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
