//
//  FailedEnvDataObjectModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/9/22.
//

/*
 // Failed Attempt on 08/09/2022
 import Foundation
 import SwiftUI
 import CoreMedia
 import QuartzCore
 import AudioToolbox
 import AVFAudio
 import AVFoundation
 import AVKit
 import Darwin
 import Security
 import Combine


 @MainActor class EnvDataObjectModel: ObservableObject {
     enum SampleErrors: Error {
         case notFound
         case unexpected(code: Int)
     }
     
     @Published nonisolated var index: Int = 0
     @Published nonisolated var indexForTest = [Int]()
     @Published nonisolated var heardArray: [Int] = [Int]()
     @Published nonisolated var samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
     @Published nonisolated var sampleType: String = ".wav"
     @Published nonisolated var pan: Int = 1        // 0 = Left , 1 = Middle, 2 = Right
     @Published nonisolated var testGain: Float = 0.2
     @Published nonisolated var testCount = [Int]()
     @Published nonisolated var playing = Int()    // Playing = 1. Stopped = -1
     @Published nonisolated var heardLastIndex = Int()
     
     
     @MainActor @Published var testPan = [Int]()
     @MainActor @Published var testTestGain = [Float]()
     @MainActor @Published var frequency = [String]()
     @MainActor @Published var testStartSystem = [UInt64]()
     @MainActor @Published var testStartSeconds = [Float64]()
     @MainActor @Published var testEndSystem = [UInt64]()
     @MainActor @Published var testEndSeconds = [Float64]()
     @MainActor @Published var userRespCMSystem = [UInt64]()
     @MainActor @Published var userRespCMSeconds = [Float64]()
     
     
     //Clock Variables
     @MainActor @Published var currentTimeMach: UInt64
     @MainActor @Published var currentTimeMedia: CFTimeInterval
     @MainActor @Published var masterClock = CMClockGetHostTimeClock()
     
     //Audio Player
     @State nonisolated var testPlayer: AVAudioPlayer?
     
     init(){
         currentTimeMach =  mach_absolute_time()
         currentTimeMedia = CACurrentMediaTime()
         let masterClock = CMClockGetHostTimeClock()
         CMClockGetTime(masterClock)
     }
     

     
 // MARK: - AudioPlayer Methods
     
 //    func setTestGain(_ testGain: Float) {
 //        testPlayer!.setVolume(testGain, fadeDuration: 0)
 //    }

     nonisolated func loadAndTestPresentation(sample: String, gain: Float, pan: Int ) {
         do{
             let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
             guard let urlSample = urlSample else {
                 return print(SampleErrors.notFound)
             }
             testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
             guard let testPlayer = testPlayer else {
                 return
             }
             testPlayer.prepareToPlay()
     // Set Gain for Playback
             testPlayer.setVolume(testGain, fadeDuration: 0)
     // Start Playback
             testPlayer.play()
         } catch {
             print("Error in playerSessionSetUp Function Execution")
         }
     }
     
     nonisolated func stop() {
         do{
             let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
             guard let urlSample = urlSample else {
                 return print(SampleErrors.notFound)
             }
             testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
             guard let testPlayer = testPlayer else {
                 return
             }
             testPlayer.stop()
         } catch {
             print("Error in Player Stop Function")
         }
     }
     
     nonisolated func playTesting() {
         do{
             let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
             guard let urlSample = urlSample else {
                 return print(SampleErrors.notFound)
             }
             testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
             guard let testPlayer = testPlayer else {
                 return
             }
             while testPlayer.isPlaying == true {
                 if heardArray.count > 1 && heardArray.index(after: indexForTest.count-1) == 1 {
                 testPlayer.stop()
                 print("Stopped in While")
                 }
             }
             testPlayer.stop()
             print("Naturally Stopped")
         } catch {
             print("Error in playTesting")
         }
     }
     
     
     

 //MARK: -HeardArray Methods

     nonisolated func responseHeardArray() async {
         heardArray.append(1)
     }
     
     nonisolated func returnHeardArrayLast() -> [Int] {
         return heardArray
     }

     
     nonisolated func heardArrayNormalize() async {
 //        let indexForTestCount = indexForTest.count
 //        let heardArrayCount = heardArray.count
         if heardArray.last == nil && heardArray.count <= 1 {
             heardArray.append(0)
             print("Starting Test, First Append(0) to Heard Array if No Response")
         } else if indexForTest.count - heardArray.count == 1 && heardArray.index(after: indexForTest.count-1) != 1 {
             heardArray.append(0)
             print("Append(0) to Heard Array for Assumed No Response")
         } else {
             print("Critial Error in Heard Array Count and or Values")
         }
     }
     
     
 // MARK: -Logging Methods
     func preEventLogging() async {
         // Initialize Time Clock
         CMClockGetTime(masterClock)
         CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         // Initial Time Stamp
         let iTS1 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         let iTS2 = CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         testStartSystem.append(iTS1) //System Unit Time
         testStartSeconds.append(iTS2)   //Seconds Time
         // Pre Event Logging
         indexForTest.append(index)
         testPan.append(pan)         // 0 = Left , 1 = Middle, 2 = Right
         testTestGain.append(testGain)
         frequency.append(samples[0])
     }
     

     
     func postEventLogging() async {
         CMClockGetTime(masterClock)
         let pEL1 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         let peL2 = CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         testEndSystem.append(pEL1)
         testEndSeconds.append(peL2)
     }
     
     func nonHeardEventLogging() async {
         let reducedCount = testCount.count
         let count = reducedCount + 1
         testCount.append(count)
         userRespCMSystem.append(1000000000001)
         userRespCMSeconds.append(9.9)
         print("heardArray Update Not registered")
     }
     
     func heardEventLogging() async {
         let reducedCount = testCount.count
         let count = reducedCount + 1
         testCount.append(count)
         let Y: UInt64 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         print(Y)
         let y: Float64 = CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
         print(y)
         userRespCMSystem.replaceSubrange(heardArray.count-1...heardArray.count-1, with: [Y])
         userRespCMSeconds.replaceSubrange(heardArray.count-1...heardArray.count-1, with: [y])
         print("hearArray update caught")
     }
     
     func heardNotHeardEventLogging() async {
         if heardArray.last == nil || heardArray.last == 0 {
             userRespCMSystem.append(1000000000001)
             userRespCMSeconds.append(9.9)
             print("heardArray Not Updated, No Click")
         } else {
             let Y: UInt64 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
             print(Y)
             let y: Float64 = CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
             print(y)
             userRespCMSystem.replaceSubrange(heardArray.count-1...heardArray.count-1, with: [Y])
             userRespCMSeconds.replaceSubrange(heardArray.count-1...heardArray.count-1, with: [y])
             print("hearArray update caught")
         }
     }
     
     func reduceHeardEventLogging() async {
         userRespCMSystem.remove(at: userRespCMSystem.count-1)
         userRespCMSeconds.remove(at: userRespCMSeconds.count-1)
     }

     func arrayTesting() async {
         let arraySet1 = Int(testStartSystem.count) - Int(testStartSeconds.count) + Int(testEndSystem.count) - Int(testEndSeconds.count)
         let arraySet2 = Int(userRespCMSeconds.count) - Int(userRespCMSystem.count) + Int(testPan.count) - Int(testTestGain.count)
         let arraySet3 = Int(frequency.count) - Int(frequency.count)
         if arraySet1 + arraySet2 + arraySet3 == 0 {
             print("All Event Logs Match")
         } else {
             print("Error Event Logs Length Error")
         }
     }

     func printData () async {
         print(heardArray)
         print(testStartSystem)
         print(testStartSeconds)
         print(testEndSystem)
         print(testEndSeconds)
         print(userRespCMSystem)
         print(userRespCMSeconds)
         print(testPan)
         print(testTestGain)
         print(frequency)
         print(heardArray)
         print(userRespCMSystem)
         print(userRespCMSeconds)
         print(testCount)
     }
     
 }

 */
