//
//  SystemSettingsEndEPTASimpleModel.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

//import Foundation
//import CodableCSV
//
//struct SaveSystemSettingsEndEPTASimple: Codable {
//
//    var jsonFinalEndingSystemVolume = [Float]()
//
//    enum CodingKeys: String, CodingKey {
//        case jsonFinalEndingSystemVolume
//    }
//}
//
//class SystemSettingsEndEPTASimpleModel: ObservableObject {
//
//    @Published var finalEndingSystemVolume: [Float] = [Float]()
//
//    let fileSystemSettingsEndName = ["EndEPTASimpleSystemSettings.json"]
//    let systemSettingsEndCSVName = "EndEPTASimpleSystemSettingsCSV.csv"
//    let inputSystemSettingsEndCSVName = "InputEndEPTASimpleSystemSettingsCSV.csv"
//
//    @Published var saveSystemSettingsEndEPTASimple: SaveSystemSettingsEndEPTASimple? = nil
//
//    func getSystemEndData() async {
//        guard let systemSettingsEndData = await getSystemEndJSONData() else { return }
//        print("Json System Settings End Data:")
//        print(systemSettingsEndData)
//        let jsonSystemSettingsEndString = String(data: systemSettingsEndData, encoding: .utf8)
//        print(jsonSystemSettingsEndString!)
//        do {
//        self.saveSystemSettingsEndEPTASimple = try JSONDecoder().decode(SaveSystemSettingsEndEPTASimple.self, from: systemSettingsEndData)
//            print("JSON Get System End Settings Run")
//            print("data: \(systemSettingsEndData)")
//        } catch let error {
//            print("!!!Error decoding system Settings End json data: \(error)")
//        }
//    }
//
//    func getSystemEndJSONData() async -> Data? {
//        let saveSystemSettingsEndEPTASimple = SaveSystemSettingsEndEPTASimple (
//        jsonFinalEndingSystemVolume: finalEndingSystemVolume)
//        let jsonSystemSettingsEndData = try? JSONEncoder().encode(saveSystemSettingsEndEPTASimple)
//        print("saveFinalResults: \(saveSystemSettingsEndEPTASimple)")
//        print("Json Encoded \(jsonSystemSettingsEndData!)")
//        return jsonSystemSettingsEndData
//    }
//
//    func saveSystemEndToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let systemEndPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let endDocumentsDirectory = systemEndPaths[0]
//        print("endDocumentsDirectory: \(endDocumentsDirectory)")
//        let systemEndFilePaths = endDocumentsDirectory.appendingPathComponent(fileSystemSettingsEndName[0])
//        print(systemEndFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonSystemEndData = try encoder.encode(saveSystemSettingsEndEPTASimple)
//            print(jsonSystemEndData)
//
//            try jsonSystemEndData.write(to: systemEndFilePaths)
//        } catch {
//            print("Error writing to JSON System End Settings file: \(error)")
//        }
//    }
//
//    func writeSystemEndResultsToCSV() async {
//        print("writeSystemEndResultsToCSV Start")
//        let stringFinalEndingSystemVolume = "finalEndingSystemVolume," + finalEndingSystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvSystemEndPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvSystemEndDocumentsDirectory = csvSystemEndPath
//            print("CSV System End Settings DocumentsDirectory: \(csvSystemEndDocumentsDirectory)")
//            let csvSystemEndFilePath = csvSystemEndDocumentsDirectory.appendingPathComponent(systemSettingsEndCSVName)
//            print(csvSystemEndFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvSystemEndFilePath, append: false)
//            try writerSetup.write(row: [stringFinalEndingSystemVolume])
//            print("CVS System End Settings Writer Success")
//        } catch {
//            print("CVSWriter System End Settings Error or Error Finding File for System End Settings CSV \(error.localizedDescription)")
//        }
//    }
//
//    func writeInputSystemEndResultsToCSV() async {
//        print("writeInputSystemEndResultsToCSV Start")
//        let stringFinalEndingSystemVolume = finalEndingSystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputSystemEndPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputSystemEndDocumentsDirectory = csvInputSystemEndPath
//            print("CSV Input System End Settings DocumentsDirectory: \(csvInputSystemEndDocumentsDirectory)")
//            let csvInputSystemEndFilePath = csvInputSystemEndDocumentsDirectory.appendingPathComponent(inputSystemSettingsEndCSVName)
//            print(csvInputSystemEndFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputSystemEndFilePath, append: false)
//            try writerSetup.write(row: [stringFinalEndingSystemVolume])
//            print("CVS Input System End Settings Writer Success")
//        } catch {
//            print("CVSWriter Input System End Settings Error or Error Finding File for Input System End Settings CSV \(error.localizedDescription)")
//        }
//    }
//}
