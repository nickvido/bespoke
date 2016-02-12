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

public class HomeViewController: UIViewController, UICollectionViewDelegate, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {
    
    var useRecordingsIfPossible: Bool = true
    
    var modesDataSource: CollectionViewDataSource?
    var wordsDataSource: CollectionViewDataSource?
    var fastwordsDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var soundboards = [Soundboard]()
    var words = [Word]()
    var fastwords = [Word]()
    var list = [AudioFile]()
    
    var currentMode = ""
    var utt: String = ""
    
    var speakTasks = [SpeakTask]()
    // have these here so the app only has one AudioPlayer and SpeechSynthesizer
    let audioPlayer = AudioPlayer()
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
    
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBAction func onLeftPlayButtonTapped(sender: AnyObject) {
        doPlay(txtMain.text, forceUseRecordingsIfPossible: false)
    }
    
    @IBAction func onPlayButtonTapped(sender: AnyObject) {
        doPlay(txtMain.text, forceUseRecordingsIfPossible: false)
    }
    
    @IBAction func onBtnHistoryTapped(sender: AnyObject) {
        print("History tapped")      
    }
    
    
    @IBAction func onBtnBackspaceTapped(sender: AnyObject) {

        if txtMain.text.characters.count > 0 {
            txtMain.text = txtMain.text.substringToIndex(txtMain.text.endIndex.predecessor())
        }
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
    
    
    func doPlay(var text: String, forceUseRecordingsIfPossible: Bool) {
        speakTasks.removeAll()
        // clear previous playlist
        list.removeAll()
        
        if (useRecordingsIfPossible || forceUseRecordingsIfPossible) {
            
            // Strip any leading and trailing whitespace and punctuation
            text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            text = text.stringByReplacingOccurrencesOfString("'", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("?", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("!", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let wordArray: [String] = text.componentsSeparatedByString(" ")
            
            // Parse the sentence to see if there are recordings of words
            var testFilename: String = ""
            var goodFilename: String = ""
            var i: Int = 0
            let depth: Int = 8   // words strings up to x long
            while i < wordArray.count {
                let word: String = wordArray[i].lowercaseString
                goodFilename = word
                testFilename = goodFilename
                if goodFilename == "" {
                    // catch empty strings
                    i = i+1
                    continue
                }
                
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
                        let af: AudioFile = AudioFile(word, url!)
                        speakTasks.append(AudioPlayerTask(audioFile: af))
                        //list.append(AudioFile(word, url!))
                    }
                } else {
                    print("Could not locate file: \(word).wav")
                    speakTasks.append(TextToSpeechTask(utterance: word))
                }
                
                // consume the word string
                i = i+1
            }
        } else {
            speakTasks.append(TextToSpeechTask(utterance: text))
        }
        
        executeSpeakTasks()
        
        txtMain.text = ""
    }
    
    func executeSpeakTasks() {
        // execute the first task in the list
        // callbacks will execute the following tasks when the previous task completes
        if speakTasks.count < 1 {
            return
        }
        
        let st: SpeakTask = speakTasks[0]
        speakTasks.removeAtIndex(0)
        if st.type == "AUDIO_PLAYER_TASK" {
            playAudioPlayerTask(st as! AudioPlayerTask)
        } else if st.type == "TTS_TASK" {
            if speakTasks.count > 0 {
                if speakTasks[0].type == "TTS_TASK" {
                    // the next task is a TTS task, don't play it, the string will get appended
                    // and play more smoothly as a sentence
                    playTextToSpeechTask(st as! TextToSpeechTask, doPlay: false)
                } else {
                    // the next task is a recorded task, need to play now
                    playTextToSpeechTask(st as! TextToSpeechTask, doPlay: true)
                }
            } else {
                // there are no more tasks after this, play it
                playTextToSpeechTask(st as! TextToSpeechTask, doPlay: true)
            }
        } else {
                    // this should never have happened
        }
    }

    func playAudioPlayerTask(ap: AudioPlayerTask) {
        
        //list.append(AudioFile(word, url!))
        list.append(ap.audioFile)
        
        if list.count > 0 {
            audioPlayer.playSong(0, songsList: list)
        }
    }
    
    func playTextToSpeechTask(ttst: TextToSpeechTask, doPlay: Bool) {
        self.utt = self.utt + ttst.utterance + " "
        self.utterance = AVSpeechUtterance(string: self.utt)
        self.utterance.rate = 0.4
        self.utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            //en-GB
            //en-IE
            //en-US
            //en-US"
        
        if doPlay {
            self.synth.speakUtterance(self.utterance)
            self.utt = ""
        } else {
            // since it does not play, trigger execute instead of using
            // the callback method
            executeSpeakTasks()
        }
        // when this completes, the callback will be triggered
    }
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        // callback from completed task - execute the next task
        list.removeAll()
        executeSpeakTasks()
    }
    
    public func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        // callback from completed task - execute the next task
        executeSpeakTasks()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            print("\(voice.language)");
        }
        
        // Do any additional setup after loading the view.
        buttons += [btnPlayLeft, btnPlay, btnBackspace, btnClear, btnHistory]
        
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
        self.modesDataSource = CollectionViewDataSource(items: self.soundboards, reuseIdentifier: "Soundboard", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? SoundboardCell {
                if let actualItem = item as? Soundboard {
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

        self.audioPlayer.delegate = self
        
        //self.utterance = AVSpeechUtterance(string: text)
        //self.utterance.rate = 0.4
        //self.synth.speakUtterance(self.utterance)
        self.synth.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged", name: NSUserDefaultsDidChangeNotification, object: nil)
        configureSettings()
    }
    
    func defaultsChanged()
    {
        configureSettings()
    }
    
    private func configureSettings()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        useRecordingsIfPossible = userDefaults.boolForKey("use_recordings_if_possible")
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func loadModes() {
        // load the soundboards.txt file
        // for each line in the file, add the soundboard
        let soundboardsPath = NSBundle.mainBundle().pathForResource("soundboards", ofType: "txt")
        if let contents = try? String(contentsOfFile: soundboardsPath!, usedEncoding: nil) {
            let lines = contents.componentsSeparatedByString("\n")
            for (_, line) in lines.enumerate() {
                soundboards.append(Soundboard(name: line))
            }
        }
        
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
            let soundboard = soundboards[indexPath.item]
            // Handle switch modes
            loadWords(soundboard.name)
        } else if collectionView == self.wordsCollectionView {
            let word = words[indexPath.item]
            //print("word: \(word.name)")
            // OLD - add to list
            //txtMain.text = txtMain.text.stringByAppendingString(word.name + " ")
            
            // play immediate, always use recordings if possible from soundboard
            // regardless of settings
            doPlay(word.name, forceUseRecordingsIfPossible: true)
            
        } else if collectionView == self.fastwordsCollectionView {
            let word = fastwords[indexPath.item]
            print ("fastword: \(word.name)")
            txtMain.text = txtMain.text.stringByAppendingString(word.name + " ")
        }
    }
    
    public func onSpacebarTapped() {
        var text = txtMain.text
        text = text.stringByAppendingString(" ")
        txtMain.text = text
    }
}
