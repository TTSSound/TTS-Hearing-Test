//
//  EHATTSTestPart1View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/1/22.
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


struct SaveFinalResults: Codable {  // This is a model
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



struct EHATTSTestPart1View: View {
    enum SampleErrors: Error {
        case notFound
        case unexpected(code: Int)
    }
    
    enum FirebaseErrors: Error {
        case unknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()

    @State var localHeard = 0
    @State var localPlaying = Int()    // Playing = 1. Stopped = -1
    @State var localReversal = Int()
    @State var localReversalEnd = Int()
    @State var localMarkNewTestCycle = Int()
    @State var testPlayer: AVAudioPlayer?
    
    @State var localTestCount = 0
    @State var localStartingNonHeardArraySet: Bool = false
    @State var localReversalHeardLast = Int()
    @State var localSeriesNoResponses = Int()
    @State var firstHeardResponseIndex = Int()
    @State var firstHeardIsTrue: Bool = false
    @State var secondHeardResponseIndex = Int()
    @State var secondHeardIsTrue: Bool = false
    @State var startTooHigh = 0
    @State var firstGain = Float()
    @State var secondGain = Float()
    @State var endTestSeries: Bool = false
    @State var showTestCompletionSheet: Bool = false
    
//    @State var envDataObjectModel_samples: [String] = ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    
    @State var envDataObjectModel_samples: [String] = ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8",
                                                       "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8",
                                                       "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16",
                                                       "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
                        @State var panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                                        -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
                                                        1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                                        -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    @State var totalCount = 32
    @State var localPan = Float()
    
    // Presentation Cycles
    // Cycle 1 Right: ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8"]  // panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    // Cycle 2 Left: ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8"]   // panArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    // Cycle 3 Right: ["Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]   // panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    // Cycle 4 Left: ["Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]    //panArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
    
//    rightFinalGain"\(activeFrequency)"
    @State var rightFinalGainSample1 = Float()
    @State var rightFinalGainSample2 = Float()
    @State var rightFinalGainSample3 = Float()
    @State var rightFinalGainSample4 = Float()
    @State var rightFinalGainSample5 = Float()
    @State var rightFinalGainSample6 = Float()
    @State var rightFinalGainSample7 = Float()
    @State var rightFinalGainSample8 = Float()
    @State var rightFinalGainSample9 = Float()
    @State var rightFinalGainSample10 = Float()
    @State var rightFinalGainSample11 = Float()
    @State var rightFinalGainSample12 = Float()
    @State var rightFinalGainSample13 = Float()
    @State var rightFinalGainSample14 = Float()
    @State var rightFinalGainSample15 = Float()
    @State var rightFinalGainSample16 = Float()
    
    @State var leftFinalGainSample1 = Float()
    @State var leftFinalGainSample2 = Float()
    @State var leftFinalGainSample3 = Float()
    @State var leftFinalGainSample4 = Float()
    @State var leftFinalGainSample5 = Float()
    @State var leftFinalGainSample6 = Float()
    @State var leftFinalGainSample7 = Float()
    @State var leftFinalGainSample8 = Float()
    @State var leftFinalGainSample9 = Float()
    @State var leftFinalGainSample10 = Float()
    @State var leftFinalGainSample11 = Float()
    @State var leftFinalGainSample12 = Float()
    @State var leftFinalGainSample13 = Float()
    @State var leftFinalGainSample14 = Float()
    @State var leftFinalGainSample15 = Float()
    @State var leftFinalGainSample16 = Float()
    
    @State var rightFinalGainsArray = [Float]()
    @State var leftFinalGainsArray = [Float]()
    @State var finalStoredRightFinalGainsArray = [Float]()
    @State var finalStoredleftFinalGainsArray = [Float]()
    
    
    
    
    @State var envDataObjectModel_index: Int = 0
    @State var envDataObjectModel_testGain: Float = 0.2
    @State var envDataObjectModel_heardArray: [Int] = [Int]()
    @State var envDataObjectModel_indexForTest = [Int]()
    @State var envDataObjectModel_testCount: [Int] = [Int]()
    @State var envDataObjectModel_pan: Int = Int()
    @State var envDataObjectModel_testPan = [Int]()
    @State var envDataObjectModel_testTestGain = [Float]()
    @State var envDataObjectModel_frequency = [String]()
    @State var envDataObjectModel_reversalHeard = [Int]()
    @State var envDataObjectModel_reversalGain = [Float]()
    @State var envDataObjectModel_reversalFrequency = [String]()
    @State var envDataObjectModel_reversalDirection = Float()
    @State var envDataObjectModel_reversalDirectionArray = [Float]()

    @State var envDataObjectModel_averageGain = Float()

    @State var envDataObjectModel_eptaSamplesCount = 0 //17
    @State var envDataObjectModel_eptaSamplesCountArray = [8, 16, 24, 32]
    @State var envDataObjectModel_eptaSamplesCountArrayIdx = 0  //[0, 1, 2, 3]
    
    @State var envDataObjectModel_finalStoredIndex: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredTestPan: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredTestTestGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredFrequency: [String] = [String]()
    @State var envDataObjectModel_finalStoredTestCount: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredHeardArray: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredReversalHeard: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredFirstGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredSecondGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredAverageGain: [Float] = [Float]()
    
    @State var idxForTest = Int() // = envDataObjectModel_indexForTest.count
    @State var idxForTestNet1 = Int() // = envDataObjectModel_indexForTest.count - 1
    @State var idxTestCount = Int() // = envDataObjectModel_TestCount.count
    @State var idxTestCountUpdated = Int() // = envDataObjectModel_TestCount.count + 1
    @State var activeFrequency = String()
    @State var idxHA = Int()    // idx = envDataObjectModel_heardArray.count
    @State var idxReversalHeardCount = Int()
    @State var idxHAZero = Int()    //  idxZero = idx - idx
    @State var idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var isCountSame = Int()
    @State var heardArrayIdxAfnet1 = Int()
    @State var testIsPlaying: Bool = false
    @State var playingString: [String] = ["", "Start or Restart Test", "Great Job, You've Completed This Test Segment"]
    @State var playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    @State var playingStringColorIndex = 0
    @State var userPausedTest: Bool = false

