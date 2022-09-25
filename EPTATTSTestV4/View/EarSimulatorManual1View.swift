//
//  EarSimulatorManual1View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/22/22.
//

import SwiftUI
import AVFAudio
import AVFoundation
import AVKit
import CoreMedia
import Combine
import CodableCSV


struct SamplesESM1List: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}

struct EarSimulatorManual1View: View {
    
    @State private var samples = [SamplesESM1List]()
    
    @State private var samplesHighResStd = [
        SamplesESM1List(name: "Sample1"),
        SamplesESM1List(name: "Sample2"),
        SamplesESM1List(name: "Sample3"),
        SamplesESM1List(name: "Sample4"),
        SamplesESM1List(name: "Sample5"),
        SamplesESM1List(name: "Sample6"),
        SamplesESM1List(name: "Sample7"),
        SamplesESM1List(name: "Sample8"),
        SamplesESM1List(name: "Sample9"),
        SamplesESM1List(name: "Sample10"),
        SamplesESM1List(name: "Sample11"),
        SamplesESM1List(name: "Sample12"),
        SamplesESM1List(name: "Sample13"),
        SamplesESM1List(name: "Sample14"),
        SamplesESM1List(name: "Sample15"),
        SamplesESM1List(name: "Sample16")
    ]
    
    @State private var samplesHighResFaded = [
        SamplesESM1List(name: "FSample1"),
        SamplesESM1List(name: "FSample2"),
        SamplesESM1List(name: "FSample3"),
        SamplesESM1List(name: "FSample4"),
        SamplesESM1List(name: "FSample5"),
        SamplesESM1List(name: "FSample6"),
        SamplesESM1List(name: "FSample7"),
        SamplesESM1List(name: "FSample8"),
        SamplesESM1List(name: "FSample9"),
        SamplesESM1List(name: "FSample10"),
        SamplesESM1List(name: "FSample11"),
        SamplesESM1List(name: "FSample12"),
        SamplesESM1List(name: "FSample13"),
        SamplesESM1List(name: "FSample14"),
        SamplesESM1List(name: "FSample15"),
        SamplesESM1List(name: "FSample16")
    ]
    
    @State private var samplesCDDitheredFaded = [
        SamplesESM1List(name: "FDSample1"),
        SamplesESM1List(name: "FDSample2"),
        SamplesESM1List(name: "FDSample3"),
        SamplesESM1List(name: "FDSample4"),
        SamplesESM1List(name: "FDSample5"),
        SamplesESM1List(name: "FDSample6"),
        SamplesESM1List(name: "FDSample7"),
        SamplesESM1List(name: "FDSample8"),
        SamplesESM1List(name: "FDSample9"),
        SamplesESM1List(name: "FDSample10"),
        SamplesESM1List(name: "FDSample11"),
        SamplesESM1List(name: "FDSample12"),
        SamplesESM1List(name: "FDSample13"),
        SamplesESM1List(name: "FDSample14"),
        SamplesESM1List(name: "FDSample15"),
        SamplesESM1List(name: "FDSample16")
    ]
    
    
    @State private var sampleSelected = [Int]()
    @State private var sampleSelectionIndex = [Int]()
    @State private var sampleSelectedName = [String]()
    @State private var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var ESM1localHeard = 0
    @State private var ESM1localPlaying = Int()    // Playing = 1. Stopped = -1
    @State private var ESM1localReversal = Int()
    @State private var ESM1localReversalEnd = Int()
    @State private var ESM1localMarkNewTestCycle = Int()
    @State private var ESM1testPlayer: AVAudioPlayer?
    
    @State private var ESM1localTestCount = 0
    @State private var ESM1localStartingNonHeardArraySet: Bool = false
    @State private var ESM1localReversalHeardLast = Int()
    @State private var ESM1localSeriesNoResponses = Int()
    @State private var ESM1firstHeardResponseIndex = Int()
    @State private var ESM1firstHeardIsTrue: Bool = false
    @State private var ESM1secondHeardResponseIndex = Int()
    @State private var ESM1secondHeardIsTrue: Bool = false
    @State private var ESM1startTooHigh = 0
    @State private var ESM1firstGain = Float()
    @State private var ESM1secondGain = Float()
    @State private var ESM1endTestSeriesValue: Bool = false
    @State private var ESM1showTestCompletionSheet: Bool = false
    
    @State private var ESM1_samples: [String] = [String]()
    
    @State private var highResStdSamples: [String] =  ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8",
                                                       "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    
    @State private var highResFadedSamples: [String] =  ["FSample1", "FSample2", "FSample3", "FSample4", "FSample5", "FSample6", "FSample7", "FSample8",
                                                         "FSample9", "FSample10", "FSample11", "FSample12", "FSample13", "FSample14", "FSample15", "FSample16"]
    
