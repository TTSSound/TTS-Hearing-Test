//
//  Bilateral1kHzTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/7/22.
//

import SwiftUI
import Foundation
import AVFAudio
import AVFoundation
import AVKit
import CoreMedia
import Darwin
import Security
import Combine
import CoreData
import CodableCSV
//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift
//import Firebase
//import FileProvider
//import Alamofire


struct onekHzSaveFinalResults: Codable {  // This is a model
    var jsonName = String()
    var jsonAge = Int()
    var jsonSex = Int()
    var jsonEmail = String()
    var json1kHzRightEarHL = Float()
    var json1kHzLeftEarHL = Float()
    var json1kHzIntraEarDeltaHL = Float()
    var jsonPhonCurve = Int()
    var jsonReferenceCurve = Int()
    var jsonSystemVoluem = Float()
    var jsonActualFrequency = Double()
    var jsonFrequency: [String]
    var jsonPan: [Float]
    var jsonStoredIndex: [Int]
    var jsonStoredTestPan: [Float]
    var jsonStoredTestTestGain: [Float]
    var jsonStoredTestCount: [Int]
    var jsonStoredHeardArray: [Int]
    var jsonStoredReversalHeard: [Int]
    var jsonStoredFirstGain: [Float]
    var jsonStoredSecondGain: [Float]
    var jsonStoredAverageGain: [Float]
}


struct Bilateral1kHzTestView: View {
    
    enum onekHzSampleErrors: Error {
        case onekHznotFound
        case onekHzunexpected(code: Int)
    }
    
    enum onekHzFirebaseErrors: Error {
        case onekHzunknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()

    @State var onekHzlocalHeard = 0
    @State var onekHzlocalPlaying = Int()    // Playing = 1. Stopped = -1
    @State var onekHzlocalReversal = Int()
    @State var onekHzlocalReversalEnd = Int()
    @State var onekHzlocalMarkNewTestCycle = Int()
    @State var onekHztestPlayer: AVAudioPlayer?
    
    @State var onekHzlocalTestCount = 0
    @State var onekHzlocalStartingNonHeardArraySet: Bool = false
    @State var onekHzlocalReversalHeardLast = Int()
    @State var onekHzlocalSeriesNoResponses = Int()
    @State var onekHzfirstHeardResponseIndex = Int()
    @State var onekHzfirstHeardIsTrue: Bool = false
    @State var onekHzsecondHeardResponseIndex = Int()
    @State var onekHzsecondHeardIsTrue: Bool = false
    @State var onekHzstartTooHigh = 0
    
            //!!!!Changes
            @State var onekHzfirstGain = Float()
            @State var onekHzsecondGain = Float()
            
            @State var onekHzfirstGainRight1 = Float()
            @State var onekHzsecondGainRight1 = Float()
            @State var onekHzfirstGainRight2 = Float()
            @State var onekHzsecondGainRight2 = Float()
//            @State var onekHzfirstGainRightRepeat1 = Float()
//            @State var onekHzsecondGainRightRepeat1 = Float()
//            @State var onekHzfirstGainRightRepeat2 = Float()
//            @State var onekHzsecondGainRightRepeat2 = Float()
            @State var onekHzfirstGainLeft1 = Float()
            @State var onekHzsecondGainLeft1 = Float()
            @State var onekHzfirstGainLeft2 = Float()
            @State var onekHzsecondGainLeft2 = Float()
//            @State var onekHzfirstGainLeftRepeat1 = Float()
//            @State var onekHzsecondGainLeftRepeat1 = Float()
//            @State var onekHzfirstGainLeftRepeat2 = Float()
//            @State var onekHzsecondGainLeftRepeat2 = Float()
            
            @State var onekHz_rightFirstSecondGainArray: [Float] = [Float]()
            @State var onekHz_leftFirstSecondGainArray: [Float] = [Float]()
    
//            @State var oneRightEntered: Bool = false
//            @State var oneLeftEntered: Bool = false
    
            @State var needToRepeatTesting: Bool = false
    
            @State var onekHzRightSorted: [Float] = [Float]()
            @State var onekHzLeftSorted: [Float] = [Float]()
            @State var onekHzIntraEarDeltaHL1 = Float()
            @State var onekHzIntraEarDeltaHL2 = Float()
            @State var onekHzIntraEarDeltaHLFinal = Float()
           
            @State var onekHzFinalLRGains1: [Float] = [Float]()
            @State var onekHzFinalLRGains2: [Float] = [Float]()
            @State var onekHzInterimLRGainsFinal: [Float] = [Float]()
            @State var onekHzFinalComboLRGains: [Float] = [Float]()
    
            @State var repeatArraysWiped: Bool = false
       
            //!!!!Changes
    
    
    
    @State var onekHzendTestSeries: Bool = false
    @State var onekHzshowTestCompletionSheet: Bool = false
    
//    @State var onekHz_samples: [String] = ["Sample0", "Sample1", "Sample0", "Sample1","Sample0", "Sample1", "Sample0", "Sample1"]
    
            //!!!!!!Changes
            @State var onekHz_samples: [String] = ["Sample0", "Sample0", "Sample0", "Sample0","Sample0", "Sample0", "Sample0", "Sample0"]
            @State var onekHz_panSettingArray: [Float] = [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0]    // -1.0 = Left , 0.0 = Middle, 1.0 = Right
            @State var pan: Float = 1.0
            //!!!!! Changes Above
    
    @State var onekHz_index: Int = 0
    @State var onekHz_testGain: Float = 0.2
    @State var onekHz_heardArray: [Int] = [Int]()
    @State var onekHz_indexForTest = [Int]()
    @State var onekHz_testCount: [Int] = [Int]()
    
            //!!!!!Changes
            @State var onekHz_pan: Float = Float()   // -1.0 = Left , 0.0 = Middle, 1.0 = Right
            @State var onekHz_testPan = [Float]()  // -1.0 = Left , 0.0 = Middle, 1.0 = Right
            //!!!Changes Above
    
    
    @State var onekHz_testTestGain = [Float]()
    @State var onekHz_frequency = [String]()
    @State var onekHz_reversalHeard = [Int]()
    @State var onekHz_reversalGain = [Float]()
//    @State var onekHz_reversalFrequency = [String]()
    @State var onekHz_reversalDirection = Float()
    @State var onekHz_reversalDirectionArray = [Float]()

    //!!!Changes
    @State var onekHz_averageGain = Float()
    @State var onekHz_averageGainRight = Float()
    @State var onekHz_averageGainLeft = Float()
    
    @State var onekHz_averageGainRight1 = Float()
    @State var onekHz_averageGainRight2 = Float()
//    @State var onekHz_averageGainRightRepeat1 = Float()
//    @State var onekHz_averageGainRightRepeat2 = Float()
    @State var onekHz_averageGainRightArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainRightArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainRightArray = Float()
    @State var onekHz_idxlastAverageGainRightArray = Float()
    
    @State var onekHz_averageGainLeft1 = Float()
    @State var onekHz_averageGainLeft2 = Float()
//    @State var onekHz_averageGainLeftRight1 = Float()
//    @State var onekHz_averageGainLeftRepeat2 = Float()
    @State var onekHz_averageGainLeftArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainLeftArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainLeftArray = Float()
    @State var onekHz_idxlastAverageGainLeftArray = Float()
    
    @State var onekHz_HoldingLowestRightGainArray: [Float] = [Float]()
    @State var onekHz_HoldingLowestLeftGainArray: [Float] = [Float]()

    
    //!!!!Changes
    

    @State var onekHz_eptaSamplesCount = Int() // 3 //17

    //These are/were csv json logging variables. No longer in code, but can be added back int
    @State var onekHz_finalStoredIndex: [Int] = [Int]()
    @State var onekHz_finalStoredTestPan: [Float] = [Float]()
    @State var onekHz_finalStoredTestTestGain: [Float] = [Float]()
    @State var onekHz_finalStoredFrequency: [String] = [String]()
    @State var onekHz_finalStoredTestCount: [Int] = [Int]()
    @State var onekHz_finalStoredHeardArray: [Int] = [Int]()
    @State var onekHz_finalStoredReversalHeard: [Int] = [Int]()
    @State var onekHz_finalStoredFirstGain: [Float] = [Float]()
    @State var onekHz_finalStoredSecondGain: [Float] = [Float]()
    
            //!!!Changes
            @State var onekHz_finalStoredAverageGain: [Float] = [Float]()
            
//            @State var onekHz_finalStoredAverageGainRight1: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainRight2: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainRightRepeat1: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainRightRepeat2: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainLeft1: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainLeft2: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainLeftRight1: [Float] = [Float]()
//            @State var onekHz_finalStoredAverageGainLeftRepeat2: [Float] = [Float]()
            //!!!!Changes
            
    
    @State var onekHzidxForTest = Int() // = onekHz_indexForTest.count
    @State var onekHzidxForTestNet1 = Int() // = onekHz_indexForTest.count - 1
//    @State var onekHzidxTestCount = Int() // = onekHz_TestCount.count
    @State var onekHzidxTestCountUpdated = Int() // = onekHz_TestCount.count + 1
    @State var onekHzactiveFrequency = String()
    @State var onekHzidxHA = Int()    // idx = onekHz_heardArray.count
    @State var onekHzidxReversalHeardCount = Int()
    @State var onekHzidxHAZero = Int()    //  idxZero = idx - idx
    @State var onekHzidxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var onekHzisCountSame = Int()
    @State var onekHzheardArrayIdxAfnet1 = Int()
    @State var onekHztestIsPlaying: Bool = false
    @State var onekHzplayingString: [String] = ["", "Start or Restart Test", "Great Job, You've\nCompleted This Test Segment"]
    @State var onekHzplayingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    @State var onekHzplayingStringColorIndex = 0
    @State var onekHzuserPausedTest: Bool = false
    
    @State var RightEar1kHzdB1 = Float()
    @State var RightEar1kHzdB2 = Float()
    @State var LeftEar1kHzdB1 = Float()
    @State var LeftEar1kHzdB2 = Float()
    @State var RightEar1kHzdBFinal = Float()
    @State var LeftEar1kHzdBFinal = Float()

    let fileonekHzName = "SummaryonekHzResults.json"
    let summaryonekHzCSVName = "SummaryonekHzResultsCSV.csv"
    let detailedonekHzCSVName = "DetailedonekHzResultsCSV.csv"
    let inputonekHzSummaryCSVName = "InputSummaryonekHzResultsCSV.csv"
    let inputonekHzDetailedCSVName = "InputDetailedonekHzResultsCSV.csv"
    
    @State var onekHzsaveFinalResults: onekHzSaveFinalResults? = nil

