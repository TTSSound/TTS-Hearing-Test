//
//  InAppPurchaseModel.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

//import Foundation
//import CoreMedia
//import AudioToolbox
//import QuartzCore
//import SwiftUI
//import CoreData
//import CodableCSV
////import Alamofire
//
//
//struct SaveFinalTestPurchase: Codable {  // This is a model
//    var jsonFinalPurchasedEHATestUUID = [String]()
//    var jsonFinalPurchasedEPTATestUUID = [String]()
//    var jsonFinalPurchasedTestTolken = [String]()
//    var jsonFinalTestPurchased = [Int]()
//
//    enum CodingKeys: String, CodingKey {
//        case jsonFinalPurchasedEHATestUUID
//        case jsonFinalPurchasedEPTATestUUID
//        case jsonFinalPurchasedTestTolken
//        case jsonFinalTestPurchased
//    }
//}
//
//class InAppPurchaseModel: ObservableObject {
//    
//    //Purchasing Variables
//    @Published var userPurchasedTest = [Int]()   // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
//    @Published var userPurchasedEHAUUIDString = String()
//    @Published var userPurchasedEPTAUUIDString = String()
//    @Published var finalPurchasedEHATestUUID: [String] = [String]()
//    @Published var finalPurchasedEPTATestUUID: [String] = [String]()
//    @Published var finalPurchasedTestTolken: [String] = [String]()
//    @Published var finalTestPurchased: [Int] = [Int]()  // 1 = Purchased The EHA Test, 2 = EPTA
// 
//    let fileTestPurchasedName = ["TestPurchase.json"]
//    let testPurchasedCSVName = "TestPurchaseCSV.csv"
//    let inputTestPurchasedCSVName = "InputTestPurchaseCSV.csv"
//    
//    @Published var saveFinalTestPurchase: SaveFinalTestPurchase? = nil
//    
//    func getTestPurchaseData() async {
//        guard let testPurchaseData = await getTestPurchseJSONData() else { return }
//        print("Json Test Purchase Data")
//        print(testPurchaseData)
//        let jsonTestPurchaseString = String(data: testPurchaseData, encoding: .utf8)
//        print(jsonTestPurchaseString!)
//        do {
//        self.saveFinalTestPurchase = try JSONDecoder().decode(SaveFinalTestPurchase.self, from: testPurchaseData)
//            print("JSON GetTestPurchaseData Run")
//            print("data: \(testPurchaseData)")
//        } catch let error {
//            print("!!!Error decoding test purchase json data: \(error)")
//        }
//    }
//    
//    func getTestPurchseJSONData() async -> Data? {
//        let saveFinalTestPurchase = SaveFinalTestPurchase (
//            jsonFinalPurchasedEHATestUUID: finalPurchasedEHATestUUID,
//            jsonFinalPurchasedEPTATestUUID: finalPurchasedEPTATestUUID,
//            jsonFinalPurchasedTestTolken: finalPurchasedTestTolken,
//            jsonFinalTestPurchased: finalTestPurchased)
//        let jsonTestPurchaseData = try? JSONEncoder().encode(saveFinalTestPurchase)
//        print("saveTestPurchase: \(saveFinalTestPurchase)")
//        print("Json Encoded \(jsonTestPurchaseData!)")
//        return jsonTestPurchaseData
//    }
//    
//    func saveTestPurchaseToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let testPurchasePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let purchaseDocumentsDirectory = testPurchasePaths[0]
//        print("purchaseDocumentsDirectory: \(purchaseDocumentsDirectory)")
//        let testPurchaseFilePaths = purchaseDocumentsDirectory.appendingPathComponent(fileTestPurchasedName[0])
//        print(testPurchaseFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonTestPurchaseData = try encoder.encode(saveFinalTestPurchase)
//            print(jsonTestPurchaseData)
//          
//            try jsonTestPurchaseData.write(to: testPurchaseFilePaths)
//        } catch {
//            print("Error writing to JSON Test Purchase file: \(error)")
//        }
//    }
//
//    func writeTestPurchaseToCSV() async {
//        print("writeTestPurchaseToCSV Start")
//        let stringFinalPurchasedEHATestUUID = "finalPurchasedEHATestUUID," + finalPurchasedEHATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedEPTATestUUID = "finalPurchasedEPTATestUUID," + finalPurchasedEPTATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedTestTolken = "finalTestTolkenPurchased," + finalPurchasedTestTolken.map { String($0) }.joined(separator: ",")
//        let stringFinalTestPurchased = "finalTestPurchased," + finalTestPurchased.map { String($0) }.joined(separator: ",")
//        do {
//            let csvTestPurchasePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvTestPurchaseDocumentsDirectory = csvTestPurchasePath
//            print("CSV Test Purchase DocumentsDirectory: \(csvTestPurchaseDocumentsDirectory)")
//            let csvTestPurchaseFilePath = csvTestPurchaseDocumentsDirectory.appendingPathComponent(testPurchasedCSVName)
//            print(csvTestPurchaseFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvTestPurchaseFilePath, append: false)
//            try writerSetup.write(row: [stringFinalPurchasedEHATestUUID])
//            try writerSetup.write(row: [stringFinalPurchasedEPTATestUUID])
//            try writerSetup.write(row: [stringFinalPurchasedTestTolken])
//            try writerSetup.write(row: [stringFinalTestPurchased])
//            print("CVS Test Purchase Writer Success")
//        } catch {
//            print("CVSWriter Test Purchase Error or Error Finding File for Test Purchase CSV \(error.localizedDescription)")
//        }
//    }
//    
//    func writeInputTestPurchaseToCSV() async {
//        print("writeInputTestSelectionToCSV Start")
//        let stringFinalPurchasedEHATestUUID = finalPurchasedEHATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedEPTATestUUID = finalPurchasedEPTATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedTestTolken = finalPurchasedTestTolken.map { String($0) }.joined(separator: ",")
//        let stringFinalTestPurchased = finalTestPurchased.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputTestPurchasePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputTestPurchaseDocumentsDirectory = csvInputTestPurchasePath
//            print("CSV Input Test Purchase DocumentsDirectory: \(csvInputTestPurchaseDocumentsDirectory)")
//            let csvInputTestPurchaseFilePath = csvInputTestPurchaseDocumentsDirectory.appendingPathComponent(inputTestPurchasedCSVName)
//            print(csvInputTestPurchaseFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputTestPurchaseFilePath, append: false)
//            try writerSetup.write(row: [stringFinalPurchasedEHATestUUID])
//            try writerSetup.write(row: [stringFinalPurchasedEPTATestUUID])
//            try writerSetup.write(row: [stringFinalPurchasedTestTolken])
//            try writerSetup.write(row: [stringFinalTestPurchased])
//            print("CVS Input Test Purchase Writer Success")
//        } catch {
//            print("CVSWriter Input Test Purchase Error or Error Finding File for Input Test Purchase CSV \(error.localizedDescription)")
//        }
//    }
//}
