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

        self.tabBar.barTintColor = UIColor.flatWhite
        
        let homeImage = #imageLiteral(resourceName: "home.png").withRenderingMode(.alwaysOriginal)
        let homeTabBarItem = UITabBarItem(title: "Home", image: homeImage,selectedImage: nil)
        homeTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        //        homeTabBarItem.selectedImage = homeImage.
        self.viewControllers?[0].tabBarItem = homeTabBarItem

        let profileImage = #imageLiteral(resourceName: "profile.png").withRenderingMode(.alwaysOriginal)
        let profileTabBarItem = UITabBarItem(title: "Me", image: profileImage,selectedImage: nil)
        profileTabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
        self.viewControllers?[1].tabBarItem = profileTabBarItem
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
