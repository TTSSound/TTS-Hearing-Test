//
//  EarSimulatorManual0View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 2/23/23.
//

import SwiftUI
import AVFAudio
import AVFoundation
import AVKit
import CoreMedia
import Combine
import CodableCSV


struct SamplesESM0List: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}

struct EarSimulatorManual0View: View {
    
    @State private var samples = [SamplesESM0List]()
    
    @State private var samplesHighResStd = [
        SamplesESM0List(name: "Sample1"),
        SamplesESM0List(name: "Sample2"),
        SamplesESM0List(name: "Sample3"),
        SamplesESM0List(name: "Sample4"),
        SamplesESM0List(name: "Sample5"),
        SamplesESM0List(name: "Sample6"),
        SamplesESM0List(name: "Sample7"),
        SamplesESM0List(name: "Sample8"),
        SamplesESM0List(name: "Sample9"),
        SamplesESM0List(name: "Sample10"),
        SamplesESM0List(name: "Sample11"),
        SamplesESM0List(name: "Sample12"),
        SamplesESM0List(name: "Sample13"),
        SamplesESM0List(name: "Sample14"),
        SamplesESM0List(name: "Sample15"),
        SamplesESM0List(name: "Sample16")
    ]
    
    @State private var samplesHighResFaded = [
        SamplesESM0List(name: "FSample1"),
        SamplesESM0List(name: "FSample2"),
        SamplesESM0List(name: "FSample3"),
        SamplesESM0List(name: "FSample4"),
        SamplesESM0List(name: "FSample5"),
        SamplesESM0List(name: "FSample6"),
        SamplesESM0List(name: "FSample7"),
        SamplesESM0List(name: "FSample8"),
        SamplesESM0List(name: "FSample9"),
        SamplesESM0List(name: "FSample10"),
        SamplesESM0List(name: "FSample11"),
        SamplesESM0List(name: "FSample12"),
        SamplesESM0List(name: "FSample13"),
        SamplesESM0List(name: "FSample14"),
        SamplesESM0List(name: "FSample15"),
        SamplesESM0List(name: "FSample16")
    ]
    
    @State private var samplesCDDitheredFaded = [
        SamplesESM0List(name: "FDSample1"),
        SamplesESM0List(name: "FDSample2"),
        SamplesESM0List(name: "FDSample3"),
        SamplesESM0List(name: "FDSample4"),
        SamplesESM0List(name: "FDSample5"),
        SamplesESM0List(name: "FDSample6"),
        SamplesESM0List(name: "FDSample7"),
        SamplesESM0List(name: "FDSample8"),
        SamplesESM0List(name: "FDSample9"),
        SamplesESM0List(name: "FDSample10"),
        SamplesESM0List(name: "FDSample11"),
        SamplesESM0List(name: "FDSample12"),
        SamplesESM0List(name: "FDSample13"),
        SamplesESM0List(name: "FDSample14"),
        SamplesESM0List(name: "FDSample15"),
        SamplesESM0List(name: "FDSample16")
    ]
    
    
    @State private var sampleSelected = [Int]()
    @State private var sampleSelectionIndex = [Int]()
    @State private var sampleSelectedName = [String]()
    @State private var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var ESM0localHeard = 0
    @State private var ESM0localPlaying = Int()    // Playing = 1. Stopped = -1
    @State private var ESM0localReversal = Int()
//    @State private var ESM0localReversalEnd = Int()
//    @State private var ESM0localMarkNewTestCycle = Int()
    @State private var ESM0testPlayer: AVAudioPlayer?
    
//    @State private var ESM0localTestCount = 0
//    @State private var ESM0localStartingNonHeardArraySet: Bool = false
//    @State private var ESM0localReversalHeardLast = Int()
//    @State private var ESM0localSeriesNoResponses = Int()
//    @State private var ESM0firstHeardResponseIndex = Int()
//    @State private var ESM0firstHeardIsTrue: Bool = false
//    @State private var ESM0secondHeardResponseIndex = Int()
//    @State private var ESM0secondHeardIsTrue: Bool = false
//    @State private var ESM0startTooHigh = 0
//    @State private var ESM0firstGain = Float()
//    @State private var ESM0secondGain = Float()
    @State private var ESM0endTestSeriesValue: Bool = false
    @State private var ESM0showTestCompletionSheet: Bool = false
    
    @State private var ESM0_samples: [String] = [String]()
    
    @State private var highResStdSamples: [String] =  ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8",
                                                       "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    
    @State private var highResFadedSamples: [String] =  ["FSample1", "FSample2", "FSample3", "FSample4", "FSample5", "FSample6", "FSample7", "FSample8",
                                                         "FSample9", "FSample10", "FSample11", "FSample12", "FSample13", "FSample14", "FSample15", "FSample16"]
    
    @State private var cdFadedDitheredSamples: [String] =  ["FDSample1", "FDSample2", "FDSample3", "FDSample4", "FDSample5", "FDSample6", "FDSample7", "FDSample8",
                                                            "FDSample9", "FDSample10", "FDSample11", "FDSample12", "FDSample13", "FDSample14", "FDSample15", "FDSample16"]
    
