//
//  EarSimulatorManual2View.swift
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


struct SamplesESM2List: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}


struct EarSimulatorManual2View: View {
    
    @State private var samples = [
        SamplesESM2List(name: "Sample1"),
        SamplesESM2List(name: "Sample2"),
        SamplesESM2List(name: "Sample3"),
        SamplesESM2List(name: "Sample4"),
        SamplesESM2List(name: "Sample5"),
        SamplesESM2List(name: "Sample6"),
        SamplesESM2List(name: "Sample7"),
        SamplesESM2List(name: "Sample8"),
        SamplesESM2List(name: "Sample9"),
        SamplesESM2List(name: "Sample10"),
        SamplesESM2List(name: "Sample11"),
        SamplesESM2List(name: "Sample12"),
        SamplesESM2List(name: "Sample13"),
        SamplesESM2List(name: "Sample14"),
        SamplesESM2List(name: "Sample15"),
        SamplesESM2List(name: "Sample16")
    ]
    
    @State private var sampleSelected = [Int]()
    @State private var sampleSelectionIndex = [Int]()
    @State private var sampleSelectedName = [String]()
    @State private var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var ESM2localHeard = 0
    @State private var ESM2localPlaying = Int()    // Playing = 1. Stopped = -1
    @State private var ESM2localReversal = Int()
    @State private var ESM2localReversalEnd = Int()
    @State private var ESM2localMarkNewTestCycle = Int()
    @State private var ESM2testPlayer: AVAudioPlayer?
    
    @State private var ESM2localTestCount = 0
    @State private var ESM2localStartingNonHeardArraySet: Bool = false
    @State private var ESM2localReversalHeardLast = Int()
    @State private var ESM2localSeriesNoResponses = Int()
    @State private var ESM2firstHeardResponseIndex = Int()
    @State private var ESM2firstHeardIsTrue: Bool = false
    @State private var ESM2secondHeardResponseIndex = Int()
    @State private var ESM2secondHeardIsTrue: Bool = false
    @State private var ESM2startTooHigh = 0
    @State private var ESM2firstGain = Float()
    @State private var ESM2secondGain = Float()
    @State private var ESM2endTestSeriesValue: Bool = false
    @State private var ESM2showTestCompletionSheet: Bool = false
    
    @State private var ESM2_samples: [String] = ["Sample0", "Sample1"]
    @State private var ESM2_index: Int = 0
    @State private var ESM2_testGain: Float = 0
    @State private var ESM2_heardArray: [Int] = [Int]()
    @State private var ESM2_indexForTest = [Int]()
    @State private var ESM2_testCount: [Int] = [Int]()
    @State private var ESM2_pan: Float = Float()
    @State private var ESM2_testPan = [Float]()
    @State private var ESM2_testTestGain = [Float]()
    @State private var ESM2_frequency = [String]()
    @State private var ESM2_reversalHeard = [Int]()
    @State private var ESM2_reversalGain = [Float]()
    @State private var ESM2_reversalFrequency = [String]()
 
    @State private var ESM2_reversalDirectionArray = [Float]()
    
    @State private var ESM2_averageGain = Float()
    
    @State private var ESM2_eptaSamplesCount = 1 //17
    @State private var ESM2_SamplesCountArray = [1, 1]
    @State private var ESM2_SamplesCountArrayIdx = 0
    
    @State private var ESM2_finalStoredIndex: [Int] = [Int]()
    @State private var ESM2_finalStoredTestPan: [Float] = [Float]()
    @State private var ESM2_finalStoredTestTestGain: [Float] = [Float]()
    @State private var ESM2_finalStoredFrequency: [String] = [String]()
    @State private var ESM2_finalStoredTestCount: [Int] = [Int]()
    @State private var ESM2_finalStoredHeardArray: [Int] = [Int]()
    @State private var ESM2_finalStoredReversalHeard: [Int] = [Int]()
    @State private var ESM2_finalStoredFirstGain: [Float] = [Float]()
    @State private var ESM2_finalStoredSecondGain: [Float] = [Float]()
    @State private var ESM2_finalStoredAverageGain: [Float] = [Float]()
    
