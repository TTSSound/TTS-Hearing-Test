//
//  DONOTChangeReferenceEPTATTSTestV4List.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/10/22.
//


//import SwiftUI
//import Foundation
//import AVFAudio
//import AVFoundation
//import AVKit
//import CoreMedia
//import Darwin
//import Security
//import Combine
//import CoreData
//import CodableCSV
//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift
//import Firebase
//import FileProvider
//
//
//
////_____________Items to Add_____________//
//// Pop up disclosure with attestation
//// User entry pop up--name, age, sex, email
//// Screen for test type selection (Purchase option)
//    // Headphone, Devices & system Selection--> Calibrated only
//        // Make request for your device to be calibrated
//// Pop up notification to turn on do not disturb or airplane mode and to set volume to max
//    // Close all other applications when testing
//        // This all helps with calibration
//// Attestation that all of these have been done
//// MPView Volume Slider to set it to 50% output volume
//    // Then have volume slider hide
//// Then screen to explain test and user instructions
//    // Explanation about pausing the test
//    // Expl;anation about taking EPTA and EHA in two sittings
//// Then practice sound and response
//// Then start the test
//// End of Test
//// Display results in graph and notice that more details will be emailed
//// Reminder to turn down volume, turn off airplane mode and turn off do not disturb
//// Exit App
////
////____________________________________//
//
//




//struct DONOTChangeReferenceEPTATTSTestV4List: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}




