//
//  HomeViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/16/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    var modesDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var modes = [Mode]()
    
    @IBOutlet weak var btnImmediateModeToggle: UIButton!
    @IBOutlet weak var modesCollectionView: UICollectionView!
    
    
    @IBAction func onImmediateButtonTapped(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buttons += [btnImmediateModeToggle]
        
        for button in buttons {
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.titleLabel?.textAlignment = .Center
        }
        
        loadModes()

        self.modesDataSource = CollectionViewDataSource(items: self.modes, reuseIdentifier: "Mode", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? ModeCell {
                if let actualItem = item as? Mode {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        
        self.modesCollectionView.dataSource = self.modesDataSource
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadModes() {
        for i in 0...100 {
            let m = Mode(name: String(i))
            modes.append(m)
        }
        
        self.modesCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mode = modes[indexPath.item]
        print("mode: \(mode.name)")
    }

}
