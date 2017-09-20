//
//  InGameUIViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 17/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class InGameUIViewController: UIViewController,InGameUIViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var inGame : Game?{
        didSet{
            
        }
    }
    
    func initInGame(_ game: Game) {
        self.inGame = game
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

protocol InGameUIViewControllerDelegate {
    func initInGame(_ game : Game)
}
