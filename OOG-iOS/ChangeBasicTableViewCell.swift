//
//  ChangeBasicTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ChangeBasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var info : String?{
        didSet{
            if info == "1"{
                titleLabel.text = "性别"
                infoLabel.text = "男"
            }else if info == "2"{
                titleLabel.text = "性别"
                infoLabel.text = "女"
            }else if (info == "控球后卫" || info == "PG"){
                titleLabel.text = "位置"
                infoLabel.text = info
            }else{
                titleLabel.text = "昵称"
                infoLabel.text = info
            }
        }
    }
}
