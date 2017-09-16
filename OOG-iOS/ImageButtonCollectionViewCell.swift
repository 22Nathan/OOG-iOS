//
//  ImageButtonCollectionViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 16/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

class ImageButtonCollectionViewCell: UICollectionViewCell {
    var delegate : PublishMovementViewControllerDelegate?
    var lastPlus = true
    var image : UIImage?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var imageButton: UIButton!{
        didSet{
            imageButton.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if lastPlus{
            let pickerController = DKImagePickerController()
            pickerController.maxSelectableCount = 9
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                self.delegate?.deleteFirst()
                for photo in assets{
                    let displayedImage = convertPHAssetToUIImage(asset: photo.originalAsset!,88)
                    let previewImage = convertPHAssetToUIImage(asset: photo.originalAsset!,375)
                    self.delegate?.appendPreviewImage(previewImage)
                    self.delegate?.appendImage(displayedImage)
                    self.delegate?.appendAsset(photo.originalAsset!)
                }
                self.delegate?.appendImage(#imageLiteral(resourceName: "window.png"))
                self.delegate?.reloadView()
            }
            self.delegate?.presentPickVC(pickerController)
        }else{
            self.delegate?.deleteFirst()
            self.delegate?.preview()
            self.delegate?.appendImage(#imageLiteral(resourceName: "window.png"))
            self.delegate?.reloadView()
        }
    }
    
    private func updateUI(){
        imageButton.setBackgroundImage(image, for: UIControlState.normal)
    }
    
}
