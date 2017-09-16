//
//  ExtUIImage.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContext(reSize)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func getGaussianBlur() -> UIImage {
        let resize = CGSize(width: 500, height: 293)
        let resizeImage = self.reSizeImage(reSize: resize)
        let beginImage = CIImage(image: resizeImage)
        let gaussianBlur = CIFilter(name: "CIGaussianBlur")
        gaussianBlur?.setDefaults()
        gaussianBlur?.setValue(beginImage, forKey: kCIInputImageKey)
        gaussianBlur?.setValue(3.5, forKey: kCIInputRadiusKey)
        let context = CIContext(options:[kCIContextUseSoftwareRenderer: true])
        
        let cgImage = context.createCGImage((gaussianBlur?.outputImage)!, from: (gaussianBlur?.outputImage?.extent)!)
        let finalImage = UIImage(cgImage: cgImage!)
        //        print(finalImage.size.width)
        //        print(finalImage.size.height)
        return finalImage
    }
}
