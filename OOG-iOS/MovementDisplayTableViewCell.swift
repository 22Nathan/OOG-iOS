//
//  MovementDisplayTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 07/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MovementDisplayTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.isScrollEnabled = false
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
//            self.collectionView.register(MovementCollectionViewCell.self, forCellWithReuseIdentifier: "imageCollection")
        }
    }
    
//     private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var movements : [Movement] = []{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
//        return CGSize(width: 125, height: 125)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 8{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollection", for: indexPath) as! ButtonCollectionViewCell
            cell.publishMovementButton.setTitle("超大加号", for: UIControlState(rawValue: 0))
            return cell
        }
        let movement = movements[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollection", for: indexPath) as! MovementCollectionViewCell
        //这里是每一个动态的第一张图片
        cell.movement = movement
        return cell
    }
    
}
