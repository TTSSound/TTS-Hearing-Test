//  EnvDataObjectModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//

import Foundation
import CoreMedia
import AudioToolbox
import QuartzCore
import SwiftUI
import CoreData
import CodableCSV
//import Alamofire
import MobileCoreServices

// Add System Volume Tracking
// Add CoreData Saves for individual variables one element at a time, forget the array approach


//struct SaveFinalResults: Identifiable, Codable {  // This is a model
//    var id = Int()
//    var jsonName = String()
//    var jsonAge = Int()
//    var jsonSex = Int()
//    var jsonEmail = String()
//    var json1kHzRightEarHL = Float()
//    var json1kHzLeftEarHL = Float()
//    var json1kHzIntraEarDeltaHL = Float()
//    var jsonPhonCurve = Int()
//    var jsonReferenceCurve = Int()
//    var jsonSystemVoluem = Float()
//    var jsonActualFrequency = Double()
//    var jsonFrequency: [String]
//    var jsonGain: [Float]
//    var jsonPan: [Int]
//    var jsonStoredIndex: [Int]
//    var jsonStoredTestStartSeconds: [Float64]
//    var jsonStoredTestEndSeconds: [Float64]
//    var jsonStoredUserRespCMSeconds: [Float64]
//    var jsonStoredTestPan: [Int]
//    var jsonStoredTestTestGain: [Float]
//    var jsonStoredFrequency: [String]
//    var jsonStoredTestCount: [Int]
//    var jsonStoredHeardArray: [Int]
//    var jsonStoredReversalDirection: [Float]
//    var jsonStoredReversalGain: [Float]
//    var jsonStoredReversalFrequency: [String]
//    var jsonStoredReversalHeard: [Int]
//    var jsonStoredFirstGain: [Float]
//    var jsonStoredSecondGain: [Float]
//    var jsonStoredAverageGain: [Float]
//    var jsonStoredResultsFrequency: [String]
//    var jsonStoredResultsGains: [Float]
//
//}


class EnvDataObjectModel: ObservableObject {



