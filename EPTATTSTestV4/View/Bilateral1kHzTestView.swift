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
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
//import Alamofire

struct Bilateral1kHzTestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            Bilateral1kHzTestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading Bilateral1kHzTest View")
                .navigationTitle("")
        }
    }
}


struct onekHzSaveFinalResults: Codable {  // This is a model 
    var json_onekHz_Name = String()
    var json_onekHz_Age = Int()
    var json_onekHz_Sex = Int()
    var json_onekHz_onekHzactiveFrequency = String()
    var json_onekHz_onekHzfirstGain = Float()
    var json_onekHz_onekHzsecondGain = Float()
    var json_onekHz_heardArray = [Int]()
    var json_onekHz_reversalHeard = [Int]()
    var json_onekHz_reversalGain = [Float]()
    var json_onekHz_testTestGain = [Float]()
    var json_onekHz_averageGain = Float()
    var json_onekHz_averageGainRightArray = [Float]()
    var json_onekHz_averageGainLeftArray = [Float]()
    var json_onekHz_averageLowestGainRightArray = [Float]()
    var json_onekHz_HoldingLowestRightGainArray = [Float]()
    var json_onekHz_averageLowestGainLeftArray = [Float]()
    var json_onekHz_HoldingLowestLeftGainArray = [Float]()
}


