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
        }
    }
    
    var movements : [Movement] = []{
        didSet{
            self.collectionView.reloadData()
            var lines = CGFloat(movements.count / 3)
            if movements.count % 3 > 0{
                lines += 1
            }
            if lines == 0{
                lines = 1
            }
            print("dsadsadsa")
            print(lines)
            self.collectionView.frame = CGRect(origin: collectionView.frame.origin, size: CGSize(width: collectionView.frame.width, height: lines*125 - 3) )
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movements.count > 9{
            return 9
        }else{
            return movements.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == movements.count) || (indexPath.row == 8){
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
