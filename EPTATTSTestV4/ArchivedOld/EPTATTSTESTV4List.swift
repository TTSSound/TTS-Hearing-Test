//
//  EPTATTSTESTV4List.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/8/22.
//
//import SwiftUI
//import AVFAudio
//import Combine
//import Foundation
//import AVFoundation
//import AVKit
//import CoreMedia
//import Darwin
//import Security
//import Combine


//_____________Items to Add_____________//
// Pop up disclosure with attestation
// User entry pop up--name, age, sex, email
// Screen for test type selection (Purchase option)
    // Headphone, Devices & system Selection--> Calibrated only
        // Make request for your device to be calibrated
// Pop up notification to turn on do not disturb or airplane mode and to set volume to max
    // Close all other applications when testing
        // This all helps with calibration
// Attestation that all of these have been done
// MPView Volume Slider to set it to 50% output volume
    // Then have volume slider hide
// Then screen to explain test and user instructions
    // Explanation about pausing the test
    // Expl;anation about taking EPTA and EHA in two sittings
// Then practice sound and response
// Then start the test
// End of Test
// Display results in graph and notice that more details will be emailed
// Reminder to turn down volume, turn off airplane mode and turn off do not disturb
// Exit App
//
//____________________________________//



//struct EPTATTSTestV4List: View {
//    enum SampleErrors: Error {
//        case notFound
//        case unexpected(code: Int)
//    }
//    
//    @StateObject var envDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
////    @EnvironmentObject var envDataObjectModel: EnvDataObjectModel
//    var audioSessionModel = AudioSessionModel()
//    @State var testPlayer: AVAudioPlayer?
//    @State var heardArrayValue = [Int]()
//    
//    let heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInteractive)
//    let playbackThread = DispatchQueue(label: "BackGroundPlayBack", qos: .utility)
//    let audioThread = DispatchQueue(label: "AudioThread", qos: .userInteractive)
//    
//    var body: some View {
//        ZStack{
//            RadialGradient(
//                gradient: Gradient(colors: [Color.blue, Color.black]),
//                center: .center,
//                startRadius: -100,
//                endRadius: 300).ignoresSafeArea()
//    
//        VStack{
// 
//            
//            Text("RePrint Data")
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.white)
//                .onTapGesture{
//                    printData()
//                }
//        Spacer()
//
//            Text("Click to setaudioSession")
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.white)
//                .onTapGesture {
//                    audioSessionModel.setAudioSession()
//                    print("Text Tapped")
//                }
//        Spacer()
//            
//            
//            Text("Click to Stat Test Tone")
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.white)
//                .onTapGesture {
//                    initializeTimeClocks()
//                    intraTimeStamp()
//                    intraEventLogging()
//                    loadAndTestPresentation(sample: envDataObjectModel.samples[0], gain: envDataObjectModel.testGain, pan: envDataObjectModel.pan)
//                    playbackThread.async {
//                        while testPlayer!.isPlaying == true {
//                            if envDataObjectModel.heardArray.count > 1 && envDataObjectModel.heardArray.index(after: envDataObjectModel.indexForTest.count-1) == 1 {
//                            testPlayer!.stop()
//                            print("Stopped in While")
//                            }
//                        }
//                        testPlayer!.stop()
//                        print("Naturally Stopped")
//                    }
//                    while testPlayer!.isPlaying == true{
//                    }
//                    postEventLogging()
//                    nonHeardEventLogging()
//                    printData()
//                    print(envDataObjectModel.heardArray)
//                    print("Start Button Clicked")
//                }
//            Spacer()
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
//                    audioThread.async {
//                        stop()
//                    }
//                    envDataObjectModel.heardArray.append(1)
//                }
//                .onChange(of: envDataObjectModel.heardArray, perform: { value in
//                    let heardArrayValue = value
//                    print(heardArrayValue)
//                    print("Value's value")
//                    if heardArrayValue.last == nil {
//                        print("Value = nil")
//                    } else if heardArrayValue.last == 0 {
//                        print("value of 0 received as heard array change")
//                    }
//                    else if heardArrayValue.last == 1 {
//                        reduceHeardEventLogging()
//                        heardEventLogging()
//                        print(heardArrayValue)
//                        print("Value of 1 received for heard array change")
//                    } else {
//                        print("Critical Error in HeardArray Value Monitoring. Not nil, 0 or 1")
//                    }
//                })
//            Spacer()
//            }
//
//        Spacer()
//        }
//        
//        .onChange(of: envDataObjectModel.testCount, perform: { _ in
//            heardArrayNormalize()
//            arrayTesting()
//            printData()
//        })
//    }
//    
//    //MARK: -Methods
//    
//    func setHeardArray(){
//            envDataObjectModel.heardArray.append(0)
//    }
//    
//    
//    func printDataView () {
//        print(envDataObjectModel.heardArray)
//        print(envDataObjectModel.testStartSystem)
//        print(envDataObjectModel.testStartSeconds)
//        print(envDataObjectModel.testEndSystem)
//        print(envDataObjectModel.testEndSeconds)
//        print(envDataObjectModel.userRespCMSystem)
//        print(envDataObjectModel.userRespCMSeconds)
//        print(envDataObjectModel.testPan)
//        print(envDataObjectModel.testTestGain)
//        print(envDataObjectModel.frequency)
//        print(envDataObjectModel.heardArray)
//        print(envDataObjectModel.userRespCMSystem)
//        print(envDataObjectModel.userRespCMSeconds)
//        print(envDataObjectModel.testCount)
//    }
//    
//    func setTestGain(_ testGain: Float) {
//        testPlayer!.setVolume(envDataObjectModel.testGain, fadeDuration: 0)
//    }
//
//    func stop() {
//        testPlayer!.stop()
//    }
//    
//    func preEventLogging() {
//        // Initialize Time Clock
//        CMClockGetTime(envDataObjectModel.masterClock)
//        CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        // Initial Time Stamp
//        let iTS1 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        let iTS2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        envDataObjectModel.testStartSystem.append(iTS1) //System Unit Time
//        envDataObjectModel.testStartSeconds.append(iTS2)   //Seconds Time
//        // Pre Event Logging
//        envDataObjectModel.indexForTest.append(envDataObjectModel.index)
//        envDataObjectModel.testPan.append(envDataObjectModel.pan)         // 0 = Left , 1 = Middle, 2 = Right
//        envDataObjectModel.testTestGain.append(envDataObjectModel.testGain)
//        envDataObjectModel.frequency.append(envDataObjectModel.samples[0])
//    }
//    
//    func initializeTimeClocks() {
//        CMClockGetTime(envDataObjectModel.masterClock)
//        CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//    }
//    
//    func intraEventLogging () {
//        envDataObjectModel.indexForTest.append(envDataObjectModel.index)
//        envDataObjectModel.testPan.append(envDataObjectModel.pan)         // 0 = Left , 1 = Middle, 2 = Right
//        envDataObjectModel.testTestGain.append(envDataObjectModel.testGain)
//        envDataObjectModel.frequency.append(envDataObjectModel.samples[0])
//    }
//    
//// Time Event Logging to Duration Before Presentation
//    // Start TimeBase Clock as Well
//    func intraTimeStamp () {
//        CMClockGetTime(envDataObjectModel.masterClock)
//        let iTS1 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        let iTS2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        envDataObjectModel.testStartSystem.append(iTS1) //System Unit Time
//        envDataObjectModel.testStartSeconds.append(iTS2)   //Seconds Time
//    }
//    
//// Time Event Logging to test End After Presentation
//    func postEventLogging() {
//        CMClockGetTime(envDataObjectModel.masterClock)
//        let pEL1 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        let peL2 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        envDataObjectModel.testEndSystem.append(pEL1)
//        envDataObjectModel.testEndSeconds.append(peL2)
//    }
//    
//    func heardNotHeardEventLogging() {
//        if envDataObjectModel.heardArray.last == nil || envDataObjectModel.heardArray.last == 0 {
//            envDataObjectModel.userRespCMSystem.append(1000000000001)
//            envDataObjectModel.userRespCMSeconds.append(9.9)
//            print("heardArray Not Updated, No Click")
//        } else {
//            let Y: UInt64 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//            print(Y)
//            let y: Float64 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//            print(y)
//            envDataObjectModel.userRespCMSystem.replaceSubrange(envDataObjectModel.heardArray.count-1...envDataObjectModel.heardArray.count-1, with: [Y])
//            envDataObjectModel.userRespCMSeconds.replaceSubrange(envDataObjectModel.heardArray.count-1...envDataObjectModel.heardArray.count-1, with: [y])
//            print("hearArray update caught")
//        }
//    }
//    
//    func heardEventLogging(){
//        let Y: UInt64 = CMClockConvertHostTimeToSystemUnits(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        print(Y)
//        let y: Float64 = CMTimeGetSeconds(CMClockGetTime(envDataObjectModel.masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        print(y)
//        envDataObjectModel.userRespCMSystem.replaceSubrange(envDataObjectModel.heardArray.count-1...envDataObjectModel.heardArray.count-1, with: [Y])
//        envDataObjectModel.userRespCMSeconds.replaceSubrange(envDataObjectModel.heardArray.count-1...envDataObjectModel.heardArray.count-1, with: [y])
//        print("hearArray update caught")
//    }
//    
//    
//    func reduceHeardEventLogging(){
//        envDataObjectModel.userRespCMSystem.remove(at: envDataObjectModel.userRespCMSystem.count-1)
//        envDataObjectModel.userRespCMSeconds.remove(at: envDataObjectModel.userRespCMSeconds.count-1)
//    }
//
//    func nonHeardEventLogging(){
//        let reducedCount = envDataObjectModel.testCount.count
//        let count = reducedCount + 1
//        envDataObjectModel.testCount.append(count)
//        envDataObjectModel.userRespCMSystem.append(1000000000001)
//        envDataObjectModel.userRespCMSeconds.append(9.9)
//        print("heardArray Update Not registered")
//    }
//
//    func heardArrayNormalize() {
//        let indexForTestCount = envDataObjectModel.indexForTest.count
//        let heardArrayCount = envDataObjectModel.heardArray.count
//        if envDataObjectModel.heardArray.last == nil && envDataObjectModel.heardArray.count <= 1 {
//            envDataObjectModel.heardArray.append(0)
//            print("Starting Test, First Append(0) to Heard Array if No Response")
//        } else if indexForTestCount - heardArrayCount == 1 && envDataObjectModel.heardArray.index(after: envDataObjectModel.indexForTest.count-1) != 1 {
//            envDataObjectModel.heardArray.append(0)
//            print("Append(0) to Heard Array for Assumed No Response")
//        } else {
//            print("Critial Error in Heard Array Count and or Values")
//        }
//    }
//
//    func loadAndTestPresentation(sample: String, gain: Float, pan: Int ) {
//        do{
//            let urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
//            guard let urlSample = urlSample else {
//                return print(SampleErrors.notFound)
//            }
//            testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlSample))
//            guard let testPlayer = testPlayer else {
//                return
//            }
//            testPlayer.prepareToPlay()
//    // Set Gain for Playback
//            setTestGain(envDataObjectModel.testGain)
//    // Start Playback
//            testPlayer.play()
//        } catch {
//            print("Error in playerSessionSetUp Function Execution")
//        }
//    }
//
//    func arrayTesting() {
//        let arraySet1 = Int(envDataObjectModel.testStartSystem.count) - Int(envDataObjectModel.testStartSeconds.count) + Int(envDataObjectModel.testEndSystem.count) - Int(envDataObjectModel.testEndSeconds.count)
//        let arraySet2 = Int(envDataObjectModel.userRespCMSeconds.count) - Int(envDataObjectModel.userRespCMSystem.count) + Int(envDataObjectModel.testPan.count) - Int(envDataObjectModel.testTestGain.count)
//        let arraySet3 = Int(envDataObjectModel.frequency.count) - Int(envDataObjectModel.frequency.count)
//        if arraySet1 + arraySet2 + arraySet3 == 0 {
//            print("All Event Logs Match")
//        } else {
//            print("Error Event Logs Length Error")
//        }
//    }
//
//    func printData () {
//        print(envDataObjectModel.heardArray)
//        print(envDataObjectModel.testStartSystem)
//        print(envDataObjectModel.testStartSeconds)
//        print(envDataObjectModel.testEndSystem)
//        print(envDataObjectModel.testEndSeconds)
//        print(envDataObjectModel.userRespCMSystem)
//        print(envDataObjectModel.userRespCMSeconds)
//        print(envDataObjectModel.testPan)
//        print(envDataObjectModel.testTestGain)
//        print(envDataObjectModel.frequency)
//        print(envDataObjectModel.heardArray)
//        print(envDataObjectModel.userRespCMSystem)
//        print(envDataObjectModel.userRespCMSeconds)
//        print(envDataObjectModel.testCount)
//    }
//
//
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EPTATTSTestV4List()
//    }
//}
