//
//  HomeViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/16/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit
import AVFoundation

public class HomeViewController: UIViewController, UICollectionViewDelegate {
    var modesDataSource: CollectionViewDataSource?
    var wordsDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var modes = [Mode]()
    var words = [Word]()
    
    var currentMode = ""
    
    @IBOutlet weak var btnImmediateModeToggle: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var modesCollectionView: UICollectionView!
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    @IBOutlet weak var txtMain: UITextView!
    
    let synth = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    
    @IBAction func onImmediateButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func onPlayButtonTapped(sender: AnyObject) {
        let text: String = txtMain.text
        self.utterance = AVSpeechUtterance(string: text)
        self.utterance.rate = 0.45
        self.synth.speakUtterance(self.utterance)
        txtMain.text = ""
    }
    
    public override func viewDidLoad() {
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
        
        modesCollectionView.backgroundColor = UIColor.whiteColor()
        modesCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        modesCollectionView.layer.borderWidth = 1
        modesCollectionView.layer.cornerRadius = 5
        
        wordsCollectionView.backgroundColor = UIColor.whiteColor()
        wordsCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        wordsCollectionView.layer.borderWidth = 1
        wordsCollectionView.layer.cornerRadius = 5
        
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
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadModes() {
        modes.append(Mode(name: "Greetings"))
        modes.append(Mode(name: "Telephone"))
        modes.append(Mode(name: "Names"))
        modes.append(Mode(name: "Adjectives"))
        modes.append(Mode(name: "Verbs"))
        modes.append(Mode(name: "Anatomy"))
        modes.append(Mode(name: "Time"))
        modes.append(Mode(name: "Emotions"))
        modes.append(Mode(name: "Food"))       
        modes.append(Mode(name: "Animals"))
        modes.append(Mode(name: "Birds"))
        modes.append(Mode(name: "Cars"))
        modes.append(Mode(name: "Colors"))
        modes.append(Mode(name: "Fish"))
        modes.append(Mode(name: "Music"))
        modes.append(Mode(name: "People"))
        modes.append(Mode(name: "Places"))
        modes.append(Mode(name: "Trees"))
        modes.append(Mode(name: "Verbs"))
        modes.append(Mode(name: "Weather"))
        
        
        self.modesCollectionView.reloadData()
    }
    
    func loadWords(mode: String = "Names") {
        if mode == currentMode {
            return
        }
        words.removeAll()
        if let wordsPath = NSBundle.mainBundle().pathForResource(mode.lowercaseString, ofType: "txt") {
            if let contents = try? String(contentsOfFile: wordsPath, usedEncoding: nil) {
                let lines = contents.componentsSeparatedByString("\n")
                for (_, line) in lines.enumerate() {
                    let word = Word(name: line)
                    words.append(word)
                }
            }
        }
        self.wordsDataSource?.setDataItems(words)
        currentMode = mode
        
        self.wordsCollectionView.reloadData()
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.modesCollectionView {
            let mode = modes[indexPath.item]
            print("mode: \(mode.name)")
            // Handle switch modes
            loadWords(mode.name)
        }
        else if collectionView == self.wordsCollectionView {
            let word = words[indexPath.item]
            print("word: \(word.name)")
            txtMain.text = txtMain.text.stringByAppendingString(word.name)
        }
    }
    
    public func onSpacebarTapped() {
        txtMain.text = txtMain.text.stringByAppendingString(" ")
    }
}
