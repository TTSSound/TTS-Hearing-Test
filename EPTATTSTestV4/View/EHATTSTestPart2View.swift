//
//  EHATTSTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
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
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase
import FileProvider


struct ehaP2SaveFinalResults: Codable {  // This is a model
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
    var jsonPan: [Float]
    var jsonStoredIndex: [Int]
    var jsonStoredTestPan: [Float]
    var jsonStoredTestTestGain: [Float]
    var jsonStoredTestCount: [Int]
    var jsonStoredHeardArray: [Int]
    var jsonStoredReversalHeard: [Int]
    var jsonStoredFirstGain: [Float]
    var jsonStoredSecondGain: [Float]
    var jsonStoredAverageGain: [Float]
}

struct EHATTSTestPart2View<Link: View>: View {
    
    var ehaTesting: EHATesting?
    var relatedLinkEHATesting: (EHATesting) -> Link
//    @State var saveSystemSettingsInterimPreEHAP2: SaveSystemSettingsInterimPreEHAP2? = nil
    
    var body: some View {
        if let ehaTesting = ehaTesting {
            EHATTSTestPart2Content(ehaTesting: ehaTesting, relatedLinkEHATesting: relatedLinkEHATesting)
        } else {
            Text("Error Loading EHATTSTestPart2 View")
                .navigationTitle("")
        }
    }
}
    

struct EHATTSTestPart2Content<Link: View>: View {
    var ehaTesting: EHATesting
    var dataModel = DataModel.shared
    var relatedLinkEHATesting: (EHATesting) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    enum ehaP2SampleErrors: Error {
        case ehaP2notFound
        case ehaP2unexpected(code: Int)
    }
    
    enum ehaP2FirebaseErrors: Error {
        case ehaP2unknownFileURL
    }
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var gainReferenceModel: GainReferenceModel = GainReferenceModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var ehaP2localHeard = 0
    @State var ehaP2localPlaying = Int()    // Playing = 1. Stopped = -1
    @State var ehaP2localReversal = Int()
    @State var ehaP2localReversalEnd = Int()
    @State var ehaP2localMarkNewTestCycle = Int()
    @State var ehaP2testPlayer: AVAudioPlayer?
    
    @State var ehaP2localTestCount = 0
    @State var ehaP2localStartingNonHeardArraySet: Bool = false
    @State var ehaP2localReversalHeardLast = Int()
    @State var ehaP2localSeriesNoResponses = Int()
    @State var ehaP2firstHeardResponseIndex = Int()
    @State var ehaP2firstHeardIsTrue: Bool = false
    @State var ehaP2secondHeardResponseIndex = Int()
    @State var ehaP2secondHeardIsTrue: Bool = false
    @State var ehaP2startTooHigh = 0
    @State var ehaP2firstGain = Float()
    @State var ehaP2secondGain = Float()
    @State var ehaP2endTestSeriesValue: Bool = false
    @State var ehaP2showTestCompletionSheet: Bool = false
    
    @State var ehaP2_samples: [String] = [String]()
    
    @State var ehaP2_dualSamples: [String] = [String]()
    
    
//    @State private var highResStdSamples: [String] = ["Sample17", "Sample18", "Sample19", "Sample20", "Sample21", "Sample22", "Sample23", "Sample24", "Sample25",
//                                                      "Sample17", "Sample18", "Sample19", "Sample20", "Sample21", "Sample22", "Sample23", "Sample24", "Sample25",
//                                                      "Sample26", "Sample27", "Sample28", "Sample29", "Sample30", "Sample31", "Sample32", "Sample33", "Sample34",
//                                                      "Sample26", "Sample27", "Sample28", "Sample29", "Sample30", "Sample31", "Sample32", "Sample33", "Sample34",
//                                                      "Sample35", "Sample36", "Sample37", "Sample38", "Sample39", "Sample40", "Sample41", "Sample42", "Sample43",
//                                                      "Sample35", "Sample36", "Sample37", "Sample38", "Sample39", "Sample40", "Sample41", "Sample42", "Sample43",
//                                                      "Sample44", "Sample45", "Sample46", "Sample47", "Sample48", "Sample49", "Sample50", "Sample51", "Sample52",
//                                                      "Sample44", "Sample45", "Sample46", "Sample47", "Sample48", "Sample49", "Sample50", "Sample51", "Sample52",
//                                                      "Sample53", "Sample54", "Sample55", "Sample56", "Sample57", "Sample58", "Sample59",
//                                                      "Sample53", "Sample54", "Sample55", "Sample56", "Sample57", "Sample58", "Sample59", "PreSilence"]
//
//
//    @State private var highResFadedSamples: [String] = ["FSample17", "FSample18", "FSample19", "FSample20", "FSample21", "FSample22", "FSample23", "FSample24", "FSample25",
//                                                        "FSample17", "FSample18", "FSample19", "FSample20", "FSample21", "FSample22", "FSample23", "FSample24", "FSample25",
//                                                        "FSample26", "FSample27", "FSample28", "FSample29", "FSample30", "FSample31", "FSample32", "FSample33", "FSample34",
//                                                        "FSample26", "FSample27", "FSample28", "FSample29", "FSample30", "FSample31", "FSample32", "FSample33", "FSample34",
//                                                        "FSample35", "FSample36", "FSample37", "FSample38", "FSample39", "FSample40", "FSample41", "FSample42", "FSample43",
//                                                        "FSample35", "FSample36", "FSample37", "FSample38", "FSample39", "FSample40", "FSample41", "FSample42", "FSample43",
//                                                        "FSample44", "FSample45", "FSample46", "FSample47", "FSample48", "FSample49", "FSample50", "FSample51", "FSample52",
//                                                        "FSample44", "FSample45", "FSample46", "FSample47", "FSample48", "FSample49", "FSample50", "FSample51", "FSample52",
//                                                        "FSample53", "FSample54", "FSample55", "FSample56", "FSample57", "FSample58", "FSample59",
//                                                        "FSample53", "FSample54", "FSample55", "FSample56", "FSample57", "FSample58", "FSample59", "PreSilence"]
//
//
//    @State private var cdFadedDitheredSamples: [String] = ["FDSample17", "FDSample18", "FDSample19", "FDSample20", "FDSample21", "FDSample22", "FDSample23", "FDSample24", "FDSample25",
//                                                           "FDSample17", "FDSample18", "FDSample19", "FDSample20", "FDSample21", "FDSample22", "FDSample23", "FDSample24", "FDSample25",
//                                                           "FDSample26", "FDSample27", "FDSample28", "FDSample29", "FDSample30", "FDSample31", "FDSample32", "FDSample33", "FDSample34",
//                                                           "FDSample26", "FDSample27", "FDSample28", "FDSample29", "FDSample30", "FDSample31", "FDSample32", "FDSample33", "FDSample34",
//                                                           "FDSample35", "FDSample36", "FDSample37", "FDSample38", "FDSample39", "FDSample40", "FDSample41", "FDSample42", "FDSample43",
//                                                           "FDSample35", "FDSample36", "FDSample37", "FDSample38", "FDSample39", "FDSample40", "FDSample41", "FDSample42", "FDSample43",
//                                                           "FDSample44", "FDSample45", "FDSample46", "FDSample47", "FDSample48", "FDSample49", "FDSample50", "FDSample51", "FDSample52",
//                                                           "FDSample44", "FDSample45", "FDSample46", "FDSample47", "FDSample48", "FDSample49", "FDSample50", "FDSample51", "FDSample52",
//                                                           "FDSample53", "FDSample54", "FDSample55", "FDSample56", "FDSample57", "FDSample58", "FDSample59",
//                                                           "FDSample53", "FDSample54", "FDSample55", "FDSample56", "FDSample57", "FDSample58", "FDSample59", "PreSilence"]
//
//    @State private var highResStdMonoSamples: [String] = ["Sample17", "Sample18", "Sample19", "Sample20", "Sample21", "Sample22", "Sample23", "Sample24", "Sample25",
//                                                          "Sample26", "Sample27", "Sample28", "Sample29", "Sample30", "Sample31", "Sample32", "Sample33", "Sample34",
//                                                          "Sample35", "Sample36", "Sample37", "Sample38", "Sample39", "Sample40", "Sample41", "Sample42", "Sample43",
//                                                          "Sample44", "Sample45", "Sample46", "Sample47", "Sample48", "Sample49", "Sample50", "Sample51", "Sample52",
//                                                          "Sample53", "Sample54", "Sample55", "Sample56", "Sample57", "Sample58", "Sample59", "PreSilence"]
//
//
//    @State private var highResFadedMonoSamples: [String] = ["FSample17", "FSample18", "FSample19", "FSample20", "FSample21", "FSample22", "FSample23", "FSample24", "FSample25",
//                                                            "FSample26", "FSample27", "FSample28", "FSample29", "FSample30", "FSample31", "FSample32", "FSample33", "FSample34",
//                                                            "FSample35", "FSample36", "FSample37", "FSample38", "FSample39", "FSample40", "FSample41", "FSample42", "FSample43",
//                                                            "FSample44", "FSample45", "FSample46", "FSample47", "FSample48", "FSample49", "FSample50", "FSample51", "FSample52",
//                                                            "FSample53", "FSample54", "FSample55", "FSample56", "FSample57", "FSample58", "FFSample59", "PreSilence"]
//
//
//    @State private var cdFadedDitheredMonoSamples: [String] = ["FDSample17", "FDSample18", "FDSample19", "FDSample20", "FDSample21", "FDSample22", "FDSample23", "FDSample24", "FDSample25",
//                                                               "FDSample26", "FDSample27", "FDSample28", "FDSample29", "FDSample30", "FDSample31", "FDSample32", "FDSample33", "FDSample34",
//                                                               "FDSample35", "FDSample36", "FDSample37", "FDSample38", "FDSample39", "FDSample40", "FDSample41", "FDSample42", "FDSample43",
//                                                               "FDSample44", "FDSample45", "FDSample46", "FDSample47", "FDSample48", "FDSample49", "FDSample50", "FDSample51", "FDSample52",
//                                                               "FDSample53", "FDSample54", "FDSample55", "FDSample56", "FDSample57", "FDSample58", "FDSample59", "PreSilence"]
//
//    @State var ehaP2panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                         1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                         1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                         1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                         1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
//
//    @State var ehaP2panBilateralArray: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
//                                                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
//                                                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
//                                                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
//                                                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
//
//    @State var ehaP2panRightArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                              1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                              1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                              1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
//                                              1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
//
//    @State var ehaP2panLeftArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                              -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                              -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                              -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
//                                              -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0]
//
//    @State var ehaP2_eptaSamplesCountArray = [8, 8, 8, 8, 8, 8, 8, 8, 8,
//                                              17, 17, 17, 17, 17, 17, 17, 17, 17,
//                                              26, 26, 26, 26, 26, 26, 26, 26, 26,
//                                              35, 35, 35, 35, 35, 35, 35, 35, 35,
//                                              44, 44, 44, 44, 44, 44, 44, 44, 44,
//                                              53, 53, 53, 53, 53, 53, 53, 53, 53,
//                                              62, 62, 62, 62, 62, 62, 62, 62, 62,
//                                              71, 71, 71, 71, 71, 71, 71, 71, 71,
//                                              78, 78, 78, 78, 78, 78, 78,
//                                              85, 85, 85, 85, 85, 85, 85]
//
//    ["Sample17", "Sample19", "Sample21", "Sample23", "Sample26", "Sample28", "Sample29", "Sample31", "Sample36",
//     0,                 1,      2,          3           4           5           6           7           8
//     "Sample17", "Sample19", "Sample21", "Sample23", "Sample26", "Sample28", "Sample29", "Sample31", "Sample36",
//        9           10          11          12          13            14        15          16          17
//     "Sample41", "Sample42", "Sample44", "Sample45", "Sample46", "Sample49", "Sample51", "Sample52", "Sample54",
//        18          19          20          21          22          23          24          25          26
//     "Sample41", "Sample42", "Sample44", "Sample45", "Sample46", "Sample49", "Sample51", "Sample52", "Sample54",
//        27          28          29          30          31          32          33          34          35
//     "Sample56", "Sample58", "Sample59",
//        36          37          38
//     "Sample56", "Sample58", "Sample59", "PreSilence"]
//        39          40          41
    
    
    
    @State private var highResStdSamples: [String] = ["Sample17", "Sample19", "Sample21", "Sample23", "Sample26", "Sample28", "Sample29", "Sample31", "Sample36",
                                                      "Sample17", "Sample19", "Sample21", "Sample23", "Sample26", "Sample28", "Sample29", "Sample31", "Sample36",
                                                      "Sample41", "Sample42", "Sample44", "Sample45", "Sample46", "Sample49", "Sample51", "Sample52", "Sample54",
                                                      "Sample41", "Sample42", "Sample44", "Sample45", "Sample46", "Sample49", "Sample51", "Sample52", "Sample54",
                                                      "Sample56", "Sample58", "Sample59",
                                                      "Sample56", "Sample58", "Sample59", "PreSilence"]
    
    
    @State private var highResFadedSamples: [String] = ["FSample17", "FSample19", "FSample21", "FSample23", "FSample26", "FSample28", "FSample29", "FSample31", "FSample36",
                                                        "FSample17", "FSample19", "FSample21", "FSample23", "FSample26", "FSample28", "FSample29", "FSample31", "FSample36",
                                                        "FSample41", "FSample42", "FSample44", "FSample45", "FSample46", "FSample49", "FSample51", "FSample52", "FSample54",
                                                        "FSample41", "FSample42", "FSample44", "FSample45", "FSample46", "FSample49", "FSample51", "FSample52", "FSample54",
                                                        "FSample56", "FSample58", "FSample59",
                                                        "FSample56", "FSample58", "FSample59", "PreSilence"]
    
    
    @State private var cdFadedDitheredSamples: [String] = ["FDSample17", "FDSample19", "FDSample21", "FDSample23", "FDSample26", "FDSample28", "FDSample29", "FDSample31", "FDSample36",
                                                           "FDSample17", "FDSample19", "FDSample21", "FDSample23", "FDSample26", "FDSample28", "FDSample29", "FDSample31", "FDSample36",
                                                           "FDSample41", "FDSample42", "FDSample44", "FDSample45", "FDSample46", "FDSample49", "FDSample51", "FDSample52", "FDSample54",
                                                           "FDSample41", "FDSample42", "FDSample44", "FDSample45", "FDSample46", "FDSample49", "FDSample51", "FDSample52", "FDSample54",
                                                           "FDSample56", "FDSample58", "FDSample59",
                                                           "FDSample56", "FDSample58", "FDSample59", "PreSilence"]
    
    
    
    
    @State var ehaP2_monoSamples: [String] = [String]()
    
    @State private var highResStdMonoSamples: [String] = ["Sample17", "Sample19", "Sample21", "Sample23", "Sample26", "Sample28", "Sample29", "Sample31", "Sample36", "Sample41", "Sample42", "Sample44", "Sample45", "Sample46", "Sample49", "Sample51", "Sample52", "Sample54", "Sample56", "Sample58", "Sample59"]
    
    
    @State private var highResFadedMonoSamples: [String] = ["FSample17", "FSample19", "FSample21", "FSample23", "FSample26", "FSample28", "FSample29", "FSample31", "FSample36", "FSample41", "FSample42", "FSample44", "FSample45", "FSample46", "FSample49", "FSample51", "FSample52", "FSample54", "FSample56", "FSample58", "FSample59"]
    
    
    @State private var cdFadedDitheredMonoSamples: [String] = ["FDSample17", "FDSample19", "FDSample21", "FDSample23", "FDSample26", "FDSample28", "FDSample29", "FDSample31", "FDSample36", "FDSample41", "FDSample42", "FDSample44", "FDSample45", "FDSample46", "FDSample49", "FDSample51", "FDSample52", "FDSample54", "FDSample56", "FDSample58", "FDSample59"]
    
    
    
    
    @State var ehaP2panArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
                                         1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                         -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
                                         1.0, 1.0, 1.0,
                                         -1.0, -1.0, -1.0, -1.0]
                                         
    
    @State var ehaP2panBilateralArray: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                                  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                                  0.0, 0.0, 0.0, 0.0]
    
    @State var ehaP2panRightArray: [Float] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                              1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
                                              1.0, 1.0, 1.0, 1.0]
                                            
    
    @State var ehaP2panLeftArray: [Float] = [-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
                                              -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0,
                                              -1.0, -1.0, -1.0, -1.0]
                                              
    
    
    @State var ehaP2totalCount = Int()
    @State var ehaP2MonoTotalCount = 22         //43
    @State var ehaP2DualTotalCount = 43         //86
    
    @State var ehaP2localPan: Float = Float()
    @State var ehaP2localPanHoldingArray: [Float] = [Float]()
    
    @State var ehaP2MonoTest: Bool = false
    @State var ehaP2MonoRightTest: Bool = false
    @State var ehaP2MonoLeftTest: Bool = false
    @State var ehaP2MonoBilateralTest: Bool = false
    
    @State var ehaP2VariableArraysSet: Bool = false
    
    
    // Presentation Cycles
    // Cycle 1 Right:  ["Sample17", "Sample18", "Sample19", "Sample20", "Sample21", "Sample22", "Sample23", "Sample24", "Sample25"]
    // Cycle 2 Right:  ["Sample26", "Sample27", "Sample28", "Sample29", "Sample30", "Sample31", "Sample32", "Sample33", "Sample34"]
    // Cycle 3 Right:  ["Sample35", "Sample36", "Sample37", "Sample38", "Sample39", "Sample40", "Sample41", "Sample42", "Sample43"]
    // Cycle 4 Right:  ["Sample44", "Sample45", "Sample46", "Sample47", "Sample48", "Sample49", "Sample50", "Sample51", "Sample52", "Sample53"]
    
    
    //    rightFinalGain"\(activeFrequency)"
    
    //Change Sample Numbers
    @State var ehaP2RightFinalGainSample17 = Float()
    @State var ehaP2RightFinalGainSample18 = Float()
    @State var ehaP2RightFinalGainSample19 = Float()
    @State var ehaP2RightFinalGainSample20 = Float()
    @State var ehaP2RightFinalGainSample21 = Float()
    @State var ehaP2RightFinalGainSample22 = Float()
    @State var ehaP2RightFinalGainSample23 = Float()
    @State var ehaP2RightFinalGainSample24 = Float()
    @State var ehaP2RightFinalGainSample25 = Float()
    @State var ehaP2RightFinalGainSample26 = Float()
    @State var ehaP2RightFinalGainSample27 = Float()
    @State var ehaP2RightFinalGainSample28 = Float()
    @State var ehaP2RightFinalGainSample29 = Float()
    @State var ehaP2RightFinalGainSample30 = Float()
    @State var ehaP2RightFinalGainSample31 = Float()
    @State var ehaP2RightFinalGainSample32 = Float()
    @State var ehaP2RightFinalGainSample33 = Float()
    @State var ehaP2RightFinalGainSample34 = Float()
    @State var ehaP2RightFinalGainSample35 = Float()
    @State var ehaP2RightFinalGainSample36 = Float()
    @State var ehaP2RightFinalGainSample37 = Float()
    @State var ehaP2RightFinalGainSample38 = Float()
    @State var ehaP2RightFinalGainSample39 = Float()
    @State var ehaP2RightFinalGainSample40 = Float()
    @State var ehaP2RightFinalGainSample41 = Float()
    @State var ehaP2RightFinalGainSample42 = Float()
    @State var ehaP2RightFinalGainSample43 = Float()
    @State var ehaP2RightFinalGainSample44 = Float()
    @State var ehaP2RightFinalGainSample45 = Float()
    @State var ehaP2RightFinalGainSample46 = Float()
    @State var ehaP2RightFinalGainSample47 = Float()
    @State var ehaP2RightFinalGainSample48 = Float()
    @State var ehaP2RightFinalGainSample49 = Float()
    @State var ehaP2RightFinalGainSample50 = Float()
    @State var ehaP2RightFinalGainSample51 = Float()
    @State var ehaP2RightFinalGainSample52 = Float()
    @State var ehaP2RightFinalGainSample53 = Float()
    @State var ehaP2RightFinalGainSample54 = Float()
    @State var ehaP2RightFinalGainSample55 = Float()
    @State var ehaP2RightFinalGainSample56 = Float()
    @State var ehaP2RightFinalGainSample57 = Float()
    @State var ehaP2RightFinalGainSample58 = Float()
    @State var ehaP2RightFinalGainSample59 = Float()
    
    
    
    @State var ehaP2LeftFinalGainSample17 = Float()
    @State var ehaP2LeftFinalGainSample18 = Float()
    @State var ehaP2LeftFinalGainSample19 = Float()
    @State var ehaP2LeftFinalGainSample20 = Float()
    @State var ehaP2LeftFinalGainSample21 = Float()
    @State var ehaP2LeftFinalGainSample22 = Float()
    @State var ehaP2LeftFinalGainSample23 = Float()
    @State var ehaP2LeftFinalGainSample24 = Float()
    @State var ehaP2LeftFinalGainSample25 = Float()
    @State var ehaP2LeftFinalGainSample26 = Float()
    @State var ehaP2LeftFinalGainSample27 = Float()
    @State var ehaP2LeftFinalGainSample28 = Float()
    @State var ehaP2LeftFinalGainSample29 = Float()
    @State var ehaP2LeftFinalGainSample30 = Float()
    @State var ehaP2LeftFinalGainSample31 = Float()
    @State var ehaP2LeftFinalGainSample32 = Float()
    @State var ehaP2LeftFinalGainSample33 = Float()
    @State var ehaP2LeftFinalGainSample34 = Float()
    @State var ehaP2LeftFinalGainSample35 = Float()
    @State var ehaP2LeftFinalGainSample36 = Float()
    @State var ehaP2LeftFinalGainSample37 = Float()
    @State var ehaP2LeftFinalGainSample38 = Float()
    @State var ehaP2LeftFinalGainSample39 = Float()
    @State var ehaP2LeftFinalGainSample40 = Float()
    @State var ehaP2LeftFinalGainSample41 = Float()
    @State var ehaP2LeftFinalGainSample42 = Float()
    @State var ehaP2LeftFinalGainSample43 = Float()
    @State var ehaP2LeftFinalGainSample44 = Float()
    @State var ehaP2LeftFinalGainSample45 = Float()
    @State var ehaP2LeftFinalGainSample46 = Float()
    @State var ehaP2LeftFinalGainSample47 = Float()
    @State var ehaP2LeftFinalGainSample48 = Float()
    @State var ehaP2LeftFinalGainSample49 = Float()
    @State var ehaP2LeftFinalGainSample50 = Float()
    @State var ehaP2LeftFinalGainSample51 = Float()
    @State var ehaP2LeftFinalGainSample52 = Float()
    @State var ehaP2LeftFinalGainSample53 = Float()
    @State var ehaP2LeftFinalGainSample54 = Float()
    @State var ehaP2LeftFinalGainSample55 = Float()
    @State var ehaP2LeftFinalGainSample56 = Float()
    @State var ehaP2LeftFinalGainSample57 = Float()
    @State var ehaP2LeftFinalGainSample58 = Float()
    @State var ehaP2LeftFinalGainSample59 = Float()
    
    
    
    @State var ehaP2rightFinalGainsArray = [Float]()
    @State var ehaP2leftFinalGainsArray = [Float]()
    @State var ehaP2finalStoredRightFinalGainsArray = [Float]()
    @State var ehaP2finalStoredleftFinalGainsArray = [Float]()
    
    
    
    @State var ehaP2_index: Int = 0
    @State var ehaP2_testGain: Float = 0.2
    @State var ehaP2_heardArray: [Int] = [Int]()
    @State var ehaP2_indexForTest = [Int]()
    @State var ehaP2_testCount: [Int] = [Int]()
    @State var ehaP2_pan: Float = Float()
    @State var ehaP2_testPan = [Float]()
    @State var ehaP2_testTestGain = [Float]()
    @State var ehaP2_frequency = [String]()
    @State var ehaP2_reversalHeard = [Int]()
    @State var ehaP2_reversalGain = [Float]()
    @State var ehaP2_reversalFrequency = [String]()
    @State var ehaP2_reversalDirection = Float()
    @State var ehaP2_reversalDirectionArray = [Float]()
    
    @State var ehaP2_averageGain = Float()
    
    @State var ehaP2_eptaSamplesCount = 42       //86 //8 //17
    //    @State var ehaP2_eptaSamplesCountArray = [2, 2, 2]
    @State var ehaP2_eptaSamplesCountArray = [8, 8, 8, 8, 8, 8, 8, 8, 8,
                                              17, 17, 17, 17, 17, 17, 17, 17, 17,
                                              26, 26, 26, 26, 26, 26, 26, 26, 26,
                                              35, 35, 35, 35, 35, 35, 35, 35, 35,
                                              38, 38, 38,
                                              41, 41, 41]
                                              
                                              
                                              
                                              
                                              
    @State var ehaP2_eptaSamplesCountArrayIdx = 0  //[0, 1, 2, 3]
    
    @State var ehaP2_finalStoredIndex: [Int] = [Int]()
    @State var ehaP2_finalStoredTestPan: [Float] = [Float]()
    @State var ehaP2_finalStoredTestTestGain: [Float] = [Float]()
    @State var ehaP2_finalStoredFrequency: [String] = [String]()
    @State var ehaP2_finalStoredTestCount: [Int] = [Int]()
    @State var ehaP2_finalStoredHeardArray: [Int] = [Int]()
    @State var ehaP2_finalStoredReversalHeard: [Int] = [Int]()
    @State var ehaP2_finalStoredFirstGain: [Float] = [Float]()
    @State var ehaP2_finalStoredSecondGain: [Float] = [Float]()
    @State var ehaP2_finalStoredAverageGain: [Float] = [Float]()
    
    @State var ehaP2idxForTest = Int() // = ehaP2_indexForTest.count
    @State var ehaP2idxForTestNet1 = Int() // = ehaP2_indexForTest.count - 1
    @State var ehaP2idxTestCount = Int() // = ehaP2_TestCount.count
    @State var ehaP2idxTestCountUpdated = Int() // = ehaP2_TestCount.count + 1
    @State var ehaP2activeFrequency = String()
    @State var ehaP2idxHA = Int()    // idx = ehaP2_heardArray.count
    @State var ehaP2idxReversalHeardCount = Int()
    @State var ehaP2idxHAZero = Int()    //  idxZero = idx - idx
    @State var ehaP2idxHAFirst = Int()   // idxFirst = idx - idx + 1
    @State var ehaP2isCountSame = Int()
    @State var ehaP2heardArrayIdxAfnet1 = Int()
    @State var ehaP2testIsPlaying: Bool = false
    @State var ehaP2playingString: [String] = ["", "Start or Restart Test", "Great Job, You've Completed This Test Segment"]
    @State var ehaP2playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    
    @State var ehaP2playingAlternateStringColor: [Color] = [Color.clear, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.white, Color.green]
    
    @State var ehaP2playingStringColorIndex = 0
    @State var ehaP2playingStringColorIndex2 = 0
    @State var ehaP2userPausedTest: Bool = false
    
    @State var ehaP2fullTestCompleted: Bool = false
    @State var ehaP2fullTestCompletedHoldingArray: [Bool] = [Bool]()
