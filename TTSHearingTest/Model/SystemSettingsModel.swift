//
//  SystemSettingsModel.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/31/22.
//
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
//struct SaveSystemSettings: Codable {  // This is a model
//    var jsonFinalStartingSystemVolume = [Float]()
//
//    enum CodingKeys: String, CodingKey {
//        case jsonFinalStartingSystemVolume
//    }
//}
//
//class SystemSettingsModel: ObservableObject {
//
//    //System Setup Variables
//    @Published var silentModeStatus = [Bool]()
//    @Published var doNotDisturbStatus = [Bool]()
//    @Published var systemVolumeStatus = [Bool]()
//    @Published var finalStartingSystemVolume: [Float] = [Float]()
//
//
//
//    let fileSystemName = ["SystemSettings.json"]
//    let systemCSVName = "SystemSettingsCSV.csv"
//    let inputSystemCSVName = "InputSystemSettingsCSV.csv"
//
//    @Published var saveSystemSettings: SaveSystemSettings? = nil
//
//// Original JSON Functions that Overwrite data at each call with only data in that view. Seems like class variables are not persisting across views in this class
//    // JSON Variables
//    func getSystemData() async {
//        guard let systemSettingsData = await getSystemJSONData() else { return }
//        print("Json System Settings Data:")
//        print(systemSettingsData)
//        let jsonSystemSettingsString = String(data: systemSettingsData, encoding: .utf8)
//        print(jsonSystemSettingsString!)
//        do {
//        self.saveSystemSettings = try JSONDecoder().decode(SaveSystemSettings.self, from: systemSettingsData)
//            print("JSON Get System Settings Run")
//            print("data: \(systemSettingsData)")
//        } catch let error {
//            print("!!!Error decoding system Settings json data: \(error)")
//        }
//    }
//
//    func getSystemJSONData() async -> Data? {
//        let saveSystemSettings = SaveSystemSettings (
//        jsonFinalStartingSystemVolume: finalStartingSystemVolume)
//        let jsonSystemSettingsData = try? JSONEncoder().encode(saveSystemSettings)
//        print("saveFinalResults: \(saveSystemSettings)")
//        print("Json Encoded \(jsonSystemSettingsData!)")
//        return jsonSystemSettingsData
//    }
//
//    func saveSystemToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let systemPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = systemPaths[0]
//        print("DocumentsDirectory: \(documentsDirectory)")
//        let systemFilePaths = documentsDirectory.appendingPathComponent(fileSystemName[0])
//        print(systemFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonSystemData = try encoder.encode(saveSystemSettings)
//            print(jsonSystemData)
//
//            try jsonSystemData.write(to: systemFilePaths)
//        } catch {
//            print("Error writing to JSON System Settings file: \(error)")
//        }
//    }
//
//    func writeSystemResultsToCSV() async {
//        print("writeSystemResultsToCSV Start")
//        let stringFinalStartingSystemVolume = "finalStartingSystemVolume," + finalStartingSystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvSystemPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvSystemDocumentsDirectory = csvSystemPath
//            print("CSV System Settings DocumentsDirectory: \(csvSystemDocumentsDirectory)")
//            let csvSystemFilePath = csvSystemDocumentsDirectory.appendingPathComponent(systemCSVName)
//            print(csvSystemFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvSystemFilePath, append: false)
//            try writerSetup.write(row: [stringFinalStartingSystemVolume])
//            print("CVS System Settings Writer Success")
//        } catch {
//            print("CVSWriter System Settings Error or Error Finding File for System Settings CSV \(error.localizedDescription)")
//        }
//    }
//
//    func writeInputSystemResultsToCSV() async {
//        print("writeInputSystemResultsToCSV Start")
//        let stringFinalStartingSystemVolume = finalStartingSystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputSystemPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputSystemDocumentsDirectory = csvInputSystemPath
//            print("CSV Input System Settings DocumentsDirectory: \(csvInputSystemDocumentsDirectory)")
//            let csvInputSystemFilePath = csvInputSystemDocumentsDirectory.appendingPathComponent(inputSystemCSVName)
//            print(csvInputSystemFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputSystemFilePath, append: false)
//            try writerSetup.write(row: [stringFinalStartingSystemVolume])
//            print("CVS Input System Settings Writer Success")
//        } catch {
//            print("CVSWriter Input System Settings Error or Error Finding File for Input System Settings CSV \(error.localizedDescription)")
//        }
//    }
//}
