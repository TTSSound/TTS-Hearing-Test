//
//  SimpleTestView.swift
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


struct simpleSaveFinalResults: Codable {  // This is a model
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
struct SimpleTestView: View {
    
    enum simpleSampleErrors: Error {
        case simplenotFound
        case simpleunexpected(code: Int)
    }
    
    enum simpleFirebaseErrors: Error {
        case simpleunknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()

    @State var simplelocalHeard = 0
    @State var simplelocalPlaying = Int()    // Playing = 1. Stopped = -1
    @State var simplelocalReversal = Int()
    @State var simplelocalReversalEnd = Int()
    @State var simplelocalMarkNewTestCycle = Int()
    @State var simpletestPlayer: AVAudioPlayer?
    
    @State var simplelocalTestCount = 0
    @State var simplelocalStartingNonHeardArraySet: Bool = false
    @State var simplelocalReversalHeardLast = Int()
    @State var simplelocalSeriesNoResponses = Int()
    @State var simplefirstHeardResponseIndex = Int()
    @State var simplefirstHeardIsTrue: Bool = false
    @State var simplesecondHeardResponseIndex = Int()
    @State var simplesecondHeardIsTrue: Bool = false
    @State var simplestartTooHigh = 0
    @State var simplefirstGain = Float()
    @State var simplesecondGain = Float()
    @State var simpleendTestSeries: Bool = false
    @State var simpleshowTestCompletionSheet: Bool = false
    
    @State var simple_samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    @State var simple_index: Int = 0
    @State var simple_testGain: Float = 0.2
    @State var simple_heardArray: [Int] = [Int]()
    @State var simple_indexForTest = [Int]()
    @State var simple_testCount: [Int] = [Int]()
    @State var simple_pan: Int = Int()
    @State var simple_testPan = [Int]()
    @State var simple_testTestGain = [Float]()
    @State var simple_frequency = [String]()
    @State var simple_reversalHeard = [Int]()
    @State var simple_reversalGain = [Float]()
    @State var simple_reversalFrequency = [String]()
    @State var simple_reversalDirection = Float()
    @State var simple_reversalDirectionArray = [Float]()

    @State var simple_averageGain = Float()

    @State var simple_eptaSamplesCount = 1 //17

    @State var simple_finalStoredIndex: [Int] = [Int]()
    @State var simple_finalStoredTestPan: [Int] = [Int]()
    @State var simple_finalStoredTestTestGain: [Float] = [Float]()
    @State var simple_finalStoredFrequency: [String] = [String]()
    @State var simple_finalStoredTestCount: [Int] = [Int]()
    @State var simple_finalStoredHeardArray: [Int] = [Int]()
    @State var simple_finalStoredReversalHeard: [Int] = [Int]()
    @State var simple_finalStoredFirstGain: [Float] = [Float]()
    @State var simple_finalStoredSecondGain: [Float] = [Float]()
    @State var simple_finalStoredAverageGain: [Float] = [Float]()
    
    @State var simpleidxForTest = Int() // = simple_indexForTest.count
    @State var simpleidxForTestNet1 = Int() // = simple_indexForTest.count - 1
    @State var simpleidxTestCount = Int() // = simple_TestCount.count
    @State var simpleidxTestCountUpdated = Int() // = simple_TestCount.count + 1
    @State var simpleactiveFrequency = String()
    @State var simpleidxHA = Int()    // idx = simple_heardArray.count
    @State var simpleidxReversalHeardCount = Int()
    @State var simpleidxHAZero = Int()    //  idxZero = idx - idx
    @State var simpleidxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var simpleisCountSame = Int()
    @State var simpleheardArrayIdxAfnet1 = Int()
    @State var simpletestIsPlaying: Bool = false
    @State var simpleplayingString: [String] = ["", "Start or Restart Test", "Great Job, You've Completed This Test Segment"]
    @State var simpleplayingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    @State var simpleplayingStringColorIndex = 0
    @State var simpleuserPausedTest: Bool = false

    let filesimpleName = "SummarysimpleResults.json"
    let summarysimpleCSVName = "SummarysimpleResultsCSV.csv"
    let detailedsimpleCSVName = "DetailedsimpleResultsCSV.csv"
    let inputsimpleSummaryCSVName = "InputSummarysimpleResultsCSV.csv"
    let inputsimpleDetailedCSVName = "InputDetailedsimpleResultsCSV.csv"
    
    @State var simplesaveFinalResults: simpleSaveFinalResults? = nil