//    @State var ehaP2fullTestCompletedLR: [Bool] = [false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false,
//                                                   false, false, false, false, false, false, false, true]
//
//    @State var ehaP2fullTestCompletedMono: [Bool] = [false, false, false, false, false, false, false, false, false,
//                                                     false, false, false, false, false, false, false, false, false,
//                                                     false, false, false, false, false, false, false, false, false,
//                                                     false, false, false, false, false, false, false, false, false,
//                                                     false, false, false, false, false, false, false, true]
    
    @State var ehaP2fullTestCompletedLR: [Bool] = [false, false, false, false, false, false, false, false, false,
                                                   false, false, false, false, false, false, false, false, false,
                                                   false, false, false, false, false, false, false, false, false,
                                                   false, false, false, false, false, false, false, false, false,
                                                   false, false, false,
                                                   false, false, false, true]
    
    @State var ehaP2fullTestCompletedMono: [Bool] = [false, false, false, false, false, false, false, false, false,
                                                     false, false, false, false, false, false, false, false, false,
                                                     false, false, false, true]
                                                     
                                                     
    
    
    
    
    @State var ehaP2TestingPhases = 0
    @State var displayGainData: Bool = false
    
    
    //
    //
    //
    // Added Manual AirPods Pro Gen 2 Values for Calibration
        @State var ehaP2_StartingDB = Float()                    //Make this a freq dependent array in other views linked to index
        @State var ehaP2_AirPodsProGen2MaxDB = Float()    //Make this a freq dependent array in other views linked to index
        
        
        @State var ehaP2_AirPodsProGen2MaxDBArray = [Float]()
        @State var gainDBehaP2SettingArray = [Float]()  // Make this target starting dB levels by frequency
        
    //        gainehaP2SettingArray.append(contentsOf: gainReferenceModel.ABS2_5_ehaP2
        
        
        @State var ehaP2_PriorDB: Float = Float()
        @State var ehaP2_CurrentDB: Float = Float()
        @State var ehaP2_StepSizeDB: Float = 0.0
        @State var ehaP2_NewTargetDB: Float = Float()
      
        @State var ehaP2_testGainDB: Float = Float() //0.025
        @State var ehaP2_reversalGainDB = [Float]()
        @State var ehaP2_testTestGainDB = [Float]()
       
        
        @State var ehaP2firstGainDB = Float()
        @State var ehaP2secondGainDB = Float()
        
        @State var ehaP2firstGainDBRight1 = Float()
        @State var ehaP2secondGainDBRight1 = Float()
        @State var ehaP2firstGainDBRight2 = Float()
        @State var ehaP2secondGainDBRight2 = Float()
        @State var ehaP2firstGainDBLeft1 = Float()
        @State var ehaP2secondGainDBLeft1 = Float()
        @State var ehaP2firstGainDBLeft2 = Float()
        @State var ehaP2secondGainDBLeft2 = Float()
        
        @State var ehaP2_rightFirstSecondGainDBArray: [Float] = [Float]()
        @State var ehaP2_leftFirstSecondGainDBArray: [Float] = [Float]()
        
       
        @State var ehaP2RightDBSorted: [Float] = [Float]()
        @State var ehaP2LeftDBSorted: [Float] = [Float]()
        @State var ehaP2IntraEarDeltaHL1DB = Float()
        @State var ehaP2IntraEarDeltaHL2DB = Float()
        @State var ehaP2IntraEarDeltaHLFinalDB = Float()
        
        @State var ehaP2FinalLRGainsDB1: [Float] = [Float]()
        @State var ehaP2FinalLRGainsDB2: [Float] = [Float]()
        @State var ehaP2InterimLRGainsDBFinal: [Float] = [Float]()
        @State var ehaP2FinalComboLRGainsDB: [Float] = [Float]()
        
        
        @State var ehaP2_averageGainDB = Float()
        @State var ehaP2_averageGainDBRight = Float()
        @State var ehaP2_averageGainDBLeft = Float()
        
        @State var ehaP2_averageGainDBRight1 = Float()
        @State var ehaP2_averageGainDBRight2 = Float()
        @State var ehaP2_averageGainDBRightArray: [Float] = [Float]()
        @State var ehaP2_averageLowestGainDBRightArray: [Float] = [Float]()
        @State var ehaP2_idxFirstAverageGainDBRightArray = Float()
        @State var ehaP2_idxlastAverageGainDBRightArray = Float()
        
        @State var ehaP2_averageGainDBLeft1 = Float()
        @State var ehaP2_averageGainDBLeft2 = Float()
        @State var ehaP2_averageGainDBLeftArray: [Float] = [Float]()
        @State var ehaP2_averageLowestGainDBLeftArray: [Float] = [Float]()
        @State var ehaP2_idxFirstAverageGainDBLeftArray = Float()
        @State var ehaP2_idxlastAverageGainDBLeftArray = Float()
        
        @State var ehaP2_HoldingLowestRightGainDBArray: [Float] = [Float]()
        @State var ehaP2_HoldingLowestLeftGainDBArray: [Float] = [Float]()
      
        
        @State var ehaP2_finalStoredFirstGainDB: [Float] = [Float]()
        @State var ehaP2_finalStoredSecondGainDB: [Float] = [Float]()
        @State var ehaP2_finalStoredAverageGainDB: [Float] = [Float]()
        
        
        @State var final_ehaP2_ehaP2firstGainDB = [Float]()
        @State var final_ehaP2_ehaP2secondGainDB = [Float]()
        @State var final_ehaP2_reversalGainDB = [Float]()
        @State var final_ehaP2_testTestGainDB = [Float]()
        @State var final_ehaP2_averageGainDB = [Float]()
        @State var final_ehaP2_averageGainDBRightArray = [Float]()
        @State var final_ehaP2_averageGainDBLeftArray = [Float]()
        @State var final_ehaP2_averageLowestGainDBRightArray = [Float]()
        @State var final_ehaP2_HoldingLowestRightGainDBArray = [Float]()
        @State var final_ehaP2_averageLowestGainDBLeftArray = [Float]()
        @State var final_ehaP2_HoldingLowestLeftGainDBArray = [Float]()
        
        
           
        @State var ehaP2RightFinalGainDBSample17 = Float()
        @State var ehaP2RightFinalGainDBSample18 = Float()
        @State var ehaP2RightFinalGainDBSample19 = Float()
        @State var ehaP2RightFinalGainDBSample20 = Float()
        @State var ehaP2RightFinalGainDBSample21 = Float()
        @State var ehaP2RightFinalGainDBSample22 = Float()
        @State var ehaP2RightFinalGainDBSample23 = Float()
        @State var ehaP2RightFinalGainDBSample24 = Float()
        @State var ehaP2RightFinalGainDBSample25 = Float()
        @State var ehaP2RightFinalGainDBSample26 = Float()
        @State var ehaP2RightFinalGainDBSample27 = Float()
        @State var ehaP2RightFinalGainDBSample28 = Float()
        @State var ehaP2RightFinalGainDBSample29 = Float()
        @State var ehaP2RightFinalGainDBSample30 = Float()
        @State var ehaP2RightFinalGainDBSample31 = Float()
        @State var ehaP2RightFinalGainDBSample32 = Float()
        @State var ehaP2RightFinalGainDBSample33 = Float()
        @State var ehaP2RightFinalGainDBSample34 = Float()
        @State var ehaP2RightFinalGainDBSample35 = Float()
        @State var ehaP2RightFinalGainDBSample36 = Float()
        @State var ehaP2RightFinalGainDBSample37 = Float()
        @State var ehaP2RightFinalGainDBSample38 = Float()
        @State var ehaP2RightFinalGainDBSample39 = Float()
        @State var ehaP2RightFinalGainDBSample40 = Float()
        @State var ehaP2RightFinalGainDBSample41 = Float()
        @State var ehaP2RightFinalGainDBSample42 = Float()
        @State var ehaP2RightFinalGainDBSample43 = Float()
        @State var ehaP2RightFinalGainDBSample44 = Float()
        @State var ehaP2RightFinalGainDBSample45 = Float()
        @State var ehaP2RightFinalGainDBSample46 = Float()
        @State var ehaP2RightFinalGainDBSample47 = Float()
        @State var ehaP2RightFinalGainDBSample48 = Float()
        @State var ehaP2RightFinalGainDBSample49 = Float()
        @State var ehaP2RightFinalGainDBSample50 = Float()
        @State var ehaP2RightFinalGainDBSample51 = Float()
        @State var ehaP2RightFinalGainDBSample52 = Float()
        @State var ehaP2RightFinalGainDBSample53 = Float()
        @State var ehaP2RightFinalGainDBSample54 = Float()
        @State var ehaP2RightFinalGainDBSample55 = Float()
        @State var ehaP2RightFinalGainDBSample56 = Float()
        @State var ehaP2RightFinalGainDBSample57 = Float()
        @State var ehaP2RightFinalGainDBSample58 = Float()
        @State var ehaP2RightFinalGainDBSample59 = Float()
        
        
        
        @State var ehaP2LeftFinalGainDBSample17 = Float()
        @State var ehaP2LeftFinalGainDBSample18 = Float()
        @State var ehaP2LeftFinalGainDBSample19 = Float()
        @State var ehaP2LeftFinalGainDBSample20 = Float()
        @State var ehaP2LeftFinalGainDBSample21 = Float()
        @State var ehaP2LeftFinalGainDBSample22 = Float()
        @State var ehaP2LeftFinalGainDBSample23 = Float()
        @State var ehaP2LeftFinalGainDBSample24 = Float()
        @State var ehaP2LeftFinalGainDBSample25 = Float()
        @State var ehaP2LeftFinalGainDBSample26 = Float()
        @State var ehaP2LeftFinalGainDBSample27 = Float()
        @State var ehaP2LeftFinalGainDBSample28 = Float()
        @State var ehaP2LeftFinalGainDBSample29 = Float()
        @State var ehaP2LeftFinalGainDBSample30 = Float()
        @State var ehaP2LeftFinalGainDBSample31 = Float()
        @State var ehaP2LeftFinalGainDBSample32 = Float()
        @State var ehaP2LeftFinalGainDBSample33 = Float()
        @State var ehaP2LeftFinalGainDBSample34 = Float()
        @State var ehaP2LeftFinalGainDBSample35 = Float()
        @State var ehaP2LeftFinalGainDBSample36 = Float()
        @State var ehaP2LeftFinalGainDBSample37 = Float()
        @State var ehaP2LeftFinalGainDBSample38 = Float()
        @State var ehaP2LeftFinalGainDBSample39 = Float()
        @State var ehaP2LeftFinalGainDBSample40 = Float()
        @State var ehaP2LeftFinalGainDBSample41 = Float()
        @State var ehaP2LeftFinalGainDBSample42 = Float()
        @State var ehaP2LeftFinalGainDBSample43 = Float()
        @State var ehaP2LeftFinalGainDBSample44 = Float()
        @State var ehaP2LeftFinalGainDBSample45 = Float()
        @State var ehaP2LeftFinalGainDBSample46 = Float()
        @State var ehaP2LeftFinalGainDBSample47 = Float()
        @State var ehaP2LeftFinalGainDBSample48 = Float()
        @State var ehaP2LeftFinalGainDBSample49 = Float()
        @State var ehaP2LeftFinalGainDBSample50 = Float()
        @State var ehaP2LeftFinalGainDBSample51 = Float()
        @State var ehaP2LeftFinalGainDBSample52 = Float()
        @State var ehaP2LeftFinalGainDBSample53 = Float()
        @State var ehaP2LeftFinalGainDBSample54 = Float()
        @State var ehaP2LeftFinalGainDBSample55 = Float()
        @State var ehaP2LeftFinalGainDBSample56 = Float()
        @State var ehaP2LeftFinalGainDBSample57 = Float()
        @State var ehaP2LeftFinalGainDBSample58 = Float()
        @State var ehaP2LeftFinalGainDBSample59 = Float()
        
        
        @State var ehaP2rightFinalGainsDBArray = [Float]()
        @State var ehaP2leftFinalGainsDBArray = [Float]()
        @State var ehaP2finalStoredRightFinalGainsDBArray = [Float]()
        @State var ehaP2finalStoredleftFinalGainsDBArray = [Float]()
        
        
        @State var ehaP2_finalStoredTestTestGainDB: [Float] = [Float]()
        
    // End of Added DB Variables
    //
    //
    //
    
    
    
    @State var dataFileURLEHAP2Gain1 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain2 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain3 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain4 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain5 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain6 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain7 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain8 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain9 = URL(fileURLWithPath: "")
    @State var dataFileURLEHAP2Gain10 = URL(fileURLWithPath: "")
    
    @State var gainEHAP2SettingArrayLink = Float()
    @State var gainEHAP2SettingArray = [Float]()
    @State var gainEHAP2PhonIsSet = false
    
    @State var ehaP2jsonHoldingString: [String] = [String]()
    
    @State var ehaP2EPTATestCompleted: Bool = false
    
    @State var ehaP2TestStarted: Bool = false
    
    
    let fileehaP2Name = "SummaryehaP2Results.json"
    let summaryehaP2CSVName = "SummaryehaP2ResultsCSV.csv"
    let detailedehaP2CSVName = "DetailedehaP2ResultsCSV.csv"
    let inputehaP2SummaryCSVName = "InputSummaryehaP2ResultsCSV.csv"
    let inputehaP2DetailedCSVName = "InputDetailedehaP2ResultsCSV.csv"
    let summaryEHAP2LRCSVName = "SummaryEHAP2LRResultsCSV.csv"
    let summaryEHAP2RightCSVName = "SummaryEHAP2RightResultsCSV.csv"
    let summaryEHAP2LeftCSVName = "SummaryEHAP2LeftResultsCSV.csv"
    let inputEHAP2LRSummaryCSVName = "InputSummaryEHAP2LRResultsCSV.csv"
    let inputEHAP2RightSummaryCSVName = "InputSummaryEHAP2RightResultsCSV.csv"
    let inputEHAP2LeftSummaryCSVName = "InputSummaryEHAP2LeftResultsCSV.csv"
    
    @State var ehaP2saveFinalResults: ehaP2SaveFinalResults? = nil
    
    let ehaP2heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let ehaP2arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let ehaP2audioThread = DispatchQueue(label: "AudioThread", qos: .default)
    let ehaP2preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var changeSampleArray: Bool = false
    @State private var highResStandard: Bool = false
    @State private var highResFaded: Bool = false
    @State private var cdFadedDithered: Bool = false
    @State private var sampleArraySet: Bool = false
    
    
    let ehaP2ThreadBackground = DispatchQueue(label: "AudioThread", qos: .background)
    let ehaP2ThreadDefault = DispatchQueue(label: "AudioThread", qos: .default)
    let ehaP2ThreadUserInteractive = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let ehaP2ThreadUserInitiated = DispatchQueue(label: "AudioThread", qos: .userInitiated)
    
    @State private var showQoSThreads: Bool = false
    @State private var qualityOfService = Int()
    @State private var qosBackground: Bool = false
    @State private var qosDefault: Bool = false
    @State private var qosUserInteractive: Bool = false
    @State private var qosUserInitiated: Bool = false
    
    @State private var showDataValues: Bool = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack {
                HStack{
                    VStack{
            
                            Toggle(isOn: $showDataValues) {
                                Text("ShowDataValues")
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 40)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom,20)
                        
                        if ehaP2fullTestCompleted == false {
                            HStack{
                                Text("EHA Part 2 Test Cycle \(ehaP2TestingPhases)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(.white)
                            }
                            
                            if showDataValues == true {
                                HStack{
                                    Spacer()
                                    Text("CurrentDB: \(ehaP2_CurrentDB)")
                                    Spacer()
                                    Text("NewTargetDB: \(ehaP2_NewTargetDB)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                HStack{
                                    Spacer()
                                    Text("testGainDB: \(ehaP2_testGainDB)")
                                    Spacer()
                                    Text("StepSizeDB: \(ehaP2_StepSizeDB)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                
                                HStack{
                                    Spacer()
                                    Text("testGain: \(ehaP2_testGain)")
                                    Spacer()
                                    Text("Sample: \(ehaP2activeFrequency)")
                                    Spacer()
                                }
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                                .padding(.bottom, 20)
                            }
                            
                        } else if ehaP2fullTestCompleted == true {
                            NavigationLink("Test Phase Complete, Press To Continue", destination: PostEHATestView(ehaTesting: ehaTesting, relatedLinkEHATesting: linkEHATesting))
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        }
                    }
                }
                .navigationDestination(isPresented: $ehaP2fullTestCompleted) {
                    PostEHATestView(ehaTesting: ehaTesting, relatedLinkEHATesting: linkEHATesting)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                

//                HStack{
//                    Spacer()
//                    Toggle("Show Data", isOn: $displayGainData)
//                        .font(.caption)
//                        .foregroundColor(.white)
//                        .padding(.leading)
//                    if displayGainData == true {
//                        Text("Gain:\n\(ehaP2_testGain)")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("Pan:\n\(ehaP2_pan)")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("phon:\n\(gainEHAP2SettingArrayLink)")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                .padding(.top, 5)
//                .padding(.bottom, 5)
//                .padding(.leading)
                
                if ehaP2TestStarted == false {
                    Button {
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            ehaP2setDualMonoVariables()
                            ehaP2localPlaying = 1
                            ehaP2endTestSeriesValue = false
                            changeSampleArray = false
                            ehaP2MonoTest = false
                            changeSampleArray = false
                            print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
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
                } else if ehaP2TestStarted == true {
                    Button {
                        ehaP2localPlaying = 0
                        ehaP2stop()
                        ehaP2userPausedTest = true
                        ehaP2playingStringColorIndex = 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                            ehaP2localPlaying = 0
                            ehaP2stop()
                            ehaP2userPausedTest = true
                            ehaP2playingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                            ehaP2localPlaying = 0
                            ehaP2stop()
                            ehaP2userPausedTest = true
                            ehaP2playingStringColorIndex = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                            ehaP2localPlaying = 0
                            ehaP2stop()
                            ehaP2userPausedTest = true
                            ehaP2playingStringColorIndex = 1
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
                        ehaP2_heardArray.removeAll()
                        ehaP2pauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        ehaP2localPlaying = 1
                        ehaP2userPausedTest = false
                        ehaP2playingStringColorIndex = 0
                        ehaP2endTestSeriesValue = false
                        ehaP2setDualMonoVariables()
                        print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
                    } label: {
                        Text(ehaP2playingString[ehaP2playingStringColorIndex])
                            .foregroundColor(ehaP2playingAlternateStringColor[ehaP2playingStringColorIndex+1])
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(ehaP2playingAlternateStringColor[ehaP2playingStringColorIndex])
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                Button {
                    ehaP2heardThread.async{ self.ehaP2localHeard = 1
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
            }
            .fullScreenCover(isPresented: $ehaP2showTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)//, edges: .top)
                    VStack(alignment: .leading) {
                        Button(action: {
                            if ehaP2fullTestCompleted == true {
                                ehaP2showTestCompletionSheet.toggle()
                            } else if ehaP2fullTestCompleted == false {
                                ehaP2showTestCompletionSheet.toggle()
                                ehaP2setDualMonoVariables()
                                ehaP2endTestSeriesValue = false
                                ehaP2testIsPlaying = true
                                ehaP2localPlaying = 1
                                ehaP2playingStringColorIndex = 2
                                ehaP2userPausedTest = false
                                print("Start Button Clicked. Playing = \(ehaP2localPlaying)")
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.clear)
                        })
                        
                        if ehaP2fullTestCompleted == false {
                            VStack(alignment: .leading, spacing: 10){
                                Toggle(isOn: $showQoSThreads) {
                                    Text("Change Qos Threads")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                if showQoSThreads == true {
                                    HStack{
                                        Toggle("Background", isOn: $qosBackground)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("Default", isOn: $qosDefault)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                    HStack{
                                        Toggle("UserInteractive", isOn: $qosUserInteractive)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("UserInitiated", isOn: $qosUserInitiated)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                }
                            }
                            .onChange(of: qosBackground) { backgroundValue in
                                if backgroundValue == true {
                                    qosBackground = true
                                    qosDefault = false
                                    qosUserInteractive = false
                                    qosUserInitiated = false
                                    qualityOfService = 1
                                }
                            }
                            .onChange(of: qosDefault) { defaultValue in
                                if defaultValue == true {
                                    qosBackground = false
                                    qosDefault = true
                                    qosUserInteractive = false
                                    qosUserInitiated = false
                                    qualityOfService = 2
                                }
                            }
                            .onChange(of: qosUserInteractive) { interactiveValue in
                                if interactiveValue == true {
                                    qosBackground = false
                                    qosDefault = false
                                    qosUserInteractive = true
                                    qosUserInitiated = false
                                    qualityOfService = 3
                                }
                            }
                            .onChange(of: qosUserInitiated) { initiatedValue in
                                if initiatedValue == true {
                                    qosBackground = false
                                    qosDefault = false
                                    qosUserInteractive = false
                                    qosUserInitiated = true
                                    qualityOfService = 4
                                }
                            }
                        }
                        
                        if ehaP2fullTestCompleted == false {
                            VStack{
                                Toggle(isOn: $changeSampleArray) {
                                    Text("ChangeSampleType")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                if changeSampleArray == true {
                                    HStack{
                                        Toggle("92/24\nStd", isOn: $highResStandard)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("92/24\nFaded", isOn: $highResFaded)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Toggle("48/16\nFaded", isOn: $cdFadedDithered)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .padding(.leading, 10)
                                    .padding(.bottom, 10)
                                }
                            }
                            .onChange(of: changeSampleArray) { change in
                                if change == true {
                                    sampleArraySet = false
                                } else if change == false {
                                    sampleArraySet = true
                                }
                            }
                            .onChange(of: highResStandard) { highResValue in
                                sampleArraySet = false
                                if highResValue == true && sampleArraySet == false {
                                    //remove array values
                                    ehaP2_dualSamples.removeAll()
                                    ehaP2_monoSamples.removeAll()
                                    //set other toggles to fales
                                    highResFaded = false
                                    cdFadedDithered = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    ehaP2_dualSamples.append(contentsOf: highResStdSamples)
                                    ehaP2_monoSamples.append(contentsOf: highResStdMonoSamples)
                                    print("ehaP2_samples: \(ehaP2_dualSamples)")
                                    print("ehaP2_monoSamples: \(ehaP2_monoSamples)")
                                }
                            }
                            .onChange(of: highResFaded) { highResFadedValue in
                                sampleArraySet = false
                                if highResFadedValue == true && sampleArraySet == false {
                                    //remove array values
                                    ehaP2_dualSamples.removeAll()
                                    ehaP2_monoSamples.removeAll()
                                    //set other toggles to fales
                                    highResStandard = false
                                    cdFadedDithered = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    ehaP2_dualSamples.append(contentsOf: highResFadedSamples)
                                    ehaP2_monoSamples.append(contentsOf: highResFadedMonoSamples)
                                    print("ehaP2_samples: \(ehaP2_dualSamples)")
                                    print("ehaP2_monoSamples: \(ehaP2_monoSamples)")
                                }
                            }
                            .onChange(of: cdFadedDithered) { cdFadedDitheredValue in
                                sampleArraySet = false
                                if cdFadedDitheredValue == true && sampleArraySet == false {
                                    //remove array values
                                    ehaP2_dualSamples.removeAll()
                                    ehaP2_monoSamples.removeAll()
                                    //set other toggles to fales
                                    highResStandard = false
                                    highResFaded = false
                                    sampleArraySet = true
                                    //append new highresstd values
                                    ehaP2_dualSamples.append(contentsOf: cdFadedDitheredSamples)
                                    ehaP2_monoSamples.append(contentsOf: cdFadedDitheredMonoSamples)
                                    print("ehaP2_samples: \(ehaP2_dualSamples)")
                                    print("ehaP2_monoSamples: \(ehaP2_monoSamples)")
                                }
                            }
                        }

//                        if ehaP2fullTestCompleted == false {
//                            VStack(alignment: .leading, spacing: 10){
//                                Toggle(isOn: $ehaP2MonoTest) {
//                                    Text("SetMonoTest")
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.leading, 10)
//                                .padding(.trailing, 10)
//                                .padding(.bottom, 10)
//                                if ehaP2MonoTest == true {
//                                    HStack{
//                                        Toggle("Right", isOn: $ehaP2MonoRightTest)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("Left", isOn: $ehaP2MonoLeftTest)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                        Toggle("Bilat", isOn: $ehaP2MonoBilateralTest)
//                                            .foregroundColor(.white)
//                                            .font(.caption)
//                                        Spacer()
//                                    }
//                                    .padding(.leading, 10)
//                                    .padding(.bottom, 10)
//                                }
//                            }
//                            .onChange(of: ehaP2MonoRightTest) { rightValue in
//                                if rightValue == true {
//                                    // Set Pan to 1.0
//                                    ehaP2localPanHoldingArray = ehaP2panRightArray
//                                    ehaP2fullTestCompletedHoldingArray = ehaP2fullTestCompletedMono
//                                    ehaP2totalCount = ehaP2MonoTotalCount
//                                    ehaP2_samples = ehaP2_monoSamples
//                                    ehaP2MonoRightTest = true
//                                    ehaP2MonoLeftTest = false
//                                    ehaP2MonoBilateralTest = false
//                                } else {
//                                    // Do Nothing
//                                }
//                            }
//                            .onChange(of: ehaP2MonoLeftTest) { leftValue in
//                                if leftValue == true {
//                                    //set pan to -1.0
//                                    ehaP2localPanHoldingArray = ehaP2panLeftArray
//                                    ehaP2fullTestCompletedHoldingArray = ehaP2fullTestCompletedMono
//                                    ehaP2totalCount = ehaP2MonoTotalCount
//                                    ehaP2_samples = ehaP2_monoSamples
//                                    ehaP2MonoRightTest = false
//                                    ehaP2MonoLeftTest = true
//                                    ehaP2MonoBilateralTest = false
//                                } else {
//                                    //do nothing
//                                }
//                            }
//                            .onChange(of: ehaP2MonoBilateralTest) { bilateralValue in
//                                if bilateralValue == true {
//                                    ehaP2localPanHoldingArray = ehaP2panBilateralArray
//                                    ehaP2fullTestCompletedHoldingArray = ehaP2fullTestCompletedMono
//                                    ehaP2totalCount = ehaP2MonoTotalCount
//                                    ehaP2_samples = ehaP2_monoSamples
//                                    ehaP2MonoRightTest = false
//                                    ehaP2MonoLeftTest = false
//                                    ehaP2MonoBilateralTest = true
//                                } else {
//                                    //do nothing
//                                }
//                            }
//                        }

                        if ehaP2fullTestCompleted == false && ehaP2TestingPhases < 1 {
                            ScrollView {
                                Text("You are now going to take the full extended hearing assessment. The test is completed in SIX(6) phases and will take about 15 minutes to complete.")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .padding(.bottom, 10)
                                Text("Make sure to take a break after each test phase, as you must concentrate deeply while actively testing, which may become tiring without breaks")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .padding(.bottom, 10)
                            }
                            .frame(width: nil, height: 220, alignment: .leading)
                            .padding()
                            .cornerRadius(24)
                            Spacer()
                            HStack{
                                Spacer()
                                Text("Let's Continue To Start The Test!")
                                    .frame(width: 300, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .cornerRadius(24)
                                    .onTapGesture {
                                        ehaP2TestingPhases += 1
                                        ehaP2showTestCompletionSheet.toggle()
                                        ehaP2_CurrentDB = ehaP2_StartingDB
                                        ehaP2_NewTargetDB = ehaP2_CurrentDB
                                        //
                                        //
                                        //
                                        ehaP2_testGainDB = ehaP2_CurrentDB
                                        //
                                        //
                                        //
                                        ehaP2_testGain = powf(10.0, ((ehaP2_StartingDB - ehaP2_AirPodsProGen2MaxDB)/20))
                                    }
                                Spacer()
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                            Spacer()
                            
                        } else if ehaP2fullTestCompleted == false && ehaP2TestingPhases >= 1 {
                            Spacer()
                            Text("Take a moment for a break before exiting to continue with the next test segment")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                            Spacer()
                            Text("You have completed \(ehaP2TestingPhases) of SIX test phases.")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    if ehaP2fullTestCompleted == true {
                                        ehaP2showTestCompletionSheet.toggle()
                                    } else if ehaP2fullTestCompleted == false {
                                        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
                                            Task(priority: .userInitiated) {
                                                await ehaP2combinedPauseRestartAndStartNexTestCycle()
                                                ehaP2TestingPhases += 1
//
//                                                ehaP2_CurrentDB = ehaP2_StartingDB
//                                                ehaP2_NewTargetDB = ehaP2_CurrentDB
//                                                ehaP2_testGain = powf(10.0, ((ehaP2_StartingDB - ehaP2_AirPodsProGen2MaxDB)/20))
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Start The Next Cycle")
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(width: 200, height: 50, alignment: .center)
                                        .background(colorModel.tiffanyBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(300)
                                })
                                Spacer()
                            }
                        } else if ehaP2fullTestCompleted == true && ehaP2TestingPhases >= 1 {
                            Text("Full Test Completed! Let's Proceed.")
                                .foregroundColor(.green)
                                .font(.title)
                                .padding()
                                .padding(.bottom, 20)
                            HStack{
                                Spacer()
                                
                                Button {
                                    self.ehaP2EPTATestCompleted = true
                                    ehaP2showTestCompletionSheet.toggle()
                                } label: {
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(width: 200, height: 50, alignment: .center)
                                        .background(Color .green)
                                        .foregroundColor(.white)
                                        .cornerRadius(300)
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
        }
        .onAppear() {
            Task(priority: .userInitiated) {
                if gainEHAP2PhonIsSet == false && changeSampleArray == false {
                    await checkGainEHAP2_2_5DataLink()
                    await checkGainEHAP2_4DataLink()
                    await checkGainEHAP2_5DataLink()
                    await checkGainEHAP2_7DataLink()
                    await checkGainEHAP2_8DataLink()
                    await checkGainEHAP2_11DataLink()
                    await checkGainEHAP2_16DataLink()
                    await checkGainEHAP2_17DataLink()
                    await checkGainEHAP2_24DataLink()
                    await checkGainEHAP2_27DataLink()
                    await gainEHAP2CurveAssignment()
                    ehaP2_testGain = gainEHAP2SettingArray[ehaP2_index]
                    await comparedLastNameCSVReader()
                    await gainEHAP2HeadphoneAssignment()
                    ehaP2_StartingDB = gainEHAP2SettingArray[ehaP2_index]
                    ehaP2_CurrentDB = ehaP2_StartingDB
                    ehaP2_NewTargetDB = ehaP2_StartingDB
                    ehaP2_AirPodsProGen2MaxDB = ehaP2_AirPodsProGen2MaxDBArray[ehaP2_index]
                    await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)    // This will set _testGain
                    
                    gainEHAP2PhonIsSet = true
                    
                    
                    cdFadedDithered = true
                    
                    qosBackground = false
                    qosDefault = false
                    qosUserInteractive = true
                    qosUserInitiated = false
                    qualityOfService = 3
//                    highResStandard = true
                    //append highresstd to array
                    ehaP2_dualSamples.append(contentsOf: cdFadedDitheredSamples)
                    ehaP2_monoSamples.append(contentsOf: cdFadedDitheredMonoSamples)
                    sampleArraySet = true
                    print("ehaP2_dualSamples: \(ehaP2_dualSamples)")
                    print("ehaP2_monoSamples: \(ehaP2_monoSamples)")
                    ehaP2showTestCompletionSheet = true
                    audioSessionModel.cancelAudioSession()
                } else if gainEHAP2PhonIsSet == true {
                    print("Gain Already Set")
                } else {
                    print("!!!Fatal Error in gainehaP2PhonIsSet OnAppear Functions")
                }
            }
        }
        .onChange(of: ehaP2testIsPlaying, perform: { ehaP2testBoolValue in
            if ehaP2testBoolValue == true && ehaP2endTestSeriesValue == false {
                //User is starting test for first time
                audioSessionModel.setAudioSession()
                ehaP2localPlaying = 1
                ehaP2playingStringColorIndex = 0
                ehaP2userPausedTest = false
            } else if ehaP2testBoolValue == false && ehaP2endTestSeriesValue == false {
                // User is pausing test for firts time
                ehaP2stop()
                ehaP2localPlaying = 0
                ehaP2playingStringColorIndex = 1
                ehaP2userPausedTest = true
            } else if ehaP2testBoolValue == true && ehaP2endTestSeriesValue == true {
                ehaP2stop()
                ehaP2localPlaying = -1
                ehaP2playingStringColorIndex = 2
                ehaP2userPausedTest = true
            } else {
                print("Critical error in pause logic")
            }
        })
        // This is the lowest CPU approach from many, many tries
        .onChange(of: ehaP2localPlaying, perform: { ehaP2playingValue in
            ehaP2activeFrequency = ehaP2_samples[ehaP2_index]
            ehaP2localPan = ehaP2localPanHoldingArray[ehaP2_index]
            ehaP2_pan = ehaP2localPanHoldingArray[ehaP2_index]
            //               ehaP2localPan = ehaP2panArray[ehaP2_index]
            //               ehaP2_pan = ehaP2panArray[ehaP2_index]
            ehaP2localHeard = 0
            ehaP2localReversal = 0
            ehaP2TestStarted = true
            if ehaP2playingValue == 1{
                print("LocalTestCount: \(ehaP2localTestCount)")
                print("ActiveFrequency: \(ehaP2activeFrequency)")
                print("Gain: \(ehaP2_testGain)")
                print("Pan: \(ehaP2localPan)")
                
                if qualityOfService == 1 {
                    print("QOS Thread Background")
                    ehaP2ThreadBackground.async {
                        ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                        while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                        if ehaP2localHeard == 1 {
                            ehaP2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                        } else {
                            ehaP2testPlayer!.stop()
                            self.ehaP2localHeard = -1
                            print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                        }
                    }
                } else if qualityOfService == 2 {
                    print("QOS Thread Default")
                    ehaP2ThreadDefault.async {
                        ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                        while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                        if ehaP2localHeard == 1 {
                            ehaP2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                        } else {
                            ehaP2testPlayer!.stop()
                            self.ehaP2localHeard = -1
                            print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                        }
                    }
                } else if qualityOfService == 3 {
                    print("QOS Thread UserInteractive")
                    ehaP2ThreadUserInteractive.async {
                        ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                        while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                        if ehaP2localHeard == 1 {
                            ehaP2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                        } else {
                            ehaP2testPlayer!.stop()
                            self.ehaP2localHeard = -1
                            print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                        }
                    }
                } else if qualityOfService == 4 {
                    print("QOS Thread UserInitiated")
                    ehaP2ThreadUserInitiated.async {
                        ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                        while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                        if ehaP2localHeard == 1 {
                            ehaP2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                        } else {
                            ehaP2testPlayer!.stop()
                            self.ehaP2localHeard = -1
                            print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                        }
                    }
                } else {
                    print("QOS Thread Not Set, Catch Setting of Default")
                    ehaP2audioThread.async {
                        ehaP2loadAndTestPresentation(sample: ehaP2activeFrequency, gain: ehaP2_testGain, pan: ehaP2localPan)
                        while ehaP2testPlayer!.isPlaying == true && self.ehaP2localHeard == 0 { }
                        if ehaP2localHeard == 1 {
                            ehaP2testPlayer!.stop()
                            print("Stopped in while if: Returned Array \(ehaP2localHeard)")
                        } else {
                            ehaP2testPlayer!.stop()
                            self.ehaP2localHeard = -1
                            print("Stopped naturally: Returned Array \(ehaP2localHeard)")
                        }
                    }
                }
                
                
                ehaP2preEventThread.async {
                    ehaP2preEventLogging()
                }
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                    if self.ehaP2localHeard == 1 {
                        ehaP2localTestCount += 1
                        ehaP2fullTestCompleted = ehaP2fullTestCompletedHoldingArray[ehaP2_index]
                        Task(priority: .userInitiated) {
                            await ehaP2responseHeardArray()      //ehaP2_heardArray.append(1)
                            await ehaP2localResponseTracking()
                            await ehaP2count()
                            await ehaP2logNotPlaying()           //ehaP2_playing = -1
                            await ehaP2resetPlaying()
                            await ehaP2resetHeard()
                            await ehaP2resetNonResponseCount()
                            await ehaP2createReversalHeardArray()
                            await ehaP2createReversalGainArray()
                            await ehaP2checkHeardReversalArrays()
                            await ehaP2reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change event
                        }
                    }
                    else if ehaP2_heardArray.last == nil || self.ehaP2localHeard == -1 {
                        ehaP2localTestCount += 1
                        ehaP2fullTestCompleted = ehaP2fullTestCompletedHoldingArray[ehaP2_index]
                        Task(priority: .userInitiated) {
                            await ehaP2heardArrayNormalize()
                            await maxEHAP2GainReachedReversal()
                            await ehaP2count()
                            await ehaP2logNotPlaying()   //self.ehaP2_playing = -1
                            await ehaP2resetPlaying()
                            await ehaP2resetHeard()
                            await ehaP2nonResponseCounting()
                            await ehaP2createReversalHeardArray()
                            await ehaP2createReversalGainArrayNonResponse()
                            await ehaP2checkHeardReversalArrays()
                            await ehaP2reversalStart()  // Send Signal for Reversals here....then at end of reversals, send playing value = 1 to retrigger change    event
                        }
                    } else {
                        ehaP2localTestCount = 1
                        ehaP2fullTestCompleted = ehaP2fullTestCompletedHoldingArray[ehaP2_index]
                        Task(priority: .background) {
                            await ehaP2resetPlaying()
                            print("Fatal Error: Stopped in Task else")
                            print("heardArray: \(ehaP2_heardArray)")
                        }
                    }
                }
            }
        })
        .onChange(of: ehaP2localReversal) { ehaP2reversalValue in
            if ehaP2reversalValue == 1 {
                DispatchQueue.global(qos: .background).async {
                    Task(priority: .userInitiated) {
                        if ehaP2MonoTest == false {
                            await ehaP2reversalDirection()
                            await ehaP2reversalComplexAction()
                            await ehaP2reversalsCompleteLogging()
                            await ehaP2AssignLRAverageSampleGains()
                            await ehaP2concatenateFinalArrays()
                            await ehaP2saveFinalStoredArrays()
                            await ehaP2endTestSeriesFunc()
                            await ehaP2newTestCycle()
                            print("End of Reversals")
                            print("Prepare to Start Next Presentation")
                            await ehaP2restartPresentation()
                        } else if ehaP2MonoTest == true {
                            await ehaP2reversalDirection()
                            await ehaP2reversalComplexAction()
                            await ehaP2reversalsCompleteLogging()
                            await ehaP2AssignMonoAverageSampleGains()
                            await ehaP2concatenateFinalArrays()
                            await ehaP2saveFinalStoredArrays()
                            await ehaP2endTestSeriesFunc()
                            await ehaP2newTestCycle()
                            print("End of Reversals")
                            print("Prepare to Start Next Presentation")
                            await ehaP2restartPresentation()
                        } else {
                            print("!!!Fatal error in ehaP2ReversalValue ehaP2MonoTest Logic")
                        }
                    }
                }
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            print("!!@@@uploadValue: \(uploadValue)")
            if uploadValue == true {
                Task{
                    print("!!!@@@@Starting Upload Results")
                    await uploadEHAP2Results()
                }
            } else {
                print("Fatal Error in uploadValue Change of Logic")
            }
        }
    }
}
 
extension EHATTSTestPart2Content {
//MARK: - AudioPlayer Methods
   
   func ehaP2pauseRestartTestCycle() {
       ehaP2localMarkNewTestCycle = 0
       ehaP2localReversalEnd = 0
       ehaP2_index = ehaP2_index
       ehaP2_testGain = gainEHAP2SettingArray[ehaP2_index]       // Add code to reset starting test gain by linking to table of expected HL
       ehaP2testIsPlaying = false
       ehaP2localPlaying = 0
       ehaP2_testCount.removeAll()
       ehaP2_reversalHeard.removeAll()
       ehaP2_averageGain = Float()
       ehaP2_reversalDirection = Float()
       ehaP2localStartingNonHeardArraySet = false
       ehaP2firstHeardResponseIndex = Int()
       ehaP2firstHeardIsTrue = false
       ehaP2secondHeardResponseIndex = Int()
       ehaP2secondHeardIsTrue = false
       ehaP2localTestCount = 0
       ehaP2localReversalHeardLast = Int()
       ehaP2startTooHigh = 0
       
//Added
       ehaP2_averageGainDB = Float()
       Task(priority: .userInitiated) {
           ehaP2_StartingDB = gainEHAP2SettingArray[ehaP2_index]
           ehaP2_CurrentDB = ehaP2_StartingDB
           ehaP2_NewTargetDB = ehaP2_StartingDB
           ehaP2_AirPodsProGen2MaxDB = ehaP2_AirPodsProGen2MaxDBArray[ehaP2_index]
           await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)
       }

               
//Added Above
   }
    
    func ehaP2combinedPauseRestartAndStartNexTestCycle() async {
        ehaP2_testCount.removeAll()
        ehaP2_reversalHeard.removeAll()
        ehaP2_heardArray.removeAll()
        ehaP2_averageGain = Float()
        ehaP2_reversalDirection = Float()
        ehaP2firstHeardResponseIndex = Int()
        ehaP2secondHeardResponseIndex = Int()
        ehaP2localReversalHeardLast = Int()
        ehaP2localSeriesNoResponses = Int()
        ehaP2localStartingNonHeardArraySet = false
        ehaP2firstHeardIsTrue = false
        ehaP2secondHeardIsTrue = false
        ehaP2endTestSeriesValue = false
        ehaP2playingStringColorIndex = 0
        ehaP2startTooHigh = 0
        ehaP2localTestCount = 0
        ehaP2localMarkNewTestCycle = 0
        ehaP2localReversalEnd = 0
        ehaP2_index = ehaP2_index + 1
//        print(ehaP2_eptaSamplesCountArray[ehaP2_index]) /// This is causing the issue
//        print("ehaP2_index: \(ehaP2_index)")
//        ehaP2_testGain = gainEHAP2SettingArray[ehaP2_index]
        ehaP2userPausedTest = false
        ehaP2testIsPlaying = true
        ehaP2localPlaying = 1
//        ehaP2showTestCompletionSheet = false
        ehaP2showTestCompletionSheet.toggle()
        //
        //
        ehaP2_StartingDB = gainEHAP2SettingArray[ehaP2_index]
        ehaP2_CurrentDB = ehaP2_StartingDB
        ehaP2_NewTargetDB = ehaP2_StartingDB
        ehaP2_AirPodsProGen2MaxDB = ehaP2_AirPodsProGen2MaxDBArray[ehaP2_index]
        await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)
        //
        //
    }
    
    func ehaP2setDualMonoVariables() {
        if ehaP2MonoTest == false && ehaP2VariableArraysSet == false {
            ehaP2localPanHoldingArray = ehaP2panArray
            ehaP2fullTestCompletedHoldingArray = ehaP2fullTestCompletedLR
            ehaP2totalCount = ehaP2DualTotalCount
            ehaP2_samples = ehaP2_dualSamples
            ehaP2VariableArraysSet = true
            print("ehaP2localPanHoldingArray: \(ehaP2localPanHoldingArray)")
            print("ehaP2totalCount: \(ehaP2totalCount)")
            print("ehaP2_samples: \(ehaP2_samples)")
            print("localPanArray: \(ehaP2localPan)")
        } else if ehaP2MonoTest == true && ehaP2VariableArraysSet == false {
            //use mono toggle functions
            print("Mono test triggered")
            ehaP2VariableArraysSet = true
            print("ehaP2localPanHoldingArray: \(ehaP2localPanHoldingArray)")
            print("ehaP2totalCount: \(ehaP2totalCount)")
            print("ehaP2_samples: \(ehaP2_samples)")
        } else {
            print("!!!Critical Error in ehaP2setDualMonoVariables() ")
//            ehaP2localPanHoldingArray = ehaP2panArray
//            ehaP2totalCount = ehaP2DualTotalCount
//            ehaP2_samples = ehaP2_dualSamples
//            ehaP2VariableArraysSet = true
        }
    }
    
    func ehaP2setPan() {
        ehaP2localPan = ehaP2localPanHoldingArray[ehaP2_index]
//        ehaP2localPan = ehaP2panArray[ehaP2_index]
//        print("Pan: \(ehaP2localPan)")
//        print("Pan Index \(ehaP2_index)")
    }
     
    func ehaP2loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
         do{
             let ehaP2urlSample = Bundle.main.path(forResource: ehaP2activeFrequency, ofType: ".wav")
             guard let ehaP2urlSample = ehaP2urlSample else { return print(ehaP2SampleErrors.ehaP2notFound) }
             ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
             guard let ehaP2testPlayer = ehaP2testPlayer else { return }
             ehaP2testPlayer.prepareToPlay()    // Test Player Prepare to Play
             ehaP2testPlayer.setVolume(ehaP2_testGain, fadeDuration: 0)      // Set Gain for Playback
             ehaP2testPlayer.pan = ehaP2localPan
             ehaP2testPlayer.play()   // Start Playback
         } catch { print("Error in playerSessionSetUp Function Execution") }
 }
   
   func ehaP2stop() {
     do{
         let ehaP2urlSample = Bundle.main.path(forResource: ehaP2activeFrequency, ofType: ".wav")
         guard let ehaP2urlSample = ehaP2urlSample else { return print(ehaP2SampleErrors.ehaP2notFound) }
         ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
         guard let ehaP2testPlayer = ehaP2testPlayer else { return }
         ehaP2testPlayer.stop()
     } catch { print("Error in Player Stop Function") }
 }
   
   func playTesting() async {
       do{
           let ehaP2urlSample = Bundle.main.path(forResource: ehaP2activeFrequency, ofType: ".wav")
           guard let ehaP2urlSample = ehaP2urlSample else {
               return print(ehaP2SampleErrors.ehaP2notFound) }
           ehaP2testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ehaP2urlSample))
           guard let ehaP2testPlayer = ehaP2testPlayer else { return }
           while ehaP2testPlayer.isPlaying == true {
               if ehaP2_heardArray.count > 1 && ehaP2_heardArray.index(after: ehaP2_indexForTest.count-1) == 1 {
                   ehaP2testPlayer.stop()
               print("Stopped in While") }
           }
           ehaP2testPlayer.stop()
           print("Naturally Stopped")
       } catch { print("Error in playTesting") }
   }
   
   func ehaP2resetNonResponseCount() async {ehaP2localSeriesNoResponses = 0 }
   
   func ehaP2nonResponseCounting() async {ehaP2localSeriesNoResponses += 1 }
    
   func ehaP2resetPlaying() async { self.ehaP2localPlaying = 0 }
   
   func ehaP2logNotPlaying() async { self.ehaP2localPlaying = -1 }
   
   func ehaP2resetHeard() async { self.ehaP2localHeard = 0 }
   
   func ehaP2reversalStart() async { self.ehaP2localReversal = 1}
 
    func ehaP2preEventLogging() {
       DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
           ehaP2_indexForTest.append(ehaP2_index)
       }
       DispatchQueue.global(qos: .default).async {
           ehaP2_testTestGain.append(ehaP2_testGain)
           ehaP2_testTestGainDB.append(ehaP2_testGainDB)
       }
       DispatchQueue.global(qos: .background).async {
           ehaP2_frequency.append(ehaP2activeFrequency)
           ehaP2_testPan.append(ehaP2_pan)         // 0 = Left , 1 = Middle, 2 = Right
       }
    }
   
 
//MARK: -HeardArray Methods
   
    func ehaP2responseHeardArray() async {
        ehaP2_heardArray.append(1)
        self.ehaP2idxHA = ehaP2_heardArray.count
        self.ehaP2localStartingNonHeardArraySet = true
    }

    func ehaP2localResponseTracking() async {
        if ehaP2firstHeardIsTrue == false {
            ehaP2firstHeardResponseIndex = ehaP2localTestCount
            ehaP2firstHeardIsTrue = true
        } else if ehaP2firstHeardIsTrue == true {
            ehaP2secondHeardResponseIndex = ehaP2localTestCount
            ehaP2secondHeardIsTrue = true
//            print("Second Heard Is True Logged!")
        } else {
            print("Error in localResponseTrackingLogic")
        }
    }
    
    func maxEHAP2GainReachedReversal() async {
        if ehaP2_testGain >= 0.995 && ehaP2firstHeardIsTrue == false && ehaP2secondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            ehaP2_testTestGain.removeLast(1)
            //responseHeardArray
            ehaP2firstHeardResponseIndex = ehaP2localTestCount
            ehaP2firstHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            ehaP2_testTestGain.append(1.0)
            // Local Response Tracking
            ehaP2_heardArray.append(1)
            self.ehaP2idxHA = ehaP2_heardArray.count
            self.ehaP2localStartingNonHeardArraySet = true
            await ehaP2resetNonResponseCount()
            
            
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
        } else if ehaP2_testGain >= 0.995 && ehaP2firstHeardIsTrue == true && ehaP2secondHeardIsTrue == false {
            //remove last gain value from preeventlogging
            ehaP2_testTestGain.removeLast(1)
            //responseHeardArray
            ehaP2secondHeardResponseIndex = ehaP2localTestCount
            ehaP2secondHeardIsTrue = true
            //Append a gain value of 1.0, indicating sound not heard a max volume
            ehaP2_testTestGain.append(1.0)
            // Local Response Tracking
            ehaP2_heardArray.append(1)
            self.ehaP2idxHA = ehaP2_heardArray.count
            self.ehaP2localStartingNonHeardArraySet = true
            await ehaP2resetNonResponseCount()
            
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

    func ehaP2heardArrayNormalize() async {
        if ehaP2_testGain < 0.995 {
            ehaP2idxHA = ehaP2_heardArray.count
            ehaP2idxForTest = ehaP2_indexForTest.count
            ehaP2idxForTestNet1 = ehaP2idxForTest - 1
            ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
            ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)
            if ehaP2localStartingNonHeardArraySet == false {
                ehaP2_heardArray.append(0)
                self.ehaP2localStartingNonHeardArraySet = true
                ehaP2idxHA = ehaP2_heardArray.count
                ehaP2idxHAZero = ehaP2idxHA - ehaP2idxHA
                ehaP2idxHAFirst = ehaP2idxHAZero + 1
                ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
                ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)
            } else if ehaP2localStartingNonHeardArraySet == true {
                if ehaP2isCountSame != 0 && ehaP2heardArrayIdxAfnet1 != 1 {
                    ehaP2_heardArray.append(0)
                    ehaP2idxHA = ehaP2_heardArray.count
                    ehaP2idxHAZero = ehaP2idxHA - ehaP2idxHA
                    ehaP2idxHAFirst = ehaP2idxHAZero + 1
                    ehaP2isCountSame = ehaP2idxHA - ehaP2idxForTest
                    ehaP2heardArrayIdxAfnet1 = ehaP2_heardArray.index(after: ehaP2idxForTestNet1)
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
    func ehaP2count() async {
        ehaP2idxTestCountUpdated = ehaP2_testCount.count + 1
        ehaP2_testCount.append(ehaP2idxTestCountUpdated)
    }
}

extension EHATTSTestPart2Content {
    //MARK: -Reversal Methods Extension
    enum ehaP2LastErrors: Error {
        case ehaP2lastError
        case ehaP2lastUnexpected(code: Int)
    }
    
    
    
    
    
    
    
    
    
    func dBNewTargetDB() async {
        ehaP2_NewTargetDB = ehaP2_CurrentDB + ehaP2_StepSizeDB
    }
    
    func dBToGain(ehaP2_NewTargetDB: Float) async {
        ehaP2_testGain = powf(10.0, ((ehaP2_NewTargetDB - ehaP2_AirPodsProGen2MaxDB)/20))
        ehaP2_testGainDB = ehaP2_NewTargetDB
    }
    
    
    
    
    
    
    
    
    
    
    
    func ehaP2createReversalHeardArray() async {
        ehaP2_reversalHeard.append(ehaP2_heardArray[ehaP2idxHA-1])
        self.ehaP2idxReversalHeardCount = ehaP2_reversalHeard.count
    }
    
    func ehaP2createReversalHeardArrayNonResponse() async {
        ehaP2_reversalHeard.append(ehaP2_heardArray[ehaP2idxHA-1])
        self.ehaP2idxReversalHeardCount = ehaP2_reversalHeard.count
    }
    
    func ehaP2createReversalGainArray() async {
        ehaP2_reversalGain.append(ehaP2_testGain)
        //        ehaP2_reversalGain.append(ehaP2_testTestGain[ehaP2idxHA-1])
        ehaP2_reversalGainDB.append(ehaP2_testGainDB)
    }
    
    func ehaP2createReversalGainArrayNonResponse() async {
        if ehaP2_testGain < 0.995 {
            ehaP2_reversalGain.append(ehaP2_testGain)
            //        ehaP2_reversalGain.append(ehaP2_testTestGain[ehaP2idxHA-1])
            ehaP2_reversalGainDB.append(ehaP2_testGainDB)
        } else if ehaP2_testGain >= 0.995 {
            ehaP2_reversalGain.append(1.0)
            ehaP2_reversalGainDB.append(200.0)
        }
    }
    
    func ehaP2checkHeardReversalArrays() async {
        if ehaP2idxHA - ehaP2idxReversalHeardCount == 0 {
            print("Success, Arrays match")
        } else if ehaP2idxHA - ehaP2idxReversalHeardCount < 0 && ehaP2idxHA - ehaP2idxReversalHeardCount > 0{
            print("Fatal Error in HeardArrayCount - ReversalHeardArrayCount")
        } else {
            print("hit else in check reversal arrays")
        }
    }
    
    func ehaP2reversalDirection() async {
        ehaP2localReversalHeardLast = ehaP2_reversalHeard.last ?? -999
        if ehaP2localReversalHeardLast == 1 {
            ehaP2_reversalDirection = -1.0
            ehaP2_reversalDirectionArray.append(-1.0)
        } else if ehaP2localReversalHeardLast == 0 {
            ehaP2_reversalDirection = 1.0
            ehaP2_reversalDirectionArray.append(1.0)
        } else {
            print("Error in Reversal Direction reversalHeardArray Count")
        }
    }
       
    
    func ehaP2reversalOfOne() async {
        ehaP2_StepSizeDB = 1.0
        let rO1Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO1Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 { //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfTwo() async {
        ehaP2_StepSizeDB = 2.0
        let rO2Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO2Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfThree() async {
        ehaP2_StepSizeDB = 3.0
        let rO3Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO3Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfFour() async {
        ehaP2_StepSizeDB = 4.0
        let rO4Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO4Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfFive() async {
        ehaP2_StepSizeDB = 5.0
        let rO5Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO5Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfEight() async {
        ehaP2_StepSizeDB = 8.0
        let rO5Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + rO5Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //} 0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfTen() async {
        ehaP2_StepSizeDB = 10.0
        let r10Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + r10Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0  //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    
    func ehaP2reversalOfTwelve() async {
        ehaP2_StepSizeDB = 12.0
        let r10Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + r10Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    //0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    func ehaP2reversalOfFifteen() async {
        ehaP2_StepSizeDB = 15.0
        let r10Direction = ehaP2_StepSizeDB * ehaP2_reversalDirection
        ehaP2_NewTargetDB = ehaP2_CurrentDB + r10Direction
        if ehaP2_NewTargetDB > 0.00001 && ehaP2_NewTargetDB < ehaP2_AirPodsProGen2MaxDB-0.1 {
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)  //This sets ehaP2_testGain
            ehaP2_testGainDB = ehaP2_NewTargetDB
            ehaP2_CurrentDB = ehaP2_NewTargetDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
        } else if ehaP2_NewTargetDB <= 3.0 {    // 0.0 {
            await dBToGain(ehaP2_NewTargetDB: 3.0)  //This sets ehaP2_testGain
            ehaP2_testGainDB = 3.0
            ehaP2_CurrentDB = 3.0
            ehaP2_NewTargetDB = 3.0
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal Zero Gain Catch")
        } else if ehaP2_NewTargetDB >= ehaP2_AirPodsProGen2MaxDB {
            ehaP2_testGain = 1.0
            ehaP2_testGainDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_CurrentDB = ehaP2_AirPodsProGen2MaxDB
            ehaP2_NewTargetDB = ehaP2_AirPodsProGen2MaxDB
            print("ehaP2_testGainDB \(ehaP2_testGainDB)")
            print("testGain: \(ehaP2_testGain)")
            print("ehaP2_NewTargetDB \(ehaP2_NewTargetDB)")
            print("!!!Fatal 1.0 Gain Catch")
        } else {
            print("!!!Fatal Error in reversalOfOne Logic")
        }
    }
    
    
    
    func ehaP2reversalAction() async {
        if ehaP2localReversalHeardLast == 1 {
            await ehaP2reversalOfFive()
        } else if ehaP2localReversalHeardLast == 0 {
            await ehaP2reversalOfTwo()
        } else {
            print("!!!Critical error in Reversal Action")
        }
    }
    
    func ehaP2reversalComplexAction() async {
        if ehaP2idxReversalHeardCount <= 1 && ehaP2idxHA <= 1 {
            await ehaP2reversalAction()
        }  else if ehaP2idxReversalHeardCount == 2 {
            if ehaP2idxReversalHeardCount == 2 && ehaP2secondHeardIsTrue == true {
                await ehaP2startTooHighCheck()
            } else if ehaP2idxReversalHeardCount == 2  && ehaP2secondHeardIsTrue == false && ehaP2localSeriesNoResponses < 2 {
                await ehaP2reversalAction()
            } else if ehaP2idxReversalHeardCount == 2  && ehaP2secondHeardIsTrue == false && ehaP2localSeriesNoResponses == 2 {
                await ehaP2reversalOfFour()
            } else {
                print("In reversal section == 2")
                print("Failed reversal section startTooHigh")
                print("!!Fatal Error in reversalHeard and Heard Array Counts")
            }
        } else if ehaP2idxReversalHeardCount >= 3 {
            if ehaP2secondHeardResponseIndex - ehaP2firstHeardResponseIndex == 1 {
            } else if ehaP2localSeriesNoResponses >= 3 {
//                await ehaP2reversalOfTen()
                await ehaP2reversalOfEight()
            } else if ehaP2localSeriesNoResponses == 2 {
                await ehaP2reversalOfFour()
            } else {
                await ehaP2reversalAction()
            }
        } else {
            print("Fatal Error in complex reversal logic for if idxRHC >=3, hit else segment")
        }
    }
    
    func ehaP2reversalHeardCount1() async {
        await ehaP2reversalAction()
    }
    
    func ehaP2check2PositiveSeriesReversals() async {
        if ehaP2_reversalHeard[ehaP2idxHA-2] == 1 && ehaP2_reversalHeard[ehaP2idxHA-1] == 1 {
        }
    }
    
    func ehaP2checkTwoNegativeSeriesReversals() async {
        if ehaP2_reversalHeard.count >= 3 && ehaP2_reversalHeard[ehaP2idxHA-2] == 0 && ehaP2_reversalHeard[ehaP2idxHA-1] == 0 {
            await ehaP2reversalOfFour()
        } else {
            await ehaP2reversalAction()
        }
    }
    
    func ehaP2startTooHighCheck() async {
        if ehaP2startTooHigh == 0 && ehaP2firstHeardIsTrue == true && ehaP2secondHeardIsTrue == true {
            ehaP2startTooHigh = 1
            await ehaP2reversalOfTwelve()
            await ehaP2resetAfterTooHigh()
            print("Too High Found")
        } else {
            await ehaP2reversalAction()
        }
    }
    
    func ehaP2resetAfterTooHigh() async {
        ehaP2firstHeardResponseIndex = Int()
        ehaP2firstHeardIsTrue = false
        ehaP2secondHeardResponseIndex = Int()
        ehaP2secondHeardIsTrue = false
    }
    
//    func ehaP2reversalsCompleteLogging() async {
////        print("in reversalcompletelogging")
//        if ehaP2secondHeardIsTrue == true {
////            print("in reversal complete logging first if")
//            self.ehaP2localReversalEnd = 1
//            self.ehaP2localMarkNewTestCycle = 1
//            self.ehaP2firstGain = ehaP2_reversalGain[ehaP2firstHeardResponseIndex-1]
//            self.ehaP2secondGain = ehaP2_reversalGain[ehaP2secondHeardResponseIndex-1]
//            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
//            print("ehaP2_reversalGain: \(ehaP2_reversalGain)")
//            print("ehaP2firstHeardResponseIndex: \(ehaP2firstHeardResponseIndex)")
//            print("ehaP2secondHeardResponseIndex: \(ehaP2secondHeardResponseIndex)")
//            print("ehaP2firstGain: \(ehaP2firstGain)")
//            print("ehaP2secondGain: \(ehaP2secondGain)")
//            let ehaP2delta = ehaP2firstGain - ehaP2secondGain
//            let ehaP2avg = (ehaP2firstGain + ehaP2secondGain)/2
//            if ehaP2delta == 0 {
////                print("in second if")
//                ehaP2_averageGain = ehaP2secondGain
//                print("average Gain: \(ehaP2_averageGain)")
//            } else if ehaP2delta >= 0.04 {
////                print("in first else if")
//                ehaP2_averageGain = ehaP2secondGain
////                print("FirstGain: \(ehaP2firstGain)")
////                print("SecondGain: \(ehaP2secondGain)")
////                print("average Gain: \(ehaP2_averageGain)")
//            } else if ehaP2delta <= -0.04 {
////                print("in second else if")
//                ehaP2_averageGain = ehaP2firstGain
////                print("FirstGain: \(ehaP2firstGain)")
////                print("SecondGain: \(ehaP2secondGain)")
////                print("average Gain: \(ehaP2_averageGain)")
//            } else if ehaP2delta < 0.04 && ehaP2delta > -0.04 {
////                print("in third else if")
//                ehaP2_averageGain = ehaP2avg
////                print("FirstGain: \(ehaP2firstGain)")
////                print("SecondGain: \(ehaP2secondGain)")
////                print("average Gain: \(ehaP2_averageGain)")
//            } else {
////                print("in final else of sub if")
//                ehaP2_averageGain = ehaP2avg
////                print("FirstGain: \(ehaP2firstGain)")
////                print("SecondGain: \(ehaP2secondGain)")
////                print("average Gain: \(ehaP2_averageGain)")
//            }
//        } else if ehaP2secondHeardIsTrue == false {
////            print("Contine, second hear is true = false")
//        } else {
//            print("Critical error in reversalsCompletLogging Logic")
//        }
//    }
    
    
    func ehaP2reversalsCompleteLogging() async {
        if ehaP2secondHeardIsTrue == true {
            self.ehaP2localReversalEnd = 1
            self.ehaP2localMarkNewTestCycle = 1
            self.ehaP2firstGain = ehaP2_reversalGain[ehaP2firstHeardResponseIndex-1]
            self.ehaP2secondGain = ehaP2_reversalGain[ehaP2secondHeardResponseIndex-1]
            
            ehaP2firstGainDB = ehaP2_reversalGainDB[ehaP2firstHeardResponseIndex-1]
            ehaP2secondGainDB = ehaP2_reversalGainDB[ehaP2secondHeardResponseIndex-1]
            

//            let ehaP2delta = ehaP2firstGain - ehaP2secondGain
            let ehaP2avg = (ehaP2firstGain + ehaP2secondGain)/2
            
            let eHAP2DeltatDB = ehaP2firstGainDB - ehaP2secondGainDB
            let eHAP2MagFirst20 = ehaP2firstGainDB/20.0
            let eHAP2MagFirst = powf(10.0, eHAP2MagFirst20)
            let eHAP2MagSecond20 = ehaP2secondGainDB/20.0
            let eHAP2MagSecond = powf(10.0,eHAP2MagSecond20)
            let eHAP2MagAvg = (eHAP2MagFirst + eHAP2MagSecond)/2.0
            let eHAP2AvgDB = 20.0 * log10f(eHAP2MagAvg)

            print("!!!Reversal Limit Hit, Prepare For Next Test Cycle!!!")
            print("ehaP2_reversalGain: \(ehaP2_reversalGain)")
            print("ehaP2firstHeardResponseIndex: \(ehaP2firstHeardResponseIndex)")
            print("ehaP2secondHeardResponseIndex: \(ehaP2secondHeardResponseIndex)")
            print("ehaP2firstGain: \(ehaP2firstGain)")
            print("ehaP2secondGain: \(ehaP2secondGain)")
            print("eHAP2firstGainDB: \(ehaP2firstGainDB)")
            print("eHAP2secondGainDB: \(ehaP2secondGainDB)")
            print("eHAP2MagAvg: \(eHAP2MagAvg)")
            print("eHAP2AvgDB: \(eHAP2AvgDB)")
            
            if eHAP2DeltatDB == 0 {
                ehaP2_averageGain = ehaP2secondGain
                ehaP2_averageGainDB = ehaP2secondGainDB
//                print("average Gain: \(ehaP2_averageGain)")
            } else if eHAP2DeltatDB >= 4.0 {
                ehaP2_averageGain = ehaP2secondGain
                ehaP2_averageGainDB = ehaP2secondGainDB
                
            } else if eHAP2DeltatDB <= -4.0 {
                ehaP2_averageGain = ehaP2firstGain
                ehaP2_averageGainDB = ehaP2firstGainDB
                
            } else if eHAP2DeltatDB < 4.0 && eHAP2DeltatDB > -4.0 {
                ehaP2_averageGain = ehaP2avg
                ehaP2_averageGainDB = eHAP2AvgDB
                
            } else {
                ehaP2_averageGain = ehaP2avg
                ehaP2_averageGainDB = eHAP2AvgDB
                
            }
        } else if ehaP2secondHeardIsTrue == false {
        } else {
            print("Critical error in reversalsCompletLogging Logic")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func ehaP2AssignLRAverageSampleGains() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == 1.0 { //}&& ehaP2MonoTest == false {
            //go through each assignment based on index
            if ehaP2_index == 0 {
                ehaP2RightFinalGainSample17 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample17 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample17)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample17)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 1 {
                ehaP2RightFinalGainSample19 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample19 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample19)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample19)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 2 {
                ehaP2RightFinalGainSample21 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample21 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample21)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample21)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 3 {
                ehaP2RightFinalGainSample23 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample23 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample23)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample23)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 4 {
                ehaP2RightFinalGainSample26 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample26 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample26)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample26)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 5 {
                ehaP2RightFinalGainSample28 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample28 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample28)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample28)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 6 {
                ehaP2RightFinalGainSample29 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample29 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample29)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample29)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 7 {
                ehaP2RightFinalGainSample31 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample31 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample31)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample31)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 8 {
                ehaP2RightFinalGainSample36 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample36 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample36)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample36)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
                
             
            } else if ehaP2_index == 18 {
                ehaP2RightFinalGainSample41 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample41 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample41)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample41)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 19 {
                ehaP2RightFinalGainSample42 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample42 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample42)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample42)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 20 {
                ehaP2RightFinalGainSample44 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample44 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample44)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample44)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 21 {
                ehaP2RightFinalGainSample45 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample45 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample45)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample45)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 22 {
                ehaP2RightFinalGainSample46 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample46 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample46)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample46)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 23 {
                ehaP2RightFinalGainSample49 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample49 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample49)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample49)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 24 {
                ehaP2RightFinalGainSample51 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample51 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample51)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample51)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 25 {
                ehaP2RightFinalGainSample52 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample52 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample52)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample52)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 26 {
                ehaP2RightFinalGainSample54 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample54 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample54)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample54)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
                

            } else if ehaP2_index == 36 {
                ehaP2RightFinalGainSample56 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample56 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample56)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample56)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 37 {
                ehaP2RightFinalGainSample58 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample58 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample58)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample58)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            } else if ehaP2_index == 38 {
                ehaP2RightFinalGainSample59 = ehaP2_averageGain
                ehaP2RightFinalGainDBSample59 = ehaP2_averageGainDB
                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample59)
                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample59)
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
            
            } else {
                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
                fatalError("In ehaP2Right side assignLRAverageSampleGains")
            }
        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan < 0 { //} ehaP2MonoTest == false {
            //Left Side. Go Through Each Assignment based on index for sample
            if ehaP2_index == 9 {
                ehaP2LeftFinalGainSample17 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample17 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample17)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample17)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 10 {
                ehaP2LeftFinalGainSample19 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample19 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample19)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample19)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 11 {
                ehaP2LeftFinalGainSample21 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample21 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample21)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample21)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 12 {
                ehaP2LeftFinalGainSample23 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample23 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample23)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample23)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 13 {
                ehaP2LeftFinalGainSample26 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample26 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample26)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample26)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 14 {
                ehaP2LeftFinalGainSample28 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample28 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample28)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample28)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 15 {
                ehaP2LeftFinalGainSample29 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample29 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample29)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample29)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 16 {
                ehaP2LeftFinalGainSample31 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample31 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample31)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample31)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 17 {
                ehaP2LeftFinalGainSample36 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample36 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample36)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample36)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
                
            
            } else if ehaP2_index == 27 {
                ehaP2LeftFinalGainSample41 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample41 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample41)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample41)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 28 {
                ehaP2LeftFinalGainSample42 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample42 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample42)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample42)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 29 {
                ehaP2LeftFinalGainSample44 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample44 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample44)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample44)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 30 {
                ehaP2LeftFinalGainSample45 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample45 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample45)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample45)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 31 {
                ehaP2LeftFinalGainSample46 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample46 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample46)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample46)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 32 {
                ehaP2LeftFinalGainSample49 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample49 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample49)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample49)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 33 {
                ehaP2LeftFinalGainSample51 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample51 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample51)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample51)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 34 {
                ehaP2LeftFinalGainSample52 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample52 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample52)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample52)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 35 {
                ehaP2LeftFinalGainSample54 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample54 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample54)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample54)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
                
                
            } else if ehaP2_index == 39 {
                ehaP2LeftFinalGainSample56 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample56 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample56)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample56)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 40 {
                ehaP2LeftFinalGainSample58 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample58 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample58)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample58)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
            } else if ehaP2_index == 41 {
                ehaP2LeftFinalGainSample59 = ehaP2_averageGain
                ehaP2LeftFinalGainDBSample59 = ehaP2_averageGainDB
                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample59)
                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample59)
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
                
            } else {
                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
                fatalError("In ehaP2left side assignLRAverageSampleGains")
            }
        } else {
            // No ready to log yet
            print("in bilateral gain logging Coninue, not ready to log in assignLRAverageSampleGains")
        }
    }
    
    // Single sided mono test for Left / Right / and Mono of pan = 0.0
    func ehaP2AssignMonoAverageSampleGains() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == 1.0 && ehaP2MonoTest == true {
            fatalError("mono fatal error")
        } else {
            // No ready to log yet
            print(" in mono gain logging Coninue, not ready to log in assignLRAverageSampleGains")
            fatalError("mono fatal error")
        }
    }
    
    func ehaP2restartPresentation() async {
        if ehaP2endTestSeriesValue == false {
            ehaP2localPlaying = 1
            ehaP2endTestSeriesValue = false
        } else if ehaP2endTestSeriesValue == true {
            ehaP2localPlaying = -1
            ehaP2endTestSeriesValue = true
            ehaP2showTestCompletionSheet = true
            ehaP2playingStringColorIndex = 2
        }
    }
    
    func ehaP2wipeArrays() async {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier, execute: {
            ehaP2_heardArray.removeAll()
            ehaP2_testCount.removeAll()
            ehaP2_reversalHeard.removeAll()
            ehaP2_reversalGain.removeAll()
            ehaP2_averageGain = Float()
            
            ehaP2firstGain = Float()    //Added these in, difference from ehaP2
            ehaP2secondGain = Float()   //Added these in, difference from ehaP2
            
            ehaP2_reversalDirection = Float()
            ehaP2localStartingNonHeardArraySet = false
            ehaP2firstHeardResponseIndex = Int()
            ehaP2firstHeardIsTrue = false
            ehaP2secondHeardResponseIndex = Int()
            ehaP2secondHeardIsTrue = false
            ehaP2localTestCount = 0
            ehaP2localReversalHeardLast = Int()
            ehaP2startTooHigh = 0
            ehaP2localSeriesNoResponses = Int()
            print("ehaP2_reversalGain: \(ehaP2_reversalGain)")
            
// Added Below
            ehaP2_reversalGainDB.removeAll()
            ehaP2_averageGainDB = Float()
                    
            ehaP2firstGainDB = Float()    //Added these in, difference from ehaP2
            ehaP2secondGainDB = Float()   //Added these in, difference from ehaP2
                    
            print("ehaP2_reversalGainDB: \(ehaP2_reversalGainDB)")
// Added Above
        })
    }
    
    func startNextTestCycle() async {
        await ehaP2wipeArrays()
        
        ehaP2_reversalGainDB.removeAll()
        ehaP2_averageGainDB = Float()
        ehaP2firstGain = Float()    //Added these in, difference from ehaP2
        ehaP2secondGain = Float()   //Added these in, difference from ehaP2
        ehaP2firstGainDB = Float()
        ehaP2secondGainDB = Float()
        ehaP2showTestCompletionSheet.toggle()
        ehaP2startTooHigh = 0
        ehaP2localMarkNewTestCycle = 0
        ehaP2localReversalEnd = 0
        ehaP2_index = ehaP2_index + 1
        //        envDataObjectModel_eptaSamplesCountArrayIdx += 1
//        ehaP2_testGain = gainEHAP2SettingArray[ehaP2_index]       // Add code to reset starting test gain by linking to table of expected HL
        
        //
        //
        ehaP2_StartingDB = gainEHAP2SettingArray[ehaP2_index]
        ehaP2_CurrentDB = ehaP2_StartingDB
        ehaP2_NewTargetDB = ehaP2_StartingDB
        ehaP2_AirPodsProGen2MaxDB = ehaP2_AirPodsProGen2MaxDBArray[ehaP2_index]
        await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)    // This will set _testGain
        //
        //
        
        
        
        ehaP2endTestSeriesValue = false
        ehaP2showTestCompletionSheet = false
        ehaP2testIsPlaying = true
        ehaP2userPausedTest = false
        ehaP2playingStringColorIndex = 2
        //        envDataObjectModel_eptaSamplesCount = envDataObjectModel_eptaSamplesCount + 8
