//
//  HomePopViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 09/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class HomePopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        preferredContentSize = CGSize(width: 90, height: 70)
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
