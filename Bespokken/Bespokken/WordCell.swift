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
    
    func configureForItem(_ item: Word) {
        lblName.text = item.name
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
    }
}