//        print(ehaP2_eptaSamplesCountArray[ehaP2_index])
        ehaP2localPlaying = 1
    }
    
    func ehaP2newTestCycle() async {
        //        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index < ehaP2_eptaSamplesCount && ehaP2endTestSeriesValue == false {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index < ehaP2_eptaSamplesCountArray[ehaP2_index] && ehaP2endTestSeriesValue == false {//} && ehaP2fullTestCompletedHoldingArray[ehaP2_index] == false {
            print("New Test Cycle Triggered")
            await ehaP2wipeArrays()
            ehaP2startTooHigh = 0
            ehaP2localMarkNewTestCycle = 0
            ehaP2localReversalEnd = 0
            ehaP2_index = ehaP2_index + 1
//            ehaP2_testGain = gainEHAP2SettingArray[ehaP2_index]       // Add code to reset starting test gain by linking to table of expected HL
            
            //
            //
            ehaP2_StepSizeDB = 0.0
            ehaP2_StartingDB = gainEHAP2SettingArray[ehaP2_index]
            ehaP2_CurrentDB = ehaP2_StartingDB
            ehaP2_NewTargetDB = ehaP2_StartingDB
            ehaP2_AirPodsProGen2MaxDB = ehaP2_AirPodsProGen2MaxDBArray[ehaP2_index]
            await dBToGain(ehaP2_NewTargetDB: ehaP2_NewTargetDB)    // This will set _testGain
            //
            //
            
            ehaP2endTestSeriesValue = false
            //                Task(priority: .userInitiated) {
            
            //                }
            //        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index == ehaP2_eptaSamplesCount && ehaP2endTestSeriesValue == false {
        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2_index == ehaP2_eptaSamplesCountArray[ehaP2_index] && ehaP2endTestSeriesValue == false {
            print("=============================")
            print("!!!!! End of Test Series!!!!!!")
            print("=============================")
            ehaP2endTestSeriesValue = true
            ehaP2localPlaying = -1
            ehaP2_eptaSamplesCountArrayIdx += 1
            ehaP2fullTestCompleted = ehaP2fullTestCompletedHoldingArray[ehaP2_index+1]    // Enabling This for Testing ending test error
            if  ehaP2fullTestCompleted == true {
                ehaP2localPlaying = -1
                ehaP2stop()
                ehaP2fullTestCompleted = true
                ehaP2endTestSeriesValue = true
                ehaP2_eptaSamplesCountArrayIdx -= 1
                print("*****************************")
                print("=============================")
                print("^^^^^^End of Full Test Series^^^^^^")
                print("=============================")
                print("*****************************")
            } else if ehaP2fullTestCompleted == false {
                ehaP2fullTestCompleted = false
                ehaP2endTestSeriesValue = true
                ehaP2localPlaying = -1
                ehaP2_eptaSamplesCountArrayIdx += 1
            } else {
                print("!!!Critical error in fullTestCompleted Logic")
            }
        } else {
            print("Reversal Limit Not Hit")
        }
    }
    
    func ehaP2endTestSeriesFunc() async {
        if ehaP2endTestSeriesValue == false {
            //Do Nothing and continue
            print("end Test Series = \(ehaP2endTestSeriesValue)")
        } else if ehaP2endTestSeriesValue == true {
            ehaP2showTestCompletionSheet = true
            ehaP2_eptaSamplesCount = ehaP2_eptaSamplesCountArray[ehaP2_index]
            ehaP2fullTestCompleted = ehaP2fullTestCompletedHoldingArray[ehaP2_index]
            //            ehaP2_eptaSamplesCount = ehaP2_eptaSamplesCount + 8
            await ehaP2endTestSeriesStop()
        }
    }
    
    func ehaP2endTestSeriesStop() async {
        ehaP2localPlaying = -1
        ehaP2stop()
        ehaP2userPausedTest = true
        ehaP2playingStringColorIndex = 2
    }
    
    func ehaP2concatenateFinalArrays() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 {
            ehaP2_finalStoredIndex.append(contentsOf: [100000000] + ehaP2_indexForTest)
            ehaP2_finalStoredTestPan.append(contentsOf: [100000000] + ehaP2_testPan)
            ehaP2_finalStoredTestTestGain.append(contentsOf: [1000000.0] + ehaP2_testTestGain)
            ehaP2_finalStoredFrequency.append(contentsOf: ["100000000"] + [String(ehaP2activeFrequency)])
            ehaP2_finalStoredTestCount.append(contentsOf: [100000000] + ehaP2_testCount)
            ehaP2_finalStoredHeardArray.append(contentsOf: [100000000] + ehaP2_heardArray)
            ehaP2_finalStoredReversalHeard.append(contentsOf: [100000000] + ehaP2_reversalHeard)
            ehaP2_finalStoredFirstGain.append(contentsOf: [1000000.0] + [ehaP2firstGain])
            ehaP2_finalStoredSecondGain.append(contentsOf: [1000000.0] + [ehaP2secondGain])
            ehaP2_finalStoredAverageGain.append(contentsOf: [1000000.0] + [ehaP2_averageGain])
            ehaP2finalStoredRightFinalGainsArray.removeAll()
            ehaP2finalStoredleftFinalGainsArray.removeAll()
            ehaP2finalStoredRightFinalGainsArray.append(contentsOf: ehaP2rightFinalGainsArray)
            ehaP2finalStoredleftFinalGainsArray.append(contentsOf: ehaP2leftFinalGainsArray)
                        
//Added Below
            ehaP2_finalStoredTestTestGainDB.append(contentsOf: [1000000.0] + ehaP2_testTestGainDB)
            ehaP2_finalStoredFirstGainDB.append(contentsOf: [1000000.0] + [ehaP2firstGainDB])
            ehaP2_finalStoredSecondGainDB.append(contentsOf: [1000000.0] + [ehaP2secondGainDB])
            ehaP2_finalStoredAverageGainDB.append(contentsOf: [1000000.0] + [ehaP2_averageGainDB])
            ehaP2finalStoredRightFinalGainsDBArray.removeAll()
            ehaP2finalStoredleftFinalGainsDBArray.removeAll()
            ehaP2finalStoredRightFinalGainsDBArray.append(contentsOf: ehaP2rightFinalGainsDBArray)
            ehaP2finalStoredleftFinalGainsDBArray.append(contentsOf: ehaP2leftFinalGainsDBArray)
//Added Above
            
        }
    }
    
    func ehaP2printConcatenatedArrays() async {
        print("finalStoredIndex: \(ehaP2_finalStoredIndex)")
        print("finalStoredTestPan: \(ehaP2_finalStoredTestPan)")
        print("finalStoredTestTestGain: \(ehaP2_finalStoredTestTestGain)")
        print("finalStoredFrequency: \(ehaP2_finalStoredFrequency)")
        print("finalStoredTestCount: \(ehaP2_finalStoredTestCount)")
        print("finalStoredHeardArray: \(ehaP2_finalStoredHeardArray)")
        print("finalStoredReversalHeard: \(ehaP2_finalStoredReversalHeard)")
        print("finalStoredFirstGain: \(ehaP2_finalStoredFirstGain)")
        print("finalStoredSecondGain: \(ehaP2_finalStoredSecondGain)")
        print("finalStoredAverageGain: \(ehaP2_finalStoredAverageGain)")
        print("eha2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
        print("eha2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
        print("eha2finalStoredRightFinalGainsArray: \(ehaP2finalStoredRightFinalGainsArray)")
        print("eha2finalStoredleftFinalGainsArray: \(ehaP2finalStoredleftFinalGainsArray)")
        
        print("ehaP2_finalStoredTestTestGainDB: \(ehaP2_finalStoredTestTestGainDB)")
        print("ehaP2_finalStoredFirstGainDB: \(ehaP2_finalStoredFirstGainDB)")
        print("ehaP2_finalStoredSecondGainDB: \(ehaP2_finalStoredSecondGainDB)")
        print("ehaP2_finalStoredAverageGainDB: \(ehaP2_finalStoredAverageGainDB)")
        print("ehaP2finalStoredRightFinalGainsDBArray: \(ehaP2finalStoredRightFinalGainsDBArray)")
        print("ehaP2finalStoredleftFinalGainsDBArray: \(ehaP2finalStoredleftFinalGainsDBArray)")
    }
    
    func ehaP2saveFinalStoredArrays() async {
        if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                Task(priority: .userInitiated) {
//                    if await ehaP2endTestSeriesValue == false {
//                        await writeEHAP2DetailedResultsToCSV()
//                        await writeEHAP2InputRightResultsToCSV()
//                        await writeEHAP2InputLeftResultsToCSV()
//                        await ehaP2printConcatenatedArrays()
//                    } else if await ehaP2endTestSeriesValue == true {
                        
                        // Hold these until end of test cycle
                        await writeEHAP2DetailedResultsToCSV()
                        await writeEHAP2InputRightResultsToCSV()
                        await writeEHAP2InputLeftResultsToCSV()
                        await writeEHAP2SummarydResultsToCSV()
                        await writeEHAP2InputDetailedResultsToCSV()
                        await writeEHAP2InputDetailedResultsToCSV()
                        
                        await writeEHAP2RightLeftResultsToCSV()
                        await writeEHAP2RightResultsToCSV()
                        await writeEHAP2LeftResultsToCSV()
                        await writeEHAP2InputRightLeftResultsToCSV()
                        
                        await ehaP2getehaP2Data()
                        await ehaP2saveEHA1ToJSON()
                        await uploadEHAP2Results()
//                        await ehaP2printConcatenatedArrays()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, qos: .userInteractive) {
//                                isOkayToUpload = true
//                        }
//                    }
                }
            }
        }
    }
    
    func uploadEHAP2Results() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, qos: .background) {
            uploadFile(fileName: fileehaP2Name)
            uploadFile(fileName: summaryehaP2CSVName)
            uploadFile(fileName: detailedehaP2CSVName)
            uploadFile(fileName: inputehaP2SummaryCSVName)
            uploadFile(fileName: inputehaP2DetailedCSVName)
            uploadFile(fileName: summaryEHAP2LRCSVName)
            uploadFile(fileName: summaryEHAP2RightCSVName)
            uploadFile(fileName: summaryEHAP2LeftCSVName)
            uploadFile(fileName: inputEHAP2LRSummaryCSVName)
            uploadFile(fileName: inputEHAP2RightSummaryCSVName)
            uploadFile(fileName: inputEHAP2LeftSummaryCSVName)
            print("%%% Upload Results")
        }
    }
}

