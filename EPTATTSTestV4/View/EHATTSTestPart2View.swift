//
//  EHATTSTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
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

struct ehaP2SaveFinalResults: Codable {  // This is a model
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

struct EHATTSTestPart2View: View {
    
    enum ehaP2SampleErrors: Error {
        case ehaP2notFound
        case ehaP2unexpected(code: Int)
    }
    
    enum ehaP2FirebaseErrors: Error {
        case ehaP2unknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()

    @State var ehaP2localHeard = 0
    @State var ehaP2localPlaying = Int()    // Playing = 1. Stopped = -1
    @State var ehaP2localReversal = Int()
    @State var ehaP2localReversalEnd = Int()
    @State var ehaP2localMarkNewTestCycle = Int()
    @State var ehaP2testPlayer: AVAudioPlayer?
    
    @State var ehaP2localTestCount = 0
    @State var ehaP2localStartingNonHeardArraySet: Bool = false
    @State var ehaP2localReversalHeardLast = Int()
    @State var ehaP2localSeriesNoResponses = Int()
    @State var ehaP2firstHeardResponseIndex = Int()
    @State var ehaP2firstHeardIsTrue: Bool = false
    @State var ehaP2secondHeardResponseIndex = Int()
    @State var ehaP2secondHeardIsTrue: Bool = false
    @State var ehaP2startTooHigh = 0
    @State var ehaP2firstGain = Float()
    @State var ehaP2secondGain = Float()
    @State var ehaP2endTestSeries: Bool = false
    @State var ehaP2showTestCompletionSheet: Bool = false
    
    @State var ehaP2_samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    
    @State var ehaP2panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    @State var ehaP2totalCount = 32
    @State var ehaP2localPan: Float = Float()

    
    // Presentation Cycles
    // Cycle 1 Right: ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8"]  // panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    // Cycle 2 Left: ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8"]   // panArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    // Cycle 3 Right: ["Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]   // panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    // Cycle 4 Left: ["Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]    //panArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    
//    rightFinalGain"\(activeFrequency)"
    
    //Change Sample Numbers
//    @State var rightFinalGainSample1 = Float()
//    @State var rightFinalGainSample2 = Float()
//    @State var rightFinalGainSample3 = Float()
//    @State var rightFinalGainSample4 = Float()
//    @State var rightFinalGainSample5 = Float()
//    @State var rightFinalGainSample6 = Float()
//    @State var rightFinalGainSample7 = Float()
//    @State var rightFinalGainSample8 = Float()
//    @State var rightFinalGainSample9 = Float()
//    @State var rightFinalGainSample10 = Float()
//    @State var rightFinalGainSample11 = Float()
//    @State var rightFinalGainSample12 = Float()
//    @State var rightFinalGainSample13 = Float()
//    @State var rightFinalGainSample14 = Float()
//    @State var rightFinalGainSample15 = Float()
//    @State var rightFinalGainSample16 = Float()
//
//    @State var leftFinalGainSample1 = Float()
//    @State var leftFinalGainSample2 = Float()
//    @State var leftFinalGainSample3 = Float()
//    @State var leftFinalGainSample4 = Float()
//    @State var leftFinalGainSample5 = Float()
//    @State var leftFinalGainSample6 = Float()
//    @State var leftFinalGainSample7 = Float()
//    @State var leftFinalGainSample8 = Float()
//    @State var leftFinalGainSample9 = Float()
//    @State var leftFinalGainSample10 = Float()
//    @State var leftFinalGainSample11 = Float()
//    @State var leftFinalGainSample12 = Float()
//    @State var leftFinalGainSample13 = Float()
//    @State var leftFinalGainSample14 = Float()
//    @State var leftFinalGainSample15 = Float()
//    @State var leftFinalGainSample16 = Float()
    
    @State var ehaP2rightFinalGainsArray = [Float]()
    @State var ehaP2leftFinalGainsArray = [Float]()
    @State var ehaP2finalStoredRightFinalGainsArray = [Float]()
    @State var ehaP2finalStoredleftFinalGainsArray = [Float]()
    
    
    
    
    
    
    
    
    @State var ehaP2_index: Int = 0
    @State var ehaP2_testGain: Float = 0.2
    @State var ehaP2_heardArray: [Int] = [Int]()
    @State var ehaP2_indexForTest = [Int]()
    @State var ehaP2_testCount: [Int] = [Int]()
    @State var ehaP2_pan: Float = Float()
    @State var ehaP2_testPan = [Float]()
    @State var ehaP2_testTestGain = [Float]()
    @State var ehaP2_frequency = [String]()
    @State var ehaP2_reversalHeard = [Int]()
    @State var ehaP2_reversalGain = [Float]()
    @State var ehaP2_reversalFrequency = [String]()
    @State var ehaP2_reversalDirection = Float()
    @State var ehaP2_reversalDirectionArray = [Float]()

    @State var ehaP2_averageGain = Float()

    @State var ehaP2_eptaSamplesCount = 1 //17
    @State var ehaP2_eptaSamplesCountArray = [7, 7, 7, 7, 7, 7, 7, 7, 15, 15, 15, 15, 15, 15, 15, 15, 23, 23, 23, 23, 23, 23, 23, 23, 31, 31, 31, 31, 31, 31, 31, 31]
    @State var ehaP2_eptaSamplesCountArrayIdx = 0  //[0, 1, 2, 3]

    @State var ehaP2_finalStoredIndex: [Int] = [Int]()
    @State var ehaP2_finalStoredTestPan: [Float] = [Float]()
    @State var ehaP2_finalStoredTestTestGain: [Float] = [Float]()
    @State var ehaP2_finalStoredFrequency: [String] = [String]()
    @State var ehaP2_finalStoredTestCount: [Int] = [Int]()
    @State var ehaP2_finalStoredHeardArray: [Int] = [Int]()
    @State var ehaP2_finalStoredReversalHeard: [Int] = [Int]()
    @State var ehaP2_finalStoredFirstGain: [Float] = [Float]()
    @State var ehaP2_finalStoredSecondGain: [Float] = [Float]()
    @State var ehaP2_finalStoredAverageGain: [Float] = [Float]()
    
    @State var ehaP2idxForTest = Int() // = ehaP2_indexForTest.count
    @State var ehaP2idxForTestNet1 = Int() // = ehaP2_indexForTest.count - 1
    @State var ehaP2idxTestCount = Int() // = ehaP2_TestCount.count
    @State var ehaP2idxTestCountUpdated = Int() // = ehaP2_TestCount.count + 1
    @State var ehaP2activeFrequency = String()
    @State var ehaP2idxHA = Int()    // idx = ehaP2_heardArray.count
    @State var ehaP2idxReversalHeardCount = Int()
    @State var ehaP2idxHAZero = Int()    //  idxZero = idx - idx
    @State var ehaP2idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var ehaP2isCountSame = Int()
    @State var ehaP2heardArrayIdxAfnet1 = Int()
    @State var ehaP2testIsPlaying: Bool = false
    @State var ehaP2playingString: [String] = ["", "Start or Restart Test", "Great Job, You've Completed This Test Segment"]
    @State var ehaP2playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    @State var ehaP2playingStringColorIndex = 0
    @State var ehaP2playingStringColorIndex2 = 0
    @State var ehaP2userPausedTest: Bool = false

