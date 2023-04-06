//
//  EnvDataObjectModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/8/22.
//
//
//import Foundation


//
//  EnvDataObjectModel.swift
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
//class EnvDataObjectModel: ObservableObject {
//    
//    @Published var index: Int = 0
//    @Published var heardArray: [Int] = [Int]()
//    @Published var samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
//    @Published var sampleType: String = ".wav"
//    @Published var pan: Int = 1        // 0 = Left , 1 = Middle, 2 = Right
//    @Published var testGain: Float = 0.2
//    @Published var testCount = [Int]()
//    
//    @Published var indexForTest = [Int]()
//    @Published var testPan = [Int]()
//    @Published var testTestGain = [Float]()
//    @Published var frequency = [String]()
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

