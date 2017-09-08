//
//  PublishMovementViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 07/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Qiniu
import Alamofire

class PublishMovementViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var imageButton: UIButton!{
        didSet{
            imageButton.imageView?.contentMode = .scaleAspectFit
            imageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.isScrollEnabled = false
            contentTextView.delegate = self
        }
    }
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    func textViewDidChange(_ textView: UITextView) {
        let test = contentTextView.text as NSString
        if (test.length != 0) {
            self.placeHolderLabel.alpha = 0;
        } else {
            self.placeHolderLabel.alpha = 1;
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        
    }
    
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var mentionButton: UIButton!
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var uploadImage : UIImage? = nil
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageButton.setBackgroundImage(image, for: UIControlState.normal)
            uploadImage = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageButton.setBackgroundImage(image, for: UIControlState.normal)
            uploadImage = image
        } else{
            print("Something went wrong")
        }
        
        let imageData = UIImagePNGRepresentation(uploadImage!)
        
//        let upManager = QNUploadManager()
//        
//        upManager?.put(imageData, key: "test", token: ApiHelper.qiniuAccessKey, complete: { (responseInfo, key , dict) in
//            if (responseInfo?.isOK)!{
//                print("21312")
//            }
//            print(responseInfo.debugDescription)
//        }, option: nil)
//        print("what")
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    func tokenRequest(){
//        Alamofire.
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
