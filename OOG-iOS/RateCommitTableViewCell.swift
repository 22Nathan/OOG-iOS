//
//  RateCommitTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class RateCommitTableViewCell: UITableViewCell {
    var buttonText : String?
    var delegate : RateGameTableViewControllerProtocol?
    
    @IBOutlet weak var rateButton: UIButton!{
        didSet{
            rateButton.backgroundColor = UIColor(red: 250/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
        }
    }
    @IBAction func commitRate(_ sender: Any) {
        delegate?.commitRate()
    }
}