    @State private var cdFadedDitheredSamples: [String] =  ["FDSample1", "FDSample2", "FDSample3", "FDSample4", "FDSample5", "FDSample6", "FDSample7", "FDSample8",
                                                            "FDSample9", "FDSample10", "FDSample11", "FDSample12", "FDSample13", "FDSample14", "FDSample15", "FDSample16"]
    
    @State private var ESM1_index: Int = 0
    @State private var ESM1_testGain: Float = 0
    @State private var ESM1_heardArray: [Int] = [Int]()
    @State private var ESM1_indexForTest = [Int]()
    @State private var ESM1_testCount: [Int] = [Int]()
    @State private var ESM1_pan: Float = Float()
    @State private var ESM1_testPan = [Float]()
    @State private var ESM1_testTestGain = [Float]()
    @State private var ESM1_frequency = [String]()
    @State private var ESM1_reversalHeard = [Int]()
    @State private var ESM1_reversalGain = [Float]()
    @State private var ESM1_reversalFrequency = [String]()
    @State private var ESM1_reversalDirection = Float()
    @State private var ESM1_reversalDirectionArray = [Float]()
    
    @State private var ESM1_averageGain = Float()
    
    @State private var ESM1_eptaSamplesCount = 1 //17
    @State private var ESM1_SamplesCountArray = [1, 1]
    @State private var ESM1_SamplesCountArrayIdx = 0
    
    @State private var ESM1_finalStoredIndex: [Int] = [Int]()
    @State private var ESM1_finalStoredTestPan: [Float] = [Float]()
    @State private var ESM1_finalStoredTestTestGain: [Float] = [Float]()
    @State private var ESM1_finalStoredFrequency: [String] = [String]()
    @State private var ESM1_finalStoredTestCount: [Int] = [Int]()
    @State private var ESM1_finalStoredHeardArray: [Int] = [Int]()
    @State private var ESM1_finalStoredReversalHeard: [Int] = [Int]()
    @State private var ESM1_finalStoredFirstGain: [Float] = [Float]()
    @State private var ESM1_finalStoredSecondGain: [Float] = [Float]()
    @State private var ESM1_finalStoredAverageGain: [Float] = [Float]()
    
    @State private var ESM1idxForTest = Int() // = ESM1_indexForTest.count
    @State private var ESM1idxForTestNet1 = Int() // = ESM1_indexForTest.count - 1
    @State private var ESM1idxTestCount = Int() // = ESM1_TestCount.count
    @State private var ESM1idxTestCountUpdated = Int() // = ESM1_TestCount.count + 1
    @State private var ESM1activeFrequency = String()
    @State private var ESM1idxHA = Int()    // idx = ESM1_heardArray.count
    @State private var ESM1idxReversalHeardCount = Int()
    @State private var ESM1idxHAZero = Int()    //  idxZero = idx - idx
    @State private var ESM1idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State private var ESM1isCountSame = Int()
    @State private var ESM1heardArrayIdxAfnet1 = Int()
    @State private var ESM1testIsPlaying: Bool = false
    @State private var ESM1playingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State private var ESM1playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State private var ESM1playingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    @State private var ESM1TappingColorIndex = 0
    @State private var ESM1TappingGesture: Bool = false
    
    @State private var ESM1playingStringColorIndex = 0
    @State private var ESM1userPausedTest: Bool = false
    
    @State private var ESM1TestCompleted: Bool = false
    
