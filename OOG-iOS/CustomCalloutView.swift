//
//  CustomCalloutView.swift
//  OOG-iOS
//
//  Created by Nathan on 13/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    var kArrorHeight : CGFloat = 10

    override func draw(_ rect: CGRect) {
        self.drawInContext(context: UIGraphicsGetCurrentContext()!)
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.opacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawInContext(context: CGContext){
        context.setLineWidth(2)
        context.setFillColor(UIColor.white.cgColor)
        self.getDrawPath(context: context)
        context.fillPath()
    }
    
    func getDrawPath(context: CGContext){
        let rrect : CGRect = self.bounds
        let radius : CGFloat = 6.0
        let minX : CGFloat = rrect.minX
        let midX = rrect.midX
        let maxX = rrect.maxX
        let minY : CGFloat = rrect.minY
        let maxY = rrect.maxY - kArrorHeight
        context.move(to: CGPoint(x: midX+kArrorHeight, y: maxY) )
        context.addLine(to: CGPoint(x: midX, y: maxY+kArrorHeight))
        context.addLine(to: CGPoint(x: midX-kArrorHeight, y: maxY))
        context.addArc(tangent1End: CGPoint(x: minX,y:maxY), tangent2End: CGPoint(x: minX,y:minY), radius: radius)
        context.addArc(tangent1End: CGPoint(x: minX,y:minX), tangent2End: CGPoint(x: maxX,y:minY), radius: radius)
        context.addArc(tangent1End: CGPoint(x: maxX,y:minY), tangent2End: CGPoint(x: maxX,y:maxX), radius: radius)
        context.addArc(tangent1End: CGPoint(x: maxX,y:maxY), tangent2End: CGPoint(x: midX,y:maxY), radius: radius)
        context.closePath()
    }
}
