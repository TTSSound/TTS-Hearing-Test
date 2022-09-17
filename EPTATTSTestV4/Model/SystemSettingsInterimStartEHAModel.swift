//
//  SystemSettingsInterimStartEHAModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

//import Foundation
//import CodableCSV
//
//struct SaveSystemSettingsInterimStartEHA: Codable {
//    var jsonFinalInterimStartingEHASystemVolume = [Float]()
//    var jsonFinalInterimStartingEHASilentMode = Int()
//
//    enum CodingKeys: String, CodingKey {
//        case jsonFinalInterimStartingEHASystemVolume
//        case jsonFinalInterimStartingEHASilentMode
//    }
//}
//
//class SystemSettingsInterimStartEHAModel: ObservableObject {
//   
//    @Published var finalInterimStartingEHASystemVolume: [Float] = [Float]()
//    @Published var finalInterimStartingEHASilentMode: [Int] = [Int]()
//    
//    let fileSystemInterimStartingEHAName = ["SystemSettingsInterimStartingEHA.json"]
//    let systemInterimStartingEHACSVName = "SystemSettingsInterimStartingEHACSV.csv"
//    let inputSystemInterimStartingEHACSVName = "InputSystemSettingsInterimStartingEHACSV.csv"
//    
//    @Published var saveSystemSettingsInterimStartEHA: SaveSystemSettingsInterimStartEHA? = nil
//    
//    func getInterimStartingEHAData() async {
//        guard let systemSettingsInterimStartingEHAData = await getSystemInterimStartingEHAJSONData() else { return }
//        print("Json System Settings Interim Starting EHA Data:")
//        print(systemSettingsInterimStartingEHAData)
//        let jsonSystemSettingsInterimStartingEHAString = String(data: systemSettingsInterimStartingEHAData, encoding: .utf8)
//        print(jsonSystemSettingsInterimStartingEHAString!)
//        do {
//        self.saveSystemSettingsInterimStartEHA = try JSONDecoder().decode(SaveSystemSettingsInterimStartEHA.self, from: systemSettingsInterimStartingEHAData)
//            print("JSON Get System Interim Starting EHA Settings Run")
//            print("data: \(systemSettingsInterimStartingEHAData)")
//        } catch let error {
//            print("!!!Error decoding system Settings Interim Starting EHA json data: \(error)")
//        }
//    }
//    
//    func getSystemInterimStartingEHAJSONData() async -> Data? {
//        let saveSystemSettingsInterimStartEHA = SaveSystemSettingsInterimStartEHA (
//        jsonFinalInterimStartingEHASystemVolume: finalInterimStartingEHASystemVolume)
//        let jsonSystemInterimStartingEHASettingsData = try? JSONEncoder().encode(saveSystemSettingsInterimStartEHA)
//        print("saveFinalResults: \(saveSystemSettingsInterimStartEHA)")
//        print("Json Encoded \(jsonSystemInterimStartingEHASettingsData!)")
//        return jsonSystemInterimStartingEHASettingsData
//    }
//    
//    func saveSystemInterimStartingEHAToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let systemInterimStartingEHAPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let interimStartingEHADocumentsDirectory = systemInterimStartingEHAPaths[0]
//        print("interimStartingEHADocumentsDirectory: \(interimStartingEHADocumentsDirectory)")
//        let systemInterimStartingEHAFilePaths = interimStartingEHADocumentsDirectory.appendingPathComponent(fileSystemInterimStartingEHAName[0])
//        print(systemInterimStartingEHAFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonSystemInterimStartingEHAData = try encoder.encode(saveSystemSettingsInterimStartEHA)
//            print(jsonSystemInterimStartingEHAData)
//            try jsonSystemInterimStartingEHAData.write(to: systemInterimStartingEHAFilePaths)
//        } catch {
//            print("Error writing to JSON System Interim Starting EHA Settings file: \(error)")
//        }
//    }
//
//    func writeSystemInterimStartingEHAResultsToCSV() async {
//        print("writeSystemInterimStartingEHAResultsToCSV Start")
//        let stringFinalInterimStartingEHASystemVolume = "finalInterimStartingEHASystemVolume," + finalInterimStartingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        let stringFinalInterimStartingEHASilentMode = "finalInterimStartingEHASilentMode," + finalInterimStartingEHASilentMode.map { String($0) }.joined(separator: "'")
//        do {
//            let csvSystemInterimStartingEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvSystemInterimStartingEHADocumentsDirectory = csvSystemInterimStartingEHAPath
//            print("CSV System Interim Starting EHA Settings DocumentsDirectory: \(csvSystemInterimStartingEHADocumentsDirectory)")
//            let csvSystemInterimStartingEHAFilePath = csvSystemInterimStartingEHADocumentsDirectory.appendingPathComponent(systemInterimStartingEHACSVName)
//            print(csvSystemInterimStartingEHAFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvSystemInterimStartingEHAFilePath, append: false)
//            try writerSetup.write(row: [stringFinalInterimStartingEHASystemVolume])
//            try writerSetup.write(row: [stringFinalInterimStartingEHASilentMode])
//            print("CVS System Starting EHA Settings Writer Success")
//        } catch {
//            print("CVSWriter System Starting EHA Settings Error or Error Finding File for System Starting EHA Settings CSV \(error.localizedDescription)")
//        }
//    }
//    
//    func writeInputSystemInterimStartingEHAResultsToCSV() async {
//        print("writeInputSystemInterimStartingEHAResultsToCSV Start")
//
//        let stringFinalInterimStartingEHASystemVolume = finalInterimStartingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        let stringFinalInterimStartingEHASilentMode = finalInterimStartingEHASilentMode.map { String($0) }.joined(separator: "'")
//        do {
//            let csvInputSystemInterimStartingEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputSystemInterimStartingEHADocumentsDirectory = csvInputSystemInterimStartingEHAPath
//            print("CSV Input System Interim Starting EHA Settings DocumentsDirectory: \(csvInputSystemInterimStartingEHADocumentsDirectory)")
//            let csvInputSystemInterimStartingEHAFilePath = csvInputSystemInterimStartingEHADocumentsDirectory.appendingPathComponent(inputSystemInterimStartingEHACSVName)
//            print(csvInputSystemInterimStartingEHAFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputSystemInterimStartingEHAFilePath, append: false)
//            try writerSetup.write(row: [stringFinalInterimStartingEHASystemVolume])
//            try writerSetup.write(row: [stringFinalInterimStartingEHASilentMode])
//            print("CVS Input System Interim Starting EHA Settings Writer Success")
//        } catch {
//            print("CVSWriter Input System Interim Starting EHA Settings Error or Error Finding File for Input System Starting EHA Settings CSV \(error.localizedDescription)")
//        }
//    }
//}
