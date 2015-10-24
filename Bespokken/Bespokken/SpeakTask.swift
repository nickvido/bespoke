//
//  SpeakTask.swift
//  Bespokken
//
//  Created by nickvido on 10/23/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

// This is the base class either an AudioPlayer playlist
// or an AVFoundation SpeechUtterance - the main view
// will have a set of SpeakTasks and will play them in order
protocol SpeakTask {
    var type: String { get }
    func play()
    func onComplete()
}

protocol SpeakTaskDelegate {    
    func speakTaskEnded()
}

class AudioPlayerTask : SpeakTask {
    // this is a hack
    var type: String  { return "AUDIO_PLAYER_TASK" }
    var speakTaskEndedDelegate: SpeakTaskDelegate?
    
    var audioFile: AudioFile
    init(audioFile: AudioFile) {
        self.audioFile = audioFile
    }
    
    func play() {
        
    }
    
    func onComplete() {
        // 
    }
}

class TextToSpeechTask : SpeakTask {
    // this is a hack
    var type: String  { return "TTS_TASK" }
    var utterance: String
    init(utterance: String) {
        self.utterance = utterance
    }
    func play() {
        
    }
    
    func onComplete() {
        //
    }
}


