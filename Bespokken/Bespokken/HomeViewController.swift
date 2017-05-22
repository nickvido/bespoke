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

open class HomeViewController: UIViewController, UICollectionViewDelegate, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {
    
    var useRecordingsIfPossible: Bool = true
    
    var modesDataSource: CollectionViewDataSource?
    var wordsDataSource: CollectionViewDataSource?
    var fastwordsDataSource: CollectionViewDataSource?
    
    var buttons = [UIButton]()
    var soundboards = [Soundboard]()
    var words = NSMutableArray() //[Word]()
    var fastwords = NSMutableArray() // [Word]()
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
    
    @IBAction func onLeftPlayButtonTapped(_ sender: AnyObject) {
        doPlay(txtMain.text, forceUseRecordingsIfPossible: false)
    }
    
    @IBAction func onPlayButtonTapped(_ sender: AnyObject) {
        doPlay(txtMain.text, forceUseRecordingsIfPossible: false)
    }
    
    @IBAction func onBtnHistoryTapped(_ sender: AnyObject) {
        print("History tapped")      
    }
    
    
    @IBAction func onBtnBackspaceTapped(_ sender: AnyObject) {

        if txtMain.text.characters.count > 0 {
            txtMain.text = txtMain.text.substring(to: txtMain.text.index(before: txtMain.text.endIndex))
        }
        //let li: Int? = lastIndexOf(txtMain.text, needle: " ")
        //if li != nil {
        //    txtMain.text = txtMain.text.substringToIndex(txtMain.text.startIndex.advancedBy(li!))
        //} else {
        //    txtMain.text = ""
        //}
    }
    
