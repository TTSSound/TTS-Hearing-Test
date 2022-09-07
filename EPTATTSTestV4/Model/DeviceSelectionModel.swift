//
//  DeviceSelectionModel.swift
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

struct SaveFinalDeviceSelection: Codable {  // This is a model
    var jsonFinalDevicSelectionName = [String]()
    var jsonFinalDeviceSelectionIndex = [Int]()
    var jsonStringFinalDeviceSelectionUUID = [String]()
    var jsonFinalDeviceSelectionUUID = [UUID]()
    var jsonFinalHeadphoneModelIsUnknownIndex = [Int]()
//    var jsonFinalUncalibratedUserAgreementAgreed = [Bool]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalDevicSelectionName
        case jsonFinalDeviceSelectionIndex
        case jsonStringFinalDeviceSelectionUUID
        case jsonFinalDeviceSelectionUUID
        case jsonFinalHeadphoneModelIsUnknownIndex
    }
}


class DeviceSelectionModel: ObservableObject {
    
    //Calibration Assessment Variables
    @Published var deviceSelection = [Int]()
    @Published var userSelectedDeviceName = [String]()
    @Published var userSelectedDeviceUUID = [UUID]()
    @Published var userSelectedDeviceIndex = [Int]()
    @Published var headphoneModelsUnknownIndex = [Int]()
    @Published var manualDeviceEntryRequired = [Int]()
    @Published var finalDevicSelectionName: [String] = [String]()
    @Published var finalDeviceSelectionIndex: [Int] = [Int]()
    @Published var finalDeviceSelectionUUID: [UUID] = [UUID]()
    @Published var finalHeadphoneModelIsUnknownIndex: [Int] = [Int]()
    @Published var stringJsonFDSUUID = [String]()
    @Published var stringFDSUUID = [String]()
    @Published var stringInputFDSUUID = [String]()
    
    let fileDeviceName = ["DeviceSelection.json"]
    let deviceCSVName = "DeviceSelectionCSV.csv"
    let inputDeviceCSVName = "InputDeviceSelectionCSV.csv"
    
    @Published var saveFinalDeviceSelection: SaveFinalDeviceSelection? = nil

    func getDeviceData() async {
        guard let deviceSelectionData = await getDeviceJSONData() else { return }
        print("Json Device Selection Data:")
        print(deviceSelectionData)
        let jsonDeviceSelectionString = String(data: deviceSelectionData, encoding: .utf8)
        print(jsonDeviceSelectionString!)
        do {
        self.saveFinalDeviceSelection = try JSONDecoder().decode(SaveFinalDeviceSelection.self, from: deviceSelectionData)
            print("JSON GetDeviceSelectionData Run")
            print("data: \(deviceSelectionData)")
        } catch let error {
            print("!!!Error decoding Device selection json data: \(error)")
        }
    }
    
    func getDeviceJSONData() async -> Data? {
        let formatter3J = DateFormatter()
        formatter3J.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringJsonFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let saveFinalDeviceSelection = SaveFinalDeviceSelection (
            jsonFinalDevicSelectionName: finalDevicSelectionName,
            jsonFinalDeviceSelectionIndex: finalDeviceSelectionIndex,
            jsonStringFinalDeviceSelectionUUID: stringJsonFDSUUID,
            jsonFinalDeviceSelectionUUID: finalDeviceSelectionUUID,
            jsonFinalHeadphoneModelIsUnknownIndex: finalHeadphoneModelIsUnknownIndex)
        let jsonDeviceData = try? JSONEncoder().encode(saveFinalDeviceSelection)
        print("saveFinalDeviceSelection: \(saveFinalDeviceSelection)")
        print("Json Encoded \(jsonDeviceData!)")
        return jsonDeviceData
    }

    func saveDeviceToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let devicePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = devicePaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let deviceFilePaths = documentsDirectory.appendingPathComponent(fileDeviceName[0])
        print(deviceFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonDeviceData = try encoder.encode(saveFinalDeviceSelection)
            print(jsonDeviceData)
          
            try jsonDeviceData.write(to: deviceFilePaths)
        } catch {
            print("Error writing to JSON Device Selection file: \(error)")
        }
    }

    func writeDeviceResultsToCSV() async {
        print("writeDeviceSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let stringFinalDevicSelectionName = "finalDevicSelectionName," +  finalDevicSelectionName.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionIndex = "finalDeviceSelectionIndex," + finalDeviceSelectionIndex.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionUUID = "finalDeviceSelectionUUID," + stringFDSUUID.map { String($0) }.joined(separator: ",")
        let stringFinalHeadphoneModelIsUnknownIndex = "finalHeadphoneModelIsUnknownIndex," + finalHeadphoneModelIsUnknownIndex.map { String($0) }.joined(separator: ",")
        do {
            let csvDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvDeviceDocumentsDirectory = csvDevicePath
            print("CSV Device Selection DocumentsDirectory: \(csvDeviceDocumentsDirectory)")
            let csvDeviceFilePath = csvDeviceDocumentsDirectory.appendingPathComponent(deviceCSVName)
            print(csvDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalDevicSelectionName])
            try writerSetup.write(row: [stringFinalDeviceSelectionIndex])
            try writerSetup.write(row: [stringFinalDeviceSelectionUUID])
            try writerSetup.write(row: [stringFinalHeadphoneModelIsUnknownIndex])
            print("CVS Device Selection Writer Success")
        } catch {
            print("CVSWriter Device Selection Error or Error Finding File for Device Selection CSV \(error.localizedDescription)")
        }
    
    }
    
    func writeInputDeviceResultsToCSV() async {
        print("writeInputDeviceSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringInputFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let stringFinalDevicSelectionName = finalDevicSelectionName.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionIndex = finalDeviceSelectionIndex.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionUUID = stringFDSUUID.map { String($0) }.joined(separator: ",")
        let stringFinalHeadphoneModelIsUnknownIndex = finalHeadphoneModelIsUnknownIndex.map { String($0) }.joined(separator: ",")
        do {
            let csvInputDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputDeviceDocumentsDirectory = csvInputDevicePath
            print("CSV Input Device Selection DocumentsDirectory: \(csvInputDeviceDocumentsDirectory)")
            let csvInputDeviceFilePath = csvInputDeviceDocumentsDirectory.appendingPathComponent(inputDeviceCSVName)
            print(csvInputDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalDevicSelectionName])
            try writerSetup.write(row: [stringFinalDeviceSelectionIndex])
            try writerSetup.write(row: [stringFinalDeviceSelectionUUID])
            try writerSetup.write(row: [stringFinalHeadphoneModelIsUnknownIndex])
            print("CVS Input Device Selection Writer Success")
        } catch {
            print("CVSWriter Input Device Selection Error or Error Finding File for Input Device Selection CSV \(error.localizedDescription)")
        }
    
    }
}