//struct EPTATTSTestV4List: View {
//    enum SampleErrors: Error {
//        case notFound
//        case unexpected(code: Int)
//    }
//
//    enum FirebaseErrors: Error {
//        case unknownFileURL
//    }
//
////    let storage = Storage.storage()
////    let storageRef = Storage.storage().reference()
////    var myData: Data?
//
////    @StateObject var detailResultsEntity : DetailResultsEntity = DetailResultsEntity()
//
//    @StateObject var envDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
////    @StateObject var summarResultsEntity: SummaryResultsEntity = SummaryResultsEntity()
////    @State var persistenceProvider: PersistenceProvider = PersistenceProvider()
//
//    var audioSessionModel = AudioSessionModel()
//
//    @State var heardArrayValue = [Int]()
//    @State var localHeard = 0
//    @State var localPlaying = Int()    // Playing = 1. Stopped = -1
//    @State var localPanSelection = Int()
//    @State var localReversal = Int()
//    @State var localReversalEnd = Int()
//    @State var localMarkNewTestCycle = Int()
//    @State var testPlayer: AVAudioPlayer?
//
//
//
//    @State var localTestCountLast = Int()
//    @State var localheardArrayLast = Int()
//    @State var localTestTestGainLast = Float()
//    @State var localReversalHeardLast = Int()
//    @State var startTooHigh = 0
//    @State var first: Int?
//    @State var first1 = Int()
//    @State var second: Int?
//    @State var second1 = Int()
//    @State var firstG: Float?
//    @State var secondG: Float?
//    @State var firstGain = Float()
//    @State var secondGain = Float()
//
//
//
//
//    let heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInteractive)
//    let arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
//    let audioThread = DispatchQueue(label: "AudioThread", qos: .utility)
//
//    var body: some View {
//
//
//        ZStack{
//            RadialGradient(
//                gradient: Gradient(colors: [Color.blue, Color.black]),
//                center: .center,
//                startRadius: -100,
//                endRadius: 300).ignoresSafeArea()
//        VStack{
//            HStack{
//                VStack{
//                    Text("RePrint Data")
//                        .fontWeight(.bold)
//                        .padding()
//                        .foregroundColor(.white)
//                        .onTapGesture{
//                            Task(priority: .userInitiated) { await printData() }
//                        }
//                    Text("Click to setaudioSession")
//                        .fontWeight(.bold)
//                        .padding()
//                        .foregroundColor(.white)
//                        .onTapGesture {
//                            audioSessionModel.setAudioSession()
//                            print(audioSessionModel.audioSession.outputVolume)
//                        }
//                    }
//                Spacer()
//                VStack {
//                    Text(String(envDataObjectModel.testGain))
//                        .fontWeight(.bold)
//                        .padding()
//                        .foregroundColor(.white)
//
//                    Text(String(envDataObjectModel.reversalDirection))
//                        .fontWeight(.bold)
//                        .padding()
//                        .foregroundColor(.white)
//                }
//                Spacer()
//
//            }
//           Spacer()
//            HStack{
//                Spacer()
//            Text("Click to Stat or Restart Test")
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.blue)
//                .onTapGesture {
//                    audioSessionModel.setAudioSession()
//                    localPlaying = 1
//                    print("Start Button Clicked. Playing = \(localPlaying)")
//                }
//                Spacer()
//                Button {
//                    Task(priority: .background, operation: {
//                        await uploadCSV()
//                    })
//                    } label: {
//                        Text("Upload Results")
//                    }
//                Spacer()
//                }
//
//            HStack{
//                Spacer()
//                Button {
//                    heardThread.async {
//                        localPlaying = 0
//                        stop()
//                    }
//                } label: {
//                    Text("Pause Test")
//                        .foregroundColor(.yellow)
//                }
//                Spacer()
//                NavigationLink {
//                    PostAllTestsSplashView()
//                } label: {
//                    Text("Proceed")
//                        .foregroundColor(.green)
//                }
//                Spacer()
//            }
//
//            Spacer()
//            Text("Press if You Hear The Tone")
//                .fontWeight(.semibold)
//                .padding()
//                .frame(width: 300, height: 100, alignment: .center)
//                .background(Color .green)
//                .foregroundColor(.black)
//                .cornerRadius(300)
//                .onTapGesture(count: 1) {
//                    heardThread.async{ self.localHeard = 1
//                        print("Heard Button Pressed; Heard: \(localHeard)")
//                    }
//                }
//            Spacer()
//            }
//        .onAppear {
//            Task(priority: .userInitiated) {
//                audioSessionModel.setAudioSession()
//                print(audioSessionModel.audioSession.outputVolume)
//            }
//            Task(priority: .userInitiated) { await printData() }
//        }
//
//        Spacer()
//        }
//        .environmentObject(envDataObjectModel)
//        .onChange(of: localPlaying, perform: { playingValue in
//            print("Playing Value: \(playingValue)")
//            localHeard = 0
//            localReversal = 0
//            if playingValue == 1 {
//                setPan()
//                preEventLogging()
//                audioThread.async {
//                    loadAndTestPresentation(sample: envDataObjectModel.samples[envDataObjectModel.index], gain: envDataObjectModel.testGain, pan: envDataObjectModel.pan)
//                    while testPlayer!.isPlaying == true && self.localHeard == 0 { }
//                    if localHeard == 1 {
//                        testPlayer!.stop()
//                        print("Stopped in while if: Returned Array \(localHeard)")
//                    } else {
//                    testPlayer!.stop()
//                    self.localHeard = -1
//                    print("Stopped naturally: Returned Array \(localHeard)")
//                    }
//                }
//                print("LocalHeard: \(localHeard) localPlaying: \(localPlaying)")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
//                    print("Post Silence Accounted For")
//                    Task(priority: .userInitiated) {
//                        if self.localHeard == 1 {
//                            await responseHeardArray()      //envDataObjectModel.heardArray.append(1)
//                            await postEventLogging()
//                            await heardEventLogging()
//                            await count()
//                            await logNotPlaying()           //envDataObjectModel.playing = -1
//                            await arrayTesting()
//                            await printData()
//                            await resetPlaying()
//                            await resetHeard()
//                            print("Stopped in Task If Segment: \(envDataObjectModel.heardArray)")
//                            print("Playing Reset playingValue: \(playingValue)")
//                            await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
//                        }
//                        else if envDataObjectModel.heardArray.last == nil || self.localHeard == -1 {
//                            await postEventLogging()
//                            await nonHeardEventLogging()
//                            await heardArrayNormalize()
//                            await count()
//                            await logNotPlaying()   //self.envDataObjectModel.playing = -1
//                            await arrayTesting()
//                            await printData()
//
//                            await resetPlaying()
//                            await resetHeard()
//                            print("Stopped in Task nil else if segment: \(envDataObjectModel.heardArray)")
//                            print("Playing Reset playingValue: \(playingValue)")
//                            await reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
//                        } else {
//
//                            await printData()
//                            await resetPlaying()
//                            await resetHeard()
//                            print("Playing Reset playingValue: \(playingValue)")
//                            print("Fatal Error: Stopped in Task else")
//                        }
//                    }
//                }
//            }
//        })
//        .onChange(of: localReversal) { reversalValue in
//            if reversalValue == 1 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    Task {
//                        await getLastValues()
//                        await createReversalArrays()
//                        await reversalDirection()
//                        await reversalComplexAction()
//                        await sumReversalLogging()
//                        await printReversalData()
//                        await restartPresentation()
//                        await concatenateFinalArrays()
//                        await printFinalStoredArrays()
//                        await newTestCycle()
//                        print("End of Reversals")
//                        print("Prepare to Start Next Presentation")
//                    }
//                }
//            }
//        }
//    }
//
//
//
//    //MARK: - AudioPlayer Methods
//
//
//
//    func loadAndTestPresentation(sample: String, gain: Float, pan: Int ) {
//      do{
//          let urlSample = Bundle.main.path(forResource: envDataObjectModel.samples[envDataObjectModel.index], ofType: envDataObjectModel.sampleType)
//          guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
//          testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
//          guard let testPlayer = testPlayer else { return }
//          testPlayer.prepareToPlay()    // Test Player Prepare to Play
//          testPlayer.setVolume(envDataObjectModel.testGain, fadeDuration: 0)      // Set Gain for Playback
//          testPlayer.play()   // Start Playback
//      } catch { print("Error in playerSessionSetUp Function Execution") }
//    }
//
//    func stop() {
//      do{
//          let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
//          guard let urlSample = urlSample else { return print(SampleErrors.notFound) }
//          testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
//          guard let testPlayer = testPlayer else { return }
//          testPlayer.stop()
//      } catch { print("Error in Player Stop Function") }
//    }
//
//    func playTesting() async {
//        do{
//            let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
//            guard let urlSample = urlSample else {
//                return print(SampleErrors.notFound) }
//            testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
//            guard let testPlayer = testPlayer else { return }
//            while testPlayer.isPlaying == true {
//                if envDataObjectModel.heardArray.count > 1 && envDataObjectModel.heardArray.index(after: envDataObjectModel.indexForTest.count-1) == 1 {
//                testPlayer.stop()
//                print("Stopped in While") }
//            }
//            testPlayer.stop()
//            print("Naturally Stopped")
//        } catch { print("Error in playTesting") }
//    }
//
//    func setPan() {
//        // some if logic to determine pan
//        localPanSelection = 1
//        envDataObjectModel.pan = localPanSelection
//    }
//
//    func resetPlaying() async { self.localPlaying = 0 }
//
//    func logNotPlaying() async { self.localPlaying = -1 }
//
//    func resetHeard() async { self.localHeard = 0 }
//
//    func reversalStart() async { self.localReversal = 1}
//
//
//    //MARK: -HeardArray Methods
//
//      func responseHeardArray() async { envDataObjectModel.heardArray.append(1) }
//
//      func heardArrayNormalize() async {
//          if envDataObjectModel.heardArray.last == nil && envDataObjectModel.heardArray.count <= 1 {
//              envDataObjectModel.heardArray.append(0)
//              print("Starting Test: First Append(0) to Heard Array if No Response")
//    //          } else if envDataObjectModel.indexForTest.count - envDataObjectModel.heardArray.count == 1 && envDataObjectModel.heardArray.index(after: envDataObjectModel.indexForTest.count-1) != 1 {
//          } else if envDataObjectModel.indexForTest.count - envDataObjectModel.heardArray.count != 0 && envDataObjectModel.heardArray.index(after: envDataObjectModel.indexForTest.count-1) != 1 {
//              envDataObjectModel.heardArray.append(0)
//              print("Append(0) to Heard Array for Assumed No Response")
//          } else {
//              print("Critial Error in Heard Array Count and or Values") }
//      }
//
//    // MARK: -Logging Methods
//    func count() async {
//          let reducedCount = envDataObjectModel.testCount.count
//          let newCount = reducedCount + 1
//          envDataObjectModel.testCount.append(newCount)
//    }
//
//      func preEventLogging() {
//          // Initialize Time Clock
//          CMClockGetTime(envDataObjectModel.masterClock)
//          CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//          // Initial Time Stamp
//          let iTS2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//          envDataObjectModel.testStartSeconds.append(iTS2)   //Seconds Time
//          // Pre Event Logging
//          envDataObjectModel.indexForTest.append(envDataObjectModel.index)
//          envDataObjectModel.testPan.append(envDataObjectModel.pan)         // 0 = Left , 1 = Middle, 2 = Right
//          envDataObjectModel.testTestGain.append(envDataObjectModel.testGain)
//          envDataObjectModel.frequency.append(envDataObjectModel.samples[envDataObjectModel.index])
//      }
//
//    func postEventLogging() async {
//        CMClockGetTime(envDataObjectModel.masterClock)
//        let peL2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        envDataObjectModel.testEndSeconds.append(peL2)
//
//
//    }
//
//    func nonHeardEventLogging() async {
//        envDataObjectModel.userRespCMSeconds.append(0.0)
//        print("heardArray Update Not registered")
//    }
//
//    func heardEventLogging() async {
//        let y2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        envDataObjectModel.userRespCMSeconds.append(y2)
//        print("hearArray update caught in heardEventLogging")
//    }
//
//    func heardNotHeardEventLogging() async {
//        if envDataObjectModel.heardArray.last == nil || envDataObjectModel.heardArray.last == 0 {
//            envDataObjectModel.userRespCMSeconds.append(0.0)
//            print("heardArray Not Updated, No Click")
//        } else {
//            let y2 = CACurrentMediaTime()
//            envDataObjectModel.testEndSeconds.append(y2)
//            print("hearArray update caught in heardNotHeardEventLogging")
//        }
//    }
//
//    func reduceHeardEventLogging() async {
//        envDataObjectModel.userRespCMSeconds.remove(at: envDataObjectModel.userRespCMSeconds.count-1)
//    }
//
//    func arrayTesting() async {
//        let arraySet1 = Int(envDataObjectModel.testStartSeconds.count) - Int(envDataObjectModel.testEndSeconds.count) + Int(envDataObjectModel.userRespCMSeconds.count) - Int(envDataObjectModel.testPan.count)
//        let arraySet2 = Int(envDataObjectModel.testTestGain.count) - Int(envDataObjectModel.frequency.count) + Int(envDataObjectModel.testCount.count) - Int(envDataObjectModel.heardArray.count)
//        if arraySet1 + arraySet2 == 0 {
//            print("All Event Logs Match")
//        } else {
//            print("Error Event Logs Length Error")
//        }
//    }
//
//    func printData () async {
//        print("--------Array Values Logged-------------")
//        print("testStartSeconds: \(envDataObjectModel.testStartSeconds)")
//        print("testEndSeconds: \(envDataObjectModel.testEndSeconds)")
//        print("userRespCMSeconds: \(envDataObjectModel.userRespCMSeconds)")
//        print("testPan: \(envDataObjectModel.testPan)")
//        print("testTestGain: \(envDataObjectModel.testTestGain)")
//        print("frequency: \(envDataObjectModel.frequency)")
//        print("testCount: \(envDataObjectModel.testCount)")
//        print("heardArray: \(envDataObjectModel.heardArray)")
//        print("---------------------------------------")
//    }
//}


