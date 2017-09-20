//
//  ConvertPHAssetToUIImage.swift
//  OOG-iOS
//
//  Created by Nathan on 15/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

func convertPHAssetToUIImage(asset : PHAsset, _ length : CGFloat) -> UIImage{
    var image = UIImage()
    
    // 新建一个默认类型的图像管理器imageManager
    let imageManager = PHImageManager.default()
    
    // 新建一个PHImageRequestOptions对象
    let imageRequestOption = PHImageRequestOptions()
    
    // PHImageRequestOptions是否有效
    imageRequestOption.isSynchronous = true
    
    // 缩略图的压缩模式设置为无
    imageRequestOption.resizeMode = .none
    
    // 缩略图的质量为高质量，不管加载时间花多少
    imageRequestOption.deliveryMode = .highQualityFormat
    
    let size = CGSize(width: length, height: length)
    
    // 按照PHImageRequestOptions指定的规则取出图片
    imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
        (result, _) -> Void in
        image = result!
    })
    return image
}