    let onekHzheardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let onekHzarrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let onekHzaudioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let onekHzpreEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    var body: some View {
 
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .top, startRadius: -10, endRadius: 300).ignoresSafeArea()
        VStack {
                Spacer()
            Text("Bilateral 1kHz Test")
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.bottom, 40)
                HStack {
                    Spacer()
                    Text(String(onekHz_testGain))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    Spacer()
                    Text(String(onekHz_index))
//                    Text(String(onekHz_pan))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    Spacer()
                    Button {
                        onekHz_heardArray.removeAll()
                        onekHzpauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        onekHzlocalPlaying = 1
                        onekHzuserPausedTest = false
                        onekHzplayingStringColorIndex = 0
                        print("Start Button Clicked. Playing = \(onekHzlocalPlaying)")
                    } label: {
                        Text(onekHzplayingString[onekHzplayingStringColorIndex])
                            .foregroundColor(onekHzplayingStringColor[onekHzplayingStringColorIndex])
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("Click to Stat Test")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.blue)
                        .onTapGesture {
                            Task(priority: .userInitiated) {
                                audioSessionModel.setAudioSession()
                                onekHzlocalPlaying = 1
                                print("Start Button Clicked. Playing = \(onekHzlocalPlaying)")
                            }
                        }
                    Spacer()
                    Button {
                        onekHzlocalPlaying = 0
                        onekHzstop()
                        onekHzuserPausedTest = true
                        onekHzplayingStringColorIndex = 1
                        onekHzaudioThread.async {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.async {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                    } label: {
                        Text("Pause Test")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
     
            
            Spacer()
            Text("Press if You Hear The Tone")
                .fontWeight(.semibold)
                .padding()
                .frame(width: 300, height: 100, alignment: .center)
                .background(Color .green)
                .foregroundColor(.black)
                .cornerRadius(300)
                .onTapGesture(count: 1) {
                    onekHzheardThread.async{ self.onekHzlocalHeard = 1
                    }
                }
            Spacer()
            }
            .fullScreenCover(isPresented: $onekHzshowTestCompletionSheet, content: {
                VStack(alignment: .leading) {
    
                    Button(action: {
                        onekHzshowTestCompletionSheet.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .padding(10)
                            .foregroundColor(.red)
                    })
                    Spacer()
                    Text("Take a moment for a break before exiting to continue with the next test segment")
                        .foregroundColor(.blue)
                        .font(.title)
                        .padding()
                }
            })
        }
        .onChange(of: onekHztestIsPlaying, perform: { onekHztestBoolValue in
            if onekHztestBoolValue == true && onekHzendTestSeries == false {
            //User is starting test for first time
                audioSessionModel.setAudioSession()
                onekHzlocalPlaying = 1
                onekHzplayingStringColorIndex = 0
                onekHzuserPausedTest = false
            } else if onekHztestBoolValue == false && onekHzendTestSeries == false {
            // User is pausing test for firts time
                onekHzstop()
                onekHzlocalPlaying = 0
                onekHzplayingStringColorIndex = 1
                onekHzuserPausedTest = true
            } else if onekHztestBoolValue == true && onekHzendTestSeries == true {
                onekHzstop()
                onekHzlocalPlaying = -1
                onekHzplayingStringColorIndex = 2
                onekHzuserPausedTest = true
            } else {
                print("Critical error in pause logic")
            }
        })
        // This is the lowest CPU approach from many, many tries
        .onChange(of: onekHzlocalPlaying, perform: { onekHzplayingValue in
            onekHzactiveFrequency = onekHz_samples[onekHz_index]
            onekHzlocalHeard = 0
            onekHzlocalReversal = 0
            if onekHzplayingValue == 1{
                
                onekHzSetPan()
                
                onekHzaudioThread.async {
                    onekHzloadAndTestPresentation(sample: onekHzactiveFrequency, gain: onekHz_testGain, pan: onekHz_pan)
                    while onekHztestPlayer!.isPlaying == true && self.onekHzlocalHeard == 0 { }
                    if onekHzlocalHeard == 1 {
                        onekHztestPlayer!.stop()
                        print("Stopped in while if: Returned Array \(onekHzlocalHeard)")
                    } else {
                        onekHztestPlayer!.stop()
                    self.onekHzlocalHeard = -1
                    print("Stopped naturally: Returned Array \(onekHzlocalHeard)")
                    }
                }
                onekHzpreEventThread.async {
                    onekHzpreEventLogging()
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                    if self.onekHzlocalHeard == 1 {
                        onekHzlocalTestCount += 1
                        Task(priority: .userInitiated) {
                            await onekHzresponseHeardArray()      //onekHz_heardArray.append(1)
                            await onekHzlocalResponseTracking()
                            await onekHzSetHeardIndicies()
                            await onekHzcount()
                            await onekHzlogNotPlaying()           //onekHz_playing = -1
                            await onekHzresetPlaying()
                            await onekHzresetHeard()
                            await onekHzresetNonResponseCount()
                            await onekHzcreateReversalHeardArray()
                            await onekHzcreateReversalGainArray()
                            await onekHzcheckHeardReversalArrays()
                            await onekHzreversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    }
                    else if onekHz_heardArray.last == nil || self.onekHzlocalHeard == -1 {
                        onekHzlocalTestCount += 1
                        Task(priority: .userInitiated) {
                            await onekHzheardArrayNormalize()
                            await onekHzcount()
                            await onekHzlogNotPlaying()   //self.onekHz_playing = -1
                            await onekHzresetPlaying()
                            await onekHzresetHeard()
                            await onekHznonResponseCounting()
                            await onekHzcreateReversalHeardArray()
                            await onekHzcreateReversalGainArray()
                            await onekHzcheckHeardReversalArrays()
                            await onekHzreversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change    event
                        }
                    } else {
                        onekHzlocalTestCount = 1
                        Task(priority: .background) {
                            await onekHzresetPlaying()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(onekHz_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: onekHzlocalReversal) { onekHzreversalValue in
            if onekHzreversalValue == 1 {
                DispatchQueue.global(qos: .background).async {
                    Task(priority: .userInitiated) {
                        await onekHzreversalDirection()
                        await onekHzreversalComplexAction()
                        await onekHzComplexLogging()
                        await assignInterimLRGains()
                        await assignFinalLRGains()
                        await mustRepeatTesting()
                        await printOnekHzArrays()
                        await printAverageGainsRightLeft()
                        await onekHzendTestSeries()
                        await onekHznewTestCycle()
                        await onekHzwipeArraysForRepeat()
                        await onekHzrestartPresentation()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
    }
 
    
//MARK: - AudioPlayer Methods
    
    func onekHzpauseRestartTestCycle() {
        onekHzlocalMarkNewTestCycle = 0
        onekHzlocalReversalEnd = 0
        onekHz_index = onekHz_index
        onekHz_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        onekHztestIsPlaying = false
        onekHzlocalPlaying = 0
        onekHz_testCount.removeAll()
        onekHz_reversalHeard.removeAll()
        onekHz_averageGain = Float()
        onekHz_reversalDirection = Float()
        onekHzlocalStartingNonHeardArraySet = false
        onekHzfirstHeardResponseIndex = Int()
        onekHzfirstHeardIsTrue = false
        onekHzsecondHeardResponseIndex = Int()
        onekHzsecondHeardIsTrue = false
        onekHzlocalTestCount = 0
        onekHzlocalReversalHeardLast = Int()
        onekHzstartTooHigh = 0
    }
  
    func onekHzSetPan() {
        onekHz_pan = onekHz_panSettingArray[onekHz_index]
        print("Pan: \(onekHz_pan)")
    }
    
    func onekHzloadAndTestPresentation(sample: String, gain: Float, pan: Float) {
          do{
              let onekHzurlSample = Bundle.main.path(forResource: onekHzactiveFrequency, ofType: ".wav")
              guard let onekHzurlSample = onekHzurlSample else { return print(onekHzSampleErrors.onekHznotFound) }
              onekHztestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: onekHzurlSample))
              guard let onekHztestPlayer = onekHztestPlayer else { return }
              onekHztestPlayer.prepareToPlay()    // Test Player Prepare to Play
              onekHztestPlayer.setVolume(onekHz_testGain, fadeDuration: 0)      // Set Gain for Playback
              onekHztestPlayer.pan = onekHz_pan
              onekHztestPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func onekHzstop() {
      do{
          let onekHzurlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let onekHzurlSample = onekHzurlSample else { return print(onekHzSampleErrors.onekHznotFound) }
          onekHztestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: onekHzurlSample))
          guard let onekHztestPlayer = onekHztestPlayer else { return }
          onekHztestPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    func playTesting() async {
        do{
            let onekHzurlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
            guard let onekHzurlSample = onekHzurlSample else {
                return print(onekHzSampleErrors.onekHznotFound) }
            onekHztestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: onekHzurlSample))
            guard let onekHztestPlayer = onekHztestPlayer else { return }
            while onekHztestPlayer.isPlaying == true {
                if onekHz_heardArray.count > 1 && onekHz_heardArray.index(after: onekHz_indexForTest.count-1) == 1 {
                    onekHztestPlayer.stop()
                print("Stopped in While") }
            }
            onekHztestPlayer.stop()
            print("Naturally Stopped")
        } catch { print("Error in playTesting") }
    }
    
    func onekHzresetNonResponseCount() async {onekHzlocalSeriesNoResponses = 0 }
    
    func onekHznonResponseCounting() async {onekHzlocalSeriesNoResponses += 1 }
     
    func onekHzresetPlaying() async { self.onekHzlocalPlaying = 0 }
    
    func onekHzlogNotPlaying() async { self.onekHzlocalPlaying = -1 }
    
    func onekHzresetHeard() async { self.onekHzlocalHeard = 0 }
    
    func onekHzreversalStart() async { self.onekHzlocalReversal = 1}
  
    func onekHzpreEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//        DispatchQueue.global(qos: .userInitiated).async {
            onekHz_indexForTest.append(onekHz_index)
        }
        DispatchQueue.global(qos: .default).async {
            onekHz_testTestGain.append(onekHz_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            onekHz_frequency.append(onekHzactiveFrequency)
            onekHz_testPan.append(onekHz_pan)         // 0 = Left , 1 = Middle, 2 = Right
        }
    }
    
  
//MARK: -HeardArray Methods
    
    func onekHzresponseHeardArray() async {
        onekHz_heardArray.append(1)
      self.onekHzidxHA = onekHz_heardArray.count
      self.onekHzlocalStartingNonHeardArraySet = true
    }

    func onekHzlocalResponseTracking() async {
        if onekHzfirstHeardIsTrue == false {
            onekHzfirstHeardResponseIndex = onekHzlocalTestCount
            onekHzfirstHeardIsTrue = true
        } else if onekHzfirstHeardIsTrue == true {
            onekHzsecondHeardResponseIndex = onekHzlocalTestCount
            onekHzsecondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
    
    func onekHzSetHeardIndicies() async {
        
        if onekHz_pan == 1.0 {
            if onekHzfirstGainRight1 <= 0.0 {
                onekHzfirstGainRight1 = onekHz_testGain
            } else if onekHzfirstGainRight1 > 0.0 && onekHzsecondGainRight1 <= 0.0 {
                onekHzsecondGainRight1 = onekHz_testGain
                onekHzsecondHeardIsTrue = true
            } else if onekHzsecondGainRight1 > 0.0 && onekHzfirstGainRight2 <= 0.0 {
                onekHzfirstGainRight2 = onekHz_testGain
            } else if onekHzfirstGainRight2 > 0.0 && onekHzsecondGainRight2 <= 0.0 {
                onekHzsecondGainRight2 = onekHz_testGain
                onekHzsecondHeardIsTrue = true
            } else {
                print("!!!Fatal error in pan=1.0 onekHzSetHeardIndicies() logic")
            }
        } else if onekHz_pan == -1.0 {
            if onekHzfirstGainLeft1 <= 0.0 {
                onekHzfirstGainLeft1 = onekHz_testGain
            } else if onekHzfirstGainLeft1 > 0.0 && onekHzsecondGainLeft1 <= 0.0 {
                onekHzsecondGainLeft1 = onekHz_testGain
                onekHzsecondHeardIsTrue = true
            } else if onekHzsecondGainLeft1 > 0.0 && onekHzfirstGainLeft2 <= 0.0 {
                onekHzfirstGainLeft2 = onekHz_testGain
            } else if onekHzfirstGainLeft2 > 0.0 && onekHzsecondGainLeft2 <= 0.0 {
                onekHzsecondGainLeft2 = onekHz_testGain
                onekHzsecondHeardIsTrue = true
            } else {
                print("!!!Fatal error in pan= -1.0 onekHzSetHeardIndicies() logic")
            }
        } else {
            print("Fatal error in onekHzSetHeardIndicies() logic hit master else")
        }
        
    }
    
//MARK: - THIS FUNCTION IS CAUSING ISSUES IN HEARD ARRAY. THE ISSUE IS THE DUAL IF STRUCTURE, NOT LINKED BY ELSE IF
    func onekHzheardArrayNormalize() async {
        onekHzidxHA = onekHz_heardArray.count
        onekHzidxForTest = onekHz_indexForTest.count
        onekHzidxForTestNet1 = onekHzidxForTest - 1
        onekHzisCountSame = onekHzidxHA - onekHzidxForTest
        onekHzheardArrayIdxAfnet1 = onekHz_heardArray.index(after: onekHzidxForTestNet1)
      
        if onekHzlocalStartingNonHeardArraySet == false {
            onekHz_heardArray.append(0)
            self.onekHzlocalStartingNonHeardArraySet = true
            onekHzidxHA = onekHz_heardArray.count
            onekHzidxHAZero = onekHzidxHA - onekHzidxHA
            onekHzidxHAFirst = onekHzidxHAZero + 1
            onekHzisCountSame = onekHzidxHA - onekHzidxForTest
            onekHzheardArrayIdxAfnet1 = onekHz_heardArray.index(after: onekHzidxForTestNet1)
        } else if onekHzlocalStartingNonHeardArraySet == true {
            if onekHzisCountSame != 0 && onekHzheardArrayIdxAfnet1 != 1 {
                onekHz_heardArray.append(0)
                onekHzidxHA = onekHz_heardArray.count
                onekHzidxHAZero = onekHzidxHA - onekHzidxHA
                onekHzidxHAFirst = onekHzidxHAZero + 1
                onekHzisCountSame = onekHzidxHA - onekHzidxForTest
                onekHzheardArrayIdxAfnet1 = onekHz_heardArray.index(after: onekHzidxForTestNet1)

            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
        } else {
            print("Critial Error in Heard Array Count and or Values")
        }
    }
      
// MARK: -Logging Methods
    func onekHzcount() async {
        onekHzidxTestCountUpdated = onekHz_testCount.count + 1
        onekHz_testCount.append(onekHzidxTestCountUpdated)
    }

//struct Bilateral1kHzTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        Bilateral1kHzTestView()
//    }
//}


    
    func onekHzprintData () async {
        DispatchQueue.global(qos: .background).async {
            print("Start printData)(")
            print("--------Array Values Logged-------------")
            print("testPan: \(onekHz_testPan)")
            print("testTestGain: \(onekHz_testTestGain)")
            print("frequency: \(onekHz_frequency)")
            print("testCount: \(onekHz_testCount)")
            print("heardArray: \(onekHz_heardArray)")
            print("---------------------------------------")
        }
    }
}

//MARK: - 1kHz Reversal Extension
extension Bilateral1kHzTestView {

    enum onekHzLastErrors: Error {
        case onekHzlastError
        case onekHzlastUnexpected(code: Int)
    }

    func onekHzcreateReversalHeardArray() async {
        onekHz_reversalHeard.append(onekHz_heardArray[onekHzidxHA-1])
        self.onekHzidxReversalHeardCount = onekHz_reversalHeard.count
    }
        
    func onekHzcreateReversalGainArray() async {
        onekHz_reversalGain.append(onekHz_testTestGain[onekHzidxHA-1])
    }
    
    func onekHzcheckHeardReversalArrays() async {
        if onekHzidxHA - onekHzidxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if onekHzidxHA - onekHzidxReversalHeardCount < 0 && onekHzidxHA - onekHzidxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    func onekHzreversalDirection() async {
        onekHzlocalReversalHeardLast = onekHz_reversalHeard.last ?? -999
        if onekHzlocalReversalHeardLast == 1 {
            onekHz_reversalDirection = -1.0
            onekHz_reversalDirectionArray.append(-1.0)
        } else if onekHzlocalReversalHeardLast == 0 {
            onekHz_reversalDirection = 1.0
            onekHz_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    func onekHzreversalOfOne() async {
        let onekHzrO1Direction = 0.01 * onekHz_reversalDirection
        let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHzr01NewGain > 0.00001 && onekHzr01NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr01NewGain * 100000) / 100000
        } else if onekHzr01NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr01NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func onekHzreversalOfTwo() async {
        let onekHzrO2Direction = 0.02 * onekHz_reversalDirection
        let onekHzr02NewGain = onekHz_testGain + onekHzrO2Direction
        if onekHzr02NewGain > 0.00001 && onekHzr02NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr02NewGain * 100000) / 100000
        } else if onekHzr02NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr02NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    func onekHzreversalOfThree() async {
        let onekHzrO3Direction = 0.03 * onekHz_reversalDirection
        let onekHzr03NewGain = onekHz_testGain + onekHzrO3Direction
        if onekHzr03NewGain > 0.00001 && onekHzr03NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr03NewGain * 100000) / 100000
        } else if onekHzr03NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr03NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    func onekHzreversalOfFour() async {
        let onekHzrO4Direction = 0.04 * onekHz_reversalDirection
        let onekHzr04NewGain = onekHz_testGain + onekHzrO4Direction
        if onekHzr04NewGain > 0.00001 && onekHzr04NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr04NewGain * 100000) / 100000
        } else if onekHzr04NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr04NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    func onekHzreversalOfFive() async {
        let onekHzrO5Direction = 0.05 * onekHz_reversalDirection
        let onekHzr05NewGain = onekHz_testGain + onekHzrO5Direction
        if onekHzr05NewGain > 0.00001 && onekHzr05NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr05NewGain * 100000) / 100000
        } else if onekHzr05NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr05NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    func onekHzreversalOfTen() async {
        let onekHzr10Direction = 0.10 * onekHz_reversalDirection
        let onekHzr10NewGain = onekHz_testGain + onekHzr10Direction
        if onekHzr10NewGain > 0.00001 && onekHzr10NewGain < 1.0 {
            onekHz_testGain = roundf(onekHzr10NewGain * 100000) / 100000
        } else if onekHzr10NewGain <= 0.0 {
            onekHz_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if onekHzr10NewGain >= 1.0 {
            onekHz_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    func onekHzreversalAction() async {
        if onekHzlocalReversalHeardLast == 1 {
            await onekHzreversalOfFive()
        } else if onekHzlocalReversalHeardLast == 0 {
            await onekHzreversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func onekHzreversalComplexAction() async {
        print("Start onekHzreversalComplexAction()")
        print("**************************************")
        print("onekHzidxReversalHeardCount: \(onekHzidxReversalHeardCount)")
        print("onekHzidxHA: \(onekHzidxHA)")
        print("onekHzsecondHeardIsTrue: \(onekHzsecondHeardIsTrue)")
        print("onekHzsecondHeardIsTrue: \(onekHzsecondHeardIsTrue)")
        print("onekHzsecondHeardResponseIndex: \(onekHzsecondHeardResponseIndex)")
        print("onekHzfirstHeardResponseIndex: \(onekHzfirstHeardResponseIndex)")
        print("onekHzlocalSeriesNoResponses: \(onekHzlocalSeriesNoResponses)")
        print("onekHz_reversalHeard: \(onekHz_reversalHeard)")
        print("************************************")
        
        if onekHzidxReversalHeardCount <= 1 && onekHzidxHA <= 1 {
            await onekHzreversalAction()
        }  else if onekHzidxReversalHeardCount == 2 {
            if onekHzidxReversalHeardCount == 2 && onekHzsecondHeardIsTrue == true {
                await onekHzstartTooHighCheck()
            } else if onekHzidxReversalHeardCount == 2  && onekHzsecondHeardIsTrue == false {
                await onekHzreversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if onekHzidxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if onekHzsecondHeardResponseIndex - onekHzfirstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if onekHzlocalSeriesNoResponses == 3 {
                await onekHzreversalOfTen()
            } else if onekHzlocalSeriesNoResponses == 2 {
                await onekHzreversalOfFour()
            } else {
                await onekHzreversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    func onekHzprintReversalGain() async {
        print("Start onekHzprintReversalGain()")
        DispatchQueue.global(qos: .background).async {
            print("New Gain: \(onekHz_testGain)")
            print("Reversal Direcction: \(onekHz_reversalDirection)")
        }
    }
    
    func onekHzreversalHeardCount1() async {
        print("Start onekHzreversalHeardCount1()")
       await onekHzreversalAction()
   }
            
    func onekHzcheck2PositiveSeriesReversals() async {
        print("Start onekHzcheck2PositiveSeriesReversals()")
        if onekHz_reversalHeard[onekHzidxHA-2] == 1 && onekHz_reversalHeard[onekHzidxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }

    func onekHzcheckTwoNegativeSeriesReversals() async {
        print("start onekHzcheckTwoNegativeSeriesReversals()")
        if onekHz_reversalHeard.count >= 3 && onekHz_reversalHeard[onekHzidxHA-2] == 0 && onekHz_reversalHeard[onekHzidxHA-1] == 0 {
            await onekHzreversalOfFour()
        } else {
            await onekHzreversalAction()
        }
    }
    
    func onekHzstartTooHighCheck() async {
        print(" Start onekHzstartTooHighCheck()")
        if onekHzstartTooHigh == 0 && onekHzfirstHeardIsTrue == true && onekHzsecondHeardIsTrue == true {
            onekHzstartTooHigh = 1
            await onekHzreversalOfTen()
            await onekHzresetAfterTooHigh()
            print("Too High Found")
        } else {
            await onekHzreversalAction()
        }
    }
    
    func onekHzresetAfterTooHigh() async {
        onekHzfirstHeardResponseIndex = Int()
        onekHzfirstHeardIsTrue = false
        onekHzsecondHeardResponseIndex = Int()
        onekHzsecondHeardIsTrue = false
    }

    func onekHzreversalsCompleteLogging() async {
        if onekHzsecondHeardIsTrue == true {
            self.onekHzlocalReversalEnd = 1
            self.onekHzlocalMarkNewTestCycle = 1
            self.onekHzfirstGain = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
            self.onekHzsecondGain = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let onekHzdelta = onekHzfirstGain - onekHzsecondGain
            let onekHzavg = (onekHzfirstGain + onekHzsecondGain)/2
            
            if onekHzdelta == 0 {
                onekHz_averageGain = onekHzsecondGain
                print("average Gain: \(onekHz_averageGain)")
            } else if onekHzdelta >= 0.05 {
                onekHz_averageGain = onekHzsecondGain
                print("SecondGain: \(onekHzfirstGain)")
                print("SecondGain: \(onekHzsecondGain)")
                print("average Gain: \(onekHz_averageGain)")
            } else if onekHzdelta <= -0.05 {
                onekHz_averageGain = onekHzfirstGain
                print("SecondGain: \(onekHzfirstGain)")
                print("SecondGain: \(onekHzsecondGain)")
                print("average Gain: \(onekHz_averageGain)")
            } else if onekHzdelta < 0.05 && onekHzdelta > -0.05 {
                onekHz_averageGain = onekHzavg
                print("SecondGain: \(onekHzfirstGain)")
                print("SecondGain: \(onekHzsecondGain)")
                print("average Gain: \(onekHz_averageGain)")
            } else {
                onekHz_averageGain = onekHzavg
                print("SecondGain: \(onekHzfirstGain)")
                print("SecondGain: \(onekHzsecondGain)")
                print("average Gain: \(onekHz_averageGain)")
            }
        } else if onekHzsecondHeardIsTrue == false {
            // just continue
//                print("reversal complete logging Contine, second hear is true = false")
        } else {
                print("Critical error in reversalsCompletLogging Logic")
        }
    }
    
//    func onekHzreversalsCompleteLoggingRight1() async {
//        print("loggingRight1 start")
//        if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 && onekHz_averageGainRight2 <= 0.0 && oneRightEntered == false {
//            print("in logging right 1 if")
//            onekHzlocalReversalEnd = 1
//            onekHzlocalMarkNewTestCycle = 1
//            onekHzfirstGainRight1 = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
//            onekHzsecondGainRight1 = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
//            oneRightEntered = true
////            onekHz_rightFirstSecondGainArray.append(onekHzfirstGainRight1)
////            onekHz_rightFirstSecondGainArray.append(onekHzfirstGainRight2)
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//
//            let onekHzdeltaRight1 = onekHzfirstGainRight1 - onekHzsecondGainRight1
//            let onekHzavgRight1 = (onekHzfirstGainRight1 + onekHzsecondGainRight1)/2
//            print("onekHzfirstGainRight1: \(onekHzfirstGainRight1)")
//            print("onekHzsecondGainRight1: \(onekHzsecondGainRight1)")
//            print("onekHzdeltaRight1: \(onekHzdeltaRight1)")
//            print("onekHzavgRight1: \(onekHzavgRight1)")
//            if onekHzdeltaRight1 == 0 {
//                onekHz_averageGainRight1 = onekHzsecondGainRight1
////                needToRepeatTesting = false
//                onekHz_averageGainRightArray.append(onekHzsecondGainRight1)
//                print("if segment")
//                print("FirstGainRight1: \(onekHzfirstGainRight1)")
//                print("SecondGainRight1: \(onekHzsecondGainRight1)")
//                print("average Gain Right 1: \(onekHz_averageGainRight1)")
//            } else if onekHzdeltaRight1 >= 0.05 {
//                onekHz_averageGainRight1 = onekHzsecondGainRight1
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzsecondGainRight1)
//                print("else if segment 1")
//                print("FirstGainRight1: \(onekHzfirstGainRight1)")
//                print("SecondGainRight1: \(onekHzsecondGainRight1)")
//                print("average Gain Right 1: \(onekHz_averageGainRight1)")
//            } else if onekHzdeltaRight1 <= -0.05 {
//                onekHz_averageGainRight1 = onekHzfirstGainRight1
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzfirstGainRight1)
//                print("else if segment 2")
//                print("FirstGainRight1: \(onekHzfirstGainRight1)")
//                print("SecondGainRight1: \(onekHzsecondGainRight1)")
//                print("average Gain Right 1: \(onekHz_averageGainRight1)")
//            } else if onekHzdeltaRight1 < 0.05 && onekHzdeltaRight1 > -0.05 {
//                onekHz_averageGainRight1 = onekHzavgRight1
////                needToRepeatTesting = false
//                onekHz_averageGainRightArray.append(onekHzavgRight1)
//                print("else if segment 3")
//                print("FirstGainRight1: \(onekHzfirstGainRight1)")
//                print("SecondGainRight1: \(onekHzsecondGainRight1)")
//                print("average Gain Right 1: \(onekHz_averageGainRight1)")
//            } else {
//                onekHz_averageGainRight1 = onekHzavgRight1
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzavgRight1)
//                print("else segment ")
//                print("FirstGainRight1: \(onekHzfirstGainRight1)")
//                print("SecondGainRight1: \(onekHzsecondGainRight1)")
//                print("average Gain Right 1: \(onekHz_averageGainRight1)")
//            }
//        } else if onekHzsecondHeardIsTrue == false {
//            // Just continue
//                print("reversal complete logging right 1 Contine, second hear is true = false")
//        } else {
//                print("onekHzreversalsCompleteLoggingRight1() if not met")
//        }
//    }
//
//
//
//    func onekHzreversalsCompleteLoggingRight2() async {
//        print("loggingRight2 start")
//        if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 && onekHz_averageGainLeft1 > 0.0 {
//            print("in logging right 2 if")
//            onekHzlocalReversalEnd = 1
//            onekHzlocalMarkNewTestCycle = 1
//            onekHzfirstGainRight2 = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
//            onekHzsecondGainRight2 = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
////            onekHz_rightFirstSecondGainArray.append(onekHzsecondGainRight2)
////            onekHz_rightFirstSecondGainArray.append(onekHzsecondGainRight2)
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//
//            let onekHzdeltaRight2 = onekHzfirstGainRight2 - onekHzsecondGainRight2
//            let onekHzavgRight2 = (onekHzfirstGainRight2 + onekHzsecondGainRight2)/2
//
//            if onekHzdeltaRight2 == 0 {
//                onekHz_averageGainRight2 = onekHzsecondGainRight2
////                needToRepeatTesting = false
//                onekHz_averageGainRightArray.append(onekHzsecondGainRight2)
//                print("FirstGainRight2: \(onekHzfirstGainRight2)")
//                print("SecondGainRight2: \(onekHzsecondGainRight2)")
//                print("average Gain Right 2: \(onekHz_averageGainRight2)")
//            } else if onekHzdeltaRight2 >= 0.05 {
//                onekHz_averageGainRight2 = onekHzsecondGainRight2
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzsecondGainRight2)
//                print("FirstGainRight2: \(onekHzfirstGainRight2)")
//                print("SecondGainRight2: \(onekHzsecondGainRight2)")
//                print("average Gain Right 2: \(onekHz_averageGainRight2)")
//            } else if onekHzdeltaRight2 <= -0.05 {
//                onekHz_averageGainRight2 = onekHzfirstGainRight2
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzfirstGainRight2)
//                print("FirstGainRight2: \(onekHzfirstGainRight2)")
//                print("SecondGainRight2: \(onekHzsecondGainRight2)")
//                print("average Gain Right 2: \(onekHz_averageGainRight2)")
//            } else if onekHzdeltaRight2 < 0.05 && onekHzdeltaRight2 > -0.05 {
//                onekHz_averageGainRight2 = onekHzavgRight2
////                needToRepeatTesting = false
//                onekHz_averageGainRightArray.append(onekHzavgRight2)
//                print("FirstGainRight2: \(onekHzfirstGainRight2)")
//                print("SecondGainRight2: \(onekHzsecondGainRight2)")
//                print("average Gain Right 2: \(onekHz_averageGainRight2)")
//            } else {
//                onekHz_averageGainRight2 = onekHzavgRight2
//                needToRepeatTesting = true
//                onekHz_averageGainRightArray.append(onekHzavgRight2)
//                print("FirstGainRight2: \(onekHzfirstGainRight2)")
//                print("SecondGainRight2: \(onekHzsecondGainRight2)")
//                print("average Gain Right 2: \(onekHz_averageGainRight2)")
//            }
//        } else if onekHzsecondHeardIsTrue == false {
//            // Just continue
//                print("reversal complete logging right 2 Contine, second hear is true = false")
//        } else {
//                print("onekHzreversalsCompleteLoggingRight2() if not met")
//        }
//    }
//
//    func onekHzreversalsCompleteLoggingLeft1() async {
//        print("loggingleft1 start")
//        if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 && onekHz_averageGainLeft2 <= 0.0 && oneLeftEntered == false{
//            print("in logging left 1 if")
//            onekHzlocalReversalEnd = 1
//            onekHzlocalMarkNewTestCycle = 1
//            oneLeftEntered = true
//            onekHzfirstGainLeft1 = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
//            onekHzsecondGainLeft1 = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
////            onekHz_leftFirstSecondGainArray.append(onekHzfirstGainLeft1)
////            onekHz_leftFirstSecondGainArray.append(onekHzfirstGainLeft2)
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//
//            let onekHzdeltaLeft1 = onekHzfirstGainLeft1 - onekHzsecondGainLeft1
//            let onekHzavgLeft1 = (onekHzfirstGainLeft1 + onekHzsecondGainLeft1)/2
//
//            if onekHzdeltaLeft1 == 0 {
//                print("in if if")
//                onekHz_averageGainLeft1 = onekHzsecondGainLeft1
////                needToRepeatTesting = false
//                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft1)
//                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
//                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
//                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
//            } else if onekHzdeltaLeft1 >= 0.05 {
//                print("in else if 1")
//                onekHz_averageGainLeft1 = onekHzsecondGainLeft1
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft1)
//                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
//                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
//                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
//            } else if onekHzdeltaLeft1 <= -0.05 {
//                print("in else if 2")
//                onekHz_averageGainLeft1 = onekHzfirstGainLeft1
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHzfirstGainLeft1)
//                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
//                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
//                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
//            } else if onekHzdeltaLeft1 < 0.05 && onekHzdeltaLeft1 > -0.05 {
//                print("in else if 3")
//                onekHz_averageGainLeft1 = onekHzavgLeft1
////                needToRepeatTesting = false
//                onekHz_averageGainLeftArray.append(onekHzavgLeft1)
//                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
//                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
//                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
//            } else {
//                print("in if else")
//                onekHz_averageGainLeft1 = onekHzavgLeft1
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHzavgLeft1)
//                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
//                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
//                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
//            }
//        } else if onekHzsecondHeardIsTrue == false {
//            print("in maseter if else if")
//            //print just continue
////                print("reversal complete logging left 1 Contine, second hear is true = false")
//        } else {
//                print("onekHzreversalsCompleteLoggingLeft1() if not met")
//        }
//    }
//
//    func onekHzreversalsCompleteLoggingLeft2() async {
//        print("loggingleft2 start")
//        if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 && onekHz_averageGainRight2 > 0.0 {
//            print("in logging left 2 if")
//            onekHzlocalReversalEnd = 1
//            onekHzlocalMarkNewTestCycle = 1
//            onekHzfirstGainLeft2 = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
//            onekHzsecondGainLeft2 = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
////            onekHz_leftFirstSecondGainArray.append(onekHzsecondGainLeft1)
////            onekHz_leftFirstSecondGainArray.append(onekHzsecondGainLeft2)
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//
//            let onekHzdeltaLeft2 = onekHzfirstGainLeft2 - onekHzsecondGainLeft2
//            let onekHzavgLeft2 = (onekHzfirstGainLeft2 + onekHzsecondGainLeft2)/2
//
//
//            if onekHzdeltaLeft2 == 0 {
//                onekHz_averageGainLeft2 = onekHzsecondGainLeft2
////                needToRepeatTesting = false
//                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft2)
//                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
//                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
//                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
//            } else if onekHzdeltaLeft2 >= 0.05 {
//                onekHz_averageGainLeft2 = onekHzsecondGainLeft2
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft2)
//                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
//                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
//                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
//            } else if onekHzdeltaLeft2 <= -0.05 {
//                onekHz_averageGainLeft2 = onekHzfirstGainLeft2
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHz_averageGainLeft2)
//                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
//                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
//                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
//            } else if onekHzdeltaLeft2 < 0.05 && onekHzdeltaLeft2 > -0.05 {
//                onekHz_averageGainLeft2 = onekHzavgLeft2
////                needToRepeatTesting = false
//                onekHz_averageGainLeftArray.append(onekHzavgLeft2)
//                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
//                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
//                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
//            } else {
//                onekHz_averageGainLeft2 = onekHzavgLeft2
//                needToRepeatTesting = true
//                onekHz_averageGainLeftArray.append(onekHzavgLeft2)
//                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
//                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
//                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
//            }
//        } else if onekHzsecondHeardIsTrue == false {
//            // Just continue
////                print("reversal complete logging left 2 Contine, second hear is true = false")
//        } else {
//                print("onekHzreversalsCompleteLoggingLeft2() if not met")
//        }
//    }
    
    func onekHzreversalsCompleteLoggingRight1() async {
        print("loggingRight1 start")
        if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 && onekHzsecondGainRight1 > 0.0 && onekHzfirstGainRight2 <= 0.0 {
            print("in logging right 1 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
//            self.onekHzfirstGainRight1 = onekHzfirstGainRight1
//            self.onekHzsecondGainRight1 = onekHzsecondGainRight1
//            oneRightEntered = true
            onekHz_rightFirstSecondGainArray.append(onekHzfirstGainRight1)
            onekHz_rightFirstSecondGainArray.append(onekHzfirstGainRight2)
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let onekHzdeltaRight1 = onekHzfirstGainRight1 - onekHzsecondGainRight1
            let onekHzavgRight1 = (onekHzfirstGainRight1 + onekHzsecondGainRight1)/2
            print("onekHzfirstGainRight1: \(onekHzfirstGainRight1)")
            print("onekHzsecondGainRight1: \(onekHzsecondGainRight1)")
            print("onekHzdeltaRight1: \(onekHzdeltaRight1)")
            print("onekHzavgRight1: \(onekHzavgRight1)")
            if onekHzdeltaRight1 == 0 {
                onekHz_averageGainRight1 = onekHzsecondGainRight1
//                needToRepeatTesting = false
                onekHz_averageGainRightArray.append(onekHzsecondGainRight1)
                print("if segment")
                print("FirstGainRight1: \(onekHzfirstGainRight1)")
                print("SecondGainRight1: \(onekHzsecondGainRight1)")
                print("average Gain Right 1: \(onekHz_averageGainRight1)")
            } else if onekHzdeltaRight1 >= 0.05 {
                onekHz_averageGainRight1 = onekHzsecondGainRight1
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzsecondGainRight1)
                print("else if segment 1")
                print("FirstGainRight1: \(onekHzfirstGainRight1)")
                print("SecondGainRight1: \(onekHzsecondGainRight1)")
                print("average Gain Right 1: \(onekHz_averageGainRight1)")
            } else if onekHzdeltaRight1 <= -0.05 {
                onekHz_averageGainRight1 = onekHzfirstGainRight1
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzfirstGainRight1)
                print("else if segment 2")
                print("FirstGainRight1: \(onekHzfirstGainRight1)")
                print("SecondGainRight1: \(onekHzsecondGainRight1)")
                print("average Gain Right 1: \(onekHz_averageGainRight1)")
            } else if onekHzdeltaRight1 < 0.05 && onekHzdeltaRight1 > -0.05 {
                onekHz_averageGainRight1 = onekHzavgRight1
//                needToRepeatTesting = false
                onekHz_averageGainRightArray.append(onekHzavgRight1)
                print("else if segment 3")
                print("FirstGainRight1: \(onekHzfirstGainRight1)")
                print("SecondGainRight1: \(onekHzsecondGainRight1)")
                print("average Gain Right 1: \(onekHz_averageGainRight1)")
            } else {
                onekHz_averageGainRight1 = onekHzavgRight1
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzavgRight1)
                print("else segment ")
                print("FirstGainRight1: \(onekHzfirstGainRight1)")
                print("SecondGainRight1: \(onekHzsecondGainRight1)")
                print("average Gain Right 1: \(onekHz_averageGainRight1)")
            }
        } else if onekHzsecondHeardIsTrue == false {
            // Just continue
                print("reversal complete logging right 1 Contine, second hear is true = false")
        } else {
                print("onekHzreversalsCompleteLoggingRight1() if not met")
        }
    }
    

    
    func onekHzreversalsCompleteLoggingRight2() async {
        print("loggingRight2 start")
        if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 && onekHzsecondGainRight2 > 0.0 {
            print("in logging right 2 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
//            self.onekHzfirstGainRight2 = onekHzfirstGainRight2
//            self.onekHzsecondGainRight2 = onekHzsecondGainRight2
            onekHz_rightFirstSecondGainArray.append(onekHzsecondGainRight2)
            onekHz_rightFirstSecondGainArray.append(onekHzsecondGainRight2)
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let onekHzdeltaRight2 = onekHzfirstGainRight2 - onekHzsecondGainRight2
            let onekHzavgRight2 = (onekHzfirstGainRight2 + onekHzsecondGainRight2)/2
            
            if onekHzdeltaRight2 == 0 {
                onekHz_averageGainRight2 = onekHzsecondGainRight2
//                needToRepeatTesting = false
                onekHz_averageGainRightArray.append(onekHzsecondGainRight2)
                print("FirstGainRight2: \(onekHzfirstGainRight2)")
                print("SecondGainRight2: \(onekHzsecondGainRight2)")
                print("average Gain Right 2: \(onekHz_averageGainRight2)")
            } else if onekHzdeltaRight2 >= 0.05 {
                onekHz_averageGainRight2 = onekHzsecondGainRight2
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzsecondGainRight2)
                print("FirstGainRight2: \(onekHzfirstGainRight2)")
                print("SecondGainRight2: \(onekHzsecondGainRight2)")
                print("average Gain Right 2: \(onekHz_averageGainRight2)")
            } else if onekHzdeltaRight2 <= -0.05 {
                onekHz_averageGainRight2 = onekHzfirstGainRight2
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzfirstGainRight2)
                print("FirstGainRight2: \(onekHzfirstGainRight2)")
                print("SecondGainRight2: \(onekHzsecondGainRight2)")
                print("average Gain Right 2: \(onekHz_averageGainRight2)")
            } else if onekHzdeltaRight2 < 0.05 && onekHzdeltaRight2 > -0.05 {
                onekHz_averageGainRight2 = onekHzavgRight2
//                needToRepeatTesting = false
                onekHz_averageGainRightArray.append(onekHzavgRight2)
                print("FirstGainRight2: \(onekHzfirstGainRight2)")
                print("SecondGainRight2: \(onekHzsecondGainRight2)")
                print("average Gain Right 2: \(onekHz_averageGainRight2)")
            } else {
                onekHz_averageGainRight2 = onekHzavgRight2
                needToRepeatTesting = true
                onekHz_averageGainRightArray.append(onekHzavgRight2)
                print("FirstGainRight2: \(onekHzfirstGainRight2)")
                print("SecondGainRight2: \(onekHzsecondGainRight2)")
                print("average Gain Right 2: \(onekHz_averageGainRight2)")
            }
        } else if onekHzsecondHeardIsTrue == false {
            // Just continue
                print("reversal complete logging right 2 Contine, second hear is true = false")
        } else {
                print("onekHzreversalsCompleteLoggingRight2() if not met")
        }
    }
    
    func onekHzreversalsCompleteLoggingLeft1() async {
        print("loggingleft1 start")
        if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 && onekHzsecondGainLeft1 > 0.0 && onekHzfirstGainLeft2 <= 0.0 {
            print("in logging left 1 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
//            oneLeftEntered = true
//            self.onekHzfirstGainLeft1 = onekHzfirstGainLeft1
//            self.onekHzsecondGainLeft1 = onekHzsecondGainLeft1
            onekHz_leftFirstSecondGainArray.append(onekHzfirstGainLeft1)
            onekHz_leftFirstSecondGainArray.append(onekHzfirstGainLeft2)
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let onekHzdeltaLeft1 = onekHzfirstGainLeft1 - onekHzsecondGainLeft1
            let onekHzavgLeft1 = (onekHzfirstGainLeft1 + onekHzsecondGainLeft1)/2
            
            if onekHzdeltaLeft1 == 0 {
                print("in if if")
                onekHz_averageGainLeft1 = onekHzsecondGainLeft1
//                needToRepeatTesting = false
                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft1)
                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
            } else if onekHzdeltaLeft1 >= 0.05 {
                print("in else if 1")
                onekHz_averageGainLeft1 = onekHzsecondGainLeft1
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft1)
                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
            } else if onekHzdeltaLeft1 <= -0.05 {
                print("in else if 2")
                onekHz_averageGainLeft1 = onekHzfirstGainLeft1
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHzfirstGainLeft1)
                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
            } else if onekHzdeltaLeft1 < 0.05 && onekHzdeltaLeft1 > -0.05 {
                print("in else if 3")
                onekHz_averageGainLeft1 = onekHzavgLeft1
//                needToRepeatTesting = false
                onekHz_averageGainLeftArray.append(onekHzavgLeft1)
                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
            } else {
                print("in if else")
                onekHz_averageGainLeft1 = onekHzavgLeft1
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHzavgLeft1)
                print("FirstGainLeft1: \(onekHzfirstGainLeft1)")
                print("SecondGainLeft1: \(onekHzsecondGainLeft1)")
                print("average Gain Left 1: \(onekHz_averageGainLeft1)")
            }
        } else if onekHzsecondHeardIsTrue == false {
            print("in maseter if else if")
            //print just continue
//                print("reversal complete logging left 1 Contine, second hear is true = false")
        } else {
                print("onekHzreversalsCompleteLoggingLeft1() if not met")
        }
    }
    
    func onekHzreversalsCompleteLoggingLeft2() async {
        print("loggingleft2 start")
        if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 && onekHzsecondGainLeft2 > 0.0 {
            print("in logging left 2 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
//            onekHzfirstGainLeft2 = onekHzfirstGainLeft2
//            onekHzsecondGainLeft2 = onekHzsecondGainLeft2
            onekHz_leftFirstSecondGainArray.append(onekHzsecondGainLeft1)
            onekHz_leftFirstSecondGainArray.append(onekHzsecondGainLeft2)
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let onekHzdeltaLeft2 = onekHzfirstGainLeft2 - onekHzsecondGainLeft2
            let onekHzavgLeft2 = (onekHzfirstGainLeft2 + onekHzsecondGainLeft2)/2
         
            
            if onekHzdeltaLeft2 == 0 {
                onekHz_averageGainLeft2 = onekHzsecondGainLeft2
//                needToRepeatTesting = false
                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft2)
                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
            } else if onekHzdeltaLeft2 >= 0.05 {
                onekHz_averageGainLeft2 = onekHzsecondGainLeft2
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHzsecondGainLeft2)
                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
            } else if onekHzdeltaLeft2 <= -0.05 {
                onekHz_averageGainLeft2 = onekHzfirstGainLeft2
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHz_averageGainLeft2)
                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
            } else if onekHzdeltaLeft2 < 0.05 && onekHzdeltaLeft2 > -0.05 {
                onekHz_averageGainLeft2 = onekHzavgLeft2
//                needToRepeatTesting = false
                onekHz_averageGainLeftArray.append(onekHzavgLeft2)
                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
            } else {
                onekHz_averageGainLeft2 = onekHzavgLeft2
                needToRepeatTesting = true
                onekHz_averageGainLeftArray.append(onekHzavgLeft2)
                print("FirstGainLeft2: \(onekHzfirstGainLeft2)")
                print("SecondGainLeft2: \(onekHzsecondGainLeft2)")
                print("average Gain Left 2: \(onekHz_averageGainLeft2)")
            }
        } else if onekHzsecondHeardIsTrue == false {
            // Just continue
//                print("reversal complete logging left 2 Contine, second hear is true = false")
        } else {
                print("onekHzreversalsCompleteLoggingLeft2() if not met")
        }
    }
    
//    func lowestAverageRightGain() async {
//        print("====LowestAverageRightGain Start======")
//        let idx = onekHz_averageGainRightArray.count
//        if onekHz_averageGainRightArray.count > 0 {
//            let avgRightSorted = onekHz_averageGainRightArray.sorted()
//            print("onekHz_averageGainRightArraySorted: \(avgRightSorted)")
//            onekHz_idxFirstAverageGainRightArray = avgRightSorted[0]
//            onekHz_idxlastAverageGainRightArray = avgRightSorted[idx - 1]
//            if onekHz_idxFirstAverageGainRightArray - onekHz_idxlastAverageGainRightArray >= 0 {
//                onekHz_averageGain = onekHz_idxFirstAverageGainRightArray
//                onekHz_averageGainRight = onekHz_idxFirstAverageGainRightArray
////                onekHz_averageLowestGainRightArray.append(onekHz_averageGainRight)
//                onekHz_averageLowestGainRightArray.append(onekHz_idxFirstAverageGainRightArray)
//                print("onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
//                print("Right average gain: \(onekHz_averageGain)")
//                print("Average Right average gain: \(onekHz_averageGainRight)")
//            } else if onekHz_idxFirstAverageGainRightArray - onekHz_idxlastAverageGainRightArray < 0 {
//                onekHz_averageGain = onekHz_idxlastAverageGainRightArray
//                onekHz_averageGainRight = onekHz_idxlastAverageGainRightArray
////                onekHz_averageLowestGainRightArray.append(onekHz_averageGainRight)
//                onekHz_averageLowestGainRightArray.append(onekHz_idxlastAverageGainRightArray)
//                print("Right average gain: \(onekHz_averageGain)")
//                print("Average Right average gain: \(onekHz_averageGainRight)")
//                print("onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
//            } else {
//                print("!!!Critical error in lowestAverageRightRain Assign Gain Logic")
//            }
//        } else {
//            // contine
//            print("AverageRightGainArray is not > 0")
//        }
//    }
    
//    func lowestAverageLeftGain() async {
//        let idx = onekHz_averageGainLeftArray.count
//        print("idx left gain: \(idx)")
//        print("onekHz_averageGainLeftArray: \(onekHz_averageGainLeftArray)")
//        if onekHz_averageGainLeftArray.count > 0 {
//            let avgLeftSorted = onekHz_averageGainLeftArray.sorted()
//            print("onekHz_averageGainLeftArray: \(avgLeftSorted)")
//            onekHz_idxFirstAverageGainLeftArray = avgLeftSorted[0]
//            onekHz_idxlastAverageGainLeftArray = avgLeftSorted[idx - 1]
//            if onekHz_idxFirstAverageGainLeftArray - onekHz_idxlastAverageGainLeftArray >= 0 {
//                onekHz_averageGain = onekHz_idxFirstAverageGainLeftArray
//                onekHz_averageGainLeft = onekHz_idxFirstAverageGainLeftArray
//                onekHz_averageLowestGainLeftArray.append(onekHz_averageGainLeft)
//                print("onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
//                print("Left average gain: \(onekHz_averageGain)")
//                print("Average Left average gain: \(onekHz_averageGainLeft)")
//            } else if onekHz_idxFirstAverageGainLeftArray - onekHz_idxlastAverageGainLeftArray < 0 {
//                onekHz_averageGain = onekHz_idxlastAverageGainLeftArray
//                onekHz_averageGainLeft = onekHz_idxlastAverageGainLeftArray
//                onekHz_averageLowestGainLeftArray.append(onekHz_averageGainLeft)
//                print("Left average gain: \(onekHz_averageGain)")
//                print("Average Left average gain: \(onekHz_averageGainLeft)")
//                print("onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
//            } else {
//                print("!!!Critical error in lowestAverageLeftRain Assign Gain Logic")
//            }
//        } else {
//            // continue
//            print("AverageLeftGainArray is not > 0")
//        }
//    }
    
    func lowestAverageRightGain() async {
        print("====LowestAverageRightGain Start======")
        let idxR = onekHz_averageGainRightArray.count
        print("idxR: \(idxR)")
        if idxR == 2 {
            let avgRightSorted = onekHz_averageGainRightArray.sorted()
            print("avgRightSorted: \(avgRightSorted)")
            print("avgRightSorted[0]: \(avgRightSorted[0])")
            onekHz_averageLowestGainRightArray.append(avgRightSorted[0])
            onekHz_HoldingLowestRightGainArray.append(avgRightSorted[0])
            print("onekHz_averageGainRightArraySorted: \(avgRightSorted)")
            print("@@@ onekHz_averageGainRightArray: \(onekHz_averageGainRightArray)")
            print("@@@onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
            print("onekHz_HoldingLowestRightGainArray: \(onekHz_HoldingLowestRightGainArray)")
        } else if idxR != 2 {
            print("idxRight != 2 \(idxR)")
        } else {
            print("!!!Critical error in lowestAverageRightRain Assign Gain Logic")
        }
    }
    
    func lowestAverageLeftGain() async {
        let idxL = onekHz_averageGainLeftArray.count
        print("ixdL: \(idxL)")
        if idxL == 2 {
            let avgLeftSorted = onekHz_averageGainLeftArray.sorted()
            print("onekHz_averageGainLeftArray: \(avgLeftSorted)")
            print("avgLeftSorted[0]: \(avgLeftSorted[0])")
            onekHz_averageLowestGainLeftArray.append(avgLeftSorted[0])
            onekHz_HoldingLowestLeftGainArray.append(avgLeftSorted[0])
            print("onekHz_averageGainLeftArraySorted: \(avgLeftSorted)")
            print("@@@ onekHz_averageGainLeftArray: \(onekHz_averageGainLeftArray)")
            print("@@@onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
            print("onekHz_HoldingLowestLeftGainArray: \(onekHz_HoldingLowestLeftGainArray)")
        } else if idxL != 2{
            print("idxLeft != 2\(idxL)")
        } else {
            print("!!!Critical error in lowestAverageLeftRain Assign Gain Logic")
        }
    }
    
    func onekHzComplexLogging() async {
        if onekHzsecondHeardIsTrue == false {
            //continue without action
            print("Second Heard is Not True onekHzComplexLogging()")
        } else if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 {
                await onekHzreversalsCompleteLoggingRight1()
                await onekHzreversalsCompleteLoggingRight2()
                await lowestAverageRightGain()
                
        } else if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 {
                await onekHzreversalsCompleteLoggingLeft1()
                await onekHzreversalsCompleteLoggingLeft2()
                await lowestAverageLeftGain()
                
        } else {
            print("!!!Fatal Error in onekHzComplexLogging() hit main Else Segment")
        }
    }


    
    func printAverageGainsRightLeft() async {
        print("printAverageGainsRightLeft () ")
        print("Right Average Gain: \(onekHz_averageLowestGainRightArray)")
        print("Left Average Gain: \(onekHz_averageLowestGainLeftArray)")
    }
    
    
    func assignInterimLRGains() async {
        print("##Trigger assignFinalLRGains")
        print("onekHz_index: \(onekHz_index)")
        print("onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
        print("onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
//        if onekHz_averageLowestGainRightArray.count == 1 && onekHz_averageLowestGainLeftArray.count == 1 && onekHz_index == 3 {
        if onekHz_HoldingLowestRightGainArray.count > 0 && onekHz_HoldingLowestLeftGainArray.count > 0 && onekHz_index == 3 {
            print("%%% In assignFinalLRGains")
    //        let idxRA = onekHz_averageLowestGainRightArray.count
    //        let idxLA = onekHz_averageLowestGainLeftArray.count
            onekHzRightSorted = onekHz_HoldingLowestRightGainArray.sorted()
            onekHzLeftSorted  = onekHz_HoldingLowestLeftGainArray.sorted()
            print("onekHzRightSorted: \(onekHzRightSorted)")
            print("onekHzLeftSorted: \(onekHzLeftSorted)")
            RightEar1kHzdB1 = onekHzRightSorted[0]
            LeftEar1kHzdB1 = onekHzLeftSorted[0]
            onekHzFinalLRGains1.append(RightEar1kHzdB1)
            onekHzFinalLRGains1.append(LeftEar1kHzdB1)
            onekHzIntraEarDeltaHL1 = RightEar1kHzdB1 - LeftEar1kHzdB1
            print("RightEar1kHzdB: \(RightEar1kHzdB1)")
            print("onekHzFinalLRGains: \(onekHzFinalLRGains1)")
            print("onekHzIntraEarDeltaHL: \(onekHzIntraEarDeltaHL1)")
//        } else if onekHz_averageLowestGainRightArray.count == 1 && onekHz_averageLowestGainLeftArray.count == 1 && onekHz_index == 7 { //onekHzFinalLRGains.count == 2 && onekHz_index == 7 {
        } else if onekHz_HoldingLowestRightGainArray.count > 0 && onekHz_HoldingLowestLeftGainArray.count > 0 && onekHz_index == 7 && onekHzlocalReversalEnd == 1 {
            print("%%% In else if assignFinalLRGains")
    //        let idxRA = onekHz_averageLowestGainRightArray.count
    //        let idxLA = onekHz_averageLowestGainLeftArray.count
            onekHzRightSorted = onekHz_HoldingLowestRightGainArray.sorted()
            onekHzLeftSorted  = onekHz_HoldingLowestLeftGainArray.sorted()
            print("onekHzRightSorted: \(onekHzRightSorted)")
            print("onekHzLeftSorted: \(onekHzLeftSorted)")
            RightEar1kHzdB2 = onekHzRightSorted[0]
            LeftEar1kHzdB2 = onekHzLeftSorted[0]
            onekHzFinalLRGains2.append(RightEar1kHzdB2)
            onekHzFinalLRGains2.append(LeftEar1kHzdB2)
            onekHzIntraEarDeltaHL2 = RightEar1kHzdB2 - LeftEar1kHzdB2
            print("RightEar1kHzdB: \(RightEar1kHzdB2)")
            print("onekHzFinalLRGains: \(onekHzFinalLRGains2)")
            print("onekHzFinalLRGains: \(onekHzFinalLRGains2)")
            print("onekHzIntraEarDeltaHL: \(onekHzIntraEarDeltaHL2)")
        } else {
            print("RightSorted and LeftSorted Count < 0")
        }
    }
    
    func assignFinalLRGains() async {
        if onekHz_HoldingLowestRightGainArray.count > 0 && onekHz_HoldingLowestLeftGainArray.count > 0 && onekHz_index == 3 && needToRepeatTesting == false {
            // one cycle calculation
            self.onekHzFinalLRGains1 = onekHzFinalLRGains1
            self.onekHzFinalLRGains1 = onekHzFinalLRGains1
            self.onekHzIntraEarDeltaHL1 = onekHzIntraEarDeltaHL1
        } else if onekHz_HoldingLowestRightGainArray.count > 0 && onekHz_HoldingLowestLeftGainArray.count > 0 && onekHz_index == 7 && onekHzlocalReversalEnd == 1 {
            let interimRight = RightEar1kHzdB1 - RightEar1kHzdB2
            let interimLeft = LeftEar1kHzdB1 - LeftEar1kHzdB2
            
            if interimRight >= 0.0 && interimLeft >= 0.0 {
                RightEar1kHzdBFinal = RightEar1kHzdB1
                LeftEar1kHzdBFinal = LeftEar1kHzdB1
                onekHzIntraEarDeltaHLFinal = RightEar1kHzdBFinal - LeftEar1kHzdBFinal
                onekHzFinalComboLRGains.append(RightEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(LeftEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(onekHzIntraEarDeltaHLFinal)
            } else if interimRight < 0.0 && interimLeft >= 0.0 {
                RightEar1kHzdBFinal = RightEar1kHzdB2
                LeftEar1kHzdBFinal = LeftEar1kHzdB1
                onekHzIntraEarDeltaHLFinal = RightEar1kHzdBFinal - LeftEar1kHzdBFinal
                onekHzFinalComboLRGains.append(RightEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(LeftEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(onekHzIntraEarDeltaHLFinal)
            }  else if interimRight >= 0.0 && interimLeft < 0.0 {
                RightEar1kHzdBFinal = RightEar1kHzdB1
                LeftEar1kHzdBFinal = LeftEar1kHzdB2
                onekHzIntraEarDeltaHLFinal = RightEar1kHzdBFinal - LeftEar1kHzdBFinal
                onekHzFinalComboLRGains.append(RightEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(LeftEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(onekHzIntraEarDeltaHLFinal)
            } else if interimRight < 0.0 && interimLeft < 0.0 {
                RightEar1kHzdBFinal = RightEar1kHzdB2
                LeftEar1kHzdBFinal = LeftEar1kHzdB2
                onekHzIntraEarDeltaHLFinal = RightEar1kHzdBFinal - LeftEar1kHzdBFinal
                onekHzFinalComboLRGains.append(RightEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(LeftEar1kHzdBFinal)
                onekHzFinalComboLRGains.append(onekHzIntraEarDeltaHLFinal)
            } else {
                print("!!!Critical Error in else if of if in assignFinalLRGains")
            }
        } else {
            print("!!!!Fatal Error in assignFinalLRGains hit master else")
        }
    }
    
    func mustRepeatTesting() async {
        if needToRepeatTesting == true {
            needToRepeatTesting = true
            onekHz_eptaSamplesCount = 7
            print("test cycle end = 7")
        } else if needToRepeatTesting == false {
            onekHz_eptaSamplesCount = 3
            print("test cycle end = 3 as no need to repeat testing")
        } else {
            print("!!!Critical Error in MustRepeatTesting Logic")
        }
    }

    func onekHzprintReversalData() async {
        print("--------Reversal Values Logged-------------")
        print("indexForTest: \(onekHz_indexForTest)")
        print("Test Pan: \(onekHz_testPan)")
        print("New TestGain: \(onekHz_testTestGain)")
        print("reversalFrequency: \(onekHzactiveFrequency)")
        print("testCount: \(onekHz_testCount)")
        print("heardArray: \(onekHz_heardArray)")
        print("reversalHeard: \(onekHz_reversalHeard)")
        print("FirstGain: \(onekHzfirstGain)")
        print("SecondGain: \(onekHzsecondGain)")
        print("AverageGain: \(onekHz_averageGain)")
        print("------------------------------------------")
    }
        
    func onekHzrestartPresentation() async {
        if onekHzendTestSeries == false {
            onekHzlocalPlaying = 1
            onekHzendTestSeries = false
        } else if onekHzendTestSeries == true {
            onekHzlocalPlaying = -1
            onekHzendTestSeries = true
            onekHzshowTestCompletionSheet = true
            onekHzplayingStringColorIndex = 2
        }
    }
    
    func onekHzwipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            onekHz_heardArray.removeAll()
            onekHz_testCount.removeAll()
            onekHz_reversalHeard.removeAll()
            onekHz_averageGain = Float()
            onekHz_reversalDirection = Float()
            onekHzlocalStartingNonHeardArraySet = false
            onekHzfirstHeardResponseIndex = Int()
            onekHzfirstHeardIsTrue = false
            onekHzsecondHeardResponseIndex = Int()
            onekHzsecondHeardIsTrue = false
            onekHzfirstHeardIsTrue = false
            onekHzlocalTestCount = 0
            onekHzlocalReversalHeardLast = Int()
            onekHzstartTooHigh = 0
            onekHzlocalSeriesNoResponses = Int()
//
//
//
//            Task(priority: .userInitiated) {
//                await onekHzwipeArraysForRepeat()
//            }
        })
    }
                    
    func onekHzwipeArraysForRepeat() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            if needToRepeatTesting == true && onekHz_index == 4 && repeatArraysWiped == false {
                print("======Wipe Arrays for New Cycle")
                repeatArraysWiped = true
                onekHzsecondHeardResponseIndex = Int()
                onekHzfirstHeardResponseIndex = Int()
//                needToRepeatTesting = true
                onekHz_averageGain = Float()
//                oneRightEntered = false
//                oneLeftEntered = false
             
                onekHz_averageGainRight1 = Float()
                onekHz_averageGainRight2 = Float()
                onekHz_idxFirstAverageGainRightArray = Float()
                onekHz_idxlastAverageGainRightArray = Float()
                onekHzfirstGainRight1 = Float()
                onekHzsecondGainRight1 = Float()
                onekHzfirstGainRight2 = Float()
                onekHzsecondGainRight2 = Float()
                onekHz_averageGainRightArray.removeAll()
                onekHz_averageGainRight = Float()
                onekHz_rightFirstSecondGainArray.removeAll()

                onekHz_averageGainLeft1 = Float()
                onekHz_averageGainLeft2 = Float()
                onekHz_idxFirstAverageGainLeftArray = Float()
                onekHz_idxlastAverageGainLeftArray = Float()
                onekHzfirstGainLeft1 = Float()
                onekHzsecondGainLeft1 = Float()
                onekHzfirstGainLeft2 = Float()
                onekHzsecondGainLeft2 = Float()
                onekHz_averageGainLeftArray.removeAll()
                onekHz_averageGainLeft = Float()
                onekHz_leftFirstSecondGainArray.removeAll()
                
                onekHzRightSorted.removeAll()
                onekHzLeftSorted.removeAll()
                
                onekHzfirstGainRight1 = Float()
                onekHzsecondGainRight1 = Float()
                onekHzfirstGainRight2 = Float()
                onekHzsecondGainRight2 = Float()
                onekHzfirstGainLeft1 = Float()
                onekHzsecondGainLeft1 = Float()
                onekHzfirstGainLeft2 = Float()
                onekHzsecondGainLeft2 = Float()
                
//                onekHzlocalMarkNewTestCycle = 0
//                onekHzlocalReversalEnd = 0
//                onekHz_index = onekHz_index
//                onekHz_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
//                onekHztestIsPlaying = false
//                onekHzlocalPlaying = 0
//                onekHz_testCount.removeAll()
//                onekHz_reversalHeard.removeAll()
//                onekHz_averageGain = Float()
//                onekHz_reversalDirection = Float()
//                onekHzlocalStartingNonHeardArraySet = false
//                onekHzfirstHeardResponseIndex = Int()
//                onekHzfirstHeardIsTrue = false
//                onekHzsecondHeardResponseIndex = Int()
//                onekHzsecondHeardIsTrue = false
//                onekHzlocalTestCount = 0
//                onekHzlocalReversalHeardLast = Int()
//                onekHzstartTooHigh = 0
                
                onekHzsecondHeardResponseIndex = Int()
                onekHzfirstHeardResponseIndex = Int()
//                onekHz_averageLowestGainRightArray.removeAll()
//                onekHz_averageLowestGainLeftArray.removeAll()
                
            } else {
                print("wipe arrays for repeat not completed")
            }
        })

    }
    
    func onekHznewTestCycle() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 && onekHz_index < onekHz_eptaSamplesCount && onekHzendTestSeries == false {
            onekHzstartTooHigh = 0
            onekHzlocalMarkNewTestCycle = 0
            onekHzlocalReversalEnd = 0
            onekHz_index = onekHz_index + 1
            onekHz_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
            onekHzendTestSeries = false
            await onekHzwipeArrays()
            await onekHzwipeArraysForRepeat()
        } else if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 && onekHz_index == onekHz_eptaSamplesCount && onekHzendTestSeries == false {
            onekHzendTestSeries = true
            onekHzlocalPlaying = -1
                print("=============================")
                print("!!!!! End of Test Series!!!!!!")
                print("=============================")
        } else {
//                print("Reversal Limit Not Hit")
        }
    }
    
    func onekHzendTestSeries() async {
        if onekHzendTestSeries == false {
            //Do Nothing and continue
            print("end Test Series = \(onekHzendTestSeries)")
        } else if onekHzendTestSeries == true {
            onekHzshowTestCompletionSheet = true
            await onekHzendTestSeriesStop()
        }
    }
    
    func onekHzendTestSeriesStop() async {
        onekHzlocalPlaying = -1
        onekHzstop()
        onekHzuserPausedTest = true
        onekHzplayingStringColorIndex = 2
        
        onekHzaudioThread.async {
            onekHzlocalPlaying = 0
            onekHzstop()
            onekHzuserPausedTest = true
            onekHzplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.async {
            onekHzlocalPlaying = 0
            onekHzstop()
            onekHzuserPausedTest = true
            onekHzplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
            onekHzlocalPlaying = 0
            onekHzstop()
            onekHzuserPausedTest = true
            onekHzplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInitiated) {
            onekHzlocalPlaying = -1
            onekHzstop()
            onekHzuserPausedTest = true
            onekHzplayingStringColorIndex = 2
        }
    }
    
    func printOnekHzArrays() async {
        print("================================")
        print("***********printOnekHzArrays**********")
//        print("onekHz_index: \(onekHz_index)")
        print("needToRepeatTesting: \(needToRepeatTesting)")
        print("onekHz_HoldingLowestRightGainArray: \(onekHz_HoldingLowestRightGainArray)")
        print("onekHz_HoldingLowestLeftGainArray: \(onekHz_HoldingLowestLeftGainArray)")
//        print("onekHz_rightFirstSecondGainArray: \(onekHz_rightFirstSecondGainArray)")
//        print("onekHz_leftFirstSecondGainArray: \(onekHz_leftFirstSecondGainArray)")
        print("onekHz_averageGainRightArray: \(onekHz_averageGainRightArray)")
        print("onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
        print("onekHz_averageGainLeftArray: \(onekHz_averageGainLeftArray)")
        print("onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
        
        //Issue with Three below
        print("RightEar1kHzdB1: \(RightEar1kHzdB1)")
        print("LeftEar1kHzdB1: \(LeftEar1kHzdB1)")
        print("onekHzFinalLRGains1: \(onekHzFinalLRGains1)")
        
        print("RightEar1kHzdB2: \(RightEar1kHzdB2)")
        print("LeftEar1kHzdB2: \(LeftEar1kHzdB2)")
        print("onekHzFinalLRGains2: \(onekHzFinalLRGains2)")
        
        
        print("RightEar1kHzdBFinal: \(RightEar1kHzdBFinal)")
        print("LeftEar1kHzdBFinal: \(LeftEar1kHzdBFinal)")
        print("onekHzIntraEarDeltaHLFinal: \(onekHzIntraEarDeltaHLFinal)")
        
        print("onekHzFinalComboLRGains: \(onekHzFinalComboLRGains)")
      
        print("onekHz_testPan: \(onekHz_testPan)")
        print("onekHz_indexForTest: \(onekHz_indexForTest)")
        print("onekHz_reversalGain: \(onekHz_reversalGain)")
        print("onekHz_reversalHeard: \(onekHz_reversalHeard)")
        print("onekHzactiveFrequency: \(onekHzactiveFrequency)")
        print("onekHz_testTestGain: \(onekHz_testTestGain)")
        print("onekHz_frequency: \(onekHz_frequency)")
        print("***********printOnekHzArrays**********")
        print("================================")
    }
    
    func onekHzconcatenateFinalArrays() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 {
            onekHz_finalStoredIndex.append(contentsOf: [100000000] + onekHz_indexForTest)
            onekHz_finalStoredTestPan.append(contentsOf: [100000000] + onekHz_testPan)
            onekHz_finalStoredTestTestGain.append(contentsOf: [1000000.0] + onekHz_testTestGain)
            onekHz_finalStoredFrequency.append(contentsOf: ["100000000"] + [String(onekHzactiveFrequency)])
            onekHz_finalStoredTestCount.append(contentsOf: [100000000] + onekHz_testCount)
            onekHz_finalStoredHeardArray.append(contentsOf: [100000000] + onekHz_heardArray)
            onekHz_finalStoredReversalHeard.append(contentsOf: [100000000] + onekHz_reversalHeard)
            onekHz_finalStoredFirstGain.append(contentsOf: [1000000.0] + [onekHzfirstGain])
            onekHz_finalStoredSecondGain.append(contentsOf: [1000000.0] + [onekHzsecondGain])
            onekHz_finalStoredAverageGain.append(contentsOf: [1000000.0] + [onekHz_averageGain])
        }
    }
    
    func onekHzprintConcatenatedArrays() async {
        print("finalStoredIndex: \(onekHz_finalStoredIndex)")
        print("finalStoredTestPan: \(onekHz_finalStoredTestPan)")
        print("finalStoredTestTestGain: \(onekHz_finalStoredTestTestGain)")
        print("finalStoredFrequency: \(onekHz_finalStoredFrequency)")
        print("finalStoredTestCount: \(onekHz_finalStoredTestCount)")
        print("finalStoredHeardArray: \(onekHz_finalStoredHeardArray)")
        print("finalStoredReversalHeard: \(onekHz_finalStoredReversalHeard)")
        print("finalStoredFirstGain: \(onekHz_finalStoredFirstGain)")
        print("finalStoredSecondGain: \(onekHz_finalStoredSecondGain)")
        print("finalStoredAverageGain: \(onekHz_finalStoredAverageGain)")
    }
        
    func onekHzsaveFinalStoredArrays() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
                    await onekHzwriteEHA1DetailedResultsToCSV()
                    await onekHzwriteEHA1SummarydResultsToCSV()
                    await onekHzwriteEHA1InputDetailedResultsToCSV()
                    await onekHzwriteEHA1InputDetailedResultsToCSV()
                    await onekHzgetEHAP1Data()
                    await onekHzsaveEHA1ToJSON()
        //                await onekHz_uploadSummaryResultsTest()
                }
            }
        }
    }
    

    

//MARK: -FireBase Storage Upload

//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//    func uploadCSV() async {
//        DispatchQueue.global(qos: .background).async {
//            let storageRef = Storage.storage().reference()
//            let setupCSVName = ["SetupResultsCSV.csv"]
//            let fileManager = FileManager.default
//            let csvPath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: setupCSVName)
//            if fileManager.fileExists(atPath: csvPath[0]) {
//                let filePath = URL(fileURLWithPath: csvPath[0])
//                let localFile = filePath
//                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
//                let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
//                    if error == nil && metadata == nil {
//                        //TSave a reference to firestore database
//                    }
//                    return
//                }
//                print(uploadTask)
//            } else {
//                print("No File")
//            }
//        }
//    }
//}
//
//
//extension EHATTSTestPart1View {
//MARK: -JSON and CSV Writing
    
    func onekHzgetEHAP1Data() async {
        guard let onekHzdata = await onekHzgetEHAP1JSONData() else { return }
        print("Json Data:")
        print(onekHzdata)
        let onekHzjsonString = String(data: onekHzdata, encoding: .utf8)
        print(onekHzjsonString!)
        do {
        self.onekHzsaveFinalResults = try JSONDecoder().decode(onekHzSaveFinalResults.self, from: onekHzdata)
            print("JSON GetData Run")
            print("data: \(onekHzdata)")
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func onekHzgetEHAP1JSONData() async -> Data? {
        let onekHzsaveFinalResults = onekHzSaveFinalResults(
            jsonName: "Jeff",
            jsonAge: 36,
            jsonSex: 1,
            jsonEmail: "blank@blank.com",
            json1kHzRightEarHL: 1.5,
            json1kHzLeftEarHL: 0.5,
            json1kHzIntraEarDeltaHL: 1.0,
            jsonPhonCurve: 2,
            jsonReferenceCurve: 7,
            jsonSystemVoluem: 100.00,
            jsonActualFrequency: 1.000,
            jsonFrequency: [onekHzactiveFrequency],
            jsonPan: onekHz_finalStoredTestPan,
            jsonStoredIndex: onekHz_finalStoredIndex,
            jsonStoredTestPan: onekHz_finalStoredTestPan,
            jsonStoredTestTestGain: onekHz_finalStoredTestTestGain,
            jsonStoredTestCount: onekHz_finalStoredTestCount,
            jsonStoredHeardArray: onekHz_finalStoredHeardArray,
            jsonStoredReversalHeard: onekHz_finalStoredReversalHeard,
            jsonStoredFirstGain: onekHz_finalStoredFirstGain,
            jsonStoredSecondGain: onekHz_finalStoredSecondGain,
            jsonStoredAverageGain: onekHz_finalStoredAverageGain)

        let onekHzjsonData = try? JSONEncoder().encode(onekHzsaveFinalResults)
        print("saveFinalResults: \(onekHzsaveFinalResults)")
        print("Json Encoded \(onekHzjsonData!)")
        return onekHzjsonData
    }

    func onekHzsaveEHA1ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let onekHzpaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let onekHzDocumentsDirectory = onekHzpaths[0]
        print("onekHzDocumentsDirectory: \(onekHzDocumentsDirectory)")
        let onekHzFilePaths = onekHzDocumentsDirectory.appendingPathComponent(fileonekHzName)
        print(onekHzFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let onekHzjsonData = try encoder.encode(onekHzsaveFinalResults)
            print(onekHzjsonData)
          
            try onekHzjsonData.write(to: onekHzFilePaths)
        } catch {
            print("Error writing EHAP1 to JSON file: \(error)")
        }
    }

//Name
//Age
//Sex
//User ID
//Test ID
//
//onekHz_rightFirstSecondGainArray
//onekHz_leftFirstSecondGainArray
//
//onekHz_averageGainRightArray
//onekHz_averageLowestGainRightArray
//
//onekHz_averageGainLeftArray
//onekHz_averageLowestGainLeftArray
//
//
//RightEar1kHzdB
//LeftEar1kHzdB
//onekHzFinalLRGains
//onekHzIntraEarDeltaHL
//
//
//onekHz_testPan
//onekHz_indexForTest
//onekHz_testCount
//onekHz_reversalGain
//onekHz_reversalHeard
//onekHzactiveFrequency
//onekHz_testTestGain
//onekHz_frequency
    
    
    
    func onekHzwriteEHA1DetailedResultsToCSV() async {
        let onekHzstringFinalStoredIndex = "finalStoredIndex," + onekHz_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestPan = "finalStoredTestPan," + onekHz_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestTestGain = "finalStoredTestTestGain," + onekHz_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredFrequency = "finalStoredFrequency," + [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestCount = "finalStoredTestCount," + onekHz_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredHeardArray = "finalStoredHeardArray," + onekHz_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredReversalHeard = "finalStoredReversalHeard," + onekHz_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredPan = "finalStoredPan," + onekHz_testPan.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredFirstGain = "finalStoredFirstGain," + onekHz_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredSecondGain = "finalStoredSecondGain," + onekHz_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredAverageGain = "finalStoredAverageGain," + onekHz_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        
        do {
            let csvonekHzDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvonekHzDetailDocumentsDirectory = csvonekHzDetailPath
//                print("CSV DocumentsDirectory: \(csvEHAP1DetailDocumentsDirectory)")
            let csvonekHzDetailFilePath = csvonekHzDetailDocumentsDirectory.appendingPathComponent(detailedonekHzCSVName)
            print(csvonekHzDetailFilePath)
            
            let writer = try CSVWriter(fileURL: csvonekHzDetailFilePath, append: false)
            
            try writer.write(row: [onekHzstringFinalStoredIndex])
            try writer.write(row: [onekHzstringFinalStoredTestPan])
            try writer.write(row: [onekHzstringFinalStoredTestTestGain])
            try writer.write(row: [onekHzstringFinalStoredFrequency])
            try writer.write(row: [onekHzstringFinalStoredTestCount])
            try writer.write(row: [onekHzstringFinalStoredHeardArray])
            try writer.write(row: [onekHzstringFinalStoredReversalHeard])
            try writer.write(row: [onekHzstringFinalStoredPan])
            try writer.write(row: [onekHzstringFinalStoredFirstGain])
            try writer.write(row: [onekHzstringFinalStoredSecondGain])
            try writer.write(row: [onekHzstringFinalStoredAverageGain])
//
//                print("CVS EHAP1 Detailed Writer Success")
        } catch {
            print("CVSWriter EHAP1 Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }

    func onekHzwriteEHA1SummarydResultsToCSV() async {
         let onekHzstringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredTestPan = "finalStoredTestPan," + onekHz_testPan.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredFirstGain = "finalStoredFirstGain," + onekHz_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredSecondGain = "finalStoredSecondGain," + onekHz_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredAverageGain = "finalStoredAverageGain," + onekHz_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        
         do {
             let csvonekHzSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvonekHzSummaryDocumentsDirectory = csvonekHzSummaryPath
//                 print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvEHAP1SummaryDocumentsDirectory)")
             let csvonekHzSummaryFilePath = csvonekHzSummaryDocumentsDirectory.appendingPathComponent(summaryonekHzCSVName)
             print(csvonekHzSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvonekHzSummaryFilePath, append: false)
             try writer.write(row: [onekHzstringFinalStoredResultsFrequency])
             try writer.write(row: [onekHzstringFinalStoredTestPan])
             try writer.write(row: [onekHzstringFinalStoredFirstGain])
             try writer.write(row: [onekHzstringFinalStoredSecondGain])
             try writer.write(row: [onekHzstringFinalStoredAverageGain])
//
//                 print("CVS Summary EHA Part 1 Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func onekHzwriteEHA1InputDetailedResultsToCSV() async {
        let onekHzstringFinalStoredIndex = onekHz_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestPan = onekHz_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestTestGain = onekHz_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredTestCount = onekHz_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredHeardArray = onekHz_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredReversalHeard = onekHz_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredResultsFrequency = [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredPan = onekHz_testPan.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredFirstGain = onekHz_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredSecondGain = onekHz_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalStoredAverageGain = onekHz_finalStoredAverageGain.map { String($0) }.joined(separator: ",")

        do {
            let csvInputonekHzDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputonekHzDetailDocumentsDirectory = csvInputonekHzDetailPath
//                print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputEHAP1DetailDocumentsDirectory)")
            let csvInputonekHzDetailFilePath = csvInputonekHzDetailDocumentsDirectory.appendingPathComponent(inputonekHzDetailedCSVName)
            print(csvInputonekHzDetailFilePath)
            let writer = try CSVWriter(fileURL: csvInputonekHzDetailFilePath, append: false)
            try writer.write(row: [onekHzstringFinalStoredIndex])
            try writer.write(row: [onekHzstringFinalStoredTestPan])
            try writer.write(row: [onekHzstringFinalStoredTestTestGain])
            try writer.write(row: [onekHzstringFinalStoredTestCount])
            try writer.write(row: [onekHzstringFinalStoredHeardArray])
            try writer.write(row: [onekHzstringFinalStoredReversalHeard])
            try writer.write(row: [onekHzstringFinalStoredResultsFrequency])
            try writer.write(row: [onekHzstringFinalStoredPan])
            try writer.write(row: [onekHzstringFinalStoredFirstGain])
            try writer.write(row: [onekHzstringFinalStoredSecondGain])
            try writer.write(row: [onekHzstringFinalStoredAverageGain])
//
//                print("CVS Input EHA Part 1Detailed Writer Success")
        } catch {
            print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }

    func onekHzwriteEHA1InputSummarydResultsToCSV() async {
         let onekHzstringFinalStoredResultsFrequency = [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredTestPan = onekHz_finalStoredTestPan.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredFirstGain = onekHz_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredSecondGain = onekHz_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
         let onekHzstringFinalStoredAverageGain = onekHz_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
         
         do {
             let csvonekHzInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvonekHzInputSummaryDocumentsDirectory = csvonekHzInputSummaryPath
             print("CSV Input onekHz Summary DocumentsDirectory: \(csvonekHzInputSummaryDocumentsDirectory)")
             let csvonekHzInputSummaryFilePath = csvonekHzInputSummaryDocumentsDirectory.appendingPathComponent(inputonekHzSummaryCSVName)
             print(csvonekHzInputSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvonekHzInputSummaryFilePath, append: false)
             try writer.write(row: [onekHzstringFinalStoredResultsFrequency])
             try writer.write(row: [onekHzstringFinalStoredTestPan])
             try writer.write(row: [onekHzstringFinalStoredFirstGain])
             try writer.write(row: [onekHzstringFinalStoredSecondGain])
             try writer.write(row: [onekHzstringFinalStoredAverageGain])
//
//                 print("CVS Input EHA Part 1 Summary Data Writer Success")
         } catch {
             print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
         }
    }
}
