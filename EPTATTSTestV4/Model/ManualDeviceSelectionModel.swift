//
//  ManualDeviceSelectionModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/1/22.
//

import Foundation
import CoreMedia
import AudioToolbox
import QuartzCore
import SwiftUI
import CoreData
import CodableCSV
//import Alamofire

struct SaveFinalManualDeviceSelection: Codable {  // This is a model
    var jsonFinalManualDeviceBrand = [String]()
    var jsonFinalManualDeviceModel = [String]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalManualDeviceBrand
        case jsonFinalManualDeviceModel
    }
}


class ManualDeviceSelectionModel: ObservableObject {
    
    //Manual Device Entry Variables
    @Published var userBrand = [String]()
    @Published var userModel = [String]()
    @Published var finalManualDeviceBrand: [String] = [String]()
    @Published var finalManualDeviceModel: [String] = [String]()
   
    let fileManualDeviceName = ["ManualDeviceSelection.json"]
    let manualDeviceCSVName = "ManualDeviceSelectionCSV.csv"
    let inputManualDeviceCSVName = "InputManualDeviceSelectionCSV.csv"
    
    @Published var saveFinalManualDeviceSelection: SaveFinalManualDeviceSelection? = nil

    func getManualDeviceData() async {
        guard let manualDeviceSelectionData = await getManualDeviceJSONData() else { return }
        print("Json Manual Device Selection Data:")
        print(manualDeviceSelectionData)
        let jsonManualDeviceSelectionString = String(data: manualDeviceSelectionData, encoding: .utf8)
        print(jsonManualDeviceSelectionString!)
        do {
        self.saveFinalManualDeviceSelection = try JSONDecoder().decode(SaveFinalManualDeviceSelection.self, from: manualDeviceSelectionData)
            print("JSON GetManualDeviceSelectionData Run")
            print("data: \(manualDeviceSelectionData)")
        } catch let error {
            print("!!!Error decoding Manual Device selection json data: \(error)")
        }
    }
    
    func getManualDeviceJSONData() async -> Data? {
        let saveFinalManualDeviceSelection = SaveFinalManualDeviceSelection (
            jsonFinalManualDeviceBrand: finalManualDeviceBrand,
            jsonFinalManualDeviceModel: finalManualDeviceBrand)
        let jsonManualDeviceData = try? JSONEncoder().encode(saveFinalManualDeviceSelection)
        print("saveFinalManualDeviceSelection: \(saveFinalManualDeviceSelection)")
        print("Json Manual Device Encoded \(jsonManualDeviceData!)")
        return jsonManualDeviceData
    }

    func saveManualDeviceToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let manualDevicePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = manualDevicePaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let manualDeviceFilePaths = documentsDirectory.appendingPathComponent(fileManualDeviceName[0])
        print(manualDeviceFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonManualDeviceData = try encoder.encode(saveFinalManualDeviceSelection)
            print(jsonManualDeviceData)
          
            try jsonManualDeviceData.write(to: manualDeviceFilePaths)
        } catch {
            print("Error writing to JSON Manual Device Selection file: \(error)")
        }
    }

    func writeManualDeviceResultsToCSV() async {
        print("writeManualDeviceSelectionToCSV Start")
        let stringFinalManualDeviceBrand = "finalManualDeviceBrand," + finalManualDeviceBrand.map { String($0) }.joined(separator: ",")
        let stringFinalManualDeviceModel = "finalManualDeviceModel," + finalManualDeviceModel.map { String($0) }.joined(separator: ",")
        do {
            let csvManualDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvManualDeviceDocumentsDirectory = csvManualDevicePath
            print("CSV Device Selection DocumentsDirectory: \(csvManualDeviceDocumentsDirectory)")
            let csvManualDeviceFilePath = csvManualDeviceDocumentsDirectory.appendingPathComponent(manualDeviceCSVName)
            print(csvManualDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvManualDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalManualDeviceBrand])
            try writerSetup.write(row: [stringFinalManualDeviceModel])
            print("CVS Manual Device Selection Writer Success")
        } catch {
            print("CVSWriter Manual Device Selection Error or Error Finding File for Manual Device Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputManualDeviceResultsToCSV() async {
        print("writeInputManualDeviceSelectionToCSV Start")
        let stringFinalManualDeviceBrand = finalManualDeviceBrand.map { String($0) }.joined(separator: ",")
        let stringFinalManualDeviceModel = finalManualDeviceModel.map { String($0) }.joined(separator: ",")
        do {
            let csvInputManualDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputManualDeviceDocumentsDirectory = csvInputManualDevicePath
            print("CSV Input Device Selection DocumentsDirectory: \(csvInputManualDeviceDocumentsDirectory)")
            let csvInputManualDeviceFilePath = csvInputManualDeviceDocumentsDirectory.appendingPathComponent(inputManualDeviceCSVName)
            print(csvInputManualDeviceFilePath)
            
            let writerSetup = try CSVWriter(fileURL: csvInputManualDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalManualDeviceBrand])
            try writerSetup.write(row: [stringFinalManualDeviceModel])
    
            print("CVS Input Manual Device Selection Writer Success")
        } catch {
            print("CVSWriter Input Manual Device Selection Error or Error Finding File for Input Manual Device Selection CSV \(error.localizedDescription)")
        }
    }
}
