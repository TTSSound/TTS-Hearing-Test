//
//  ClockModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//

//import Foundation
//import CoreMedia
//import AudioToolbox
//import QuartzCore
//
//class ClockModel: ObservableObject {
//    @Published var currentTimeMach: UInt64
//    @Published var currentTimeMedia: CFTimeInterval
//    @Published var currentTimeOS = OS_CLOCK_MACH_ABSOLUTE_TIME
//    @Published var masterClock = CMClockGetHostTimeClock()
//
//    
//    init(){
//        currentTimeMach =  mach_absolute_time()
//        currentTimeMedia = CACurrentMediaTime()
//        let masterClock = CMClockGetHostTimeClock()
//        CMClockGetTime(masterClock)
//        getCurrentTimeMach()
//        getCurrentTimeMedia()
//        getMasterClock()
//        ini
//    }
//    
//    func getCurrentTimeMach() -> UInt64 {
//        mach_absolute_time()
//    }
//    
//    func getCurrentTimeMedia() -> CFTimeInterval {
//        CACurrentMediaTime()
//    }
//    
//    func getMasterClock() -> CMTime {
//        CMClockGetTime(masterClock)
//    }
//    
//    func initializeTimeClocks() {
//        CMClockGetTime(masterClock)
//        CMClockConvertHostTimeToSystemUnits(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//        CMTimeGetSeconds(CMClockGetTime(masterClock).convertScale(1000, method: CMTimeRoundingMethod.roundTowardZero))
//    }
//    
//    func intraEventLogging () {
//            indexForTest.append(indexPlayer[index])
//            testPan.append(pan)         // 0 = Left , 1 = Middle, 2 = Right
//            testTestGain.append(testGain)
//            frequency.append(samples[0])
//    }
//}


