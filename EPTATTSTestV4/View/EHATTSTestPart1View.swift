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
    var jsonGain: [Float]
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
    
    @State var heardArrayValue = [Int]()
    @State var localHeard = 0
    @State var localPlaying = Int()    // Playing = 1. Stopped = -1
    @State var localPanSelection = Int()
    @State var localReversal = Int()
    @State var localReversalEnd = Int()
    @State var localMarkNewTestCycle = Int()
    @State var testPlayer: AVAudioPlayer?
    
    @State var localTestCount = 0
    @State var localStartingNonHeardArraySet: Bool = false

    @State var localReversalHeardLast = Int()
    @State var localSeriesYesResponses = Int()
    @State var localSeriesNoResponses = Int()

    
    @State var response1 = Int()
    @State var response2 = Int()
    @State var response3 = Int()
    
    @State var firstHeardResponseIndex = Int()
    @State var firstHeardIsTrue: Bool = false
    @State var secondHeardResponseIndex = Int()
    @State var secondHeardIsTrue: Bool = false
    
    @State var startTooHigh = 0
    @State var startTooLow = 0
    @State var first: Int?
    @State var first1 = Int()
    @State var second: Int?
    @State var second1 = Int()
    @State var firstG: Float?
    @State var secondG: Float?
    @State var firstGain = Float()
    @State var secondGain = Float()
 
    
    @State var envDataObjectModel_samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    @State var envDataObjectModel_index: Int = 0
    @State var envDataObjectModel_testGain: Float = 0.2
    @State var envDataObjectModel_heardArray: [Int] = [Int]()
    @State var envDataObjectModel_sampleType: String = ".wav"
    @State var envDataObjectModel_indexForTest = [Int]()
    @State var envDataObjectModel_testCount: [Int] = [Int]()
    @State var envDataObjectModel_pan: Int = Int()
    @State var envDataObjectModel_testPan = [Int]()
    @State var envDataObjectModel_testTestGain = [Float]()
    @State var envDataObjectModel_frequency = [String]()
    @State var envDataObjectModel_testStartSeconds = [Float64]()
    @State var envDataObjectModel_testEndSeconds = [Float64]()
    @State var envDataObjectModel_userRespCMSeconds = [Float64]()
    @State var envDataObjectModel_reversalHeard = [Int]()
    @State var envDataObjectModel_reversalGain = [Float]()
    @State var envDataObjectModel_reversalFrequency = [String]()
    @State var envDataObjectModel_reveralArray = [Any]()
    @State var envDataObjectModel_reversalArrayIndex = Int()
    @State var envDataObjectModel_reversalDirection = Float()
    @State var envDataObjectModel_reversalDirectionArray = [Float]()

    @State var envDataObjectModel_averageGain = Float()

    @State var envDataObjectModel_reversalResultsFrequency = [String]()
    @State var envDataObjectModel_reversalResultsGains = [Float]()
    @State var envDataObjectModel_reversalFirstGain = [Float]()
    @State var envDataObjectModel_reversalSecondGain = [Float]()
    @State var envDataObjectModel_reversalAverageGain = [Float]()
    @State var envDataObjectModel_resultsFrequency  = [String]()
    @State var envDataObjectModel_resultsGains  = [Float]()
    @State var envDataObjectModel_reversalDualTrue = Int()

    @State var envDataObjectModel_eptaSamplesCount = 17

    @State var envDataObjectModel_finalStoredIndex: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredTestStartSeconds: [Float64] = [Float64]()
    @State var envDataObjectModel_finalStoredTestEndSeconds: [Float64] = [Float64]()
    @State var envDataObjectModel_finalStoredUserRespCMSeconds: [Float64] = [Float64]()
    @State var envDataObjectModel_finalStoredTestPan: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredTestTestGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredFrequency: [String] = [String]()
    @State var envDataObjectModel_finalStoredTestCount: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredHeardArray: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredReversalDirectionArray: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredReversalGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredReversalFrequency: [String] = [String]()
    @State var envDataObjectModel_finalStoredReversalHeard: [Int] = [Int]()
    @State var envDataObjectModel_finalStoredFirstGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredSecondGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredAverageGain: [Float] = [Float]()
    @State var envDataObjectModel_finalStoredResultsFrequency: [String] = [String]()
    @State var envDataObjectModel_finalStoredResultsGains: [Float] = [Float]()
    @State var envDataObjectModel_finalHearingResults = [[Any]]()
    
    @State var idxForTest = Int() // = envDataObjectModel_indexForTest.count
    @State var idxForTestNet1 = Int() // = envDataObjectModel_indexForTest.count - 1
    @State var idxTestCount = Int() // = envDataObjectModel_TestCount.count
    @State var idxTestCountNet1 = Int() // = envDataObjectModel_TestCount.count - 1
    @State var idxTestCountUpdated = Int() // = envDataObjectModel_TestCount.count + 1
    @State var activeFrequency = String()
    @State var idxHA = Int()    // idx = envDataObjectModel_heardArray.count
    @State var idxReversalHeardCount = Int()
    @State var idxHAZero = Int()    //  idxZero = idx - idx
    @State var idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var rHIdxNet3: Int?
    @State var rHIdxNet2: Int?
    @State var rHIdxNet1: Int?
    @State var localSumReversalHeard = Int()
    @State var isCountSame = Int()
    //envDataObjectModel_heardArray.index(after: envDataObjectModel_indexForTest.count-1)
    @State var heardArrayIdxAfnet1 = Int()
    @State var testIsPlaying: Bool = false
    @State var playingString: [String] = ["", "Start or Restart Test"]
    @State var playingStringColor: [Color] = [Color.clear, Color.yellow]
    @State var playingStringColorIndex = 0
    @State var userPausedTest: Bool = false


    

    let fileEHAP1Name = "SummaryEHAP1Results.json"
    let summaryEHAP1CSVName = "SummaryEHAP1ResultsCSV.csv"
    let detailedEHAP1CSVName = "DetailedEHAP1ResultsCSV.csv"
    let inputEHAP1SummaryCSVName = "InputSummaryEHAP1ResultsCSV.csv"
    let inputEHAP1DetailedCSVName = "InputDetailedEHAP1ResultsCSV.csv"
    
    @State var saveFinalResults: SaveFinalResults? = nil

   
    let heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    
    var body: some View {
        
        ZStack{
            RadialGradient(
                gradient: Gradient(colors: [Color.blue, Color.black]),
                center: .center,
                startRadius: -100,
                endRadius: 300).ignoresSafeArea()
            VStack{
                Spacer()
                
                HStack {
                    Spacer()
                    Text(String(envDataObjectModel_testGain))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
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
                        Text("Resart Test Post Pause")
                            .foregroundColor(playingStringColor[playingStringColorIndex])
                    }
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
//                        print("Heard Button Pressed; Heard: \(localHeard)")
                    }
                }
            Spacer()
            }
        }
        .onChange(of: testIsPlaying, perform: { testBoolValue in
            if testBoolValue == true {
            //User is starting test for first time
                audioSessionModel.setAudioSession()
                localPlaying = 1
                playingStringColorIndex = 0
                userPausedTest = false
            } else if testBoolValue == false  {
            // User is pausing test for firts time
                stop()
                localPlaying = 0
                playingStringColorIndex = 1
                userPausedTest = true
//                envDataObjectModel_heardArray.removeAll()
//                pauseRestartTestCycle()
                    
                
            } else {
                print("Critical error in pause logic")
            }
        }) // This is the lowest CPU approach from many, many tries
        .onChange(of: localPlaying, perform: { playingValue in
            activeFrequency = envDataObjectModel_samples[envDataObjectModel_index]
            localHeard = 0
            localReversal = 0
            if playingValue == 1{
                audioThread.async {
                    loadAndTestPresentation(sample: activeFrequency, gain: envDataObjectModel_testGain)
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
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
//                    Task(priority: .userInitiated) {
                        if self.localHeard == 1 {
                            localTestCount += 1
                            Task(priority: .userInitiated) {
                                await responseHeardArray()      //envDataObjectModel_heardArray.append(1)
                                await localResponseTracking()
                                await count()
                                await logNotPlaying()           //envDataObjectModel_playing = -1
//                                await arrayTesting()
//                                await printData()
                                await resetPlaying()
                                await resetHeard()
                                await resetNonResponseCount()
                                await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                            }
                        }
                        else if envDataObjectModel_heardArray.last == nil || self.localHeard == -1 {
                            localTestCount += 1
                            Task(priority: .userInitiated) {
                                await heardArrayNormalize()
                                await count()
                                await logNotPlaying()   //self.envDataObjectModel_playing = -1
    //                                await arrayTesting()
    //                                await printData()
                                await resetPlaying()
                                await resetHeard()
                                await nonResponseCounting()
                                await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                            }
                        } else {
                            localTestCount += 1
                            Task(priority: .background) {
//                                await printData()
                            await resetPlaying()
//                            await resetHeard()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(envDataObjectModel_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: localReversal) { reversalValue in
            if reversalValue == 1 {
//                print("Pre Reversal Funcs _reversalHeard: \(envDataObjectModel_reversalHeard)")
                DispatchQueue.global(qos: .background).async {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Task(priority: .userInitiated) {
                        await createReversalHeardArray()
                        await createReversalGainArray()
                        await checkHeardReversalArrays()
                        await reversalDirection()
                        await reversalComplexAction()
                        await printReversalGain()
                        await reversalsCompleteLogging()
                        await restartPresentation()
                        await newTestCycle()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
//        .onChange(of:  localReversalEnd) { lREValue in
//            if lREValue == 0 {
//                DispatchQueue.global(qos: .background).async(group: .none, qos: .background) {
//                    Task(priority: .background) {
//                        await printReversalData()
//                    }
//                    Task(priority: .background) {
//                        await concatenateFinalArrays()
//                        await saveFinalStoredArrays()
//                    }
//                }
//            }
//        }
    }
 
    
    
//MARK: - AudioPlayer Methods
    
    
    func pauseRestartTestCycle() {
        localMarkNewTestCycle = 0
        localReversalEnd = 0
        envDataObjectModel_index = envDataObjectModel_index
        envDataObjectModel_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        testIsPlaying = false
        localPlaying = 0
//            envDataObjectModel_heardArray.removeAll()
        envDataObjectModel_testCount.removeAll()
        envDataObjectModel_reversalHeard.removeAll()
        envDataObjectModel_reversalArrayIndex = Int()
        envDataObjectModel_averageGain = Float()
        envDataObjectModel_reversalDirection = Float()
        envDataObjectModel_reversalDualTrue = Int()
        localStartingNonHeardArraySet = false
        firstHeardResponseIndex = Int()
        firstHeardIsTrue = false
        secondHeardResponseIndex = Int()
        secondHeardIsTrue = false
        localTestCount = 0
        localReversalHeardLast = Int()
        startTooHigh = 0
    }
      
  func loadAndTestPresentation(sample: String, gain: Float) {
          do{
              let urlSample = Bundle.main.path(forResource: activeFrequency, ofType: ".wav")
              guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
              testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
              guard let testPlayer = testPlayer else { return }
              testPlayer.prepareToPlay()    // Test Player Prepare to Play
              testPlayer.setVolume(envDataObjectModel_testGain, fadeDuration: 0)      // Set Gain for Playback
              testPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func stop() {
      do{
          let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
          testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
          guard let testPlayer = testPlayer else { return }
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
//      DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
          envDataObjectModel_heardArray.append(1)
          self.idxHA = envDataObjectModel_heardArray.count
          self.localStartingNonHeardArraySet = true
//      })
    }

    func localResponseTracking() async {
//        DispatchQueue.global(qos: .userInitiated).async {
            if firstHeardIsTrue == false {
    //            DispatchQueue.global(qos: .userInitiated).async {
                firstHeardResponseIndex = localTestCount
                firstHeardIsTrue = true
    //            }
            } else if firstHeardIsTrue == true {
    //            DispatchQueue.global(qos: .userInitiated).async {
                secondHeardResponseIndex = localTestCount
                secondHeardIsTrue = true
                print("Second Heard Is True Logged!")
    //            }
            } else {
    //            DispatchQueue.global(qos: .background).async {
                print("Error in localResponseTrackingLogic")
            }
//        }
    }
    
//MARK: - THIS FUNCTION IS CAUSING ISSUES IN HEARD ARRAY. THE ISSUE IS THE DUAL IF STRUCTURE, NOT LINKED BY ELSE IF
    func heardArrayNormalize() async {
        idxHA = envDataObjectModel_heardArray.count
        idxForTest = envDataObjectModel_indexForTest.count
        idxForTestNet1 = idxForTest - 1
        isCountSame = idxHA - idxForTest
        heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)
      
        if localStartingNonHeardArraySet == false {
//            DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            envDataObjectModel_heardArray.append(0)
            self.localStartingNonHeardArraySet = true
            idxHA = envDataObjectModel_heardArray.count
            idxHAZero = idxHA - idxHA
            idxHAFirst = idxHAZero + 1
            isCountSame = idxHA - idxForTest
            heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)
//            })
        } else if localStartingNonHeardArraySet == true {
      
      //envDataObjectModel_indexForTest.count - envDataObjectModel_heardArray.count
//            let isCountSame = idxHA - idxForTest
      //envDataObjectModel_heardArray.index(after: envDataObjectModel_indexForTest.count-1)
//            let heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)

            if isCountSame != 0 && heardArrayIdxAfnet1 != 1 {
//            DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
                envDataObjectModel_heardArray.append(0)
                idxHA = envDataObjectModel_heardArray.count
                idxHAZero = idxHA - idxHA
                idxHAFirst = idxHAZero + 1
                isCountSame = idxHA - idxForTest
                heardArrayIdxAfnet1 = envDataObjectModel_heardArray.index(after: idxForTestNet1)

            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
//            })
        } else {
//            DispatchQueue.global(qos: .background).async {
            print("Critial Error in Heard Array Count and or Values")
        }
    }
      
// MARK: -Logging Methods
    func count() async {
        idxTestCountUpdated = envDataObjectModel_testCount.count + 1
        
//        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
        envDataObjectModel_testCount.append(idxTestCountUpdated)
//        })
    }
    

    func arrayTesting() async {
//        DispatchQueue.global(qos: .background).async {
        let arraySet1 = Int(envDataObjectModel_testStartSeconds.count) - Int(envDataObjectModel_testEndSeconds.count) + Int(envDataObjectModel_userRespCMSeconds.count) - Int(envDataObjectModel_testPan.count)
        let arraySet2 = Int(envDataObjectModel_testTestGain.count) - Int(envDataObjectModel_frequency.count) + Int(envDataObjectModel_testCount.count) - Int(envDataObjectModel_heardArray.count)
        if arraySet1 + arraySet2 == 0 {
            print("All Event Logs Match")
        } else {
            print("Error Event Logs Length Error")
        }
//        }
    }
    
    func printData () async {
        DispatchQueue.global(qos: .background).async {
            print("Start printData)(")
            print("--------Array Values Logged-------------")
            print("testStartSeconds: \(envDataObjectModel_testStartSeconds)")
            print("testEndSeconds: \(envDataObjectModel_testEndSeconds)")
            print("userRespCMSeconds: \(envDataObjectModel_userRespCMSeconds)")
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
//        DispatchQueue.main.async {
        envDataObjectModel_reversalHeard.append(envDataObjectModel_heardArray[idxHA-1])
        self.idxReversalHeardCount = envDataObjectModel_reversalHeard.count
//        }
    }
        
    func createReversalGainArray() async {
//        DispatchQueue.global(qos: .userInitiated).async {
            envDataObjectModel_reversalGain.append(envDataObjectModel_testTestGain[idxHA-1])
//        }
    }
    
    func checkHeardReversalArrays() async {
//        DispatchQueue.main.async(group: .none, qos: .userInitiated) { //}, flags: .barrier) {
        if idxHA - idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if idxHA - idxReversalHeardCount < 0 && idxHA - idxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
//        }
    }
    
    
    func reversalDirection() async {
        localReversalHeardLast = envDataObjectModel_reversalHeard.last ?? -999
        
        if localReversalHeardLast == 1 {
            envDataObjectModel_reversalDirection = -1.0
//            DispatchQueue.global(qos: .userInitiated).async {
            envDataObjectModel_reversalDirectionArray.append(-1.0)
//            }
        } else if localReversalHeardLast == 0 {
            envDataObjectModel_reversalDirection = 1.0
//            DispatchQueue.global(qos: .userInitiated).async {
            envDataObjectModel_reversalDirectionArray.append(1.0)
//            }
        } else {
//            DispatchQueue.global(qos: .background).async {
            print("Error in Reversal Direction reversalHeardArray Count")
//            }
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
//        DispatchQueue.global(qos: .userInitiated).async {
        if localReversalHeardLast == 1 {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            await reversalOfFive()
//                }
//            }
        } else if localReversalHeardLast == 0 {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            await reversalOfTwo()
//                }
//            }
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    

    func reversalComplexAction() async {
    //        print("Start reversalComplexAction()")
    //        print("=============================")
    //        print("reversal section")
    //        print("idxRevHC: \(idxReversalHeardCount)")
    //        print("idxHA: \(idxHA)")
    //        print("PostCreate reversalHeard: \(envDataObjectModel_reversalHeard)")
    //        print("PostCreate heardArray: \(envDataObjectModel_heardArray)")
    //        print("PostCreate heardArray[idxHa-1]: \(envDataObjectModel_heardArray[idxHA-1])")
    //        print("PostCreate idxReversalHeardCount: \(idxReversalHeardCount)")
    //        print("secondHeardIsTrue: \(secondHeardIsTrue)")
    //        print("firstHeardResponseIndex: \(firstHeardResponseIndex)")
    //        print("SecondHeardResponseIndex: \(secondHeardResponseIndex)")
    //        print("LocalSeriesNoResponses: \(localSeriesNoResponses)")
        if idxReversalHeardCount <= 1 && idxHA <= 1 {
//            print("reversal section <= 1")
//            DispatchQueue.global(qos: .userInitiated).async {
//                    Task(priority: .userInitiated) {
            await reversalAction()
//                    print("reversal section hCount <=1 = reversalAction")
//                    }
//            }
        }  else if idxReversalHeardCount == 2 {
//            print("reversal section == 2")
            if idxReversalHeardCount == 2 && secondHeardIsTrue == true {
//                DispatchQueue.global(qos: .userInitiated).async {
//                        Task(priority: .userInitiated) {
                await startTooHighCheck()
//                        print("In reversal section == 2")
//                        print("reversal section startTooHigh")
    // Need to Add in Start Too Low Check
//                        }
//                }
            } else if idxReversalHeardCount == 2  && secondHeardIsTrue == false {
                await reversalAction()
//                print("In reversal section == 2")
//                print("In reversal section 2 else if reversal action triggered")
            } else {
//                DispatchQueue.global(qos: .userInitiated).async {
//                        Task(priority: .background) {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
//                        }
//                }
            }
        } else if idxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if secondHeardResponseIndex - firstHeardResponseIndex == 1 {
//                DispatchQueue.global(qos: .userInitiated).async {
// Need Code To Ensure Exit This Cycle to New Cycle
//                        Task(priority: .background) {
                        // End Test Cycle
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
//                        }
//                }
            } else if localSeriesNoResponses == 3 {
//                DispatchQueue.global(qos: .userInitiated).async {
//                        Task(priority: .userInitiated) {
                await reversalOfTen()
//                        print("reversal section >= 3")
//                        print("In first else if section localSeriesNoResponses === 3")
//                        print("Three Negative Series Reversals, Reversal of Ten")
//                        }
//                }
            } else if localSeriesNoResponses == 2 {
//                DispatchQueue.global(qos: .userInitiated).async {
//                        Task(priority: .userInitiated) {
                await reversalOfFour()
//                        print("reversal section >= 3")
//                        print("In second else if section localSeriesNoResponses === 2")
//                        print("Two Negative Series Reversals, Reversal of four")
//                        }
//                }
            } else {
//                DispatchQueue.global(qos: .userInitiated).async {
//                        Task(priority: .userInitiated) {
                await reversalAction()
//                        print("reversal section >= 3")
//                        print("In else section for normal revert reversal action")
//                        print("Normal Reversal Action with Count >= 3")
//                        }
//                }
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
//        print("Start reversalHeardCount1()")
//       DispatchQueue.global(qos: .userInitiated).async {
//           Task(priority: .userInitiated) {
       await reversalAction()
//               print("reversalHeardCount1 = reversalAction")
//           }
//       }
   }
            
    func check2PositiveSeriesReversals() async {
//        print("Start check2PositiveSeriesReversals()")
        if envDataObjectModel_reversalHeard[idxHA-2] == 1 && envDataObjectModel_reversalHeard[idxHA-1] == 1 {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .background) {
//                     End Test Cycle
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
//                }
//            }
        }
    }

    func checkTwoNegativeSeriesReversals() async {
//        print("Start checkTwoNegativeSeriesReversals()")
        if envDataObjectModel_reversalHeard.count >= 3 && envDataObjectModel_reversalHeard[idxHA-2] == 0 && envDataObjectModel_reversalHeard[idxHA-1] == 0 {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            await reversalOfFour()
//                    print("reversal - check2NegaitveSeriesReversals if segment = reversal of Four")
//                      print("Two Negative Series Reversal Registered, Reversal of Five")
//                }
//            }
        } else {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            await reversalAction()
//                    print("reversal - check2NegaitveSeriesReversals else segment = reversal action")
//                       print("Complex Action Triggers Not Met, continue standard Reversal Action")
//                }
//            }
        }
    }
    
    func startTooHighCheck() async {
//        if startTooHigh == 0 && envDataObjectModel_reversalHeard[idxHAZero] == 1 && envDataObjectModel_reversalHeard[idxHAFirst] == 1 {
        if startTooHigh == 0 && firstHeardIsTrue == true && secondHeardIsTrue == true {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            startTooHigh = 1
            await reversalOfTen()
            await resetAfterTooHigh()
            print("Too High Found")
//
//                }
//            }
        } else {
//            DispatchQueue.global(qos: .userInitiated).async {
//                Task(priority: .userInitiated) {
            await reversalAction()
//                }
//            }
        }
    }
    
    func resetAfterTooHigh() async {
//        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            firstHeardResponseIndex = Int()
            firstHeardIsTrue = false
            secondHeardResponseIndex = Int()
            secondHeardIsTrue = false
//        })
    }

    func reversalsCompleteLogging() async {
//        DispatchQueue.global(qos: .userInitiated).async {
        if secondHeardIsTrue == true {
            self.localReversalEnd = 1
            self.localMarkNewTestCycle = 1
//                print("envDataObjectModel_reversalGain: \(envDataObjectModel_reversalGain)")
//                print("firstHeardResponseIndex: \(firstHeardResponseIndex)")
//                print("secondHeardResponseIndex: \(secondHeardResponseIndex)")
//                print("firstGain by index - 1 func: \(envDataObjectModel_reversalGain[firstHeardResponseIndex-1])")
//                print("secondGain by index - 1 func: \(envDataObjectModel_reversalGain[secondHeardResponseIndex-1])")
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
//            DispatchQueue.global(qos: .background).async {
                print("Contine, second hear is true = false")
//            }
        } else {
//            DispatchQueue.global(qos: .background).async {
                print("Critical error in reversalsCompletLogging Logic")
//            }
        }
    }

    func printReversalData() async {
        print("Start printReversalData()")
        DispatchQueue.global(qos: .background).async {
            print("--------Reversal Values Logged-------------")
            print("Test Pan: \(envDataObjectModel_testPan)")
            print("New TestGain: \(envDataObjectModel_testGain)")
            print("testCount: \(envDataObjectModel_testCount)")
            print("reversalFrequency: \(activeFrequency)")
            print("reversalHeard: \(envDataObjectModel_reversalHeard)")
            print("FirstGain: \(firstGain)")
            print("SecondGain: \(secondGain)")
            print("AverageGain: \(envDataObjectModel_averageGain)")
            print("------------------------------------------")
        }
    }
        
    func restartPresentation() async {
        localPlaying = 1
    }
    
    func wipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            envDataObjectModel_heardArray.removeAll()
            envDataObjectModel_testCount.removeAll()
            envDataObjectModel_reversalHeard.removeAll()
            envDataObjectModel_reversalArrayIndex = Int()
            envDataObjectModel_averageGain = Float()
            envDataObjectModel_reversalDirection = Float()
            envDataObjectModel_reversalDualTrue = Int()
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
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
            startTooHigh = 0
            startTooLow = 0
            localMarkNewTestCycle = 0
            localReversalEnd = 0
            //!!!!!Need to fix / stop this index from climbing in next cycle without the cycle being completed!!
            envDataObjectModel_index = envDataObjectModel_index + 1
            envDataObjectModel_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL

            await wipeArrays()

//            await printData()
        }
    }
    
    
   
    func concatenateFinalArrays() async {
//        print("concatenateFinalArrays()")
        DispatchQueue.global(qos: .background).async {
            if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
                
//                let ift = [100000000] + envDataObjectModel_indexForTest
//                let tp = [100000000] + envDataObjectModel_testPan
//                let ttg = [1000000.0] + envDataObjectModel_testTestGain
//                let freq = ["100000000"] + [activeFrequency]
//                let tc = [100000000] + envDataObjectModel_testCount
//                let ha = [100000000] + envDataObjectModel_heardArray
//                let rh = [100000000] + envDataObjectModel_reversalHeard
//                let rfg = [1000000.0] + envDataObjectModel_reversalFirstGain
//                let rsg = [1000000.0] + envDataObjectModel_reversalSecondGain
//                let rag = [1000000.0] + envDataObjectModel_reversalAverageGain
//
                
    //            let ift = envDataObjectModel.storedIndex + envDataObjectModel.indexForTest
    //            let tss = envDataObjectModel.storedTestStartSeconds + envDataObjectModel.testStartSeconds
    //            let tes = envDataObjectModel.storedTestEndSeconds + envDataObjectModel.testEndSeconds
    //            let urcms = envDataObjectModel.storedUserRespCMSeconds + envDataObjectModel.userRespCMSeconds
    //            let tp = envDataObjectModel.storedTestPan + envDataObjectModel.testPan
    //            let ttg = envDataObjectModel.storedTestTestGain + envDataObjectModel.testTestGain
    //            let freq = envDataObjectModel.storedFrequency + envDataObjectModel.frequency
    //            let tc = envDataObjectModel.storedTestCount + envDataObjectModel.testCount
    //            let ha = envDataObjectModel.storedHeardArray + envDataObjectModel.heardArray
    //            let rda = envDataObjectModel.storedReversalDirection + envDataObjectModel.reversalDirectionArray
    //            let rg = envDataObjectModel.storedReversalGain + envDataObjectModel.reversalGain
    //            let rFreq = envDataObjectModel.storedReversalFrequency + envDataObjectModel.reversalFrequency
    //            let rh = envDataObjectModel.storedReversalHeard + envDataObjectModel.reversalHeard
    //            let rfg = envDataObjectModel.storedFirstGain + envDataObjectModel.reversalFirstGain
    //            let rsg = envDataObjectModel.storedSecondGain + envDataObjectModel.reversalSecondGain
    //            let rag = envDataObjectModel.storedAverageGain + envDataObjectModel.reversalAverageGain
    //            let resFreq = envDataObjectModel.storedResultsFrequency + envDataObjectModel.resultsFrequency
    //            let resGs = envDataObjectModel.storedResultsGains + envDataObjectModel.resultsGains
                
                envDataObjectModel_finalStoredIndex.append(contentsOf: [100000000] + envDataObjectModel_indexForTest)
                envDataObjectModel_finalStoredTestPan.append(contentsOf: [100000000] + envDataObjectModel_testPan)
                envDataObjectModel_finalStoredTestTestGain.append(contentsOf: [1000000.0] + envDataObjectModel_testTestGain)
                envDataObjectModel_finalStoredFrequency.append(contentsOf: ["100000000"] + [activeFrequency])
                envDataObjectModel_finalStoredTestCount.append(contentsOf: [100000000] + envDataObjectModel_testCount)
                envDataObjectModel_finalStoredHeardArray.append(contentsOf: [100000000] + envDataObjectModel_heardArray)
                envDataObjectModel_finalStoredReversalHeard.append(contentsOf: [100000000] + envDataObjectModel_reversalHeard)
                envDataObjectModel_finalStoredFirstGain.append(contentsOf: [1000000.0] + envDataObjectModel_reversalFirstGain)
                envDataObjectModel_finalStoredSecondGain.append(contentsOf: [1000000.0] + envDataObjectModel_reversalSecondGain)
                envDataObjectModel_finalStoredAverageGain.append(contentsOf: [1000000.0] + envDataObjectModel_reversalAverageGain)

            }
        }
    }
        
    func saveFinalStoredArrays() async {
//        print("Start saveFinalStoredArrays()")
        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
            await getEHAP1Data()
            await saveEHA1ToJSON()
            await writeEHA1DetailedResultsToCSV()
            await writeEHA1SummarydResultsToCSV()
            await writeEHA1InputDetailedResultsToCSV()
            await writeEHA1InputDetailedResultsToCSV()
//                await envDataObjectModel_uploadSummaryResultsTest()
         
//            print("---------End-Test-Cycle-Print-Stored-Array-Results---------")
//            print("finalStoredIndex: \(envDataObjectModel_finalStoredIndex)")
//            print("finalStoredTestStartSeconds: \(envDataObjectModel_finalStoredTestStartSeconds)")
//            print("finalStoredTestEndSeconds: \(envDataObjectModel_finalStoredTestEndSeconds)")
//            print("finalStoredUserRespCMSeconds: \(envDataObjectModel_finalStoredUserRespCMSeconds)")
//            print("finalStoredTestPan: \(envDataObjectModel_finalStoredTestPan)")
//            print("finalStoredTestTestGain: \(envDataObjectModel_finalStoredTestTestGain)")
//            print("finalStoredFrequency: \(envDataObjectModel_finalStoredFrequency)")
//            print("finalStoredTestCount: \(envDataObjectModel_finalStoredTestCount)")
//            print("finalStoredHeardArray: \(envDataObjectModel_finalStoredHeardArray)")
//            print("finalStoredReversalDirectionArray: \(envDataObjectModel_finalStoredReversalDirectionArray)")
//            print("finalStoredReversalGain: \(envDataObjectModel_finalStoredReversalGain)")
//            print("finalStoredReversalFrequency: \(envDataObjectModel_finalStoredReversalFrequency)")
//            print("finalStoredReversalHeard: \(envDataObjectModel_finalStoredReversalHeard)")
//            print("finalStoredFirstGain: \(envDataObjectModel_finalStoredFirstGain)")
//            print("finalStoredSecondGain: \(envDataObjectModel_finalStoredSecondGain)")
//            print("finalStoredAverageGain: \(envDataObjectModel_finalStoredAverageGain)")
//            print("finalStoredResultsFrequency: \(envDataObjectModel_finalStoredResultsFrequency)")
//            print("finalStoredResultsGains: \(envDataObjectModel_finalStoredResultsGains)")
//            print("finalHearingResults: \(envDataObjectModel_finalHearingResults)")
//            print("-------End-Test-Cycle-And-Printed-Stored-Array-Results-------")
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
            jsonGain: envDataObjectModel_finalStoredResultsGains,
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
        DispatchQueue.global(qos: .background).async {
            
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
    }


    func writeEHA1DetailedResultsToCSV() async {
        DispatchQueue.global(qos: .background).async {
            
           print("writeEHAP1DetailedResultsToCSV Start")
            
            let stringFinalStoredIndex = "finalStoredIndex," + envDataObjectModel_finalStoredIndex.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestPan = "finalStoredTestPan," + envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestTestGain = "finalStoredTestTestGain," + envDataObjectModel_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredFrequency = "finalStoredFrequency," + activeFrequency.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestCount = "finalStoredTestCount," + envDataObjectModel_finalStoredTestCount.map { String($0) }.joined(separator: ",")
            let stringFinalStoredHeardArray = "finalStoredHeardArray," + envDataObjectModel_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
            let stringFinalStoredReversalHeard = "finalStoredReversalHeard," + envDataObjectModel_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
            let stringFinalStoredFirstGain = "finalStoredFirstGain," + envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredSecondGain = "finalStoredSecondGain," + envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredAverageGain = "finalStoredAverageGain," + envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
            

    //        let stringFinalStoredIndex = "finalStoredIndex," + finalStoredIndex.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredTestStartSeconds = "finalStoredTestStartSeconds," + finalStoredTestStartSeconds.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredTestEndSeconds = "finalStoredTestEndSeconds." + finalStoredTestEndSeconds.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredUserRespCMSeconds = "finalStoredUserRespCMSeconds," + finalStoredUserRespCMSeconds.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredTestTestGain = "finalStoredTestTestGain," + finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredFrequency = "finalStoredFrequency," + finalStoredFrequency.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredTestCount = "finalStoredTestCount," + finalStoredTestCount.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredHeardArray = "finalStoredHeardArray," + finalStoredHeardArray.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredReversalDirectionArray = "finalStoredReversalDirectionArray," + finalStoredReversalDirectionArray.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredReversalGain = "finalStoredReversalGain," + finalStoredReversalGain.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredReversalFrequency = "finalStoredReversalFrequency," + finalStoredReversalFrequency.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredReversalHeard = "finalStoredReversalHeard," + finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredFirstGain = "finalStoredFirstGain," + finalStoredFirstGain.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredSecondGain = "finalStoredSecondGain," + finalStoredSecondGain.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredAverageGain = "finalStoredAverageGain," + finalStoredAverageGain.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + finalStoredResultsFrequency.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredResultsGains = "finalStoredResultsGains," + finalStoredResultsGains.map { String($0) }.joined(separator: ",")
    //        let stringFinalStoredTestPan = "finalStoredTestPan," + finalStoredTestPan.map { String($0) }.joined(separator: ",")
            
            
            do {
                let csvEHAP1DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                let csvEHAP1DetailDocumentsDirectory = csvEHAP1DetailPath
                print("CSV DocumentsDirectory: \(csvEHAP1DetailDocumentsDirectory)")
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
                try writer.write(row: [stringFinalStoredFirstGain])
                try writer.write(row: [stringFinalStoredSecondGain])
                try writer.write(row: [stringFinalStoredAverageGain])

                print("CVS EHAP1 Detailed Writer Success")
            } catch {
                print("CVSWriter EHAP1 Detailed Error or Error Finding File for Detailed CSV \(error)")
            }
        }
    }


    func writeEHA1SummarydResultsToCSV() async {
        DispatchQueue.global(qos: .background).async {
            
            print("writeSummaryEHAP1ResultsToCSV Start")
             let stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + activeFrequency.map { String($0) }.joined(separator: ",")
             let stringFinalStoredTestPan = "finalStoredTestPan," + envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
             let stringFinalStoredFirstGain = "finalStoredFirstGain," + envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
             let stringFinalStoredSecondGain = "finalStoredSecondGain," + envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
             let stringFinalStoredAverageGain = "finalStoredAverageGain," + envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
            
             do {
                 let csvEHAP1SummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                 let csvEHAP1SummaryDocumentsDirectory = csvEHAP1SummaryPath
                 print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvEHAP1SummaryDocumentsDirectory)")
                 let csvEHAP1SummaryFilePath = csvEHAP1SummaryDocumentsDirectory.appendingPathComponent(summaryEHAP1CSVName)
                 print(csvEHAP1SummaryFilePath)
                 let writer = try CSVWriter(fileURL: csvEHAP1SummaryFilePath, append: false)
                 try writer.write(row: [stringFinalStoredResultsFrequency])
                 try writer.write(row: [stringFinalStoredTestPan])
                 try writer.write(row: [stringFinalStoredFirstGain])
                 try writer.write(row: [stringFinalStoredSecondGain])
                 try writer.write(row: [stringFinalStoredAverageGain])

                 print("CVS Summary EHA Part 1 Data Writer Success")
             } catch {
                 print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
             }
        }
    }


    func writeEHA1InputDetailedResultsToCSV() async {
        DispatchQueue.global(qos: .background).async {
            print("writeInputEHAP1DetailResultsToCSV Start")

            let stringFinalStoredIndex = envDataObjectModel_finalStoredIndex.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestPan = envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestTestGain = envDataObjectModel_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredFrequency = activeFrequency.map { String($0) }.joined(separator: ",")
            let stringFinalStoredTestCount = envDataObjectModel_finalStoredTestCount.map { String($0) }.joined(separator: ",")
            let stringFinalStoredHeardArray = envDataObjectModel_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
            let stringFinalStoredReversalHeard = envDataObjectModel_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
            let stringFinalStoredFirstGain = envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredSecondGain = envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
            let stringFinalStoredAverageGain = envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")

            do {
                let csvInputEHAP1DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                let csvInputEHAP1DetailDocumentsDirectory = csvInputEHAP1DetailPath
                print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputEHAP1DetailDocumentsDirectory)")
                let csvInputEHAP1DetailFilePath = csvInputEHAP1DetailDocumentsDirectory.appendingPathComponent(inputEHAP1DetailedCSVName)
                print(csvInputEHAP1DetailFilePath)
                let writer = try CSVWriter(fileURL: csvInputEHAP1DetailFilePath, append: false)
                try writer.write(row: [stringFinalStoredIndex])
                try writer.write(row: [stringFinalStoredTestPan])
                try writer.write(row: [stringFinalStoredTestTestGain])
                try writer.write(row: [stringFinalStoredFrequency])
                try writer.write(row: [stringFinalStoredTestCount])
                try writer.write(row: [stringFinalStoredHeardArray])
                try writer.write(row: [stringFinalStoredReversalHeard])
                try writer.write(row: [stringFinalStoredFirstGain])
                try writer.write(row: [stringFinalStoredSecondGain])
                try writer.write(row: [stringFinalStoredAverageGain])
                
                print("CVS Input EHA Part 1Detailed Writer Success")
            } catch {
                print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
            }
        }
    }


    func writeEHA1InputSummarydResultsToCSV() async {
        DispatchQueue.global(qos: .background).async {
            print("writeInputEHAP1SummaryResultsToCSV Start")
             let stringFinalStoredResultsFrequency = activeFrequency.map { String($0) }.joined(separator: ",")
             let stringFinalStoredTestPan = envDataObjectModel_finalStoredTestPan.map { String($0) }.joined(separator: ",")
             let stringFinalStoredFirstGain = envDataObjectModel_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
             let stringFinalStoredSecondGain = envDataObjectModel_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
             let stringFinalStoredAverageGain = envDataObjectModel_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
             
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
                 
                 print("CVS Input EHA Part 1 Summary Data Writer Success")
             } catch {
                 print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
             }
        }
    }
}