    let fileehaP2Name = "SummaryehaP2Results.json"
    let summaryehaP2CSVName = "SummaryehaP2ResultsCSV.csv"
    let detailedehaP2CSVName = "DetailedehaP2ResultsCSV.csv"
    let inputehaP2SummaryCSVName = "InputSummaryehaP2ResultsCSV.csv"
    let inputehaP2DetailedCSVName = "InputDetailedehaP2ResultsCSV.csv"
    let summaryEHAP2LRCSVName = "SummaryEHAP2LRResultsCSV.csv"
    let summaryEHAP2RightCSVName = "SummaryEHAP2RightResultsCSV.csv"
    let summaryEHAP2LeftCSVName = "SummaryEHAP2LeftResultsCSV.csv"
    let inputEHAP2LRSummaryCSVName = "InputDetailedEHAP2LRResultsCSV.csv"
    let inputEHAP2RightSummaryCSVName = "InputDetailedEHAP2RightResultsCSV.csv"
    let inputEHAP2LeftSummaryCSVName = "InputDetailedEHAP2LeftResultsCSV.csv"
    
    @State var ehaP2saveFinalResults: ehaP2SaveFinalResults? = nil

    let ehaP2heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let ehaP2arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let ehaP2audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let ehaP2preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
  
    
    var body: some View {

       ZStack{
           RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .top, startRadius: -10, endRadius: 300).ignoresSafeArea()
           VStack {
                   
               Text("EHA Part 2 Test")
                   .fontWeight(.bold)
                   .padding()
                   .foregroundColor(.white)
                   .padding(.top, 40)
                   .padding(.bottom, 20)
               
               Text("Click to Stat Test")
                   .fontWeight(.bold)
                   .padding()
                   .foregroundColor(.blue)
                   .onTapGesture {
                       Task(priority: .userInitiated) {
                           audioSessionModel.setAudioSession()
                           ehaP2localPlaying = 1
                           ehaP2endTestSeries = false
                           print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
                       }
                   }
                   .padding(.top, 20)
                   .padding(.bottom, 20)
               
               Button {
                   ehaP2_heardArray.removeAll()
                   ehaP2pauseRestartTestCycle()
                   audioSessionModel.setAudioSession()
                   ehaP2localPlaying = 1
                   ehaP2userPausedTest = false
                   ehaP2playingStringColorIndex = 0
                   ehaP2endTestSeries = false
                   print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
               } label: {
                   Text(ehaP2playingString[ehaP2playingStringColorIndex])
                       .foregroundColor(ehaP2playingStringColor[ehaP2playingStringColorIndex])
               }
               .padding(.top, 20)
               .padding(.bottom, 20)
                     
               Button {
                   ehaP2localPlaying = 0
                   ehaP2stop()
                   ehaP2userPausedTest = true
                   ehaP2playingStringColorIndex = 1
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                       ehaP2localPlaying = 0
                       ehaP2stop()
                       ehaP2userPausedTest = true
                       ehaP2playingStringColorIndex = 1
                   }
                   DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                       ehaP2localPlaying = 0
                       ehaP2stop()
                       ehaP2userPausedTest = true
                       ehaP2playingStringColorIndex = 1
                   }
                   DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                       ehaP2localPlaying = 0
                       ehaP2stop()
                       ehaP2userPausedTest = true
                       ehaP2playingStringColorIndex = 1
                   }
               } label: {
                   Text("Pause Test")
                       .foregroundColor(.yellow)
               }
               .padding(.top, 20)
               .padding(.bottom, 80)
        
               
               Text("Press if You Hear The Tone")
                   .fontWeight(.semibold)
                   .padding()
                   .frame(width: 300, height: 100, alignment: .center)
                   .background(Color .green)
                   .foregroundColor(.black)
                   .cornerRadius(300)
                   .onTapGesture(count: 1) {
                       ehaP2heardThread.async{ self.ehaP2localHeard = 1
                       }
                   }
                   .padding(.top, 20)
               Spacer()
               }
               .fullScreenCover(isPresented: $ehaP2showTestCompletionSheet, content: {
                   ZStack{
                       RadialGradient(gradient: Gradient(colors: [Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569), Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
                       
                       VStack(alignment: .leading) {
                           
                           Button(action: {
                               
                               ehaP2showTestCompletionSheet.toggle()
                               ehaP2endTestSeries = false
                               ehaP2testIsPlaying = true
                               ehaP2localPlaying = 1
                               ehaP2playingStringColorIndex = 2
                               ehaP2userPausedTest = false
                               
                               print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
                               
                           }, label: {
                               Image(systemName: "xmark")
                                   .font(.headline)
                                   .padding(10)
                                   .foregroundColor(.red)
                           })
                           Spacer()
                           Text("Take a moment for a break before exiting to continue with the next test segment")
                               .foregroundColor(.white)
                               .font(.title3)
                               .padding()
                           Spacer()
                           Button(action: {
                               DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
                                   Task(priority: .userInitiated) {
                                       await ehaP2combinedPauseRestartAndStartNexTestCycle()
                                   }
                               }
                           }, label: {
                               Text("Start The Next Cycle")
                                   .foregroundColor(.green)
                                   .font(.title)
                                   .padding()
                           })
                           Spacer()
                       }
                   }
               })
           }
           .onChange(of: ehaP2testIsPlaying, perform: { ehaP2testBoolValue in
               if ehaP2testBoolValue == true && ehaP2endTestSeries == false {
               //User is starting test for first time
                   audioSessionModel.setAudioSession()
                   ehaP2localPlaying = 1
                   ehaP2playingStringColorIndex = 0
                   ehaP2userPausedTest = false
               } else if ehaP2testBoolValue == false && ehaP2endTestSeries == false {
               // User is pausing test for firts time
                   ehaP2stop()
                   ehaP2localPlaying = 0
                   ehaP2playingStringColorIndex = 1
                   ehaP2userPausedTest = true
               } else if ehaP2testBoolValue == true && ehaP2endTestSeries == true {
                   ehaP2stop()
                   ehaP2localPlaying = -1
                   ehaP2playingStringColorIndex = 2
                   ehaP2userPausedTest = true
               } else {
                   print("Critical error in pause logic")
               }
           })
           // This is the lowest CPU approach from many, many tries
           .onChange(of: ehaP2localPlaying, perform: { ehaP2playingValue in
               ehaP2activeFrequency = ehaP2_samples[ehaP2_index]
               ehaP2localPan = ehaP2panArray[ehaP2_index]
               ehaP2_pan = ehaP2panArray[ehaP2_index]
               ehaP2localHeard = 0
               ehaP2localReversal = 0
               
               if ehaP2playingValue == 1{
                   print("envDataObjectModel_testGain: \(ehaP2_testGain)")
                   print("activeFrequency: \(ehaP2activeFrequency)")
                   print("localPan: \(ehaP2localPan)")
                   print("envDataObjectModel_index: \(ehaP2_index)")
                   
                   ehaP2audioThread.async {
                       ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                       while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                       if ehaP2localHeard == 1 {
                           ehaP2testPlayer!.stop()
                           print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                       } else {
                           ehaP2testPlayer!.stop()
                       self.ehaP2localHeard = -1
                       print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                       }
                   }
                   ehaP2preEventThread.async {
                       ehaP2preEventLogging()
                   }
                   DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                       if self.ehaP2localHeard == 1 {
                           ehaP2localTestCount += 1
                           Task(priority: .userInitiated) {
                               await ehaP2responseHeardArray()      //ehaP2_heardArray.append(1)
                               await ehaP2localResponseTracking()
                               await ehaP2count()
                               await ehaP2logNotPlaying()           //ehaP2_playing = -1
                               await ehaP2resetPlaying()
                               await ehaP2resetHeard()
                               await ehaP2resetNonResponseCount()
                               await ehaP2createReversalHeardArray()
                               await ehaP2createReversalGainArray()
                               await ehaP2checkHeardReversalArrays()
                               await ehaP2reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                           }
                       }
                       else if ehaP2_heardArray.last == nil || self.ehaP2localHeard == -1 {
                           ehaP2localTestCount += 1
                           Task(priority: .userInitiated) {
                               await ehaP2heardArrayNormalize()
                               await ehaP2count()
                               await ehaP2logNotPlaying()   //self.ehaP2_playing = -1
                               await ehaP2resetPlaying()
                               await ehaP2resetHeard()
                               await ehaP2nonResponseCounting()
                               await ehaP2createReversalHeardArray()
                               await ehaP2createReversalGainArray()
                               await ehaP2checkHeardReversalArrays()
                               await ehaP2reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change    event
                           }
                       } else {
                           ehaP2localTestCount = 1
                           Task(priority: .background) {
                               await ehaP2resetPlaying()
                               print("Fatal Error: Stopped in Task else")
                               print("heardArray: \(ehaP2_heardArray)")
                           }
                       }
                   }
               }
           })
           .onChange(of: ehaP2localReversal) { ehaP2reversalValue in
               if ehaP2reversalValue == 1 {
                   DispatchQueue.global(qos: .background).async {
                       Task(priority: .userInitiated) {
   //                        await ehaP2createReversalHeardArray()
   //                        await ehaP2createReversalGainArray()
   //                        await ehaP2checkHeardReversalArrays()
                           await ehaP2reversalDirection()
                           await ehaP2reversalComplexAction()
                           await ehaP2reversalsCompleteLogging()
                           await ehaP2AssignLRAverageSampleGains()
   //                        await ehaP2printReversalGain()
   //                        await ehaP2printData()
   //                        await ehaP2printReversalData()
                           await ehaP2concatenateFinalArrays()
   //                        await ehaP2printConcatenatedArrays()
                           await ehaP2saveFinalStoredArrays()
                           await ehaP2endTestSeries()
                           await ehaP2newTestCycle()
                           await ehaP2restartPresentation()
                           print("End of Reversals")
                           print("Prepare to Start Next Presentation")
                       }
                   }
               }
           }
       }
    
       