    @State private var ESM2idxForTest = Int() // = ESM2_indexForTest.count
    @State private var ESM2idxForTestNet1 = Int() // = ESM2_indexForTest.count - 1
    @State private var ESM2idxTestCount = Int() // = ESM2_TestCount.count
    @State private var ESM2idxTestCountUpdated = Int() // = ESM2_TestCount.count + 1
    @State private var ESM2activeFrequency = String()
    @State private var ESM2idxHA = Int()    // idx = ESM2_heardArray.count
    @State private var ESM2idxReversalHeardCount = Int()
    @State private var ESM2idxHAZero = Int()    //  idxZero = idx - idx
    @State private var ESM2idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State private var ESM2isCountSame = Int()
    @State private var ESM2heardArrayIdxAfnet1 = Int()
    @State private var ESM2testIsPlaying: Bool = false
    @State private var ESM2playingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State private var ESM2playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State private var ESM2playingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    @State private var ESM2TappingColorIndex = 0
    @State private var ESM2TappingGesture: Bool = false
    
    @State private var ESM2playingStringColorIndex = 0
    @State private var ESM2userPausedTest: Bool = false
    
    @State private var ESM2TestCompleted: Bool = false
    
    @State private var ESM2fullTestCompleted: Bool = false
    @State private var ESM2fullTestCompletedHoldingArray: [Bool] = [false, false, true]
    @State private var ESM2TestStarted: Bool = false
    
    
    let inputESM2CSVName = "InputDetailedEarSimulatorM2ResultsCSV.csv"
    
    
    let earSimulatorM2heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM2arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM2audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM2preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var earSimulatorM2testPlayerlocalHeard = Int()
    @State private var earSimulatorM2_volume = Float()
    @State private var newactiveFrequency = String()
    @State private var earSimulatorM2Cycle: Bool = true
    
    
    @State private var reversalTenth: Bool = false
    @State private var reversalOne: Bool = false
    @State private var reversalFive: Bool = false
    @State private var reversalTen: Bool = false
    @State private var directionOfReversals: Bool = false
    @State private var ESM2_reversalDirection: Float = 1.0
    @State private var ESM2_Watcher: Int = 0
    
