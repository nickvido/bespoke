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
    var wordsDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var modes = [Mode]()
    var words = [Word]()
    
    @IBOutlet weak var btnImmediateModeToggle: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var modesCollectionView: UICollectionView!
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    @IBOutlet weak var txtMain: UITextView!
    
    
    @IBAction func onImmediateButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func onPlayButtonTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buttons += [btnImmediateModeToggle, btnPlay]
        
        for button in buttons {
            button.backgroundColor = UIColor.whiteColor()
            button.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.titleLabel?.textAlignment = .Center
        }
        
        txtMain.backgroundColor = UIColor.whiteColor()
        txtMain.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        txtMain.layer.borderWidth = 1
        txtMain.layer.cornerRadius = 5
        
        // Setup modes
        loadModes()
        self.modesDataSource = CollectionViewDataSource(items: self.modes, reuseIdentifier: "Mode", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? ModeCell {
                if let actualItem = item as? Mode {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        self.modesCollectionView.dataSource = self.modesDataSource
        
        // Setup words
        loadWords()
        self.wordsDataSource = CollectionViewDataSource(items: self.words, reuseIdentifier: "Word", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? WordCell {
                if let actualItem = item as? Word {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        self.wordsCollectionView.dataSource = self.wordsDataSource
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
    
    func loadWords() {
        if let wordsPath = NSBundle.mainBundle().pathForResource("words", ofType: "txt") {
            if let contents = try? String(contentsOfFile: wordsPath, usedEncoding: nil) {
                let lines = contents.componentsSeparatedByString("\n")
                for (_, line) in lines.enumerate() {
                    let word = Word(name: line)
                    words.append(word)
                }
            }
        }
        
        self.wordsCollectionView.reloadData()
        self.wordsCollectionView.invalidateIntrinsicContentSize()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.modesCollectionView {
            let mode = modes[indexPath.item]
            print("mode: \(mode.name)")
            // TODO: Handle switch modes
        }
        else if collectionView == self.wordsCollectionView {
            let word = words[indexPath.item]
            print("word: \(word.name)")
        }
    }
}
