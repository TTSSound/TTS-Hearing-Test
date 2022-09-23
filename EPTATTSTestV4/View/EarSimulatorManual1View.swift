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


struct SamplesList: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}



struct EarSimulatorManual1View: View {
    
    @State var samples = [
        SamplesList(name: "Sample1"),
        SamplesList(name: "Sample2"),
        SamplesList(name: "Sample3"),
        SamplesList(name: "Sample4"),
        SamplesList(name: "Sample5"),
        SamplesList(name: "Sample6"),
        SamplesList(name: "Sample7"),
        SamplesList(name: "Sample8"),
        SamplesList(name: "Sample9"),
        SamplesList(name: "Sample10"),
        SamplesList(name: "Sample11"),
        SamplesList(name: "Sample12"),
        SamplesList(name: "Sample13"),
        SamplesList(name: "Sample14"),
        SamplesList(name: "Sample15"),
        SamplesList(name: "Sample16")
    ]
    
    @State private var sampleSelected = [Int]()
    @State private var sampleSelectionIndex = [Int]()
    @State private var sampleSelectedName = [String]()
    @State private var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var traininglocalHeard = 0
    @State private var traininglocalPlaying = Int()    // Playing = 1. Stopped = -1
    @State private var traininglocalReversal = Int()
    @State private var traininglocalReversalEnd = Int()
    @State private var traininglocalMarkNewTestCycle = Int()
    @State private var trainingtestPlayer: AVAudioPlayer?
    
    @State private var traininglocalTestCount = 0
    @State private var traininglocalStartingNonHeardArraySet: Bool = false
    @State private var traininglocalReversalHeardLast = Int()
    @State private var traininglocalSeriesNoResponses = Int()
    @State private var trainingfirstHeardResponseIndex = Int()
    @State private var trainingfirstHeardIsTrue: Bool = false
    @State private var trainingsecondHeardResponseIndex = Int()
    @State private var trainingsecondHeardIsTrue: Bool = false
    @State private var trainingstartTooHigh = 0
    @State private var trainingfirstGain = Float()
    @State private var trainingsecondGain = Float()
    @State private var trainingendTestSeriesValue: Bool = false
    @State private var trainingshowTestCompletionSheet: Bool = false
    
    @State private var training_samples: [String] = ["Sample0", "Sample1"]
    @State private var training_index: Int = 0
    @State private var training_testGain: Float = 0
    @State private var training_heardArray: [Int] = [Int]()
    @State private var training_indexForTest = [Int]()
    @State private var training_testCount: [Int] = [Int]()
    @State private var training_pan: Float = Float()
    @State private var training_testPan = [Float]()
    @State private var training_testTestGain = [Float]()
    @State private var training_frequency = [String]()
    @State private var training_reversalHeard = [Int]()
    @State private var training_reversalGain = [Float]()
    @State private var training_reversalFrequency = [String]()
    @State private var training_reversalDirection = Float()
    @State private var training_reversalDirectionArray = [Float]()
    
    @State private var training_averageGain = Float()
    
    @State private var training_eptaSamplesCount = 1 //17
    @State private var training_SamplesCountArray = [1, 1]
    @State private var training_SamplesCountArrayIdx = 0
    
    @State private var training_finalStoredIndex: [Int] = [Int]()
    @State private var training_finalStoredTestPan: [Float] = [Float]()
    @State private var training_finalStoredTestTestGain: [Float] = [Float]()
    @State private var training_finalStoredFrequency: [String] = [String]()
    @State private var training_finalStoredTestCount: [Int] = [Int]()
    @State private var training_finalStoredHeardArray: [Int] = [Int]()
    @State private var training_finalStoredReversalHeard: [Int] = [Int]()
    @State private var training_finalStoredFirstGain: [Float] = [Float]()
    @State private var training_finalStoredSecondGain: [Float] = [Float]()
    @State private var training_finalStoredAverageGain: [Float] = [Float]()
    