//MARK: - AudioPlayer Methods
   
   func ehaP2pauseRestartTestCycle() {
       ehaP2localMarkNewTestCycle = 0
       ehaP2localReversalEnd = 0
       ehaP2_index = ehaP2_index
       ehaP2_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
       ehaP2testIsPlaying = false
       ehaP2localPlaying = 0
       ehaP2_testCount.removeAll()
       ehaP2_reversalHeard.removeAll()
       ehaP2_averageGain = Float()
       ehaP2_reversalDirection = Float()
       ehaP2localStartingNonHeardArraySet = false
       ehaP2firstHeardResponseIndex = Int()
       ehaP2firstHeardIsTrue = false
       ehaP2secondHeardResponseIndex = Int()
       ehaP2secondHeardIsTrue = false
       ehaP2localTestCount = 0
       ehaP2localReversalHeardLast = Int()
       ehaP2startTooHigh = 0
   }
    
    func ehaP2combinedPauseRestartAndStartNexTestCycle() async {
        ehaP2_testCount.removeAll()
        ehaP2_reversalHeard.removeAll()
        ehaP2_heardArray.removeAll()
        ehaP2_averageGain = Float()
        ehaP2_reversalDirection = Float()
        ehaP2firstHeardResponseIndex = Int()
        ehaP2secondHeardResponseIndex = Int()
        ehaP2localReversalHeardLast = Int()
        ehaP2localSeriesNoResponses = Int()
        ehaP2localStartingNonHeardArraySet = false
        ehaP2firstHeardIsTrue = false
        ehaP2secondHeardIsTrue = false
        ehaP2endTestSeries = false
        ehaP2playingStringColorIndex = 0
        ehaP2startTooHigh = 0
        ehaP2localTestCount = 0
        ehaP2localMarkNewTestCycle = 0
        ehaP2localReversalEnd = 0
        ehaP2_testGain = 0.2
        ehaP2_index = ehaP2_index + 1
        print(ehaP2_eptaSamplesCountArray[ehaP2_index])
        print("ehaP2_index: \(ehaP2_index)")
        ehaP2userPausedTest = false
        ehaP2testIsPlaying = true
        ehaP2localPlaying = 1
//        ehaP2showTestCompletionSheet = false
        ehaP2showTestCompletionSheet.toggle()
    }
    
    
    func ehaP2setPan() {
        ehaP2localPan = ehaP2panArray[ehaP2_index]
        print("Pan: \(ehaP2localPan)")
        print("Pan Index \(ehaP2_index)")
    }
     
    func ehaP2loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
         do{
             let ehaP2urlSample = Bundle.main.path(forResource: ehaP2activeFrequency, ofType: ".wav")
             guard let ehaP2urlSample = ehaP2urlSample else { return print(ehaP2SampleErrors.ehaP2notFound) }
             ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
             guard let ehaP2testPlayer = ehaP2testPlayer else { return }
             ehaP2testPlayer.prepareToPlay()    // Test Player Prepare to Play
             ehaP2testPlayer.setVolume(ehaP2_testGain, fadeDuration: 0)      // Set Gain for Playback
             ehaP2testPlayer.pan = ehaP2localPan
             ehaP2testPlayer.play()   // Start Playback
         } catch { print("Error in playerSessionSetUp Function Execution") }
 }
   
   func ehaP2stop() {
     do{
         let ehaP2urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
         guard let ehaP2urlSample = ehaP2urlSample else { return print(ehaP2SampleErrors.ehaP2notFound) }
         ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
         guard let ehaP2testPlayer = ehaP2testPlayer else { return }
         ehaP2testPlayer.stop()
     } catch { print("Error in Player Stop Function") }
 }
   
   func playTesting() async {
       do{
           let ehaP2urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
           guard let ehaP2urlSample = ehaP2urlSample else {
               return print(ehaP2SampleErrors.ehaP2notFound) }
           ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
           guard let ehaP2testPlayer = ehaP2testPlayer else { return }
           while ehaP2testPlayer.isPlaying == true {
               if ehaP2_heardArray.count > 1 && ehaP2_heardArray.index(after: ehaP2_indexForTest.count-1) == 1 {
                   ehaP2testPlayer.stop()
               print("Stopped in While") }
           }
           ehaP2testPlayer.stop()
           print("Naturally Stopped")
       } catch { print("Error in playTesting") }
   }
   
   func ehaP2resetNonResponseCount() async {ehaP2localSeriesNoResponses = 0 }
   
   func ehaP2nonResponseCounting() async {ehaP2localSeriesNoResponses += 1 }
    
   func ehaP2resetPlaying() async { self.ehaP2localPlaying = 0 }
   
   func ehaP2logNotPlaying() async { self.ehaP2localPlaying = -1 }
   
   func ehaP2resetHeard() async { self.ehaP2localHeard = 0 }
   
   func ehaP2reversalStart() async { self.ehaP2localReversal = 1}
 
    func ehaP2preEventLogging() {
       DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//        DispatchQueue.global(qos: .userInitiated).async {
           ehaP2_indexForTest.append(ehaP2_index)
       }
       DispatchQueue.global(qos: .default).async {
           ehaP2_testTestGain.append(ehaP2_testGain)
       }
       DispatchQueue.global(qos: .background).async {
           ehaP2_frequency.append(ehaP2activeFrequency)
           ehaP2_testPan.append(ehaP2_pan)         // 0 = Left , 1 = Middle, 2 = Right
       }
    }
   
 
