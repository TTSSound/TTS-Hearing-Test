//
//  SystemSettingsEndEHAModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

import Foundation
import CodableCSV


struct SaveSystemSettingsEndEHA: Codable {
    var jsonFinalEndingEHASystemVolume = [Float]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalEndingEHASystemVolume
    }
}


class SystemSettingsEndEHAModel: ObservableObject {
    
    @Published var finalEndingEHASystemVolume: [Float] = [Float]()
    
    let fileSystemEndEHAName = ["SystemSettingsEndEHA.json"]
    let systemEndEHACSVName = "SystemSettingsEndEHACSV.csv"
    let inputSystemEndEHACSVName = "InputSystemSettingsEndEHACSV.csv"
    
    @Published var saveSystemSettingsEndEHA: SaveSystemSettingsEndEHA? = nil
    
    
    func getSystemEndEHAData() async {
        guard let systemSettingsEndEHAData = await getSystemEndEHAJSONData() else { return }
        print("Json System Settings End EHA Data:")
        print(systemSettingsEndEHAData)
        let jsonSystemSettingsEndEHAString = String(data: systemSettingsEndEHAData, encoding: .utf8)
        print(jsonSystemSettingsEndEHAString!)
        do {
        self.saveSystemSettingsEndEHA = try JSONDecoder().decode(SaveSystemSettingsEndEHA.self, from: systemSettingsEndEHAData)
            print("JSON Get System Settings End EHA Run")
            print("data: \(systemSettingsEndEHAData)")
        } catch let error {
            print("!!!Error decoding system Settings End EHA json data: \(error)")
        }
    }
    
    func getSystemEndEHAJSONData() async -> Data? {
        let saveSystemSettingsEndEHA = SaveSystemSettingsEndEHA (
        jsonFinalEndingEHASystemVolume: finalEndingEHASystemVolume)
        let jsonSystemEndEHASettingsData = try? JSONEncoder().encode(saveSystemSettingsEndEHA)
        print("saveFinalResults: \(saveSystemSettingsEndEHA)")
        print("Json Encoded \(jsonSystemEndEHASettingsData!)")
        return jsonSystemEndEHASettingsData
    }
    
    func saveSystemEndEHAToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let systemEndEHAPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let endEHADocumentsDirectory = systemEndEHAPaths[0]
        print("endEHADocumentsDirectory: \(endEHADocumentsDirectory)")
        let systemEndEHAFilePaths = endEHADocumentsDirectory.appendingPathComponent(fileSystemEndEHAName[0])
        print(systemEndEHAFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemEndEHAData = try encoder.encode(saveSystemSettingsEndEHA)
            print(jsonSystemEndEHAData)
            try jsonSystemEndEHAData.write(to: systemEndEHAFilePaths)
        } catch {
            print("Error writing to JSON System End EHA Settings file: \(error)")
        }
    }

    func writeSystemEndEHAResultsToCSV() async {
        print("writeSystemEndEHAResultsToCSV Start")
        let stringfinalEndingEHASystemVolume = "finalEndingEHASystemVolume," + finalEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvSystemEndEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemEndEHADocumentsDirectory = csvSystemEndEHAPath
            print("CSV System End EHA Settings DocumentsDirectory: \(csvSystemEndEHADocumentsDirectory)")
            let csvSystemEndEHAFilePath = csvSystemEndEHADocumentsDirectory.appendingPathComponent(systemEndEHACSVName)
            print(csvSystemEndEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemEndEHAFilePath, append: false)
            try writerSetup.write(row: [stringfinalEndingEHASystemVolume])
            print("CVS System End EHA Settings Writer Success")
        } catch {
            print("CVSWriter System End EHA Settings Error or Error Finding File for System End EHA Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemEndEHAResultsToCSV() async {
        print("writeInputSystemInterimResultsToCSV Start")
        let stringfinalEndingEHASystemVolume = finalEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSystemEndEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemEndEHADocumentsDirectory = csvInputSystemEndEHAPath
            print("CSV Input System End EHA Settings DocumentsDirectory: \(csvInputSystemEndEHADocumentsDirectory)")
            let csvInputSystemEndEHAFilePath = csvInputSystemEndEHADocumentsDirectory.appendingPathComponent(inputSystemEndEHACSVName)
            print(csvInputSystemEndEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemEndEHAFilePath, append: false)
            try writerSetup.write(row: [stringfinalEndingEHASystemVolume])
            print("CVS Input System Interim Settings Writer Success")
        } catch {
            print("CVSWriter Input System Interim Settings Error or Error Finding File for Input System Settings CSV \(error.localizedDescription)")
        }
    }
}

