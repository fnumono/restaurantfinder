//
//  MyCollection.swift
//  mapfinderme
//
//  Created by pramono wang on 8/11/16.
//  Copyright © 2016 fnu. All rights reserved.
//

import UIKit

class MyCollection: UICollectionViewController {
    
    let allSectionColors = [
        UIColor.redColor(),
        UIColor.greenColor(),
        UIColor.blueColor()
    ]
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: 80, height: 80)
        flowLayout.scrollDirection = .Vertical

        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        self.init(collectionViewLayout: flowLayout)
    }

}