//MARK: -HeardArray Methods
   
    func ehaP2responseHeardArray() async {
        ehaP2_heardArray.append(1)
        self.ehaP2idxHA = ehaP2_heardArray.count
        self.ehaP2localStartingNonHeardArraySet = true
    }

    func ehaP2localResponseTracking() async {
        if ehaP2firstHeardIsTrue == false {
            ehaP2firstHeardResponseIndex = ehaP2localTestCount
            ehaP2firstHeardIsTrue = true
        } else if ehaP2firstHeardIsTrue == true {
            ehaP2secondHeardResponseIndex = ehaP2localTestCount
            ehaP2secondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
   

    func ehaP2heardArrayNormalize() async {
        ehaP2idxHA = ehaP2_heardArray.count
        ehaP2idxForTest = ehaP2_indexForTest.count
        ehaP2idxForTestNet1 = ehaP2idxForTest - 1
        ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
        ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)
     
        if ehaP2localStartingNonHeardArraySet == false {
            ehaP2_heardArray.append(0)
            self.ehaP2localStartingNonHeardArraySet = true
            ehaP2idxHA = ehaP2_heardArray.count
            ehaP2idxHAZero = ehaP2idxHA - ehaP2idxHA
            ehaP2idxHAFirst = ehaP2idxHAZero + 1
            ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
            ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)
        } else if ehaP2localStartingNonHeardArraySet == true {
            if ehaP2isCountSame != 0 && ehaP2heardArrayIdxAfnet1 != 1 {
                ehaP2_heardArray.append(0)
                ehaP2idxHA = ehaP2_heardArray.count
                ehaP2idxHAZero = ehaP2idxHA - ehaP2idxHA
                ehaP2idxHAFirst = ehaP2idxHAZero + 1
                ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
                ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)

            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
        } else {
            print("Critial Error in Heard Array Count and or Values")
        }
    }
     
// MARK: -Logging Methods
    func ehaP2count() async {
        ehaP2idxTestCountUpdated = ehaP2_testCount.count + 1
        ehaP2_testCount.append(ehaP2idxTestCountUpdated)
    }
}


//struct EHATTSTestPart2View_Previews: PreviewProvider {
//    static var previews: some View {
//        EHATTSTestPart2View()
//    }
//}

extension EHATTSTestPart2View {
    enum ehaP2LastErrors: Error {
        case ehaP2lastError
        case ehaP2lastUnexpected(code: Int)
    }

    func ehaP2createReversalHeardArray() async {
        ehaP2_reversalHeard.append(ehaP2_heardArray[ehaP2idxHA-1])
        self.ehaP2idxReversalHeardCount = ehaP2_reversalHeard.count
    }
        
    func ehaP2createReversalGainArray() async {
        ehaP2_reversalGain.append(ehaP2_testTestGain[ehaP2idxHA-1])
    }
    