    @State private var ESM0_index: Int = 0
    @State private var ESM0_testGain: Float = 0
    @State private var ESM0_heardArray: [Int] = [Int]()
    @State private var ESM0_indexForTest = [Int]()
//    @State private var ESM0_testCount: [Int] = [Int]()
    @State private var ESM0_pan: Float = Float()
//    @State private var ESM0_testPan = [Float]()
//    @State private var ESM0_testTestGain = [Float]()
//    @State private var ESM0_frequency = [String]()
//    @State private var ESM0_reversalHeard = [Int]()
//    @State private var ESM0_reversalGain = [Float]()
//    @State private var ESM0_reversalFrequency = [String]()
//    @State private var ESM0_reversalDirection = Float()
//    @State private var ESM0_reversalDirectionArray = [Float]()
    
//    @State private var ESM0_averageGain = Float()
    
//    @State private var ESM0_eptaSamplesCount = 1 //17
//    @State private var ESM0_SamplesCountArray = [1, 1]
//    @State private var ESM0_SamplesCountArrayIdx = 0
    
//    @State private var ESM0_finalStoredIndex: [Int] = [Int]()
//    @State private var ESM0_finalStoredTestPan: [Float] = [Float]()
//    @State private var ESM0_finalStoredTestTestGain: [Float] = [Float]()
//    @State private var ESM0_finalStoredFrequency: [String] = [String]()
//    @State private var ESM0_finalStoredTestCount: [Int] = [Int]()
//    @State private var ESM0_finalStoredHeardArray: [Int] = [Int]()
//    @State private var ESM0_finalStoredReversalHeard: [Int] = [Int]()
//    @State private var ESM0_finalStoredFirstGain: [Float] = [Float]()
//    @State private var ESM0_finalStoredSecondGain: [Float] = [Float]()
//    @State private var ESM0_finalStoredAverageGain: [Float] = [Float]()
//
//    @State private var ESM0idxForTest = Int() // = ESM0_indexForTest.count
//    @State private var ESM0idxForTestNet1 = Int() // = ESM0_indexForTest.count - 1
//    @State private var ESM0idxTestCount = Int() // = ESM0_TestCount.count
//    @State private var ESM0idxTestCountUpdated = Int() // = ESM0_TestCount.count + 1
    @State private var ESM0activeFrequency = String()
//    @State private var ESM0idxHA = Int()    // idx = ESM0_heardArray.count
//    @State private var ESM0idxReversalHeardCount = Int()
//    @State private var ESM0idxHAZero = Int()    //  idxZero = idx - idx
//    @State private var ESM0idxHAFirst = Int()   // idxFirst = idx - idx + 1
//    @State private var ESM0isCountSame = Int()
//    @State private var ESM0heardArrayIdxAfnet1 = Int()
    @State private var ESM0testIsPlaying: Bool = false
    @State private var ESM0playingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State private var ESM0playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
//
//    @State private var ESM0playingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
//    @State private var ESM0TappingColorIndex = 0
//    @State private var ESM0TappingGesture: Bool = false
    
    @State private var ESM0playingStringColorIndex = 0
    @State private var ESM0userPausedTest: Bool = false
    
//    @State private var ESM0TestCompleted: Bool = false
    
//    @State private var ESM0fullTestCompleted: Bool = false
//    @State private var ESM0fullTestCompletedHoldingArray: [Bool] = [false, false, true]
    @State private var ESM0TestStarted: Bool = false
    
    
//    let inputESM0CSVName = "InputDetailedEarSimulatorM1ResultsCSV.csv"
    
    
    let earSimulatorM1heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM1arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM1audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
//    @State private var earSimulatorM1testPlayerlocalHeard = Int()
    @State private var earSimulatorM1_volume = Float()
    @State private var newactiveFrequency = String()
    @State private var earSimulatorM1Cycle: Bool = false
    
    @State private var changeSampleArray: Bool = false
    @State private var highResStandard: Bool = false
    @State private var highResFaded: Bool = false
    @State private var cdFadedDithered: Bool = false
    @State private var sampleArraySet: Bool = false
    
    @State private var earSimulatorM1showTestCompletionSheet: Bool = false
    
    let earSimulatorM1ThreadBackground = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1ThreadDefault = DispatchQueue(label: "AudioThread", qos: .default)
    let earSimulatorM1ThreadUserInteractive = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let earSimulatorM1ThreadUserInitiated = DispatchQueue(label: "AudioThread", qos: .userInitiated)
    
