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
import DKImagePickerController
import Photos
import SwiftPhotoGallery

class PublishMovementViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PublishMovementViewControllerDelegate,SwiftPhotoGalleryDelegate,SwiftPhotoGalleryDataSource {
    var uploadPHAssets : [PHAsset] = []
    var uploadImages : [UIImage] = []
    var previewImages : [UIImage] = []
    var token : String = ""
    var userID : String = ""
    var imageUrls : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImages.append(#imageLiteral(resourceName: "myadd.png"))
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.isScrollEnabled = false
            collectionView.delegate = self
            collectionView.dataSource = self
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
    
    //监听多张图片上传
    var uploadImageCount = 0{
        didSet{
            if uploadImageCount == uploadPHAssets.count{
                self.postOut()
            }
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        requestToken() //三级回调 先请求token
        showProgressDialog()
    }
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var mentionButton: UIButton!
    
    //Mark : - PublishMovementViewControllerDelegate
    func deleteFirst() {
        self.uploadImages.popLast()
    }
    
    func appendImage(_ image: UIImage) {
        self.uploadImages.append(image)
    }
    
    func appendPreviewImage(_ image: UIImage) {
        self.previewImages.append(image)
    }
    
    func appendAsset(_ assets: PHAsset) {
        self.uploadPHAssets.append(assets)
    }
    
    func presentPickVC(_ vc: DKImagePickerController) {
        self.present(vc, animated: true)
    }
    
    func reloadView() {
        self.collectionView.reloadData()
    }
    
    func preview() {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        present(gallery, animated: true, completion: nil)
    }
    
    // Gallery dataSource
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return previewImages.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return previewImages[forIndex]
    }
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }
    
    // collection dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = uploadImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageButton", for: indexPath) as! ImageButtonCollectionViewCell
        cell.image = image
        cell.delegate = self
        if ( (indexPath.row + 1) == uploadImages.count ){
            cell.lastPlus = true
        }else{
            cell.lastPlus = false 
        }
        return cell
    }
    
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        var uploadImage : UIImage? = nil
//        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
//            imageButton.setBackgroundImage(image, for: UIControlState.normal)
//            uploadImage = image
//        }
//        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageButton.setBackgroundImage(image, for: UIControlState.normal)
//            uploadImage = image
//        } else{
//            print("Something went wrong")
//        }
//        let imageData = UIImagePNGRepresentation(uploadImage!)
//        uploadImages.append(imageData!)
//        self.dismiss(animated: true, completion: nil)
//    }
    
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
        for asset in uploadPHAssets{
            let date = NSDate()
            let timeInterval = date.timeIntervalSince1970 * 1000
            let key = userID + String(timeInterval)
            upManager?.put(asset, key: key, token: token, complete: { (responseInfo, key, dict) in
                if (responseInfo?.isOK)!{
                    if(self.uploadImageCount == 0){
                        self.imageUrls += (ApiHelper.qiniu_Root + key!)
                    }else{
                        self.imageUrls += ("," + ApiHelper.qiniu_Root + key!)
                    }
                    self.uploadImageCount += 1
                }else{
                    SVProgressHUD.showInfo(withStatus: "图片上传失败")
                }
            }, option: nil)
        }
    }
    
    private func postOut(){
        var parameters = [String : String]()
        parameters["id"] = userID
        parameters["uuid"] = ApiHelper.currentUser.uuid
        parameters["content"] = contentTextView.text
        parameters["image_url"] = imageUrls
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

protocol PublishMovementViewControllerDelegate {
    func deleteFirst()
    func appendImage(_ image : UIImage)
    func appendPreviewImage(_ image : UIImage)
    func appendAsset(_ assets : PHAsset)
    func presentPickVC(_ vc : DKImagePickerController)
    func reloadView()
    func preview()
}