extension EHATTSTestPart2Content {
//MARK: -CSV/JSON Methods Extension
    
    func ehaP2getehaP2Data() async {
        guard let ehaP2data = await ehaP2getehaP2JSONData() else { return }
        let ehaP2jsonString = String(data: ehaP2data, encoding: .utf8)
        ehaP2jsonHoldingString = [ehaP2jsonString!]
        do {
        self.ehaP2saveFinalResults = try JSONDecoder().decode(ehaP2SaveFinalResults.self, from: ehaP2data)
        } catch let error {
            print("error decoding \(error)")
        }
    }
    
    func ehaP2getehaP2JSONData() async -> Data? {
        let ehaP2saveFinalResults = ehaP2SaveFinalResults(
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
            jsonFrequency: [ehaP2activeFrequency],
            jsonPan: ehaP2_finalStoredTestPan,
            jsonStoredIndex: ehaP2_finalStoredIndex,
            jsonStoredTestPan: ehaP2_finalStoredTestPan,
            jsonStoredTestTestGain: ehaP2_finalStoredTestTestGain,
            jsonStoredTestCount: ehaP2_finalStoredTestCount,
            jsonStoredHeardArray: ehaP2_finalStoredHeardArray,
            jsonStoredReversalHeard: ehaP2_finalStoredReversalHeard,
            jsonStoredFirstGain: ehaP2_finalStoredFirstGain,
            jsonStoredSecondGain: ehaP2_finalStoredSecondGain,
            jsonStoredAverageGain: ehaP2_finalStoredAverageGain)
        let ehaP2jsonData = try? JSONEncoder().encode(ehaP2saveFinalResults)
        return ehaP2jsonData
    }

