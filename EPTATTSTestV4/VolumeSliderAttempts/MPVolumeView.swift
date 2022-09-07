//
//  MPVolumeView.swift
//  ButtonEventTesting
//
//  Created by Jeffrey Jaskunas on 8/15/22.
//

//import SwiftUI
//import UIKit
//import MediaPlayer
//
//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print(AVAudioSession.sharedInstance().outputVolume)
//    }
//    
//    @IBAction func setVolumeButton (_ sender: Any) {
//        MPVolumeView.setVolume(0.5)
//    }
//}
//
//
//
//
//
//extension MPVolumeView {
//    static func setVolume(_ volume: Float) {
//        let volumeView = MPVolumeView()
//        let slider = volumeView.subviews.first(where: {$0 is UISlider}) as! UISlider
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            slider.value = volume
//            
//            print(AVAudioSession.sharedInstance().outputVolume)Volume
//        }
//    }
//}
