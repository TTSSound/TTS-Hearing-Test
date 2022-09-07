//
//  AudioSessionModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//


import Foundation
import AVFoundation
import AVFAudio
import AVKit
import SwiftUI
import CoreMedia
import MediaPlayer



class AudioSessionModel: ObservableObject {
    enum RouteSharingPolicy : UInt, @unchecked Sendable{
        case `default` = 0
        case independent = 2
    }
    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume
    var audioSession = AVAudioSession.sharedInstance()
    var progressObserver: NSKeyValueObservation!
    @Published var successfulStartToAudioSession = Int()
    
    init() {
        setAudioSession()
    }


    func setAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .measurement, policy: AVAudioSession.RouteSharingPolicy.default, options: .allowAirPlay)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            self.successfulStartToAudioSession = 1
            print(audioSession.currentRoute)
            print("Success starting audio session")
            
        } catch {
            self.successfulStartToAudioSession = 0
            print("Failed to set audio session category.")
            print(error.localizedDescription)
        }
        
        progressObserver = audioSession.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = session.outputVolume
            }
        }
  
    }
    
    func volumeObserver() {
        progressObserver = audioSession.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = session.outputVolume
            }
        }
    }
            
    func unsubscribe() {
        self.progressObserver.invalidate()
    }
    
    func cancelAudioSession() {
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            self.successfulStartToAudioSession = 0
            print(audioSession.currentRoute)
            print("Cancel Audio Session Complete!!")
        } catch {
            self.successfulStartToAudioSession = 1
            print("Could Not Cancel AudioSession")
            print(error.localizedDescription)
        }
    }
}

    
  

        
        
        