    @State private var earSimulatorM2showTestCompletionSheet: Bool = false
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
                    Button {
                        earSimulatorM2showTestCompletionSheet = true
                        ESM2stop()
                    } label: {
                        Text("\(ESM2activeFrequency)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                    Spacer()
                    Toggle(isOn: $directionOfReversals) {
                        HStack{
                            Spacer()
                            Text("Direction")
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
                if ESM2TestStarted == false {
                    Button {    // Start Button
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            ESM2localPlaying = 1
                            ESM2endTestSeriesValue = false
                            print("Start Button Clicked. Playing = \(ESM2localPlaying)")
                        }
                    } label: {
                        Text("Click to Start")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 200, height: 40, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                } else if ESM2TestStarted == true {
                    HStack{
                        Spacer()
                        Button {    // Pause Button
                            ESM2localPlaying = 0
                            ESM2stop()
                            ESM2userPausedTest = true
                            ESM2playingStringColorIndex = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                                ESM2localPlaying = 0
                                ESM2stop()
                                ESM2userPausedTest = true
                                ESM2playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                                ESM2localPlaying = 0
                                ESM2stop()
                                ESM2userPausedTest = true
                                ESM2playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                                ESM2localPlaying = 0
                                ESM2stop()
                                ESM2userPausedTest = true
                                ESM2playingStringColorIndex = 1
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
                            ESM2_heardArray.removeAll()
                            ESM2pauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            ESM2localPlaying = 1
                            ESM2userPausedTest = false
                            ESM2playingStringColorIndex = 0
                            earSimulatorM2Cycle = true
                            ESM2testIsPlaying = true
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
                        earSimulatorM2_volume = audioSessionModel.audioSession.outputVolume
                        //                    audioSessionModel.cancelAudioSession()
                    } label: {
                        Text("Volume: \(earSimulatorM2_volume)")
                    }
                    Spacer()
                }
                .frame(width: 300, height: 30, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    Text("Gain: \(ESM2_testGain)")
                    Spacer()
                }
                .frame(width: 300, height: 30, alignment: .center)
                .foregroundColor(.white)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 10)
                
                HStack{
                    Spacer()
                    Toggle(isOn: $reversalTenth) {
                        Text("Tenth")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Toggle(isOn: $reversalOne) {
                        Text("One")
                            .foregroundColor(.orange)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 20)
                
                HStack{
                    Spacer()
                    Toggle(isOn: $reversalFive) {
                        Text("Five")
                            .foregroundColor(.purple)
                    }
                    Spacer()
                    Toggle(isOn: $reversalTen) {
                        Text("Ten")
                            .foregroundColor(.cyan)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 20)
            
                HStack{
                    Spacer()
                    Button {    // Left Pan
                        ESM2_pan = -1.0
                    } label: {
                        Text("Left Pan")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button {    // Middle Pan
                        ESM2_pan = 0.0
                    } label: {
                        Text("Middle Pan")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Button {    // Right Pan
                        ESM2_pan = 1.0
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
                earSimulatorM2showTestCompletionSheet = true
                directionOfReversals = false
             })
            .fullScreenCover(isPresented: $earSimulatorM2showTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            earSimulatorM2showTestCompletionSheet.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.red)
                        })
                        List {
                            ForEach(samples.indices, id: \.self) { index in
                                HStack {
                                    Text("\(self.samples[index].name)")
                                        .foregroundColor(.blue)
                                    Toggle("", isOn: self.$samples[index].isToggledS)
                                        .foregroundColor(.blue)
                                        .onChange(of: self.samples[index].isToggledS) { nameIndex in
                                            sampleSelectionIndex.removeAll()
                                            sampleSelectedName.append(self.samples[index].name)
                                            sampleSelectedID.append(self.samples[index].id)
                                            sampleSelectionIndex.append(index)
                                            ESM2activeFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM2activeFrequency: \(ESM2activeFrequency)")
                                            print("index: \(index)")
                                        }
                                }
                            }
                        }
                        .onAppear {
                            sampleSelectionIndex.removeAll()
                            sampleSelectedName.removeAll()
                            sampleSelectedID.removeAll()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            Button("Dismiss and Start") {
                                ESM2_samples.removeAll()
                                earSimulatorM2showTestCompletionSheet.toggle()
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
            .onChange(of: ESM2testIsPlaying, perform: { ESM2testBoolValue in
                if ESM2testBoolValue == true && ESM2endTestSeriesValue == false {
                    //User is starting test for first time
                    audioSessionModel.setAudioSession()
                    ESM2localPlaying = 1
                    ESM2playingStringColorIndex = 0
                    ESM2userPausedTest = false
                } else if ESM2testBoolValue == false && ESM2endTestSeriesValue == false {
                    // User is pausing test for firts time
                    ESM2stop()
                    ESM2localPlaying = 0
                    ESM2playingStringColorIndex = 1
                    ESM2userPausedTest = true
                } else if ESM2testBoolValue == true && ESM2endTestSeriesValue == true {
                    ESM2stop()
                    ESM2localPlaying = -1
                    ESM2playingStringColorIndex = 2
                    ESM2userPausedTest = true
                } else {
                    print("Critical error in pause logic")
                }
            })
            .onChange(of: ESM2localPlaying) { ESM2playingValue in
                ESM2_samples.append(ESM2activeFrequency)
                ESM2localHeard = 0
                ESM2localReversal = 0
                newactiveFrequency = ESM2_samples[ESM2_index]
                ESM2TestStarted = true
                if ESM2playingValue == 1{
                    earSimulatorM2audioThread.async {
                        ESM2loadAndTestPresentation(sample: ESM2activeFrequency, gain: ESM2_testGain, pan: ESM2_pan)
                        while ESM2testPlayer!.isPlaying == true && self.ESM2localHeard == 0 { }
                        if ESM2localHeard == 1 {
                            ESM2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ESM2localHeard)")
                        } else {
                            ESM2testPlayer!.stop()
                            self.ESM2localHeard = -1
                            print("Stopped naturally: Returned Array \(ESM2localHeard)")
                        }
                    }
                    earSimulatorM2preEventThread.async {
                        ESM2preEventLogging()
                    }
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                        ESM2localTestCount += 1
                        Task(priority: .userInitiated) {
                            await ESM2heardArrayNormalize()
                            await ESM2count()
                            await ESM2logNotPlaying()
                            await ESM2resetPlaying()
                            await ESM2resetHeard()
                            await ESM2createReversalHeardArray()
                            await ESM2createReversalSampleArray()
                            await ESM2reversalStart()
                        }
                    }
                }
            }
            // end of first .onChange of
            .onChange(of: ESM2localReversal) { ESM2reversalValue in
                if ESM2reversalValue == 1 {
                    DispatchQueue.global(qos: .background).async {
                        Task(priority: .userInitiated) {
                            await ESM2reversalDirection()
                            await ESM2reversalAction()
                            await writeESM2ResultsToCSV()
                            await watchGainToEnd()
                            await ESM2restartPresentation()
                            await ESM2endTestSeriesStop()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual2View {
    enum ESM2SampleErrors: Error {
        case ESM2notFound
        case earSimulatorM2lastUnexpected(code: Int)
    }

    private func ESM2pauseRestartTestCycle() {
        earSimulatorM2Cycle = true
        ESM2userPausedTest = false
        ESM2_Watcher = 0
        ESM2localMarkNewTestCycle = 0
        ESM2localReversalEnd = 0
        ESM2_index = 0
        ESM2_samples.removeAll()
        ESM2_samples.append(ESM2activeFrequency)
        newactiveFrequency = ESM2_samples[ESM2_index]
        ESM2_testGain = ESM2_testGain
        ESM2testIsPlaying = false
        ESM2localPlaying = 0
        ESM2_testCount.removeAll()
        ESM2_reversalHeard.removeAll()
        ESM2_averageGain = Float()
        ESM2_reversalDirection = Float()
        ESM2localStartingNonHeardArraySet = false
        ESM2firstHeardResponseIndex = Int()
        ESM2firstHeardIsTrue = false
        ESM2secondHeardResponseIndex = Int()
        ESM2secondHeardIsTrue = false
        ESM2localTestCount = 0
        ESM2localReversalHeardLast = Int()
        ESM2startTooHigh = 0
    }
    
    private func ESM2loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
        do{
            let ESM2urlSample = Bundle.main.path(forResource: newactiveFrequency, ofType: ".wav")
            guard let ESM2urlSample = ESM2urlSample else { return print(ESM2SampleErrors.ESM2notFound) }
            ESM2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM2urlSample))
            guard let ESM2testPlayer = ESM2testPlayer else { return }
            ESM2testPlayer.prepareToPlay()    // Test Player Prepare to Play
            ESM2testPlayer.setVolume(ESM2_testGain, fadeDuration: 0)      // Set Gain for Playback
            ESM2testPlayer.pan = ESM2_pan
            ESM2testPlayer.play()   // Start Playback
        } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    private func ESM2stop() {
      do{
          let ESM2urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let ESM2urlSample = ESM2urlSample else { return print(ESM2SampleErrors.ESM2notFound) }
          ESM2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM2urlSample))
          guard let ESM2testPlayer = ESM2testPlayer else { return }
          ESM2testPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    private func ESM2resetNonResponseCount() async {ESM2localSeriesNoResponses = 0 }
    
    private func ESM2nonResponseCounting() async {ESM2localSeriesNoResponses += 1 }
     
    private func ESM2resetPlaying() async { self.ESM2localPlaying = 0 }
    
    private func ESM2logNotPlaying() async { self.ESM2localPlaying = -1 }
    
    private func ESM2resetHeard() async { self.ESM2localHeard = 0 }
    
    private func ESM2reversalStart() async { self.ESM2localReversal = 1}
  
    private func ESM2preEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
            ESM2_indexForTest.append(ESM2_index)
        }
        DispatchQueue.global(qos: .default).async {
            ESM2_testTestGain.append(ESM2_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            ESM2_frequency.append(ESM2activeFrequency)
            ESM2_testPan.append(ESM2_pan)
        }
    }
    
    private func ESM2responseHeardArray() async {
        ESM2_heardArray.append(1)
        self.ESM2idxHA = ESM2_heardArray.count
        self.ESM2localStartingNonHeardArraySet = true
    }

    private func ESM2localResponseTracking() async {
        if ESM2firstHeardIsTrue == false {
            ESM2firstHeardResponseIndex = ESM2localTestCount
            ESM2firstHeardIsTrue = true
        } else if ESM2firstHeardIsTrue == true {
            ESM2secondHeardResponseIndex = ESM2localTestCount
            ESM2secondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
    private func ESM2heardArrayNormalize() async {
        ESM2idxHA = ESM2_heardArray.count
        ESM2idxForTest = ESM2_indexForTest.count
        ESM2idxForTestNet1 = ESM2idxForTest - 1
        ESM2isCountSame = ESM2idxHA - ESM2idxForTest
        ESM2heardArrayIdxAfnet1 = ESM2_heardArray.index(after: ESM2idxForTestNet1)
        
        if ESM2localStartingNonHeardArraySet == false {
            ESM2_heardArray.append(0)
            self.ESM2localStartingNonHeardArraySet = true
            ESM2idxHA = ESM2_heardArray.count
            ESM2idxHAZero = ESM2idxHA - ESM2idxHA
            ESM2idxHAFirst = ESM2idxHAZero + 1
            ESM2isCountSame = ESM2idxHA - ESM2idxForTest
            ESM2heardArrayIdxAfnet1 = ESM2_heardArray.index(after: ESM2idxForTestNet1)
            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
    }
    
    
    private func ESM2count() async {
        ESM2idxTestCountUpdated = ESM2_testCount.count + 1
        ESM2_testCount.append(ESM2idxTestCountUpdated)
    }
}


extension EarSimulatorManual2View {
//MARK: -Extension Methods Reversals
    
    private func ESM2createReversalHeardArray() async {
        ESM2_reversalHeard.append(ESM2_heardArray[ESM2idxHA-1])
        self.ESM2idxReversalHeardCount = ESM2_reversalHeard.count
    }
    
    private func ESM2createReversalGainArray() async {
        ESM2_reversalGain.append(ESM2_testGain)
    }
    
    private func ESM2createReversalSampleArray() async {
        ESM2_frequency.append(newactiveFrequency)
    }
    
    private func createReversalGainArrayNonResponse() async {
        if ESM2_testGain < 0.995 {
            ESM2_reversalGain.append(ESM2_testGain)
        } else if ESM2_testGain >= 0.995 {
            ESM2_reversalGain.append(1.0)
        }
    }
    
    private func ESM2checkHeardReversalArrays() async {
        if ESM2idxHA - ESM2idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if ESM2idxHA - ESM2idxReversalHeardCount < 0 && ESM2idxHA - ESM2idxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    private func ESM2reversalDirection() async {
        if directionOfReversals == false {
            ESM2_reversalDirection = 1.0
            print("ESM2_reversalDirection: \(ESM2_reversalDirection)")
        } else if directionOfReversals == true {
            ESM2_reversalDirection = -1.0
            print("ESM2_reversalDirection: \(ESM2_reversalDirection)")
        }
    }
    
    private func ESM2reversalOfTenth() async {
        let newGain: Float = ESM2_testGain + (0.001 * ESM2_reversalDirection)
        if newGain < 1.0 && ESM2_reversalDirection > 0 {
            ESM2_testGain += (0.001 * ESM2_reversalDirection)
        } else if newGain >= 0.9991 && ESM2_reversalDirection > 0 {
            ESM2_testGain = 1.0 //+= (0.001 * ESM2_reversalDirection)
        } else if newGain > 0.0 && ESM2_reversalDirection < 0 {
            ESM2_testGain += (0.001 * ESM2_reversalDirection)
        } else if newGain <= 0.0009 && ESM2_reversalDirection < 0 {
            ESM2_testGain = 0.0 // -= (0.001 * ESM2_reversalDirection)
        } else {
            print("Critical Error in reverslofTenth Logic")
        }
    }
    
    private func ESM2reversalOfOne() async {
        let newGain: Float = ESM2_testGain + (0.01 * ESM2_reversalDirection)
        if newGain < 1.0 && ESM2_reversalDirection > 0 {
            ESM2_testGain += (0.01 * ESM2_reversalDirection)
        } else if newGain >= 0.991 && ESM2_reversalDirection > 0 {
            ESM2_testGain = 1.0//+= (0.01 * ESM2_reversalDirection)
        } else if newGain > 0.0 && ESM2_reversalDirection < 0 {
            ESM2_testGain += (0.01 * ESM2_reversalDirection)
        } else if newGain <= 0.009 && ESM2_reversalDirection < 0 {
            ESM2_testGain = 0.0// -= (0.01 * ESM2_reversalDirection)
        } else {
            print("Critical Error in reverslofOne Logic")
        }
    }
    
    private func ESM2reversalOfFive() async {
        let newGain: Float = ESM2_testGain + (0.05 * ESM2_reversalDirection)
        if newGain < 1.0 && ESM2_reversalDirection > 0 {
            ESM2_testGain += (0.05 * ESM2_reversalDirection)
        } else if newGain >= 0.96 && ESM2_reversalDirection > 0 {
            ESM2_testGain = 1.0//+= (0.05 * ESM2_reversalDirection)
        } else if newGain > 0.0 && ESM2_reversalDirection < 0 {
            ESM2_testGain += (0.05 * ESM2_reversalDirection)
        } else if newGain <= 0.04 && ESM2_reversalDirection < 0 {
            ESM2_testGain = 0.0 //-= (0.05 * ESM2_reversalDirection)
        } else {
            print("Critical Error in reverslofFive Logic")
        }
    }
    
    private func ESM2reversalOfTen() async {
        let newGain: Float = ESM2_testGain + (0.1 * ESM2_reversalDirection)
        print("newGain: \(newGain)")
        if newGain < 1.0 && ESM2_reversalDirection > 0.0 {
            ESM2_testGain += (0.1 * ESM2_reversalDirection)
        } else if newGain > 0.91 && ESM2_reversalDirection > 0.0 {
            ESM2_testGain = 1.0// += (0.1 * ESM2_reversalDirection)
        } else if newGain > 0.0 && ESM2_reversalDirection < 0.0 {
            ESM2_testGain += (0.1 * ESM2_reversalDirection)
        } else if newGain <= 0.01 && ESM2_reversalDirection < 0.0 {
            ESM2_testGain = 0.0 // -= (0.1 * ESM2_reversalDirection)
        } else {
            print("Critical Error in reverslofTe Logic")
        }
    }
    
    private func ESM2reversalAction() async {
        if reversalTenth == true && reversalOne == false && reversalFive == false && reversalTen == false {
            await ESM2reversalOfTenth()
        } else if reversalTenth == false && reversalOne == true && reversalFive == false && reversalTen == false {
            await ESM2reversalOfOne()
        } else if reversalTenth == false && reversalOne == false && reversalFive == true && reversalTen == false {
            await ESM2reversalOfFive()
        } else if reversalTenth == false && reversalOne == false && reversalFive == false && reversalTen == true {
            await ESM2reversalOfTen()
        } else {
            await ESM2reversalOfOne()
            print("!!!Critical error in Reversal Action")
        }
    }
    
    private func watchGainToEnd() async {
        if ESM2_testGain == 1.0 || ESM2_testGain == 0.0 {
            ESM2_Watcher += 1
        } else {
            //Do Nothing
        }
        
    }
    
    private func ESM2restartPresentation() async {
        if ESM2endTestSeriesValue == false && ESM2userPausedTest == false && earSimulatorM2Cycle == true && ESM2_Watcher <= 3 {
            ESM2localPlaying = 1
            ESM2endTestSeriesValue = false
        } else if ESM2endTestSeriesValue == true && ESM2userPausedTest == true && earSimulatorM2Cycle == true && ESM2_Watcher <= 3 {
            ESM2localPlaying = -1
            ESM2endTestSeriesValue = true
            ESM2showTestCompletionSheet = true
            ESM2playingStringColorIndex = 2
        }  else if earSimulatorM2Cycle == false || ESM2_Watcher >= 4 { //ESM2endTestSeriesValue == true || ESM2userPausedTest == true || earSimulatorM2Cycle == false {
            ESM2localPlaying = -1
            ESM2endTestSeriesValue = true
            ESM2showTestCompletionSheet = true
            ESM2playingStringColorIndex = 2
        }
    }
    
    private func ESM2endTestSeriesStop() async {
        if ESM2_Watcher == 4 {
            ESM2localPlaying = -1
            ESM2stop()
            ESM2userPausedTest = true
            ESM2playingStringColorIndex = 2
        } else {
            //do nothing
        }
    }
    
    func writeESM2ResultsToCSV() async {
        let stringFinalESM2GainsArray = ESM2_reversalGain.map { String($0) }.joined(separator: ",")
        let stringFinalESM2SamplesArray = ESM2_frequency.map { String($0) }.joined(separator: ",")
         do {
             let csvESM2Path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvESM2DocumentsDirectory = csvESM2Path
             let csvESM2FilePath = csvESM2DocumentsDirectory.appendingPathComponent(inputESM2CSVName)
             let writer = try CSVWriter(fileURL: csvESM2FilePath, append: false)
             try writer.write(row: [stringFinalESM2GainsArray])
             try writer.write(row: [stringFinalESM2SamplesArray])
         } catch {
             print("CVSWriter ESM2 Data Error or Error Finding File for ESM2 CSV \(error)")
         }
    }
}


extension EarSimulatorManual2View {
//    private func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }

}



struct EarSimulatorManual2View_Previews: PreviewProvider {
    static var previews: some View {
        EarSimulatorManual2View()
    }
}
