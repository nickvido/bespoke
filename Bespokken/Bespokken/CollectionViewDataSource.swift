//
//  CollectionViewDataSource.swift
//  Bespokken
//
//  Created by nickvido on 10/18/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import Foundation
import UIKit

typealias CollectionViewCellConfigureBlock = (cell:UICollectionViewCell, item:AnyObject?) -> ()

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var items:NSArray = []
    var reuseIdentifier:String?
    var configureCellBlock:CollectionViewCellConfigureBlock?
    
    init(items: NSArray, reuseIdentifier: String, configureBlock: CollectionViewCellConfigureBlock) {
        self.items = items
        self.reuseIdentifier = reuseIdentifier
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    func setDataItems(items: NSArray) {
        self.items = items
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier!, forIndexPath: indexPath) as UICollectionViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell: cell, item: item)
        }
        
        return cell
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return self.items[indexPath.row]
    }
}