    // Test Variables
    @Published var index: Int = 0
    @MainActor @Published var heardArray: [Int] = [Int]()
    @Published var samples: [String] = ["Sample0", "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    @Published var eptaSamplesCount = 17
    @Published var sampleType: String = ".wav"
    @Published var pan: Int = Int()        // 0 = Left , 1 = Middle, 2 = Right
    @Published var testGain: Float = 0.2
    @MainActor @Published var testCount: [Int] = [Int]()


    @Published var indexForTest = [Int]()
    @Published var testPan = [Int]()
    @MainActor @Published var testTestGain = [Float]()
    @Published var frequency = [String]()
    @Published var testStartSeconds = [Float64]()
    @Published var testEndSeconds = [Float64]()
    @Published var userRespCMSeconds = [Float64]()

    // Results Variable Arrays
    @Published var resultsFrequency = [String]()
    @Published var resultsGains = [Float]()


    //Clock Variables
    @Published var currentTimeMach: UInt64
    @Published var currentTimeMedia: CFTimeInterval
    @Published var masterClock = CMClockGetHostTimeClock()


    //Reversal Variables
    @Published var envReversal = Int()
    @Published var reversalTestCount = [Int]()
    @MainActor @Published var reversalArrayIndex = Int()
    @Published var reversalGain = [Float]()
    @Published var reversalFirstGain = [Float]()
    @Published var reversalSecondGain = [Float]()
    @Published var reversalFrequency = [String]()
    @MainActor @Published var reversalHeard = [Int]()
    @Published var reveralArray = [Any]()
    @Published var reversalDirection = Float()
    @Published var reversalDirectionArray = [Float]()
    @Published var averageGain = Float()
    @Published var reversalAverageGain = [Float]()
    @Published var reversalDualTrue = Int()
    @Published var reversalResultsGains = [Float]()
    @Published var reversalResultsFrequency = [String]()
    @Published var envMarkNewTestCycle = Int()


    //Data Store Variables
    @Published var storedIndex: [Int] = [100000000] // [9999999999]
    @Published var storedTestStartSeconds: [Float64] = [1000000.0] //[999999.999]
    @Published var storedTestEndSeconds: [Float64] = [1000000.0]
    @Published var storedUserRespCMSeconds: [Float64] = [1000000.0]
    @Published var storedTestPan: [Int] = [100000000]
    @Published var storedTestTestGain: [Float] = [1000000.0] //1000000.0
    @Published var storedFrequency: [String] = ["100000000"] //["9999999999"]
    @Published var storedTestCount: [Int] = [100000000]
    @Published var storedHeardArray: [Int] = [100000000]
    @Published var storedReversalDirection: [Float] = [1000000.0]
    @Published var storedReversalGain: [Float] = [1000000.0]
    @Published var storedReversalFrequency: [String] = ["100000000"]
    @Published var storedReversalHeard: [Int] = [100000000]
    @Published var storedFirstGain: [Float] = [1000000.0]
    @Published var storedSecondGain: [Float] = [1000000.0]
    @Published var storedAverageGain: [Float] = [1000000.0]
    @Published var storedResultsFrequency: [String] = ["100000000"]
    @Published var storedResultsGains: [Float] = [1000000.0]



    //Final Data Store Arrays
    @Published var finalStoredIndex: [Int] = [Int]()
    @Published var finalStoredTestStartSeconds: [Float64] = [Float64]()
    @Published var finalStoredTestEndSeconds: [Float64] = [Float64]()
    @Published var finalStoredUserRespCMSeconds: [Float64] = [Float64]()
    @Published var finalStoredTestPan: [Int] = [Int]()
    @Published var finalStoredTestTestGain: [Float] = [Float]()
    @Published var finalStoredFrequency: [String] = [String]()
    @Published var finalStoredTestCount: [Int] = [Int]()
    @Published var finalStoredHeardArray: [Int] = [Int]()
    @Published var finalStoredReversalDirectionArray: [Float] = [Float]()
    @Published var finalStoredReversalGain: [Float] = [Float]()
    @Published var finalStoredReversalFrequency: [String] = [String]()
    @Published var finalStoredReversalHeard: [Int] = [Int]()
    @Published var finalStoredFirstGain: [Float] = [Float]()
    @Published var finalStoredSecondGain: [Float] = [Float]()
    @Published var finalStoredAverageGain: [Float] = [Float]()
    @Published var finalStoredResultsFrequency: [String] = [String]()
    @Published var finalStoredResultsGains: [Float] = [Float]()

    @Published var finalHearingResults = [[Any]]()



    let fileName = "SummaryResults.json"
    let summaryCSVName = "SummaryResultsCSV.csv"
    let detailedCSVName = "DetailedResultsCSV.csv"
    let inputSummaryCSVName = "InputSummaryResultsCSV.csv"
    let inputDetailedCSVName = "InputDetailedResultsCSV.csv"


//
//    @Published var saveFinalResults: SaveFinalResults? = nil
    

    



    init(){
        currentTimeMach =  mach_absolute_time()
        currentTimeMedia = CACurrentMediaTime()
        let masterClock = CMClockGetHostTimeClock()
        CMClockGetTime(masterClock)
    }
//    
//    
//    func getData() async {
//        guard let data = await getJSONData() else { return }
//        print("Json Data:")
//        print(data)
//        let jsonString = String(data: data, encoding: .utf8)
//        print(jsonString!)
//        do {
//        self.saveFinalResults = try JSONDecoder().decode(SaveFinalResults.self, from: data)
//            print("JSON GetData Run")
//            print("data: \(data)")
//        } catch let error {
//            print("error decoding \(error)")
//        }
//    }
//
//    func getJSONData() async -> Data? {
//        let saveFinalResults = SaveFinalResults(
//            id: 11111,
//            jsonName: "Jeff",
//            jsonAge: 36,
//            jsonSex: 1,
//            jsonEmail: "blank@blank.com",
//            json1kHzRightEarHL: 1.5,
//            json1kHzLeftEarHL: 0.5,
//            json1kHzIntraEarDeltaHL: 1.0,
//            jsonPhonCurve: 2,
//            jsonReferenceCurve: 7,
//            jsonSystemVoluem: 100.00,
//            jsonActualFrequency: 1.000,
//            jsonFrequency: finalStoredResultsFrequency,
//            jsonGain: finalStoredResultsGains,
//            jsonPan: finalStoredTestPan,
//            jsonStoredIndex: finalStoredIndex,
//            jsonStoredTestStartSeconds: finalStoredTestStartSeconds,
//            jsonStoredTestEndSeconds: finalStoredTestEndSeconds,
//            jsonStoredUserRespCMSeconds: finalStoredUserRespCMSeconds,
//            jsonStoredTestPan: finalStoredTestPan,
//            jsonStoredTestTestGain: finalStoredTestTestGain,
//            jsonStoredFrequency: finalStoredFrequency,
//            jsonStoredTestCount: finalStoredTestCount,
//            jsonStoredHeardArray: finalStoredHeardArray,
//            jsonStoredReversalDirection: finalStoredReversalDirectionArray,
//            jsonStoredReversalGain: finalStoredReversalGain,
//            jsonStoredReversalFrequency: finalStoredReversalFrequency,
//            jsonStoredReversalHeard: finalStoredReversalHeard,
//            jsonStoredFirstGain: finalStoredFirstGain,
//            jsonStoredSecondGain: finalStoredSecondGain,
//            jsonStoredAverageGain: finalStoredAverageGain,
//            jsonStoredResultsFrequency: finalStoredResultsFrequency,
//            jsonStoredResultsGains: finalStoredResultsGains)
//
//        let jsonData = try? JSONEncoder().encode(saveFinalResults)
//        print("saveFinalResults: \(saveFinalResults)")
//        print("Json Encoded \(jsonData!)")
//        return jsonData
//    }
//
//
//    func saveToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        print("DocumentsDirectory: \(documentsDirectory)")
//        let filePaths = documentsDirectory.appendingPathComponent(fileName)
//        print(filePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//            do {
//                let jsonData = try encoder.encode(saveFinalResults)
//                print(jsonData)
//
//                try jsonData.write(to: filePaths)
//            } catch {
//                print("Error writing to JSON file: \(error)")
//            }
//        }
//
//
//    func writeDetailedResultsToCSV() async {
//       print("writeResultsToCSV Start")
//
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
//
//        do {
//            let csvDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvDetailDocumentsDirectory = csvDetailPath
//            print("CSV DocumentsDirectory: \(csvDetailDocumentsDirectory)")
//            let csvDetailFilePath = csvDetailDocumentsDirectory.appendingPathComponent(detailedCSVName)
//            print(csvDetailFilePath)
//
//            let writer = try CSVWriter(fileURL: csvDetailFilePath, append: false)
//
//            try writer.write(row: [stringFinalStoredIndex])
//            try writer.write(row: [stringFinalStoredTestStartSeconds])
//            try writer.write(row: [stringFinalStoredTestEndSeconds])
//            try writer.write(row: [stringFinalStoredUserRespCMSeconds])
//            try writer.write(row: [stringFinalStoredTestTestGain])
//            try writer.write(row: [stringFinalStoredFrequency])
//            try writer.write(row: [stringFinalStoredTestCount])
//            try writer.write(row: [stringFinalStoredHeardArray])
//            try writer.write(row: [stringFinalStoredReversalDirectionArray])
//            try writer.write(row: [stringFinalStoredReversalGain])
//            try writer.write(row: [stringFinalStoredReversalFrequency])
//            try writer.write(row: [stringFinalStoredReversalHeard])
//            try writer.write(row: [stringFinalStoredFirstGain])
//            try writer.write(row: [stringFinalStoredSecondGain])
//            try writer.write(row: [stringFinalStoredAverageGain])
//            try writer.write(row: [stringFinalStoredResultsFrequency])
//            try writer.write(row: [stringFinalStoredResultsGains])
//            try writer.write(row: [stringFinalStoredTestPan])
//
//            print("CVS Detailed Writer Success")
//        } catch {
//            print("CVSWriter Detailed Error or Error Finding File for Detailed CSV \(error)")
//        }
//    }
//
//
//    func writeSummarydResultsToCSV() async {
//        print("writeSummaryResultsToCSV Start")
//         let stringFinalStoredResultsFrequency = "finalStoredResultsFrequency," + finalStoredResultsFrequency.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredTestPan = "finalStoredTestPan," + finalStoredTestPan.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredFirstGain = "finalStoredFirstGain," + finalStoredFirstGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredSecondGain = "finalStoredSecondGain," + finalStoredSecondGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredAverageGain = "finalStoredAverageGain," + finalStoredAverageGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredResultsGains = "finalStoredResultsGains," + finalStoredResultsGains.map { String($0) }.joined(separator: ",")
//         do {
//             let csvSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//             let csvSummaryDocumentsDirectory = csvSummaryPath
//             print("CSV Summary DocumentsDirectory: \(csvSummaryDocumentsDirectory)")
//             let csvSummaryFilePath = csvSummaryDocumentsDirectory.appendingPathComponent(summaryCSVName)
//             print(csvSummaryFilePath)
//             let writer = try CSVWriter(fileURL: csvSummaryFilePath, append: false)
//             try writer.write(row: [stringFinalStoredResultsFrequency])
//             try writer.write(row: [stringFinalStoredTestPan])
//             try writer.write(row: [stringFinalStoredFirstGain])
//             try writer.write(row: [stringFinalStoredSecondGain])
//             try writer.write(row: [stringFinalStoredAverageGain])
//             try writer.write(row: [stringFinalStoredResultsGains])
//             print("CVS Summary Data Writer Success")
//         } catch {
//             print("CVSWriter Summary Data Error or Error Finding File for Detailed CSV \(error)")
//         }
//    }
//
//
//    func writeInputDetailedResultsToCSV() async {
//       print("writeInputDetailResultsToCSV Start")
//        let stringFinalStoredIndex = finalStoredIndex.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredTestStartSeconds = finalStoredTestStartSeconds.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredTestEndSeconds = finalStoredTestEndSeconds.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredUserRespCMSeconds = finalStoredUserRespCMSeconds.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredTestTestGain = finalStoredTestTestGain.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredFrequency = finalStoredFrequency.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredTestCount = finalStoredTestCount.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredHeardArray = finalStoredHeardArray.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredReversalDirectionArray = finalStoredReversalDirectionArray.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredReversalGain = finalStoredReversalGain.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredReversalFrequency = finalStoredReversalFrequency.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredReversalHeard = finalStoredReversalHeard.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredFirstGain = finalStoredFirstGain.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredSecondGain = finalStoredSecondGain.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredAverageGain = finalStoredAverageGain.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredResultsFrequency = finalStoredResultsFrequency.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredResultsGains = finalStoredResultsGains.map { String($0) }.joined(separator: ",")
//        let stringFinalStoredTestPan = finalStoredTestPan.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputDetailPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputDetailDocumentsDirectory = csvInputDetailPath
//            print("CSV Input Detail DocumentsDirectory: \(csvInputDetailDocumentsDirectory)")
//            let csvInputDetailFilePath = csvInputDetailDocumentsDirectory.appendingPathComponent(inputDetailedCSVName)
//            print(csvInputDetailFilePath)
//            let writer = try CSVWriter(fileURL: csvInputDetailFilePath, append: false)
//            try writer.write(row: [stringFinalStoredIndex])
//            try writer.write(row: [stringFinalStoredTestStartSeconds])
//            try writer.write(row: [stringFinalStoredTestEndSeconds])
//            try writer.write(row: [stringFinalStoredUserRespCMSeconds])
//            try writer.write(row: [stringFinalStoredTestTestGain])
//            try writer.write(row: [stringFinalStoredFrequency])
//            try writer.write(row: [stringFinalStoredTestCount])
//            try writer.write(row: [stringFinalStoredHeardArray])
//            try writer.write(row: [stringFinalStoredReversalDirectionArray])
//            try writer.write(row: [stringFinalStoredReversalGain])
//            try writer.write(row: [stringFinalStoredReversalFrequency])
//            try writer.write(row: [stringFinalStoredReversalHeard])
//            try writer.write(row: [stringFinalStoredFirstGain])
//            try writer.write(row: [stringFinalStoredSecondGain])
//            try writer.write(row: [stringFinalStoredAverageGain])
//            try writer.write(row: [stringFinalStoredResultsFrequency])
//            try writer.write(row: [stringFinalStoredResultsGains])
//            try writer.write(row: [stringFinalStoredTestPan])
//            print("CVS Input Detailed Writer Success")
//        } catch {
//            print("CVSWriter Input Detailed Error or Error Finding File for Input Detailed CSV \(error)")
//        }
//    }
//
//
//    func writeInputSummarydResultsToCSV() async {
//        print("writeInputSummaryResultsToCSV Start")
//         let stringFinalStoredResultsFrequency = finalStoredResultsFrequency.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredTestPan = finalStoredTestPan.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredFirstGain = finalStoredFirstGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredSecondGain = finalStoredSecondGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredAverageGain = finalStoredAverageGain.map { String($0) }.joined(separator: ",")
//         let stringFinalStoredResultsGains = finalStoredResultsGains.map { String($0) }.joined(separator: ",")
//         do {
//             let csvInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//             let csvInputSummaryDocumentsDirectory = csvInputSummaryPath
//             print("CSV Input Summary DocumentsDirectory: \(csvInputSummaryDocumentsDirectory)")
//             let csvInputSummaryFilePath = csvInputSummaryDocumentsDirectory.appendingPathComponent(inputSummaryCSVName)
//             print(csvInputSummaryFilePath)
//             let writer = try CSVWriter(fileURL: csvInputSummaryFilePath, append: false)
//             try writer.write(row: [stringFinalStoredResultsFrequency])
//             try writer.write(row: [stringFinalStoredTestPan])
//             try writer.write(row: [stringFinalStoredFirstGain])
//             try writer.write(row: [stringFinalStoredSecondGain])
//             try writer.write(row: [stringFinalStoredAverageGain])
//             try writer.write(row: [stringFinalStoredResultsGains])
//             print("CVS Input Summary Data Writer Success")
//         } catch {
//             print("CVSWriter Input Summary Data Error or Error Finding File for Input Summary CSV \(error)")
//         }
//    }
}
    





