//
//  UserMovementTableViewCell.swift
//  OOG-iOS
//
//  Created by Nathan on 12/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UserMovementTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

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
            collectionView.frame = CGRect(origin: collectionView.frame.origin, size: CGSize(width: collectionView.frame.width, height: lines*125 - 3) )
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movement = movements[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollection", for: indexPath) as! UserMovementCollectionViewCell
        //这里是每一个动态的第一张图片
        cell.movement = movement
        return cell
    }
    
}
