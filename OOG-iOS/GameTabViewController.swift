//
//  GameTabViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 02/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class GameTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        oneOnoneButoon.layer.masksToBounds = true
        oneOnoneButoon.clipsToBounds = true
        oneOnoneButoon.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var oneOnoneButoon: UIButton!
    @IBOutlet weak var twoOnTwoButton: UIButton!
    
    @IBOutlet weak var threeOnthreeButton: UIButton!
    
    @IBOutlet weak var fiveOnfiveButton: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