    @State private var ESM1fullTestCompleted: Bool = false
    @State private var ESM1fullTestCompletedHoldingArray: [Bool] = [false, false, true]
    @State private var ESM1TestStarted: Bool = false
    
    
    let inputESM1CSVName = "InputDetailedEarSimulatorM1ResultsCSV.csv"
    
    
    let earSimulatorM1heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM1arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM1audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var earSimulatorM1testPlayerlocalHeard = Int()
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
                    Button {
                        if changeSampleArray == true {
                            self.highResStandard = highResStandard
                            self.highResFaded = highResFaded
                            self.cdFadedDithered = cdFadedDithered
                            self.sampleArraySet = sampleArraySet
                        }
                        earSimulatorM1showTestCompletionSheet = true
                        ESM1stop()
                    } label: {
                        Text("\(ESM1activeFrequency)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                    Spacer()
                    Toggle(isOn: $earSimulatorM1Cycle) {
                        HStack{
                            Spacer()
                            Text("Cycle")
                            Spacer()
                        }
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(24)
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                if ESM1TestStarted == false {
                    Button {    // Start Button
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            ESM1localPlaying = 1
                            ESM1endTestSeriesValue = false
                            print("Start Button Clicked. Playing = \(ESM1localPlaying)")
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
                    .padding(.bottom, 20)
                } else if ESM1TestStarted == true {
                    HStack{
                        Spacer()
                        Button {    // Pause Button
                            ESM1localPlaying = 0
                            ESM1stop()
                            ESM1userPausedTest = true
                            ESM1playingStringColorIndex = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                                ESM1localPlaying = 0
                                ESM1stop()
                                ESM1userPausedTest = true
                                ESM1playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                                ESM1localPlaying = 0
                                ESM1stop()
                                ESM1userPausedTest = true
                                ESM1playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                                ESM1localPlaying = 0
                                ESM1stop()
                                ESM1userPausedTest = true
                                ESM1playingStringColorIndex = 1
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
                            ESM1_heardArray.removeAll()
                            ESM1pauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            ESM1localPlaying = 1
                            ESM1userPausedTest = false
                            ESM1playingStringColorIndex = 0
                        } label: {
                            Text("Restart")
                                .frame(width: 100, height: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                }
                //View System Volume and Reset Audio Session to View Updated System Volume (2 wide Hstack)
                HStack{
                    Spacer()
                    Button {
                        audioSessionModel.setAudioSession()
                        earSimulatorM1_volume = audioSessionModel.audioSession.outputVolume
                        //                    audioSessionModel.cancelAudioSession()
                    } label: {
                        Text("Check Volume: \(earSimulatorM1_volume)")
                    }
                    Spacer()
                }
                .frame(width: 300, height: 40, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                //View Current Gain
                HStack{
                    Spacer()
                    Text("Gain: \(ESM1_testGain)")
                    Spacer()
                    Text("Pan: \(ESM1_pan)")
                    Spacer()
                }
                .frame(width: 300, height: 30, alignment: .center)
                .foregroundColor(.white)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 10)
                
                HStack{
                    //Button For Gain Change of 0.1 (10% / 10 db?)
                    Spacer()
                    Button {
                        Task{
                            let newGain: Float = ESM1_testGain - 0.1
                            if newGain > 0.0 {
                                ESM1_testGain -= 0.1
                            } else if newGain == 0.0 {
                                ESM1_testGain -= 0.1
                            } else {
                                ESM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Gain: 0.1")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain + 0.1
                            if newGain < 1.0 {
                                ESM1_testGain += 0.1
                            } else if newGain == 1.0 {
                                ESM1_testGain += 0.1
                            } else {
                                ESM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
                HStack{     // Button for gain Change of 0.05 (5% / 5 db?)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain - 0.05
                            if newGain > 0.0 {
                                ESM1_testGain -= 0.05
                            } else if newGain == 0.0 {
                                ESM1_testGain -= 0.05
                            } else {
                                ESM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Gain: 0.05")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain + 0.05
                            if newGain < 1.0 {
                                ESM1_testGain += 0.05
                            } else if newGain == 1.0 {
                                ESM1_testGain += 0.05
                            } else {
                                ESM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
                HStack{ // Button for gain change of 0.01 (1% / 1db)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain - 0.01
                            if newGain > 0.0 {
                                ESM1_testGain -= 0.01
                            } else if newGain == 0.0 {
                                ESM1_testGain -= 0.01
                            } else {
                                ESM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("Gain: 0.01")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain + 0.01
                            if newGain < 1.0 {
                                ESM1_testGain += 0.01
                            } else if newGain == 1.0 {
                                ESM1_testGain += 0.01
                            } else {
                                ESM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
                HStack{     // Button for gain change of 0.001 (0.1% 0.1dB?)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain - 0.001
                            if newGain > 0.0 {
                                ESM1_testGain -= 0.001
                            } else if newGain == 0.0 {
                                ESM1_testGain -= 0.001
                            } else {
                                ESM1_testGain = 0.0
                            }
                        }
                    } label: {
                        VStack{
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                    Text("Gain: 0.001")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = ESM1_testGain + 0.001
                            if newGain < 1.0 {
                                ESM1_testGain += 0.001
                            } else if newGain == 1.0 {
                                ESM1_testGain += 0.001
                            } else {
                                ESM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
            
                HStack{
                    Spacer()
                    Button {    // Left Pan
                        ESM1_pan = -1.0
                    } label: {
                        Text("Left Pan")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button {    // Middle Pan
                        ESM1_pan = 0.0
                    } label: {
                        Text("Middle Pan")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Button {    // Right Pan
                        ESM1_pan = 1.0
                    } label: {
                        Text("Right Pan")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 380, height: 50, alignment: .center)
                .font(.caption)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 40)
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
                                            ESM1activeFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM1activeFrequency: \(ESM1activeFrequency)")
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
                        Spacer()
                        HStack{
                            Spacer()
                            Button("Dismiss and Start") {
                                ESM1_samples.removeAll()
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
            .onChange(of: ESM1testIsPlaying, perform: { ESM1testBoolValue in
                if ESM1testBoolValue == true && ESM1endTestSeriesValue == false {
                    //User is starting test for first time
                    audioSessionModel.setAudioSession()
                    ESM1localPlaying = 1
                    ESM1playingStringColorIndex = 0
                    ESM1userPausedTest = false
                } else if ESM1testBoolValue == false && ESM1endTestSeriesValue == false {
                    // User is pausing test for firts time
                    ESM1stop()
                    ESM1localPlaying = 0
                    ESM1playingStringColorIndex = 1
                    ESM1userPausedTest = true
                } else if ESM1testBoolValue == true && ESM1endTestSeriesValue == true {
                    ESM1stop()
                    ESM1localPlaying = -1
                    ESM1playingStringColorIndex = 2
                    ESM1userPausedTest = true
                } else {
                    print("Critical error in pause logic")
                }
            })
            .onChange(of: ESM1localPlaying) { ESM1playingValue in
//                //Change This To Picker Frequency Selection   //earSimulatorM1activeFrequency is keyed into formula
//                earSimulatorM1activeFrequency = earSimulatorM1activeFrequency
//                // GAIN SETTING Bound to Gain Change Buttons
//                earSimulatorM1_testGain = earSimulatorM1_testGain
//                // Pan Setting // earSimulatorM1_pan is bound to play function
//                earSimulatorM1_pan = earSimulatorM1_pan
                ESM1_samples.append(ESM1activeFrequency)
                ESM1localHeard = 0
                ESM1localReversal = 0
                newactiveFrequency = ESM1_samples[ESM1_index]
                ESM1TestStarted = true
                if ESM1playingValue == 1{
                    //Play Sample
                    
                    if qualityOfService == 1 {
                        print("QOS Thread Background")
                        earSimulatorM1ThreadBackground.async {
                            ESM1loadAndTestPresentation(sample: ESM1activeFrequency, gain: ESM1_testGain, pan: ESM1_pan)
                            while ESM1testPlayer!.isPlaying == true && self.ESM1localHeard == 0 { }
                            if ESM1localHeard == 1 {
                                ESM1testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM1localHeard)")
                            } else {
                                ESM1testPlayer!.stop()
                                self.ESM1localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM1localHeard)")
                            }
                        }
                    } else if qualityOfService == 2 {
                        print("QOS Thread Default")
                        earSimulatorM1ThreadDefault.async {
                            ESM1loadAndTestPresentation(sample: ESM1activeFrequency, gain: ESM1_testGain, pan: ESM1_pan)
                            while ESM1testPlayer!.isPlaying == true && self.ESM1localHeard == 0 { }
                            if ESM1localHeard == 1 {
                                ESM1testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM1localHeard)")
                            } else {
                                ESM1testPlayer!.stop()
                                self.ESM1localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM1localHeard)")
                            }
                        }
                    } else if qualityOfService == 3 {
                        print("QOS Thread UserInteractive")
                        earSimulatorM1ThreadUserInteractive.async {
                            ESM1loadAndTestPresentation(sample: ESM1activeFrequency, gain: ESM1_testGain, pan: ESM1_pan)
                            while ESM1testPlayer!.isPlaying == true && self.ESM1localHeard == 0 { }
                            if ESM1localHeard == 1 {
                                ESM1testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM1localHeard)")
                            } else {
                                ESM1testPlayer!.stop()
                                self.ESM1localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM1localHeard)")
                            }
                        }
                    } else if qualityOfService == 4 {
                        print("QOS Thread UserInitiated")
                        earSimulatorM1ThreadUserInitiated.async {
                            ESM1loadAndTestPresentation(sample: ESM1activeFrequency, gain: ESM1_testGain, pan: ESM1_pan)
                            while ESM1testPlayer!.isPlaying == true && self.ESM1localHeard == 0 { }
                            if ESM1localHeard == 1 {
                                ESM1testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM1localHeard)")
                            } else {
                                ESM1testPlayer!.stop()
                                self.ESM1localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM1localHeard)")
                            }
                        }
                    } else {
                        print("QOS Thread Not Set, Catch Setting of Default")
                        earSimulatorM1audioThread.async {
                            ESM1loadAndTestPresentation(sample: ESM1activeFrequency, gain: ESM1_testGain, pan: ESM1_pan)
                            while ESM1testPlayer!.isPlaying == true && self.ESM1localHeard == 0 { }
                            if ESM1localHeard == 1 {
                                ESM1testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM1localHeard)")
                            } else {
                                ESM1testPlayer!.stop()
                                self.ESM1localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM1localHeard)")
                            }
                        }
                    }
                    //Event Logging
                    earSimulatorM1preEventThread.async {
                        ESM1preEventLogging()
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                        ESM1localTestCount += 1
                        Task(priority: .userInitiated) {
                            await ESM1heardArrayNormalize()
                            await ESM1count()
                            await ESM1logNotPlaying()
                            await ESM1resetPlaying()
                            await ESM1resetHeard()
//                            await ESM1nonResponseCounting()
                            await ESM1createReversalHeardArray()
                            await ESM1createReversalSampleArray()
//                            await createReversalGainArrayNonResponse()
//                            await ESM1checkHeardReversalArrays()
                            await ESM1reversalStart()
                        }
                    }
                }
            }
            // end of first .onChange of
            .onChange(of: ESM1localReversal) { ESM1reversalValue in
                if ESM1reversalValue == 1 {
                    DispatchQueue.global(qos: .background).async {
                        Task(priority: .userInitiated) {
//                            await ESM1reversalDirection()
//                            await ESM1reversalComplexAction()
//                            await ESM1reversalsCompleteLogging()
//                            await ESM1endTestSeries()
//                            await ESM1newTestCycle()
                            await writeESM1ResultsToCSV()
                            await ESM1restartPresentation()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual1View {
    enum ESM1SampleErrors: Error {
        case ESM1notFound
        case earSimulatorM1lastUnexpected(code: Int)
    }

    private func ESM1pauseRestartTestCycle() {
        ESM1localMarkNewTestCycle = 0
        ESM1localReversalEnd = 0
        ESM1_index = 0
        ESM1_samples.removeAll()
        ESM1_samples.append(ESM1activeFrequency)
        newactiveFrequency = ESM1_samples[ESM1_index]
        ESM1_testGain = ESM1_testGain
        ESM1testIsPlaying = false
        ESM1localPlaying = 0
        ESM1_testCount.removeAll()
        ESM1_reversalHeard.removeAll()
        ESM1_averageGain = Float()
        ESM1_reversalDirection = Float()
        ESM1localStartingNonHeardArraySet = false
        ESM1firstHeardResponseIndex = Int()
        ESM1firstHeardIsTrue = false
        ESM1secondHeardResponseIndex = Int()
        ESM1secondHeardIsTrue = false
        ESM1localTestCount = 0
        ESM1localReversalHeardLast = Int()
        ESM1startTooHigh = 0
    }
    
    private func ESM1loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
            do{
                let ESM1urlSample = Bundle.main.path(forResource: newactiveFrequency, ofType: ".wav")
                guard let ESM1urlSample = ESM1urlSample else { return print(ESM1SampleErrors.ESM1notFound) }
                ESM1testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM1urlSample))
                guard let ESM1testPlayer = ESM1testPlayer else { return }
                ESM1testPlayer.prepareToPlay()    // Test Player Prepare to Play
                ESM1testPlayer.setVolume(ESM1_testGain, fadeDuration: 0)      // Set Gain for Playback
                ESM1testPlayer.pan = ESM1_pan
                ESM1testPlayer.play()   // Start Playback
            } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    private func ESM1stop() {
      do{
          let ESM1urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let ESM1urlSample = ESM1urlSample else { return print(ESM1SampleErrors.ESM1notFound) }
          ESM1testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM1urlSample))
          guard let ESM1testPlayer = ESM1testPlayer else { return }
          ESM1testPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    private func ESM1resetNonResponseCount() async {ESM1localSeriesNoResponses = 0 }
    
    private func ESM1nonResponseCounting() async {ESM1localSeriesNoResponses += 1 }
     
    private func ESM1resetPlaying() async { self.ESM1localPlaying = 0 }
    
    private func ESM1logNotPlaying() async { self.ESM1localPlaying = -1 }
    
    private func ESM1resetHeard() async { self.ESM1localHeard = 0 }
    
    private func ESM1reversalStart() async { self.ESM1localReversal = 1}
  
    private func ESM1preEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
            ESM1_indexForTest.append(ESM1_index)
        }
        DispatchQueue.global(qos: .default).async {
            ESM1_testTestGain.append(ESM1_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            ESM1_frequency.append(ESM1activeFrequency)
            ESM1_testPan.append(ESM1_pan)
        }
    }
    
    private func ESM1responseHeardArray() async {
        ESM1_heardArray.append(1)
        self.ESM1idxHA = ESM1_heardArray.count
        self.ESM1localStartingNonHeardArraySet = true
    }

    private func ESM1localResponseTracking() async {
        if ESM1firstHeardIsTrue == false {
            ESM1firstHeardResponseIndex = ESM1localTestCount
            ESM1firstHeardIsTrue = true
        } else if ESM1firstHeardIsTrue == true {
            ESM1secondHeardResponseIndex = ESM1localTestCount
            ESM1secondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
    private func ESM1heardArrayNormalize() async {
        ESM1idxHA = ESM1_heardArray.count
        ESM1idxForTest = ESM1_indexForTest.count
        ESM1idxForTestNet1 = ESM1idxForTest - 1
        ESM1isCountSame = ESM1idxHA - ESM1idxForTest
        ESM1heardArrayIdxAfnet1 = ESM1_heardArray.index(after: ESM1idxForTestNet1)
        
        if ESM1localStartingNonHeardArraySet == false {
            ESM1_heardArray.append(0)
            self.ESM1localStartingNonHeardArraySet = true
            ESM1idxHA = ESM1_heardArray.count
            ESM1idxHAZero = ESM1idxHA - ESM1idxHA
            ESM1idxHAFirst = ESM1idxHAZero + 1
            ESM1isCountSame = ESM1idxHA - ESM1idxForTest
            ESM1heardArrayIdxAfnet1 = ESM1_heardArray.index(after: ESM1idxForTestNet1)
            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
    }
    
    private func ESM1count() async {
        ESM1idxTestCountUpdated = ESM1_testCount.count + 1
        ESM1_testCount.append(ESM1idxTestCountUpdated)
    }
}


extension EarSimulatorManual1View {
//MARK: -Extension Methods Reversals
    
    private func ESM1createReversalHeardArray() async {
        ESM1_reversalHeard.append(ESM1_heardArray[ESM1idxHA-1])
        self.ESM1idxReversalHeardCount = ESM1_reversalHeard.count
    }
    
    private func ESM1createReversalGainArray() async {
        ESM1_reversalGain.append(ESM1_testGain)
    }
    
    private func ESM1createReversalSampleArray() async {
        ESM1_frequency.append(newactiveFrequency)
    }
    
    private func createReversalGainArrayNonResponse() async {
        if ESM1_testGain < 0.995 {
            ESM1_reversalGain.append(ESM1_testGain)
        } else if ESM1_testGain >= 0.995 {
            ESM1_reversalGain.append(1.0)
        }
    }
    
    private func ESM1checkHeardReversalArrays() async {
        if ESM1idxHA - ESM1idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if ESM1idxHA - ESM1idxReversalHeardCount < 0 && ESM1idxHA - ESM1idxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    private func ESM1reversalDirection() async {
        ESM1localReversalHeardLast = ESM1_reversalHeard.last ?? -999
        if ESM1localReversalHeardLast == 1 {
            ESM1_reversalDirection = -1.0
            ESM1_reversalDirectionArray.append(-1.0)
        } else if ESM1localReversalHeardLast == 0 {
            ESM1_reversalDirection = 1.0
            ESM1_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    private func ESM1reversalOfOne() async {
        let ESM1rO1Direction = 0.01 * ESM1_reversalDirection
        let ESM1r01NewGain = ESM1_testGain + ESM1rO1Direction
        if ESM1r01NewGain > 0.00001 && ESM1r01NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r01NewGain * 100000) / 100000
        } else if ESM1r01NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r01NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    private func ESM1reversalOfTwo() async {
        let ESM1rO2Direction = 0.02 * ESM1_reversalDirection
        let ESM1r02NewGain = ESM1_testGain + ESM1rO2Direction
        if ESM1r02NewGain > 0.00001 && ESM1r02NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r02NewGain * 100000) / 100000
        } else if ESM1r02NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r02NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    private func ESM1reversalOfThree() async {
        let ESM1rO3Direction = 0.03 * ESM1_reversalDirection
        let ESM1r03NewGain = ESM1_testGain + ESM1rO3Direction
        if ESM1r03NewGain > 0.00001 && ESM1r03NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r03NewGain * 100000) / 100000
        } else if ESM1r03NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r03NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    private func ESM1reversalOfFour() async {
        let ESM1rO4Direction = 0.04 * ESM1_reversalDirection
        let ESM1r04NewGain = ESM1_testGain + ESM1rO4Direction
        if ESM1r04NewGain > 0.00001 && ESM1r04NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r04NewGain * 100000) / 100000
        } else if ESM1r04NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r04NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    private func ESM1reversalOfFive() async {
        let ESM1rO5Direction = 0.05 * ESM1_reversalDirection
        let ESM1r05NewGain = ESM1_testGain + ESM1rO5Direction
        if ESM1r05NewGain > 0.00001 && ESM1r05NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r05NewGain * 100000) / 100000
        } else if ESM1r05NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r05NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    private func ESM1reversalOfTen() async {
        let ESM1r10Direction = 0.10 * ESM1_reversalDirection
        let ESM1r10NewGain = ESM1_testGain + ESM1r10Direction
        if ESM1r10NewGain > 0.00001 && ESM1r10NewGain < 1.0 {
            ESM1_testGain = roundf(ESM1r10NewGain * 100000) / 100000
        } else if ESM1r10NewGain <= 0.0 {
            ESM1_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if ESM1r10NewGain >= 0.995 {
            ESM1_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    private func ESM1reversalAction() async {
        if ESM1localReversalHeardLast == 1 {
            await ESM1reversalOfFive()
        } else if ESM1localReversalHeardLast == 0 {
            await ESM1reversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    private func ESM1reversalComplexAction() async {
        if ESM1idxReversalHeardCount <= 1 && ESM1idxHA <= 1 {
            await ESM1reversalAction()
        }  else if ESM1idxReversalHeardCount == 2 {
            if ESM1idxReversalHeardCount == 2 && ESM1secondHeardIsTrue == true {
                await ESM1startTooHighCheck()
            } else if ESM1idxReversalHeardCount == 2  && ESM1secondHeardIsTrue == false {
                await ESM1reversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if ESM1idxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if ESM1secondHeardResponseIndex - ESM1firstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if ESM1localSeriesNoResponses == 3 {
                await ESM1reversalOfTen()
            } else if ESM1localSeriesNoResponses == 2 {
                await ESM1reversalOfFour()
            } else {
                await ESM1reversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    private func ESM1reversalHeardCount1() async {
        await ESM1reversalAction()
    }
    
    private func ESM1check2PositiveSeriesReversals() async {
        if ESM1_reversalHeard[ESM1idxHA-2] == 1 && ESM1_reversalHeard[ESM1idxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }
    
    private func ESM1checkTwoNegativeSeriesReversals() async {
        if ESM1_reversalHeard.count >= 3 && ESM1_reversalHeard[ESM1idxHA-2] == 0 && ESM1_reversalHeard[ESM1idxHA-1] == 0 {
            await ESM1reversalOfFour()
        } else {
            await ESM1reversalAction()
        }
    }
    
    private func ESM1startTooHighCheck() async {
        if ESM1startTooHigh == 0 && ESM1firstHeardIsTrue == true && ESM1secondHeardIsTrue == true {
            ESM1startTooHigh = 1
            await ESM1reversalOfTen()
            await ESM1resetAfterTooHigh()
            print("Too High Found")
        } else {
            await ESM1reversalAction()
        }
    }
    
    private func ESM1resetAfterTooHigh() async {
        ESM1firstHeardResponseIndex = Int()
        ESM1firstHeardIsTrue = false
        ESM1secondHeardResponseIndex = Int()
        ESM1secondHeardIsTrue = false
    }
    
    private func ESM1reversalsCompleteLogging() async {
        if ESM1secondHeardIsTrue == true {
            self.ESM1localReversalEnd = 1
            self.ESM1localMarkNewTestCycle = 1
            self.ESM1firstGain = ESM1_reversalGain[ESM1firstHeardResponseIndex-1]
            self.ESM1secondGain = ESM1_reversalGain[ESM1secondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
            let ESM1delta = ESM1firstGain - ESM1secondGain
            let ESM1avg = (ESM1firstGain + ESM1secondGain)/2
            if ESM1delta == 0 {
                ESM1_averageGain = ESM1secondGain
                print("average Gain: \(ESM1_averageGain)")
            } else if ESM1delta >= 0.05 {
                ESM1_averageGain = ESM1secondGain
                print("SecondGain: \(ESM1firstGain)")
                print("SecondGain: \(ESM1secondGain)")
                print("average Gain: \(ESM1_averageGain)")
            } else if ESM1delta <= -0.05 {
                ESM1_averageGain = ESM1firstGain
                print("SecondGain: \(ESM1firstGain)")
                print("SecondGain: \(ESM1secondGain)")
                print("average Gain: \(ESM1_averageGain)")
            } else if ESM1delta < 0.05 && ESM1delta > -0.05 {
                ESM1_averageGain = ESM1avg
                print("SecondGain: \(ESM1firstGain)")
                print("SecondGain: \(ESM1secondGain)")
                print("average Gain: \(ESM1_averageGain)")
            } else {
                ESM1_averageGain = ESM1avg
                print("SecondGain: \(ESM1firstGain)")
                print("SecondGain: \(ESM1secondGain)")
                print("average Gain: \(ESM1_averageGain)")
            }
        } else if ESM1secondHeardIsTrue == false {
            print("Contine, second hear is true = false")
        } else {
            print("Critical error in reversalsCompletLogging Logic")
        }
    }
    
    private func ESM1restartPresentation() async {
        if ESM1endTestSeriesValue == false && ESM1userPausedTest == false && earSimulatorM1Cycle == true {
            ESM1localPlaying = 1
            ESM1endTestSeriesValue = false
        } else if ESM1endTestSeriesValue == true && ESM1userPausedTest == true && earSimulatorM1Cycle == true {
            ESM1localPlaying = -1
            ESM1endTestSeriesValue = true
            ESM1showTestCompletionSheet = true
            ESM1playingStringColorIndex = 2
        }  else if earSimulatorM1Cycle == false { //ESM1endTestSeriesValue == true || ESM1userPausedTest == true || earSimulatorM1Cycle == false {
            ESM1localPlaying = -1
            ESM1endTestSeriesValue = true
            ESM1showTestCompletionSheet = true
            ESM1playingStringColorIndex = 2
        }
    }
    
    private func ESM1wipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            ESM1_heardArray.removeAll()
            ESM1_testCount.removeAll()
            ESM1_reversalHeard.removeAll()
            ESM1_reversalGain.removeAll()
            ESM1_averageGain = Float()
            ESM1_reversalDirection = Float()
            ESM1localStartingNonHeardArraySet = false
            ESM1firstHeardResponseIndex = Int()
            ESM1firstHeardIsTrue = false
            ESM1secondHeardResponseIndex = Int()
            ESM1secondHeardIsTrue = false
            ESM1localTestCount = 0
            ESM1localReversalHeardLast = Int()
            ESM1startTooHigh = 0
            ESM1localSeriesNoResponses = Int()
        })
    }
    
    private func startNextTestCycle() async {
        await ESM1wipeArrays()
        ESM1showTestCompletionSheet.toggle()
        ESM1startTooHigh = 0
        ESM1localMarkNewTestCycle = 0
        ESM1localReversalEnd = 0
        ESM1_index = ESM1_index + 1
        ESM1_testGain = ESM1_testGain
        ESM1endTestSeriesValue = false
        ESM1showTestCompletionSheet = false
        ESM1testIsPlaying = true
        ESM1userPausedTest = false
        ESM1playingStringColorIndex = 2
        print(ESM1_SamplesCountArray[ESM1_index])
        ESM1localPlaying = 1
    }
    
    private func ESM1newTestCycle() async {
        if ESM1localMarkNewTestCycle == 1 && ESM1localReversalEnd == 1 && ESM1_index < ESM1_SamplesCountArray[ESM1_index] && ESM1endTestSeriesValue == false {
            ESM1startTooHigh = 0
            ESM1localMarkNewTestCycle = 0
            ESM1localReversalEnd = 0
            ESM1_index = ESM1_index + 1
            ESM1_testGain = ESM1_testGain
            ESM1endTestSeriesValue = false
            await ESM1wipeArrays()
        } else if ESM1localMarkNewTestCycle == 1 && ESM1localReversalEnd == 1 && ESM1_index == ESM1_SamplesCountArray[ESM1_index] && ESM1endTestSeriesValue == false {
            ESM1endTestSeriesValue = true
            ESM1fullTestCompleted = true
            ESM1localPlaying = -1
            ESM1_SamplesCountArrayIdx += 1
            print("=============================")
            print("!!!!! End of Test Series!!!!!!")
            print("=============================")
            if ESM1fullTestCompleted == true {
                ESM1fullTestCompleted = true
                ESM1endTestSeriesValue = true
                ESM1localPlaying = -1
                print("*****************************")
                print("=============================")
                print("^^^^^^End of Full Test Series^^^^^^")
                print("=============================")
                print("*****************************")
            } else if ESM1fullTestCompleted == false {
                ESM1fullTestCompleted = false
                ESM1endTestSeriesValue = true
                ESM1localPlaying = -1
                ESM1_SamplesCountArrayIdx += 1
            }
        } else {
            //                print("Reversal Limit Not Hit")
        }
    }
    
    private func ESM1endTestSeries() async {
        if ESM1endTestSeriesValue == false {
            //Do Nothing and continue
            print("end Test Series = \(ESM1endTestSeriesValue)")
        } else if ESM1endTestSeriesValue == true {
            ESM1showTestCompletionSheet = true
            ESM1_eptaSamplesCount = ESM1_eptaSamplesCount + 1
            await ESM1endTestSeriesStop()
        }
    }
    
    private func ESM1endTestSeriesStop() async {
        ESM1localPlaying = -1
        ESM1stop()
        ESM1userPausedTest = true
        ESM1playingStringColorIndex = 2
    }
    
    func writeESM1ResultsToCSV() async {
        let stringFinalESM1GainsArray = ESM1_reversalGain.map { String($0) }.joined(separator: ",")
        let stringFinalESM1SamplesArray = ESM1_frequency.map { String($0) }.joined(separator: ",")
         do {
             let csvESM1Path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvESM1DocumentsDirectory = csvESM1Path
             let csvESM1FilePath = csvESM1DocumentsDirectory.appendingPathComponent(inputESM1CSVName)
             let writer = try CSVWriter(fileURL: csvESM1FilePath, append: false)
             try writer.write(row: [stringFinalESM1GainsArray])
             try writer.write(row: [stringFinalESM1SamplesArray])
         } catch {
             print("CVSWriter ESM1 Data Error or Error Finding File for ESM1 CSV \(error)")
         }
    }
}


extension EarSimulatorManual1View {
//    private func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }

}

//struct EarSimulatorManual1View_Previews: PreviewProvider {
//    static var previews: some View {
//        EarSimulatorManual1View()
//    }
//}