    @IBAction func onButtonClearTapped(_ sender: AnyObject) {
        txtMain.text = ""
    }
    
    
    func doPlay(_ text: String, forceUseRecordingsIfPossible: Bool) {
        var text = text
        speakTasks.removeAll()
        // clear previous playlist
        list.removeAll()
        
        if (useRecordingsIfPossible || forceUseRecordingsIfPossible) {
            
            // Strip any leading and trailing whitespace and punctuation
            text = text.trimmingCharacters(in: CharacterSet.whitespaces)
            text = text.replacingOccurrences(of: "'", with: "", options: NSString.CompareOptions.literal, range: nil)
            text = text.replacingOccurrences(of: "?", with: "", options: NSString.CompareOptions.literal, range: nil)
            text = text.replacingOccurrences(of: "!", with: "", options: NSString.CompareOptions.literal, range: nil)
            text = text.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            text = text.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
            text = text.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let wordArray: [String] = text.components(separatedBy: " ")
            
            // Parse the sentence to see if there are recordings of words
            var testFilename: String = ""
            var goodFilename: String = ""
            var i: Int = 0
            let depth: Int = 8   // words strings up to x long
            while i < wordArray.count {
                let word: String = wordArray[i].lowercased()
                goodFilename = word
                testFilename = goodFilename
                if goodFilename == "" {
                    // catch empty strings
                    i = i+1
                    continue
                }
                
                // try to build the longest word string possible
                // search depth first down to one extra word
                for d in (0...depth).reversed() {
                    testFilename = goodFilename
                    if (i+d) < wordArray.count {
                        if d > 0 {
                            for j in 1...d {
                                // build the word string to this depth
                                let nextword: String = wordArray[i+j].lowercased()
                                testFilename = testFilename + "_" + nextword
                            }
                        }
                        var goodFilenames: [String] = [String]()
                        
                        // find all the potential matching file names for this combination
                        // add them to a list which will be selected from at random
                        if Bundle.main.path(forResource: testFilename, ofType: "wav") != nil {
                            goodFilenames.append(testFilename)
                        }
                        if Bundle.main.path(forResource: testFilename + "_001", ofType: "wav") != nil {
                            goodFilenames.append(testFilename + "_001")
                        }
                        if Bundle.main.path(forResource: testFilename + "_002", ofType: "wav") != nil {
                            goodFilenames.append(testFilename + "_002")
                        }
                        if Bundle.main.path(forResource: testFilename + "_003", ofType: "wav") != nil {
                            goodFilenames.append(testFilename + "_003")
                        }
                        if Bundle.main.path(forResource: testFilename + "_004", ofType: "wav") != nil {
                            goodFilenames.append(testFilename + "_004")
                        }
                        if Bundle.main.path(forResource: testFilename + "_005", ofType: "wav") != nil {
                            goodFilenames.append(testFilename + "_005")
                        }
                        if Bundle.main.path(forResource: testFilename + "_006", ofType: "wav") != nil {
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
                
                let path: String? = Bundle.main.path(forResource: goodFilename, ofType: "wav")
                if path != nil {
                    let url: URL? = URL(fileURLWithPath: path!)
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
        speakTasks.remove(at: 0)
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

    func playAudioPlayerTask(_ ap: AudioPlayerTask) {
        
        //list.append(AudioFile(word, url!))
        list.append(ap.audioFile)
        
        if list.count > 0 {
            audioPlayer.playSong(0, songsList: list)
        }
    }
    
    func playTextToSpeechTask(_ ttst: TextToSpeechTask, doPlay: Bool) {
        self.utt = self.utt + ttst.utterance + " "
        self.utterance = AVSpeechUtterance(string: self.utt)
        self.utterance.rate = 0.4
        self.utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            //en-GB
            //en-IE
            //en-US
            //en-US"
        
        if doPlay {
            self.synth.speak(self.utterance)
            self.utt = ""
        } else {
            // since it does not play, trigger execute instead of using
            // the callback method
            executeSpeakTasks()
        }
        // when this completes, the callback will be triggered
    }
    
    open func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // callback from completed task - execute the next task
        list.removeAll()
        executeSpeakTasks()
    }
    
    open func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // callback from completed task - execute the next task
        executeSpeakTasks()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            print("\(voice.language)");
        }
        
        // Do any additional setup after loading the view.
        buttons += [btnPlayLeft, btnPlay, btnBackspace, btnClear, btnHistory]
        
        for button in buttons {
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.titleLabel?.textAlignment = .center
        }
        
        txtMain.backgroundColor = UIColor.white
        txtMain.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
        txtMain.layer.borderWidth = 1
        txtMain.layer.cornerRadius = 5
        
        modesCollectionView.backgroundColor = UIColor.darkGray
        modesCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
        modesCollectionView.layer.borderWidth = 1
        modesCollectionView.layer.cornerRadius = 5
        
        wordsCollectionView.backgroundColor = UIColor.lightGray
        wordsCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
        wordsCollectionView.layer.borderWidth = 1
        wordsCollectionView.layer.cornerRadius = 5
        
        fastwordsCollectionView.backgroundColor = UIColor.white
        fastwordsCollectionView.layer.borderColor = UIColor(red:0, green: 0, blue:0, alpha: 0.3).cgColor
        fastwordsCollectionView.layer.borderWidth = 1
        fastwordsCollectionView.layer.cornerRadius = 5
        
        // Setup modes
        loadModes()
        self.modesDataSource = CollectionViewDataSource(items: self.soundboards as NSArray, reuseIdentifier: "Soundboard", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? SoundboardCell {
                if let actualItem = item as? Soundboard {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        self.modesCollectionView.dataSource = self.modesDataSource
        
        // Setup words
        loadWords()
        self.wordsDataSource = CollectionViewDataSource(items: self.words as NSArray, reuseIdentifier: "Word", configureBlock: { (cell, item) -> () in
            if let actualCell = cell as? WordCell {
                if let actualItem = item as? Word {
                    actualCell.configureForItem(actualItem)
                }
            }
        })
        self.wordsCollectionView.dataSource = self.wordsDataSource
        
        loadFastwords()
        self.fastwordsDataSource = CollectionViewDataSource(items: self.fastwords as NSArray, reuseIdentifier: "Word", configureBlock: { (cell, item) -> () in
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
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        configureSettings()
    }
    
    func defaultsChanged()
    {
        configureSettings()
    }
    
    fileprivate func configureSettings()
    {
        let userDefaults = UserDefaults.standard
        useRecordingsIfPossible = userDefaults.bool(forKey: "use_recordings_if_possible")
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadModes() {
        // load the soundboards.txt file
        // for each line in the file, add the soundboard
        let soundboardsPath = Bundle.main.path(forResource: "soundboards", ofType: "txt")
        if let contents = try? String(contentsOfFile: soundboardsPath!) {
            let lines = contents.components(separatedBy: "\n")
            for (_, line) in lines.enumerated() {
                soundboards.append(Soundboard(name: line))
            }
        }
        
        self.modesCollectionView.reloadData()
    }
    
    func loadWords(_ mode: String = "Names") {
        if mode == currentMode {
            return
        }
        words.removeAllObjects()
        if let wordsPath = Bundle.main.path(forResource: mode.lowercased(), ofType: "txt") {
            if let contents = try? String(contentsOfFile: wordsPath) {
                let lines = contents.components(separatedBy: "\n")
                for (_, line) in lines.enumerated() {
                    let word = Word(name: line)
                    words.add(word)
                }
            }
        }
        self.wordsDataSource?.setDataItems(words as NSArray)
        currentMode = mode
        self.wordsCollectionView.reloadData()
    }
    
    func loadFastwords() {
        fastwords.removeAllObjects()
        if let wordsPath = Bundle.main.path(forResource: "fastwords", ofType: "txt") {
            if let contents = try? String(contentsOfFile: wordsPath) {
                let lines = contents.components(separatedBy: "\n")
                for (_, line) in lines.enumerated() {
                    let word = Word(name: line)
                    fastwords.add(word)
                }
            }
        }
        self.fastwordsDataSource?.setDataItems(fastwords)
        self.fastwordsCollectionView.reloadData()
    }

    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.modesCollectionView {
            let soundboard = soundboards[(indexPath as NSIndexPath).item]
            // Handle switch modes
            loadWords(soundboard.name)
        } else if collectionView == self.wordsCollectionView {
            let word = words[(indexPath as NSIndexPath).item] as! Word
            //print("word: \(word.name)")
            // OLD - add to list
            //txtMain.text = txtMain.text.stringByAppendingString(word.name + " ")
            
            // play immediate, always use recordings if possible from soundboard
            // regardless of settings
            doPlay(word.name, forceUseRecordingsIfPossible: true)
            
        } else if collectionView == self.fastwordsCollectionView {
            let word = fastwords[(indexPath as NSIndexPath).item] as! Word
            print ("fastword: \(word.name)")
            txtMain.text = txtMain.text + (word.name + " ")
        }
    }
    
    open func onSpacebarTapped() {
        var text = txtMain.text
        text = text! + " "
        txtMain.text = text
    }
}
