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
import SwiftyJSON
import SwiftDate
import SVProgressHUD

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
    
    //textview placeholder
    func textViewDidChange(_ textView: UITextView) {
        let test = contentTextView.text as NSString
        if (test.length != 0) {
            self.placeHolderLabel.alpha = 0;
        } else {
            self.placeHolderLabel.alpha = 1;
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        requestToken() //三级回调
        showProgressDialog()
    }
    
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var mentionButton: UIButton!
    
    // variables
    var uploadImages : [Data] = []
    var token : String = ""
    var userID : String = ""
    var key : String = ""
//    var keySuffix : String {
//        return DateInRegion(absoluteDate: Date(), in: Region.Local()).string()
//    }
//    var key : String{
//        return keyPrefix + keySuffix
//    }
    
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
        uploadImages.append(imageData!)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func requestToken(){
        Alamofire.request(ApiHelper.API_Root + "/users/picture/authentication/",
                          method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON {response in
                switch response.result.isSuccess {
                case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    self.token = json["result"].stringValue
                    print(self.token)
                    self.uploadData()
                }
                case false:
                    print(response.result.error!)
                    SVProgressHUD.showInfo(withStatus: "上传凭证获取失败")
                }
        }
    }
    
    private func uploadData(){
        let upManager = QNUploadManager()
        key = userID
        upManager?.put(uploadImages[0], key: key, token: token, complete: { (responseInfo, key , dict) in
            if (responseInfo?.isOK)!{
                print("上传成功")
                self.postOut()
            }else{
                SVProgressHUD.showInfo(withStatus: "图片上传失败")
            }
        }, option: nil)
    }
    
    private func postOut(){
        var parameters = [String : String]()
        parameters["uuid"] = userID
        parameters["content"] = contentTextView.text
        parameters["image_url"] = ApiHelper.qiniu_Root + key
        Alamofire.request(ApiHelper.API_Root + "/movements/publish/",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseJSON {response in
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    let json = SwiftyJSON.JSON(value)
                                    //Mark: - print
                                    print(json)
                                    let result = json["result"].stringValue
                                    if result == "no"{
                                        SVProgressHUD.showInfo(withStatus: "发布失败")
                                    }
                                    if result == "ok"{
                                        self.navigationController?.popViewController(animated: true)
                                        self.hideProgressDialog()
                                    }
                                }
                            case false:
                                print(response.result.error!)
                            }
        }
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
