//
//  ManualDisclaimerModel.swift
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

struct SaveFinalManualDisclaimerAgreement: Codable {  // This is a model
    var jsonFinalUncalibratedUserAgreementAgreed = [Bool]()
    var jsonStringFinalUncalibratedUserAgreementAgreedDate = String()
    var jsonFinalUncalibratedUserAgreementAgreedDate = [Date]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalUncalibratedUserAgreementAgreed
        case jsonStringFinalUncalibratedUserAgreementAgreedDate
        case jsonFinalUncalibratedUserAgreementAgreedDate
    }
}


class ManualDisclaimerModel: ObservableObject {
    
    @Published var uncalibratedUserAgreement = [Bool]()
    @Published var finalUncalibratedUserAgreementAgreed: [Bool] = [Bool]()
    @Published var finalUncalibratedUserAgreementAgreedDate: [Date] = [Date]()
    @Published var stringJsonFUUAADate = String()
    @Published var stringFUUAADate = String()
    @Published var stringInputFUUAADate = String()
    
    let fileManualDisclaimerName = ["ManualDisclaimerAgreement.json"]
    let manuaDisclaimerCSVName = "ManualDisclaimerAgreementCSV.csv"
    let inputManuaDisclaimerCSVName = "InputManualDisclaimerAgreementCSV.csv"
    
    @Published var saveFinalManualDisclaimerAgreement: SaveFinalManualDisclaimerAgreement? = nil
    
    func getManualDisclaimerData() async {
        guard let manualDisclaimerAgreementData = await getManualDisclaimerJSONData() else { return }
        print("Json Manual Device Selection Data:")
        print(manualDisclaimerAgreementData)
        let jsonManualDisclaimerAgreementString = String(data: manualDisclaimerAgreementData, encoding: .utf8)
        print(jsonManualDisclaimerAgreementString!)
        do {
        self.saveFinalManualDisclaimerAgreement = try JSONDecoder().decode(SaveFinalManualDisclaimerAgreement.self, from: manualDisclaimerAgreementData)
            print("JSON GetManualDisclaimerAgreementData Run")
            print("data: \(manualDisclaimerAgreementData)")
        } catch let error {
            print("!!!Error decoding Manual Disclaimer Agreement json data: \(error)")
        }
    }
    
    func getManualDisclaimerJSONData() async -> Data? {
        let formatter3D = DateFormatter()
        formatter3D.dateFormat = "HH:mm E, d MMM y"
        if finalUncalibratedUserAgreementAgreedDate.count != 0 {
            stringJsonFUUAADate = formatter3D.string(from: finalUncalibratedUserAgreementAgreedDate[0])
        } else {
            print("finaluncalibrateduseragreementdata is nil")
        }
        let saveFinalManualDisclaimerAgreement = SaveFinalManualDisclaimerAgreement (
            jsonFinalUncalibratedUserAgreementAgreed: finalUncalibratedUserAgreementAgreed,
            jsonStringFinalUncalibratedUserAgreementAgreedDate: stringJsonFUUAADate,
            jsonFinalUncalibratedUserAgreementAgreedDate: finalUncalibratedUserAgreementAgreedDate)

            let jsonManDisclaimerData = try? JSONEncoder().encode(saveFinalManualDisclaimerAgreement)
            print("saveFinalManualDeviceSelection: \(saveFinalManualDisclaimerAgreement)")
            print("Json Manual Device Encoded \(jsonManDisclaimerData!)")
            return jsonManDisclaimerData
    }

    func saveManualDisclaimerToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let manualDisclaimerPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = manualDisclaimerPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let manualDisclaimerFilePaths = documentsDirectory.appendingPathComponent(fileManualDisclaimerName[0])
        print(manualDisclaimerFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
            do {
                let jsonManDisclaimerData = try encoder.encode(saveFinalManualDisclaimerAgreement)
                print(jsonManDisclaimerData)
              
                try jsonManDisclaimerData.write(to: manualDisclaimerFilePaths)
            } catch {
                print("Error writing to JSON Manual Disclaimer Agreement file: \(error)")
            }
        }

    func writeManualDisclaimerToCSV() async {
        print("writeManualDisclaimerSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"

        if finalUncalibratedUserAgreementAgreedDate.count != 0 {
            stringFUUAADate = formatter3.string(from: finalUncalibratedUserAgreementAgreedDate[0])
        } else {
            print("finaluncalibrateduseragreementdata is nil")
        }

        let stringFinalUncalibratedUserAgreementAgreed = "finalUncalibratedUserAgreementAgreed," + finalUncalibratedUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUncalibratedUserAgreementAgreedDate = "stringFinalUncalibratedUserAgreementAgreedDate," + stringFUUAADate
        let stringMapFinalUncalibratedUserAgreementAgreedDate = "finalUncalibratedUserAgreementAgreedDate," + stringFUUAADate.map { String($0) }.joined(separator: ",")
    
        do {
            let csvManualDisclaimerPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvManualDisclaimerDocumentsDirectory = csvManualDisclaimerPath
            print("CSV Device Selection DocumentsDirectory: \(csvManualDisclaimerDocumentsDirectory)")
            let csvManualDisclaimerFilePath = csvManualDisclaimerDocumentsDirectory.appendingPathComponent(manuaDisclaimerCSVName)
            print(csvManualDisclaimerFilePath)
            
            let writerSetup = try CSVWriter(fileURL: csvManualDisclaimerFilePath, append: false)
            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreed])
            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreedDate])
            try writerSetup.write(row: [stringMapFinalUncalibratedUserAgreementAgreedDate])

            print("CVS Manual Disclaimer Writer Success")
        } catch {
            print("CVSWriter Manual Disclaimer Error or Error Finding File for Manual Disclaimer CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputManualDisclaimerToCSV() async {
        print("writeInputManualDisclaimerSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalUncalibratedUserAgreementAgreedDate.count != 0 {
            stringInputFUUAADate = formatter3.string(from: finalUncalibratedUserAgreementAgreedDate[0])
        } else {
            print("finaluncalibrateduseragreementdata is nil")
        }
        let stringFinalUncalibratedUserAgreementAgreed = finalUncalibratedUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUncalibratedUserAgreementAgreedDate = stringFUUAADate
        let stringMapFinalUncalibratedUserAgreementAgreedDate = stringFUUAADate.map { String($0) }.joined(separator: ",")
        do {
            let csvInputManualDisclaimerPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputManualDisclaimerDocumentsDirectory = csvInputManualDisclaimerPath
            print("CSV Input Device Selection DocumentsDirectory: \(csvInputManualDisclaimerDocumentsDirectory)")
            let csvInputManualDisclaimerFilePath = csvInputManualDisclaimerDocumentsDirectory.appendingPathComponent(inputManuaDisclaimerCSVName)
            print(csvInputManualDisclaimerFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputManualDisclaimerFilePath, append: false)
            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreed])
            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreedDate])
            try writerSetup.write(row: [stringMapFinalUncalibratedUserAgreementAgreedDate])

            print("CVS Input Manual Disclaimer Writer Success")
        } catch {
            print("CVSWriter Input Manual Disclaimer Error or Error Finding File for Input Manual Disclaimer CSV \(error.localizedDescription)")
        }
    }
}
