//
//  TestSelectionModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/31/22.
//

import Foundation
import CoreMedia
import AudioToolbox
import QuartzCore
import SwiftUI
import CoreData
import CodableCSV
//import Alamofire


struct SaveFinalTestSelection: Codable {  // This is a model
    var jsonFinalSelectedEHATest = [Int]()
    var jsonFinalSelectedEPTATest = [Int]()
    var jsonFinalSelectedSimpleTest = [Int]()
    var jsonSelectedSimpleTestUUID = [String]()
    var jsonFinalTestSelected = [Int]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalSelectedEHATest
        case jsonFinalSelectedEPTATest
        case jsonFinalSelectedSimpleTest
        case jsonSelectedSimpleTestUUID
        case jsonFinalTestSelected
    }
}

class TestSelectionModel: ObservableObject {
    
    @Published var finalSelectedEHATest: [Int] = [Int]()
    @Published var finalSelectedEPTATest: [Int] = [Int]()
    @Published var finalSelectedSimpleTest: [Int] = [Int]()
    @Published var finalSelectedSimpleTestUUID: [String] = [String]()  // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
    @Published var finalTestSelected: [Int] = [Int]()
    
    let fileTestSelectionName = ["TestSelection.json"]
    let testSelectionCSVName = "TestSelectionCSV.csv"
    let inputTestSelectionCSVName = "InputTestSelectionCSV.csv"
    
    @Published var saveFinalTestSelection: SaveFinalTestSelection? = nil

    
    func getTestSelectionData() async {
        guard let testSelectionData = await getTestSelectionJSONData() else { return }
        print("Json Test Selection Data:")
        print(testSelectionData)
        let jsonTestSelectionString = String(data: testSelectionData, encoding: .utf8)
        print(jsonTestSelectionString!)
        do {
        self.saveFinalTestSelection = try JSONDecoder().decode(SaveFinalTestSelection.self, from: testSelectionData)
            print("JSON GetTestSelectionData Run")
            print("data: \(testSelectionData)")
        } catch let error {
            print("!!!Error decoding test selection json data: \(error)")
        }
    }
 
    func getTestSelectionJSONData() async -> Data? {
        
        let saveFinalTestSelection = SaveFinalTestSelection (
            jsonFinalSelectedEHATest: finalSelectedEHATest,
            jsonFinalSelectedEPTATest: finalSelectedEPTATest,
            jsonFinalSelectedSimpleTest: finalSelectedSimpleTest,
            jsonSelectedSimpleTestUUID: finalSelectedSimpleTestUUID,
            jsonFinalTestSelected: finalTestSelected)

        let jsonTestSelectionData = try? JSONEncoder().encode(saveFinalTestSelection)
        print("saveTestSelection: \(saveFinalTestSelection)")
        print("Json Encoded \(jsonTestSelectionData!)")
        return jsonTestSelectionData
    }
    
    func saveTestSelectionToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let testSelectionPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = testSelectionPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let testSelectionFilePaths = documentsDirectory.appendingPathComponent(fileTestSelectionName[0])
        print(testSelectionFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
            do {
                let jsonTestSelectionData = try encoder.encode(saveFinalTestSelection)
                print(jsonTestSelectionData)
              
                try jsonTestSelectionData.write(to: testSelectionFilePaths)
            } catch {
                print("Error writing to JSON Test Selection file: \(error)")
            }
        }

    
    func writeTestSelectionToCSV() async {
        print("writeTestSelectionToCSV Start")
        let stringFinalSelectedEHATest = "finalSelectedEHATest," + finalSelectedEHATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedEPTATest = "finalSelectedEPTATest," + finalSelectedEPTATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTest = "finalSelectedSimpleTest," + finalSelectedSimpleTest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTestUUID = "finalSelectedSimpleTestUUID," + finalSelectedSimpleTestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalTestSelected = "finalTestSelected," + finalTestSelected.map { String($0) }.joined(separator: ",")
        do {
            let csvTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvTestDocumentsDirectory = csvTestPath
            print("CSV Test Selection DocumentsDirectory: \(csvTestDocumentsDirectory)")
            let csvTestFilePath = csvTestDocumentsDirectory.appendingPathComponent(testSelectionCSVName)
            print(csvTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvTestFilePath, append: false)
            try writerSetup.write(row: [stringFinalSelectedEHATest])
            try writerSetup.write(row: [stringFinalSelectedEPTATest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTestUUID])
            try writerSetup.write(row: [stringFinalTestSelected])
            print("CVS Test Selection Writer Success")
        } catch {
            print("CVSWriter Test Selection Error or Error Finding File for Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputTestSelectionToCSV() async {
        print("writeInputTestSelectionToCSV Start")
        let stringFinalSelectedEHATest = finalSelectedEHATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedEPTATest = finalSelectedEPTATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTest = finalSelectedSimpleTest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTestUUID = finalSelectedSimpleTestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalTestSelected = finalTestSelected.map { String($0) }.joined(separator: ",")
        do {
            let csvInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputTestDocumentsDirectory = csvInputTestPath
            print("CSV Input Test Selection DocumentsDirectory: \(csvInputTestDocumentsDirectory)")
            let csvInputTestFilePath = csvInputTestDocumentsDirectory.appendingPathComponent(inputTestSelectionCSVName)
            print(csvInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputTestFilePath, append: false)
            try writerSetup.write(row: [stringFinalSelectedEHATest])
            try writerSetup.write(row: [stringFinalSelectedEPTATest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTestUUID])
            try writerSetup.write(row: [stringFinalTestSelected])
            print("CVS Input Test Selection Writer Success")
        } catch {
            print("CVSWriter Input Test Selection Error or Error Finding File for Input Test Selection CSV \(error.localizedDescription)")
        }
    }
}

//Test Selection Input File Exists
//FileView(headers: [], rows: [["1"], [""], ["ED7AB070-21E6-4313-934E-8150EE8CA76B"]], _lookup: [:])
//Test Selection Results Read
//rows: ColumnsView(_file: CodableCSV.CSVReader.FileView(headers: [], rows: [["1"], [""], ["ED7AB070-21E6-4313-934E-8150EE8CA76B"]], _lookup: [:]))