    @State private var trainingidxForTest = Int() // = training_indexForTest.count
    @State private var trainingidxForTestNet1 = Int() // = training_indexForTest.count - 1
    @State private var trainingidxTestCount = Int() // = training_TestCount.count
    @State private var trainingidxTestCountUpdated = Int() // = training_TestCount.count + 1
    @State private var trainingactiveFrequency = String()
    @State private var trainingidxHA = Int()    // idx = training_heardArray.count
    @State private var trainingidxReversalHeardCount = Int()
    @State private var trainingidxHAZero = Int()    //  idxZero = idx - idx
    @State private var trainingidxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State private var trainingisCountSame = Int()
    @State private var trainingheardArrayIdxAfnet1 = Int()
    @State private var trainingtestIsPlaying: Bool = false
    @State private var trainingplayingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State private var trainingplayingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State private var trainingplayingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    @State private var trainingTappingColorIndex = 0
    @State private var trainingTappingGesture: Bool = false
    
    @State private var trainingplayingStringColorIndex = 0
    @State private var traininguserPausedTest: Bool = false
    
    @State private var trainingTestCompleted: Bool = false
    
    @State private var trainingfullTestCompleted: Bool = false
    @State private var trainingfullTestCompletedHoldingArray: [Bool] = [false, false, true]
    @State private var trainingTestStarted: Bool = false
    
    
    let inputESM1CSVName = "InputDetailedEarSimulatorM1ResultsCSV.csv"
    
    
    let earSimulatorM1heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM1arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM1audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var earSimulatorM1testPlayerlocalHeard = Int()
    @State private var earSimulatorM1_volume = Float()
    @State private var newactiveFrequency = String()
    @State private var earSimulatorM1Cycle: Bool = false
    
