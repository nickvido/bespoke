//
//  ModeCellCollectionViewCell.swift
//  Bespokken
//
//  Created by nickvido on 10/17/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

class ModeCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    func configureForItem(item: Mode) {
        lblName.text = item.name
    }
}