    @State private var showQoSThreads: Bool = false
    @State private var qualityOfService = Int()
    @State private var qosBackground: Bool = false
    @State private var qosDefault: Bool = false
    @State private var qosUserInteractive: Bool = false
    @State private var qosUserInitiated: Bool = false
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundTopNeonGreen.ignoresSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
//
//
//Button to open popup view to select sample to load into audio player (and QOS thread type here and different sample versions, neither of which are needed any more for the next/future use). Only need to select from 16 samples... FDSample1...FDSample16
                    Button {
                        if changeSampleArray == true {
                            self.highResStandard = highResStandard
                            self.highResFaded = highResFaded
                            self.cdFadedDithered = cdFadedDithered
                            self.sampleArraySet = sampleArraySet
                        }
                        earSimulatorM1showTestCompletionSheet = true
                        ESM0stop()
                    } label: {
                        Text("\(ESM0activeFrequency)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                    Spacer()

//
//
//Button to query system volume and display result
                    Button {
                        audioSessionModel.setAudioSession()
                        earSimulatorM1_volume = audioSessionModel.audioSession.outputVolume
                    } label: {
                        Text("Vol: \(earSimulatorM1_volume)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(24)
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
//
//
//Button to start plackback of loaded sample
                if ESM0TestStarted == false {
                    Button {    // Start Button
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            ESM0localPlaying = 1
                            ESM0endTestSeriesValue = false
                            print("Start Button Clicked. Playing = \(ESM0localPlaying)")
                        }
                    } label: {
                        Text("Click to Start")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 300, height: 40, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

//
//
// Below replaces the play button with a pause and restart button
// Neither are really needed. Only one button is needed to play a loaded sample when triggered
                } else if ESM0TestStarted == true {
                    HStack{
                        Spacer()
                        Button {    // Pause Button
                            ESM0localPlaying = 0
                            ESM0stop()
                            ESM0userPausedTest = true
                            ESM0playingStringColorIndex = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                        } label: {
                            Text("Pause")
                                .frame(width: 100, height: 40, alignment: .center)
                                .background(Color .yellow)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                            
                        }
                        Spacer()

                        Button {    //Restart Button
                            ESM0_heardArray.removeAll()
                            ESM0pauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            ESM0localPlaying = 1
                            ESM0userPausedTest = false
                            ESM0playingStringColorIndex = 0
                        } label: {
                            Text("Restart")
                                .frame(width: 100, height: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(colorModel.tiffanyBlue)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
//
//
// Display gain parameter of audio player as assigned based on the manual gain change buttons
// Display gain to 16 decimal places
                HStack{
                    Text(String(format: "%.16f", ESM0_testGain))
                }
                .frame(width: 400, height: 30, alignment: .center)
                .foregroundColor(.white)
                .font(.title)
                .padding(.bottom, 10)
//
//
//Reset Gain Button
//Reset gain to empty float element
                Button("GainReset=0") {
                    ESM0_testGain = Float()
                }
                .fontWeight(.bold)
                .frame(width: 200, height: 30, alignment: .center)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(24)
                .padding(.trailing, 160)
                .padding(.leading, 10)
                .padding(.top, 10)
                .padding(.bottom, 20)

//
//
//Scroll View #1 of Gain Change Buttons
                ScrollView{
        
                    
                    HStack{
                        Spacer()
                        Button {
                            Task{
                                let newGain: Float = ESM0_testGain - 10E-17 //0.0000000000000001
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-17 //0.0000000000000001
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-17 //0.0000000000000001
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-17")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-17
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-17
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-17
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task{
                                let newGain: Float = ESM0_testGain - 10E-16
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-16
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-16
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-16")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-16
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-16
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-16
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-15
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-15
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-15
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-15")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-15
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-15
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-15
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-14
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-14
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-14
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-14")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-14
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-14
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-14
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-13
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-13
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-13
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-13")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-13
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-13
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-13
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-12
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-12
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-12
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-12")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-12
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-12
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-12
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-11
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-11
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-11
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-11")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-11
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-11
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-11
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-10
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-10
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-10
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-10")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-10
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-10
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-10
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                }
                .frame(width: 400, height: 190, alignment: .center)
                .background(Color.clear)
                .padding(.top, 10)
                .padding(.bottom, 30)
//End of Scroll View #1
//
//
                
//
//
//Scroll View #2 of Gain Change Buttons
                ScrollView{
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-9
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-9
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-9
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-9")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-9
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-9
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-9
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-8
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-8
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-8
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-8")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-8
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-8
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-8
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-7
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-7
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-7
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-7")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-7
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-7
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-7
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-6
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-6
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-6
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-6")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-6
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-6
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-6
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-5
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-5
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-5
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-5")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-5
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-5
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-5
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-4
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-4
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-4
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-4")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-4
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-4
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-4
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-3
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-3
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-3
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-3")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-3
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-3
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-3
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-2
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-2
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-2
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-2")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-2
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-2
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-2
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
// Pan Buttons in Scroll View #2
                    HStack{
                        Spacer()
                        Button {    // Left Pan
                            ESM0_pan = -1.0
                        } label: {
                            Text("Left Pan")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button {    // Middle Pan
                            ESM0_pan = 0.0
                        } label: {
                            Text("Middle Pan")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Button {    // Right Pan
                            ESM0_pan = 1.0
                        } label: {
                            Text("Right Pan")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 480, height: 50, alignment: .center)
                    .font(.caption)
                    .background(Color.clear)
                    .cornerRadius(24)
                    .padding(.bottom, 10)
                    
                }
                .frame(width: 400, height: 190, alignment: .center)
                .background(Color.clear)
                .padding(.bottom, 40)

// End of Scroll View #2
//
//
                
//
//
// Popup Menu to select different Samples
            }
            .onAppear(perform: {
                earSimulatorM1showTestCompletionSheet = true
             })
            .fullScreenCover(isPresented: $earSimulatorM1showTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            earSimulatorM1showTestCompletionSheet.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.red)
                        })
                        
//Below is not needed related to QOS
// This was to try different QOS assignments to see thread and CPU usage
// Not Needed anymore
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
//Below is not needed
//Only need to have one set of samples
//This was to try different sample versions by selection within view, but is not needed anymore
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
                                samples.removeAll()
                                //set other toggles to fales
                                highResFaded = false
                                cdFadedDithered = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesHighResStd)
                                print("samples: \(samples)")
                            }

                        }
                        .onChange(of: highResFaded) { highResFadedValue in
                            sampleArraySet = false
                            if highResFadedValue == true && sampleArraySet == false {
                                //remove array values
                                samples.removeAll()
                                //set other toggles to fales
                                highResStandard = false
                                cdFadedDithered = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesHighResFaded)
                                print("samples: \(samples)")
                            }
                        }
                        .onChange(of: cdFadedDithered) { cdFadedDitheredValue in
                            sampleArraySet = false
                            if cdFadedDitheredValue == true && sampleArraySet == false {
                                //remove array values
                                samples.removeAll()
                                //set other toggles to fales
                                highResStandard = false
                                highResFaded = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesCDDitheredFaded)
                                print("samples: \(samples)")
                            }
                        }
//
//
//Sample Selection List
                        List {
                            ForEach(samples.indices, id: \.self) { index in
                                HStack {
                                    Text("\(self.samples[index].name)")
                                        .foregroundColor(.white)
                                    Toggle("", isOn: self.$samples[index].isToggledS)
                                        .foregroundColor(.white)
                                        .onChange(of: self.samples[index].isToggledS) { nameIndex in
                                            sampleSelectionIndex.removeAll()
                                            sampleSelectedName.append(self.samples[index].name)
                                            sampleSelectedID.append(self.samples[index].id)
                                            sampleSelectionIndex.append(index)
                                            ESM0activeFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM1activeFrequency: \(ESM0activeFrequency)")
                                            print("index: \(index)")
                                        }
                                }
                                .cornerRadius(12)
                                .scrollContentBackground(.hidden)
                                .listRowInsets(nil)
                                .listRowBackground(Color.clear)
                            }
                        }
                        .background(colorModel.colorBackgroundTopDarkNeonGreen)
                        .scrollContentBackground(.hidden)
                        .listRowInsets(nil)
                        .listRowBackground(Color.clear)
//
//
// Below is not needed, as you will not have multiple different version of the same samples
                        .onAppear {
                            sampleSelectionIndex.removeAll()
                            sampleSelectedName.removeAll()
                            sampleSelectedID.removeAll()
                            if sampleArraySet == false && highResStandard == false && highResFaded == false && cdFadedDithered == false {
                                highResStandard = true
                                highResFaded = false
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResStd)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == true && highResFaded == false && cdFadedDithered == false {
                                highResStandard = true
                                highResFaded = false
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResStd)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == false && highResFaded == true && cdFadedDithered == false {
                                highResStandard = false
                                highResFaded = true
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResFaded)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == false && highResFaded == false && cdFadedDithered == true {
                                highResStandard = false
                                highResFaded = false
                                cdFadedDithered = true
                                //append highresstd to array
                                samples.append(contentsOf: samplesCDDitheredFaded)
                                sampleArraySet = true
                            }
                        }
//
//
// Dismiss Popup
                        Spacer()
                        HStack{
                            Spacer()
                            Button("Dismiss and Start") {
                                ESM0_samples.removeAll()
                                earSimulatorM1showTestCompletionSheet.toggle()
                            }
                            .frame(width: 200, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(24)
                        Spacer()
                        }
                        Spacer()
                    }
                }
            })

//
//
// Nothing below is needed except for maybe starting an audio session
            .onChange(of: ESM0testIsPlaying, perform: { ESM0testBoolValue in
                if ESM0testBoolValue == true && ESM0endTestSeriesValue == false {
                    //User is starting test for first time
                    audioSessionModel.setAudioSession()
                    ESM0localPlaying = 1
                    ESM0playingStringColorIndex = 0
                    ESM0userPausedTest = false
                } else if ESM0testBoolValue == false && ESM0endTestSeriesValue == false {
                    // User is pausing test for firts time
                    ESM0stop()
                    ESM0localPlaying = 0
                    ESM0playingStringColorIndex = 1
                    ESM0userPausedTest = true
                } else if ESM0testBoolValue == true && ESM0endTestSeriesValue == true {
                    ESM0stop()
                    ESM0localPlaying = -1
                    ESM0playingStringColorIndex = 2
                    ESM0userPausedTest = true
                } else {
                    print("Critical error in pause logic")
                }
            })
            .onChange(of: ESM0localPlaying) { ESM0playingValue in
                ESM0_samples.append(ESM0activeFrequency)
                ESM0localHeard = 0
                ESM0localReversal = 0
                newactiveFrequency = ESM0_samples[ESM0_index]
                ESM0TestStarted = true
                if ESM0playingValue == 1{
                    
                    if qualityOfService == 1 {
                        print("QOS Thread Background")
                        earSimulatorM1ThreadBackground.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 2 {
                        print("QOS Thread Default")
                        earSimulatorM1ThreadDefault.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 3 {
                        print("QOS Thread UserInteractive")
                        earSimulatorM1ThreadUserInteractive.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 4 {
                        print("QOS Thread UserInitiated")
                        earSimulatorM1ThreadUserInitiated.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else {
                        print("QOS Thread Not Set, Catch Setting of Default")
                        earSimulatorM1audioThread.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    }
// End of Not Needed Items from Above
//
//
           
                    
                    
                    
//                    earSimulatorM1preEventThread.async {
//                        ESM0preEventLogging()
//                    }
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
//                        ESM0localTestCount += 1
                        Task(priority: .userInitiated) {
//                            await ESM0heardArrayNormalize()
//                            await ESM0count()
                            await ESM0logNotPlaying()
                            await ESM0resetPlaying()
                            await ESM0resetHeard()
//                            await ESM0createReversalHeardArray()
//                            await ESM0createReversalSampleArray()
//                            await ESM0reversalStart()
                        }
                    }
                }
            }
            .onChange(of: ESM0localReversal) { ESM0reversalValue in
                if ESM0reversalValue == 1 {
                    DispatchQueue.global(qos: .background).async {
                        Task(priority: .userInitiated) {
//                            await writeESM0ResultsToCSV()
                            await ESM0restartPresentation()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual0View {
    enum ESM0SampleErrors: Error {
        case ESM0notFound
        case earSimulatorM1lastUnexpected(code: Int)
    }

    private func ESM0pauseRestartTestCycle() {
//        ESM0localMarkNewTestCycle = 0
//        ESM0localReversalEnd = 0
        ESM0_index = 0
        ESM0_samples.removeAll()
        ESM0_samples.append(ESM0activeFrequency)
        newactiveFrequency = ESM0_samples[ESM0_index]
        ESM0_testGain = ESM0_testGain
        ESM0testIsPlaying = false
        ESM0localPlaying = 0
//        ESM0_testCount.removeAll()
//        ESM0_reversalHeard.removeAll()
//        ESM0_averageGain = Float()
//        ESM0_reversalDirection = Float()
//        ESM0localStartingNonHeardArraySet = false
//        ESM0firstHeardResponseIndex = Int()
//        ESM0firstHeardIsTrue = false
//        ESM0secondHeardResponseIndex = Int()
//        ESM0secondHeardIsTrue = false
//        ESM0localTestCount = 0
//        ESM0localReversalHeardLast = Int()
//        ESM0startTooHigh = 0
    }
    
    private func ESM0loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
            do{
                let ESM0urlSample = Bundle.main.path(forResource: newactiveFrequency, ofType: ".wav")
                guard let ESM0urlSample = ESM0urlSample else { return print(ESM0SampleErrors.ESM0notFound) }
                ESM0testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM0urlSample))
                guard let ESM0testPlayer = ESM0testPlayer else { return }
                ESM0testPlayer.prepareToPlay()    // Test Player Prepare to Play
                ESM0testPlayer.setVolume(ESM0_testGain, fadeDuration: 0)      // Set Gain for Playback
                ESM0testPlayer.pan = ESM0_pan
                ESM0testPlayer.play()   // Start Playback
            } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    private func ESM0stop() {
      do{
          let ESM0urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let ESM0urlSample = ESM0urlSample else { return print(ESM0SampleErrors.ESM0notFound) }
          ESM0testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM0urlSample))
          guard let ESM0testPlayer = ESM0testPlayer else { return }
          ESM0testPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
//    private func ESM0resetNonResponseCount() async {ESM0localSeriesNoResponses = 0 }
//
//    private func ESM0nonResponseCounting() async {ESM0localSeriesNoResponses += 1 }
//
    private func ESM0resetPlaying() async { self.ESM0localPlaying = 0 }

    private func ESM0logNotPlaying() async { self.ESM0localPlaying = -1 }

    private func ESM0resetHeard() async { self.ESM0localHeard = 0 }

    private func ESM0reversalStart() async { self.ESM0localReversal = 1}
//
//    private func ESM0preEventLogging() {
//        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//            ESM0_indexForTest.append(ESM0_index)
//        }
//        DispatchQueue.global(qos: .default).async {
//            ESM0_testTestGain.append(ESM0_testGain)
//        }
//        DispatchQueue.global(qos: .background).async {
//            ESM0_frequency.append(ESM0activeFrequency)
//            ESM0_testPan.append(ESM0_pan)
//        }
//    }
//
//    private func ESM0responseHeardArray() async {
//        ESM0_heardArray.append(1)
//        self.ESM0idxHA = ESM0_heardArray.count
//        self.ESM0localStartingNonHeardArraySet = true
//    }
//
//    private func ESM0localResponseTracking() async {
//        if ESM0firstHeardIsTrue == false {
//            ESM0firstHeardResponseIndex = ESM0localTestCount
//            ESM0firstHeardIsTrue = true
//        } else if ESM0firstHeardIsTrue == true {
//            ESM0secondHeardResponseIndex = ESM0localTestCount
//            ESM0secondHeardIsTrue = true
//            print("Second Heard Is True Logged!")
//
//        } else {
//            print("Error in localResponseTrackingLogic")
//        }
//    }
//
//    private func ESM0heardArrayNormalize() async {
//        ESM0idxHA = ESM0_heardArray.count
//        ESM0idxForTest = ESM0_indexForTest.count
//        ESM0idxForTestNet1 = ESM0idxForTest - 1
//        ESM0isCountSame = ESM0idxHA - ESM0idxForTest
//        ESM0heardArrayIdxAfnet1 = ESM0_heardArray.index(after: ESM0idxForTestNet1)
//
//        if ESM0localStartingNonHeardArraySet == false {
//            ESM0_heardArray.append(0)
//            self.ESM0localStartingNonHeardArraySet = true
//            ESM0idxHA = ESM0_heardArray.count
//            ESM0idxHAZero = ESM0idxHA - ESM0idxHA
//            ESM0idxHAFirst = ESM0idxHAZero + 1
//            ESM0isCountSame = ESM0idxHA - ESM0idxForTest
//            ESM0heardArrayIdxAfnet1 = ESM0_heardArray.index(after: ESM0idxForTestNet1)
//            } else {
//                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
//            }
//    }
//
//    private func ESM0count() async {
//        ESM0idxTestCountUpdated = ESM0_testCount.count + 1
//        ESM0_testCount.append(ESM0idxTestCountUpdated)
//    }
}

extension EarSimulatorManual0View {
//MARK: -Extension Methods Reversals
    
//    private func ESM0createReversalHeardArray() async {
//        ESM0_reversalHeard.append(ESM0_heardArray[ESM0idxHA-1])
//        self.ESM0idxReversalHeardCount = ESM0_reversalHeard.count
//    }
//
//    private func ESM0createReversalGainArray() async {
//        ESM0_reversalGain.append(ESM0_testGain)
//    }
//
//    private func ESM0createReversalSampleArray() async {
//        ESM0_frequency.append(newactiveFrequency)
//    }
//
//    private func createReversalGainArrayNonResponse() async {
//        if ESM0_testGain < 0.995 {
//            ESM0_reversalGain.append(ESM0_testGain)
//        } else if ESM0_testGain >= 0.995 {
//            ESM0_reversalGain.append(1.0)
//        }
//    }
//
//    private func ESM0checkHeardReversalArrays() async {
//        if ESM0idxHA - ESM0idxReversalHeardCount == 0 {
//            print("Success, Arrays match")
//        } else if ESM0idxHA - ESM0idxReversalHeardCount < 0 && ESM0idxHA - ESM0idxReversalHeardCount > 0{
//            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
//        } else {
//            fatalError("hit else in check reversal arrays")
//        }
//    }
//
//    private func ESM0reversalDirection() async {
//        ESM0localReversalHeardLast = ESM0_reversalHeard.last ?? -999
//        if ESM0localReversalHeardLast == 1 {
//            ESM0_reversalDirection = -1.0
//            ESM0_reversalDirectionArray.append(-1.0)
//        } else if ESM0localReversalHeardLast == 0 {
//            ESM0_reversalDirection = 1.0
//            ESM0_reversalDirectionArray.append(1.0)
//        } else {
//            print("Error in Reversal Direction reversalHeardArray Count")
//        }
//    }
//
//    private func ESM0reversalOfOne() async {
//        let ESM0rO1Direction = 0.01 * ESM0_reversalDirection
//        let ESM0r01NewGain = ESM0_testGain + ESM0rO1Direction
//        if ESM0r01NewGain > 0.00001 && ESM0r01NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r01NewGain * 100000) / 100000
//        } else if ESM0r01NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r01NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfOne Logic")
//        }
//    }
//
//    private func ESM0reversalOfTwo() async {
//        let ESM0rO2Direction = 0.02 * ESM0_reversalDirection
//        let ESM0r02NewGain = ESM0_testGain + ESM0rO2Direction
//        if ESM0r02NewGain > 0.00001 && ESM0r02NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r02NewGain * 100000) / 100000
//        } else if ESM0r02NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r02NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfTwo Logic")
//        }
//    }
//
//    private func ESM0reversalOfThree() async {
//        let ESM0rO3Direction = 0.03 * ESM0_reversalDirection
//        let ESM0r03NewGain = ESM0_testGain + ESM0rO3Direction
//        if ESM0r03NewGain > 0.00001 && ESM0r03NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r03NewGain * 100000) / 100000
//        } else if ESM0r03NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r03NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfThree Logic")
//        }
//    }
//
//    private func ESM0reversalOfFour() async {
//        let ESM0rO4Direction = 0.04 * ESM0_reversalDirection
//        let ESM0r04NewGain = ESM0_testGain + ESM0rO4Direction
//        if ESM0r04NewGain > 0.00001 && ESM0r04NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r04NewGain * 100000) / 100000
//        } else if ESM0r04NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r04NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfFour Logic")
//        }
//    }
//
//    private func ESM0reversalOfFive() async {
//        let ESM0rO5Direction = 0.05 * ESM0_reversalDirection
//        let ESM0r05NewGain = ESM0_testGain + ESM0rO5Direction
//        if ESM0r05NewGain > 0.00001 && ESM0r05NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r05NewGain * 100000) / 100000
//        } else if ESM0r05NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r05NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfFive Logic")
//        }
//    }
//
//    private func ESM0reversalOfTen() async {
//        let ESM0r10Direction = 0.10 * ESM0_reversalDirection
//        let ESM0r10NewGain = ESM0_testGain + ESM0r10Direction
//        if ESM0r10NewGain > 0.00001 && ESM0r10NewGain < 1.0 {
//            ESM0_testGain = roundf(ESM0r10NewGain * 100000) / 100000
//        } else if ESM0r10NewGain <= 0.0 {
//            ESM0_testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if ESM0r10NewGain >= 0.995 {
//            ESM0_testGain = 0.995
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            print("!!!Fatal Error in reversalOfTen Logic")
//        }
//    }
//
//    private func ESM0reversalAction() async {
//        if ESM0localReversalHeardLast == 1 {
//            await ESM0reversalOfFive()
//        } else if ESM0localReversalHeardLast == 0 {
//            await ESM0reversalOfTwo()
//        } else {
//            print("!!!Critical error in Reversal Action")
//        }
//    }
//
//    private func ESM0reversalComplexAction() async {
//        if ESM0idxReversalHeardCount <= 1 && ESM0idxHA <= 1 {
//            await ESM0reversalAction()
//        }  else if ESM0idxReversalHeardCount == 2 {
//            if ESM0idxReversalHeardCount == 2 && ESM0secondHeardIsTrue == true {
//                await ESM0startTooHighCheck()
//            } else if ESM0idxReversalHeardCount == 2  && ESM0secondHeardIsTrue == false {
//                await ESM0reversalAction()
//            } else {
//                print("In reversal section == 2")
//                print("Failed reversal section startTooHigh")
//                print("!!Fatal Error in reversalHeard and Heard Array Counts")
//            }
//        } else if ESM0idxReversalHeardCount >= 3 {
//            print("reversal section >= 3")
//            if ESM0secondHeardResponseIndex - ESM0firstHeardResponseIndex == 1 {
//                print("reversal section >= 3")
//                print("In first if section sHRI - fHRI == 1")
//                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
//            } else if ESM0localSeriesNoResponses == 3 {
//                await ESM0reversalOfTen()
//            } else if ESM0localSeriesNoResponses == 2 {
//                await ESM0reversalOfFour()
//            } else {
//                await ESM0reversalAction()
//            }
//        } else {
//            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
//        }
//    }
//
//    private func ESM0reversalHeardCount1() async {
//        await ESM0reversalAction()
//    }
//
//    private func ESM0check2PositiveSeriesReversals() async {
//        if ESM0_reversalHeard[ESM0idxHA-2] == 1 && ESM0_reversalHeard[ESM0idxHA-1] == 1 {
//            print("reversal - check2PositiveSeriesReversals")
//            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
//        }
//    }
//
//    private func ESM0checkTwoNegativeSeriesReversals() async {
//        if ESM0_reversalHeard.count >= 3 && ESM0_reversalHeard[ESM0idxHA-2] == 0 && ESM0_reversalHeard[ESM0idxHA-1] == 0 {
//            await ESM0reversalOfFour()
//        } else {
//            await ESM0reversalAction()
//        }
//    }
//
//    private func ESM0startTooHighCheck() async {
//        if ESM0startTooHigh == 0 && ESM0firstHeardIsTrue == true && ESM0secondHeardIsTrue == true {
//            ESM0startTooHigh = 1
//            await ESM0reversalOfTen()
//            await ESM0resetAfterTooHigh()
//            print("Too High Found")
//        } else {
//            await ESM0reversalAction()
//        }
//    }
//
//    private func ESM0resetAfterTooHigh() async {
//        ESM0firstHeardResponseIndex = Int()
//        ESM0firstHeardIsTrue = false
//        ESM0secondHeardResponseIndex = Int()
//        ESM0secondHeardIsTrue = false
//    }
//
//    private func ESM0reversalsCompleteLogging() async {
//        if ESM0secondHeardIsTrue == true {
//            self.ESM0localReversalEnd = 1
//            self.ESM0localMarkNewTestCycle = 1
//            self.ESM0firstGain = ESM0_reversalGain[ESM0firstHeardResponseIndex-1]
//            self.ESM0secondGain = ESM0_reversalGain[ESM0secondHeardResponseIndex-1]
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//            let ESM0delta = ESM0firstGain - ESM0secondGain
//            let ESM0avg = (ESM0firstGain + ESM0secondGain)/2
//            if ESM0delta == 0 {
//                ESM0_averageGain = ESM0secondGain
//                print("average Gain: \(ESM0_averageGain)")
//            } else if ESM0delta >= 0.05 {
//                ESM0_averageGain = ESM0secondGain
//                print("SecondGain: \(ESM0firstGain)")
//                print("SecondGain: \(ESM0secondGain)")
//                print("average Gain: \(ESM0_averageGain)")
//            } else if ESM0delta <= -0.05 {
//                ESM0_averageGain = ESM0firstGain
//                print("SecondGain: \(ESM0firstGain)")
//                print("SecondGain: \(ESM0secondGain)")
//                print("average Gain: \(ESM0_averageGain)")
//            } else if ESM0delta < 0.05 && ESM0delta > -0.05 {
//                ESM0_averageGain = ESM0avg
//                print("SecondGain: \(ESM0firstGain)")
//                print("SecondGain: \(ESM0secondGain)")
//                print("average Gain: \(ESM0_averageGain)")
//            } else {
//                ESM0_averageGain = ESM0avg
//                print("SecondGain: \(ESM0firstGain)")
//                print("SecondGain: \(ESM0secondGain)")
//                print("average Gain: \(ESM0_averageGain)")
//            }
//        } else if ESM0secondHeardIsTrue == false {
//            print("Contine, second hear is true = false")
//        } else {
//            print("Critical error in reversalsCompletLogging Logic")
//        }
//    }
//
    private func ESM0restartPresentation() async {
        if ESM0endTestSeriesValue == false && ESM0userPausedTest == false && earSimulatorM1Cycle == true {
            ESM0localPlaying = 1
            ESM0endTestSeriesValue = false
        } else if ESM0endTestSeriesValue == true && ESM0userPausedTest == true && earSimulatorM1Cycle == true {
            ESM0localPlaying = -1
            ESM0endTestSeriesValue = true
            ESM0showTestCompletionSheet = true
            ESM0playingStringColorIndex = 2
        }  else if earSimulatorM1Cycle == false { //ESM0endTestSeriesValue == true || ESM0userPausedTest == true || earSimulatorM1Cycle == false {
            ESM0localPlaying = -1
            ESM0endTestSeriesValue = true
            ESM0showTestCompletionSheet = true
            ESM0playingStringColorIndex = 2
        }
    }
//
//    private func ESM0wipeArrays() async {
//        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
//            ESM0_heardArray.removeAll()
//            ESM0_testCount.removeAll()
//            ESM0_reversalHeard.removeAll()
//            ESM0_reversalGain.removeAll()
//            ESM0_averageGain = Float()
//            ESM0_reversalDirection = Float()
//            ESM0localStartingNonHeardArraySet = false
//            ESM0firstHeardResponseIndex = Int()
//            ESM0firstHeardIsTrue = false
//            ESM0secondHeardResponseIndex = Int()
//            ESM0secondHeardIsTrue = false
//            ESM0localTestCount = 0
//            ESM0localReversalHeardLast = Int()
//            ESM0startTooHigh = 0
//            ESM0localSeriesNoResponses = Int()
//        })
//    }
//
//    private func startNextTestCycle() async {
//        await ESM0wipeArrays()
//        ESM0showTestCompletionSheet.toggle()
//        ESM0startTooHigh = 0
//        ESM0localMarkNewTestCycle = 0
//        ESM0localReversalEnd = 0
//        ESM0_index = ESM0_index + 1
//        ESM0_testGain = ESM0_testGain
//        ESM0endTestSeriesValue = false
//        ESM0showTestCompletionSheet = false
//        ESM0testIsPlaying = true
//        ESM0userPausedTest = false
//        ESM0playingStringColorIndex = 2
//        print(ESM0_SamplesCountArray[ESM0_index])
//        ESM0localPlaying = 1
//    }
//
//    private func ESM0newTestCycle() async {
//        if ESM0localMarkNewTestCycle == 1 && ESM0localReversalEnd == 1 && ESM0_index < ESM0_SamplesCountArray[ESM0_index] && ESM0endTestSeriesValue == false {
//            ESM0startTooHigh = 0
//            ESM0localMarkNewTestCycle = 0
//            ESM0localReversalEnd = 0
//            ESM0_index = ESM0_index + 1
//            ESM0_testGain = ESM0_testGain
//            ESM0endTestSeriesValue = false
//            await ESM0wipeArrays()
//        } else if ESM0localMarkNewTestCycle == 1 && ESM0localReversalEnd == 1 && ESM0_index == ESM0_SamplesCountArray[ESM0_index] && ESM0endTestSeriesValue == false {
//            ESM0endTestSeriesValue = true
//            ESM0fullTestCompleted = true
//            ESM0localPlaying = -1
//            ESM0_SamplesCountArrayIdx += 1
//            print("=============================")
//            print("!!!!! End of Test Series!!!!!!")
//            print("=============================")
//            if ESM0fullTestCompleted == true {
//                ESM0fullTestCompleted = true
//                ESM0endTestSeriesValue = true
//                ESM0localPlaying = -1
//                print("*****************************")
//                print("=============================")
//                print("^^^^^^End of Full Test Series^^^^^^")
//                print("=============================")
//                print("*****************************")
//            } else if ESM0fullTestCompleted == false {
//                ESM0fullTestCompleted = false
//                ESM0endTestSeriesValue = true
//                ESM0localPlaying = -1
//                ESM0_SamplesCountArrayIdx += 1
//            }
//        } else {
//            //                print("Reversal Limit Not Hit")
//        }
//    }
//
//    private func ESM0endTestSeries() async {
//        if ESM0endTestSeriesValue == false {
//            //Do Nothing and continue
//            print("end Test Series = \(ESM0endTestSeriesValue)")
//        } else if ESM0endTestSeriesValue == true {
//            ESM0showTestCompletionSheet = true
//            ESM0_eptaSamplesCount = ESM0_eptaSamplesCount + 1
//            await ESM0endTestSeriesStop()
//        }
//    }
//
//    private func ESM0endTestSeriesStop() async {
//        ESM0localPlaying = -1
//        ESM0stop()
//        ESM0userPausedTest = true
//        ESM0playingStringColorIndex = 2
//    }
//
//    func writeESM0ResultsToCSV() async {
//        let stringFinalESM0GainsArray = ESM0_reversalGain.map { String($0) }.joined(separator: ",")
//        let stringFinalESM0SamplesArray = ESM0_frequency.map { String($0) }.joined(separator: ",")
//         do {
//             let csvESM0Path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//             let csvESM0DocumentsDirectory = csvESM0Path
//             let csvESM0FilePath = csvESM0DocumentsDirectory.appendingPathComponent(inputESM0CSVName)
//             let writer = try CSVWriter(fileURL: csvESM0FilePath, append: false)
//             try writer.write(row: [stringFinalESM0GainsArray])
//             try writer.write(row: [stringFinalESM0SamplesArray])
//         } catch {
//             print("CVSWriter ESM0 Data Error or Error Finding File for ESM0 CSV \(error)")
//         }
//    }
}




extension EarSimulatorManual0View {
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }

}

struct EarSimulatorManual0View_Previews: PreviewProvider {
    static var previews: some View {
        EarSimulatorManual0View()
    }
}
