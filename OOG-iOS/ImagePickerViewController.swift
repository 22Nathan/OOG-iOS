//
//  ImagePickerViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 07/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerViewController : UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var testImage: UIImageView!
    
    @IBAction func tapButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            testImage.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            testImage.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
