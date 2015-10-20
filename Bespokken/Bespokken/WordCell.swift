//
//  WordCellCollectionViewCell.swift
//  Bespokken
//
//  Created by nickvido on 10/18/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

class WordCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    func configureForItem(item: Word) {
        lblName.text = item.name
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
    }
}