    @State private var earSimulatorM1showTestCompletionSheet: Bool = false
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                HStack{
                    Spacer()
                    Button {
                        earSimulatorM1showTestCompletionSheet = true
                        trainingstop()
                    } label: {
                        Text("\(trainingactiveFrequency)")
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
                if trainingTestStarted == false {
                    Button {    // Start Button
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            traininglocalPlaying = 1
                            trainingendTestSeriesValue = false
                            print("Start Button Clicked. Playing = \(traininglocalPlaying)")
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
                } else if trainingTestStarted == true {
                    HStack{
                        Spacer()
                        Button {    // Pause Button
                            traininglocalPlaying = 0
                            trainingstop()
                            traininguserPausedTest = true
                            trainingplayingStringColorIndex = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                                traininglocalPlaying = 0
                                trainingstop()
                                traininguserPausedTest = true
                                trainingplayingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                                traininglocalPlaying = 0
                                trainingstop()
                                traininguserPausedTest = true
                                trainingplayingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                                traininglocalPlaying = 0
                                trainingstop()
                                traininguserPausedTest = true
                                trainingplayingStringColorIndex = 1
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
                            training_heardArray.removeAll()
                            trainingpauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            traininglocalPlaying = 1
                            traininguserPausedTest = false
                            trainingplayingStringColorIndex = 0
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
                        Text("Volume: \(earSimulatorM1_volume)")
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
                    Text("Gain: \(training_testGain)")
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
                            let newGain: Float = training_testGain - 0.1
                            if newGain > 0.0 {
                                training_testGain -= 0.1
                            } else if newGain == 0.0 {
                                training_testGain -= 0.1
                            } else {
                                training_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.1")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = training_testGain + 0.1
                            if newGain < 1.0 {
                                training_testGain += 0.1
                            } else if newGain == 1.0 {
                                training_testGain += 0.1
                            } else {
                                training_testGain = 1.0
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
                            let newGain: Float = training_testGain - 0.05
                            if newGain > 0.0 {
                                training_testGain -= 0.05
                            } else if newGain == 0.0 {
                                training_testGain -= 0.05
                            } else {
                                training_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.05")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = training_testGain + 0.05
                            if newGain < 1.0 {
                                training_testGain += 0.05
                            } else if newGain == 1.0 {
                                training_testGain += 0.05
                            } else {
                                training_testGain = 1.0
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
                            let newGain: Float = training_testGain - 0.01
                            if newGain > 0.0 {
                                training_testGain -= 0.01
                            } else if newGain == 0.0 {
                                training_testGain -= 0.01
                            } else {
                                training_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.01")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = training_testGain + 0.01
                            if newGain < 1.0 {
                                training_testGain += 0.01
                            } else if newGain == 1.0 {
                                training_testGain += 0.01
                            } else {
                                training_testGain = 1.0
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
                            let newGain: Float = training_testGain - 0.001
                            if newGain > 0.0 {
                                training_testGain -= 0.001
                            } else if newGain == 0.0 {
                                training_testGain -= 0.001
                            } else {
                                training_testGain = 0.0
                            }
                        }
                    } label: {
                        VStack{
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                    Text("0.001")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = training_testGain + 0.001
                            if newGain < 1.0 {
                                training_testGain += 0.001
                            } else if newGain == 1.0 {
                                training_testGain += 0.001
                            } else {
                                training_testGain = 1.0
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
                        training_pan = -1.0
                    } label: {
                        Text("Left Pan")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button {    // Middle Pan
                        training_pan = 0.0
                    } label: {
                        Text("Middle Pan")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Button {    // Right Pan
                        training_pan = 1.0
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
                                            trainingactiveFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM1activeFrequency: \(trainingactiveFrequency)")
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
                                training_samples.removeAll()
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
            .onChange(of: trainingtestIsPlaying, perform: { trainingtestBoolValue in
                if trainingtestBoolValue == true && trainingendTestSeriesValue == false {
                    //User is starting test for first time
                    audioSessionModel.setAudioSession()
                    traininglocalPlaying = 1
                    trainingplayingStringColorIndex = 0
                    traininguserPausedTest = false
                } else if trainingtestBoolValue == false && trainingendTestSeriesValue == false {
                    // User is pausing test for firts time
                    trainingstop()
                    traininglocalPlaying = 0
                    trainingplayingStringColorIndex = 1
                    traininguserPausedTest = true
                } else if trainingtestBoolValue == true && trainingendTestSeriesValue == true {
                    trainingstop()
                    traininglocalPlaying = -1
                    trainingplayingStringColorIndex = 2
                    traininguserPausedTest = true
                } else {
                    print("Critical error in pause logic")
                }
            })
            .onChange(of: traininglocalPlaying) { trainingplayingValue in
//                //Change This To Picker Frequency Selection   //earSimulatorM1activeFrequency is keyed into formula
//                earSimulatorM1activeFrequency = earSimulatorM1activeFrequency
//                // GAIN SETTING Bound to Gain Change Buttons
//                earSimulatorM1_testGain = earSimulatorM1_testGain
//                // Pan Setting // earSimulatorM1_pan is bound to play function
//                earSimulatorM1_pan = earSimulatorM1_pan
                training_samples.append(trainingactiveFrequency)
                traininglocalHeard = 0
                traininglocalReversal = 0
                newactiveFrequency = training_samples[training_index]
                trainingTestStarted = true
                if trainingplayingValue == 1{
                    //Play Sample
                    earSimulatorM1audioThread.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain, pan: training_pan)
                        while trainingtestPlayer!.isPlaying == true && self.traininglocalHeard == 0 { }
                        if traininglocalHeard == 1 {
                            trainingtestPlayer!.stop()
                            print("Stopped in while if: Returned Array \(traininglocalHeard)")
                        } else {
                            trainingtestPlayer!.stop()
                            self.traininglocalHeard = -1
                            print("Stopped naturally: Returned Array \(traininglocalHeard)")
                        }
                    }
                    //Event Logging
                    earSimulatorM1preEventThread.async {
                        trainingpreEventLogging()
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                        traininglocalTestCount += 1
                        Task(priority: .userInitiated) {
                            await trainingheardArrayNormalize()
                            
                            await trainingcount()
                            await traininglogNotPlaying()
                            await trainingresetPlaying()
                            
                            await trainingresetHeard()
//                            await trainingnonResponseCounting()
                            await trainingcreateReversalHeardArray()
                            await trainingcreateReversalSampleArray()
//                            await createReversalGainArrayNonResponse()
//                            await trainingcheckHeardReversalArrays()
                       

                            await trainingreversalStart()

                        }
                    }
                }
            }
            // end of first .onChange of
            .onChange(of: traininglocalReversal) { trainingreversalValue in
                if trainingreversalValue == 1 {
                    DispatchQueue.global(qos: .background).async {
                        Task(priority: .userInitiated) {
//                            await trainingreversalDirection()
//                            await trainingreversalComplexAction()
//                            await trainingreversalsCompleteLogging()
//                            await trainingendTestSeries()
//                            await trainingnewTestCycle()
                            await writeESM1ResultsToCSV()
                            await trainingrestartPresentation()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual1View {
    enum trainingSampleErrors: Error {
        case trainingnotFound
        case earSimulatorM1lastUnexpected(code: Int)
    }

    private func trainingpauseRestartTestCycle() {
        traininglocalMarkNewTestCycle = 0
        traininglocalReversalEnd = 0
        training_index = 0
        training_samples.removeAll()
        training_samples.append(trainingactiveFrequency)
        newactiveFrequency = training_samples[training_index]
        training_testGain = training_testGain
        trainingtestIsPlaying = false
        traininglocalPlaying = 0
        training_testCount.removeAll()
        training_reversalHeard.removeAll()
        training_averageGain = Float()
        training_reversalDirection = Float()
        traininglocalStartingNonHeardArraySet = false
        trainingfirstHeardResponseIndex = Int()
        trainingfirstHeardIsTrue = false
        trainingsecondHeardResponseIndex = Int()
        trainingsecondHeardIsTrue = false
        traininglocalTestCount = 0
        traininglocalReversalHeardLast = Int()
        trainingstartTooHigh = 0
    }
    
    private func trainingloadAndTestPresentation(sample: String, gain: Float, pan: Float) {
            do{
                let trainingurlSample = Bundle.main.path(forResource: newactiveFrequency, ofType: ".wav")
                guard let trainingurlSample = trainingurlSample else { return print(trainingSampleErrors.trainingnotFound) }
                trainingtestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: trainingurlSample))
                guard let trainingtestPlayer = trainingtestPlayer else { return }
                trainingtestPlayer.prepareToPlay()    // Test Player Prepare to Play
                trainingtestPlayer.setVolume(training_testGain, fadeDuration: 0)      // Set Gain for Playback
                trainingtestPlayer.pan = training_pan
                trainingtestPlayer.play()   // Start Playback
            } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    private func trainingstop() {
      do{
          let trainingurlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let trainingurlSample = trainingurlSample else { return print(trainingSampleErrors.trainingnotFound) }
          trainingtestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: trainingurlSample))
          guard let trainingtestPlayer = trainingtestPlayer else { return }
          trainingtestPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    private func trainingresetNonResponseCount() async {traininglocalSeriesNoResponses = 0 }
    
    private func trainingnonResponseCounting() async {traininglocalSeriesNoResponses += 1 }
     
    private func trainingresetPlaying() async { self.traininglocalPlaying = 0 }
    
    private func traininglogNotPlaying() async { self.traininglocalPlaying = -1 }
    
    private func trainingresetHeard() async { self.traininglocalHeard = 0 }
    
    private func trainingreversalStart() async { self.traininglocalReversal = 1}
  
    private func trainingpreEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
            training_indexForTest.append(training_index)
        }
        DispatchQueue.global(qos: .default).async {
            training_testTestGain.append(training_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            training_frequency.append(trainingactiveFrequency)
            training_testPan.append(training_pan)
        }
    }
    
    private func trainingresponseHeardArray() async {
        training_heardArray.append(1)
        self.trainingidxHA = training_heardArray.count
        self.traininglocalStartingNonHeardArraySet = true
    }

    private func traininglocalResponseTracking() async {
        if trainingfirstHeardIsTrue == false {
            trainingfirstHeardResponseIndex = traininglocalTestCount
            trainingfirstHeardIsTrue = true
        } else if trainingfirstHeardIsTrue == true {
            trainingsecondHeardResponseIndex = traininglocalTestCount
            trainingsecondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
    private func trainingheardArrayNormalize() async {
        trainingidxHA = training_heardArray.count
        trainingidxForTest = training_indexForTest.count
        trainingidxForTestNet1 = trainingidxForTest - 1
        trainingisCountSame = trainingidxHA - trainingidxForTest
        trainingheardArrayIdxAfnet1 = training_heardArray.index(after: trainingidxForTestNet1)
        
        if traininglocalStartingNonHeardArraySet == false {
            training_heardArray.append(0)
            self.traininglocalStartingNonHeardArraySet = true
            trainingidxHA = training_heardArray.count
            trainingidxHAZero = trainingidxHA - trainingidxHA
            trainingidxHAFirst = trainingidxHAZero + 1
            trainingisCountSame = trainingidxHA - trainingidxForTest
            trainingheardArrayIdxAfnet1 = training_heardArray.index(after: trainingidxForTestNet1)
            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
    }
    
    
    private func trainingcount() async {
        trainingidxTestCountUpdated = training_testCount.count + 1
        training_testCount.append(trainingidxTestCountUpdated)
    }
}


extension EarSimulatorManual1View {
//MARK: -Extension Methods Reversals
    
    private func trainingcreateReversalHeardArray() async {
        training_reversalHeard.append(training_heardArray[trainingidxHA-1])
        self.trainingidxReversalHeardCount = training_reversalHeard.count
    }
    
    private func trainingcreateReversalGainArray() async {
        training_reversalGain.append(training_testGain)
    }
    
    private func trainingcreateReversalSampleArray() async {
        training_frequency.append(newactiveFrequency)
    }
    
    private func createReversalGainArrayNonResponse() async {
        if training_testGain < 0.995 {
            training_reversalGain.append(training_testGain)
        } else if training_testGain >= 0.995 {
            training_reversalGain.append(1.0)
        }
    }
    
    private func trainingcheckHeardReversalArrays() async {
        if trainingidxHA - trainingidxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if trainingidxHA - trainingidxReversalHeardCount < 0 && trainingidxHA - trainingidxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    private func trainingreversalDirection() async {
        traininglocalReversalHeardLast = training_reversalHeard.last ?? -999
        if traininglocalReversalHeardLast == 1 {
            training_reversalDirection = -1.0
            training_reversalDirectionArray.append(-1.0)
        } else if traininglocalReversalHeardLast == 0 {
            training_reversalDirection = 1.0
            training_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    private func trainingreversalOfOne() async {
        let trainingrO1Direction = 0.01 * training_reversalDirection
        let trainingr01NewGain = training_testGain + trainingrO1Direction
        if trainingr01NewGain > 0.00001 && trainingr01NewGain < 1.0 {
            training_testGain = roundf(trainingr01NewGain * 100000) / 100000
        } else if trainingr01NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr01NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    private func trainingreversalOfTwo() async {
        let trainingrO2Direction = 0.02 * training_reversalDirection
        let trainingr02NewGain = training_testGain + trainingrO2Direction
        if trainingr02NewGain > 0.00001 && trainingr02NewGain < 1.0 {
            training_testGain = roundf(trainingr02NewGain * 100000) / 100000
        } else if trainingr02NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr02NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    private func trainingreversalOfThree() async {
        let trainingrO3Direction = 0.03 * training_reversalDirection
        let trainingr03NewGain = training_testGain + trainingrO3Direction
        if trainingr03NewGain > 0.00001 && trainingr03NewGain < 1.0 {
            training_testGain = roundf(trainingr03NewGain * 100000) / 100000
        } else if trainingr03NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr03NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    private func trainingreversalOfFour() async {
        let trainingrO4Direction = 0.04 * training_reversalDirection
        let trainingr04NewGain = training_testGain + trainingrO4Direction
        if trainingr04NewGain > 0.00001 && trainingr04NewGain < 1.0 {
            training_testGain = roundf(trainingr04NewGain * 100000) / 100000
        } else if trainingr04NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr04NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    private func trainingreversalOfFive() async {
        let trainingrO5Direction = 0.05 * training_reversalDirection
        let trainingr05NewGain = training_testGain + trainingrO5Direction
        if trainingr05NewGain > 0.00001 && trainingr05NewGain < 1.0 {
            training_testGain = roundf(trainingr05NewGain * 100000) / 100000
        } else if trainingr05NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr05NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    private func trainingreversalOfTen() async {
        let trainingr10Direction = 0.10 * training_reversalDirection
        let trainingr10NewGain = training_testGain + trainingr10Direction
        if trainingr10NewGain > 0.00001 && trainingr10NewGain < 1.0 {
            training_testGain = roundf(trainingr10NewGain * 100000) / 100000
        } else if trainingr10NewGain <= 0.0 {
            training_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if trainingr10NewGain >= 0.995 {
            training_testGain = 0.995
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    private func trainingreversalAction() async {
        if traininglocalReversalHeardLast == 1 {
            await trainingreversalOfFive()
        } else if traininglocalReversalHeardLast == 0 {
            await trainingreversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    private func trainingreversalComplexAction() async {
        if trainingidxReversalHeardCount <= 1 && trainingidxHA <= 1 {
            await trainingreversalAction()
        }  else if trainingidxReversalHeardCount == 2 {
            if trainingidxReversalHeardCount == 2 && trainingsecondHeardIsTrue == true {
                await trainingstartTooHighCheck()
            } else if trainingidxReversalHeardCount == 2  && trainingsecondHeardIsTrue == false {
                await trainingreversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if trainingidxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if trainingsecondHeardResponseIndex - trainingfirstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if traininglocalSeriesNoResponses == 3 {
                await trainingreversalOfTen()
            } else if traininglocalSeriesNoResponses == 2 {
                await trainingreversalOfFour()
            } else {
                await trainingreversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    private func trainingreversalHeardCount1() async {
        await trainingreversalAction()
    }
    
    private func trainingcheck2PositiveSeriesReversals() async {
        if training_reversalHeard[trainingidxHA-2] == 1 && training_reversalHeard[trainingidxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }
    
    private func trainingcheckTwoNegativeSeriesReversals() async {
        if training_reversalHeard.count >= 3 && training_reversalHeard[trainingidxHA-2] == 0 && training_reversalHeard[trainingidxHA-1] == 0 {
            await trainingreversalOfFour()
        } else {
            await trainingreversalAction()
        }
    }
    
    private func trainingstartTooHighCheck() async {
        if trainingstartTooHigh == 0 && trainingfirstHeardIsTrue == true && trainingsecondHeardIsTrue == true {
            trainingstartTooHigh = 1
            await trainingreversalOfTen()
            await trainingresetAfterTooHigh()
            print("Too High Found")
        } else {
            await trainingreversalAction()
        }
    }
    
    private func trainingresetAfterTooHigh() async {
        trainingfirstHeardResponseIndex = Int()
        trainingfirstHeardIsTrue = false
        trainingsecondHeardResponseIndex = Int()
        trainingsecondHeardIsTrue = false
    }
    
    private func trainingreversalsCompleteLogging() async {
        if trainingsecondHeardIsTrue == true {
            self.traininglocalReversalEnd = 1
            self.traininglocalMarkNewTestCycle = 1
            self.trainingfirstGain = training_reversalGain[trainingfirstHeardResponseIndex-1]
            self.trainingsecondGain = training_reversalGain[trainingsecondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
            let trainingdelta = trainingfirstGain - trainingsecondGain
            let trainingavg = (trainingfirstGain + trainingsecondGain)/2
            if trainingdelta == 0 {
                training_averageGain = trainingsecondGain
                print("average Gain: \(training_averageGain)")
            } else if trainingdelta >= 0.05 {
                training_averageGain = trainingsecondGain
                print("SecondGain: \(trainingfirstGain)")
                print("SecondGain: \(trainingsecondGain)")
                print("average Gain: \(training_averageGain)")
            } else if trainingdelta <= -0.05 {
                training_averageGain = trainingfirstGain
                print("SecondGain: \(trainingfirstGain)")
                print("SecondGain: \(trainingsecondGain)")
                print("average Gain: \(training_averageGain)")
            } else if trainingdelta < 0.05 && trainingdelta > -0.05 {
                training_averageGain = trainingavg
                print("SecondGain: \(trainingfirstGain)")
                print("SecondGain: \(trainingsecondGain)")
                print("average Gain: \(training_averageGain)")
            } else {
                training_averageGain = trainingavg
                print("SecondGain: \(trainingfirstGain)")
                print("SecondGain: \(trainingsecondGain)")
                print("average Gain: \(training_averageGain)")
            }
        } else if trainingsecondHeardIsTrue == false {
            print("Contine, second hear is true = false")
        } else {
            print("Critical error in reversalsCompletLogging Logic")
        }
    }
    
    private func trainingrestartPresentation() async {
        if trainingendTestSeriesValue == false && traininguserPausedTest == false && earSimulatorM1Cycle == true {
            traininglocalPlaying = 1
            trainingendTestSeriesValue = false
        } else if trainingendTestSeriesValue == true && traininguserPausedTest == true && earSimulatorM1Cycle == true {
            traininglocalPlaying = -1
            trainingendTestSeriesValue = true
            trainingshowTestCompletionSheet = true
            trainingplayingStringColorIndex = 2
        }  else if earSimulatorM1Cycle == false { //trainingendTestSeriesValue == true || traininguserPausedTest == true || earSimulatorM1Cycle == false {
            traininglocalPlaying = -1
            trainingendTestSeriesValue = true
            trainingshowTestCompletionSheet = true
            trainingplayingStringColorIndex = 2
        }
    }
    
    private func trainingwipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            training_heardArray.removeAll()
            training_testCount.removeAll()
            training_reversalHeard.removeAll()
            training_reversalGain.removeAll()
            training_averageGain = Float()
            training_reversalDirection = Float()
            traininglocalStartingNonHeardArraySet = false
            trainingfirstHeardResponseIndex = Int()
            trainingfirstHeardIsTrue = false
            trainingsecondHeardResponseIndex = Int()
            trainingsecondHeardIsTrue = false
            traininglocalTestCount = 0
            traininglocalReversalHeardLast = Int()
            trainingstartTooHigh = 0
            traininglocalSeriesNoResponses = Int()
        })
    }
    
    private func startNextTestCycle() async {
        await trainingwipeArrays()
        trainingshowTestCompletionSheet.toggle()
        trainingstartTooHigh = 0
        traininglocalMarkNewTestCycle = 0
        traininglocalReversalEnd = 0
        training_index = training_index + 1
        training_testGain = training_testGain
        trainingendTestSeriesValue = false
        trainingshowTestCompletionSheet = false
        trainingtestIsPlaying = true
        traininguserPausedTest = false
        trainingplayingStringColorIndex = 2
        print(training_SamplesCountArray[training_index])
        traininglocalPlaying = 1
    }
    
    private func trainingnewTestCycle() async {
        if traininglocalMarkNewTestCycle == 1 && traininglocalReversalEnd == 1 && training_index < training_SamplesCountArray[training_index] && trainingendTestSeriesValue == false {
            trainingstartTooHigh = 0
            traininglocalMarkNewTestCycle = 0
            traininglocalReversalEnd = 0
            training_index = training_index + 1
            training_testGain = training_testGain
            trainingendTestSeriesValue = false
            await trainingwipeArrays()
        } else if traininglocalMarkNewTestCycle == 1 && traininglocalReversalEnd == 1 && training_index == training_SamplesCountArray[training_index] && trainingendTestSeriesValue == false {
            trainingendTestSeriesValue = true
            trainingfullTestCompleted = true
            traininglocalPlaying = -1
            training_SamplesCountArrayIdx += 1
            print("=============================")
            print("!!!!! End of Test Series!!!!!!")
            print("=============================")
            if trainingfullTestCompleted == true {
                trainingfullTestCompleted = true
                trainingendTestSeriesValue = true
                traininglocalPlaying = -1
                print("*****************************")
                print("=============================")
                print("^^^^^^End of Full Test Series^^^^^^")
                print("=============================")
                print("*****************************")
            } else if trainingfullTestCompleted == false {
                trainingfullTestCompleted = false
                trainingendTestSeriesValue = true
                traininglocalPlaying = -1
                training_SamplesCountArrayIdx += 1
            }
        } else {
            //                print("Reversal Limit Not Hit")
        }
    }
    
    private func trainingendTestSeries() async {
        if trainingendTestSeriesValue == false {
            //Do Nothing and continue
            print("end Test Series = \(trainingendTestSeriesValue)")
        } else if trainingendTestSeriesValue == true {
            trainingshowTestCompletionSheet = true
            training_eptaSamplesCount = training_eptaSamplesCount + 1
            await trainingendTestSeriesStop()
        }
    }
    
    private func trainingendTestSeriesStop() async {
        traininglocalPlaying = -1
        trainingstop()
        traininguserPausedTest = true
        trainingplayingStringColorIndex = 2
    }
    
    func writeESM1ResultsToCSV() async {
        let stringFinalESM1GainsArray = training_reversalGain.map { String($0) }.joined(separator: ",")
        let stringFinalESM1SamplesArray = training_frequency.map { String($0) }.joined(separator: ",")
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

struct EarSimulatorManual1View_Previews: PreviewProvider {
    static var previews: some View {
        EarSimulatorManual1View()
    }
}