    func ehaP2checkHeardReversalArrays() async {
        if ehaP2idxHA - ehaP2idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if ehaP2idxHA - ehaP2idxReversalHeardCount < 0 && ehaP2idxHA - ehaP2idxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    func ehaP2reversalDirection() async {
        ehaP2localReversalHeardLast = ehaP2_reversalHeard.last ?? -999
        if ehaP2localReversalHeardLast == 1 {
            ehaP2_reversalDirection = -1.0
            ehaP2_reversalDirectionArray.append(-1.0)
        } else if ehaP2localReversalHeardLast == 0 {
            ehaP2_reversalDirection = 1.0
            ehaP2_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    func ehaP2reversalOfOne() async {
        let ehaP2rO1Direction = 0.01 * ehaP2_reversalDirection
        let ehaP2r01NewGain = ehaP2_testGain + ehaP2rO1Direction
        if ehaP2r01NewGain > 0.00001 && ehaP2r01NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r01NewGain * 100000) / 100000
        } else if ehaP2r01NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r01NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfTwo() async {
        let ehaP2rO2Direction = 0.02 * ehaP2_reversalDirection
        let ehaP2r02NewGain = ehaP2_testGain + ehaP2rO2Direction
        if ehaP2r02NewGain > 0.00001 && ehaP2r02NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r02NewGain * 100000) / 100000
        } else if ehaP2r02NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r02NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    func ehaP2reversalOfThree() async {
        let ehaP2rO3Direction = 0.03 * ehaP2_reversalDirection
        let ehaP2r03NewGain = ehaP2_testGain + ehaP2rO3Direction
        if ehaP2r03NewGain > 0.00001 && ehaP2r03NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r03NewGain * 100000) / 100000
        } else if ehaP2r03NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r03NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    func ehaP2reversalOfFour() async {
        let ehaP2rO4Direction = 0.04 * ehaP2_reversalDirection
        let ehaP2r04NewGain = ehaP2_testGain + ehaP2rO4Direction
        if ehaP2r04NewGain > 0.00001 && ehaP2r04NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r04NewGain * 100000) / 100000
        } else if ehaP2r04NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r04NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    func ehaP2reversalOfFive() async {
        let ehaP2rO5Direction = 0.05 * ehaP2_reversalDirection
        let ehaP2r05NewGain = ehaP2_testGain + ehaP2rO5Direction
        if ehaP2r05NewGain > 0.00001 && ehaP2r05NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r05NewGain * 100000) / 100000
        } else if ehaP2r05NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r05NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    func ehaP2reversalOfTen() async {
        let ehaP2r10Direction = 0.10 * ehaP2_reversalDirection
        let ehaP2r10NewGain = ehaP2_testGain + ehaP2r10Direction
        if ehaP2r10NewGain > 0.00001 && ehaP2r10NewGain < 1.0 {
            ehaP2_testGain = roundf(ehaP2r10NewGain * 100000) / 100000
        } else if ehaP2r10NewGain <= 0.0 {
            ehaP2_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2r10NewGain >= 1.0 {
            ehaP2_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    func ehaP2reversalAction() async {
        if ehaP2localReversalHeardLast == 1 {
            await ehaP2reversalOfFive()
        } else if ehaP2localReversalHeardLast == 0 {
            await ehaP2reversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func ehaP2reversalComplexAction() async {
        if ehaP2idxReversalHeardCount <= 1 && ehaP2idxHA <= 1 {
            await ehaP2reversalAction()
        }  else if ehaP2idxReversalHeardCount == 2 {
            if ehaP2idxReversalHeardCount == 2 && ehaP2secondHeardIsTrue == true {
                await ehaP2startTooHighCheck()
            } else if ehaP2idxReversalHeardCount == 2  && ehaP2secondHeardIsTrue == false {
                await ehaP2reversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if ehaP2idxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if ehaP2secondHeardResponseIndex - ehaP2firstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if ehaP2localSeriesNoResponses == 3 {
                await ehaP2reversalOfTen()
            } else if ehaP2localSeriesNoResponses == 2 {
                await ehaP2reversalOfFour()
            } else {
                await ehaP2reversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
//    func ehaP2printReversalGain() async {
//        DispatchQueue.global(qos: .background).async {
//            print("New Gain: \(ehaP2_testGain)")
//            print("Reversal Direcction: \(ehaP2_reversalDirection)")
//        }
//    }
    
    func ehaP2reversalHeardCount1() async {
       await ehaP2reversalAction()
   }
            
    func ehaP2check2PositiveSeriesReversals() async {
        if ehaP2_reversalHeard[ehaP2idxHA-2] == 1 && ehaP2_reversalHeard[ehaP2idxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }

    func ehaP2checkTwoNegativeSeriesReversals() async {
        if ehaP2_reversalHeard.count >= 3 && ehaP2_reversalHeard[ehaP2idxHA-2] == 0 && ehaP2_reversalHeard[ehaP2idxHA-1] == 0 {
            await ehaP2reversalOfFour()
        } else {
            await ehaP2reversalAction()
        }
    }
    
    func ehaP2startTooHighCheck() async {
        if ehaP2startTooHigh == 0 && ehaP2firstHeardIsTrue == true && ehaP2secondHeardIsTrue == true {
            ehaP2startTooHigh = 1
            await ehaP2reversalOfTen()
            await ehaP2resetAfterTooHigh()
            print("Too High Found")
        } else {
            await ehaP2reversalAction()
        }
    }
    
    func ehaP2resetAfterTooHigh() async {
        ehaP2firstHeardResponseIndex = Int()
        ehaP2firstHeardIsTrue = false
        ehaP2secondHeardResponseIndex = Int()
        ehaP2secondHeardIsTrue = false
    }

    func ehaP2reversalsCompleteLogging() async {
        if ehaP2secondHeardIsTrue == true {
            self.ehaP2localReversalEnd = 1
            self.ehaP2localMarkNewTestCycle = 1
            self.ehaP2firstGain = ehaP2_reversalGain[ehaP2firstHeardResponseIndex-1]
            self.ehaP2secondGain = ehaP2_reversalGain[ehaP2secondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let ehaP2delta = ehaP2firstGain - ehaP2secondGain
            let ehaP2avg = (ehaP2firstGain + ehaP2secondGain)/2
            
            if ehaP2delta == 0 {
                ehaP2_averageGain = ehaP2secondGain
                print("average Gain: \(ehaP2_averageGain)")
            } else if ehaP2delta >= 0.05 {
                ehaP2_averageGain = ehaP2secondGain
                print("SecondGain: \(ehaP2firstGain)")
                print("SecondGain: \(ehaP2secondGain)")
                print("average Gain: \(ehaP2_averageGain)")
            } else if ehaP2delta <= -0.05 {
                ehaP2_averageGain = ehaP2firstGain
                print("SecondGain: \(ehaP2firstGain)")
                print("SecondGain: \(ehaP2secondGain)")
                print("average Gain: \(ehaP2_averageGain)")
            } else if ehaP2delta < 0.05 && ehaP2delta > -0.05 {
                ehaP2_averageGain = ehaP2avg
                print("SecondGain: \(ehaP2firstGain)")
                print("SecondGain: \(ehaP2secondGain)")
                print("average Gain: \(ehaP2_averageGain)")
            } else {
                ehaP2_averageGain = ehaP2avg
                print("SecondGain: \(ehaP2firstGain)")
                print("SecondGain: \(ehaP2secondGain)")
                print("average Gain: \(ehaP2_averageGain)")
            }
        } else if ehaP2secondHeardIsTrue == false {
                print("Contine, second hear is true = false")
        } else {
                print("Critical error in reversalsCompletLogging Logic")
        }
    }

    func ehaP2AssignLRAverageSampleGains() async {
//        if localMarkNewTestCycle == 1 && localReversalEnd == 1 && localPan == 1.0 {
//            //go through each assignment based on index
//            if envDataObjectModel_index == 0 {
//                rightFinalGainSample1 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample1)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 1 {
//                rightFinalGainSample2 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample2)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 2 {
//                rightFinalGainSample3 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample3)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 3 {
//                rightFinalGainSample4 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample4)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 4 {
//                rightFinalGainSample5 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample5)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 5 {
//                rightFinalGainSample6 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample6)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 6 {
//                rightFinalGainSample7 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample7)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 7 {
//                rightFinalGainSample8 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample8)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 16 {
//                rightFinalGainSample9 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample9)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 17 {
//                rightFinalGainSample10 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample10)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 18 {
//                rightFinalGainSample11 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample11)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 19 {
//                rightFinalGainSample12 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample12)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 20 {
//                rightFinalGainSample13 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample13)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 21 {
//                rightFinalGainSample14 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample14)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 22 {
//                rightFinalGainSample15 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample15)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else if envDataObjectModel_index == 23 {
//                rightFinalGainSample16 = envDataObjectModel_averageGain
//                rightFinalGainsArray.append(rightFinalGainSample16)
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//            } else {
//                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
//                fatalError("In right side assignLRAverageSampleGains")
//            }
//        } else if localMarkNewTestCycle == 1 && localReversalEnd == 1 && localPan == -1.0 {
//            //Left Side. Go Through Each Assignment based on index for sample
//            if envDataObjectModel_index == 8 {
//                leftFinalGainSample1 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample1)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 9 {
//                leftFinalGainSample2 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample2)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 10 {
//                leftFinalGainSample3 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample3)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 11 {
//                leftFinalGainSample4 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample4)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 12 {
//                leftFinalGainSample5 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample5)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 13 {
//                leftFinalGainSample6 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample6)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 14 {
//                leftFinalGainSample7 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample7)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 15 {
//                leftFinalGainSample8 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample8)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 24 {
//                leftFinalGainSample9 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample9)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 25 {
//                leftFinalGainSample10 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample10)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 26 {
//                leftFinalGainSample11 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample11)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 27 {
//                leftFinalGainSample12 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample12)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 28 {
//                leftFinalGainSample13 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample13)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 29 {
//                leftFinalGainSample14 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample14)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 30 {
//                leftFinalGainSample15 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample15)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else if envDataObjectModel_index == 31 {
//                leftFinalGainSample16 = envDataObjectModel_averageGain
//                leftFinalGainsArray.append(leftFinalGainSample16)
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//            } else {
//                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
//                fatalError("In left side assignLRAverageSampleGains")
//            }
//        } else {
//            // No ready to log yet
//            print("Coninue, not ready to log in assignLRAverageSampleGains")
//        }
    }

    
        
    func ehaP2restartPresentation() async {
        if ehaP2endTestSeries == false {
            ehaP2localPlaying = 1
            ehaP2endTestSeries = false
        } else if ehaP2endTestSeries == true {
            ehaP2localPlaying = -1
            ehaP2endTestSeries = true
            ehaP2showTestCompletionSheet = true
            ehaP2playingStringColorIndex = 2
        }
    }
    
    func ehaP2wipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            ehaP2_heardArray.removeAll()
            ehaP2_testCount.removeAll()
            ehaP2_reversalHeard.removeAll()
            ehaP2_averageGain = Float()
            ehaP2_reversalDirection = Float()
            ehaP2localStartingNonHeardArraySet = false
            ehaP2firstHeardResponseIndex = Int()
            ehaP2firstHeardIsTrue = false
            ehaP2secondHeardResponseIndex = Int()
            ehaP2secondHeardIsTrue = false
            ehaP2localTestCount = 0
            ehaP2localReversalHeardLast = Int()
            ehaP2startTooHigh = 0
            ehaP2localSeriesNoResponses = Int()
        })
    }
    
    func startNextTestCycle() async {
        await ehaP2wipeArrays()
        ehaP2showTestCompletionSheet.toggle()
        ehaP2startTooHigh = 0
        ehaP2localMarkNewTestCycle = 0
        ehaP2localReversalEnd = 0
        ehaP2_index = ehaP2_index + 1
//        envDataObjectModel_eptaSamplesCountArrayIdx += 1
        ehaP2_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        ehaP2endTestSeries = false
        ehaP2showTestCompletionSheet = false
        ehaP2testIsPlaying = true
        ehaP2userPausedTest = false
        ehaP2playingStringColorIndex = 2
//        envDataObjectModel_eptaSamplesCount = envDataObjectModel_eptaSamplesCount + 8
        print(ehaP2_eptaSamplesCountArray[ehaP2_index])
        ehaP2localPlaying = 1
    }
    
    
    
    func ehaP2newTestCycle() async {
//        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index < ehaP2_eptaSamplesCount && ehaP2endTestSeries == false {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index < ehaP2_eptaSamplesCountArray[ehaP2_index] && ehaP2endTestSeries == false {
            ehaP2startTooHigh = 0
            ehaP2localMarkNewTestCycle = 0
            ehaP2localReversalEnd = 0
            ehaP2_index = ehaP2_index + 1
            ehaP2_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
            ehaP2endTestSeries = false
//                Task(priority: .userInitiated) {
            await ehaP2wipeArrays()
//                }
//        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index == ehaP2_eptaSamplesCount && ehaP2endTestSeries == false {
        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index == ehaP2_eptaSamplesCountArray[ehaP2_index] && ehaP2endTestSeries == false {
            ehaP2endTestSeries = true
            ehaP2localPlaying = -1
            ehaP2_eptaSamplesCountArrayIdx += 1
                print("=============================")
                print("!!!!! End of Test Series!!!!!!")
                print("=============================")
        } else {
//                print("Reversal Limit Not Hit")

        }
    }
    
    func ehaP2endTestSeries() async {
        if ehaP2endTestSeries == false {
            //Do Nothing and continue
            print("end Test Series = \(ehaP2endTestSeries)")
        } else if ehaP2endTestSeries == true {
            ehaP2showTestCompletionSheet = true
            ehaP2_eptaSamplesCount = ehaP2_eptaSamplesCount + 8
            await ehaP2endTestSeriesStop()
        }
    }
    
    func ehaP2endTestSeriesStop() async {
        ehaP2localPlaying = -1
        ehaP2stop()
        ehaP2userPausedTest = true
        ehaP2playingStringColorIndex = 2
        if ehaP2_index == 31 {
            ehaP2playingStringColorIndex2 = 2
        } else {
            ehaP2playingStringColorIndex2 = 1
        }
        
//        ehaP2audioThread.async {
//            ehaP2localPlaying = 0
//            ehaP2stop()
//            ehaP2userPausedTest = true
//            ehaP2playingStringColorIndex = 2
//        }
//
//        DispatchQueue.main.async {
//            ehaP2localPlaying = 0
//            ehaP2stop()
//            ehaP2userPausedTest = true
//            ehaP2playingStringColorIndex = 2
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
//            ehaP2localPlaying = 0
//            ehaP2stop()
//            ehaP2userPausedTest = true
//            ehaP2playingStringColorIndex = 2
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInitiated) {
//            ehaP2localPlaying = -1
//            ehaP2stop()
//            ehaP2userPausedTest = true
//            ehaP2playingStringColorIndex = 2
//        }
    }

    
    func ehaP2concatenateFinalArrays() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 {
            ehaP2_finalStoredIndex.append(contentsOf: [100000000] + ehaP2_indexForTest)
            ehaP2_finalStoredTestPan.append(contentsOf: [100000000] + ehaP2_testPan)
            ehaP2_finalStoredTestTestGain.append(contentsOf: [1000000.0] + ehaP2_testTestGain)
            ehaP2_finalStoredFrequency.append(contentsOf: ["100000000"] + [String(ehaP2activeFrequency)])
            ehaP2_finalStoredTestCount.append(contentsOf: [100000000] + ehaP2_testCount)
            ehaP2_finalStoredHeardArray.append(contentsOf: [100000000] + ehaP2_heardArray)
            ehaP2_finalStoredReversalHeard.append(contentsOf: [100000000] + ehaP2_reversalHeard)
            ehaP2_finalStoredFirstGain.append(contentsOf: [1000000.0] + [ehaP2firstGain])
            ehaP2_finalStoredSecondGain.append(contentsOf: [1000000.0] + [ehaP2secondGain])
            ehaP2_finalStoredAverageGain.append(contentsOf: [1000000.0] + [ehaP2_averageGain])
            ehaP2finalStoredRightFinalGainsArray.removeAll()
            ehaP2finalStoredleftFinalGainsArray.removeAll()
            ehaP2finalStoredRightFinalGainsArray.append(contentsOf: ehaP2rightFinalGainsArray)
            ehaP2finalStoredleftFinalGainsArray.append(contentsOf: ehaP2leftFinalGainsArray)
            
            
        }
    }
    
    func ehaP2printConcatenatedArrays() async {
        print("finalStoredIndex: \(ehaP2_finalStoredIndex)")
        print("finalStoredTestPan: \(ehaP2_finalStoredTestPan)")
        print("finalStoredTestTestGain: \(ehaP2_finalStoredTestTestGain)")
        print("finalStoredFrequency: \(ehaP2_finalStoredFrequency)")
        print("finalStoredTestCount: \(ehaP2_finalStoredTestCount)")
        print("finalStoredHeardArray: \(ehaP2_finalStoredHeardArray)")
        print("finalStoredReversalHeard: \(ehaP2_finalStoredReversalHeard)")
        print("finalStoredFirstGain: \(ehaP2_finalStoredFirstGain)")
        print("finalStoredSecondGain: \(ehaP2_finalStoredSecondGain)")
        print("finalStoredAverageGain: \(ehaP2_finalStoredAverageGain)")
        print("eha2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
        print("eha2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
        print("eha2finalStoredRightFinalGainsArray: \(ehaP2finalStoredRightFinalGainsArray)")
        print("eha2finalStoredleftFinalGainsArray: \(ehaP2finalStoredleftFinalGainsArray)")
    }
        
    func ehaP2saveFinalStoredArrays() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
                    await writeEHAP2DetailedResultsToCSV()
                    await writeEHAP2SummarydResultsToCSV()
                    await writeEHAP2InputDetailedResultsToCSV()
                    await writeEHAP2InputDetailedResultsToCSV()
                    
                    await writeEHAP2RightLeftResultsToCSV()
                    await writeEHAP2RightResultsToCSV()
                    await writeEHAP2LeftResultsToCSV()
                    await writeEHAP2InputRightLeftResultsToCSV()
                    await writeEHAP2InputRightResultsToCSV()
                    await writeEHAP2InputLeftResultsToCSV()
                    
                    await ehaP2getEHAP1Data()
                    await ehaP2saveEHA1ToJSON()
        //                await ehaP2_uploadSummaryResultsTest()
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
    
    func ehaP2getEHAP1Data() async {
        guard let ehaP2data = await ehaP2getEHAP1JSONData() else { return }
        print("Json Data:")
        print(ehaP2data)
        let ehaP2jsonString = String(data: ehaP2data, encoding: .utf8)
        print(ehaP2jsonString!)
        do {
        self.ehaP2saveFinalResults = try JSONDecoder().decode(ehaP2SaveFinalResults.self, from: ehaP2data)
            print("JSON GetData Run")
            print("data: \(ehaP2data)")
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func ehaP2getEHAP1JSONData() async -> Data? {
        let ehaP2saveFinalResults = ehaP2SaveFinalResults(
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
            jsonFrequency: [ehaP2activeFrequency],
            jsonPan: ehaP2_finalStoredTestPan,
            jsonStoredIndex: ehaP2_finalStoredIndex,
            jsonStoredTestPan: ehaP2_finalStoredTestPan,
            jsonStoredTestTestGain: ehaP2_finalStoredTestTestGain,
            jsonStoredTestCount: ehaP2_finalStoredTestCount,
            jsonStoredHeardArray: ehaP2_finalStoredHeardArray,
            jsonStoredReversalHeard: ehaP2_finalStoredReversalHeard,
            jsonStoredFirstGain: ehaP2_finalStoredFirstGain,
            jsonStoredSecondGain: ehaP2_finalStoredSecondGain,
            jsonStoredAverageGain: ehaP2_finalStoredAverageGain)
//    jsonRightFinalGainsArray: rightFinalGainsArray,
//    jsonLeftFinalGainsArray: leftFinalGainsArray,
//    jsonFinalStoredRightFinalGainsArray: finalStoredRightFinalGainsArray,
//    jsonFinalStoredleftFinalGainsArray: finalStoredleftFinalGainsArray)

        let ehaP2jsonData = try? JSONEncoder().encode(ehaP2saveFinalResults)
        print("saveFinalResults: \(ehaP2saveFinalResults)")
        print("Json Encoded \(ehaP2jsonData!)")
        return ehaP2jsonData
    }

    func ehaP2saveEHA1ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let ehaP2paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let ehaP2DocumentsDirectory = ehaP2paths[0]
        print("ehaP2DocumentsDirectory: \(ehaP2DocumentsDirectory)")
        let ehaP2FilePaths = ehaP2DocumentsDirectory.appendingPathComponent(fileehaP2Name)
        print(ehaP2FilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let ehaP2jsonData = try encoder.encode(ehaP2saveFinalResults)
            print(ehaP2jsonData)
          
            try ehaP2jsonData.write(to: ehaP2FilePaths)
        } catch {
            print("Error writing EHAP1 to JSON file: \(error)")
        }
    }

    func writeEHAP2DetailedResultsToCSV() async {
        let ehaP2stringFinalStoredIndex = "finalStoredIndex," + ehaP2_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = "finalStoredTestPan," + ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestTestGain = "finalStoredTestTestGain," + ehaP2_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFrequency = "finalStoredFrequency," + [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestCount = "finalStoredTestCount," + ehaP2_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredHeardArray = "finalStoredHeardArray," + ehaP2_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredReversalHeard = "finalStoredReversalHeard," + ehaP2_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredPan = "finalStoredPan," + ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = "finalStoredFirstGain," + ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = "finalStoredSecondGain," + ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = "finalStoredAverageGain," + ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
        do {
            let csvehaP2DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvehaP2DetailDocumentsDirectory = csvehaP2DetailPath
//                print("CSV DocumentsDirectory: \(csvEHAP1DetailDocumentsDirectory)")
            let csvehaP2DetailFilePath = csvehaP2DetailDocumentsDirectory.appendingPathComponent(detailedehaP2CSVName)
            print(csvehaP2DetailFilePath)
            
            let writer = try CSVWriter(fileURL: csvehaP2DetailFilePath, append: false)
            
            try writer.write(row: [ehaP2stringFinalStoredIndex])
            try writer.write(row: [ehaP2stringFinalStoredTestPan])
            try writer.write(row: [ehaP2stringFinalStoredTestTestGain])
            try writer.write(row: [ehaP2stringFinalStoredFrequency])
            try writer.write(row: [ehaP2stringFinalStoredTestCount])
            try writer.write(row: [ehaP2stringFinalStoredHeardArray])
            try writer.write(row: [ehaP2stringFinalStoredReversalHeard])
            try writer.write(row: [ehaP2stringFinalStoredPan])
            try writer.write(row: [ehaP2stringFinalStoredFirstGain])
            try writer.write(row: [ehaP2stringFinalStoredSecondGain])
            try writer.write(row: [ehaP2stringFinalStoredAverageGain])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
//
//                print("CVS EHAP1 Detailed Writer Success")
        } catch {
            print("CVSWriter EHAP1 Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }

    func writeEHAP2SummarydResultsToCSV() async {
        let ehaP2stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = "finalStoredTestPan," + ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = "finalStoredFirstGain," + ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = "finalStoredSecondGain," + ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = "finalStoredAverageGain," + ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvehaP2SummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvehaP2SummaryDocumentsDirectory = csvehaP2SummaryPath
//                 print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvEHAP1SummaryDocumentsDirectory)")
             let csvehaP2SummaryFilePath = csvehaP2SummaryDocumentsDirectory.appendingPathComponent(summaryehaP2CSVName)
             print(csvehaP2SummaryFilePath)
             let writer = try CSVWriter(fileURL: csvehaP2SummaryFilePath, append: false)
             try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
             try writer.write(row: [ehaP2stringFinalStoredTestPan])
             try writer.write(row: [ehaP2stringFinalStoredFirstGain])
             try writer.write(row: [ehaP2stringFinalStoredSecondGain])
             try writer.write(row: [ehaP2stringFinalStoredAverageGain])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func writeEHAP2InputDetailedResultsToCSV() async {
        let ehaP2stringFinalStoredIndex = ehaP2_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestTestGain = ehaP2_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestCount = ehaP2_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredHeardArray = ehaP2_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredReversalHeard = ehaP2_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredResultsFrequency = [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredPan = ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")

        do {
            let csvInputehaP2DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputehaP2DetailDocumentsDirectory = csvInputehaP2DetailPath
//                print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputEHAP1DetailDocumentsDirectory)")
            let csvInputehaP2DetailFilePath = csvInputehaP2DetailDocumentsDirectory.appendingPathComponent(inputehaP2DetailedCSVName)
            print(csvInputehaP2DetailFilePath)
            let writer = try CSVWriter(fileURL: csvInputehaP2DetailFilePath, append: false)
            try writer.write(row: [ehaP2stringFinalStoredIndex])
            try writer.write(row: [ehaP2stringFinalStoredTestPan])
            try writer.write(row: [ehaP2stringFinalStoredTestTestGain])
            try writer.write(row: [ehaP2stringFinalStoredTestCount])
            try writer.write(row: [ehaP2stringFinalStoredHeardArray])
            try writer.write(row: [ehaP2stringFinalStoredReversalHeard])
            try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
            try writer.write(row: [ehaP2stringFinalStoredPan])
            try writer.write(row: [ehaP2stringFinalStoredFirstGain])
            try writer.write(row: [ehaP2stringFinalStoredSecondGain])
            try writer.write(row: [ehaP2stringFinalStoredAverageGain])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
//
//                print("CVS Input EHA Part 1Detailed Writer Success")
        } catch {
            print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }

    func writeEHAP2InputSummarydResultsToCSV() async {
        let ehaP2stringFinalStoredResultsFrequency = [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         
         do {
             let csvehaP2InputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvehaP2InputSummaryDocumentsDirectory = csvehaP2InputSummaryPath
             print("CSV Input ehaP2 Summary DocumentsDirectory: \(csvehaP2InputSummaryDocumentsDirectory)")
             let csvehaP2InputSummaryFilePath = csvehaP2InputSummaryDocumentsDirectory.appendingPathComponent(inputehaP2SummaryCSVName)
             print(csvehaP2InputSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvehaP2InputSummaryFilePath, append: false)
             try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
             try writer.write(row: [ehaP2stringFinalStoredTestPan])
             try writer.write(row: [ehaP2stringFinalStoredFirstGain])
             try writer.write(row: [ehaP2stringFinalStoredSecondGain])
             try writer.write(row: [ehaP2stringFinalStoredAverageGain])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Input EHA Part 1 Summary Data Writer Success")
         } catch {
             print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
         }
    }
    
    func writeEHAP2RightLeftResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2LRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2LRSummaryDocumentsDirectory = csvEHAP2LRSummaryPath
//                 print("CSV Summary EHA Part 2 LR Summary DocumentsDirectory: \(csvEHAP2LRSummaryDocumentsDirectory)")
             let csvEHAP2LRSummaryFilePath = csvEHAP2LRSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2LRCSVName)
//             print(csvEHAP2LRSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2LRSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 2 LR Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 LR Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2RightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2RightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2RightSummaryDocumentsDirectory = csvEHAP2RightSummaryPath
//                 print("CSV Summary EHA Part 2 Right Summary DocumentsDirectory: \(csvEHAP2RightSummaryDocumentsDirectory)")
             let csvEHAP2RightSummaryFilePath = csvEHAP2RightSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2RightCSVName)
//             print(csvEHAP1RightSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2RightSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
//                 print("CVS Summary EHA Part 2 Right Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 Right Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2LeftResultsToCSV() async {
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2LeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2LeftSummaryDocumentsDirectory = csvEHAP2LeftSummaryPath
//                 print("CSV Summary EHA Part 1 Left Summary DocumentsDirectory: \(csvEHAP1LeftSummaryDocumentsDirectory)")
             let csvEHAP2LeftSummaryFilePath = csvEHAP2LeftSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2LeftCSVName)
//             print(csvEHAP2LeftSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2LeftSummaryFilePath, append: false)
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 2 Left Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 Left Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2InputRightLeftResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2InputLRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputLRSummaryDocumentsDirectory = csvEHAP2InputLRSummaryPath
//                 print("CSV Summary EHA Part 2 LR Summary DocumentsDirectory: \(csvEHAP2LRSummaryDocumentsDirectory)")
             let csvEHAP2InputLRSummaryFilePath = csvEHAP2InputLRSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2LRSummaryCSVName)
//             print(csvEHAP2InputLRSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2InputLRSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 2 LR Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 LR Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func writeEHAP2InputRightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2InputRightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputRightSummaryDocumentsDirectory = csvEHAP2InputRightSummaryPath
//                 print("CSV Summary EHA Part 2 Right Input DocumentsDirectory: \(csvEHAP2InputRightSummaryDocumentsDirectory)")
             let csvEHAP2InputRightSummaryFilePath = csvEHAP2InputRightSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2RightSummaryCSVName)
//             print(csvEHAP2InputRightSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2InputRightSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
//                 print("CVS Summary EHA Part 2 Right Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 Right Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2InputLeftResultsToCSV() async {
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         do {
             let csvEHAP2InputLeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputLeftSummaryDocumentsDirectory = csvEHAP2InputLeftSummaryPath
//                 print("CSV Summary EHA Part 2 Left Input DocumentsDirectory: \(csvEHAP2InputSummaryDocumentsDirectory)")
             let csvEHAP2InputLeftSummaryFilePath = csvEHAP2InputLeftSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2LeftSummaryCSVName)
             print(csvEHAP2InputLeftSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2InputLeftSummaryFilePath, append: false)
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 2 Left Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 2 Left Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
}

