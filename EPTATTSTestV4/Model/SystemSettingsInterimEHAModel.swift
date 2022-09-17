//
//  SystemSettingsInterimEHAModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

//import Foundation
//import CodableCSV
//
//struct SaveSystemSettingsInterimEHA: Codable {
//    var jsonFinalInterimEndingEHASystemVolume = [Float]()
//
//    enum CodingKeys: String, CodingKey {
//        case jsonFinalInterimEndingEHASystemVolume
//    }
//}
//
//
//class SystemSettingsInterimEHAModel: ObservableObject {
//    
//    @Published var finalInterimEndingEHASystemVolume: [Float] = [Float]()
//    @Published var finalInterimStartingEHASystemVolume: [Float] = [Float]()
//    
//    let fileSystemInterimEHAName = ["SystemSettingsInterimEHA.json"]
//    let systemInterimEHACSVName = "SystemSettingsInterimEHACSV.csv"
//    let inputSystemInterimEHACSVName = "InputSystemSettingsInterimEHACSV.csv"
//    
//    @Published var saveSystemSettingsInterimEHA: SaveSystemSettingsInterimEHA? = nil
//    
//    func getInterimEndData() async {
//        guard let systemSettingsInterimData = await getSystemInterimJSONData() else { return }
//        print("Json System Settings Interim Data:")
//        print(systemSettingsInterimData)
//        let jsonSystemSettingsInterimString = String(data: systemSettingsInterimData, encoding: .utf8)
//        print(jsonSystemSettingsInterimString!)
//        do {
//        self.saveSystemSettingsInterimEHA = try JSONDecoder().decode(SaveSystemSettingsInterimEHA.self, from: systemSettingsInterimData)
//            print("JSON Get System Interim Settings Run")
//            print("data: \(systemSettingsInterimData)")
//        } catch let error {
//            print("!!!Error decoding system Settings Interim json data: \(error)")
//        }
//    }
//    
//    func getSystemInterimJSONData() async -> Data? {
//        let saveSystemSettingsInterimEHA = SaveSystemSettingsInterimEHA (
//        jsonFinalInterimEndingEHASystemVolume: finalInterimEndingEHASystemVolume)
//        let jsonSystemInterimSettingsData = try? JSONEncoder().encode(saveSystemSettingsInterimEHA)
//        print("saveFinalResults: \(saveSystemSettingsInterimEHA)")
//        print("Json Encoded \(jsonSystemInterimSettingsData!)")
//        return jsonSystemInterimSettingsData
//    }
//    
//    func saveSystemInterimToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let systemInterimPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let interimDocumentsDirectory = systemInterimPaths[0]
//        print("interimDocumentsDirectory: \(interimDocumentsDirectory)")
//        let systemInterimFilePaths = interimDocumentsDirectory.appendingPathComponent(fileSystemInterimEHAName[0])
//        print(systemInterimFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonSystemInterimData = try encoder.encode(saveSystemSettingsInterimEHA)
//            print(jsonSystemInterimData)
//            try jsonSystemInterimData.write(to: systemInterimFilePaths)
//        } catch {
//            print("Error writing to JSON System Interim Settings file: \(error)")
//        }
//    }
//
//    func writeSystemInterimResultsToCSV() async {
//        print("writeSystemInterimResultsToCSV Start")
//        let stringFinalInterimEndingEHASystemVolume = "finalInterimEndingEHASystemVolume," + finalInterimEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvSystemInterimPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvSystemInterimDocumentsDirectory = csvSystemInterimPath
//            print("CSV System Interim Settings DocumentsDirectory: \(csvSystemInterimDocumentsDirectory)")
//            let csvSystemInterimFilePath = csvSystemInterimDocumentsDirectory.appendingPathComponent(systemInterimEHACSVName)
//            print(csvSystemInterimFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvSystemInterimFilePath, append: false)
//            try writerSetup.write(row: [stringFinalInterimEndingEHASystemVolume])
//            print("CVS System Settings Writer Success")
//        } catch {
//            print("CVSWriter System Settings Error or Error Finding File for System Settings CSV \(error.localizedDescription)")
//        }
//    }
//    
//    func writeInputSystemInterimResultsToCSV() async {
//        print("writeInputSystemInterimResultsToCSV Start")
//        let stringFinalInterimEndingEHASystemVolume = finalInterimEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputSystemInterimPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputSystemInterimDocumentsDirectory = csvInputSystemInterimPath
//            print("CSV Input System Interim Settings DocumentsDirectory: \(csvInputSystemInterimDocumentsDirectory)")
//            let csvInputSystemInterimFilePath = csvInputSystemInterimDocumentsDirectory.appendingPathComponent(inputSystemInterimEHACSVName)
//            print(csvInputSystemInterimFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputSystemInterimFilePath, append: false)
//            try writerSetup.write(row: [stringFinalInterimEndingEHASystemVolume])
//            print("CVS Input System Interim Settings Writer Success")
//        } catch {
//            print("CVSWriter Input System Interim Settings Error or Error Finding File for Input System Settings CSV \(error.localizedDescription)")
//        }
//    }
//}
