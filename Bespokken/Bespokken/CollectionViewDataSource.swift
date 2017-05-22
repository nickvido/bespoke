//
//  CollectionViewDataSource.swift
//  Bespokken
//
//  Created by nickvido on 10/18/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import Foundation
import UIKit

typealias CollectionViewCellConfigureBlock = (_ cell:UICollectionViewCell, _ item:AnyObject?) -> ()

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var items:NSArray = []
    var reuseIdentifier:String?
    var configureCellBlock:CollectionViewCellConfigureBlock?
    
    init(items: NSArray, reuseIdentifier: String, configureBlock: @escaping CollectionViewCellConfigureBlock) {
        self.items = items
        self.reuseIdentifier = reuseIdentifier
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    func setDataItems(_ items: NSArray) {
        self.items = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier!, for: indexPath) as UICollectionViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell, item)
        }
        
        return cell
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return self.items[(indexPath as NSIndexPath).row] as AnyObject
    }
}
