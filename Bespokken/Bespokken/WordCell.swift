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
    
    var _extraMargins: CGSize = CGSize(width: 0, height: 0)
    
    func configureForItem(item: Word) {
        lblName.text = item.name
        lblName.sizeToFit()
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.lblName?.textAlignment = .Center
        
        self.sizeToFit()
    }
    
    override func intrinsicContentSize() -> CGSize {
        var size = self.lblName.intrinsicContentSize()
        
        if CGSizeEqualToSize(self._extraMargins, CGSizeZero) {
            for constraint in self.constraints {
                if (constraint.firstAttribute == NSLayoutAttribute.Bottom || constraint.firstAttribute == NSLayoutAttribute.Top) {
                    _extraMargins.height += constraint.constant
                } else if (constraint.firstAttribute == NSLayoutAttribute.Leading || constraint.firstAttribute == NSLayoutAttribute.Trailing) {
                    _extraMargins.width += constraint.constant
                }
            }
        }
        
        size.width += _extraMargins.width
        size.height += _extraMargins.height
        
        return size
    }

}
