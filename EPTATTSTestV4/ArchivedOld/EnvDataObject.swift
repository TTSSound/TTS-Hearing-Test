//
//  EnvDataObject.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//

//import Foundation
//import CoreMedia
//import AudioToolbox
//import QuartzCore
//import SwiftUI
//
//
//struct EnvHeardKey: EnvironmentKey {
//    static let defaultValue: Int = 0
//}
//
//extension EnvironmentValues {
//    public var envHeard: Int {
//        get { self[EnvHeardKey.self] }
//        set { self[EnvHeardKey.self] = newValue}
//    }
//}
//
//struct EnvHeardAction {
//    var envHeardAction: () -> Void
//    
//    
//    func envHeardActionFunction() {
//        envHeardAction()
//    }
//    
//    init(envHeardAction: @escaping () -> Void = { }) {
//        self.envHeardAction = envHeardAction
//    }
//}
//
//struct EnvHeardActionKey: EnvironmentKey {
//  static var defaultValue: EnvHeardAction = EnvHeardAction()
//}
//
//extension EnvironmentValues {
//  var envHeardAction: EnvHeardAction {
//    get { self[EnvHeardActionKey.self] }
//    set { self[EnvHeardActionKey.self] = newValue }
//  }
//}


//class EnvDataObjectModel: ObservableObject {
//    @Published var heardArray: [Int] = [0]
//    @Published var samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
//    @Published var sampleType: String = ".wav"
//    @Published var pan: Int = 1        // 0 = Left , 1 = Middle, 2 = Right
//    @Published var testGain: Float = 0.2
//
//
//    @Published var testStartSystem = [UInt64]()
//    @Published var testStartSeconds = [Float64]()
//    @Published var testEndSystem = [UInt64]()
//    @Published var testEndSeconds = [Float64]()
//    @Published var userRespCMSystem = [UInt64]()
//    @Published var userRespCMSeconds = [Float64]()
//
//
//    //Clock Variables
//    @Published var currentTimeMach: UInt64
//    @Published var currentTimeMedia: CFTimeInterval
//    @Published var masterClock = CMClockGetHostTimeClock()
//
//    init(){
//        currentTimeMach =  mach_absolute_time()
//        currentTimeMedia = CACurrentMediaTime()
//        let masterClock = CMClockGetHostTimeClock()
//        CMClockGetTime(masterClock)
//    }
//
//}


//
//
//
//
//class EnvDataObject  {
//   //Changing Variables for Test Conditions
//    @Published var heardArray: [Int] = [0]
//    @Published var index: Int = 0
//    @Published var pan: Int = 1        // 0 = Left , 1 = Middle, 2 = Right
//    @Published var testGain: Float = 0.2
//    @Published var samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
//    @Published var sampleType: String = ".wav"
//    @Published var sampleRate: Double = 96000.00
//    @Published var buffer: Int = 1024
//    @Published var bits: Int = 24
//    @Published var sampleTimeCombined: Double = 3.5598958333333335
//    @Published var allEventLogMatch: Bool = false
//    
//    
//
//    
//    //Indexing Data Arrays
//    @Published var indexForTest = [Int]()
//    @Published var testPan = [Int]()         // 0 = Left , 1 = Middle, 2 = Right
//    @Published var testTestGain = [Float]()
//    @Published var frequency = [String]()
//    @Published var testStartSystem = [UInt64]()
//    @Published var testStartSeconds = [Float64]()
//    @Published var testEndSystem = [UInt64]()
//    @Published var testEndSeconds = [Float64]()
//    @Published var userTestEndSystem = [UInt64]()
//    @Published var userTestEndSeconds = [Float64]()
//    @Published var userRespCMSystem = [UInt64]()
//    @Published var userRespCMSeconds = [Float64]()
//    @Published var EventLogsMatching = [Bool]()
//    
//
//    
//    //Clock Variables
//    @Published var currentTimeMach: UInt64
//    @Published var currentTimeMedia: CFTimeInterval
////    @Published var masterClock = CMClockGetHostTimeClock()
//    
//    init(){
//        currentTimeMach =  mach_absolute_time()
//        currentTimeMedia = CACurrentMediaTime()
////        let masterClock = CMClockGetHostTimeClock()
////        CMClockGetTime(masterClock)
//    }
//
//    
////
////    func getCurrentTimeMach() -> UInt64 {
////        mach_absolute_time()
////    }
////
////    func getCurrentTimeMedia() -> CFTimeInterval {
////        CACurrentMediaTime()
////    }
////
////    func getMasterClock() -> CMTime {
////        CMClockGetTime(masterClock)
////    }
////
////    func initializeTimeClocks() {
////        CMClockGetTime(masterClock)
////        CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
////        CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
////    }
//}