    func ehaP2saveEHA1ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let ehaP2paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let ehaP2DocumentsDirectory = ehaP2paths[0]
        let ehaP2FilePaths = ehaP2DocumentsDirectory.appendingPathComponent(fileehaP2Name)
//        print(ehaP2FilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let ehaP2jsonData = try encoder.encode(ehaP2saveFinalResults)
            try ehaP2jsonData.write(to: ehaP2FilePaths)
        } catch {
            print("Error writing ehaP2 to JSON file: \(error)")
        }
    }

    func writeEHAP2DetailedResultsToCSV() async {
        let ehaP2stringFinalStoredIndex = "finalStoredIndex," + ehaP2_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = "finalStoredTestPan," + ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestTestGain = "finalStoredTestTestGain," + ehaP2_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFrequency = "finalStoredFrequency," + [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestCount = "finalStoredTestCount," + ehaP2_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredHeardArray = "finalStoredHeardArray," + ehaP2_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredReversalHeard = "finalStoredReversalHeard," + ehaP2_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredPan = "finalStoredPan," + ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = "finalStoredFirstGain," + ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = "finalStoredSecondGain," + ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = "finalStoredAverageGain," + ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let ehaP2stringFinalStoredTestTestGainDB = "finalStoredTestTestGainDB," + ehaP2_finalStoredTestTestGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGainDB = "finalStoredFirstGainDB," + ehaP2_finalStoredFirstGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGainDB = "finalStoredSecondGainDB," + ehaP2_finalStoredSecondGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGainDB = "finalStoredAverageGainDB," + ehaP2_finalStoredAverageGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsDBArray = "rightFinalGainsDBArray," + ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsDBArray = "leftFinalGainsDBArray," + ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsDBArray = "finalStoredRightFinalGainsDBArray," + ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsDBArray = "finalStoredleftFinalGainsDBArray," + ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
        do {
            let csvehaP2DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvehaP2DetailDocumentsDirectory = csvehaP2DetailPath
            let csvehaP2DetailFilePath = csvehaP2DetailDocumentsDirectory.appendingPathComponent(detailedehaP2CSVName)
            let writer = try CSVWriter(fileURL: csvehaP2DetailFilePath, append: false)
            try writer.write(row: [ehaP2stringFinalStoredIndex])
            try writer.write(row: [ehaP2stringFinalStoredTestPan])
            try writer.write(row: [ehaP2stringFinalStoredTestTestGain])
            try writer.write(row: [ehaP2stringFinalStoredFrequency])
            try writer.write(row: [ehaP2stringFinalStoredTestCount])
            try writer.write(row: [ehaP2stringFinalStoredHeardArray])
            try writer.write(row: [ehaP2stringFinalStoredReversalHeard])
            try writer.write(row: [ehaP2stringFinalStoredPan])
            try writer.write(row: [ehaP2stringFinalStoredFirstGain])
            try writer.write(row: [ehaP2stringFinalStoredSecondGain])
            try writer.write(row: [ehaP2stringFinalStoredAverageGain])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
            
//Added Below
            try writer.write(row: [ehaP2stringFinalStoredTestTestGainDB])
            try writer.write(row: [ehaP2stringFinalStoredFirstGainDB])
            try writer.write(row: [ehaP2stringFinalStoredSecondGainDB])
            try writer.write(row: [ehaP2stringFinalStoredAverageGainDB])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsDBArray])
//Added Above
            
        } catch {
            print("CVSWriter ehaP2 Detailed Error or Error Finding File for Detailed CSV \(error)")
        }
    }

    func writeEHAP2SummarydResultsToCSV() async {
        let ehaP2stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = "finalStoredTestPan," + ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = "finalStoredFirstGain," + ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = "finalStoredSecondGain," + ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = "finalStoredAverageGain," + ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let ehaP2stringFinalStoredFirstGainDB = "finalStoredFirstGainDB," + ehaP2_finalStoredFirstGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGainDB = "finalStoredSecondGainDB," + ehaP2_finalStoredSecondGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGainDB = "finalStoredAverageGainDB," + ehaP2_finalStoredAverageGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsDBArray = "rightFinalGainsDBArray," + ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsDBArray = "leftFinalGainsDBArray," + ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsDBArray = "finalStoredRightFinalGainsDBArray," + ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsDBArray = "finalStoredleftFinalGainsDBArray," + ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvehaP2SummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvehaP2SummaryDocumentsDirectory = csvehaP2SummaryPath
             let csvehaP2SummaryFilePath = csvehaP2SummaryDocumentsDirectory.appendingPathComponent(summaryehaP2CSVName)
             let writer = try CSVWriter(fileURL: csvehaP2SummaryFilePath, append: false)
             try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
             try writer.write(row: [ehaP2stringFinalStoredTestPan])
             try writer.write(row: [ehaP2stringFinalStoredFirstGain])
             try writer.write(row: [ehaP2stringFinalStoredSecondGain])
             try writer.write(row: [ehaP2stringFinalStoredAverageGain])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
             
             //Added Below
             try writer.write(row: [ehaP2stringFinalStoredFirstGainDB])
             try writer.write(row: [ehaP2stringFinalStoredSecondGainDB])
             try writer.write(row: [ehaP2stringFinalStoredAverageGainDB])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsDBArray])
             //Added Above
             
         } catch {
             print("CVSWriter Summary EHA Part 1 Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2InputDetailedResultsToCSV() async {
        let ehaP2stringFinalStoredIndex = ehaP2_finalStoredIndex.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestTestGain = ehaP2_finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestCount = ehaP2_finalStoredTestCount.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredHeardArray = ehaP2_finalStoredHeardArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredReversalHeard = ehaP2_finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredResultsFrequency = [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredPan = ehaP2_testPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let ehaP2stringFinalStoredTestTestGainDB = ehaP2_finalStoredTestTestGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGainDB = ehaP2_finalStoredFirstGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGainDB = ehaP2_finalStoredSecondGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGainDB = ehaP2_finalStoredAverageGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsDBArray = ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsDBArray = ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsDBArray = ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsDBArray = ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above

        do {
            let csvInputehaP2DetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputehaP2DetailDocumentsDirectory = csvInputehaP2DetailPath
            let csvInputehaP2DetailFilePath = csvInputehaP2DetailDocumentsDirectory.appendingPathComponent(inputehaP2DetailedCSVName)
            let writer = try CSVWriter(fileURL: csvInputehaP2DetailFilePath, append: false)
            try writer.write(row: [ehaP2stringFinalStoredIndex])
            try writer.write(row: [ehaP2stringFinalStoredTestPan])
            try writer.write(row: [ehaP2stringFinalStoredTestTestGain])
            try writer.write(row: [ehaP2stringFinalStoredTestCount])
            try writer.write(row: [ehaP2stringFinalStoredHeardArray])
            try writer.write(row: [ehaP2stringFinalStoredReversalHeard])
            try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
            try writer.write(row: [ehaP2stringFinalStoredPan])
            try writer.write(row: [ehaP2stringFinalStoredFirstGain])
            try writer.write(row: [ehaP2stringFinalStoredSecondGain])
            try writer.write(row: [ehaP2stringFinalStoredAverageGain])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
            
//Added Below
            try writer.write(row: [ehaP2stringFinalStoredTestTestGainDB])
            try writer.write(row: [ehaP2stringFinalStoredFirstGainDB])
            try writer.write(row: [ehaP2stringFinalStoredSecondGainDB])
            try writer.write(row: [ehaP2stringFinalStoredAverageGainDB])
            try writer.write(row: [ehaP2stringFinalrightFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalleftFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsDBArray])
            try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsDBArray])
//Added Above

        } catch {
            print("CVSWriter Input EHA Part 1 Detailed Error or Error Finding File for Input Detailed CSV \(error)")
        }
    }

    func writeEHAP2InputSummarydResultsToCSV() async {
        let ehaP2stringFinalStoredResultsFrequency = [ehaP2activeFrequency].map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredTestPan = ehaP2_finalStoredTestPan.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredFirstGain = ehaP2_finalStoredFirstGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGain = ehaP2_finalStoredSecondGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGain = ehaP2_finalStoredAverageGain.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let ehaP2stringFinalStoredFirstGainDB = ehaP2_finalStoredFirstGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredSecondGainDB = ehaP2_finalStoredSecondGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredAverageGainDB = ehaP2_finalStoredAverageGainDB.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalrightFinalGainsDBArray = ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalleftFinalGainsDBArray = ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredRightFinalGainsDBArray = ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let ehaP2stringFinalStoredleftFinalGainsDBArray = ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvehaP2InputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvehaP2InputSummaryDocumentsDirectory = csvehaP2InputSummaryPath
             let csvehaP2InputSummaryFilePath = csvehaP2InputSummaryDocumentsDirectory.appendingPathComponent(inputehaP2SummaryCSVName)
             let writer = try CSVWriter(fileURL: csvehaP2InputSummaryFilePath, append: false)
             try writer.write(row: [ehaP2stringFinalStoredResultsFrequency])
             try writer.write(row: [ehaP2stringFinalStoredTestPan])
             try writer.write(row: [ehaP2stringFinalStoredFirstGain])
             try writer.write(row: [ehaP2stringFinalStoredSecondGain])
             try writer.write(row: [ehaP2stringFinalStoredAverageGain])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsArray])
             
             //Added Below
             try writer.write(row: [ehaP2stringFinalStoredFirstGainDB])
             try writer.write(row: [ehaP2stringFinalStoredSecondGainDB])
             try writer.write(row: [ehaP2stringFinalStoredAverageGainDB])
             try writer.write(row: [ehaP2stringFinalrightFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalleftFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalStoredRightFinalGainsDBArray])
             try writer.write(row: [ehaP2stringFinalStoredleftFinalGainsDBArray])
             //Added Above
             
         } catch {
             print("CVSWriter Input EHA Part 1 Summary Data Error or Error Finding File for Input Summary CSV \(error)")
         }
    }
    
    func writeEHAP2RightLeftResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalrightFinalGainsDBArray = "rightFinalGainsDBArray," + ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsDBArray = "leftFinalGainsDBArray," + ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsDBArray = "finalStoredRightFinalGainsDBArray," + ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsDBArray = "finalStoredleftFinalGainsDBArray," + ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvEHAP2LRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2LRSummaryDocumentsDirectory = csvEHAP2LRSummaryPath
             let csvEHAP2LRSummaryFilePath = csvEHAP2LRSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2LRCSVName)
             let writer = try CSVWriter(fileURL: csvEHAP2LRSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
             
 //Added Below
             try writer.write(row: [stringFinalrightFinalGainsDBArray])
             try writer.write(row: [stringFinalleftFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsDBArray])
 //Added Above
             
         } catch {
             print("CVSWriter Summary EHA Part 2 LR Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2RightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = "rightFinalGainsArray," + ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = "finalStoredRightFinalGainsArray," + ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalrightFinalGainsDBArray = "rightFinalGainsDBArray," + ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsDBArray = "finalStoredRightFinalGainsDBArray," + ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above

        do {
             let csvEHAP2RightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2RightSummaryDocumentsDirectory = csvEHAP2RightSummaryPath
             let csvEHAP2RightSummaryFilePath = csvEHAP2RightSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2RightCSVName)
             let writer = try CSVWriter(fileURL: csvEHAP2RightSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
            
//Added Below
            try writer.write(row: [stringFinalrightFinalGainsDBArray])
            try writer.write(row: [stringFinalStoredRightFinalGainsDBArray])
//Added Above
            
         } catch {
             print("CVSWriter Summary EHA Part 2 Right Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2LeftResultsToCSV() async {
        let stringFinalleftFinalGainsArray = "leftFinalGainsArray," + ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = "finalStoredleftFinalGainsArray," + ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalleftFinalGainsDBArray = "leftFinalGainsDBArray," + ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsDBArray = "finalStoredleftFinalGainsDBArray," + ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvEHAP2LeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2LeftSummaryDocumentsDirectory = csvEHAP2LeftSummaryPath
             let csvEHAP2LeftSummaryFilePath = csvEHAP2LeftSummaryDocumentsDirectory.appendingPathComponent(summaryEHAP2LeftCSVName)
             let writer = try CSVWriter(fileURL: csvEHAP2LeftSummaryFilePath, append: false)
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
             
 //Added Below
             try writer.write(row: [stringFinalleftFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsDBArray])
//Added Above
             
         } catch {
             print("CVSWriter Summary EHA Part 2 Left Summary Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2InputRightLeftResultsToCSV() async {
        let stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalrightFinalGainsDBArray = ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalleftFinalGainsDBArray = ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsDBArray = ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsDBArray = ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvEHAP2InputLRSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputLRSummaryDocumentsDirectory = csvEHAP2InputLRSummaryPath
             let csvEHAP2InputLRSummaryFilePath = csvEHAP2InputLRSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2LRSummaryCSVName)
             print(csvEHAP2InputLRSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2InputLRSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])
             
//Added Below
             try writer.write(row: [stringFinalrightFinalGainsDBArray])
             try writer.write(row: [stringFinalleftFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsDBArray])
//Added Above

         } catch {
             print("CVSWriter Summary EHA Part 2 LR Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }


    func writeEHAP2InputRightResultsToCSV() async {
        let stringFinalrightFinalGainsArray = ehaP2rightFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsArray = ehaP2finalStoredRightFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalrightFinalGainsDBArray = ehaP2rightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredRightFinalGainsDBArray = ehaP2finalStoredRightFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvEHAP2InputRightSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputRightSummaryDocumentsDirectory = csvEHAP2InputRightSummaryPath
             let csvEHAP2InputRightSummaryFilePath = csvEHAP2InputRightSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2RightSummaryCSVName)
             let writer = try CSVWriter(fileURL: csvEHAP2InputRightSummaryFilePath, append: false)
             try writer.write(row: [stringFinalrightFinalGainsArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsArray])

//Added Below
             try writer.write(row: [stringFinalrightFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredRightFinalGainsDBArray])
//Added Above

         } catch {
             print("CVSWriter Summary EHA Part 2 Right Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }

    func writeEHAP2InputLeftResultsToCSV() async {
        let stringFinalleftFinalGainsArray = ehaP2leftFinalGainsArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsArray = ehaP2finalStoredleftFinalGainsArray.map { String($0) }.joined(separator: ",")
        
//Added Below
        let stringFinalleftFinalGainsDBArray = ehaP2leftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
        let stringFinalStoredleftFinalGainsDBArray = ehaP2finalStoredleftFinalGainsDBArray.map { String($0) }.joined(separator: ",")
//Added Above
        
         do {
             let csvEHAP2InputLeftSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
             let csvEHAP2InputLeftSummaryDocumentsDirectory = csvEHAP2InputLeftSummaryPath
             let csvEHAP2InputLeftSummaryFilePath = csvEHAP2InputLeftSummaryDocumentsDirectory.appendingPathComponent(inputEHAP2LeftSummaryCSVName)
//             print(csvEHAP2InputLeftSummaryFilePath)
             let writer = try CSVWriter(fileURL: csvEHAP2InputLeftSummaryFilePath, append: false)
             try writer.write(row: [stringFinalleftFinalGainsArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsArray])

//Added Below
             try writer.write(row: [stringFinalleftFinalGainsDBArray])
             try writer.write(row: [stringFinalStoredleftFinalGainsDBArray])
//Added Above


         } catch {
             print("CVSWriter Summary EHA Part 2 Left Input Data Error or Error Finding File for Detailed CSV \(error)")
         }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
    func comparedLastNameCSVReader() async {
        let dataSetupName = inputFinalComparedLastNameCSV
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLComparedLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLComparedLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLComparedLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputLastName = fieldLastName
            print("inputLastName: \(inputLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
    
    private func uploadFile(fileName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let storageRef = Storage.storage().reference()
            let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
            let lastNameRef = storageRef.child(inputLastName)
            let fileManager = FileManager.default
            let filePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [fileName])
            if fileManager.fileExists(atPath: filePath[0]) {
                let filePath = URL(fileURLWithPath: filePath[0])
                let localFile = filePath
                //                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
                let fileRef = lastNameRef.child("\(fileName)")
                
                let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
                    if error == nil && metadata == nil {
                        //TSave a reference to firestore database
                    }
                    return
                }
                print(uploadTask)
            } else {
                print("No File")
            }
        }
    }
}

extension EHATTSTestPart2Content {
    //MARK: Extension for Gain Link File Checking
    
    func gainEHAP2HeadphoneAssignment() async {
        ehaP2_AirPodsProGen2MaxDBArray.append(contentsOf: gainReferenceModel.maxDBEHAP2ReferenceAirPodsProGen2LR)
            
    }
    
    func gainEHAP2CurveAssignment() async {
        if ehaP2MonoTest == false {
            if gainEHAP2SettingArrayLink == 2.5 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS2_5_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 2.5: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 4 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS4_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 4: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 5 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS5_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 5: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 7 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS7_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 7: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 8 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS8_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 8: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 11 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS11_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 11: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 16 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS16_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 16: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 17 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS17_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 17: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 24 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS24_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 24: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 27 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS27_EHAP2LR)
                gainEHAP2PhonIsSet = true
                print("Phon of 27: \(gainEHAP2SettingArray)")
            } else {
                gainEHAP2PhonIsSet = false
                print("!!!! Fatal Error in gainEHAP2CurveAssignment() if segment Logic")
            }
        } else if ehaP2MonoTest == true {
            if gainEHAP2SettingArrayLink == 2.5 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS2_5_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 2.5: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 4 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS4_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 4: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 5 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS5_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 5: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 7 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS7_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 7: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 8 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS8_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 8: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 11 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS11_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 11: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 16 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS16_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 16: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 17 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS17_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 17: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 24 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS24_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 24: \(gainEHAP2SettingArray)")
            } else if gainEHAP2SettingArrayLink == 27 {
                gainEHAP2SettingArray.append(contentsOf: gainReferenceModel.ABS27_EHAP2Mono)
                gainEHAP2PhonIsSet = true
                print("Phon of 27: \(gainEHAP2SettingArray)")
            } else {
                gainEHAP2PhonIsSet = false
                print("!!!! Fatal Error in gainEHAP2CurveAssignment() if segment Logic")
            }
            
            
        } else {
            print("!!!!Fatal error in gainCurveEHAP2Assignment() Master Logic")
        }
    }
    
    
    
    func getGainEHAP2DataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
    
    func checkGainEHAP2_2_5DataLink() async {
        let dataGainEHAP2_2_5Name = ["2_5.csv"]
        let fileGainEHAP2_2_5Manager = FileManager.default
        let dataGainEHAP2_2_5Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_2_5Name)
        if fileGainEHAP2_2_5Manager.fileExists(atPath: dataGainEHAP2_2_5Path[0]) {
            let dataGainEHAP2_2_5FilePath = URL(fileURLWithPath: dataGainEHAP2_2_5Path[0])
            if dataGainEHAP2_2_5FilePath.isFileURL  {
                dataFileURLEHAP2Gain1 = dataGainEHAP2_2_5FilePath
                print("2_5.csv dataFilePath: \(dataGainEHAP2_2_5FilePath)")
                print("2_5.csv dataFileURL: \(dataFileURLEHAP2Gain1)")
                print("2_5.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 2.5
                print("gainEHAP2SettingArrayLink = 2.5 \(gainEHAP2SettingArrayLink)")
            } else {
                print("2_5.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_4DataLink() async {
        let dataGainEHAP2_4Name = ["4.csv"]
        let fileGainEHAP2_4Manager = FileManager.default
        let dataGainEHAP2_4Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_4Name)
        if fileGainEHAP2_4Manager.fileExists(atPath: dataGainEHAP2_4Path[0]) {
            let dataGainEHAP2_4FilePath = URL(fileURLWithPath: dataGainEHAP2_4Path[0])
            if dataGainEHAP2_4FilePath.isFileURL  {
                dataFileURLEHAP2Gain2 = dataGainEHAP2_4FilePath
                print("4.csv dataFilePath: \(dataGainEHAP2_4FilePath)")
                print("4.csv dataFileURL: \(dataFileURLEHAP2Gain2)")
                print("4.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 4
                print("gainEHAP2SettingArrayLink = 4 \(gainEHAP2SettingArrayLink)")
            } else {
                print("4.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_5DataLink() async {
        let dataGainEHAP2_5Name = ["5.csv"]
        let fileGainEHAP2_5Manager = FileManager.default
        let dataGainEHAP2_5Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_5Name)
        if fileGainEHAP2_5Manager.fileExists(atPath: dataGainEHAP2_5Path[0]) {
            let dataGainEHAP2_5FilePath = URL(fileURLWithPath: dataGainEHAP2_5Path[0])
            if dataGainEHAP2_5FilePath.isFileURL  {
                dataFileURLEHAP2Gain3 = dataGainEHAP2_5FilePath
                print("5.csv dataFilePath: \(dataGainEHAP2_5FilePath)")
                print("5.csv dataFileURL: \(dataFileURLEHAP2Gain3)")
                print("5.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 5
                print("gainEHAP2SettingArrayLink = 5 \(gainEHAP2SettingArrayLink)")
            } else {
                print("5.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_7DataLink() async {
        let dataGainEHAP2_7Name = ["7.csv"]
        let fileGainEHAP2_7Manager = FileManager.default
        let dataGainEHAP2_7Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_7Name)
        if fileGainEHAP2_7Manager.fileExists(atPath: dataGainEHAP2_7Path[0]) {
            let dataGainEHAP2_7FilePath = URL(fileURLWithPath: dataGainEHAP2_7Path[0])
            if dataGainEHAP2_7FilePath.isFileURL  {
                dataFileURLEHAP2Gain4 = dataGainEHAP2_7FilePath
                print("7.csv dataFilePath: \(dataGainEHAP2_7FilePath)")
                print("7.csv dataFileURL: \(dataFileURLEHAP2Gain4)")
                print("7.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 7
                print("gainEHAP2SettingArrayLink = 7 \(gainEHAP2SettingArrayLink)")
            } else {
                print("7.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_8DataLink() async {
        let dataGainEHAP2_8Name = ["8.csv"]
        let fileGainEHAP2_8Manager = FileManager.default
        let dataGainEHAP2_8Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_8Name)
        if fileGainEHAP2_8Manager.fileExists(atPath: dataGainEHAP2_8Path[0]) {
            let dataGainEHAP2_8FilePath = URL(fileURLWithPath: dataGainEHAP2_8Path[0])
            if dataGainEHAP2_8FilePath.isFileURL  {
                dataFileURLEHAP2Gain5 = dataGainEHAP2_8FilePath
                print("8.csv dataFilePath: \(dataGainEHAP2_8FilePath)")
                print("8.csv dataFileURL: \(dataFileURLEHAP2Gain5)")
                print("8.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 8
                print("gainEHAP2SettingArrayLink = 8: \(gainEHAP2SettingArrayLink)")
            } else {
                print("8.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_11DataLink() async {
        let dataGainEHAP2_11Name = ["11.csv"]
        let fileGainEHAP2_11Manager = FileManager.default
        let dataGainEHAP2_11Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_11Name)
        if fileGainEHAP2_11Manager.fileExists(atPath: dataGainEHAP2_11Path[0]) {
            let dataGainEHAP2_11FilePath = URL(fileURLWithPath: dataGainEHAP2_11Path[0])
            if dataGainEHAP2_11FilePath.isFileURL  {
                dataFileURLEHAP2Gain6 = dataGainEHAP2_11FilePath
                print("11.csv dataFilePath: \(dataGainEHAP2_11FilePath)")
                print("11.csv dataFileURL: \(dataFileURLEHAP2Gain6)")
                print("11.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 11
                print("gainEHAP2SettingArrayLink = 11 \(gainEHAP2SettingArrayLink)")
            } else {
                print("11.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_16DataLink() async {
        let dataGainEHAP2_16Name = ["16.csv"]
        let fileGainEHAP2_16Manager = FileManager.default
        let dataGainEHAP2_16Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_16Name)
        if fileGainEHAP2_16Manager.fileExists(atPath: dataGainEHAP2_16Path[0]) {
            let dataGainEHAP2_16FilePath = URL(fileURLWithPath: dataGainEHAP2_16Path[0])
            if dataGainEHAP2_16FilePath.isFileURL  {
                dataFileURLEHAP2Gain7 = dataGainEHAP2_16FilePath
                print("16.csv dataFilePath: \(dataGainEHAP2_16FilePath)")
                print("16.csv dataFileURL: \(dataFileURLEHAP2Gain7)")
                print("16.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 16
                print("gainEHAP2SettingArrayLink = 16: \(gainEHAP2SettingArrayLink)")
            } else {
                print("16.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_17DataLink() async {
        let dataGainEHAP2_17Name = ["17.csv"]
        let fileGainEHAP2_17Manager = FileManager.default
        let dataGainEHAP2_17Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_17Name)
        if fileGainEHAP2_17Manager.fileExists(atPath: dataGainEHAP2_17Path[0]) {
            let dataGainEHAP2_17FilePath = URL(fileURLWithPath: dataGainEHAP2_17Path[0])
            if dataGainEHAP2_17FilePath.isFileURL  {
                dataFileURLEHAP2Gain8 = dataGainEHAP2_17FilePath
                print("17.csv dataFilePath: \(dataGainEHAP2_17FilePath)")
                print("17.csv dataFileURL: \(dataFileURLEHAP2Gain8)")
                print("17.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 17
                print("gainEHAP2SettingArrayLink = 17: \(gainEHAP2SettingArrayLink)")
            } else {
                print("17.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_24DataLink() async {
        let dataGainEHAP2_24Name = ["24.csv"]
        let fileGainEHAP2_24Manager = FileManager.default
        let dataGainEHAP2_24Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_24Name)
        if fileGainEHAP2_24Manager.fileExists(atPath: dataGainEHAP2_24Path[0]) {
            let dataGainEHAP2_24FilePath = URL(fileURLWithPath: dataGainEHAP2_24Path[0])
            if dataGainEHAP2_24FilePath.isFileURL  {
                dataFileURLEHAP2Gain9 = dataGainEHAP2_24FilePath
                print("24.csv dataFilePath: \(dataGainEHAP2_24FilePath)")
                print("24.csv dataFileURL: \(dataFileURLEHAP2Gain9)")
                print("24.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 24
                print("gainEHAP2SettingArrayLink = 24 : \(gainEHAP2SettingArrayLink)")
            } else {
                print("24.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGainEHAP2_27DataLink() async {
        let dataGainEHAP2_27Name = ["27.csv"]
        let fileGainEHAP2_27Manager = FileManager.default
        let dataGainEHAP2_27Path = (await self.getGainEHAP2DataLinkPath() as NSString).strings(byAppendingPaths: dataGainEHAP2_27Name)
        if fileGainEHAP2_27Manager.fileExists(atPath: dataGainEHAP2_27Path[0]) {
            let dataGainEHAP2_27FilePath = URL(fileURLWithPath: dataGainEHAP2_27Path[0])
            if dataGainEHAP2_27FilePath.isFileURL  {
                dataFileURLEHAP2Gain10 = dataGainEHAP2_27FilePath
                print("27.csv dataFilePath: \(dataGainEHAP2_27FilePath)")
                print("27.csv dataFileURL: \(dataFileURLEHAP2Gain10)")
                print("27.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
                gainEHAP2SettingArrayLink = 27
                print("gainEHAP2SettingArrayLink = 27: \(gainEHAP2SettingArrayLink)")
            } else {
                print("27.csv Data File Path Does Not Exist")
            }
        }
    }
}

extension EHATTSTestPart2Content {
//MARK: -NavigationLink Extension
    private func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
}


//struct EHATTSTestPart2View_Previews: PreviewProvider {
//    static var previews: some View {
//        EHATTSTestPart2View(ehaTesting: nil, relatedLinkEHATesting: linkEHATesting)
//    }
//
//    static func linkEHATesting(ehaTesting: EHATesting) -> some View {
//        EmptyView()
//    }
//}


//func ehaP2AssignLRAverageSampleGains() async {
//    if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == 1.0 { //}&& ehaP2MonoTest == false {
//        //go through each assignment based on index
//        if ehaP2_index == 0 {
//            ehaP2RightFinalGainSample17 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample17 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample17)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample17)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 1 {
//            ehaP2RightFinalGainSample18 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample18 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample18)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample18)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 2 {
//            ehaP2RightFinalGainSample19 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample19 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample19)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample19)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 3 {
//            ehaP2RightFinalGainSample20 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample20 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample20)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample20)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 4 {
//            ehaP2RightFinalGainSample21 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample21 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample21)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample21)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 5 {
//            ehaP2RightFinalGainSample22 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample22 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample22)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample22)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 6 {
//            ehaP2RightFinalGainSample23 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample23 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample23)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample23)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 7 {
//            ehaP2RightFinalGainSample24 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample24 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample24)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample24)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 8 {
//            ehaP2RightFinalGainSample25 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample25 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample25)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample25)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//
//        } else if ehaP2_index == 18 {
//            ehaP2RightFinalGainSample26 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample26 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample26)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample26)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 19 {
//            ehaP2RightFinalGainSample27 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample27 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample27)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample27)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 20 {
//            ehaP2RightFinalGainSample28 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample28 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample28)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample28)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 21 {
//            ehaP2RightFinalGainSample29 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample29 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample29)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample29)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 22 {
//            ehaP2RightFinalGainSample30 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample30 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample30)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample30)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 23 {
//            ehaP2RightFinalGainSample31 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample31 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample31)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample31)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 24 {
//            ehaP2RightFinalGainSample32 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample32 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample32)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample32)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 25 {
//            ehaP2RightFinalGainSample33 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample33 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample33)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample33)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 26 {
//            ehaP2RightFinalGainSample34 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample34 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample34)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample34)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//
//        } else if ehaP2_index == 36 {
//            ehaP2RightFinalGainSample35 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample35 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample35)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample35)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 37 {
//            ehaP2RightFinalGainSample36 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample36 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample36)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample36)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 38 {
//            ehaP2RightFinalGainSample37 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample37 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample37)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample37)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 39 {
//            ehaP2RightFinalGainSample38 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample38 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample38)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample38)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 40 {
//            ehaP2RightFinalGainSample39 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample39 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample39)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample39)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 41 {
//            ehaP2RightFinalGainSample40 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample40 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample40)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample40)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 42 {
//            ehaP2RightFinalGainSample41 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample41 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample41)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample41)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 43 {
//            ehaP2RightFinalGainSample42 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample42 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample42)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample42)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 44 {
//            ehaP2RightFinalGainSample43 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample43 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample43)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample43)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//
//        } else if ehaP2_index == 54 {
//            ehaP2RightFinalGainSample44 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample44 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample44)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample44)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 55 {
//            ehaP2RightFinalGainSample45 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample45 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample45)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample45)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 56 {
//            ehaP2RightFinalGainSample46 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample46 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample46)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample46)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 57 {
//            ehaP2RightFinalGainSample47 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample47 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample47)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample47)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 58 {
//            ehaP2RightFinalGainSample48 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample48 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample48)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample48)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 59 {
//            ehaP2RightFinalGainSample49 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample49 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample49)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample49)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 60 {
//            ehaP2RightFinalGainSample50 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample50 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample50)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample50)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 61 {
//            ehaP2RightFinalGainSample51 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample51 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample51)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample51)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 62 {
//            ehaP2RightFinalGainSample52 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample52 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample52)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample52)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//
//        } else if ehaP2_index == 72 {
//            ehaP2RightFinalGainSample53 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample53 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample53)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample53)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 73 {
//            ehaP2RightFinalGainSample54 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample54 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample54)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample54)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 74 {
//            ehaP2RightFinalGainSample55 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample55 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample55)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample55)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 75 {
//            ehaP2RightFinalGainSample56 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample56 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample56)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample56)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 76 {
//            ehaP2RightFinalGainSample57 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample57 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample57)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample57)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 77 {
//            ehaP2RightFinalGainSample58 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample58 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample58)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample58)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//        } else if ehaP2_index == 78 {
//            ehaP2RightFinalGainSample59 = ehaP2_averageGain
//            ehaP2RightFinalGainDBSample59 = ehaP2_averageGainDB
//            ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample59)
//            ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample59)
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//
//
//        } else {
//            print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
//            print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
//            fatalError("In ehaP2Right side assignLRAverageSampleGains")
//        }
//    } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan < 0 { //} ehaP2MonoTest == false {
//        //Left Side. Go Through Each Assignment based on index for sample
//        if ehaP2_index == 9 {
//            ehaP2LeftFinalGainSample17 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample17 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample17)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample17)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 10 {
//            ehaP2LeftFinalGainSample18 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample18 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample18)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample18)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 11 {
//            ehaP2LeftFinalGainSample19 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample19 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample19)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample19)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 12 {
//            ehaP2LeftFinalGainSample20 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample20 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample20)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample20)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 13 {
//            ehaP2LeftFinalGainSample21 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample21 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample21)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample21)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 14 {
//            ehaP2LeftFinalGainSample22 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample22 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample22)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample22)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 15 {
//            ehaP2LeftFinalGainSample23 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample23 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample23)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample23)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 16 {
//            ehaP2LeftFinalGainSample24 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample24 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample24)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample24)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 17 {
//            ehaP2LeftFinalGainSample25 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample25 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample25)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample25)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//
//        } else if ehaP2_index == 27 {
//            ehaP2LeftFinalGainSample26 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample26 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample26)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample26)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 28 {
//            ehaP2LeftFinalGainSample27 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample27 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample27)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample27)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 29 {
//            ehaP2LeftFinalGainSample28 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample28 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample28)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample28)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 30 {
//            ehaP2LeftFinalGainSample29 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample29 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample29)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample29)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 31 {
//            ehaP2LeftFinalGainSample30 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample30 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample30)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample30)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 32 {
//            ehaP2LeftFinalGainSample31 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample31 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample31)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample31)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 33 {
//            ehaP2LeftFinalGainSample32 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample32 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample32)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample32)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 34 {
//            ehaP2LeftFinalGainSample33 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample33 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample33)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample33)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 35 {
//            ehaP2LeftFinalGainSample34 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample34 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample34)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample34)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//
//        } else if ehaP2_index == 45 {
//            ehaP2LeftFinalGainSample35 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample35 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample35)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample35)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 46 {
//            ehaP2LeftFinalGainSample36 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample36 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample36)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample36)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 47 {
//            ehaP2LeftFinalGainSample37 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample37 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample37)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample37)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 48 {
//            ehaP2LeftFinalGainSample38 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample38 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample38)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample38)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 49 {
//            ehaP2LeftFinalGainSample39 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample39 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample39)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample39)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 50 {
//            ehaP2LeftFinalGainSample40 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample40 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample40)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample40)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 51 {
//            ehaP2LeftFinalGainSample41 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample41 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample41)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample41)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 52 {
//            ehaP2LeftFinalGainSample42 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample42 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample42)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample42)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 53 {
//            ehaP2LeftFinalGainSample43 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample43 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample43)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample43)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//
//        } else if ehaP2_index == 63 {
//            ehaP2LeftFinalGainSample44 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample44 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample44)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample44)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 64 {
//            ehaP2LeftFinalGainSample45 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample45 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample45)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample45)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 65 {
//            ehaP2LeftFinalGainSample46 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample46 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample46)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample46)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 66 {
//            ehaP2LeftFinalGainSample47 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample47 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample47)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample47)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 67 {
//            ehaP2LeftFinalGainSample48 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample48 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample48)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample48)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 68 {
//            ehaP2LeftFinalGainSample49 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample49 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample49)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample49)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 69 {
//            ehaP2LeftFinalGainSample50 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample50 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample50)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample50)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 70 {
//            ehaP2LeftFinalGainSample51 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample51 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample51)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample51)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 71 {
//            ehaP2LeftFinalGainSample52 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample52 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample52)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample52)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//
//        } else if ehaP2_index == 79 {
//            ehaP2LeftFinalGainSample53 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample53 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample53)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample53)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 80 {
//            ehaP2LeftFinalGainSample54 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample54 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample54)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample54)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 81 {
//            ehaP2LeftFinalGainSample55 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample55 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample55)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample55)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 82 {
//            ehaP2LeftFinalGainSample56 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample56 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample56)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample56)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 83 {
//            ehaP2LeftFinalGainSample57 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample57 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample57)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample57)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 84 {
//            ehaP2LeftFinalGainSample58 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample58 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample58)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample58)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//        } else if ehaP2_index == 85 {
//            ehaP2LeftFinalGainSample59 = ehaP2_averageGain
//            ehaP2LeftFinalGainDBSample59 = ehaP2_averageGainDB
//            ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample59)
//            ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample59)
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//
//        } else {
//            print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
//            print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
//            fatalError("In ehaP2left side assignLRAverageSampleGains")
//        }
//    } else {
//        // No ready to log yet
//        print("in bilateral gain logging Coninue, not ready to log in assignLRAverageSampleGains")
//    }
//}
//
//// Single sided mono test for Left / Right / and Mono of pan = 0.0
//func ehaP2AssignMonoAverageSampleGains() async {
//    if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == 1.0 && ehaP2MonoTest == true {
//        fatalError("mono fatal error")
////            //go through each assignment based on index
////            if ehaP2_index == 0 {
////                ehaP2RightFinalGainSample17 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample17 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample17)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample17)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 1 {
////                ehaP2RightFinalGainSample18 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample18 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample18)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample18)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 2 {
////                ehaP2RightFinalGainSample19 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample19 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample19)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample19)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 3 {
////                ehaP2RightFinalGainSample20 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample20 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample20)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample20)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 4 {
////                ehaP2RightFinalGainSample21 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample21 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample21)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample21)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 5 {
////                ehaP2RightFinalGainSample22 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample22 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample22)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample22)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 6 {
////                ehaP2RightFinalGainSample23 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample23 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample23)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample23)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 7 {
////                ehaP2RightFinalGainSample24 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample24 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample24)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample24)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 8 {
////                ehaP2RightFinalGainSample25 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample25 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample25)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample25)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////
////            } else if ehaP2_index == 9 {
////                ehaP2RightFinalGainSample26 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample26 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample26)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample26)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 10 {
////                ehaP2RightFinalGainSample27 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample27 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample27)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample27)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 11 {
////                ehaP2RightFinalGainSample28 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample28 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample28)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample28)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 12 {
////                ehaP2RightFinalGainSample29 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample29 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample29)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample29)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 13 {
////                ehaP2RightFinalGainSample30 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample30 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample30)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample30)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 14 {
////                ehaP2RightFinalGainSample31 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample31 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample31)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample31)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 15 {
////                ehaP2RightFinalGainSample32 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample32 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample32)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample32)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 16 {
////                ehaP2RightFinalGainSample33 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample33 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample33)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample33)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 17 {
////                ehaP2RightFinalGainSample34 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample34 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample34)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample34)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////
////            } else if ehaP2_index == 18 {
////                ehaP2RightFinalGainSample35 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample35 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample35)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample35)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 19 {
////                ehaP2RightFinalGainSample36 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample36 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample36)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample36)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 20 {
////                ehaP2RightFinalGainSample37 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample37 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample37)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample37)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 21 {
////                ehaP2RightFinalGainSample38 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample38 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample38)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample38)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 22 {
////                ehaP2RightFinalGainSample39 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample39 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample39)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample39)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 23 {
////                ehaP2RightFinalGainSample40 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample40 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample40)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample40)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 24 {
////                ehaP2RightFinalGainSample41 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample41 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample41)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample41)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 25 {
////                ehaP2RightFinalGainSample42 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample42 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample42)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample42)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 26 {
////                ehaP2RightFinalGainSample43 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample43 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample43)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample43)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////
////            } else if ehaP2_index == 27 {
////                ehaP2RightFinalGainSample44 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample44 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample44)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample44)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 28 {
////                ehaP2RightFinalGainSample45 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample45 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample45)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample45)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 29 {
////                ehaP2RightFinalGainSample46 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample46 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample46)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample46)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 30 {
////                ehaP2RightFinalGainSample47 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample47 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample47)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample47)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 31 {
////                ehaP2RightFinalGainSample48 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample48 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample48)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample48)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 32 {
////                ehaP2RightFinalGainSample49 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample49 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample49)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample49)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 33 {
////                ehaP2RightFinalGainSample50 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample50 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample50)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample50)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 34 {
////                ehaP2RightFinalGainSample51 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample51 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample51)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample51)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 35 {
////                ehaP2RightFinalGainSample52 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample52 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample52)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample52)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////
////            } else if ehaP2_index == 36 {
////                ehaP2RightFinalGainSample53 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample53 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample53)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample53)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 37 {
////                ehaP2RightFinalGainSample54 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample54 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample54)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample54)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 38 {
////                ehaP2RightFinalGainSample55 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample55 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample55)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample55)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 39 {
////                ehaP2RightFinalGainSample56 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample56 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample56)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample56)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 40 {
////                ehaP2RightFinalGainSample57 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample57 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample57)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample57)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 41 {
////                ehaP2RightFinalGainSample58 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample58 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample58)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample58)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////            } else if ehaP2_index == 42 {
////                ehaP2RightFinalGainSample59 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample59 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample59)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample59)
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2rightFinalGainsDBArray: \(ehaP2rightFinalGainsDBArray)")
////
////            } else {
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                fatalError("In ehaP2Right side assignLRAverageSampleGains")
////            }
////        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == -1.0 && ehaP2MonoTest == true {
////            //Left Side. Go Through Each Assignment based on index for sample
////            if ehaP2_index == 0 {
////                ehaP2LeftFinalGainSample17 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample17 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample17)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample17)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 1 {
////                ehaP2LeftFinalGainSample18 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample18 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample18)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample18)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 2 {
////                ehaP2LeftFinalGainSample19 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample19 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample19)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample19)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 3 {
////                ehaP2LeftFinalGainSample20 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample20 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample20)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample20)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 4 {
////                ehaP2LeftFinalGainSample21 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample21 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample21)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample21)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 5 {
////                ehaP2LeftFinalGainSample22 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample22 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample22)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample22)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 6 {
////                ehaP2LeftFinalGainSample23 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample23 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample23)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample23)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 7 {
////                ehaP2LeftFinalGainSample24 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample24 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample24)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample24)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 8 {
////                ehaP2LeftFinalGainSample25 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample25 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample25)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample25)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////
////            } else if ehaP2_index == 9 {
////                ehaP2LeftFinalGainSample26 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample26 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample26)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample26)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 10 {
////                ehaP2LeftFinalGainSample27 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample27 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample27)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample27)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 11 {
////                ehaP2LeftFinalGainSample28 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample28 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample28)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample28)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 12 {
////                ehaP2LeftFinalGainSample29 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample29 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample29)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample29)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 13 {
////                ehaP2LeftFinalGainSample30 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample30 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample30)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample30)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 14 {
////                ehaP2LeftFinalGainSample31 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample31 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample31)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample31)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 15 {
////                ehaP2LeftFinalGainSample32 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample32 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample32)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample32)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 16 {
////                ehaP2LeftFinalGainSample33 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample33 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample33)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample33)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 17 {
////                ehaP2LeftFinalGainSample34 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample34 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample34)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample34)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////
////            } else if ehaP2_index == 18 {
////                ehaP2LeftFinalGainSample35 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample35 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample35)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample35)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 19 {
////                ehaP2LeftFinalGainSample36 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample36 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample36)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample36)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 20 {
////                ehaP2LeftFinalGainSample37 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample37 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample37)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample37)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 21 {
////                ehaP2LeftFinalGainSample38 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample38 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample38)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample38)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 22 {
////                ehaP2LeftFinalGainSample39 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample39 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample39)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample39)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 23 {
////                ehaP2LeftFinalGainSample40 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample40 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample40)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample40)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 24 {
////                ehaP2LeftFinalGainSample41 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample41 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample41)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample41)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 25 {
////                ehaP2LeftFinalGainSample42 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample42 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample42)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample42)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 26 {
////                ehaP2LeftFinalGainSample43 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample43 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample43)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample43)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////
////            } else if ehaP2_index == 27 {
////                ehaP2LeftFinalGainSample44 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample44 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample44)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample44)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 28 {
////                ehaP2LeftFinalGainSample45 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample45 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample45)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample45)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 29 {
////                ehaP2LeftFinalGainSample46 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample46 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample46)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample46)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 30 {
////                ehaP2LeftFinalGainSample47 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample47 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample47)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample47)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 31 {
////                ehaP2LeftFinalGainSample48 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample48 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample48)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample48)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 32 {
////                ehaP2LeftFinalGainSample49 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample49 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample49)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample49)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 33 {
////                ehaP2LeftFinalGainSample50 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample50 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample50)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample50)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 34 {
////                ehaP2LeftFinalGainSample51 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample51 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample51)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample51)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 35 {
////                ehaP2LeftFinalGainSample52 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample52 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample52)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample52)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////
////            } else if ehaP2_index == 36 {
////                ehaP2LeftFinalGainSample53 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample53 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample53)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample53)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 37 {
////                ehaP2LeftFinalGainSample54 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample54 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample54)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample54)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 38 {
////                ehaP2LeftFinalGainSample55 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample55 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample55)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample55)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 39 {
////                ehaP2LeftFinalGainSample56 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample56 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample56)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample56)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 40 {
////                ehaP2LeftFinalGainSample57 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample57 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample57)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample57)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 41 {
////                ehaP2LeftFinalGainSample58 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample58 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample58)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample58)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////            } else if ehaP2_index == 42 {
////                ehaP2LeftFinalGainSample59 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample59 = ehaP2_averageGainDB
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample59)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample59)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////
////            } else {
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                print("### eHAP2_ehaP2leftFinalGainsDBArray: \(ehaP2leftFinalGainsDBArray)")
////                fatalError("In ehaP2Right side assignLRAverageSampleGains")
////            }
////
////        } else if ehaP2localMarkNewTestCycle == 1 && ehaP2localReversalEnd == 1 && ehaP2localPan == 0.0 && ehaP2MonoTest == true {
////            if ehaP2_index == 0 {
////                ehaP2LeftFinalGainSample17 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample17 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample17 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample17 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample17)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample17)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample17)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample17)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 1 {
////                ehaP2LeftFinalGainSample18 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample18 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample18 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample18 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample18)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample18)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample18)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample18)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 2 {
////                ehaP2LeftFinalGainSample19 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample19 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample19 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample19 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample19)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample19)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample19)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample19)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 3 {
////                ehaP2LeftFinalGainSample20 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample20 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample20 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample20 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample20)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample20)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample20)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample20)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 4 {
////                ehaP2LeftFinalGainSample21 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample21 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample21 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample21 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample21)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample21)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample21)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample21)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////            } else if ehaP2_index == 5 {
////                ehaP2LeftFinalGainSample22 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample22 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample22 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample22 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample22)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample22)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample22)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample22)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 6 {
////                ehaP2LeftFinalGainSample23 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample23 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample23 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample23 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample23)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample23)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample23)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample23)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 7 {
////                ehaP2LeftFinalGainSample24 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample24 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample24 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample24 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample24)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample24)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample24)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample24)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 8 {
////                ehaP2LeftFinalGainSample25 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample25 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample25 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample25 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample25)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample25)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample25)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample25)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////
////            } else if ehaP2_index == 9 {
////                ehaP2LeftFinalGainSample26 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample26 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample26 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample26 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample26)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample26)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample26)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample26)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 10 {
////                ehaP2LeftFinalGainSample27 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample27 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample27 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample27 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample27)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample27)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample27)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample27)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 11 {
////                ehaP2LeftFinalGainSample28 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample28 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample28 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample28 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample28)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample28)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample28)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample28)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 12 {
////                ehaP2LeftFinalGainSample29 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample29 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample29 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample29 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample29)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample29)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample29)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample29)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 13 {
////                ehaP2LeftFinalGainSample30 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample30 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample30 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample30 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample30)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample30)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample30)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample30)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 14 {
////                ehaP2LeftFinalGainSample31 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample31 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample31 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample31 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample31)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample31)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample31)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample31)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 15 {
////                ehaP2LeftFinalGainSample32 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample32 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample32 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample32 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample32)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample32)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample32)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample32)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 16 {
////                ehaP2LeftFinalGainSample33 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample33 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample33 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample33 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample33)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample33)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample33)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample33)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 17 {
////                ehaP2LeftFinalGainSample34 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample34 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample34 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample34 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample34)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample34)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample34)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample34)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////
////            } else if ehaP2_index == 18 {
////                ehaP2LeftFinalGainSample35 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample35 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample35 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample35 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample35)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample35)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample35)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample35)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 19 {
////                ehaP2LeftFinalGainSample36 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample36 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample36 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample36 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample36)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample36)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample36)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample36)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 20 {
////                ehaP2LeftFinalGainSample37 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample37 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample37 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample37 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample37)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample37)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample37)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample37)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 21 {
////                ehaP2LeftFinalGainSample38 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample38 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample38 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample38 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample38)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample38)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample38)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample38)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 22 {
////                ehaP2LeftFinalGainSample39 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample39 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample39 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample39 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample39)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample39)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample39)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample39)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 23 {
////                ehaP2LeftFinalGainSample40 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample40 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample40 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample40 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample40)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample40)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample40)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample40)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 24 {
////                ehaP2LeftFinalGainSample41 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample41 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample41 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample41 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample41)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample41)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample41)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample41)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 25 {
////                ehaP2LeftFinalGainSample42 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample42 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample42 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample42 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample42)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample42)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample42)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample42)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 26 {
////                ehaP2LeftFinalGainSample43 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample43 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample43 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample43 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample43)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample43)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample43)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample43)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////
////            } else if ehaP2_index == 27 {
////                ehaP2LeftFinalGainSample44 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample44 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample44 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample44 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample44)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample44)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample44)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample44)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 28 {
////                ehaP2LeftFinalGainSample45 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample45 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample45 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample45 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample45)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample45)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample45)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample45)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 29 {
////                ehaP2LeftFinalGainSample46 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample46 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample46 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample46 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample46)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample46)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample46)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample46)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 30 {
////                ehaP2LeftFinalGainSample47 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample47 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample47 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample47 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample47)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample47)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample47)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample47)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 31 {
////                ehaP2LeftFinalGainSample48 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample48 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample48 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample48 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample48)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample48)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample48)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample48)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 32 {
////                ehaP2LeftFinalGainSample49 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample49 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample49 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample49 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample49)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample49)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample49)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample49)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 33 {
////                ehaP2LeftFinalGainSample50 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample50 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample50 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample50 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample50)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample50)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample50)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample50)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 34 {
////                ehaP2LeftFinalGainSample51 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample51 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample51 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample51 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample51)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample51)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample51)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample51)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 35 {
////                ehaP2LeftFinalGainSample52 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample52 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample52 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample52 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample52)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample52)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample52)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample52)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////
////            } else if ehaP2_index == 36 {
////                ehaP2LeftFinalGainSample53 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample53 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample53 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample53 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample53)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample53)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample53)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample53)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 37 {
////                ehaP2LeftFinalGainSample54 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample54 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample54 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample54 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample54)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample54)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample54)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample54)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 38 {
////                ehaP2LeftFinalGainSample55 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample55 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample55 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample55 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample55)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample55)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample55)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample55)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 39 {
////                ehaP2LeftFinalGainSample56 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample56 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample56 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample56 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample56)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample56)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample56)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample56)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 40 {
////                ehaP2LeftFinalGainSample57 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample57 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample57 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample57 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample57)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample57)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample57)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample57)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 41 {
////                ehaP2LeftFinalGainSample58 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample58 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample58 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample58 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample58)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample58)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample58)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample58)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////            } else if ehaP2_index == 42 {
////                ehaP2LeftFinalGainSample59 = ehaP2_averageGain
////                ehaP2LeftFinalGainDBSample59 = ehaP2_averageGainDB
////                ehaP2RightFinalGainSample59 = ehaP2_averageGain
////                ehaP2RightFinalGainDBSample59 = ehaP2_averageGainDB
////                ehaP2rightFinalGainsArray.append(ehaP2RightFinalGainSample59)
////                ehaP2leftFinalGainsArray.append(ehaP2LeftFinalGainSample59)
////                ehaP2rightFinalGainsDBArray.append(ehaP2RightFinalGainDBSample59)
////                ehaP2leftFinalGainsDBArray.append(ehaP2LeftFinalGainDBSample59)
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////
////            } else {
////                print("*** ehaP2leftFinalGainsArray: \(ehaP2leftFinalGainsArray)")
////                print("*** ehaP2rightFinalGainsArray: \(ehaP2rightFinalGainsArray)")
////                fatalError("In ehaP2left side assignLRAverageSampleGains")
////            }
//    } else {
//        // No ready to log yet
//        print(" in mono gain logging Coninue, not ready to log in assignLRAverageSampleGains")
//        fatalError("mono fatal error")
//    }
//}
