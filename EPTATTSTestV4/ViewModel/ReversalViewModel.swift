//
//  ReversalViewModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/12/22.
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

// Assume that output volume is set to 10/16ths, indicating dbFTS range of 100dB.
// Full dBFS range is -160 to 0 with 16 steps using iphone button, indicating each
// button step is equal to 10dBFS
//
// If output volume is set so range is from -160 to -60 = 100 dBFS, then with
// a gain setting range of 0 to 1, each 0.1 gain change = 10dBFS or 10% of output volume range

// So, a change in gain of 0.01 = 1 dBFS
// and, a change in gain of 0.02 = 2 dBFS
// and, a change in gain of 0.03 = 3 dBFS
// and, a change in gain of 0.05 = 5 dBFS
// and, a change in gain of 0.10 = 10 dBFS


// NEED TO ADDRESS PAN CHANGE at SOME POINT
// Need to reset these struct arrays to nil at sample change


//struct ReversalViewModel: View {
//
//    @State var envDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
//
////    init(){
////        envDataObjectModel = EnvDataObjectModel()
////        self.envDataObjectModel.testCount = envDataObjectModel.testCount
////    }
//
//
//    @State var playing = Int()    // Playing = 1. Stopped = -1
//    @State var reversal = Int()
//    @State var localReversalTestCount = [Int]()
//    @State var localReversalArrayIndex = Int()
//    @State var localRveralGain = [Float]()
//    @State var localReversalFrequency = [String]()
//    @State var localReversalHeard = [Int]()
//    @State var localReveralArray = [Any]()
//    @State var reversalDirection = Float()
//    @State var averageGain = Float()
//    @State var reversalDualTrue = Int()
//    @State var reversalEnd = Int()
//    @State var reversalResultsGains = [Float]()
//    @State var reversalResultsFrequency = [String]()
//    @State var markNewTestCycle = Int()
//
//    var body: some View {
//
//        VStack {
//            Text(String(envDataObjectModel.testGain))
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.white)
//
//            Text(String(reversalDirection))
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(.white)
//        }
//        .environmentObject(envDataObjectModel)
//    }
        
    
//    func createReversalArrays() async {
//        localReversalArrayIndex = envDataObjectModel.testCount.last!
//        localRveralGain.append(envDataObjectModel.testTestGain[localReversalArrayIndex])
//        localReversalFrequency.append(envDataObjectModel.frequency[localReversalArrayIndex])
//        await localReversalHeard.append(envDataObjectModel.heardArray[localReversalArrayIndex])
//        localReveralArray.append([localReversalArrayIndex, localRveralGain, localReversalFrequency, localReversalHeard, ("Break")])
//        print(localReveralArray)
//    }
//    
//    func reversalDirection() async {
//        if localReversalHeard.last == 1 {
//            reversalDirection = -1.0
//        } else if localReversalHeard.last == 0 {
//            reversalDirection = 1.0
//        } else {
//            print("Error in Reversal Direction reversalHeardArray Count")
//        }
//    }
//    
//    func reversalOfOne() async {
//        let rO1Direction = 0.01 * reversalDirection
//        envDataObjectModel.testGain = envDataObjectModel.testGain + rO1Direction
//        print("New Gain reversalOfOne: \(envDataObjectModel.testGain)")
//        print("Check rO1: \(envDataObjectModel.testGain + rO1Direction)")
//    }
//    
//    func reversalOfTwo() async {
//        let rO2Direction = 0.02 * reversalDirection
//        envDataObjectModel.testGain = envDataObjectModel.testGain + rO2Direction
//        print("New Gain reversalOfTwo: \(envDataObjectModel.testGain)")
//        print("Check rO2: \(envDataObjectModel.testGain + rO2Direction)")
//    }
//    
//    func reversalOfThree() async {
//        let rO3Direction = 0.03 * reversalDirection
//        envDataObjectModel.testGain = envDataObjectModel.testGain + rO3Direction
//        print("New Gain reversalOfThree: \(envDataObjectModel.testGain)")
//        print("Check rO3: \(envDataObjectModel.testGain + rO3Direction)")
//    }
//    
//    func reversalOfFive() async {
//        let rO5Direction = 0.05 * reversalDirection
//        envDataObjectModel.testGain = envDataObjectModel.testGain + rO5Direction
//        print("New Gain reversalOfFive: \(envDataObjectModel.testGain)")
//        print("Check rO5: \(envDataObjectModel.testGain + rO5Direction)")
//    }
//    
//    func reversalOfTen() async {
//        let rO10Direction = 0.10 * reversalDirection
//        envDataObjectModel.testGain = envDataObjectModel.testGain + rO10Direction
//        print("New Gain reversalOfTen: \(envDataObjectModel.testGain)")
//        print("Check rO10: \(envDataObjectModel.testGain + rO10Direction)")
//    }
//    
//    func reversalAction() async {
//        if localReversalHeard.last == 1 {
//            await reversalOfFive()
//        } else if localReversalHeard.last == 0 {
//            await reversalOfTwo()
//        } else {
//            print("Error in Reversal Action")
//        }
//    }
//    
//    func reversalComplexAction() async {
//        if localReversalHeard.count >= 3 {
//            if localReversalHeard.last == 1 && localReversalHeard.index(before: localReversalHeard.last!) == 1 {
//                await reversalOfTen()
//            } else if localReversalHeard.last == 0 && localReversalHeard.index(before: localReversalHeard.last!) == 0 && localReversalHeard.index(before: localReversalHeard.last!-1) == 0 {
//                await reversalOfFive()
//            } else {
//                await reversalAction()
//                print("Complex Reversal hit Else ReversalOfOne")
//            }
//        } else {
//            print("localReversalHeard Array Length is < 3")
//        }
//    }
//    
//    func sumReversalLogginve() async {
//        let sumLocalReversalHeard = localReversalHeard.reduce(0) { (sum, num)  -> Int in
//            sum + num
//        }
//        print(sumLocalReversalHeard)
//        if sumLocalReversalHeard >= 2 {
//            // Creat indicies where heard =1 and then reference those index elements in gain and freq and calc average gain
//            let first1 = localReversalHeard.firstIndex(of: 1)
//            let second1 = localReversalHeard.lastIndex(of: 1)
//            let firstGain = localRveralGain[first1! + 1]
//            let secondGain = localRveralGain[second1! + 1]
//            let sampleFrequency = localReversalFrequency
//            //Setting average gain or setting to lowest value if delta is >= +/1 0.05
//            if firstGain - secondGain == 0 {
//                averageGain = secondGain
//            } else if firstGain - secondGain >= 0.05 {
//                averageGain = secondGain
//            } else if firstGain - secondGain <= -0.05 {
//                averageGain = firstGain
//            } else if firstGain - secondGain < 0.05 && firstGain - secondGain > -0.05 {
//                averageGain = (firstGain + secondGain)/2
//            } else {
//                averageGain = (firstGain + secondGain)/2
//            }
//            print("Average Gain: \(averageGain)")
//            reversalResultsFrequency.append(sampleFrequency.last!)
//            reversalResultsGains.append(firstGain)
//            reversalResultsFrequency.append(sampleFrequency.last!)
//            reversalResultsGains.append(secondGain)
//            reversalResultsFrequency.append(sampleFrequency.last!)
//            reversalResultsGains.append(averageGain)
//            // Logging result values to env class object for retention
//            envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//            envDataObjectModel.resultsGains.append(firstGain)
//            envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//            envDataObjectModel.resultsGains.append(secondGain)
//            envDataObjectModel.resultsFrequency.append(sampleFrequency.last!)
//            envDataObjectModel.resultsGains.append(averageGain)
//            print("reversalResultsFrequency: \(reversalResultsFrequency)")
//            print("reversalResultsGains: \(reversalResultsGains)")
//            print("envDataObjectModel.resultsFrequency: \(envDataObjectModel.resultsFrequency)")
//            print("envDataObjectModel.resultsGains: \(envDataObjectModel.resultsGains)")
//            reversalEnd = 1
//            markNewTestCycle = 1
//        }
//    }
//        
//    func restartPresentation() async {
//        playing = 1
//    }
//    
//    func newTestCycle() async {
//        if markNewTestCycle == 1 && reversalEnd == 1 {
//            envDataObjectModel.index = envDataObjectModel.index + 1
//            envDataObjectModel.testGain = 0.2       // Add code to reset starting test gain by linking to table of expected HL
//        }
//    }
    

}
