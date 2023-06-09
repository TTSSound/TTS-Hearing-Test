//
//  TrainingTestView.swift
//  TTS_Hearing_Test
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

struct TrainingTestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            TrainingTestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading TrainingTest View")
                .navigationTitle("")
        }
    }
}


struct trainingSaveFinalResults: Codable {  // This is a model
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
    var jsonPan: [Int]
    var jsonStoredIndex: [Int]
    var jsonStoredTestPan: [Int]
    var jsonStoredTestTestGain: [Float]
    var jsonStoredTestCount: [Int]
    var jsonStoredHeardArray: [Int]
    var jsonStoredReversalHeard: [Int]
    var jsonStoredFirstGain: [Float]
    var jsonStoredSecondGain: [Float]
    var jsonStoredAverageGain: [Float]
}

struct TrainingTestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    enum trainingSampleErrors: Error {
        case trainingnotFound
        case trainingunexpected(code: Int)
    }
    
    enum trainingFirebaseErrors: Error {
        case trainingunknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var traininglocalHeard = 0
    @State var traininglocalPlaying = Int()    // Playing = 1. Stopped = -1
    @State var traininglocalReversal = Int()
    @State var traininglocalReversalEnd = Int()
    @State var traininglocalMarkNewTestCycle = Int()
    @State var trainingtestPlayer: AVAudioPlayer?
    
    @State var traininglocalTestCount = 0
    @State var traininglocalStartingNonHeardArraySet: Bool = false
    @State var traininglocalReversalHeardLast = Int()
    @State var traininglocalSeriesNoResponses = Int()
    @State var trainingfirstHeardResponseIndex = Int()
    @State var trainingfirstHeardIsTrue: Bool = false
    @State var trainingsecondHeardResponseIndex = Int()
    @State var trainingsecondHeardIsTrue: Bool = false
    @State var trainingstartTooHigh = 0
    @State var trainingfirstGain = Float()
    @State var trainingsecondGain = Float()
    @State var trainingendTestSeriesValue: Bool = false
    @State var trainingshowTestCompletionSheet: Bool = false
    
    @State var training_samples: [String] = [String]()
    @State private var highResStdSamples: [String] = ["Sample0", "Sample1"]
    @State private var highResFadedSamples: [String] = ["FSample0", "FSample1"]
    @State private var cdFadedDitheredSamples: [String] = ["FDSample0", "FDSample1"]
    @State var training_index: Int = 0
    @State var training_testGain: Float = 0.0015
    @State var training_heardArray: [Int] = [Int]()
    @State var training_indexForTest = [Int]()
    @State var training_testCount: [Int] = [Int]()
    @State var training_pan: Int = Int()
    @State var training_testPan = [Int]()
    @State var training_testTestGain = [Float]()
    @State var training_frequency = [String]()
    @State var training_reversalHeard = [Int]()
    @State var training_reversalGain = [Float]()
    @State var training_reversalFrequency = [String]()
    @State var training_reversalDirection = Float()
    @State var training_reversalDirectionArray = [Float]()
    
    @State var training_averageGain = Float()
    
    @State var training_eptaSamplesCount = 1 //17
    @State var training_SamplesCountArray = [1, 1]
    @State var training_SamplesCountArrayIdx = 0
    
    @State var training_finalStoredIndex: [Int] = [Int]()
    @State var training_finalStoredTestPan: [Int] = [Int]()
    @State var training_finalStoredTestTestGain: [Float] = [Float]()
    @State var training_finalStoredFrequency: [String] = [String]()
    @State var training_finalStoredTestCount: [Int] = [Int]()
    @State var training_finalStoredHeardArray: [Int] = [Int]()
    @State var training_finalStoredReversalHeard: [Int] = [Int]()
    @State var training_finalStoredFirstGain: [Float] = [Float]()
    @State var training_finalStoredSecondGain: [Float] = [Float]()
    @State var training_finalStoredAverageGain: [Float] = [Float]()
    
    @State var trainingidxForTest = Int() // = training_indexForTest.count
    @State var trainingidxForTestNet1 = Int() // = training_indexForTest.count - 1
    @State var trainingidxTestCount = Int() // = training_TestCount.count
    @State var trainingidxTestCountUpdated = Int() // = training_TestCount.count + 1
    @State var trainingactiveFrequency = String()
    @State var trainingidxHA = Int()    // idx = training_heardArray.count
    @State var trainingidxReversalHeardCount = Int()
    @State var trainingidxHAZero = Int()    //  idxZero = idx - idx
    @State var trainingidxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var trainingisCountSame = Int()
    @State var trainingheardArrayIdxAfnet1 = Int()
    @State var trainingtestIsPlaying: Bool = false
    @State var trainingplayingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State var trainingplayingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State var trainingplayingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    @State var trainingTappingColorIndex = 0
    @State var trainingTappingGesture: Bool = false
    
    @State var trainingplayingStringColorIndex = 0
    @State var traininguserPausedTest: Bool = false
    
    @State var trainingTestCompleted: Bool = false
    
    @State var trainingfullTestCompleted: Bool = false
    @State var trainingfullTestCompletedHoldingArray: [Bool] = [false, false, true]
    @State var trainingTestStarted: Bool = false
    
    
    let filetrainingName = "SummaryTrainingResults.json"
    let summarytrainingCSVName = "SummaryTrainingResultsCSV.csv"
    let detailedtrainingCSVName = "DetailedTrainingResultsCSV.csv"
    let inputtrainingSummaryCSVName = "InputSummaryTrainingResultsCSV.csv"
    let inputtrainingDetailedCSVName = "InputDetailedTrainingResultsCSV.csv"
    
    @State var trainingsaveFinalResults: trainingSaveFinalResults? = nil
    
    let trainingheardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let trainingarrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let trainingaudioThread = DispatchQueue(label: "AudioThread", qos: .default)
        
    let trainingpreEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State var P: Testing?
    
    @State private var changeSampleArray: Bool = false
    @State private var highResStandard: Bool = false
    @State private var highResFaded: Bool = false
    @State private var cdFadedDithered: Bool = false
    @State private var sampleArraySet: Bool = false
    
    let trainingaudioThreadBackground = DispatchQueue(label: "AudioThread", qos: .background)
    let trainingaudioThreadDefault = DispatchQueue(label: "AudioThread", qos: .default)
    let trainingaudioThreadUserInteractive = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let trainingaudioThreadUserInitiated = DispatchQueue(label: "AudioThread", qos: .userInitiated)
    
    @State private var showQoSThreads: Bool = false
    @State private var qualityOfService = Int()
    @State private var qosBackground: Bool = false
    @State private var qosDefault: Bool = false
    @State private var qosUserInteractive: Bool = false
    @State private var qosUserInitiated: Bool = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                if trainingfullTestCompleted == false {
                    Text("Practice Test")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                } else if trainingTestCompleted == true { //trainingfullTestCompleted == true {
                    HStack{
                        NavigationLink("Training Complete. Continue.", destination: TrainingTestHoldingPlace(testing: testing, relatedLinkTesting: linkTesting))
                        //                        NavigationLink("Training Complete. Contine.", value: P)
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                    }
                    .navigationDestination(isPresented: $trainingTestCompleted) {
                        TrainingTestHoldingPlace(testing: testing, relatedLinkTesting: linkTesting)
                    }
                    
                }
        
                if trainingTestStarted == false {
                    Button {
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            traininglocalPlaying = 1
                            changeSampleArray = false
                            print("Start Button Clicked. Playing = \(traininglocalPlaying)")
                        }
                    } label: {
                        Text("Click to Start")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
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
                    
                } else if trainingTestStarted == true {
                    Button {
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
                    
                    Button {
                        training_heardArray.removeAll()
                        trainingpauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        traininglocalPlaying = 1
                        traininguserPausedTest = false
                        trainingplayingStringColorIndex = 0
                        print("Start Button Clicked. Playing = \(traininglocalPlaying)")
                    } label: {
                        Text(trainingplayingString[trainingplayingStringColorIndex])
                            .foregroundColor(trainingplayingAlternateStringColor[trainingplayingStringColorIndex+1])
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(trainingplayingAlternateStringColor[trainingplayingStringColorIndex])
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                
                Button {
                    trainingheardThread.async{ self.traininglocalHeard = 1
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
            .onAppear(perform: {
                trainingshowTestCompletionSheet = true
                audioSessionModel.cancelAudioSession()
                highResStandard = true
                //append highresstd to array
                training_samples.append(contentsOf: highResStdSamples)
                sampleArraySet = true
                //
                //
                //
                trainingTestCompleted = true
                //
                //
                //
                
                print("training_samples: \(training_samples)")
            })
            .fullScreenCover(isPresented: $trainingshowTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            trainingshowTestCompletionSheet.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.clear)
                        })
//                        if trainingfullTestCompleted == false {
//                            VStack(alignment: .leading, spacing: 10){
//                                Toggle(isOn: $showQoSThreads) {
//                                    Text("Change Qos Threads")
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.leading, 10)
//                                .padding(.trailing, 10)
//                                .padding(.bottom, 10)
//                                if showQoSThreads == true {
//                                    HStack{
//                                        Toggle("Background", isOn: $qosBackground)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("Default", isOn: $qosDefault)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                    }
//                                    .padding(.leading, 10)
//                                    .padding(.bottom, 10)
//                                    HStack{
//                                        Toggle("UserInteractive", isOn: $qosUserInteractive)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("UserInitiated", isOn: $qosUserInitiated)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                    }
//                                    .padding(.leading, 10)
//                                    .padding(.bottom, 10)
//                                }
//                            }
//                            .onChange(of: qosBackground) { backgroundValue in
//                                if backgroundValue == true {
//                                    qosBackground = true
//                                    qosDefault = false
//                                    qosUserInteractive = false
//                                    qosUserInitiated = false
//                                    qualityOfService = 1
//                                }
//                            }
//                            .onChange(of: qosDefault) { defaultValue in
//                                if defaultValue == true {
//                                    qosBackground = false
//                                    qosDefault = true
//                                    qosUserInteractive = false
//                                    qosUserInitiated = false
//                                    qualityOfService = 2
//                                }
//                            }
//                            .onChange(of: qosUserInteractive) { interactiveValue in
//                                if interactiveValue == true {
//                                    qosBackground = false
//                                    qosDefault = false
//                                    qosUserInteractive = true
//                                    qosUserInitiated = false
//                                    qualityOfService = 3
//                                }
//                            }
//                            .onChange(of: qosUserInitiated) { initiatedValue in
//                                if initiatedValue == true {
//                                    qosBackground = false
//                                    qosDefault = false
//                                    qosUserInteractive = false
//                                    qosUserInitiated = true
//                                    qualityOfService = 4
//                                }
//                            }
//                        }
//
//                        if trainingfullTestCompleted == false {
//                            VStack{
//                                Toggle(isOn: $changeSampleArray) {
//                                    Text("ChangeSampleType")
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.leading, 10)
//                                .padding(.trailing, 10)
//                                .padding(.bottom, 10)
//                                if changeSampleArray == true {
//                                    HStack{
//                                        Toggle("92/24\nStd", isOn: $highResStandard)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("92/24\nFaded", isOn: $highResFaded)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("48/16\nFaded", isOn: $cdFadedDithered)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                    }
//                                    .padding(.leading, 10)
//                                    .padding(.bottom, 10)
//                                }
//                            }
//                            .onChange(of: changeSampleArray) { change in
//                                if change == true {
//                                    sampleArraySet = false
//                                } else if change == false {
//                                    sampleArraySet = true
//                                }
//                            }
//                            .onChange(of: highResStandard) { highResValue in
//                                sampleArraySet = false
//                                if highResValue == true && sampleArraySet == false {
//                                    //remove array values
//                                    training_samples.removeAll()
//                                    //set other toggles to fales
//                                    highResFaded = false
//                                    cdFadedDithered = false
//                                    sampleArraySet = true
//                                    //append new highresstd values
//                                    training_samples.append(contentsOf: highResStdSamples)
//                                    print("training_samples: \(training_samples)")
//                                }
//
//                            }
//                            .onChange(of: highResFaded) { highResFadedValue in
//                                sampleArraySet = false
//                                if highResFadedValue == true && sampleArraySet == false {
//                                    //remove array values
//                                    training_samples.removeAll()
//                                    //set other toggles to fales
//                                    highResStandard = false
//                                    cdFadedDithered = false
//                                    sampleArraySet = true
//                                    //append new highresstd values
//                                    training_samples.append(contentsOf: highResFadedSamples)
//                                    print("training_samples: \(training_samples)")
//                                }
//                            }
//                            .onChange(of: cdFadedDithered) { cdFadedDitheredValue in
//                                sampleArraySet = false
//                                if cdFadedDitheredValue == true && sampleArraySet == false {
//                                    //remove array values
//                                    training_samples.removeAll()
//                                    //set other toggles to fales
//                                    highResStandard = false
//                                    highResFaded = false
//                                    sampleArraySet = true
//                                    //append new highresstd values
//                                    training_samples.append(contentsOf: cdFadedDitheredSamples)
//                                    print("training_samples: \(training_samples)")
//                                }
//                            }
//                        }
                        
                        if trainingfullTestCompleted == false {
                            Spacer()
//                            Text("Next you will get a chance to experience what taking the test is like. You will hear a tone playing. Whenever you hear a tone playing, press the green button to indicate you have heard the tone.")
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .padding()
//                            Spacer()
                            HStack{
                                Spacer()
                                Text("Let's continue")
                                    .frame(width: 300, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .font(.title)
                                    .cornerRadius(24)
                                    .onTapGesture {
                                        trainingshowTestCompletionSheet.toggle()
                                    }
                                Spacer()
                            }
                        } else if trainingfullTestCompleted == true {
//                            Spacer()
//                            Text("Hopefully, you now have an idea of what you will hear and how to respond.")
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .padding()
//                            Spacer()
                            Text("Let's proceed with the test.")
                                .foregroundColor(.green)
                                .font(.title)
                                .padding()
                                .padding(.bottom, 20)
                            HStack{
                                Spacer()
                                Button {
//                                    P = TTS_Hearing_Test.Testing(id: 11.2, name: "1kHz Test", related: [])
                                    trainingTestCompleted = true
                                    trainingshowTestCompletionSheet.toggle()
                                } label: {
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200, height: 50, alignment: .center)
                                        .background(Color .green)
                                        .foregroundColor(.white)
                                        .cornerRadius(24)
                                }
                                Spacer()
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        Spacer()
                    }
                }
                
            })
            .navigationDestination(isPresented: $trainingTestCompleted, destination: {
                TrainingTestHoldingPlace(testing: testing, relatedLinkTesting: linkTesting)
            })
            //TTS_Hearing_Test.Testing(id: 11.2, name: "1kHz Test", related: [])
        }
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
        // This is the lowest CPU approach from many, many tries
        .onChange(of: traininglocalPlaying, perform: { trainingplayingValue in
            trainingactiveFrequency = training_samples[training_index]
            traininglocalHeard = 0
            traininglocalReversal = 0
            trainingTestStarted = true
            if trainingplayingValue == 1{
                
                if qualityOfService == 1 {
                    print("QOS Thread Background")
                    trainingaudioThreadBackground.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain)
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
                } else if qualityOfService == 2 {
                    print("QOS Thread Default")
                    trainingaudioThreadDefault.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain)
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
                } else if qualityOfService == 3 {
                    print("QOS Thread UserInteractive")
                    trainingaudioThreadUserInteractive.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain)
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
                } else if qualityOfService == 4 {
                    print("QOS Thread UserInitiated")
                    trainingaudioThreadUserInitiated.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain)
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
                } else {
                    print("QOS Thread Not Set, Catch Setting of Default")
                    trainingaudioThread.async {
                        trainingloadAndTestPresentation(sample: trainingactiveFrequency, gain: training_testGain)
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
                }
                
                
                trainingpreEventThread.async {
                    trainingpreEventLogging()
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                    if self.traininglocalHeard == 1 {
                        traininglocalTestCount += 1
                        trainingfullTestCompleted = trainingfullTestCompletedHoldingArray[training_index]
                        Task(priority: .userInitiated) {
                            await trainingresponseHeardArray()      //training_heardArray.append(1)
                            await traininglocalResponseTracking()
                            await trainingcount()
                            await traininglogNotPlaying()           //training_playing = -1
                            await trainingresetPlaying()
                            await trainingresetHeard()
                            await trainingresetNonResponseCount()
                            await trainingcreateReversalHeardArray()
                            await trainingcreateReversalGainArray()
                            await trainingcheckHeardReversalArrays()
                            await trainingreversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    }
                    else if training_heardArray.last == nil || self.traininglocalHeard == -1 {
                        traininglocalTestCount += 1
                        trainingfullTestCompleted = trainingfullTestCompletedHoldingArray[training_index]
                        Task(priority: .userInitiated) {
                            await trainingheardArrayNormalize()
                            await maxTrainingGainReachedReversal()
                            await trainingcount()
                            await traininglogNotPlaying()   //self.training_playing = -1
                            await trainingresetPlaying()
                            await trainingresetHeard()
                            await trainingnonResponseCounting()
                            await trainingcreateReversalHeardArray()
                            await createReversalGainArrayNonResponse()
                            await trainingcheckHeardReversalArrays()
                            await trainingreversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change    event
                        }
                    } else {
                        traininglocalTestCount = 1
                        trainingfullTestCompleted = trainingfullTestCompletedHoldingArray[training_index]
                        Task(priority: .background) {
                            await trainingresetPlaying()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(training_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: traininglocalReversal) { trainingreversalValue in
            if trainingreversalValue == 1 {
                DispatchQueue.global(qos: .background).async {
                    Task(priority: .userInitiated) {
                        await trainingreversalDirection()
                        await trainingreversalComplexAction()
                        await trainingreversalsCompleteLogging()
                        await trainingendTestSeries()
                        await trainingnewTestCycle()
                        await trainingrestartPresentation()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
    }
}
 
extension TrainingTestContent {
//MARK: - AudioPlayer Methods
    
    func trainingpauseRestartTestCycle() {
        traininglocalMarkNewTestCycle = 0
        traininglocalReversalEnd = 0
        training_index = training_index
        training_testGain = 0.0015       // Add code to reset starting test gain by linking to table of expected HL
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
      
  func trainingloadAndTestPresentation(sample: String, gain: Float) {
          do{
              let trainingurlSample = Bundle.main.path(forResource: trainingactiveFrequency, ofType: ".wav")
              guard let trainingurlSample = trainingurlSample else { return print(trainingSampleErrors.trainingnotFound) }
              trainingtestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: trainingurlSample))
              guard let trainingtestPlayer = trainingtestPlayer else { return }
              trainingtestPlayer.prepareToPlay()    // Test Player Prepare to Play
              trainingtestPlayer.setVolume(training_testGain, fadeDuration: 0)      // Set Gain for Playback
              trainingtestPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func trainingstop() {
      do{
          let trainingurlSample = Bundle.main.path(forResource: trainingactiveFrequency, ofType: ".wav")
          guard let trainingurlSample = trainingurlSample else { return print(trainingSampleErrors.trainingnotFound) }
          trainingtestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: trainingurlSample))
          guard let trainingtestPlayer = trainingtestPlayer else { return }
          trainingtestPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    func playTesting() async {
        do{
            let trainingurlSample = Bundle.main.path(forResource: trainingactiveFrequency, ofType: ".wav")
            guard let trainingurlSample = trainingurlSample else {
                return print(trainingSampleErrors.trainingnotFound) }
            trainingtestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: trainingurlSample))
            guard let trainingtestPlayer = trainingtestPlayer else { return }
            while trainingtestPlayer.isPlaying == true {
                if training_heardArray.count > 1 && training_heardArray.index(after: training_indexForTest.count-1) == 1 {
                    trainingtestPlayer.stop()
                print("Stopped in While") }
            }
            trainingtestPlayer.stop()
            print("Naturally Stopped")
        } catch { print("Error in playTesting") }
    }
    
    func trainingresetNonResponseCount() async {traininglocalSeriesNoResponses = 0 }
    
    func trainingnonResponseCounting() async {traininglocalSeriesNoResponses += 1 }
     
    func trainingresetPlaying() async { self.traininglocalPlaying = 0 }
    
    func traininglogNotPlaying() async { self.traininglocalPlaying = -1 }
    
    func trainingresetHeard() async { self.traininglocalHeard = 0 }
    
    func trainingreversalStart() async { self.traininglocalReversal = 1}
  
    func trainingpreEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//        DispatchQueue.global(qos: .userInitiated).async {
            training_indexForTest.append(training_index)
        }
        DispatchQueue.global(qos: .default).async {
            training_testTestGain.append(training_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            training_frequency.append(trainingactiveFrequency)
            training_testPan.append(training_pan)         // 0 = Left , 1 = Middle, 2 = Right
        }
    }
    
  
//MARK: -HeardArray Methods
    
    func trainingresponseHeardArray() async {
        training_heardArray.append(1)
        self.trainingidxHA = training_heardArray.count
        self.traininglocalStartingNonHeardArraySet = true
    }

    func traininglocalResponseTracking() async {
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
    
    func maxTrainingGainReachedReversal() async {
        if training_testGain >= 0.995 && trainingfirstHeardIsTrue == false && trainingsecondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            training_testTestGain.removeLast(1)
            //responseHeardArray
            trainingfirstHeardResponseIndex = traininglocalTestCount
            trainingfirstHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            training_testTestGain.append(1.0)
            // Local Response Tracking
            training_heardArray.append(1)
            self.trainingidxHA = training_heardArray.count
            self.traininglocalStartingNonHeardArraySet = true
            await trainingresetNonResponseCount()
            
            
            //run the rest of the functions to trigger next cycle
//            await count()
//            await logNotPlaying()           //envDataObjectModel_playing = -1
//            await resetPlaying()
//            await resetHeard()
//            await resetNonResponseCount()
//            await createReversalHeardArray()
//            await createReversalGainArray()
//            await checkHeardReversalArrays()
//            await reversalStart()
        } else if training_testGain >= 0.995 && trainingfirstHeardIsTrue == true && trainingsecondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            training_testTestGain.removeLast(1)
            //responseHeardArray
            trainingsecondHeardResponseIndex = traininglocalTestCount
            trainingsecondHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            training_testTestGain.append(1.0)
            // Local Response Tracking
            training_heardArray.append(1)
            self.trainingidxHA = training_heardArray.count
            self.traininglocalStartingNonHeardArraySet = true
            await trainingresetNonResponseCount()
            
            //run the rest of the functions to trigger next cycle
//            await count()
//            await logNotPlaying()           //envDataObjectModel_playing = -1
//            await resetPlaying()
//            await resetHeard()
//            await resetNonResponseCount()
//            await createReversalHeardArray()
//            await createReversalGainArray()
//            await checkHeardReversalArrays()
//            await reversalStart()
        }
    }
    
    
//MARK: - THIS FUNCTION IS CAUSING ISSUES IN HEARD ARRAY. THE ISSUE IS THE DUAL IF STRUCTURE, NOT LINKED BY ELSE IF
    func trainingheardArrayNormalize() async {
        if training_testGain < 0.995 {
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
            } else if traininglocalStartingNonHeardArraySet == true {
                if trainingisCountSame != 0 && trainingheardArrayIdxAfnet1 != 1 {
                    training_heardArray.append(0)
                    trainingidxHA = training_heardArray.count
                    trainingidxHAZero = trainingidxHA - trainingidxHA
                    trainingidxHAFirst = trainingidxHAZero + 1
                    trainingisCountSame = trainingidxHA - trainingidxForTest
                    trainingheardArrayIdxAfnet1 = training_heardArray.index(after: trainingidxForTestNet1)
                    
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
    func trainingcount() async {
        trainingidxTestCountUpdated = training_testCount.count + 1
        training_testCount.append(trainingidxTestCountUpdated)
    }
    
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }

}


extension TrainingTestContent {
//MARK: -Extension Methods Reversals
    enum trainingLastErrors: Error {
        case traininglastError
        case traininglastUnexpected(code: Int)
    }
    
    func trainingcreateReversalHeardArray() async {
        training_reversalHeard.append(training_heardArray[trainingidxHA-1])
        self.trainingidxReversalHeardCount = training_reversalHeard.count
    }
    
    func trainingcreateReversalGainArray() async {
        training_reversalGain.append(training_testTestGain[trainingidxHA-1])
    }
    
    func createReversalGainArrayNonResponse() async {
        if training_testGain < 0.995 {
            //        envDataObjectModel_reversalGain.append(envDataObjectModel_testTestGain[idxHA-1])
            training_reversalGain.append(training_testGain)
        } else if training_testGain >= 0.995 {
            training_reversalGain.append(1.0)
        }
    }
    
    func trainingcheckHeardReversalArrays() async {
        if trainingidxHA - trainingidxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if trainingidxHA - trainingidxReversalHeardCount < 0 && trainingidxHA - trainingidxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    func trainingreversalDirection() async {
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
    
    func trainingreversalOfOne() async {
        let trainingrO1Direction = 0.001 * training_reversalDirection
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
    
    func trainingreversalOfTwo() async {
        let trainingrO2Direction = 0.002 * training_reversalDirection
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
    
    func trainingreversalOfThree() async {
        let trainingrO3Direction = 0.003 * training_reversalDirection
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
    
    func trainingreversalOfFour() async {
        let trainingrO4Direction = 0.004 * training_reversalDirection
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
    
    func trainingreversalOfFive() async {
        let trainingrO5Direction = 0.005 * training_reversalDirection
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
    
    func trainingreversalOfTen() async {
        let trainingr10Direction = 0.007 * training_reversalDirection
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
    
    func trainingreversalAction() async {
        if traininglocalReversalHeardLast == 1 {
            await trainingreversalOfFive()
        } else if traininglocalReversalHeardLast == 0 {
            await trainingreversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func trainingreversalComplexAction() async {
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
    
    
    func trainingreversalHeardCount1() async {
        await trainingreversalAction()
    }
    
    func trainingcheck2PositiveSeriesReversals() async {
        if training_reversalHeard[trainingidxHA-2] == 1 && training_reversalHeard[trainingidxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }
    
    func trainingcheckTwoNegativeSeriesReversals() async {
        if training_reversalHeard.count >= 3 && training_reversalHeard[trainingidxHA-2] == 0 && training_reversalHeard[trainingidxHA-1] == 0 {
            await trainingreversalOfFour()
        } else {
            await trainingreversalAction()
        }
    }
    
    func trainingstartTooHighCheck() async {
        if trainingstartTooHigh == 0 && trainingfirstHeardIsTrue == true && trainingsecondHeardIsTrue == true {
            trainingstartTooHigh = 1
            await trainingreversalOfTen()
            await trainingresetAfterTooHigh()
            print("Too High Found")
        } else {
            await trainingreversalAction()
        }
    }
    
    func trainingresetAfterTooHigh() async {
        trainingfirstHeardResponseIndex = Int()
        trainingfirstHeardIsTrue = false
        trainingsecondHeardResponseIndex = Int()
        trainingsecondHeardIsTrue = false
    }
    
    func trainingreversalsCompleteLogging() async {
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
    
    
    func trainingrestartPresentation() async {
        if trainingendTestSeriesValue == false {//}&& traininguserPausedTest == false {
            traininglocalPlaying = 1
            trainingendTestSeriesValue = false
        } else if trainingendTestSeriesValue == true {//} && traininguserPausedTest == true {
            traininglocalPlaying = -1
            trainingendTestSeriesValue = true
            trainingshowTestCompletionSheet = true
            trainingplayingStringColorIndex = 2
        } else {
            traininglocalPlaying = 1
            trainingendTestSeriesValue = false
            print("!!! Critical Error in trainingRestartPresentation() Logic")
        }
    }
    
    func trainingwipeArrays() async {
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
    
    func startNextTestCycle() async {
        await trainingwipeArrays()
        trainingshowTestCompletionSheet.toggle()
        trainingstartTooHigh = 0
        traininglocalMarkNewTestCycle = 0
        traininglocalReversalEnd = 0
        training_index = training_index + 1
        //        envDataObjectModel_eptaSamplesCountArrayIdx += 1
        training_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        trainingendTestSeriesValue = false
        trainingshowTestCompletionSheet = false
        trainingtestIsPlaying = true
        traininguserPausedTest = false
        trainingplayingStringColorIndex = 2
        //        envDataObjectModel_eptaSamplesCount = envDataObjectModel_eptaSamplesCount + 8
        print(training_SamplesCountArray[training_index])
        traininglocalPlaying = 1
    }
    
    func trainingnewTestCycle() async {
        if traininglocalMarkNewTestCycle == 1 && traininglocalReversalEnd == 1 && training_index < training_SamplesCountArray[training_index] && trainingendTestSeriesValue == false {
            trainingstartTooHigh = 0
            traininglocalMarkNewTestCycle = 0
            traininglocalReversalEnd = 0
            training_index = training_index + 1
            training_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
            trainingendTestSeriesValue = false
            //                Task(priority: .userInitiated) {
            await trainingwipeArrays()
            //                }
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
    
    func trainingendTestSeries() async {
        if trainingendTestSeriesValue == false {
            //Do Nothing and continue
            print("end Test Series = \(trainingendTestSeriesValue)")
        } else if trainingendTestSeriesValue == true {
            trainingshowTestCompletionSheet = true
            training_eptaSamplesCount = training_eptaSamplesCount + 1
            await trainingendTestSeriesStop()
        }
    }
    
    func trainingendTestSeriesStop() async {
        traininglocalPlaying = -1
        trainingstop()
        traininguserPausedTest = true
        trainingplayingStringColorIndex = 2
    }
}

//struct TrainingTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainingTestView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
