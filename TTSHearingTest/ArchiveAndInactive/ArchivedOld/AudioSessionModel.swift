//
//  AudioSessionModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/8/22.
//

//import Foundation
//
//  AudioSessionModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//


//import Foundation
//import AVFoundation
//import AVFAudio
//import AVKit
//import SwiftUI
//import CoreMedia
//
//
//
//class AudioSessionModel: ObservableObject {
//    enum RouteSharingPolicy : UInt, @unchecked Sendable{
//        case `default` = 0
//        case independent = 2
//    }
//
//    var routeSharingPolicy: AVAudioSession.RouteSharingPolicy {
//        .default
//    }
//
//    var audioSession = AVAudioSession.sharedInstance()
//    var systemAVAOutputVolume = AVAudioSession.sharedInstance().outputVolume
//
//    func setAudioSession() {
//        do {
//            try audioSession.setCategory(.playback, mode: .measurement, policy: AVAudioSession.RouteSharingPolicy.default, options: .allowAirPlay)
////                try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
//            try audioSession.setActive(true)
//            print(audioSession.currentRoute)
//            print(AVAudioSession.sharedInstance().currentRoute)
//            print(AVAudioSessionRouteDescription.self)
//            print("success")
//
//        } catch {
//            print("Failed to set audio session category.")
//        }
//    }
//
//    func systemAVAVolume() {
//        systemAVAOutputVolume = AVAudioSession.sharedInstance().outputVolume
//        print(systemAVAOutputVolume)
//    }
//}
//
//
