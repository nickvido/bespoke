//
// ColiseuPlayer.swift
// Coliseu
//
// Copyright (c) 2014 Ricardo Pereira (http://ricardopereira.eu)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// edited by NickVido

import AVFoundation
import MediaPlayer

protocol AudioPlayerProtocol: AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
}

open class AudioPlayer: NSObject
{
    open var delegate: AVAudioPlayerDelegate?
    public typealias function = () -> ()
    
    var audioPlayer: AVAudioPlayer?
    
    // Playlist
    fileprivate var currentSong: AudioFile?
    var songsList: [AudioFile]?
    
    // Events
    open var playerDidStart: function?
    open var playerDidStop: function?
    
    public override init()
    {
        // Inherited
        super.init()
    }
    
    open func startSession()
    {
        // Session
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch let error as NSError {
            print("A AVAudioSession setCategory error occurred, here are the details:\n \(error)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("A AVAudioSession setActive error occurred, here are the details:\n \(error)")
        }
    }
    
    fileprivate func prepareAudio(_ index: Int)
    {
        guard let songs = self.songsList , (index >= 0 && index < songs.count) else {
            return
        }
        prepareAudio(songs[index], index)
    }
    
    fileprivate func prepareAudio(_ song: AudioFile, _ index: Int)
    {
        // Keep alive audio at background
        if song.path == nil {
            self.currentSong = nil
            return
        }
        else {
            self.currentSong = song
            song.index = index
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: song.path! as URL)
        }
        catch let error as NSError {
            print("A AVAudioPlayer contentsOfURL error occurred, here are the details:\n \(error)")
        }
        
        // hooks the audioPlayerDidFinishPlaying method from the protocol
        self.audioPlayer!.delegate = self
        self.audioPlayer!.prepareToPlay()
        
        // ?
        song.duration = self.audioPlayer!.duration
    }
    
    fileprivate func songListIsValid() -> Bool
    {
        if self.songsList == nil || self.songsList!.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    open func playSong()
    {
        // Verify if has a valid playlist to play
        if !songListIsValid() {
            return
        }
        // Check the didStart event
        if let event = self.playerDidStart {
            event()
        }
        self.audioPlayer!.play()
    }
    
    open func playSong(_ index: Int, songsList: [AudioFile])
    {
        self.songsList = songsList
        // Prepare core audio
        prepareAudio(index)
        // Play current song
        playSong()
    }
    
    open func playSong(_ index: Int)
    {
        // Verify if has a valid playlist to play
        if !songListIsValid() {
            return
        }
        // Prepare core audio
        prepareAudio(index)
        // Play current song
        playSong()
    }
    
    open func stopSong()
    {
        if self.audioPlayer == nil || !self.audioPlayer!.isPlaying {
            return
        }
        
        self.audioPlayer!.stop();
        if let event = self.playerDidStop {
            event()
        }
        if let current = self.currentSong {
            prepareAudio(current, current.index)
        }
    }
    
    open func playNextSong(stopIfInvalid: Bool = false)
    {
        if let songs = self.songsList {
            if let song = self.currentSong {
                var index = song.index
                
                // Next song
                index += 1
                
                if index > songs.count - 1 {
                    if stopIfInvalid {
                        stopSong()
                    }
                    self.delegate?.audioPlayerDidFinishPlaying?(self.audioPlayer!, successfully: true)
                    return
                }
                
                playSong(index)
            }
        } else {
            self.delegate?.audioPlayerDidFinishPlaying?(self.audioPlayer!, successfully: true)
        }
    }
}


extension AudioPlayer: AudioPlayerProtocol
{
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if !flag {
            // this generally means the playlist has ended - 
            // TODO: trigger the method call
            // out to the protol listeners (so SpeakTask listener can play the next task)
            
            return
        }
        playNextSong(stopIfInvalid: true)
    }
}