    let simpleheardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let simplearrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let simpleaudioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let simplepreEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    var body: some View {
 
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .top, startRadius: -10, endRadius: 300).ignoresSafeArea()
        VStack {
                Spacer()
            Text("Simple Test")
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.bottom, 40)
                HStack {
                    Spacer()
                    Text(String(simple_testGain))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                    Spacer()
                    Button {
                        simple_heardArray.removeAll()
                        simplepauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        simplelocalPlaying = 1
                        simpleuserPausedTest = false
                        simpleplayingStringColorIndex = 0
                        print("Start Button Clicked. Playing = \(simplelocalPlaying)")
                    } label: {
                        Text(simpleplayingString[simpleplayingStringColorIndex])
                            .foregroundColor(simpleplayingStringColor[simpleplayingStringColorIndex])
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
                                simplelocalPlaying = 1
                                print("Start Button Clicked. Playing = \(simplelocalPlaying)")
                            }
                        }
                    Spacer()
                    Button {
                        simplelocalPlaying = 0
                        simplestop()
                        simpleuserPausedTest = true
                        simpleplayingStringColorIndex = 1
                        simpleaudioThread.async {
                            simplelocalPlaying = 0
                            simplestop()
                            simpleuserPausedTest = true
                            simpleplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.async {
                            simplelocalPlaying = 0
                            simplestop()
                            simpleuserPausedTest = true
                            simpleplayingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
                            simplelocalPlaying = 0
                            simplestop()
                            simpleuserPausedTest = true
                            simpleplayingStringColorIndex = 1
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
                    simpleheardThread.async{ self.simplelocalHeard = 1
                    }
                }
            Spacer()
            }
            .fullScreenCover(isPresented: $simpleshowTestCompletionSheet, content: {
                VStack(alignment: .leading) {
    
                    Button(action: {
                        simpleshowTestCompletionSheet.toggle()
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
        .onChange(of: simpletestIsPlaying, perform: { simpletestBoolValue in
            if simpletestBoolValue == true && simpleendTestSeries == false {
            //User is starting test for first time
                audioSessionModel.setAudioSession()
                simplelocalPlaying = 1
                simpleplayingStringColorIndex = 0
                simpleuserPausedTest = false
            } else if simpletestBoolValue == false && simpleendTestSeries == false {
            // User is pausing test for firts time
                simplestop()
                simplelocalPlaying = 0
                simpleplayingStringColorIndex = 1
                simpleuserPausedTest = true
            } else if simpletestBoolValue == true && simpleendTestSeries == true {
                simplestop()
                simplelocalPlaying = -1
                simpleplayingStringColorIndex = 2
                simpleuserPausedTest = true
            } else {
                print("Critical error in pause logic")
            }
        })
        // This is the lowest CPU approach from many, many tries
        .onChange(of: simplelocalPlaying, perform: { simpleplayingValue in
            simpleactiveFrequency = simple_samples[simple_index]
            simplelocalHeard = 0
            simplelocalReversal = 0
            if simpleplayingValue == 1{
                simpleaudioThread.async {
                    simpleloadAndTestPresentation(sample: simpleactiveFrequency, gain: simple_testGain)
                    while simpletestPlayer!.isPlaying == true && self.simplelocalHeard == 0 { }
                    if simplelocalHeard == 1 {
                        simpletestPlayer!.stop()
                        print("Stopped in while if: Returned Array \(simplelocalHeard)")
                    } else {
                        simpletestPlayer!.stop()
                    self.simplelocalHeard = -1
                    print("Stopped naturally: Returned Array \(simplelocalHeard)")
                    }
                }
                simplepreEventThread.async {
                    simplepreEventLogging()
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                    if self.simplelocalHeard == 1 {
                        simplelocalTestCount += 1
                        Task(priority: .userInitiated) {
                            await simpleresponseHeardArray()      //simple_heardArray.append(1)
                            await simplelocalResponseTracking()
                            await simplecount()
                            await simplelogNotPlaying()           //simple_playing = -1
                            await simpleresetPlaying()
                            await simpleresetHeard()
                            await simpleresetNonResponseCount()
                            await simplecreateReversalHeardArray()
                            await simplecreateReversalGainArray()
                            await simplecheckHeardReversalArrays()
                            await simplereversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    }
                    else if simple_heardArray.last == nil || self.simplelocalHeard == -1 {
                        simplelocalTestCount += 1
                        Task(priority: .userInitiated) {
                            await simpleheardArrayNormalize()
                            await simplecount()
                            await simplelogNotPlaying()   //self.simple_playing = -1
                            await simpleresetPlaying()
                            await simpleresetHeard()
                            await simplenonResponseCounting()
                            await simplecreateReversalHeardArray()
                            await simplecreateReversalGainArray()
                            await simplecheckHeardReversalArrays()
                            await simplereversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change    event
                        }
                    } else {
                        simplelocalTestCount = 1
                        Task(priority: .background) {
                            await simpleresetPlaying()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(simple_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: simplelocalReversal) { simplereversalValue in
            if simplereversalValue == 1 {
                DispatchQueue.global(qos: .background).async {
                    Task(priority: .userInitiated) {
//                        await simplecreateReversalHeardArray()
//                        await simplecreateReversalGainArray()
//                        await simplecheckHeardReversalArrays()
                        await simplereversalDirection()
                        await simplereversalComplexAction()
                        await simplereversalsCompleteLogging()
//                        await simpleprintReversalGain()
//                        await simpleprintData()
//                        await simpleprintReversalData()
                        await simpleconcatenateFinalArrays()
//                        await simpleprintConcatenatedArrays()
                        await simplesaveFinalStoredArrays()
                        await simpleendTestSeries()
                        await simplenewTestCycle()
                        await simplerestartPresentation()
                        print("End of Reversals")
                        print("Prepare to Start Next Presentation")
                    }
                }
            }
        }
    }
 
    
//MARK: - AudioPlayer Methods
    
    func simplepauseRestartTestCycle() {
        simplelocalMarkNewTestCycle = 0
        simplelocalReversalEnd = 0
        simple_index = simple_index
        simple_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
        simpletestIsPlaying = false
        simplelocalPlaying = 0
        simple_testCount.removeAll()
        simple_reversalHeard.removeAll()
        simple_averageGain = Float()
        simple_reversalDirection = Float()
        simplelocalStartingNonHeardArraySet = false
        simplefirstHeardResponseIndex = Int()
        simplefirstHeardIsTrue = false
        simplesecondHeardResponseIndex = Int()
        simplesecondHeardIsTrue = false
        simplelocalTestCount = 0
        simplelocalReversalHeardLast = Int()
        simplestartTooHigh = 0
    }
      
  func simpleloadAndTestPresentation(sample: String, gain: Float) {
          do{
              let simpleurlSample = Bundle.main.path(forResource: simpleactiveFrequency, ofType: ".wav")
              guard let simpleurlSample = simpleurlSample else { return print(simpleSampleErrors.simplenotFound) }
              simpletestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: simpleurlSample))
              guard let simpletestPlayer = simpletestPlayer else { return }
              simpletestPlayer.prepareToPlay()    // Test Player Prepare to Play
              simpletestPlayer.setVolume(simple_testGain, fadeDuration: 0)      // Set Gain for Playback
              simpletestPlayer.play()   // Start Playback
          } catch { print("Error in playerSessionSetUp Function Execution") }
  }
    
    func simplestop() {
      do{
          let simpleurlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let simpleurlSample = simpleurlSample else { return print(simpleSampleErrors.simplenotFound) }
          simpletestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: simpleurlSample))
          guard let simpletestPlayer = simpletestPlayer else { return }
          simpletestPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }
    
    func playTesting() async {
        do{
            let simpleurlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
            guard let simpleurlSample = simpleurlSample else {
                return print(simpleSampleErrors.simplenotFound) }
            simpletestPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: simpleurlSample))
            guard let simpletestPlayer = simpletestPlayer else { return }
            while simpletestPlayer.isPlaying == true {
                if simple_heardArray.count > 1 && simple_heardArray.index(after: simple_indexForTest.count-1) == 1 {
                    simpletestPlayer.stop()
                print("Stopped in While") }
            }
            simpletestPlayer.stop()
            print("Naturally Stopped")
        } catch { print("Error in playTesting") }
    }
    
    func simpleresetNonResponseCount() async {simplelocalSeriesNoResponses = 0 }
    
    func simplenonResponseCounting() async {simplelocalSeriesNoResponses += 1 }
     
    func simpleresetPlaying() async { self.simplelocalPlaying = 0 }
    
    func simplelogNotPlaying() async { self.simplelocalPlaying = -1 }
    
    func simpleresetHeard() async { self.simplelocalHeard = 0 }
    
    func simplereversalStart() async { self.simplelocalReversal = 1}
  
    func simplepreEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
//        DispatchQueue.global(qos: .userInitiated).async {
            simple_indexForTest.append(simple_index)
        }
        DispatchQueue.global(qos: .default).async {
            simple_testTestGain.append(simple_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            simple_frequency.append(simpleactiveFrequency)
            simple_testPan.append(simple_pan)         // 0 = Left , 1 = Middle, 2 = Right
        }
    }
    
  
//MARK: -HeardArray Methods
    
    func simpleresponseHeardArray() async {
        simple_heardArray.append(1)
      self.simpleidxHA = simple_heardArray.count
      self.simplelocalStartingNonHeardArraySet = true
    }

    func simplelocalResponseTracking() async {
        if simplefirstHeardIsTrue == false {
            simplefirstHeardResponseIndex = simplelocalTestCount
            simplefirstHeardIsTrue = true
        } else if simplefirstHeardIsTrue == true {
            simplesecondHeardResponseIndex = simplelocalTestCount
            simplesecondHeardIsTrue = true
            print("Second Heard Is True Logged!")

        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
//MARK: - THIS FUNCTION IS CAUSING ISSUES IN HEARD ARRAY. THE ISSUE IS THE DUAL IF STRUCTURE, NOT LINKED BY ELSE IF
    func simpleheardArrayNormalize() async {
        simpleidxHA = simple_heardArray.count
        simpleidxForTest = simple_indexForTest.count
        simpleidxForTestNet1 = simpleidxForTest - 1
        simpleisCountSame = simpleidxHA - simpleidxForTest
        simpleheardArrayIdxAfnet1 = simple_heardArray.index(after: simpleidxForTestNet1)
      
        if simplelocalStartingNonHeardArraySet == false {
            simple_heardArray.append(0)
            self.simplelocalStartingNonHeardArraySet = true
            simpleidxHA = simple_heardArray.count
            simpleidxHAZero = simpleidxHA - simpleidxHA
            simpleidxHAFirst = simpleidxHAZero + 1
            simpleisCountSame = simpleidxHA - simpleidxForTest
            simpleheardArrayIdxAfnet1 = simple_heardArray.index(after: simpleidxForTestNet1)
        } else if simplelocalStartingNonHeardArraySet == true {
            if simpleisCountSame != 0 && simpleheardArrayIdxAfnet1 != 1 {
                simple_heardArray.append(0)
                simpleidxHA = simple_heardArray.count
                simpleidxHAZero = simpleidxHA - simpleidxHA
                simpleidxHAFirst = simpleidxHAZero + 1
                simpleisCountSame = simpleidxHA - simpleidxForTest
                simpleheardArrayIdxAfnet1 = simple_heardArray.index(after: simpleidxForTestNet1)

            } else {
                print("Error in arrayNormalization else if isCountSame && heardAIAFnet1 if segment")
            }
        } else {
            print("Critial Error in Heard Array Count and or Values")
        }
    }
      
// MARK: -Logging Methods
    func simplecount() async {
        simpleidxTestCountUpdated = simple_testCount.count + 1
        simple_testCount.append(simpleidxTestCountUpdated)
    }
    
    
//    func arrayTesting() async {
//        let arraySet1 = Int(simple_testPan.count)
//        let arraySet2 = Int(simple_testTestGain.count) - Int(simple_frequency.count) + Int(simple_testCount.count) - Int(simple_heardArray.count)
//        if arraySet1 + arraySet2 == 0 {
//            print("All Event Logs Match")
//        } else {
//            print("Error Event Logs Length Error")
//        }
//    }
    
    func simpleprintData () async {
        DispatchQueue.global(qos: .background).async {
            print("Start printData)(")
            print("--------Array Values Logged-------------")
            print("testPan: \(simple_testPan)")
            print("testTestGain: \(simple_testTestGain)")
            print("frequency: \(simple_frequency)")
            print("testCount: \(simple_testCount)")
            print("heardArray: \(simple_heardArray)")
            print("---------------------------------------")
        }
    }
}


//struct SimpleTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTestView()
//    }
//}


extension SimpleTestView {
    

    enum simpleLastErrors: Error {
        case simplelastError
        case simplelastUnexpected(code: Int)
    }

    func simplecreateReversalHeardArray() async {
        simple_reversalHeard.append(simple_heardArray[simpleidxHA-1])
        self.simpleidxReversalHeardCount = simple_reversalHeard.count
    }
        
    func simplecreateReversalGainArray() async {
        simple_reversalGain.append(simple_testTestGain[simpleidxHA-1])
    }
    
    func simplecheckHeardReversalArrays() async {
        if simpleidxHA - simpleidxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if simpleidxHA - simpleidxReversalHeardCount < 0 && simpleidxHA - simpleidxReversalHeardCount > 0{
            fatalError("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            fatalError("hit else in check reversal arrays")
        }
    }
    
    func simplereversalDirection() async {
        simplelocalReversalHeardLast = simple_reversalHeard.last ?? -999
        if simplelocalReversalHeardLast == 1 {
            simple_reversalDirection = -1.0
            simple_reversalDirectionArray.append(-1.0)
        } else if simplelocalReversalHeardLast == 0 {
            simple_reversalDirection = 1.0
            simple_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
    
    func simplereversalOfOne() async {
        let simplerO1Direction = 0.01 * simple_reversalDirection
        let simpler01NewGain = simple_testGain + simplerO1Direction
        if simpler01NewGain > 0.00001 && simpler01NewGain < 1.0 {
            simple_testGain = roundf(simpler01NewGain * 100000) / 100000
        } else if simpler01NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler01NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func simplereversalOfTwo() async {
        let simplerO2Direction = 0.02 * simple_reversalDirection
        let simpler02NewGain = simple_testGain + simplerO2Direction
        if simpler02NewGain > 0.00001 && simpler02NewGain < 1.0 {
            simple_testGain = roundf(simpler02NewGain * 100000) / 100000
        } else if simpler02NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler02NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTwo Logic")
        }
    }
    
    func simplereversalOfThree() async {
        let simplerO3Direction = 0.03 * simple_reversalDirection
        let simpler03NewGain = simple_testGain + simplerO3Direction
        if simpler03NewGain > 0.00001 && simpler03NewGain < 1.0 {
            simple_testGain = roundf(simpler03NewGain * 100000) / 100000
        } else if simpler03NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler03NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfThree Logic")
        }
    }
    
    func simplereversalOfFour() async {
        let simplerO4Direction = 0.04 * simple_reversalDirection
        let simpler04NewGain = simple_testGain + simplerO4Direction
        if simpler04NewGain > 0.00001 && simpler04NewGain < 1.0 {
            simple_testGain = roundf(simpler04NewGain * 100000) / 100000
        } else if simpler04NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler04NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFour Logic")
        }
    }
    
    func simplereversalOfFive() async {
        let simplerO5Direction = 0.05 * simple_reversalDirection
        let simpler05NewGain = simple_testGain + simplerO5Direction
        if simpler05NewGain > 0.00001 && simpler05NewGain < 1.0 {
            simple_testGain = roundf(simpler05NewGain * 100000) / 100000
        } else if simpler05NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler05NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfFive Logic")
        }
    }
    
    func simplereversalOfTen() async {
        let simpler10Direction = 0.10 * simple_reversalDirection
        let simpler10NewGain = simple_testGain + simpler10Direction
        if simpler10NewGain > 0.00001 && simpler10NewGain < 1.0 {
            simple_testGain = roundf(simpler10NewGain * 100000) / 100000
        } else if simpler10NewGain <= 0.0 {
            simple_testGain = 0.00001
            print("!!!Fatal Zero Gain Catch")
        } else if simpler10NewGain >= 1.0 {
            simple_testGain = 1.0
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfTen Logic")
        }
    }
    
    func simplereversalAction() async {
        if simplelocalReversalHeardLast == 1 {
            await simplereversalOfFive()
        } else if simplelocalReversalHeardLast == 0 {
            await simplereversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func simplereversalComplexAction() async {
        if simpleidxReversalHeardCount <= 1 && simpleidxHA <= 1 {
            await simplereversalAction()
        }  else if simpleidxReversalHeardCount == 2 {
            if simpleidxReversalHeardCount == 2 && simplesecondHeardIsTrue == true {
                await simplestartTooHighCheck()
            } else if simpleidxReversalHeardCount == 2  && simplesecondHeardIsTrue == false {
                await simplereversalAction()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if simpleidxReversalHeardCount >= 3 {
            print("reversal section >= 3")
            if simplesecondHeardResponseIndex - simplefirstHeardResponseIndex == 1 {
                print("reversal section >= 3")
                print("In first if section sHRI - fHRI == 1")
                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
            } else if simplelocalSeriesNoResponses == 3 {
                await simplereversalOfTen()
            } else if simplelocalSeriesNoResponses == 2 {
                await simplereversalOfFour()
            } else {
                await simplereversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    func simpleprintReversalGain() async {
        DispatchQueue.global(qos: .background).async {
            print("New Gain: \(simple_testGain)")
            print("Reversal Direcction: \(simple_reversalDirection)")
        }
    }
    
    func simplereversalHeardCount1() async {
       await simplereversalAction()
   }
            
    func simplecheck2PositiveSeriesReversals() async {
        if simple_reversalHeard[simpleidxHA-2] == 1 && simple_reversalHeard[simpleidxHA-1] == 1 {
            print("reversal - check2PositiveSeriesReversals")
            print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
        }
    }

    func simplecheckTwoNegativeSeriesReversals() async {
        if simple_reversalHeard.count >= 3 && simple_reversalHeard[simpleidxHA-2] == 0 && simple_reversalHeard[simpleidxHA-1] == 0 {
            await simplereversalOfFour()
        } else {
            await simplereversalAction()
        }
    }
    
    func simplestartTooHighCheck() async {
        if simplestartTooHigh == 0 && simplefirstHeardIsTrue == true && simplesecondHeardIsTrue == true {
            simplestartTooHigh = 1
            await simplereversalOfTen()
            await simpleresetAfterTooHigh()
            print("Too High Found")
        } else {
            await simplereversalAction()
        }
    }
    
    func simpleresetAfterTooHigh() async {
        simplefirstHeardResponseIndex = Int()
        simplefirstHeardIsTrue = false
        simplesecondHeardResponseIndex = Int()
        simplesecondHeardIsTrue = false
    }

    func simplereversalsCompleteLogging() async {
        if simplesecondHeardIsTrue == true {
            self.simplelocalReversalEnd = 1
            self.simplelocalMarkNewTestCycle = 1
            self.simplefirstGain = simple_reversalGain[simplefirstHeardResponseIndex-1]
            self.simplesecondGain = simple_reversalGain[simplesecondHeardResponseIndex-1]
            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")

            let simpledelta = simplefirstGain - simplesecondGain
            let simpleavg = (simplefirstGain + simplesecondGain)/2
            
            if simpledelta == 0 {
                simple_averageGain = simplesecondGain
                print("average Gain: \(simple_averageGain)")
            } else if simpledelta >= 0.05 {
                simple_averageGain = simplesecondGain
                print("SecondGain: \(simplefirstGain)")
                print("SecondGain: \(simplesecondGain)")
                print("average Gain: \(simple_averageGain)")
            } else if simpledelta <= -0.05 {
                simple_averageGain = simplefirstGain
                print("SecondGain: \(simplefirstGain)")
                print("SecondGain: \(simplesecondGain)")
                print("average Gain: \(simple_averageGain)")
            } else if simpledelta < 0.05 && simpledelta > -0.05 {
                simple_averageGain = simpleavg
                print("SecondGain: \(simplefirstGain)")
                print("SecondGain: \(simplesecondGain)")
                print("average Gain: \(simple_averageGain)")
            } else {
                simple_averageGain = simpleavg
                print("SecondGain: \(simplefirstGain)")
                print("SecondGain: \(simplesecondGain)")
                print("average Gain: \(simple_averageGain)")
            }
        } else if simplesecondHeardIsTrue == false {
                print("Contine, second hear is true = false")
        } else {
                print("Critical error in reversalsCompletLogging Logic")
        }
    }

    func simpleprintReversalData() async {
        print("--------Reversal Values Logged-------------")
        print("indexForTest: \(simple_indexForTest)")
        print("Test Pan: \(simple_testPan)")
        print("New TestGain: \(simple_testTestGain)")
        print("reversalFrequency: \(simpleactiveFrequency)")
        print("testCount: \(simple_testCount)")
        print("heardArray: \(simple_heardArray)")
        print("reversalHeard: \(simple_reversalHeard)")
        print("FirstGain: \(simplefirstGain)")
        print("SecondGain: \(simplesecondGain)")
        print("AverageGain: \(simple_averageGain)")
        print("------------------------------------------")
    }
        
    func simplerestartPresentation() async {
        if simpleendTestSeries == false {
            simplelocalPlaying = 1
            simpleendTestSeries = false
        } else if simpleendTestSeries == true {
            simplelocalPlaying = -1
            simpleendTestSeries = true
            simpleshowTestCompletionSheet = true
            simpleplayingStringColorIndex = 2
        }
    }
    
    func simplewipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            simple_heardArray.removeAll()
            simple_testCount.removeAll()
            simple_reversalHeard.removeAll()
            simple_averageGain = Float()
            simple_reversalDirection = Float()
            simplelocalStartingNonHeardArraySet = false
            simplefirstHeardResponseIndex = Int()
            simplefirstHeardIsTrue = false
            simplesecondHeardResponseIndex = Int()
            simplesecondHeardIsTrue = false
            simplelocalTestCount = 0
            simplelocalReversalHeardLast = Int()
            simplestartTooHigh = 0
            simplelocalSeriesNoResponses = Int()
        })
    }
    
    func simplenewTestCycle() async {
        if simplelocalMarkNewTestCycle == 1 && simplelocalReversalEnd == 1 && simple_index < simple_eptaSamplesCount && simpleendTestSeries == false {
            simplestartTooHigh = 0
            simplelocalMarkNewTestCycle = 0
            simplelocalReversalEnd = 0
            simple_index = simple_index + 1
            simple_testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
            simpleendTestSeries = false
//                Task(priority: .userInitiated) {
            await simplewipeArrays()
//                }
        } else if simplelocalMarkNewTestCycle == 1 && simplelocalReversalEnd == 1 && simple_index == simple_eptaSamplesCount && simpleendTestSeries == false {
            simpleendTestSeries = true
            simplelocalPlaying = -1
                print("=============================")
                print("!!!!! End of Test Series!!!!!!")
                print("=============================")
        } else {
//                print("Reversal Limit Not Hit")

        }
    }
    
    func simpleendTestSeries() async {
        if simpleendTestSeries == false {
            //Do Nothing and continue
            print("end Test Series = \(simpleendTestSeries)")
        } else if simpleendTestSeries == true {
            simpleshowTestCompletionSheet = true
            await simpleendTestSeriesStop()
        }
    }
    
    func simpleendTestSeriesStop() async {
        simplelocalPlaying = -1
        simplestop()
        simpleuserPausedTest = true
        simpleplayingStringColorIndex = 2
        
        simpleaudioThread.async {
            simplelocalPlaying = 0
            simplestop()
            simpleuserPausedTest = true
            simpleplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.async {
            simplelocalPlaying = 0
            simplestop()
            simpleuserPausedTest = true
            simpleplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, qos: .userInitiated) {
            simplelocalPlaying = 0
            simplestop()
            simpleuserPausedTest = true
            simpleplayingStringColorIndex = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, qos: .userInitiated) {
            simplelocalPlaying = -1
            simplestop()
            simpleuserPausedTest = true
            simpleplayingStringColorIndex = 2
        }
    }
    
    func simpleconcatenateFinalArrays() async {
        if simplelocalMarkNewTestCycle == 1 && simplelocalReversalEnd == 1 {
            simple_finalStoredIndex.append(contentsOf: [100000000] + simple_indexForTest)
            simple_finalStoredTestPan.append(contentsOf: [100000000] + simple_testPan)
            simple_finalStoredTestTestGain.append(contentsOf: [1000000.0] + simple_testTestGain)
            simple_finalStoredFrequency.append(contentsOf: ["100000000"] + [String(simpleactiveFrequency)])
            simple_finalStoredTestCount.append(contentsOf: [100000000] + simple_testCount)
            simple_finalStoredHeardArray.append(contentsOf: [100000000] + simple_heardArray)
            simple_finalStoredReversalHeard.append(contentsOf: [100000000] + simple_reversalHeard)
            simple_finalStoredFirstGain.append(contentsOf: [1000000.0] + [simplefirstGain])
            simple_finalStoredSecondGain.append(contentsOf: [1000000.0] + [simplesecondGain])
            simple_finalStoredAverageGain.append(contentsOf: [1000000.0] + [simple_averageGain])
        }
    }
    
    func simpleprintConcatenatedArrays() async {
        print("finalStoredIndex: \(simple_finalStoredIndex)")
        print("finalStoredTestPan: \(simple_finalStoredTestPan)")
        print("finalStoredTestTestGain: \(simple_finalStoredTestTestGain)")
        print("finalStoredFrequency: \(simple_finalStoredFrequency)")
        print("finalStoredTestCount: \(simple_finalStoredTestCount)")
        print("finalStoredHeardArray: \(simple_finalStoredHeardArray)")
        print("finalStoredReversalHeard: \(simple_finalStoredReversalHeard)")
        print("finalStoredFirstGain: \(simple_finalStoredFirstGain)")
        print("finalStoredSecondGain: \(simple_finalStoredSecondGain)")
        print("finalStoredAverageGain: \(simple_finalStoredAverageGain)")
    }
        
    func simplesaveFinalStoredArrays() async {
        if simplelocalMarkNewTestCycle == 1 && simplelocalReversalEnd == 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
                    await simplewriteEHA1DetailedResultsToCSV()
                    await simplewriteEHA1SummarydResultsToCSV()
                    await simplewriteEHA1InputDetailedResultsToCSV()
                    await simplewriteEHA1InputDetailedResultsToCSV()
                    await simplegetEHAP1Data()
                    await simplesaveEHA1ToJSON()
        //                await simple_uploadSummaryResultsTest()
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
    
    func simplegetEHAP1Data() async {
        guard let simpledata = await simplegetEHAP1JSONData() else { return }
        print("Json Data:")
        print(simpledata)
        let simplejsonString = String(data: simpledata, encoding: .utf8)
        print(simplejsonString!)
        do {
        self.simplesaveFinalResults = try JSONDecoder().decode(simpleSaveFinalResults.self, from: simpledata)
            print("JSON GetData Run")
            print("data: \(simpledata)")
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func simplegetEHAP1JSONData() async -> Data? {
        let simplesaveFinalResults = simpleSaveFinalResults(
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
            jsonFrequency: [simpleactiveFrequency],
            jsonPan: simple_finalStoredTestPan,
            jsonStoredIndex: simple_finalStoredIndex,
            jsonStoredTestPan: simple_finalStoredTestPan,
            jsonStoredTestTestGain: simple_finalStoredTestTestGain,
            jsonStoredTestCount: simple_finalStoredTestCount,
            jsonStoredHeardArray: simple_finalStoredHeardArray,
            jsonStoredReversalHeard: simple_finalStoredReversalHeard,
            jsonStoredFirstGain: simple_finalStoredFirstGain,
            jsonStoredSecondGain: simple_finalStoredSecondGain,
            jsonStoredAverageGain: simple_finalStoredAverageGain)

        let simplejsonData = try? JSONEncoder().encode(simplesaveFinalResults)
        print("saveFinalResults: \(simplesaveFinalResults)")
        print("Json Encoded \(simplejsonData!)")
        return simplejsonData
    }

    func simplesaveEHA1ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let simplepaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let simpleDocumentsDirectory = simplepaths[0]
        print("simpleDocumentsDirectory: \(simpleDocumentsDirectory)")
        let simpleFilePaths = simpleDocumentsDirectory.appendingPathComponent(filesimpleName)
        print(simpleFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let simplejsonData = try encoder.encode(simplesaveFinalResults)
            print(simplejsonData)
          
            try simplejsonData.write(to: simpleFilePaths)
        } catch {
            print("Error writing EHAP1 to JSON file: \(error)")
        }
    }

    func simplewriteEHA1DetailedResultsToCSV() async {
        let simplestringFinalStoredIndex = "finalStoredIndex," + simple_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestPan = "finalStoredTestPan," + simple_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestTestGain = "finalStoredTestTestGain," + simple_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredFrequency = "finalStoredFrequency," + [simpleactiveFrequency].map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestCount = "finalStoredTestCount," + simple_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredHeardArray = "finalStoredHeardArray," + simple_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredReversalHeard = "finalStoredReversalHeard," + simple_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredPan = "finalStoredPan," + simple_testPan.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredFirstGain = "finalStoredFirstGain," + simple_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredSecondGain = "finalStoredSecondGain," + simple_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredAverageGain = "finalStoredAverageGain," + simple_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        
        do {
            let csvsimpleDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvsimpleDetailDocumentsDirectory = csvsimpleDetailPath
//                print("CSV DocumentsDirectory: \(csvEHAP1DetailDocumentsDirectory)")
            let csvsimpleDetailFilePath = csvsimpleDetailDocumentsDirectory.appendingPathComponent(detailedsimpleCSVName)
            print(csvsimpleDetailFilePath)
            
            let writer = try CSVWriter(fileURL: csvsimpleDetailFilePath, append: false)
            
            try writer.write(row: [simplestringFinalStoredIndex])
            try writer.write(row: [simplestringFinalStoredTestPan])
            try writer.write(row: [simplestringFinalStoredTestTestGain])
            try writer.write(row: [simplestringFinalStoredFrequency])
            try writer.write(row: [simplestringFinalStoredTestCount])
            try writer.write(row: [simplestringFinalStoredHeardArray])
            try writer.write(row: [simplestringFinalStoredReversalHeard])
            try writer.write(row: [simplestringFinalStoredPan])
            try writer.write(row: [simplestringFinalStoredFirstGain])
            try writer.write(row: [simplestringFinalStoredSecondGain])
            try writer.write(row: [simplestringFinalStoredAverageGain])
//
//                print("CVS EHAP1 Detailed Writer Success")
        } catch {
            print("CVSWriter EHAP1 Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }

    func simplewriteEHA1SummarydResultsToCSV() async {
         let simplestringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + [simpleactiveFrequency].map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredTestPan = "finalStoredTestPan," + simple_testPan.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredFirstGain = "finalStoredFirstGain," + simple_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredSecondGain = "finalStoredSecondGain," + simple_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredAverageGain = "finalStoredAverageGain," + simple_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        
         do {
             let csvsimpleSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvsimpleSummaryDocumentsDirectory = csvsimpleSummaryPath
//                 print("CSV Summary EHA Part 1 DocumentsDirectory: \(csvEHAP1SummaryDocumentsDirectory)")
             let csvsimpleSummaryFilePath = csvsimpleSummaryDocumentsDirectory.appendingPathComponent(summarysimpleCSVName)
             print(csvsimpleSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvsimpleSummaryFilePath, append: false)
             try writer.write(row: [simplestringFinalStoredResultsFrequency])
             try writer.write(row: [simplestringFinalStoredTestPan])
             try writer.write(row: [simplestringFinalStoredFirstGain])
             try writer.write(row: [simplestringFinalStoredSecondGain])
             try writer.write(row: [simplestringFinalStoredAverageGain])
//
//                 print("CVS Summary EHA Part 1 Data Writer Success")
         } catch {
             print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func simplewriteEHA1InputDetailedResultsToCSV() async {
        let simplestringFinalStoredIndex = simple_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestPan = simple_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestTestGain = simple_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredTestCount = simple_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredHeardArray = simple_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredReversalHeard = simple_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredResultsFrequency = [simpleactiveFrequency].map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredPan = simple_testPan.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredFirstGain = simple_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredSecondGain = simple_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let simplestringFinalStoredAverageGain = simple_finalStoredAverageGain.map { String($0) }.joined(separator: ",")

        do {
            let csvInputsimpleDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputsimpleDetailDocumentsDirectory = csvInputsimpleDetailPath
//                print("CSV Input EHAP1 Detail DocumentsDirectory: \(csvInputEHAP1DetailDocumentsDirectory)")
            let csvInputsimpleDetailFilePath = csvInputsimpleDetailDocumentsDirectory.appendingPathComponent(inputsimpleDetailedCSVName)
            print(csvInputsimpleDetailFilePath)
            let writer = try CSVWriter(fileURL: csvInputsimpleDetailFilePath, append: false)
            try writer.write(row: [simplestringFinalStoredIndex])
            try writer.write(row: [simplestringFinalStoredTestPan])
            try writer.write(row: [simplestringFinalStoredTestTestGain])
            try writer.write(row: [simplestringFinalStoredTestCount])
            try writer.write(row: [simplestringFinalStoredHeardArray])
            try writer.write(row: [simplestringFinalStoredReversalHeard])
            try writer.write(row: [simplestringFinalStoredResultsFrequency])
            try writer.write(row: [simplestringFinalStoredPan])
            try writer.write(row: [simplestringFinalStoredFirstGain])
            try writer.write(row: [simplestringFinalStoredSecondGain])
            try writer.write(row: [simplestringFinalStoredAverageGain])
//
//                print("CVS Input EHA Part 1Detailed Writer Success")
        } catch {
            print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }

    func simplewriteEHA1InputSummarydResultsToCSV() async {
         let simplestringFinalStoredResultsFrequency = [simpleactiveFrequency].map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredTestPan = simple_finalStoredTestPan.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredFirstGain = simple_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredSecondGain = simple_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
         let simplestringFinalStoredAverageGain = simple_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
         
         do {
             let csvsimpleInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvsimpleInputSummaryDocumentsDirectory = csvsimpleInputSummaryPath
             print("CSV Input simple Summary DocumentsDirectory: \(csvsimpleInputSummaryDocumentsDirectory)")
             let csvsimpleInputSummaryFilePath = csvsimpleInputSummaryDocumentsDirectory.appendingPathComponent(inputsimpleSummaryCSVName)
             print(csvsimpleInputSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvsimpleInputSummaryFilePath, append: false)
             try writer.write(row: [simplestringFinalStoredResultsFrequency])
             try writer.write(row: [simplestringFinalStoredTestPan])
             try writer.write(row: [simplestringFinalStoredFirstGain])
             try writer.write(row: [simplestringFinalStoredSecondGain])
             try writer.write(row: [simplestringFinalStoredAverageGain])
//
//                 print("CVS Input EHA Part 1 Summary Data Writer Success")
         } catch {
             print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
         }
    }
}

