//
//  HomeViewController.swift
//  Bespokken
//
//  Created by nickvido on 10/16/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit
import AVFoundation
import Darwin

public class HomeViewController: UIViewController, UICollectionViewDelegate {
    let audioPlayer = AudioPlayer()
    
    var modesDataSource: CollectionViewDataSource?
    var wordsDataSource: CollectionViewDataSource?
    var fastwordsDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var modes = [Mode]()
    var words = [Word]()
    var fastwords = [Word]()
    
    var currentMode = ""
    
    let synth = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPlayLeft: UIButton!
    @IBOutlet weak var btnBackspace: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var modesCollectionView: UICollectionView!
    @IBOutlet weak var wordsCollectionView: UICollectionView!
    @IBOutlet weak var fastwordsCollectionView: UICollectionView!
    @IBOutlet weak var txtMain: UITextView!
    
    
    @IBAction func onLeftPlayButtonTapped(sender: AnyObject) {
        doPlay()
    }
    
    @IBAction func onPlayButtonTapped(sender: AnyObject) {
        doPlay()
    }
    
    @IBAction func onBtnBackspaceTapped(sender: AnyObject) {
        //let li: Int? = lastIndexOf(txtMain.text, needle: " ")
        //if li != nil {
        //    txtMain.text = txtMain.text.substringToIndex(txtMain.text.startIndex.advancedBy(li!))
        //} else {
        //    txtMain.text = ""
        //}
    }
    
    @IBAction func onButtonClearTapped(sender: AnyObject) {
        txtMain.text = ""
    }
    
    
    func doPlay() {
        var text: String = txtMain.text
        
        // Strip any leading and trailing whitespace and punctuation
        text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        text = text.stringByReplacingOccurrencesOfString("'", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        text = text.stringByReplacingOccurrencesOfString("?", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        text = text.stringByReplacingOccurrencesOfString("!", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        text = text.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        text = text.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        text = text.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let wordArray: [String] = text.componentsSeparatedByString(" ")
        
        var list = [AudioFile]()
        
        // Parse the sentence to see if there are recordings of words
        var testFilename: String = ""
        var goodFilename: String = ""
        var i: Int = 0
        let depth: Int = 5   // words strings up to x long
        while i < wordArray.count {
            let word: String = wordArray[i].lowercaseString
            goodFilename = word
            testFilename = goodFilename
            
            // try to build the longest word string possible
            // search depth first down to one extra word
            for d in (0...depth).reverse() {
                testFilename = goodFilename
                if (i+d) < wordArray.count {
                    if d > 0 {
                        for j in 1...d {
                            // build the word string to this depth
                            let nextword: String = wordArray[i+j].lowercaseString
                            testFilename = testFilename + "_" + nextword
                        }
                    }
                    var goodFilenames: [String] = [String]()
                    
                    // find all the potential matching file names for this combination
                    // add them to a list which will be selected from at random
                    if NSBundle.mainBundle().pathForResource(testFilename, ofType: "wav") != nil {
                        goodFilenames.append(testFilename)
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_001", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_001")
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_002", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_002")
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_003", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_003")
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_004", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_004")
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_005", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_005")
                    }
                    if NSBundle.mainBundle().pathForResource(testFilename + "_006", ofType: "wav") != nil {
                        goodFilenames.append(testFilename + "_006")
                    }
                    
                    if goodFilenames.count == 0 {
                        continue      // no filenames found
                    } else {
                        let diceRoll = Int(arc4random_uniform(UInt32(goodFilenames.count)))
                        // found a consecutive word string that exists
                        goodFilename = goodFilenames[diceRoll]
                        i = i+d       // consume the words
                        break         // quit the depth search
                    }
                } else {
                    continue          // the proposed depth was too long for the text
                }
            }
            
            let path: String? = NSBundle.mainBundle().pathForResource(goodFilename, ofType: "wav")
            if path != nil {
                let url: NSURL? = NSURL.fileURLWithPath(path!)
                print("path = \(path)")
                if url != nil {
                    list.append(AudioFile(word, url!))
                }
            } else {
                print("Could not locate file: \(word).wav")
            }
            
            // consume the word string
            i = i+1
        }
        
        if list.count > 0 {
            audioPlayer.playSong(0, songsList: list)
        }
        
        // TODO: Divide the sentence into recorded words and text-to-speech words
        // TODO: interleave the recordings with the text-to-speech        
        
        //self.utterance = AVSpeechUtterance(string: text)
        //self.utterance.rate = 0.4
        //self.synth.speakUtterance(self.utterance)
        txtMain.text = ""
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buttons += [btnPlayLeft, btnPlay, btnBackspace, btnClear]
        
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
        
        modesCollectionView.backgroundColor = UIColor.darkGrayColor()
        modesCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        modesCollectionView.layer.borderWidth = 1
        modesCollectionView.layer.cornerRadius = 5
        
        wordsCollectionView.backgroundColor = UIColor.lightGrayColor()
        wordsCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        wordsCollectionView.layer.borderWidth = 1
        wordsCollectionView.layer.cornerRadius = 5
        
        fastwordsCollectionView.backgroundColor = UIColor.whiteColor()
        fastwordsCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).CGColor
        fastwordsCollectionView.layer.borderWidth = 1
        fastwordsCollectionView.layer.cornerRadius = 5
        
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
        
        loadFastwords()
        self.fastwordsDataSource = CollectionViewDataSource(items: self.fastwords, reuseIdentifier: "Word", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? WordCell {
                if let actualItem = item as? Word {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        self.fastwordsCollectionView.dataSource = self.fastwordsDataSource

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
    
    func loadFastwords() {
        fastwords.removeAll()
        if let wordsPath = NSBundle.mainBundle().pathForResource("fastwords", ofType: "txt") {
            if let contents = try? String(contentsOfFile: wordsPath, usedEncoding: nil) {
                let lines = contents.componentsSeparatedByString("\n")
                for (_, line) in lines.enumerate() {
                    let word = Word(name: line)
                    fastwords.append(word)
                }
            }
        }
        self.fastwordsDataSource?.setDataItems(fastwords)
        self.fastwordsCollectionView.reloadData()
    }

    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.modesCollectionView {
            let mode = modes[indexPath.item]
            print("mode: \(mode.name)")
            // Handle switch modes
            loadWords(mode.name)
        } else if collectionView == self.wordsCollectionView {
            let word = words[indexPath.item]
            print("word: \(word.name)")
            txtMain.text = txtMain.text.stringByAppendingString(word.name)
        } else if collectionView == self.fastwordsCollectionView {
            let word = fastwords[indexPath.item]
            print ("fastword: \(word.name)")
            txtMain.text = txtMain.text.stringByAppendingString(word.name)
        }
    }
    
    public func onSpacebarTapped() {
        var text = txtMain.text
        text = text.stringByAppendingString(" ")
        txtMain.text = text
    }
}
