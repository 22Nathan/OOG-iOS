//
//  CustomAnnotationView.swift
//  OOG-iOS
//
//  Created by Nathan on 13/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class CustomAnnotationView : MAAnnotationView{
    var courtImage : UIImage?
    var calloutView : CustomCalloutView?{
        didSet{
//            self.addSubview(calloutView!)
        }
    }
    
    let kCalloutWidth : CGFloat = 180.0
    let kCalloutHeight : CGFloat = 100.0
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if(selected){
            if(self.calloutView == nil){
                self.calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: kCalloutWidth, height: kCalloutHeight ))
                self.calloutView?.center = CGPoint(x: self.bounds.width/2 + self.calloutOffset.x, y: self.bounds.height/2 + self.calloutOffset.y)
            }
            let courtNameLabel = UILabel(frame: CGRect(x: 10, y: 8, width: kCalloutWidth-10, height: 20))
            courtNameLabel.text = self.annotation.title
            courtNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
            self.calloutView?.addSubview(courtNameLabel)
            
            let locationLabel = UILabel(frame: CGRect(x: 10, y: 28, width: kCalloutWidth-10, height: 30))
            locationLabel.text = self.annotation.subtitle
            locationLabel.font = UIFont.boldSystemFont(ofSize: 13)
            self.calloutView?.addSubview(locationLabel)
            self.image = #imageLiteral(resourceName: "like.png")
            self.addSubview(calloutView!)
            
        }else{
            self.calloutView?.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
}
