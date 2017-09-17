//
//  InfoTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 07/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageButton: UIButton!{
        didSet{
            imageButton.isEnabled = false
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    
    var infoText : String?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        if infoText == "我的组队"{
            imageButton.setImage(#imageLiteral(resourceName: "tab_game_selected"), for: UIControlState.normal)
        }else if infoText == "我的评分"{
            imageButton.setImage(#imageLiteral(resourceName: "tab_chat_selected"), for: UIControlState.normal)
        }
        infoLabel.text = infoText
    }
    
}
