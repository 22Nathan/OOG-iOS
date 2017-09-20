//
//  ButtonCollectionViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 07/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var publishMovementButton: UIButton!{
        didSet{
            publishMovementButton.tintColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        }
    }
    
    
}