    let fileEHAP1Name = "SummaryEHAP1Results.json"
    let summaryEHAP1CSVName = "SummaryEHAP1ResultsCSV.csv"
    let detailedEHAP1CSVName = "DetailedEHAP1ResultsCSV.csv"
    let inputEHAP1SummaryCSVName = "InputSummaryEHAP1ResultsCSV.csv"
    let inputEHAP1DetailedCSVName = "InputDetailedEHAP1ResultsCSV.csv"
    let summaryEHAP1LRCSVName = "SummaryEHAP1LRResultsCSV.csv"
    let summaryEHAP1RightCSVName = "SummaryEHAP1RightResultsCSV.csv"
    let summaryEHAP1LeftCSVName = "SummaryEHAP1LeftResultsCSV.csv"
    let inputEHAP1LRSummaryCSVName = "InputDetailedEHAP1LRResultsCSV.csv"
    let inputEHAP1RightSummaryCSVName = "InputDetailedEHAP1RightResultsCSV.csv"
    let inputEHAP1LeftSummaryCSVName = "InputDetailedEHAP1LeftResultsCSV.csv"
    
    
    @State var saveFinalResults: SaveFinalResults? = nil

    let heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    var body: some View {
        
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .top, startRadius: -10, endRadius: 300).ignoresSafeArea()
        VStack {
                Spacer()
            Text("EHA Part 1 / EPTA Test")
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.bottom, 40)
                HStack {
                    Spacer()
                    Text(String(envDataObjectModel_testGain))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    Spacer()
                    Button {
                        envDataObjectModel_heardArray.removeAll()
                        pauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        localPlaying = 1
                        userPausedTest = false
                        playingStringColorIndex = 0
                        print("Start Button Clicked. Playing = \(localPlaying)")
                    } label: {
                        Text(playingString[playingStringColorIndex])
                            .foregroundColor(playingStringColor[playingStringColorIndex])
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
                                localPlaying = 1
                                print("Start Button Clicked. Playing = \(localPlaying)")
                            }
                        }
                    Spacer()
                    Button {
                        localPlaying = 0
                        stop()
                        userPausedTest = true
                        playingStringColorIndex = 1
                        audioThread.async {
                            localPlaying = 0
                            stop()
                            userPausedTest = true
                            playingStringColorIndex = 1
                        }
                        DispatchQueue.main.async {
                            localPlaying = 0
                            stop()
                            userPausedTest = true
                            playingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
                            localPlaying = 0
                            stop()
                            userPausedTest = true
                            playingStringColorIndex = 1
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
                    heardThread.async{ self.localHeard = 1
                    }
                }
            Spacer()
            }
            .fullScreenCover(isPresented: $showTestCompletionSheet, content: {
                VStack(alignment: .leading) {
    
                    Button(action: {
                        showTestCompletionSheet.toggle()
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
        .onChange(of: testIsPlaying, perform: { testBoolValue in
            if testBoolValue == true && endTestSeries == false {
            //User is starting test for first time
                audioSessionModel.setAudioSession()
                localPlaying = 1
                playingStringColorIndex = 0
                userPausedTest = false
            } else if testBoolValue == false && endTestSeries == false {
            // User is pausing test for firts time
                stop()
                localPlaying = 0
                playingStringColorIndex = 1
                userPausedTest = true
            } else if testBoolValue == true && endTestSeries == true {
                stop()
                localPlaying = -1
                playingStringColorIndex = 2
                userPausedTest = true
            } else {
                print("Critical error in pause logic")
            }
        })
        // This is the lowest CPU approach from many, many tries
        .onChange(of: localPlaying, perform: { playingValue in
            activeFrequency = envDataObjectModel_samples[envDataObjectModel_index]
            localHeard = 0
            localReversal = 0
            if playingValue == 1{
                
                setPan()
                
                audioThread.async {
                    loadAndTestPresentation(sample: activeFrequency, gain: envDataObjectModel_testGain, pan: localPan)
                    while testPlayer!.isPlaying == true && self.localHeard == 0 { }
                    if localHeard == 1 {
                        testPlayer!.stop()
                        print("Stopped in while if: Returned Array \(localHeard)")
                    } else {
                    testPlayer!.stop()
                    self.localHeard = -1
                    print("Stopped naturally: Returned Array \(localHeard)")
                    }
                }
                preEventThread.async {
                    preEventLogging()
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                    if self.localHeard == 1 {
                        localTestCount += 1
                        Task(priority: .userInitiated) {
                            await responseHeardArray()      //envDataObjectModel_heardArray.append(1)
                            await localResponseTracking()
                            await count()
                            await logNotPlaying()           //envDataObjectModel_playing = -1
                            await resetPlaying()
                            await resetHeard()
                            await resetNonResponseCount()
                            await createReversalHeardArray()
                            await createReversalGainArray()
                            await checkHeardReversalArrays()
                            await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    }
                    else if envDataObjectModel_heardArray.last == nil || self.localHeard == -1 {
                        localTestCount += 1
                        Task(priority: .userInitiated) {
                            await heardArrayNormalize()
                            await count()
                            await logNotPlaying()   //self.envDataObjectModel_playing = -1
                            await resetPlaying()
                            await resetHeard()
                            await nonResponseCounting()
                            await createReversalHeardArray()
                            await createReversalGainArray()
                            await checkHeardReversalArrays()
                            await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    } else {
                        localTestCount = 1
                        Task(priority: .background) {
                            await resetPlaying()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(envDataObjectModel_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: localReversal) { reversalValue in
            if reversalValue == 1 {
                DispatchQueue.global(qos: .background).async {
                    Task(priority: .userInitiated) {
//                        await createReversalHeardArray()
//                        await createReversalGainArray()
//                        await checkHeardReversalArrays()
                        await reversalDirection()
                        await reversalComplexAction()
                        await reversalsCompleteLogging()
//                        await printReversalGain()
//                        await printData()
//                        await printReversalData()
                        await concatenateFinalArrays()
//                        await printConcatenatedArrays()
                        await saveFinalStoredArrays()
                        await endTestSeries()
                        await newTestCycle()
                        await restartPresentation()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
    }
 
    
//MARK: - AudioPlayer Methods
    
    func pauseRestartTestCycle() {
        localMarkNewTestCycle = 0
        localReversalEnd = 0
        envDataObjectModel_index = envDataObjectModel_index
        envDataObjectModel_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        testIsPlaying = false
        localPlaying = 0
        envDataObjectModel_testCount.removeAll()
        envDataObjectModel_reversalHeard.removeAll()
        envDataObjectModel_averageGain = Float()
        envDataObjectModel_reversalDirection = Float()
        localStartingNonHeardArraySet = false
        firstHeardResponseIndex = Int()
        firstHeardIsTrue = false
        secondHeardResponseIndex = Int()
        secondHeardIsTrue = false
        localTestCount = 0
        localReversalHeardLast = Int()
        startTooHigh = 0
    }
    
    func setPan() {
        localPan = panArray[envDataObjectModel_index]
        print("Pan: \(localPan)")
    }

    func loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
          do{
              let urlSample = Bundle.main.path(forResource: activeFrequency, ofType: ".wav")
              guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
              testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
              guard let testPlayer = testPlayer else { return }
              testPlayer.prepareToPlay()    // Test Player Prepare to Play
              testPlayer.setVolume(envDataObjectModel_testGain, fadeDuration: 0.01)      // Set Gain for Playback
              testPlayer.pan = localPan
              testPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func stop() {
      do{
          let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
          testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
          guard let testPlayer = testPlayer else { return }
          testPlayer.setVolume(0, fadeDuration: 0.01)
          testPlayer.stop()
          
      } catch { print("Error in Player Stop Function") }
  }
    
    func playTesting() async {
        do{
            let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
            guard let urlSample = urlSample else {
                return print(SampleErrors.notFound) }
            testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
            guard let testPlayer = testPlayer else { return }
            while testPlayer.isPlaying == true {
                if envDataObjectModel_heardArray.count > 1 && envDataObjectModel_heardArray.index(after: envDataObjectModel_indexForTest.count-1) == 1 {
                testPlayer.stop()
                print("Stopped in While") }
            }
            testPlayer.stop()
            print("Naturally Stopped")
        } catch { print("Error in playTesting") }
    }
    
    func resetNonResponseCount() async {localSeriesNoResponses = 0 }
    
    func nonResponseCounting() async {localSeriesNoResponses += 1 }
     
    func resetPlaying() async { self.localPlaying = 0 }
    
    func logNotPlaying() async { self.localPlaying = -1 }
    
    func resetHeard() async { self.localHeard = 0 }
    
    func reversalStart() async { self.localReversal = 1}
  
    func preEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//        DispatchQueue.global(qos: .userInitiated).async {
            envDataObjectModel_indexForTest.append(envDataObjectModel_index)
        }
        DispatchQueue.global(qos: .default).async {
            envDataObjectModel_testTestGain.append(envDataObjectModel_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            envDataObjectModel_frequency.append(activeFrequency)
            envDataObjectModel_testPan.append(envDataObjectModel_pan)         // 0 = Left , 1 = Middle, 2 = Right
        }
    }
    
  
//MARK: -HeardArray Methods
    
    func responseHeardArray() async {
      envDataObjectModel_heardArray.append(1)
      self.idxHA = envDataObjectModel_heardArray.count
      self.localStartingNonHeardArraySet = true
    }

    func localResponseTracking() async {
        if firstHeardIsTrue == false {
            firstHeardResponseIndex = localTestCount
            firstHeardIsTrue = true
        } else if firstHeardIsTrue == true {
            secondHeardResponseIndex = localTestCount
            secondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
//MARK: - THIS FUNCTION IS CAUSING ISSUES IN HEARD ARRAY. THE ISSUE IS THE DUAL IF STRUCTURE, NOT LINKED BY ELSE IF
    func heardArrayNormalize() async {
        idxHA = envDataObjectModel_heardArray.count
        idxForTest = envDataObjectModel_indexForTest.count
        idxForTestNet1 = idxForTest - 1
        isCountSame = idxHA - idxForTest
        heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)
      
        if localStartingNonHeardArraySet == false {
            envDataObjectModel_heardArray.append(0)
            self.localStartingNonHeardArraySet = true
            idxHA = envDataObjectModel_heardArray.count
            idxHAZero = idxHA - idxHA
            idxHAFirst = idxHAZero + 1
            isCountSame = idxHA - idxForTest
            heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)
        } else if localStartingNonHeardArraySet == true {
            if isCountSame != 0 && heardArrayIdxAfnet1 != 1 {
                envDataObjectModel_heardArray.append(0)
                idxHA = envDataObjectModel_heardArray.count
                idxHAZero = idxHA - idxHA
                idxHAFirst = idxHAZero + 1
                isCountSame = idxHA - idxForTest
                heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)

            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
        } else {
            print("Critial Error in Heard Array Count and or Values")
        }
    }
      
// MARK: -Logging Methods
    func count() async {
        idxTestCountUpdated = envDataObjectModel_testCount.count + 1
        envDataObjectModel_testCount.append(idxTestCountUpdated)
    }
    
//    func arrayTesting() async {
//        let arraySet1 = Int(envDataObjectModel_testPan.count)
//        let arraySet2 = Int(envDataObjectModel_testTestGain.count) - Int(envDataObjectModel_frequency.count) + Int(envDataObjectModel_testCount.count) - Int(envDataObjectModel_heardArray.count)
//        if arraySet1 + arraySet2 == 0 {
//            print("All Event Logs Match")
//        } else {
//            print("Error Event Logs Length Error")
//        }
//    }
    
    func printData () async {
        DispatchQueue.global(qos: .background).async {
            print("Start printData)(")
            print("--------Array Values Logged-------------")
            print("testPan: \(envDataObjectModel_testPan)")
            print("testTestGain: \(envDataObjectModel_testTestGain)")
            print("frequency: \(envDataObjectModel_frequency)")
            print("testCount: \(envDataObjectModel_testCount)")
            print("heardArray: \(envDataObjectModel_heardArray)")
            print("---------------------------------------")
        }
    }
}

//MARK: - Preview View Struct

//struct EHATTSTestPart1View_Previews: PreviewProvider {
//    static var previews: some View {
//        EHATTSTestPart1View()
//    }
//}


//MARK: - Reversal Extension
extension EHATTSTestPart1View {
    enum LastErrors: Error {
        case lastError
        case lastUnexpected(code: Int)
    }

    func createReversalHeardArray() async {
        envDataObjectModel_reversalHeard.append(envDataObjectModel_heardArray[idxHA-1])
        self.idxReversalHeardCount = envDataObjectModel_reversalHeard.count
    }
        
    func createReversalGainArray() async {
        envDataObjectModel_reversalGain.append(envDataObjectModel_testTestGain[idxHA-1])
    }
    
    func checkHeardReversalArrays() async {
        if idxHA - idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if idxHA - idxReversalHeardCount < 0 && idxHA - idxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    func reversalDirection() async {
        localReversalHeardLast = envDataObjectModel_reversalHeard.last ?? -999
        if localReversalHeardLast == 1 {
            envDataObjectModel_reversalDirection = -1.0
            envDataObjectModel_reversalDirectionArray.append(-1.0)
        } else if localReversalHeardLast == 0 {
            envDataObjectModel_reversalDirection = 1.0
            envDataObjectModel_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    func reversalOfOne() async {
        let rO1Direction = 0.01 * envDataObjectModel_reversalDirection
        let r01NewGain = envDataObjectModel_testGain + rO1Direction
        if r01NewGain > 0.00001 && r01NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r01NewGain * 100000) / 100000
        } else if r01NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r01NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func reversalOfTwo() async {
        let rO2Direction = 0.02 * envDataObjectModel_reversalDirection
        let r02NewGain = envDataObjectModel_testGain + rO2Direction
        if r02NewGain > 0.00001 && r02NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r02NewGain * 100000) / 100000
        } else if r02NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r02NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    func reversalOfThree() async {
        let rO3Direction = 0.03 * envDataObjectModel_reversalDirection
        let r03NewGain = envDataObjectModel_testGain + rO3Direction
        if r03NewGain > 0.00001 && r03NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r03NewGain * 100000) / 100000
        } else if r03NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r03NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    func reversalOfFour() async {
        let rO4Direction = 0.04 * envDataObjectModel_reversalDirection
        let r04NewGain = envDataObjectModel_testGain + rO4Direction
        if r04NewGain > 0.00001 && r04NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r04NewGain * 100000) / 100000
        } else if r04NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r04NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    func reversalOfFive() async {
        let rO5Direction = 0.05 * envDataObjectModel_reversalDirection
        let r05NewGain = envDataObjectModel_testGain + rO5Direction
        if r05NewGain > 0.00001 && r05NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r05NewGain * 100000) / 100000
        } else if r05NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r05NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    func reversalOfTen() async {
        let r10Direction = 0.10 * envDataObjectModel_reversalDirection
        let r10NewGain = envDataObjectModel_testGain + r10Direction
        if r10NewGain > 0.00001 && r10NewGain < 1.0 {
            envDataObjectModel_testGain = roundf(r10NewGain * 100000) / 100000
        } else if r10NewGain <= 0.0 {
            envDataObjectModel_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if r10NewGain >= 1.0 {
            envDataObjectModel_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    func reversalAction() async {
        if localReversalHeardLast == 1 {
            await reversalOfFive()
        } else if localReversalHeardLast == 0 {
            await reversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func reversalComplexAction() async {
        if idxReversalHeardCount <= 1 && idxHA <= 1 {
            await reversalAction()
        }  else if idxReversalHeardCount == 2 {
            if idxReversalHeardCount == 2 && secondHeardIsTrue == true {
                await startTooHighCheck()
            } else if idxReversalHeardCount == 2  && secondHeardIsTrue == false {
                await reversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if idxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if secondHeardResponseIndex - firstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if localSeriesNoResponses == 3 {
                await reversalOfTen()
            } else if localSeriesNoResponses == 2 {
                await reversalOfFour()
            } else {
                await reversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    func printReversalGain() async {
        DispatchQueue.global(qos: .background).async {
            print("New Gain: \(envDataObjectModel_testGain)")
            print("Reversal Direcction: \(envDataObjectModel_reversalDirection)")
        }
    }
    
    func reversalHeardCount1() async {
       await reversalAction()
   }
            
    func check2PositiveSeriesReversals() async {
        if envDataObjectModel_reversalHeard[idxHA-2] == 1 && envDataObjectModel_reversalHeard[idxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }

    func checkTwoNegativeSeriesReversals() async {
        if envDataObjectModel_reversalHeard.count >= 3 && envDataObjectModel_reversalHeard[idxHA-2] == 0 && envDataObjectModel_reversalHeard[idxHA-1] == 0 {
            await reversalOfFour()
        } else {
            await reversalAction()
        }
    }
    
    func startTooHighCheck() async {
        if startTooHigh == 0 && firstHeardIsTrue == true && secondHeardIsTrue == true {
            startTooHigh = 1
            await reversalOfTen()
            await resetAfterTooHigh()
            print("Too High Found")
        } else {
            await reversalAction()
        }
    }
    
    func resetAfterTooHigh() async {
        firstHeardResponseIndex = Int()
        firstHeardIsTrue = false
        secondHeardResponseIndex = Int()
        secondHeardIsTrue = false
    }

    func reversalsCompleteLogging() async {
        if secondHeardIsTrue == true {
            self.localReversalEnd = 1
            self.localMarkNewTestCycle = 1
            self.firstGain = envDataObjectModel_reversalGain[firstHeardResponseIndex-1]
            self.secondGain = envDataObjectModel_reversalGain[secondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let delta = firstGain - secondGain
            let avg = (firstGain + secondGain)/2
            
            if delta == 0 {
                envDataObjectModel_averageGain = secondGain
                print("average Gain: \(envDataObjectModel_averageGain)")
            } else if delta >= 0.05 {
                envDataObjectModel_averageGain = secondGain
                print("SecondGain: \(firstGain)")
                print("SecondGain: \(secondGain)")
                print("average Gain: \(envDataObjectModel_averageGain)")
            } else if delta <= -0.05 {
                envDataObjectModel_averageGain = firstGain
                print("SecondGain: \(firstGain)")
                print("SecondGain: \(secondGain)")
                print("average Gain: \(envDataObjectModel_averageGain)")
            } else if delta < 0.05 && delta > -0.05 {
                envDataObjectModel_averageGain = avg
                print("SecondGain: \(firstGain)")
                print("SecondGain: \(secondGain)")
                print("average Gain: \(envDataObjectModel_averageGain)")
            } else {
                envDataObjectModel_averageGain = avg
                print("SecondGain: \(firstGain)")
                print("SecondGain: \(secondGain)")
                print("average Gain: \(envDataObjectModel_averageGain)")
            }
        } else if secondHeardIsTrue == false {
                print("Contine, second hear is true = false")
        } else {
                print("Critical error in reversalsCompletLogging Logic")
        }
    }
    
//    activeFrequency
//    envDataObjectModel_averageGain
//    localPan
//    envDataObjectModel_index
    
    func assignLRAverageSampleGains() async {
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 && localPan == 1.0 {
            //go through each assignment based on index
            if envDataObjectModel_index == 0 {
                rightFinalGainSample1 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample1)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 1 {
                rightFinalGainSample2 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample2)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 2 {
                rightFinalGainSample3 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample3)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 3 {
                rightFinalGainSample4 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample4)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 4 {
                rightFinalGainSample5 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample5)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 5 {
                rightFinalGainSample6 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample6)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 6 {
                rightFinalGainSample7 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample7)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 7 {
                rightFinalGainSample8 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample8)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 16 {
                rightFinalGainSample9 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample9)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 17 {
                rightFinalGainSample10 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample10)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 18 {
                rightFinalGainSample11 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample11)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 19 {
                rightFinalGainSample12 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample12)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 20 {
                rightFinalGainSample13 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample13)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 21 {
                rightFinalGainSample14 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample14)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 22 {
                rightFinalGainSample15 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample15)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else if envDataObjectModel_index == 23 {
                rightFinalGainSample16 = envDataObjectModel_averageGain
                rightFinalGainsArray.append(rightFinalGainSample16)
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
            } else {
                print("*** rightFinalGainsArray: \(rightFinalGainsArray)")
                fatalError("In right side assignLRAverageSampleGains")
            }
        } else if localMarkNewTestCycle == 1 && localReversalEnd == 1 && localPan == -1.0 {
            //Left Side. Go Through Each Assignment based on index for sample
            if envDataObjectModel_index == 8 {
                leftFinalGainSample1 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample1)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 9 {
                leftFinalGainSample2 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample2)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 10 {
                leftFinalGainSample3 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample3)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 11 {
                leftFinalGainSample4 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample4)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 12 {
                leftFinalGainSample5 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample5)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 13 {
                leftFinalGainSample6 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample6)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 14 {
                leftFinalGainSample7 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample7)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 15 {
                leftFinalGainSample8 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample8)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 24 {
                leftFinalGainSample9 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample9)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 25 {
                leftFinalGainSample10 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample10)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 26 {
                leftFinalGainSample11 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample11)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 27 {
                leftFinalGainSample12 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample12)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 28 {
                leftFinalGainSample13 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample13)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 29 {
                leftFinalGainSample14 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample14)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 30 {
                leftFinalGainSample15 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample15)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else if envDataObjectModel_index == 31 {
                leftFinalGainSample16 = envDataObjectModel_averageGain
                leftFinalGainsArray.append(leftFinalGainSample16)
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
            } else {
                print("*** leftFinalGainsArray: \(leftFinalGainsArray)")
                fatalError("In left side assignLRAverageSampleGains")
            }
        } else {
            // No ready to log yet
            print("Coninue, not ready to log in assignLRAverageSampleGains")
        }

    }

    func printReversalData() async {
        print("--------Reversal Values Logged-------------")
        print("indexForTest: \(envDataObjectModel_indexForTest)")
        print("Test Pan: \(envDataObjectModel_testPan)")
        print("New TestGain: \(envDataObjectModel_testTestGain)")
        print("reversalFrequency: \(activeFrequency)")
        print("testCount: \(envDataObjectModel_testCount)")
        print("heardArray: \(envDataObjectModel_heardArray)")
        print("reversalHeard: \(envDataObjectModel_reversalHeard)")
        print("FirstGain: \(firstGain)")
        print("SecondGain: \(secondGain)")
        print("AverageGain: \(envDataObjectModel_averageGain)")
        print("------------------------------------------")
    }
        
    func restartPresentation() async {
        if endTestSeries == false {
            localPlaying = 1
            endTestSeries = false
        } else if endTestSeries == true {
            localPlaying = -1
            endTestSeries = true
            showTestCompletionSheet = true
            playingStringColorIndex = 2
        }
    }
    
    func wipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            envDataObjectModel_heardArray.removeAll()
            envDataObjectModel_testCount.removeAll()
            envDataObjectModel_reversalHeard.removeAll()
            envDataObjectModel_averageGain = Float()
            envDataObjectModel_reversalDirection = Float()
            localStartingNonHeardArraySet = false
            firstHeardResponseIndex = Int()
            firstHeardIsTrue = false
            secondHeardResponseIndex = Int()
            secondHeardIsTrue = false
            localTestCount = 0
            localReversalHeardLast = Int()
            startTooHigh = 0
            localSeriesNoResponses = Int()
        })
    }
    
    func newTestCycle() async {
//        if localMarkNewTestCycle == 1 && localReversalEnd == 1 && envDataObjectModel_index < envDataObjectModel_eptaSamplesCount && endTestSeries == false {
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 && envDataObjectModel_index < envDataObjectModel_eptaSamplesCountArray[envDataObjectModel_eptaSamplesCount] && endTestSeries == false {
            startTooHigh = 0
            localMarkNewTestCycle = 0
            localReversalEnd = 0
            envDataObjectModel_index = envDataObjectModel_index + 1
            envDataObjectModel_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
            endTestSeries = false
            await wipeArrays()
//        } else if localMarkNewTestCycle == 1 && localReversalEnd == 1 && envDataObjectModel_index == envDataObjectModel_eptaSamplesCount && endTestSeries == false {
        } else if localMarkNewTestCycle == 1 && localReversalEnd == 1 && envDataObjectModel_index == envDataObjectModel_eptaSamplesCountArray[envDataObjectModel_eptaSamplesCount] && endTestSeries == false {
                endTestSeries = true
                localPlaying = -1
                envDataObjectModel_eptaSamplesCount += 1
                print("=============================")
                print("!!!!! End of Test Series!!!!!!")
                print("=============================")
        } else {
//                print("Reversal Limit Not Hit")

        }
    }
    
    func endTestSeries() async {
        if endTestSeries == false {
            //Do Nothing and continue
            print("end Test Series = \(endTestSeries)")
        } else if endTestSeries == true {
            showTestCompletionSheet = true
            await endTestSeriesStop()
        }
    }
    
    func endTestSeriesStop() async {
        localPlaying = -1
        stop()
        userPausedTest = true
        playingStringColorIndex = 2
        
        audioThread.async {
            localPlaying = 0
            stop()
            userPausedTest = true
            playingStringColorIndex = 2
        }
        
        DispatchQueue.main.async {
            localPlaying = 0
            stop()
            userPausedTest = true
            playingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
            localPlaying = 0
            stop()
            userPausedTest = true
            playingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInitiated) {
            localPlaying = -1
            stop()
            userPausedTest = true
            playingStringColorIndex = 2
        }
    }
    
    func concatenateFinalArrays() async {
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
            envDataObjectModel_finalStoredIndex.append(contentsOf: [100000000] + envDataObjectModel_indexForTest)
            envDataObjectModel_finalStoredTestPan.append(contentsOf: [100000000] + envDataObjectModel_testPan)
            envDataObjectModel_finalStoredTestTestGain.append(contentsOf: [1000000.0] + envDataObjectModel_testTestGain)
            envDataObjectModel_finalStoredFrequency.append(contentsOf: ["100000000"] + [String(activeFrequency)])
            envDataObjectModel_finalStoredTestCount.append(contentsOf: [100000000] + envDataObjectModel_testCount)
            envDataObjectModel_finalStoredHeardArray.append(contentsOf: [100000000] + envDataObjectModel_heardArray)
            envDataObjectModel_finalStoredReversalHeard.append(contentsOf: [100000000] + envDataObjectModel_reversalHeard)
            envDataObjectModel_finalStoredFirstGain.append(contentsOf: [1000000.0] + [firstGain])
            envDataObjectModel_finalStoredSecondGain.append(contentsOf: [1000000.0] + [secondGain])
            envDataObjectModel_finalStoredAverageGain.append(contentsOf: [1000000.0] + [envDataObjectModel_averageGain])
            finalStoredRightFinalGainsArray.removeAll()
            finalStoredleftFinalGainsArray.removeAll()
            finalStoredRightFinalGainsArray.append(contentsOf: rightFinalGainsArray)
            finalStoredleftFinalGainsArray.append(contentsOf: leftFinalGainsArray)
        }
    }
    
    func printConcatenatedArrays() async {
        print("finalStoredIndex: \(envDataObjectModel_finalStoredIndex)")
        print("finalStoredTestPan: \(envDataObjectModel_finalStoredTestPan)")
        print("finalStoredTestTestGain: \(envDataObjectModel_finalStoredTestTestGain)")
        print("finalStoredFrequency: \(envDataObjectModel_finalStoredFrequency)")
        print("finalStoredTestCount: \(envDataObjectModel_finalStoredTestCount)")
        print("finalStoredHeardArray: \(envDataObjectModel_finalStoredHeardArray)")
        print("finalStoredReversalHeard: \(envDataObjectModel_finalStoredReversalHeard)")
        print("finalStoredFirstGain: \(envDataObjectModel_finalStoredFirstGain)")
        print("finalStoredSecondGain: \(envDataObjectModel_finalStoredSecondGain)")
        print("finalStoredAverageGain: \(envDataObjectModel_finalStoredAverageGain)")
        print("rightFinalGainsArray: \(rightFinalGainsArray)")
        print("finalStoredRightFinalGainsArray: \(finalStoredRightFinalGainsArray)")
        print("leftFinalGainsArray: \(leftFinalGainsArray)")
        print("finalStoredleftFinalGainsArray: \(finalStoredleftFinalGainsArray)")
    }
        
    func saveFinalStoredArrays() async {
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
                    await writeEHA1DetailedResultsToCSV()
                    await writeEHA1SummarydResultsToCSV()
                    await writeEHA1InputDetailedResultsToCSV()
                    await writeEHA1InputDetailedResultsToCSV()
                    
                    await writeEHA1RightLeftResultsToCSV()
                    await writeEHA1RightResultsToCSV()
                    await writeEHA1LeftResultsToCSV()
                    await writeEHA1InputRightLeftResultsToCSV()
                    await writeEHA1InputRightResultsToCSV()
                    await writeEHA1InputLeftResultsToCSV()
                    
                    await getEHAP1Data()
                    await saveEHA1ToJSON()
        //                await envDataObjectModel_uploadSummaryResultsTest()
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
    
    func getEHAP1Data() async {
        guard let data = await getEHAP1JSONData() else { return }
        print("Json Data:")
        print(data)
        let jsonString = String(data: data, encoding: .utf8)
        print(jsonString!)
        do {
        self.saveFinalResults = try JSONDecoder().decode(SaveFinalResults.self, from: data)
            print("JSON GetData Run")
            print("data: \(data)")
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func getEHAP1JSONData() async -> Data? {
        let saveFinalResults = SaveFinalResults(
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
            jsonFrequency: [activeFrequency],
            jsonPan: envDataObjectModel_finalStoredTestPan,
            jsonStoredIndex: envDataObjectModel_finalStoredIndex,
            jsonStoredTestPan: envDataObjectModel_finalStoredTestPan,
            jsonStoredTestTestGain: envDataObjectModel_finalStoredTestTestGain,
            jsonStoredTestCount: envDataObjectModel_finalStoredTestCount,
            jsonStoredHeardArray: envDataObjectModel_finalStoredHeardArray,
            jsonStoredReversalHeard: envDataObjectModel_finalStoredReversalHeard,
            jsonStoredFirstGain: envDataObjectModel_finalStoredFirstGain,
            jsonStoredSecondGain: envDataObjectModel_finalStoredSecondGain,
            jsonStoredAverageGain: envDataObjectModel_finalStoredAverageGain)

        let jsonData = try? JSONEncoder().encode(saveFinalResults)
        print("saveFinalResults: \(saveFinalResults)")
        print("Json Encoded \(jsonData!)")
        return jsonData
    }

    func saveEHA1ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let ehaP1paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let ehaP1DocumentsDirectory = ehaP1paths[0]
        print("ehaP1DocumentsDirectory: \(ehaP1DocumentsDirectory)")
        let ehaP1FilePaths = ehaP1DocumentsDirectory.appendingPathComponent(fileEHAP1Name)
        print(ehaP1FilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonEHAP1Data = try encoder.encode(saveFinalResults)
            print(jsonEHAP1Data)
          
            try jsonEHAP1Data.write(to: ehaP1FilePaths)
        } catch {
            print("Error writing EHAP1 to JSON file: \(error)")
        }
    }

    func writeEHA1DetailedResultsToCSV() async {
        let stringFinalStoredIndex = "finalStoredIndex," + envDataObjectModel_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestPan = "finalStoredTestPan," + envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestTestGain = "finalStoredTestTestGain," + envDataObjectModel_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredFrequency = "finalStoredFrequency," + [activeFrequency].map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestCount = "finalStoredTestCount," + envDataObjectModel_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let stringFinalStoredHeardArray = "finalStoredHeardArray," + envDataObjectModel_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredReversalHeard = "finalStoredReversalHeard," + envDataObjectModel_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let stringFinalStoredPan = "finalStoredPan," + envDataObjectModel_testPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredFirstGain = "finalStoredFirstGain," + envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredSecondGain = "finalStoredSecondGain," + envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredAverageGain = "finalStoredAverageGain," + envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//        finalStoredRightFinalGainsArray.append(contentsOf: rightFinalGainsArray)
//        finalStoredleftFinalGainsArray.append(contentsOf: leftFinalGainsArray)
        
        do {
            let csvEHAP1DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvEHAP1DetailDocumentsDirectory = csvEHAP1DetailPath
//                print("CSV DocumentsDirectory: \(csvEHAP1DetailDocumentsDirectory)")
            let csvEHAP1DetailFilePath = csvEHAP1DetailDocumentsDirectory.appendingPathComponent(detailedEHAP1CSVName)
            print(csvEHAP1DetailFilePath)
            
            let writer = try CSVWriter(fileURL: csvEHAP1DetailFilePath, append: false)
            
            try writer.write(row: [stringFinalStoredIndex])
            try writer.write(row: [stringFinalStoredTestPan])
            try writer.write(row: [stringFinalStoredTestTestGain])
            try writer.write(row: [stringFinalStoredFrequency])
            try writer.write(row: [stringFinalStoredTestCount])
            try writer.write(row: [stringFinalStoredHeardArray])
            try writer.write(row: [stringFinalStoredReversalHeard])
            try writer.write(row: [stringFinalStoredPan])
            try writer.write(row: [stringFinalStoredFirstGain])
            try writer.write(row: [stringFinalStoredSecondGain])
            try writer.write(row: [stringFinalStoredAverageGain])
            try writer.write(row: [stringFinalrightFinalGainsArray])
            try writer.write(row: [stringFinalleftFinalGainsArray])
            try writer.write(row: [stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                print("CVS EHAP1 Detailed Writer Success")
        } catch {
            print("CVSWriter EHAP1 Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }

    func writeEHA1SummarydResultsToCSV() async {
        let stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + [activeFrequency].map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestPan = "finalStoredTestPan," + envDataObjectModel_testPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredFirstGain = "finalStoredFirstGain," + envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredSecondGain = "finalStoredSecondGain," + envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredAverageGain = "finalStoredAverageGain," + envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1SummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1SummaryDocumentsDirectory = csvEHAP1SummaryPath
//                 print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvEHAP1SummaryDocumentsDirectory)")
             let csvEHAP1SummaryFilePath = csvEHAP1SummaryDocumentsDirectory.appendingPathComponent(summaryEHAP1CSVName)
             print(csvEHAP1SummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1SummaryFilePath, append: false)
             try writer.write(row: [stringFinalStoredResultsFrequency])
             try writer.write(row: [stringFinalStoredTestPan])
             try writer.write(row: [stringFinalStoredFirstGain])
             try writer.write(row: [stringFinalStoredSecondGain])
             try writer.write(row: [stringFinalStoredAverageGain])
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func writeEHA1InputDetailedResultsToCSV() async {
        let stringFinalStoredIndex = envDataObjectModel_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestPan = envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestTestGain = envDataObjectModel_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestCount = envDataObjectModel_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let stringFinalStoredHeardArray = envDataObjectModel_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredReversalHeard = envDataObjectModel_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let stringFinalStoredResultsFrequency = [activeFrequency].map { String($0) }.joined(separator: ",")
        let stringFinalStoredPan = envDataObjectModel_testPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredFirstGain = envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredSecondGain = envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredAverageGain = envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let stringFinalrightFinalGainsArray = rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        

        do {
            let csvInputEHAP1DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputEHAP1DetailDocumentsDirectory = csvInputEHAP1DetailPath
//                print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputEHAP1DetailDocumentsDirectory)")
            let csvInputEHAP1DetailFilePath = csvInputEHAP1DetailDocumentsDirectory.appendingPathComponent(inputEHAP1DetailedCSVName)
            print(csvInputEHAP1DetailFilePath)
            let writer = try CSVWriter(fileURL: csvInputEHAP1DetailFilePath, append: false)
            try writer.write(row: [stringFinalStoredIndex])
            try writer.write(row: [stringFinalStoredTestPan])
            try writer.write(row: [stringFinalStoredTestTestGain])
            try writer.write(row: [stringFinalStoredTestCount])
            try writer.write(row: [stringFinalStoredHeardArray])
            try writer.write(row: [stringFinalStoredReversalHeard])
            try writer.write(row: [stringFinalStoredResultsFrequency])
            try writer.write(row: [stringFinalStoredPan])
            try writer.write(row: [stringFinalStoredFirstGain])
            try writer.write(row: [stringFinalStoredSecondGain])
            try writer.write(row: [stringFinalStoredAverageGain])
            try writer.write(row: [stringFinalrightFinalGainsArray])
            try writer.write(row: [stringFinalleftFinalGainsArray])
            try writer.write(row: [stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                print("CVS Input EHA Part 1Detailed Writer Success")
        } catch {
            print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }

    func writeEHA1InputSummarydResultsToCSV() async {
        let stringFinalStoredResultsFrequency = [activeFrequency].map { String($0) }.joined(separator: ",")
        let stringFinalStoredTestPan = envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let stringFinalStoredFirstGain = envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredSecondGain = envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let stringFinalStoredAverageGain = envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let stringFinalrightFinalGainsArray = rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
         
         do {
             let csvEHAP1InputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1InputSummaryDocumentsDirectory = csvEHAP1InputSummaryPath
             print("CSV Input EHA Part 1 Summary DocumentsDirectory: \(csvEHAP1InputSummaryDocumentsDirectory)")
             let csvEHAP1InputSummaryFilePath = csvEHAP1InputSummaryDocumentsDirectory.appendingPathComponent(inputEHAP1SummaryCSVName)
             print(csvEHAP1InputSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1InputSummaryFilePath, append: false)
             try writer.write(row: [stringFinalStoredResultsFrequency])
             try writer.write(row: [stringFinalStoredTestPan])
             try writer.write(row: [stringFinalStoredFirstGain])
             try writer.write(row: [stringFinalStoredSecondGain])
             try writer.write(row: [stringFinalStoredAverageGain])
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Input EHA Part 1 Summary Data Writer Success")
         } catch {
             print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
         }
    }
    
    func writeEHA1RightLeftResultsToCSV() async {
        
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1LRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1LRSummaryDocumentsDirectory = csvEHAP1LRSummaryPath
//                 print("CSV Summary EHA Part 1 LR Summary DocumentsDirectory: \(csvEHAP1LRSummaryDocumentsDirectory)")
             let csvEHAP1LRSummaryFilePath = csvEHAP1LRSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP1LRCSVName)
             print(csvEHAP1LRSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1LRSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 LR Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 LR Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHA1RightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1RightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1RightSummaryDocumentsDirectory = csvEHAP1RightSummaryPath
//                 print("CSV Summary EHA Part 1 Right Summary DocumentsDirectory: \(csvEHAP1RightSummaryDocumentsDirectory)")
             let csvEHAP1RightSummaryFilePath = csvEHAP1RightSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP1RightCSVName)
             print(csvEHAP1RightSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1RightSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 Right Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Right Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    func writeEHA1LeftResultsToCSV() async {
        
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1LeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1LeftSummaryDocumentsDirectory = csvEHAP1LeftSummaryPath
//                 print("CSV Summary EHA Part 1 Left Summary DocumentsDirectory: \(csvEHAP1LeftSummaryDocumentsDirectory)")
             let csvEHAP1LeftSummaryFilePath = csvEHAP1LeftSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP1LeftCSVName)
             print(csvEHAP1LeftSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1LeftSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 1 Left Summary Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Left Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    func writeEHA1InputRightLeftResultsToCSV() async {
        
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1InputLRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1InputLRSummaryDocumentsDirectory = csvEHAP1InputLRSummaryPath
//                 print("CSV Summary EHA Part 1 LR Summary DocumentsDirectory: \(csvEHAP1LRSummaryDocumentsDirectory)")
             let csvEHAP1InputLRSummaryFilePath = csvEHAP1InputLRSummaryDocumentsDirectory.appendingPathComponent(inputEHAP1LRSummaryCSVName)
             print(csvEHAP1InputLRSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1InputLRSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 LR Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 LR Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    
    func writeEHA1InputRightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1InputRightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1InputRightSummaryDocumentsDirectory = csvEHAP1InputRightSummaryPath
//                 print("CSV Summary EHA Part 1 Right Input DocumentsDirectory: \(csvEHAP1InputRightSummaryDocumentsDirectory)")
             let csvEHAP1InputRightSummaryFilePath = csvEHAP1InputRightSummaryDocumentsDirectory.appendingPathComponent(inputEHAP1RightSummaryCSVName)
             print(csvEHAP1InputRightSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1InputRightSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
//
//                 print("CVS Summary EHA Part 1 Right Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Right Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    func writeEHA1InputLeftResultsToCSV() async {
        
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
         do {
             let csvEHAP1InputLeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP1InputLeftSummaryDocumentsDirectory = csvEHAP1InputLeftSummaryPath
//                 print("CSV Summary EHA Part 1 Left Input DocumentsDirectory: \(csvEHAP1InputSummaryDocumentsDirectory)")
             let csvEHAP1InputLeftSummaryFilePath = csvEHAP1InputLeftSummaryDocumentsDirectory.appendingPathComponent(inputEHAP1LeftSummaryCSVName)
             print(csvEHAP1InputLeftSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP1InputLeftSummaryFilePath, append: false)
 
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
//                 print("CVS Summary EHA Part 1 Left Input Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Left Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    
}

