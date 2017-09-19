//
//  ExtUIView.swift
//  OOG-iOS
//
//  Created by Nathan on 18/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

extension UIView{
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
