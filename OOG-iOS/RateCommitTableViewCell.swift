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
    
    @IBAction func commitRate(_ sender: Any) {
        delegate?.commitRate()
    }
}