struct Bilateral1kHzTestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    enum onekHzSampleErrors: Error {
        case onekHznotFound
        case onekHzunexpected(code: Int)
    }
    
    enum onekHzFirebaseErrors: Error {
        case onekHzunknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    
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
    @State var onekHzfirstGainLeft1 = Float()
    @State var onekHzsecondGainLeft1 = Float()
    @State var onekHzfirstGainLeft2 = Float()
    @State var onekHzsecondGainLeft2 = Float()
    
    @State var onekHz_rightFirstSecondGainArray: [Float] = [Float]()
    @State var onekHz_leftFirstSecondGainArray: [Float] = [Float]()
    
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
    
    //!!!!!!Changes
    @State var onekHz_samples: [String] = [String]()
    
    @State private var highResStdSamples: [String] = ["Sample0", "Sample0", "Sample0", "Sample0", "Sample0", "Sample0", "Sample0", "Sample0"]
    @State private var highResFadedSamples: [String] = ["FSample0", "FSample0", "FSample0", "FSample0", "FSample0", "FSample0", "FSample0", "FSample0"]
    @State private var cdFadedDitheredSamples: [String] = ["FDSample1", "FDSample1", "FDSample1", "FDSample1", "FDSample1", "FDSample1", "FDSample1", "FDSample1"]
    
    @State var onekHz_panSettingArray: [Float] = [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0]    // -1.0 = Left , 0.0 = Middle, 1.0 = Right
    @State var pan: Float = 1.0
    //!!!!! Changes Above
    
    
//
//
//
// Added Manual AirPods Pro Gen 2 Values for Calibration
    @State var onekHz_StartingDB: Float = 21.0
    @State var onekHz_AirPodsProGen2MaxDB: Float = 111.74468    //Make this a freq dependent array in other views linked to index
    @State var onekHz_PriorDB: Float = Float()
    @State var onekHz_CurrentDB: Float = Float()
    @State var onekHz_StepSizeDB: Float = 0.0
    @State var onekHz_NewTargetDB: Float = Float()
  
    @State var onekHz_testGainDB: Float = Float() //0.025
    @State var onekHz_reversalGainDB = [Float]()
    @State var onekHz_testTestGainDB = [Float]()
   
    
    @State var onekHzfirstGainDB = Float()
    @State var onekHzsecondGainDB = Float()
    
    @State var onekHzfirstGainDBRight1 = Float()
    @State var onekHzsecondGainDBRight1 = Float()
    @State var onekHzfirstGainDBRight2 = Float()
    @State var onekHzsecondGainDBRight2 = Float()
    @State var onekHzfirstGainDBLeft1 = Float()
    @State var onekHzsecondGainDBLeft1 = Float()
    @State var onekHzfirstGainDBLeft2 = Float()
    @State var onekHzsecondGainDBLeft2 = Float()
    
    @State var onekHz_rightFirstSecondGainDBArray: [Float] = [Float]()
    @State var onekHz_leftFirstSecondGainDBArray: [Float] = [Float]()
    
   
    @State var onekHzRightDBSorted: [Float] = [Float]()
    @State var onekHzLeftDBSorted: [Float] = [Float]()
    @State var onekHzIntraEarDeltaHL1DB = Float()
    @State var onekHzIntraEarDeltaHL2DB = Float()
    @State var onekHzIntraEarDeltaHLFinalDB = Float()
    
    @State var onekHzFinalLRGainsDB1: [Float] = [Float]()
    @State var onekHzFinalLRGainsDB2: [Float] = [Float]()
    @State var onekHzInterimLRGainsDBFinal: [Float] = [Float]()
    @State var onekHzFinalComboLRGainsDB: [Float] = [Float]()
    
    
    @State var onekHz_averageGainDB = Float()
    @State var onekHz_averageGainDBRight = Float()
    @State var onekHz_averageGainDBLeft = Float()
    
    @State var onekHz_averageGainDBRight1 = Float()
    @State var onekHz_averageGainDBRight2 = Float()
    @State var onekHz_averageGainDBRightArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainDBRightArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainDBRightArray = Float()
    @State var onekHz_idxlastAverageGainDBRightArray = Float()
    
    @State var onekHz_averageGainDBLeft1 = Float()
    @State var onekHz_averageGainDBLeft2 = Float()
    @State var onekHz_averageGainDBLeftArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainDBLeftArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainDBLeftArray = Float()
    @State var onekHz_idxlastAverageGainDBLeftArray = Float()
    
    @State var onekHz_HoldingLowestRightGainDBArray: [Float] = [Float]()
    @State var onekHz_HoldingLowestLeftGainDBArray: [Float] = [Float]()
  
    
    @State var onekHz_finalStoredFirstGainDB: [Float] = [Float]()
    @State var onekHz_finalStoredSecondGainDB: [Float] = [Float]()
    
    
    @State var final_onekHz_onekHzfirstGainDB = [Float]()
    @State var final_onekHz_onekHzsecondGainDB = [Float]()
    @State var final_onekHz_reversalGainDB = [Float]()
    @State var final_onekHz_testTestGainDB = [Float]()
    @State var final_onekHz_averageGainDB = [Float]()
    @State var final_onekHz_averageGainDBRightArray = [Float]()
    @State var final_onekHz_averageGainDBLeftArray = [Float]()
    @State var final_onekHz_averageLowestGainDBRightArray = [Float]()
    @State var final_onekHz_HoldingLowestRightGainDBArray = [Float]()
    @State var final_onekHz_averageLowestGainDBLeftArray = [Float]()
    @State var final_onekHz_HoldingLowestLeftGainDBArray = [Float]()

    @State var onekHz_finalStoredAverageGainDB: [Float] = [Float]()
    
// End of Added DB Variables
//
//
//
    
    @State var onekHz_index: Int = 0
    @State var onekHz_testGain: Float = Float() //0.025
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
    @State var onekHz_reversalDirection = Float()
    @State var onekHz_reversalDirectionArray = [Float]()
    
    //!!!Changes
    @State var onekHz_averageGain = Float()
    @State var onekHz_averageGainRight = Float()
    @State var onekHz_averageGainLeft = Float()
    
    @State var onekHz_averageGainRight1 = Float()
    @State var onekHz_averageGainRight2 = Float()
    @State var onekHz_averageGainRightArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainRightArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainRightArray = Float()
    @State var onekHz_idxlastAverageGainRightArray = Float()
    
    @State var onekHz_averageGainLeft1 = Float()
    @State var onekHz_averageGainLeft2 = Float()
    @State var onekHz_averageGainLeftArray: [Float] = [Float]()
    @State var onekHz_averageLowestGainLeftArray: [Float] = [Float]()
    @State var onekHz_idxFirstAverageGainLeftArray = Float()
    @State var onekHz_idxlastAverageGainLeftArray = Float()
    
    @State var onekHz_HoldingLowestRightGainArray: [Float] = [Float]()
    @State var onekHz_HoldingLowestLeftGainArray: [Float] = [Float]()
    
    
    //!!!!Changes
    
    
    @State var onekHz_eptaSamplesCount = 7 // 3 //17
    
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

    
    @State var final_onekHz_Name = [String]()
    @State var final_onekHz_Age = [Int]()
    @State var final_onekHz_Sex = [Int]()
    @State var final_onekHz_onekHzactiveFrequency = [String]()
    @State var final_onekHz_onekHzfirstGain = [Float]()
    @State var final_onekHz_onekHzsecondGain = [Float]()
    @State var final_onekHz_heardArray = [Int]()
    @State var final_onekHz_reversalHeard = [Int]()
    @State var final_onekHz_reversalGain = [Float]()
    @State var final_onekHz_testTestGain = [Float]()
    @State var final_onekHz_averageGain = [Float]()
    @State var final_onekHz_averageGainRightArray = [Float]()
    @State var final_onekHz_averageGainLeftArray = [Float]()
    @State var final_onekHz_averageLowestGainRightArray = [Float]()
    @State var final_onekHz_HoldingLowestRightGainArray = [Float]()
    @State var final_onekHz_averageLowestGainLeftArray = [Float]()
    @State var final_onekHz_HoldingLowestLeftGainArray = [Float]()
    
    //!!!Changes
    @State var onekHz_finalStoredAverageGain: [Float] = [Float]()
    
    
    
    @State var onekHzidxForTest = Int() // = onekHz_indexForTest.count
    @State var onekHzidxForTestNet1 = Int() // = onekHz_indexForTest.count - 1
    @State var onekHzidxTestCountUpdated = Int() // = onekHz_TestCount.count + 1
    @State var onekHzactiveFrequency = String()
    @State var onekHzidxHA = Int()    // idx = onekHz_heardArray.count
    @State var onekHzidxReversalHeardCount = Int()
    @State var onekHzidxHAZero = Int()    //  idxZero = idx - idx
    @State var onekHzidxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var onekHzisCountSame = Int()
    @State var onekHzheardArrayIdxAfnet1 = Int()
    @State var onekHztestIsPlaying: Bool = false
    @State var onekHzplayingString: [String] = ["", "Restart Test", "Great Job, You've\nCompleted This Test Segment"]
    @State var onekHzplayingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State var onekHzplayingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    
    @State var onekHzplayingStringColorIndex = 0
    @State var onekHzuserPausedTest: Bool = false
    
//    @State var RightEar1kHzdB1 = Float()
//    @State var RightEar1kHzdB2 = Float()
//    @State var LeftEar1kHzdB1 = Float()
//    @State var LeftEar1kHzdB2 = Float()
//    @State var RightEar1kHzdBFinal = Float()
//    @State var LeftEar1kHzdBFinal = Float()
    
    @State var bilateral1kHzTestCompleted: Bool = false
    
    @State var continuePastBilateralTest: Bool = false
    
    @State var onekHzjsonHoldingString: [String] = [String]()
    
    @State var onekHzTestStarted: Bool = false
    
    let fileOnekHzName = "SummaryOnekHzResults.json"
    let summaryOnekHzCSVName = "SummaryOnekHzResultsCSV.csv"
    let detailedOnekHzCSVName = "DetailedOnekHzResultsCSV.csv"
    let inputOnekHzSummaryCSVName = "InputSummaryOnekHzResultsCSV.csv"
    let inputOnekHzDetailedCSVName = "InputDetailedOnekHzResultsCSV.csv"
    
    @State var onekHzsaveFinalResults: onekHzSaveFinalResults? = nil
    
    let onekHzheardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let onekHzarrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let onekHzaudioThread = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let onekHzpreEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var changeSampleArray: Bool = false
    @State private var highResStandard: Bool = false
    @State private var highResFaded: Bool = false
    @State private var cdFadedDithered: Bool = false
    @State private var sampleArraySet: Bool = false
    
    let onekHzaudioThreadBackground = DispatchQueue(label: "AudioThread", qos: .background)
    let onekHzaudioThreadDefault = DispatchQueue(label: "AudioThread", qos: .default)
    let onekHzaudioThreadUserInteractive = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let onekHzaudioThreadUserInitiated = DispatchQueue(label: "AudioThread", qos: .userInitiated)
    
    @State private var showQoSThreads: Bool = false
    @State private var qualityOfService = Int()
    @State private var qosBackground: Bool = false
    @State private var qosDefault: Bool = false
    @State private var qosUserInteractive: Bool = false
    @State private var qosUserInitiated: Bool = false
    
    @State private var showDataValues: Bool = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                HStack{
                    if bilateral1kHzTestCompleted == false {
                        VStack{
                            
                            Toggle(isOn: $showDataValues) {
                                Text("ShowDataValues")
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 40)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom,20)
                            
                            HStack{
                                Spacer()
                                Text("Bilateral 1kHz Test")
                                Spacer()
                            }
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            
                            if showDataValues == true {
                                HStack{
                                    Spacer()
                                    Text("CurrentDB: \(onekHz_CurrentDB)")
                                    Spacer()
                                    Text("NewTargetDB: \(onekHz_NewTargetDB)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                HStack{
                                    Spacer()
                                    Text("testGainDB: \(onekHz_testGainDB)")
                                    Spacer()
                                    Text("StepSizeDB: \(onekHz_StepSizeDB)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                HStack{
                                    Spacer()
                                    Text("testGain: \(onekHz_testGain)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 20)
                            }
                        }
                    } else if bilateral1kHzTestCompleted == true {
                        NavigationLink("Test Phase Complete. Continue.", destination: PostBilateral1kHzTestView(testing: testing, relatedLinkTesting: relatedLinkTesting))
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                    }
                }
                .navigationDestination(isPresented: $bilateral1kHzTestCompleted) {
                    PostBilateral1kHzTestView(testing: testing, relatedLinkTesting: linkTesting)
                }
                

                if onekHzTestStarted == false {
                    Button {
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()

// Change Add Below
//                            onekHz_CurrentDB = onekHz_StartingDB
//                            onekHz_NewTargetDB = onekHz_CurrentDB
//                            await dBToGain(onekHz_NewTargetDB: onekHz_StartingDB)   //Sets onekHz_testGain value in FS
// Change Add Above
                            
                            onekHzlocalPlaying = 1
                            changeSampleArray = false
                            print("Start Button Clicked. Playing = \(onekHzlocalPlaying)")
                        }
                    } label: {
                        Text("Click to Start")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    Text("")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color .clear)
                        .foregroundColor(.clear)
                        .cornerRadius(24)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                } else if onekHzTestStarted == true {
                    Button {
                        onekHzlocalPlaying = 0
                        onekHzstop()
                        onekHzuserPausedTest = true
                        onekHzplayingStringColorIndex = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                            onekHzlocalPlaying = 0
                            onekHzstop()
                            onekHzuserPausedTest = true
                            onekHzplayingStringColorIndex = 1
                        }
                    } label: {
                        Text("Pause Test")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(Color .yellow)
                            .foregroundColor(.black)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    // Restart Button Issue
                    //Try thread change
                    Button {
                        onekHzheardThread.async{
                            onekHz_heardArray.removeAll()
                            onekHzpauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            onekHzlocalPlaying = 1
                            onekHzuserPausedTest = false
                            onekHzplayingStringColorIndex = 0
                            print("Start Button Clicked. Playing = \(onekHzlocalPlaying)")
                        }
                    } label: {
                        Text(onekHzplayingString[onekHzplayingStringColorIndex])
                            .foregroundColor(onekHzplayingAlternateStringColor[onekHzplayingStringColorIndex+1])
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(onekHzplayingAlternateStringColor[onekHzplayingStringColorIndex])
                            .cornerRadius(24)
                        
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                Button {
                    onekHzheardThread.async{ self.onekHzlocalHeard = 1
                    }
                } label: {
                    Text("Press if You Hear The Tone")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 300, height: 100, alignment: .center)
                        .background(Color .green)
                        .foregroundColor(.black)
                        .cornerRadius(24)
                }
                .padding(.top, 20)
                .padding(.bottom, 80)
                Spacer()
            }
            .onAppear {
                onekHzshowTestCompletionSheet = true
                audioSessionModel.cancelAudioSession()
            }
            .fullScreenCover(isPresented: $onekHzshowTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            onekHzshowTestCompletionSheet.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.clear)
                        })
                        if bilateral1kHzTestCompleted == false {
                            VStack(alignment: .leading, spacing: 10){
                                Toggle(isOn: $showQoSThreads) {
                                    Text("Change Qos Threads")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                if showQoSThreads == true {
                                    HStack{
                                        Toggle("Background", isOn: $qosBackground)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("Default", isOn: $qosDefault)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                    HStack{
                                        Toggle("UserInteractive", isOn: $qosUserInteractive)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("UserInitiated", isOn: $qosUserInitiated)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                }
                            }
                            .onChange(of: qosBackground) { backgroundValue in
                                if backgroundValue == true {
                                    qosBackground = true
                                    qosDefault = false
                                    qosUserInteractive = false
                                    qosUserInitiated = false
                                    qualityOfService = 1
                                }
                            }
                            .onChange(of: qosDefault) { defaultValue in
                                if defaultValue == true {
                                    qosBackground = false
                                    qosDefault = true
                                    qosUserInteractive = false
                                    qosUserInitiated = false
                                    qualityOfService = 2
                                }
                            }
                            .onChange(of: qosUserInteractive) { interactiveValue in
                                if interactiveValue == true {
                                    qosBackground = false
                                    qosDefault = false
                                    qosUserInteractive = true
                                    qosUserInitiated = false
                                    qualityOfService = 3
                                }
                            }
                            .onChange(of: qosUserInitiated) { initiatedValue in
                                if initiatedValue == true {
                                    qosBackground = false
                                    qosDefault = false
                                    qosUserInteractive = false
                                    qosUserInitiated = true
                                    qualityOfService = 4
                                }
                            }
                        }
                        
                        if bilateral1kHzTestCompleted == false {
                            VStack{
                                Toggle(isOn: $changeSampleArray) {
                                    Text("ChangeSampleType")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                if changeSampleArray == true {
                                    HStack{
                                        Toggle("92/24\nStd", isOn: $highResStandard)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("92/24\nFaded", isOn: $highResFaded)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("48/16\nFaded", isOn: $cdFadedDithered)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                }
                            }
                            .onChange(of: changeSampleArray) { change in
                                if change == true {
                                    sampleArraySet = false
                                } else if change == false {
                                    sampleArraySet = true
                                }
                            }
                            .onChange(of: highResStandard) { highResValue in
                                sampleArraySet = false
                                if highResValue == true && sampleArraySet == false {
                                    //remove array values
                                    onekHz_samples.removeAll()
                                    //set other toggles to fales
                                    highResFaded = false
                                    cdFadedDithered = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    onekHz_samples.append(contentsOf: highResStdSamples)
                                    print("training_samples: \(onekHz_samples)")
                                }
                                
                            }
                            .onChange(of: highResFaded) { highResFadedValue in
                                sampleArraySet = false
                                if highResFadedValue == true && sampleArraySet == false {
                                    //remove array values
                                    onekHz_samples.removeAll()
                                    //set other toggles to fales
                                    highResStandard = false
                                    cdFadedDithered = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    onekHz_samples.append(contentsOf: highResFadedSamples)
                                    print("training_samples: \(onekHz_samples)")
                                }
                            }
                            .onChange(of: cdFadedDithered) { cdFadedDitheredValue in
                                sampleArraySet = false
                                if cdFadedDitheredValue == true && sampleArraySet == false {
                                    //remove array values
                                    onekHz_samples.removeAll()
                                    //set other toggles to fales
                                    highResStandard = false
                                    highResFaded = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    onekHz_samples.append(contentsOf: cdFadedDitheredSamples)
                                    print("training_samples: \(onekHz_samples)")
                                }
                            }
                        }
                        
                        if bilateral1kHzTestCompleted == false {
                            Text("This is first true test phase. So, make sure you are ready and paying attention to what you hear.")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                            Spacer()
                            Text("Let's proceed with the test.")
                                .foregroundColor(.green)
                                .font(.title)
                                .padding()
                                .padding(.bottom, 20)
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                    continuePastBilateralTest = false
                                    onekHzshowTestCompletionSheet.toggle()
                                    onekHz_CurrentDB = onekHz_StartingDB
                                    onekHz_NewTargetDB = onekHz_CurrentDB
                                    onekHz_testGainDB = onekHz_CurrentDB
                                    onekHz_testGain = powf(10.0, ((onekHz_StartingDB - onekHz_AirPodsProGen2MaxDB)/20))
// Change Add Below
//                                    Task(priority: .userInitiated) {
//                                        onekHz_CurrentDB = onekHz_StartingDB
//                                        onekHz_NewTargetDB = onekHz_CurrentDB
//                                        await dBToGain(onekHz_NewTargetDB: onekHz_StartingDB)   //Sets onekHz_testGain value in FS
//                                    }
// Change Add Above
                                    
                                } label: {
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .background(Color .green)
                                        .foregroundColor(.white)
                                        .cornerRadius(24)
                                }
                                Spacer()
                            }
                        } else if bilateral1kHzTestCompleted == true {
                            Text("Take a moment for a break before exiting to continue with the next test segment")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                            Spacer()
                            Text("Let's proceed with the test.")
                                .foregroundColor(.green)
                                .font(.title)
                                .padding()
                                .padding(.bottom, 20)
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                    continuePastBilateralTest = true
                                    onekHzshowTestCompletionSheet.toggle()
                                } label: {
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .background(Color .green)
                                        .foregroundColor(.white)
                                        .cornerRadius(24)
                                }
                                Spacer()
                            }
                            .navigationDestination(isPresented: $bilateral1kHzTestCompleted) {
                                PostBilateral1kHzTestView(testing: testing, relatedLinkTesting: linkTesting)
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            })
        }
        .onAppear(perform: {
            Task{
                await comparedLastNameCSVReader()
            }
            
            cdFadedDithered = true
            qosBackground = false
            qosDefault = false
            qosUserInteractive = true
            qosUserInitiated = false
            qualityOfService = 3
            
            //append highresstd to array
            onekHz_samples.append(contentsOf: highResStdSamples)
            sampleArraySet = true
            print("training_samples: \(onekHz_samples)")
//            onekHz_testGain = powf(10.0, ((onekHz_StartingDB - onekHz_AirPodsProGen2MaxDB)/20))
        })
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
            onekHz_testGain = powf(10.0, ((onekHz_NewTargetDB - onekHz_AirPodsProGen2MaxDB)/20))
            onekHzlocalHeard = 0
            onekHzlocalReversal = 0
            onekHzTestStarted = true
            if onekHzplayingValue == 1{
                onekHzSetPan()
                
                if qualityOfService == 1 {
                    print("QOS Thread Background")
                    onekHzaudioThreadBackground.async {
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
                } else if qualityOfService == 2 {
                    print("QOS Thread Default")
                    onekHzaudioThreadDefault.async {
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
                } else if qualityOfService == 3 {
                    print("QOS Thread UserInteractive")
                    onekHzaudioThreadUserInteractive.async {
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
                } else if qualityOfService == 4 {
                    print("QOS Thread UserInitiated")
                    onekHzaudioThreadUserInitiated.async {
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
                } else {
                    print("QOS Thread Not Set, Catch Setting of Default")
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
                            await maxOnekHzGainReachedReversal()
                            await onekHzcount()
                            await onekHzlogNotPlaying()   //self.onekHz_playing = -1
                            await onekHzresetPlaying()
                            await onekHzresetHeard()
                            await onekHznonResponseCounting()
                            await onekHzcreateReversalHeardArray()
                            await onekHzcreateReversalGainArrayNonResponse()
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
                        await onekHzreversalsCompleteLogging()
                        await lowestAverageGainLogging()
                        await onekHzconcatenateFinalArrays()
                        //                        await onekHzprintConcatenatedArrays()
                        await onekHzsaveFinalStoredArrays()
                        await onekHzendTestSeries()
                        await onekHznewTestCycle()
                        await onekHzrestartPresentation()
                        await printGainArrays()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                Task {
                    await uploadBilateralTestResults()
                }
            } else {
                print("Fatal Error in uploadValue Change of Logic")
            }
        }
    }
}
 
extension Bilateral1kHzTestContent {
//MARK: - AudioPlayer Methods
    
    func onekHzpauseRestartTestCycle() {
        onekHzlocalMarkNewTestCycle = 0
        onekHzlocalReversalEnd = 0
        onekHz_index = onekHz_index
        onekHz_testGain = onekHz_StartingDB       // Add code to reset starting test gain by linking to table o expected HL
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

//Added
        onekHz_averageGainDB = Float()
        onekHz_testGainDB = onekHz_StartingDB
//        Task(priority: .userInitiated) {
//            onekHz_CurrentDB = onekHz_StartingDB
//            onekHz_NewTargetDB = onekHz_StartingDB
//            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)
//        }

        
//Added Above
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
//              onekHztestPlayer.setVolume(onekHz_testGain, fadeDuration: 0)      // Set Gain for Playback
              onekHztestPlayer.setVolume(onekHz_testGain, fadeDuration: 0)      // Set Gain for Playback
              onekHztestPlayer.pan = onekHz_pan
              onekHztestPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func onekHzstop() {
      do{
          let onekHzurlSample = Bundle.main.path(forResource: onekHzactiveFrequency, ofType: ".wav")
          guard let onekHzurlSample = onekHzurlSample else { return print(onekHzSampleErrors.onekHznotFound) }
          onekHztestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: onekHzurlSample))
          guard let onekHztestPlayer = onekHztestPlayer else { return }
          onekHztestPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    func playTesting() async {
        do{
            let onekHzurlSample = Bundle.main.path(forResource: onekHzactiveFrequency, ofType: ".wav")
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
            onekHz_indexForTest.append(onekHz_index)
        }
        DispatchQueue.global(qos: .default).async {
            onekHz_testTestGain.append(onekHz_testGain)
            onekHz_testTestGainDB.append(onekHz_testGainDB)
        }
        DispatchQueue.global(qos: .background).async {
            onekHz_frequency.append(onekHzactiveFrequency)
            onekHz_testPan.append(onekHz_pan)
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
    
    func maxOnekHzGainReachedReversal() async {
        if onekHz_testGain >= 0.995 && onekHzfirstHeardIsTrue == false && onekHzsecondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            onekHz_testTestGain.removeLast(1)
            //responseHeardArray
            onekHzfirstHeardResponseIndex = onekHzlocalTestCount
            onekHzfirstHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            onekHz_testTestGain.append(1.0)
            // Local Response Tracking
            onekHz_heardArray.append(1)
            self.onekHzidxHA = onekHz_heardArray.count
            self.onekHzlocalStartingNonHeardArraySet = true
            await onekHzresetNonResponseCount()

        } else if onekHz_testGain >= 0.995 && onekHzfirstHeardIsTrue == true && onekHzsecondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            onekHz_testTestGain.removeLast(1)
            //responseHeardArray
            onekHzsecondHeardResponseIndex = onekHzlocalTestCount
            onekHzsecondHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            onekHz_testTestGain.append(1.0)
            // Local Response Tracking
            onekHz_heardArray.append(1)
            self.onekHzidxHA = onekHz_heardArray.count
            self.onekHzlocalStartingNonHeardArraySet = true
            await onekHzresetNonResponseCount()
            
        }
    }
    
    func onekHzheardArrayNormalize() async {
        if onekHz_testGain < 0.995 {
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
        } else {
            print("!!!Critical Max Gain Reached, logging 1.0 for no response to sound")
        }
    }
      
// MARK: -Logging Methods
    func onekHzcount() async {
        onekHzidxTestCountUpdated = onekHz_testCount.count + 1
        onekHz_testCount.append(onekHzidxTestCountUpdated)
    }
}


extension Bilateral1kHzTestContent {
//MARK: - 1kHz Reversal Extension
    enum onekHzLastErrors: Error {
        case onekHzlastError
        case onekHzlastUnexpected(code: Int)
    }
    
    
    
    

    
    
    func dBNewTargetDB() async {
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHz_StepSizeDB
    }
    
    func dBToGain(onekHz_NewTargetDB: Float) async {
        onekHz_testGain = powf(10.0, ((onekHz_NewTargetDB - onekHz_AirPodsProGen2MaxDB)/20))
        onekHz_testGainDB = onekHz_NewTargetDB
    }
    
    
    
    
    

    
    func onekHzcreateReversalHeardArray() async {
        onekHz_reversalHeard.append(onekHz_heardArray[onekHzidxHA-1])
        self.onekHzidxReversalHeardCount = onekHz_reversalHeard.count
    }
    
    func onekHzcreateReversalGainArray() async {
        onekHz_reversalGain.append(onekHz_testGain)
        onekHz_reversalGainDB.append(onekHz_testGainDB)
    }
    
    func onekHzcreateReversalGainArrayNonResponse() async {
        if onekHz_testGain < 0.995 {
            onekHz_reversalGain.append(onekHz_testGain)
            onekHz_reversalGainDB.append(onekHz_testGainDB)
        } else if onekHz_testGain >= 0.995 {
            onekHz_reversalGain.append(1.0)
            onekHz_reversalGainDB.append(200.0)
        }
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
    
    
    
//    func onekHzreversalOfOne() async {
//        let onekHzrO1Direction = 0.01 * onekHz_reversalDirection
//        let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
//        if onekHzr01NewGain > 0.00001 && onekHzr01NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr01NewGain * 100000) / 100000
//        } else if onekHzr01NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr01NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfOne Logic")
//        }
//    }
//
//    func onekHzreversalOfTwo() async {
//        let onekHzrO2Direction = 0.02 * onekHz_reversalDirection
//        let onekHzr02NewGain = onekHz_testGain + onekHzrO2Direction
//        if onekHzr02NewGain > 0.00001 && onekHzr02NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr02NewGain * 100000) / 100000
//        } else if onekHzr02NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr02NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfTwo Logic")
//        }
//    }
//
//    func onekHzreversalOfThree() async {
//        let onekHzrO3Direction = 0.03 * onekHz_reversalDirection
//        let onekHzr03NewGain = onekHz_testGain + onekHzrO3Direction
//        if onekHzr03NewGain > 0.00001 && onekHzr03NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr03NewGain * 100000) / 100000
//        } else if onekHzr03NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr03NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfThree Logic")
//        }
//    }
//
//    func onekHzreversalOfFour() async {
//        let onekHzrO4Direction = 0.04 * onekHz_reversalDirection
//        let onekHzr04NewGain = onekHz_testGain + onekHzrO4Direction
//        if onekHzr04NewGain > 0.00001 && onekHzr04NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr04NewGain * 100000) / 100000
//        } else if onekHzr04NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr04NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfFour Logic")
//        }
//    }
//
//    func onekHzreversalOfFive() async {
//        let onekHzrO5Direction = 0.05 * onekHz_reversalDirection
//        let onekHzr05NewGain = onekHz_testGain + onekHzrO5Direction
//        if onekHzr05NewGain > 0.00001 && onekHzr05NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr05NewGain * 100000) / 100000
//        } else if onekHzr05NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr05NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfFive Logic")
//        }
//    }
//
//    func onekHzreversalOfTen() async {
//        let onekHzr10Direction = 0.10 * onekHz_reversalDirection
//        let onekHzr10NewGain = onekHz_testGain + onekHzr10Direction
//        if onekHzr10NewGain > 0.00001 && onekHzr10NewGain < 1.0 {
//            onekHz_testGain = roundf(onekHzr10NewGain * 100000) / 100000
//        } else if onekHzr10NewGain <= 0.0 {
//            onekHz_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if onekHzr10NewGain >= 1.0 {
//            onekHz_testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfTen Logic")
//        }
//    }
    
    
    // func dBNewTargetDB() async {
      //   onekHz_NewTargetDB = onekHz_CurrentDB + onekHz_StepSizeDB
    // }
     
//    func dBToGain(onekHz_NewTargetDB: Float) async {
//        onekHz_testGain = Float(10^(Int((onekHz_NewTargetDB-onekHz_AirPodsProGen2MaxDB))/20))
//    }
    
    func onekHzreversalOfOne() async {
        onekHz_StepSizeDB = 1.0
//        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzrO1Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzrO1Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }

    
    func onekHzreversalOfTwo() async {
        onekHz_StepSizeDB = 2.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzrO2Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzrO2Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    
    func onekHzreversalOfThree() async {
        onekHz_StepSizeDB = 3.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzrO3Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzrO3Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    

    
    func onekHzreversalOfFour() async {
        onekHz_StepSizeDB = 4.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzrO4Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzrO4Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }

    
    
    func onekHzreversalOfFive() async {
        onekHz_StepSizeDB = 5.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzrO5Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzrO5Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }

    
    func onekHzreversalOfEight() async {
        onekHz_StepSizeDB = 8.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzr10Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzr10Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //} 0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func onekHzreversalOfTen() async {
        onekHz_StepSizeDB = 10.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzr10Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzr10Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func onekHzreversalOfTwelve() async {
        onekHz_StepSizeDB = 12.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzr10Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzr10Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //} 0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }

    
    func onekHzreversalOfFifteen() async {
        onekHz_StepSizeDB = 15.0
        onekHz_PriorDB = onekHz_CurrentDB
        let onekHzr10Direction = onekHz_StepSizeDB * onekHz_reversalDirection
        onekHz_NewTargetDB = onekHz_CurrentDB + onekHzr10Direction
        //  let onekHzr01NewGain = onekHz_testGain + onekHzrO1Direction
        if onekHz_NewTargetDB > 0.00001 && onekHz_NewTargetDB < onekHz_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)  //This sets onekHz_testGain
            onekHz_testGainDB = onekHz_NewTargetDB
            onekHz_CurrentDB = onekHz_NewTargetDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
        } else if onekHz_NewTargetDB <= 3.0 {   //0.0 {
            await dBToGain(onekHz_NewTargetDB: 3.0)  //This sets onekHz_testGain
            onekHz_testGainDB = 3.0
            onekHz_CurrentDB = 3.0
            onekHz_NewTargetDB = 3.0
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if onekHz_NewTargetDB >= onekHz_AirPodsProGen2MaxDB {
            onekHz_testGain = 1.0
            onekHz_testGainDB = onekHz_AirPodsProGen2MaxDB
            onekHz_CurrentDB = onekHz_AirPodsProGen2MaxDB
            onekHz_NewTargetDB = onekHz_AirPodsProGen2MaxDB
            print("onekHz_testGainDB \(onekHz_testGainDB)")
            print("testGain: \(onekHz_testGain)")
            print("onekHz_NewTargetDB \(onekHz_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
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
        if onekHzidxReversalHeardCount <= 1 && onekHzidxHA <= 1 {
            await onekHzreversalAction()
        }  else if onekHzidxReversalHeardCount == 2 {
            if onekHzidxReversalHeardCount == 2 && onekHzsecondHeardIsTrue == true {
                await onekHzstartTooHighCheck()
                //            } else if onekHzidxReversalHeardCount == 2  && onekHzsecondHeardIsTrue == false {
                //                await onekHzreversalAction()
                
                //!!! Changes Below From Original Test Models
            } else if onekHzidxReversalHeardCount == 2  && onekHzsecondHeardIsTrue == false && onekHzlocalSeriesNoResponses < 2 {
                await onekHzreversalAction()
            } else if onekHzidxReversalHeardCount == 2  && onekHzsecondHeardIsTrue == false && onekHzlocalSeriesNoResponses == 2 {
                await onekHzreversalOfFour()
                //!!! Changes Above From Original Test Models
                
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
//            } else if onekHzlocalSeriesNoResponses == 3 {
            } else if onekHzlocalSeriesNoResponses >= 3 {
//                await onekHzreversalOfTen()
                await onekHzreversalOfEight()
            } else if onekHzlocalSeriesNoResponses == 2 {
                await onekHzreversalOfFour()
            } else {
                await onekHzreversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    
    func onekHzreversalHeardCount1() async {
        //        print("Start onekHzreversalHeardCount1()")
        await onekHzreversalAction()
    }
    
    func onekHzcheck2PositiveSeriesReversals() async {
        //        print("Start onekHzcheck2PositiveSeriesReversals()")
        if onekHz_reversalHeard[onekHzidxHA-2] == 1 && onekHz_reversalHeard[onekHzidxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }
    
    func onekHzcheckTwoNegativeSeriesReversals() async {
        //        print("start onekHzcheckTwoNegativeSeriesReversals()")
        if onekHz_reversalHeard.count >= 3 && onekHz_reversalHeard[onekHzidxHA-2] == 0 && onekHz_reversalHeard[onekHzidxHA-1] == 0 {
            await onekHzreversalOfFour()
        } else {
            await onekHzreversalAction()
        }
    }
    
    func onekHzstartTooHighCheck() async {
        //        print(" Start onekHzstartTooHighCheck()")
        if onekHzstartTooHigh == 0 && onekHzfirstHeardIsTrue == true && onekHzsecondHeardIsTrue == true {
            onekHzstartTooHigh = 1
            await onekHzreversalOfFifteen()
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
        needToRepeatTesting = true
    }
    
    func onekHzreversalsCompleteLogging() async {
        //        print("loggingRight1 start")
        if onekHzsecondHeardIsTrue == true && onekHz_pan == 1.0 {
            print("in logging right 1 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
            onekHzfirstGain = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
            onekHzsecondGain = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
            
// Added Below
            onekHzfirstGainDB = onekHz_reversalGainDB[onekHzfirstHeardResponseIndex-1]
            onekHzsecondGainDB = onekHz_reversalGainDB[onekHzsecondHeardResponseIndex-1]
//
            
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
            
//            let onekHzdeltaRight = onekHzfirstGain - onekHzsecondGain
            let onekHzavgRight = (onekHzfirstGain + onekHzsecondGain)/2
            
// Added Below
            let onekHzdeltaRightDB = onekHzfirstGainDB - onekHzsecondGainDB
            let onekHzMagFirst20Right = onekHzfirstGainDB/20.0
            let onekHzMagFirstRight = powf(10.0, onekHzMagFirst20Right)
            let onekHzMagSecond20Right = onekHzsecondGainDB/20.0
            let onekHzMagSecondRight = powf(10.0,onekHzMagSecond20Right)
            let onekHzMagAvgRight = (onekHzMagFirstRight + onekHzMagSecondRight)/2.0
            let onekHzavgRightDB = 20.0 * log10f(onekHzMagAvgRight)
            print("eHAP1firstGainDB: \(onekHzfirstGainDB)")
            print("eHAP1secondGainDB: \(onekHzsecondGainDB)")
            print("eHAP1MagAvg: \(onekHzMagAvgRight)")
            print("eHAP1AvgDB: \(onekHzavgRightDB)")
            
//            let onekHzavgRightDB = (onekHzfirstGainDB + onekHzsecondGainDB)/2
// Added Above
            
//            if onekHzdeltaRight == 0 {
            if onekHzdeltaRightDB == 0 {
                onekHz_averageGain = onekHzsecondGain
                onekHz_averageGainRightArray.append(onekHzsecondGain)
                
// Added Below
                onekHz_averageGainDB = onekHzsecondGainDB
                onekHz_averageGainDBRightArray.append(onekHzsecondGainDB)
// Added Above
                
//            } else if onekHzdeltaRight >= 0.04 {
            } else if onekHzdeltaRightDB >= 4 {
                onekHz_averageGain = onekHzsecondGain
                onekHz_averageGainRightArray.append(onekHzsecondGain)
                
// Added Below
                onekHz_averageGainDB = onekHzsecondGainDB
                onekHz_averageGainDBRightArray.append(onekHzsecondGainDB)
// Added Above
                
//            } else if onekHzdeltaRight <= -0.04 {
            } else if onekHzdeltaRightDB <= -4 {
                onekHz_averageGain = onekHzfirstGain
                onekHz_averageGainRightArray.append(onekHzfirstGain)
                
// Added Below
                onekHz_averageGainDB = onekHzfirstGainDB
                onekHz_averageGainDBRightArray.append(onekHzfirstGainDB)
// Added Above
                
//            } else if onekHzdeltaRight < 0.04 && onekHzdeltaRight > -0.04 {
            } else if onekHzdeltaRightDB < 4 && onekHzdeltaRightDB > -4 {
                onekHz_averageGain = onekHzavgRight
                onekHz_averageGainRightArray.append(onekHzavgRight)
                
// Added Below
                onekHz_averageGainDB = onekHzavgRightDB
                onekHz_averageGainDBRightArray.append(onekHzavgRightDB)
// Added Above
                
            } else {
                onekHz_averageGain = onekHzavgRight
                onekHz_averageGainRightArray.append(onekHzavgRight)
                
// Added Below
                onekHz_averageGainDB = onekHzavgRightDB
                onekHz_averageGainDBRightArray.append(onekHzavgRightDB)
// Added Above
                
            }
        } else if onekHzsecondHeardIsTrue == true && onekHz_pan == -1.0 {
            print("in logging right 1 if")
            onekHzlocalReversalEnd = 1
            onekHzlocalMarkNewTestCycle = 1
            onekHzfirstGain = onekHz_reversalGain[onekHzfirstHeardResponseIndex-1]
            onekHzsecondGain = onekHz_reversalGain[onekHzsecondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
            
// Added Below
            onekHzfirstGainDB = onekHz_reversalGainDB[onekHzfirstHeardResponseIndex-1]
            onekHzsecondGainDB = onekHz_reversalGainDB[onekHzsecondHeardResponseIndex-1]
// Added Above
            
//            let onekHzdeltaLeft = onekHzfirstGain - onekHzsecondGain
            let onekHzavgLeft = (onekHzfirstGain + onekHzsecondGain)/2
            
// Added Below
            let onekHzdeltaLeftDB = onekHzfirstGainDB - onekHzsecondGainDB
            let onekHzMagFirst20Left = onekHzfirstGainDB/20.0
            let onekHzMagFirstLeft = powf(10.0, onekHzMagFirst20Left)
            let onekHzMagSecond20Left = onekHzsecondGainDB/20.0
            let onekHzMagSecondLeft = powf(10.0,onekHzMagSecond20Left)
            let onekHzMagAvgLeft = (onekHzMagFirstLeft + onekHzMagSecondLeft)/2.0
            let onekHzavgLeftDB = 20.0 * log10f(onekHzMagAvgLeft)
            print("eHAP1firstGainDB: \(onekHzfirstGainDB)")
            print("eHAP1secondGainDB: \(onekHzsecondGainDB)")
            print("eHAP1MagAvg: \(onekHzMagAvgLeft)")
            print("eHAP1AvgDB: \(onekHzavgLeftDB)")
            
//            let onekHzavgLeftDB = (onekHzfirstGainDB + onekHzsecondGainDB)/2
// Added Above
            
//            if onekHzdeltaLeft == 0 {
            if onekHzdeltaLeftDB == 0 {
                onekHz_averageGain = onekHzsecondGain
                onekHz_averageGainLeftArray.append(onekHzsecondGain)
                
// Added Below
                onekHz_averageGainDB = onekHzsecondGainDB
                onekHz_averageGainDBLeftArray.append(onekHzsecondGainDB)
// Added Above
                
//            } else if onekHzdeltaLeft >= 0.04 {
            } else if onekHzdeltaLeftDB >= 4 {
                onekHz_averageGain = onekHzsecondGain
                onekHz_averageGainLeftArray.append(onekHzsecondGain)

// Added Below
                onekHz_averageGainDB = onekHzsecondGainDB
                onekHz_averageGainDBLeftArray.append(onekHzsecondGainDB)
// Added Above
                
//            } else if onekHzdeltaLeft <= -0.04 {
            } else if onekHzdeltaLeftDB <= -4 {
                onekHz_averageGain = onekHzfirstGain
                onekHz_averageGainLeftArray.append(onekHzfirstGain)

// Added Below
                onekHz_averageGainDB = onekHzfirstGainDB
                onekHz_averageGainDBLeftArray.append(onekHzfirstGainDB)
// Added Above
                
//            } else if onekHzdeltaLeft < 0.04 && onekHzdeltaLeft > -0.04 {
            } else if onekHzdeltaLeftDB < 4 && onekHzdeltaLeftDB > -4 {
                onekHz_averageGain = onekHzavgLeft
                onekHz_averageGainLeftArray.append(onekHzavgLeft)
                
// Added Below
                onekHz_averageGainDB = onekHzavgLeftDB
                onekHz_averageGainDBLeftArray.append(onekHzavgLeftDB)
// Added Above

            } else {
                onekHz_averageGain = onekHzavgLeft
                onekHz_averageGainLeftArray.append(onekHzavgLeft)
                
// Added Below
                onekHz_averageGainDB = onekHzavgLeftDB
                onekHz_averageGainDBLeftArray.append(onekHzavgLeftDB)
// Added Above

            }
        } else {
            print("onekHzreversalsCompleteLoggingRight1() if not met")
        }
    }
    
    func lowestAverageGainLogging() async {
        print("====LowestAverageRightGain Start======")
        let idxR = onekHz_averageGainRightArray.count
        let idxL = onekHz_averageGainLeftArray.count
        print("idxR: \(idxR)")
        print("ixdL: \(idxL)")
        if idxR == 4 && idxL == 4 {
            let avgRightSorted = onekHz_averageGainRightArray.sorted()
            let avgLeftSorted = onekHz_averageGainLeftArray.sorted()
            needToRepeatTesting = true
            onekHz_averageLowestGainRightArray.append(avgRightSorted[0])
            onekHz_HoldingLowestRightGainArray.append(avgRightSorted[0])
            onekHz_averageLowestGainLeftArray.append(avgLeftSorted[0])
            onekHz_HoldingLowestLeftGainArray.append(avgLeftSorted[0])
            
// Added Below
            let avgRightSortedDB = onekHz_averageGainDBRightArray.sorted()
            let avgLeftSortedDB = onekHz_averageGainDBLeftArray.sorted()
//            needToRepeatTesting = true
            onekHz_averageLowestGainDBRightArray.append(avgRightSortedDB[0])
            onekHz_HoldingLowestRightGainDBArray.append(avgRightSortedDB[0])
            onekHz_averageLowestGainDBLeftArray.append(avgLeftSortedDB[0])
            onekHz_HoldingLowestLeftGainDBArray.append(avgLeftSortedDB[0])
// Added Above
            
        } else if idxR < 4 || idxL < 4 {
            print("idxRight != 7 \(idxR)")
            print("idxLeft != 7 \(idxL)")
        } else {
            print("!!!Critical error in lowestAverageRightRain Assign Gain Logic")
        }
    }
    
    
    func printGainArrays() async {
        print("onekHz_averageGainRightArray: \(onekHz_averageGainRightArray)")
        print("onekHz_averageGainLeftArray: \(onekHz_averageGainLeftArray)")
        print("onekHz_averageLowestGainRightArray: \(onekHz_averageLowestGainRightArray)")
        print("onekHz_HoldingLowestRightGainArray: \(onekHz_HoldingLowestRightGainArray)")
        print("onekHz_averageLowestGainLeftArray: \(onekHz_averageLowestGainLeftArray)")
        print("onekHz_HoldingLowestLeftGainArray: \(onekHz_HoldingLowestLeftGainArray)")
        
//Added Below
        print("onekHz_averageGainDBRightArray: \(onekHz_averageGainDBRightArray)")
        print("onekHz_averageGainDBLeftArray: \(onekHz_averageGainDBLeftArray)")
        print("onekHz_averageLowestGainDBRightArray: \(onekHz_averageLowestGainDBRightArray)")
        print("onekHz_HoldingLowestRightGainDBArray: \(onekHz_HoldingLowestRightGainDBArray)")
        print("onekHz_averageLowestGainDBLeftArray: \(onekHz_averageLowestGainDBLeftArray)")
        print("onekHz_HoldingLowestLeftGainDBArray: \(onekHz_HoldingLowestLeftGainDBArray)")
// Added Above
        
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
            onekHz_reversalGain.removeAll()
            onekHz_averageGain = Float()
            
            onekHzfirstGain = Float()    //Added these in, difference from EHAP1
            onekHzsecondGain = Float()   //Added these in, difference from EHAP1
            
            onekHz_reversalDirection = Float()
            onekHzlocalStartingNonHeardArraySet = false
            onekHzfirstHeardResponseIndex = Int()
            onekHzfirstHeardIsTrue = false
            onekHzsecondHeardResponseIndex = Int()
            onekHzsecondHeardIsTrue = false
            onekHzlocalTestCount = 0
            onekHzlocalReversalHeardLast = Int()
            onekHzstartTooHigh = 0
            onekHzlocalSeriesNoResponses = Int()
            print("onekHz_reversalGain: \(onekHz_reversalGain)")
            
// Added Below
            onekHz_reversalGainDB.removeAll()
            onekHz_averageGainDB = Float()
            
            onekHzfirstGainDB = Float()    //Added these in, difference from EHAP1
            onekHzsecondGainDB = Float()   //Added these in, difference from EHAP1
            
            print("onekHz_reversalGainDB: \(onekHz_reversalGainDB)")
// Added Above
            
        })
    }
    
    
    func onekHznewTestCycle() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 && onekHz_index < onekHz_eptaSamplesCount && onekHzendTestSeries == false {
            await onekHzwipeArrays()
            onekHzstartTooHigh = 0
            onekHzlocalMarkNewTestCycle = 0
            onekHzlocalReversalEnd = 0
            onekHz_index = onekHz_index + 1

// Changed Below
            onekHz_StepSizeDB = 0.0
            onekHz_CurrentDB = onekHz_StartingDB
            onekHz_NewTargetDB = onekHz_StartingDB
//            onekHz_testGainDB = onekHz_StartingDB
//            onekHz_testGain = 0.025
            await dBToGain(onekHz_NewTargetDB: onekHz_NewTargetDB)
// Changed Above
            
            onekHzendTestSeries = false

            
        } else if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 && onekHz_index == onekHz_eptaSamplesCount && onekHzendTestSeries == false {
            onekHzendTestSeries = true
            onekHzlocalPlaying = -1
            bilateral1kHzTestCompleted = true
            print("=============================")
            print("!!!!! End of Test Series!!!!!!")
            print("=============================")
        } else {
                            print("Reversal Limit Not Hit")
        }
    }
    
    func onekHzendTestSeries() async {
        if onekHzendTestSeries == false {
            //Do Nothing and continue
            print("end Test Series = \(onekHzendTestSeries)")
        } else if onekHzendTestSeries == true {
            onekHzshowTestCompletionSheet = true
            bilateral1kHzTestCompleted = true
            await onekHzendTestSeriesStop()
        }
    }
    
    func onekHzendTestSeriesStop() async {
        onekHzlocalPlaying = -1
        onekHzstop()
        onekHzuserPausedTest = true
        onekHzplayingStringColorIndex = 2
        //        onekHzaudioThread.async {
        //            onekHzlocalPlaying = 0
        //            onekHzstop()
        //            onekHzuserPausedTest = true
        //            onekHzplayingStringColorIndex = 2
        //        }
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
    
    func onekHzconcatenateFinalArrays() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 {
            final_onekHz_onekHzactiveFrequency.append(contentsOf: ["100000000"] + [String(onekHzactiveFrequency)])
            final_onekHz_onekHzfirstGain.append(contentsOf: [1000000.0] + [onekHzfirstGain])
            final_onekHz_onekHzsecondGain.append(contentsOf: [1000000.0] + [onekHzsecondGain])
            final_onekHz_heardArray.append(contentsOf: [10000000] + onekHz_heardArray)
            final_onekHz_reversalHeard.append(contentsOf: [10000000] + onekHz_reversalHeard)
            final_onekHz_reversalGain.append(contentsOf: [1000000.0] + onekHz_reversalGain)
            final_onekHz_testTestGain.append(contentsOf: [1000000.0] + onekHz_testTestGain)
            final_onekHz_averageGain.append(contentsOf: [1000000.0] + [onekHz_averageGain])
            
            final_onekHz_averageGainRightArray.append(contentsOf: [1000000.0] + onekHz_averageGainRightArray)
            final_onekHz_averageGainLeftArray.append(contentsOf: [1000000.0] + onekHz_averageGainLeftArray)
            final_onekHz_averageLowestGainRightArray.append(contentsOf: [1000000.0] + onekHz_averageLowestGainRightArray)
            final_onekHz_HoldingLowestRightGainArray.append(contentsOf: [1000000.0] + onekHz_HoldingLowestRightGainArray)
            final_onekHz_averageLowestGainLeftArray.append(contentsOf: [1000000.0] + onekHz_averageLowestGainLeftArray)
            final_onekHz_HoldingLowestLeftGainArray.append(contentsOf: [10000000] + onekHz_HoldingLowestLeftGainArray)
            
// Added Below
            final_onekHz_onekHzfirstGainDB.append(contentsOf: [1000000.0] + [onekHzfirstGainDB])
            final_onekHz_onekHzsecondGainDB.append(contentsOf: [1000000.0] + [onekHzsecondGainDB])
            final_onekHz_reversalGainDB.append(contentsOf: [1000000.0] + onekHz_reversalGainDB)
            final_onekHz_testTestGainDB.append(contentsOf: [1000000.0] + onekHz_testTestGainDB)
            final_onekHz_averageGainDB.append(contentsOf: [1000000.0] + [onekHz_averageGainDB])
            
            final_onekHz_averageGainDBRightArray.append(contentsOf: [1000000.0] + onekHz_averageGainDBRightArray)
            final_onekHz_averageGainDBLeftArray.append(contentsOf: [1000000.0] + onekHz_averageGainDBLeftArray)
            final_onekHz_averageLowestGainDBRightArray.append(contentsOf: [1000000.0] + onekHz_averageLowestGainDBRightArray)
            final_onekHz_HoldingLowestRightGainDBArray.append(contentsOf: [1000000.0] + onekHz_HoldingLowestRightGainDBArray)
            final_onekHz_averageLowestGainDBLeftArray.append(contentsOf: [1000000.0] + onekHz_averageLowestGainDBLeftArray)
            final_onekHz_HoldingLowestLeftGainDBArray.append(contentsOf: [10000000] + onekHz_HoldingLowestLeftGainDBArray)
// Added Above
            
        }
    }
    
    
    func onekHzsaveFinalStoredArrays() async {
        if onekHzlocalMarkNewTestCycle == 1 && onekHzlocalReversalEnd == 1 {
            //        if onekHzFinalComboLRGains.count >= 2 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
                    await onekHzWriteDetailedResultsToCSV()
                    await onekHzwriteSummarydResultsToCSV()
                    await onekHzWriteInputDetailedResultsToCSV()
                    await onekHzwriteInputSummarydResultsToCSV()
                    await onekHzGetData()
                    await onekHzSaveToJSON()
                    //                await onekHz_uploadSummaryResultsTest()
                    DispatchQueue.main.async(group: .none, qos: .userInteractive) {
                        isOkayToUpload = true
                    }
                }
            }
        }
    }
    
    
    func uploadBilateralTestResults() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: fileOnekHzName)
            uploadFile(fileName: summaryOnekHzCSVName)
            uploadFile(fileName: detailedOnekHzCSVName)
            uploadFile(fileName: inputOnekHzSummaryCSVName)
            uploadFile(fileName: inputOnekHzDetailedCSVName)
        }
    }
}
 
extension Bilateral1kHzTestContent {
//MARK: -CSV/JSON Extension
    
    func onekHzGetData() async {
        guard let onekHzdata = await onekHzGetJSONData() else { return }
        //        print("onekHz Json Data:")
        //        print(onekHzdata)
        let onekHzjsonString = String(data: onekHzdata, encoding: .utf8)
        onekHzjsonHoldingString = [onekHzjsonString!]
        //        print(onekHzjsonString!)
        do {
            self.onekHzsaveFinalResults = try JSONDecoder().decode(onekHzSaveFinalResults.self, from: onekHzdata)
            //            print("JSON GetData Run")
            //            print("data: \(onekHzdata)")
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func onekHzGetJSONData() async -> Data? {
        let onekHzsaveFinalResults = onekHzSaveFinalResults(
            json_onekHz_onekHzactiveFrequency: onekHzactiveFrequency,
            json_onekHz_onekHzfirstGain: onekHzfirstGain,
            json_onekHz_onekHzsecondGain: onekHzsecondGain,
            json_onekHz_heardArray: onekHz_heardArray,
            json_onekHz_reversalHeard: onekHz_reversalHeard,
            json_onekHz_reversalGain: onekHz_reversalGain,
            json_onekHz_testTestGain: onekHz_testTestGain,
            json_onekHz_averageGain: onekHz_averageGain,
            json_onekHz_averageGainRightArray: onekHz_averageGainRightArray,
            json_onekHz_averageGainLeftArray: onekHz_averageGainLeftArray,
            json_onekHz_averageLowestGainRightArray: onekHz_averageLowestGainRightArray,
            json_onekHz_HoldingLowestRightGainArray: onekHz_HoldingLowestRightGainArray,
            json_onekHz_averageLowestGainLeftArray: onekHz_averageLowestGainLeftArray,
            json_onekHz_HoldingLowestLeftGainArray: onekHz_HoldingLowestLeftGainArray)
        let onekHzjsonData = try? JSONEncoder().encode(onekHzsaveFinalResults)
        //        print("saveFinalResults: \(onekHzsaveFinalResults)")
        //        print("Json Encoded \(onekHzjsonData!)")
        return onekHzjsonData
    }
    
    func onekHzSaveToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let onekHzpaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let onekHzDocumentsDirectory = onekHzpaths[0]
        //        print("onekHzDocumentsDirectory: \(onekHzDocumentsDirectory)")
        let onekHzFilePaths = onekHzDocumentsDirectory.appendingPathComponent(fileOnekHzName)
        //        print(onekHzFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let onekHzjsonData = try encoder.encode(onekHzsaveFinalResults)
            print(onekHzjsonData)
            
            try onekHzjsonData.write(to: onekHzFilePaths)
        } catch {
            print("Error writing 1kHZ to JSON file: \(error)")
        }
    }
    
    func onekHzWriteDetailedResultsToCSV() async {
        let onekHzstringFinalOnekHzactiveFrequency = "finalStoredFrequency," + [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzfirstGain = "firstGain," + [onekHzfirstGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzsecondGain = "secondGain," + [onekHzsecondGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHeardArray = "heardArray," + onekHz_heardArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalHeard = "reversalHeard," + onekHz_reversalHeard.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalGain = "reversalGain," + onekHz_reversalGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGain = "testTestGain," + onekHz_testTestGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGain = "averageGain," + [onekHz_averageGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainRightArray = "averageGainRightArray," + onekHz_averageGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainLeftArray = "averageGainLeftArray," + onekHz_averageGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainRightArray = "averageLowestGainRightArray," + onekHz_averageLowestGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainArray = "HoldingLowestRightGainArray," + onekHz_HoldingLowestRightGainArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftArray = "averageLowestGainLeftArray," + onekHz_averageLowestGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainArray = "HoldingLowestLeftGainArray," + onekHz_HoldingLowestLeftGainArray.map { String($0) }.joined(separator: ",")
        
// ADDED Below
        let onekHzstringFinalOnekHzfirstGainDB = "firstGainDB," + [onekHzfirstGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzsecondGainDB = "secondGainDB," + [onekHzsecondGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalGainDB = "reversalGainDB," + onekHz_reversalGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGainDB = "testTestGainDB," + onekHz_testTestGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDB = "averageGainDB," + [onekHz_averageGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainRightArrayDB = "averageGainRightArrayDB," + onekHz_averageGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainLeftArrayDB = "averageGainLeftArrayDB," + onekHz_averageGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainRightArrayDB = "averageLowestGainDBRightArray," + onekHz_averageLowestGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainArrayDB = "HoldingLowestRightGainDBArray," + onekHz_HoldingLowestRightGainDBArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftArrayDB = "averageLowestGainDBLeftArray," + onekHz_averageLowestGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainArrayDB = "HoldingLowestLeftGainDBArray," + onekHz_HoldingLowestLeftGainDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        do {
            let csvonekHzDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvonekHzDetailDocumentsDirectory = csvonekHzDetailPath
            //            print("CSV DocumentsDirectory: \(csvonekHzDetailDocumentsDirectory)")
            let csvonekHzDetailFilePath = csvonekHzDetailDocumentsDirectory.appendingPathComponent(detailedOnekHzCSVName)
            //            print(csvonekHzDetailFilePath)
            let writer = try CSVWriter(fileURL: csvonekHzDetailFilePath, append: false)
            try writer.write(row: [onekHzstringFinalOnekHzactiveFrequency])
            try writer.write(row: [onekHzstringFinalOnekHzfirstGain])
            try writer.write(row: [onekHzstringFinalOnekHzsecondGain])
            try writer.write(row: [onekHzstringFinalHeardArray])
            try writer.write(row: [onekHzstringFinalReversalHeard])
            try writer.write(row: [onekHzstringFinalReversalGain])
            try writer.write(row: [onekHzstringFinalTestTestGain])
            try writer.write(row: [onekHzstringFinalAverageGain])
            try writer.write(row: [onekHzstringFinalAverageGainRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainArray])
            //            print("CVS EHAP1 Detailed Writer Success")
            
// Added Below
            try writer.write(row: [onekHzstringFinalOnekHzfirstGainDB])
            try writer.write(row: [onekHzstringFinalOnekHzsecondGainDB])
            try writer.write(row: [onekHzstringFinalReversalGainDB])
            try writer.write(row: [onekHzstringFinalTestTestGainDB])
            try writer.write(row: [onekHzstringFinalAverageGainDB])
            try writer.write(row: [onekHzstringFinalAverageGainRightArrayDB])
            try writer.write(row: [onekHzstringFinalAverageGainLeftArrayDB])
            try writer.write(row: [onekHzstringFinalAverageLowestGainRightArrayDB])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainArrayDB])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftArrayDB])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainArrayDB])
// Added Above
            
            
        } catch {
            print("CVSWriter 1kHZ Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }
    
    func onekHzwriteSummarydResultsToCSV() async {
        let onekHzstringFinalOnekHzactiveFrequency = "finalStoredFrequency," + [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalGain = "reversalGain," + onekHz_reversalGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGain = "testTestGain," + onekHz_testTestGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainRightArray = "averageGainRightArray," + onekHz_averageGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainLeftArray = "averageGainLeftArray," + onekHz_averageGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainRightArray = "averageLowestGainRightArray," + onekHz_averageLowestGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainArray = "HoldingLowestRightGainArray," + onekHz_HoldingLowestRightGainArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftArray = "averageLowestGainLeftArray," + onekHz_averageLowestGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainArray = "HoldingLowestLeftGainArray," + onekHz_HoldingLowestLeftGainArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let onekHzstringFinalReversalGainDB = "reversalGainDB," + onekHz_reversalGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGainDB = "testTestGainDB," + onekHz_testTestGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDBRightArray = "averageGainDBRightArray," + onekHz_averageGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDBLeftArray = "averageGainDBLeftArray," + onekHz_averageGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainDBRightArray = "averageLowestGainDBRightArray," + onekHz_averageLowestGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainDBArray = "HoldingLowestRightGainDBArray," + onekHz_HoldingLowestRightGainDBArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftDBArray = "averageLowestGainDBLeftArray," + onekHz_averageLowestGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainDBArray = "HoldingLowestLeftGainDBArray," + onekHz_HoldingLowestLeftGainDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
        do {
            let csvonekHzSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvonekHzSummaryDocumentsDirectory = csvonekHzSummaryPath
            //             print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvonekHzSummaryDocumentsDirectory)")
            let csvonekHzSummaryFilePath = csvonekHzSummaryDocumentsDirectory.appendingPathComponent(summaryOnekHzCSVName)
            //             print(csvonekHzSummaryFilePath)
            let writer = try CSVWriter(fileURL: csvonekHzSummaryFilePath, append: false)
            try writer.write(row: [onekHzstringFinalOnekHzactiveFrequency])
            try writer.write(row: [onekHzstringFinalReversalGain])
            try writer.write(row: [onekHzstringFinalTestTestGain])
            try writer.write(row: [onekHzstringFinalAverageGainRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainArray])
            //             print("CVS Summary EHA Part 1 Data Writer Success")
            
//Added Below
            try writer.write(row: [onekHzstringFinalReversalGainDB])
            try writer.write(row: [onekHzstringFinalTestTestGainDB])
            try writer.write(row: [onekHzstringFinalAverageGainDBRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainDBLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainDBRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainDBArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftDBArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainDBArray])
//Added Above
            
        } catch {
            print("CVSWriter Summary 1kHz Data Error or Error Finding File for Detailed CSV \(error)")
        }
    }
    
    
    func onekHzWriteInputDetailedResultsToCSV() async {
        let onekHzstringFinalOnekHzactiveFrequency = [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzfirstGain = [onekHzfirstGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzsecondGain = [onekHzsecondGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHeardArray = onekHz_heardArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalHeard = onekHz_reversalHeard.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalGain = onekHz_reversalGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGain = onekHz_testTestGain.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGain = [onekHz_averageGain].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainRightArray = onekHz_averageGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainLeftArray = onekHz_averageGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainRightArray = onekHz_averageLowestGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainArray = onekHz_HoldingLowestRightGainArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftArray = onekHz_averageLowestGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainArray = onekHz_HoldingLowestLeftGainArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let onekHzstringFinalOnekHzfirstGainDB = [onekHzfirstGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalOnekHzsecondGainDB = [onekHzsecondGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalReversalGainDB = onekHz_reversalGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalTestTestGainDB = onekHz_testTestGainDB.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDB = [onekHz_averageGainDB].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDBRightArray = onekHz_averageGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDBLeftArray = onekHz_averageGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainDBRightArray = onekHz_averageLowestGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainDBArray = onekHz_HoldingLowestRightGainDBArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainDBLeftArray = onekHz_averageLowestGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainDBArray = onekHz_HoldingLowestLeftGainDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
        do {
            let csvInputonekHzDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputonekHzDetailDocumentsDirectory = csvInputonekHzDetailPath
            //            print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputonekHzDetailDocumentsDirectory)")
            let csvInputonekHzDetailFilePath = csvInputonekHzDetailDocumentsDirectory.appendingPathComponent(inputOnekHzDetailedCSVName)
            //            print(csvInputonekHzDetailFilePath)
            let writer = try CSVWriter(fileURL: csvInputonekHzDetailFilePath, append: false)
            try writer.write(row: [onekHzstringFinalOnekHzactiveFrequency])
            try writer.write(row: [onekHzstringFinalOnekHzfirstGain])
            try writer.write(row: [onekHzstringFinalOnekHzsecondGain])
            try writer.write(row: [onekHzstringFinalHeardArray])
            try writer.write(row: [onekHzstringFinalReversalHeard])
            try writer.write(row: [onekHzstringFinalReversalGain])
            try writer.write(row: [onekHzstringFinalTestTestGain])
            try writer.write(row: [onekHzstringFinalAverageGain])
            try writer.write(row: [onekHzstringFinalAverageGainRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainArray])
            //            print("CVS Input EHA Part 1Detailed Writer Success")
            
//Added Below
            try writer.write(row: [onekHzstringFinalOnekHzfirstGainDB])
            try writer.write(row: [onekHzstringFinalOnekHzsecondGainDB])
            try writer.write(row: [onekHzstringFinalReversalGainDB])
            try writer.write(row: [onekHzstringFinalTestTestGainDB])
            try writer.write(row: [onekHzstringFinalAverageGainDB])
            try writer.write(row: [onekHzstringFinalAverageGainDBRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainDBLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainDBRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainDBArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainDBLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainDBArray])
//Added Above
            
        } catch {
            print("CVSWriter Input 1kHZ Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }
    
    func onekHzwriteInputSummarydResultsToCSV() async {
        //        let onekHzstringFinalOnekHzactiveFrequency = [onekHzactiveFrequency].map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainRightArray = onekHz_averageGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainLeftArray = onekHz_averageGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainRightArray = onekHz_averageLowestGainRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainArray = onekHz_HoldingLowestRightGainArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainLeftArray = onekHz_averageLowestGainLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainArray = onekHz_HoldingLowestLeftGainArray.map { String($0) }.joined(separator: ",")
        
// Added Below
        let onekHzstringFinalAverageGainDBRightArray = onekHz_averageGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageGainDBLeftArray = onekHz_averageGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainDBRightArray = onekHz_averageLowestGainDBRightArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestRightGainDBArray = onekHz_HoldingLowestRightGainDBArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalAverageLowestGainDBLeftArray = onekHz_averageLowestGainDBLeftArray.map { String($0) }.joined(separator: ",")
        let onekHzstringFinalHoldingLowestLeftGainDBArray = onekHz_HoldingLowestLeftGainDBArray.map { String($0) }.joined(separator: ",")
// Added Above
        
        do {
            let csvonekHzInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvonekHzInputSummaryDocumentsDirectory = csvonekHzInputSummaryPath
            //             print("CSV Input onekHz Summary DocumentsDirectory: \(csvonekHzInputSummaryDocumentsDirectory)")
            let csvonekHzInputSummaryFilePath = csvonekHzInputSummaryDocumentsDirectory.appendingPathComponent(inputOnekHzSummaryCSVName)
            print(csvonekHzInputSummaryFilePath)
            let writer = try CSVWriter(fileURL: csvonekHzInputSummaryFilePath, append: false)
            //             try writer.write(row: [onekHzstringFinalOnekHzactiveFrequency])
            try writer.write(row: [onekHzstringFinalAverageGainRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainArray])
            //             print("CVS Input EHA Part 1 Summary Data Writer Success")
            
// Added Below
            try writer.write(row: [onekHzstringFinalAverageGainDBRightArray])
            try writer.write(row: [onekHzstringFinalAverageGainDBLeftArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainDBRightArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestRightGainDBArray])
            try writer.write(row: [onekHzstringFinalAverageLowestGainDBLeftArray])
            try writer.write(row: [onekHzstringFinalHoldingLowestLeftGainDBArray])
// Added Above
            
        } catch {
            print("CVSWriter Input 1kHZ Summary Data Error or Error Finding File for Input Summary CSV \(error)")
        }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
    func comparedLastNameCSVReader() async {
        let dataSetupName = inputFinalComparedLastNameCSV
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLComparedLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLComparedLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLComparedLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputLastName = fieldLastName
            print("inputLastName: \(inputLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
    
    private func uploadFile(fileName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let storageRef = Storage.storage().reference()
            let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
            let lastNameRef = storageRef.child(inputLastName)
            let fileManager = FileManager.default
            let filePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [fileName])
            if fileManager.fileExists(atPath: filePath[0]) {
                let filePath = URL(fileURLWithPath: filePath[0])
                let localFile = filePath
                //                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
                let fileRef = lastNameRef.child("\(fileName)")
                
                let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
                    if error == nil && metadata == nil {
                        //TSave a reference to firestore database
                    }
                    return
                }
                print(uploadTask)
            } else {
                print("No File")
            }
        }
    }
}
 
extension Bilateral1kHzTestContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

struct Bilateral1kHzTestView_Previews: PreviewProvider {
    static var previews: some View {
        Bilateral1kHzTestView(testing: nil, relatedLinkTesting: linkTesting)
    }

    static func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}