//struct DONOTChangeReferenceEPTATTSTestV4List_Previews: PreviewProvider {
//    static var previews: some View {
//        DONOTChangeReferenceEPTATTSTestV4List()
//    }
//}
//
////MARK: - Reversal Extension
//extension EPTATTSTestV4List {
//    enum LastErrors: Error {
//        case lastError
//        case lastUnexpected(code: Int)
//    }
//
//    func getLastValues() async {
//        let idx = envDataObjectModel.heardArray.count
//        print("idx: \(idx)")
//        if envDataObjectModel.reversalHeard.count < idx {
//           localReversalHeardLast = 0
//        } else {
//            localReversalHeardLast = envDataObjectModel.reversalHeard[idx-1]
//        }
//        localTestCountLast = envDataObjectModel.testCount[idx-1]
//        localheardArrayLast = envDataObjectModel.heardArray[idx-1]
//        localTestTestGainLast = envDataObjectModel.testTestGain[idx-1]
//
//        if localTestCountLast == 0 || localTestCountLast <= 0 {
//            print("Fatal Error in testCount Array Value in Reversal")
//            print(localTestCountLast)
//        } else {
//            localTestCountLast = envDataObjectModel.testCount[idx-1]
//            print("Success localTestCountLast: \(localTestCountLast)")
//        }
//        if localheardArrayLast < 0{
//            print("Fatal Error in heardArray Array Value in Reversal: \(localheardArrayLast)")
//        } else {
//            localheardArrayLast = envDataObjectModel.heardArray[idx-1]
//            print("Success localheardArrayLast: \(localheardArrayLast)")
//        }
//        if localReversalHeardLast < 0 {
//            localReversalHeardLast = 0
//            print("Starting nil found reversalHeard Array Value in Reversal: \(localReversalHeardLast)")
//        } else if localReversalHeardLast >= 0 {
//            localReversalHeardLast = envDataObjectModel.heardArray[idx-1]
//            print("Found reversalHeard Array Count>=1 & .last Value !=nil in Reversal: \(localheardArrayLast)")
//        } else {
//            print("Fatal Error in reversalHeard Array Value in Reversal: \(localheardArrayLast)")
//        }
//        if localTestTestGainLast == 0 ||  localTestTestGainLast <= 0 {
//            print("Fatal Error in testTestGain Array Value in Reversal: \(localTestTestGainLast)")
//        } else {
//            localTestTestGainLast = envDataObjectModel.testTestGain[idx-1]
//            print("Success localTestTestGain: \(localTestTestGainLast)")
//        }
//    }
//
//    func createReversalArrays() async {
//        let idx = envDataObjectModel.heardArray.count
//        print("idx: \(idx)")
//        envDataObjectModel.reversalGain.append(envDataObjectModel.testTestGain[idx-1])
//        envDataObjectModel.reversalFrequency.append(envDataObjectModel.samples[envDataObjectModel.index])
//        envDataObjectModel.reversalHeard.append(envDataObjectModel.heardArray[idx-1])
//        envDataObjectModel.reveralArray.append([envDataObjectModel.reversalArrayIndex, envDataObjectModel.reversalGain, envDataObjectModel.reversalFrequency, envDataObjectModel.reversalHeard, ("Break")])
//        print("testCount: \(envDataObjectModel.testCount)")
//        print("headrArray: \(envDataObjectModel.heardArray)")
//        print("reversalGain: \(envDataObjectModel.reversalGain)")
//        print("reversalFrequency: \(envDataObjectModel.reversalFrequency)")
//        print("reversalHeard: \(envDataObjectModel.reversalHeard)")
//    }
//
//    func reversalDirection() async {
//        if envDataObjectModel.reversalHeard.last == 1 {
//            envDataObjectModel.reversalDirection = -1.0
//            envDataObjectModel.reversalDirectionArray.append(envDataObjectModel.reversalDirection)
//        } else if envDataObjectModel.reversalHeard.last == 0 {
//            envDataObjectModel.reversalDirection = 1.0
//            envDataObjectModel.reversalDirectionArray.append(envDataObjectModel.reversalDirection)
//        } else {
//            print("Error in Reversal Direction reversalHeardArray Count")
//        }
//    }
//
//    func reversalOfOne() async {
//        let rO1Direction = 0.01 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO1Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO1Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r01Gain = envDataObjectModel.testGain + rO1Direction
//            envDataObjectModel.testGain = roundf(r01Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfOne: \(envDataObjectModel.testGain)")
//        print("Check rO1: \(envDataObjectModel.testGain + rO1Direction)")
//    }
//
//    func reversalOfTwo() async {
//        let rO2Direction = 0.02 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO2Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO2Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r02Gain = envDataObjectModel.testGain + rO2Direction
//            envDataObjectModel.testGain = roundf(r02Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfTwo: \(envDataObjectModel.testGain)")
//        print("Check rO2: \(envDataObjectModel.testGain + rO2Direction)")
//    }
//
//    func reversalOfThree() async {
//        let rO3Direction = 0.03 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO3Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO3Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r03Gain = envDataObjectModel.testGain + rO3Direction
//            envDataObjectModel.testGain = roundf(r03Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfThree: \(envDataObjectModel.testGain)")
//        print("Check rO3: \(envDataObjectModel.testGain + rO3Direction)")
//    }
//
//    func reversalOfFour() async {
//        let rO4Direction = 0.04 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO4Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO4Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r04Gain = envDataObjectModel.testGain + rO4Direction
//            envDataObjectModel.testGain = roundf(r04Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfThree: \(envDataObjectModel.testGain)")
//        print("Check rO4: \(envDataObjectModel.testGain + rO4Direction)")
//    }
//
//    func reversalOfFive() async {
//        let rO5Direction = 0.05 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO5Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO5Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r05Gain = envDataObjectModel.testGain + rO5Direction
//            envDataObjectModel.testGain = roundf(r05Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfFive: \(envDataObjectModel.testGain)")
//        print("Check rO5: \(envDataObjectModel.testGain + rO5Direction)")
//    }
//
//    func reversalOfTen() async {
//        let rO10Direction = 0.10 * envDataObjectModel.reversalDirection
//        if envDataObjectModel.testGain + rO10Direction <= 0.0 {
//            envDataObjectModel.testGain = 0.00001
//            print("!!!Fatal Zero Gain Catch")
//        } else if envDataObjectModel.testGain + rO10Direction >= 1.0 {
//            envDataObjectModel.testGain = 1.0
//            print("!!!Fatal 1.0 Gain Catch")
//        } else {
//            let r010Gain = envDataObjectModel.testGain + rO10Direction
//            envDataObjectModel.testGain = roundf(r010Gain * 100000) / 100000
//        }
//        print("New Gain reversalOfTen: \(envDataObjectModel.testGain)")
//        print("Check rO10: \(envDataObjectModel.testGain + rO10Direction)")
//    }
//
//    func reversalAction() async {
//        if envDataObjectModel.reversalHeard.last == 1 {
//            await reversalOfFive()
//        } else if envDataObjectModel.reversalHeard.last == 0 {
//            await reversalOfTwo()
//        } else {
//            print("Error in Reversal Action")
//        }
//    }
//
//    func reversalComplexAction() async {
//        let idx = envDataObjectModel.heardArray.count
//        let idxZero = idx - idx
//        let idxFirst = idx - idx + 1
//
//        print("idx: \(idx) idxZero: \(idxZero) idxFirst: \(idxFirst)")
//        if envDataObjectModel.reversalHeard.count >= 2 {
//            if startTooHigh == 0 && envDataObjectModel.reversalHeard[idxZero] == 1 && envDataObjectModel.reversalHeard[idxFirst] == 1 {
//                startTooHigh = 1
//                await reversalOfTen()
//                print("StartTooHigh: \(startTooHigh)")
//                print("First 2 Presentations = Two Positive Series Reversals Registered, startTooHigh now = 1; Reversal of Ten")
//            }
//            else if envDataObjectModel.reversalHeard.count >= 3 && envDataObjectModel.reversalHeard[idx-2] == 1 && envDataObjectModel.reversalHeard[idx-1] == 1 {
//                // End Test Cycle
//                print("Two Positive Series Reversals Registered, End Test Cycle & Log Final Cycle Results")
//            }
//            else if envDataObjectModel.reversalHeard.count >= 3 && envDataObjectModel.reversalHeard[idx-2] == 0 && envDataObjectModel.reversalHeard[idx-1] == 0 {
//                await reversalOfFour()
//                print("Two Negative Series Reversal Registered, Reversal of Five")
//            }
//            else {
//                await reversalAction()
//                print("Complex Action Triggers Not Met, continue standard Reversal Action")
//            }
//        } else if envDataObjectModel.reversalHeard.count <= 1 {
//            await reversalAction()
//            print("ReversalHeard Count <2, standard Reversal Action")
//        } else {
//            print("Fatal Error in Reversal Complex Action")
//        }
//    }
//
//
//    func getFirst1() throws -> Int? {
//        if envDataObjectModel.reversalHeard.firstIndex(of: 1) != nil {
//            first = envDataObjectModel.reversalHeard.firstIndex(of: 1)
//            return first
//        } else {
//            throw LastErrors.lastError
//        }
//    }
//
//
//    func getSecond1() throws -> Int? {
//        if envDataObjectModel.reversalHeard.lastIndex(of: 1) != nil {
//            second = envDataObjectModel.reversalHeard.lastIndex(of: 1)
//            return second
//        } else {
//            throw LastErrors.lastError
//        }
//    }
//
//
//    func sumReversalLogging() async {
//        let idx = envDataObjectModel.heardArray.count
//        let idxZero = idx - idx
//        let idxFirst = idx - idx + 1
//        let sumReversalHeard = envDataObjectModel.reversalHeard.reduce(0) { (sum, num)  -> Int in
//            sum + num
//        }
//        print(sumReversalHeard)
//        if sumReversalHeard == 2 {
//            print("!!!Reversal Limit of 2 + Responses Hit")
//            // Creat indicies where heard =1 and then reference those index elements in gain and freq and calc average gain
//            if startTooHigh == 1 && envDataObjectModel.reversalHeard[idxZero] == 1 && envDataObjectModel.reversalHeard[idxFirst] == 1{
//                startTooHigh = 2
//                print("StartTooHigh: \(startTooHigh)")
//                print("Pre reversalHeard: \(envDataObjectModel.reversalHeard)")
//                envDataObjectModel.reversalHeard.replaceSubrange(idxZero...idxZero, with: [1])
//                envDataObjectModel.reversalHeard.replaceSubrange(idxFirst...idxFirst, with: [-1])
//                print("Post reversalHeard: \(envDataObjectModel.reversalHeard)")
//                print("Starting Gain Too High, sumReversalLogic Skipped")
//            } else {
//
//                let first1 = try? getFirst1()
//                if let first1 = first1 {
//                    self.first = first1
//                    let firstG = envDataObjectModel.reversalGain[first1]
//                    self.firstGain = firstG
//                    print("FirstGain: \(firstGain)")
//                }
//
//                let second1 = try? getSecond1()
//                if let second1 = second1 {
//                    self.second = second1
//                    let secondG = envDataObjectModel.reversalGain[second1]
//                    self.secondGain = secondG
//                    print("SecondGain: \(secondGain)")
//                }
//
//                let sampleFrequency = envDataObjectModel.reversalFrequency
//                //Setting average gain or setting to lowest value if delta is >= +/1 0.05
//                if firstGain - secondGain == 0 {
//                    envDataObjectModel.averageGain = secondGain
//                    print("Average Gain = secondGain from if segment")
//                } else if firstGain - secondGain >= 0.05 {
//                    envDataObjectModel.averageGain = secondGain
//                    print("Average Gain = secondGain from 1st else if segment")
//                } else if firstGain - secondGain <= -0.05 {
//                    envDataObjectModel.averageGain = firstGain
//                    print("Average Gain = firstGain from 2nd else if segment")
//                } else if firstGain - secondGain < 0.05 && firstGain - secondGain > -0.05 {
//                    envDataObjectModel.averageGain = (firstGain + secondGain)/2
//                    print("Average Gain = Average Calc from 3rd else if segment")
//                } else {
//                    envDataObjectModel.averageGain = (firstGain + secondGain)/2
//                    print("Average Gain = Average Calc from final else segment")
//                }
//                print("First Gain: \(firstGain)")
//                print("Second Gain: \(secondGain)")
//                print("Average Gain: \(envDataObjectModel.averageGain)")
//                envDataObjectModel.reversalResultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.reversalResultsGains.append(firstGain)
//                envDataObjectModel.reversalFirstGain.append(firstGain)
//                envDataObjectModel.reversalResultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.reversalResultsGains.append(secondGain)
//                envDataObjectModel.reversalSecondGain.append(secondGain)
//                envDataObjectModel.reversalResultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.reversalResultsGains.append(envDataObjectModel.averageGain)
//                envDataObjectModel.reversalAverageGain.append(envDataObjectModel.averageGain)
//                // Logging result values to env class object for retention
//                envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.resultsGains.append(firstGain)
//                envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.resultsGains.append(secondGain)
//                envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//                envDataObjectModel.resultsGains.append(envDataObjectModel.averageGain)
//                print("reversalResultsFrequency: \(envDataObjectModel.reversalResultsFrequency)")
//                print("reversalResultsGains: \(envDataObjectModel.reversalResultsGains)")
//                print("envDataObjectModel.resultsFrequency: \(envDataObjectModel.resultsFrequency)")
//                print("envDataObjectModel.resultsGains: \(envDataObjectModel.resultsGains)")
//                localReversalEnd = 1
//                localMarkNewTestCycle = 1
//            }
//        }
//    }
//
//    func printReversalData() async {
//        print("--------Reversal Values Logged-------------")
//        print("Test Pan: \(envDataObjectModel.testPan)")
//        print("New TestGain: \(envDataObjectModel.testGain)")
//        print("testCount: \(envDataObjectModel.testCount)")
//        print("reversalGain: \(envDataObjectModel.reversalGain)")
//        print("reversalFrequency: \(envDataObjectModel.reversalFrequency)")
//        print("reversalHeard: \(envDataObjectModel.reversalHeard)")
//        print("FirstGain: \(firstGain)")
//        print("SecondGain: \(secondGain)")
//        print("AverageGain: \(envDataObjectModel.averageGain)")
//        print("------------------------------------------")
//    }
//
//
//    func restartPresentation() async {
//        localPlaying = 1
//    }
//
//    func newTestCycle() async {
//        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
//            startTooHigh = 0
//            localMarkNewTestCycle = 0
//            localReversalEnd = 0
//            //!!!!!Need to fix / stop this index from climbing in next cycle without the cycle being completed!!
//            envDataObjectModel.index = envDataObjectModel.index + 1
//
//
//            envDataObjectModel.testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
//            if envDataObjectModel.samples[envDataObjectModel.index] == envDataObjectModel.samples[envDataObjectModel.eptaSamplesCount-1] {
//                localPanSelection = 0
//            } else {
//                self.localPanSelection = localPanSelection
//            }
//
//            //!!! Need to nul all detail recorded arrays to reset them to nil/empty as with the start
//            await wipeArrays()
//
//
//
//            // Reprint cleared detail data arrays for confirmation
//            await printData()
//        }
//    }
//
//    func concatenateFinalArrays() async {
//        if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
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
//
//            envDataObjectModel.finalStoredIndex.append(contentsOf: ift)  //envDataObjectModel.finalStoredIndex
//            envDataObjectModel.finalStoredTestStartSeconds.append(contentsOf: tss)  // envDataObjectModel.finalStoredTestStartSeconds
//            envDataObjectModel.finalStoredTestEndSeconds.append(contentsOf: tes) // envDataObjectModel.finalStoredTestEndSeconds
//            envDataObjectModel.finalStoredUserRespCMSeconds.append(contentsOf: urcms)   // envDataObjectModel.finalStoredUserRespCMSeconds
//            envDataObjectModel.finalStoredTestPan.append(contentsOf: tp)    //envDataObjectModel.finalStoredTestPan
//            envDataObjectModel.finalStoredTestTestGain.append(contentsOf: ttg)  //envDataObjectModel.finalStoredTestTestGain
//            envDataObjectModel.finalStoredFrequency.append(contentsOf: freq)    // envDataObjectModel.finalStoredFrequency
//            envDataObjectModel.finalStoredTestCount.append(contentsOf: tc)  // envDataObjectModel.finalStoredTestCount
//            envDataObjectModel.finalStoredHeardArray.append(contentsOf: ha) //envDataObjectModel.finalStoredHeardArray
//            envDataObjectModel.finalStoredReversalDirectionArray.append(contentsOf: rda)    //envDataObjectModel.finalStoredReversalDirectionArray
//            envDataObjectModel.finalStoredReversalGain.append(contentsOf: rg)   // envDataObjectModel.finalStoredReversalGain
//            envDataObjectModel.finalStoredReversalFrequency.append(contentsOf: rFreq)   //envDataObjectModel.finalStoredReversalFrequency
//            envDataObjectModel.finalStoredReversalHeard.append(contentsOf: rh)  //envDataObjectModel.finalStoredReversalHeard
//            envDataObjectModel.finalStoredFirstGain.append(contentsOf: rfg) //envDataObjectModel.finalStoredFirstGain
//            envDataObjectModel.finalStoredSecondGain.append(contentsOf: rsg)    //envDataObjectModel.finalStoredSecondGain
//            envDataObjectModel.finalStoredAverageGain.append(contentsOf: rag)   //envDataObjectModel.finalStoredAverageGain
//            envDataObjectModel.finalStoredResultsFrequency.append(contentsOf: resFreq)  //envDataObjectModel.finalStoredResultsFrequency
//            envDataObjectModel.finalStoredResultsGains.append(contentsOf: resGs)    //envDataObjectModel.finalStoredResultsGains
//
//
//
////            envDataObjectModel.finalStoredIndex = envDataObjectModel.storedIndex + envDataObjectModel.indexForTest
////            envDataObjectModel.finalStoredTestStartSeconds = envDataObjectModel.storedTestStartSeconds + envDataObjectModel.testStartSeconds
////            envDataObjectModel.finalStoredTestEndSeconds = envDataObjectModel.storedTestEndSeconds + envDataObjectModel.testEndSeconds
////            envDataObjectModel.finalStoredUserRespCMSeconds = envDataObjectModel.storedUserRespCMSeconds + envDataObjectModel.userRespCMSeconds
////            envDataObjectModel.finalStoredTestPan = envDataObjectModel.storedTestPan + envDataObjectModel.testPan
////            envDataObjectModel.finalStoredTestTestGain = envDataObjectModel.storedTestTestGain + envDataObjectModel.testTestGain
////            envDataObjectModel.finalStoredFrequency = envDataObjectModel.storedFrequency + envDataObjectModel.frequency
////            envDataObjectModel.finalStoredTestCount = envDataObjectModel.storedTestCount + envDataObjectModel.testCount
////            envDataObjectModel.finalStoredHeardArray = envDataObjectModel.storedHeardArray + envDataObjectModel.heardArray
////            envDataObjectModel.finalStoredReversalDirectionArray = envDataObjectModel.storedReversalDirection + envDataObjectModel.reversalDirectionArray
////            envDataObjectModel.finalStoredReversalGain = envDataObjectModel.storedReversalGain + envDataObjectModel.reversalGain
////            envDataObjectModel.finalStoredReversalFrequency = envDataObjectModel.storedReversalFrequency + envDataObjectModel.reversalFrequency
////            envDataObjectModel.finalStoredReversalHeard = envDataObjectModel.storedReversalHeard + envDataObjectModel.reversalHeard
////            envDataObjectModel.finalStoredFirstGain = envDataObjectModel.storedFirstGain + envDataObjectModel.reversalFirstGain
////            envDataObjectModel.finalStoredSecondGain = envDataObjectModel.storedSecondGain + envDataObjectModel.reversalSecondGain
////            envDataObjectModel.finalStoredAverageGain = envDataObjectModel.storedAverageGain + envDataObjectModel.reversalAverageGain
////            envDataObjectModel.finalStoredResultsFrequency = envDataObjectModel.storedResultsFrequency + envDataObjectModel.resultsFrequency
////            envDataObjectModel.finalStoredResultsGains = envDataObjectModel.storedResultsGains + envDataObjectModel.resultsGains
//
//            envDataObjectModel.finalHearingResults.append(envDataObjectModel.reversalResultsFrequency)
//            envDataObjectModel.finalHearingResults.append(envDataObjectModel.reversalResultsGains)
//        }
//    }
//
//        func printFinalStoredArrays() async {
//            if localMarkNewTestCycle == 1 && localReversalEnd == 1 {
////                await envDataObjectModel.getData()
////                await envDataObjectModel.saveToJSON()
////                await envDataObjectModel.writeDetailedResultsToCSV()
////                await envDataObjectModel.writeSummarydResultsToCSV()
////                await envDataObjectModel.uploadSummaryResultsTest()
//
//                print("---------End-Test-Cycle-Print-Stored-Array-Results---------")
//                print("finalStoredIndex: \(envDataObjectModel.finalStoredIndex)")
//                print("finalStoredTestStartSeconds: \(envDataObjectModel.finalStoredTestStartSeconds)")
//                print("finalStoredTestEndSeconds: \(envDataObjectModel.finalStoredTestEndSeconds)")
//                print("finalStoredUserRespCMSeconds: \(envDataObjectModel.finalStoredUserRespCMSeconds)")
//                print("finalStoredTestPan: \(envDataObjectModel.finalStoredTestPan)")
//                print("finalStoredTestTestGain: \(envDataObjectModel.finalStoredTestTestGain)")
//                print("finalStoredFrequency: \(envDataObjectModel.finalStoredFrequency)")
//                print("finalStoredTestCount: \(envDataObjectModel.finalStoredTestCount)")
//                print("finalStoredHeardArray: \(envDataObjectModel.finalStoredHeardArray)")
//                print("finalStoredReversalDirectionArray: \(envDataObjectModel.finalStoredReversalDirectionArray)")
//                print("finalStoredReversalGain: \(envDataObjectModel.finalStoredReversalGain)")
//                print("finalStoredReversalFrequency: \(envDataObjectModel.finalStoredReversalFrequency)")
//                print("finalStoredReversalHeard: \(envDataObjectModel.finalStoredReversalHeard)")
//                print("finalStoredFirstGain: \(envDataObjectModel.finalStoredFirstGain)")
//                print("finalStoredSecondGain: \(envDataObjectModel.finalStoredSecondGain)")
//                print("finalStoredAverageGain: \(envDataObjectModel.finalStoredAverageGain)")
//                print("finalStoredResultsFrequency: \(envDataObjectModel.finalStoredResultsFrequency)")
//                print("finalStoredResultsGains: \(envDataObjectModel.finalStoredResultsGains)")
//                print("finalHearingResults: \(envDataObjectModel.finalHearingResults)")
//                print("-------End-Test-Cycle-And-Printed-Stored-Array-Results-------")
//            }
//        }
//
//
//
//    func wipeArrays() async {
//        envDataObjectModel.heardArray.removeAll()
//        envDataObjectModel.testCount.removeAll()
//        envDataObjectModel.testStartSeconds.removeAll()
//        envDataObjectModel.testEndSeconds.removeAll()
//        envDataObjectModel.userRespCMSeconds.removeAll()
//        envDataObjectModel.reversalHeard.removeAll()
//        envDataObjectModel.reversalArrayIndex = Int()
//        envDataObjectModel.averageGain = Float()
//        envDataObjectModel.reversalDirection = Float()
//        envDataObjectModel.reversalDualTrue = Int()
//    }
//
//    func uploadJSON() async {
//    //
//    }
//
//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//
//    func uploadCSV() async {
////        let storage = Storage.storage()
//        let storageRef = Storage.storage().reference()
//        let setupCSVName = ["SetupResultsCSV.csv"]
//        let fileManager = FileManager.default
//        let csvPath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: setupCSVName)
//        if fileManager.fileExists(atPath: csvPath[0]) {
//            let filePath = URL(fileURLWithPath: csvPath[0])
//            let localFile = filePath
//            let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
//            let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
//                if error == nil && metadata == nil {
//                    //TSave a reference to firestore database
//                }
//
//                return
//            }
//            print(uploadTask)
////                guard let metadata = metadata else {
////                    print("!!!Error in uploadCSV File Located")
////                    return
////                }
//        } else {
//            print("No File")
//        }
//    }
//
//}

