//
//  SetupDataModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/21/22.
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
//struct SaveFinalSetupResults: Codable {  // This is a model
//    var id = Int()
//    var jsonUserAgreementAgreed = [Int]()
//    var jsonStringUserAgreementAgreedDate = String()
//    var jsonUserAgreementAgreedDate = [Date]()
//    var jsonFinalFirstName = [String]()
//    var jsonFinalLastName = [String]()
//    var jsonFinalEmail = [String]()
//    var jsonFinalPassword = [String]()
//    var jsonFinalAge = [Int]()
//    var jsonFinalGender = [String]()
//    var jsonFinalGenderIndex = [Int]()
//    var jsonFinalSex = [Int]()
//    var jsonUserUUID = [String]()
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case jsonUserAgreementAgreed
//        case jsonStringUserAgreementAgreedDate
//        case jsonUserAgreementAgreedDate
//        case jsonFinalFirstName
//        case jsonFinalLastName
//        case jsonFinalEmail
//        case jsonFinalPassword
//        case jsonFinalAge
//        case jsonFinalGender
//        case jsonFinalGenderIndex
//        case jsonFinalSex
//        case jsonUserUUID
//    }
//}
//
//class SetupDataModel: ObservableObject {
//
//
//    //Login Demographic Variables
//    @Published var userFirstName = [String]()
//    @Published var userLastName = [String]()
//    @Published var userEmail = [String]()
//    @Published var userPassword = [String]()
//    @Published var userAge = [Int]()
//    @Published var userBirthDate = [Date]()
//    @Published var userGender = [String]()
//    @Published var userGenderIndex = [Int]()
//    @Published var userSex = [Int]()
//    @Published var userUUIDString = [String]()
//
//    @Published var userAgreement = [Bool]()
//
//    @Published var finalUserAgreementAgreed: [Int] = [Int]()
//    @Published var finalUserAgreementAgreedDate: [Date] = [Date]()
//
//    // Demo Variables
//    @Published var finalFirstName: [String] = [String]()
//    @Published var finalLastName: [String] = [String]()
//    @Published var finalEmail: [String] = [String]()
//    @Published var finalPassword: [String] = [String]()
//    @Published var finalAge: [Int] = [Int]()
//    @Published var finalGender: [String] = [String]()
//    @Published var finalGenderIndex: [Int] = [Int]()
//    @Published var finalSex: [Int] = [Int]()
//    @Published var finalUserUUIDString: [String] = [String]()
//
//
//
//    @Published var stringJsonFUAADate = String()
//
//    @Published var stringFUAADate = String()
//    @Published var stringInputFUAADate = String()
//
//
//    let fileSetupName = ["SetupResults.json"]
//    let setupCSVName = "SetupResultsCSV.csv"
//    let inputSetupCSVName = "InputSetupResultsCSV.csv"
//
//    @Published var saveFinalSetupResults: SaveFinalSetupResults? = nil
//
//
//
//// Original JSON Functions that Overwrite data at each call with only data in that view. Seems like class variables are not persisting across views in this class
//    // JSON Variables
//    func getSetupData() async {
//        DispatchQueue.main.async {
//            Task(priority: .background) {
//                guard let setupData = await self.getDemoJSONData() else { return }
//                print("Json Setup Data:")
//                print(setupData)
//                let jsonSetupString = String(data: setupData, encoding: .utf8)
//                print(jsonSetupString!)
//                do {
//                    self.saveFinalSetupResults = try JSONDecoder().decode(SaveFinalSetupResults.self, from: setupData)
//                    print("JSON GetData Run")
//                    print("data: \(setupData)")
//                } catch let error {
//                    print("!!!Error decoding setup json data: \(error)")
//                }
//            }
//        }
//    }
//
//
//
//    func getDemoJSONData() async -> Data? {
//
//        let formatter3J = DateFormatter()
//        formatter3J.dateFormat = "HH:mm E, d MMM y"
//        if finalUserAgreementAgreedDate.count != 0 {
//            stringJsonFUAADate = formatter3J.string(from: finalUserAgreementAgreedDate[0])
//        } else {
//            print("finaluseragreementagreeddate is nil")
//        }
//
//        let saveFinalSetupResults = SaveFinalSetupResults (
//            id: 11111,
//            jsonUserAgreementAgreed: finalUserAgreementAgreed,
//            jsonStringUserAgreementAgreedDate: stringJsonFUAADate,
//            jsonUserAgreementAgreedDate: finalUserAgreementAgreedDate,
//            jsonFinalFirstName: finalFirstName,
//            jsonFinalLastName: finalLastName,
//            jsonFinalEmail: finalEmail,
//            jsonFinalPassword: finalPassword,
//            jsonFinalAge: finalAge,
//            jsonFinalGender: finalGender,
//            jsonFinalGenderIndex: finalGenderIndex,
//            jsonFinalSex: finalSex,
//            jsonUserUUID: finalUserUUIDString)
//
//        let jsonSetupData = try? JSONEncoder().encode(saveFinalSetupResults)
//        print("saveFinalResults: \(saveFinalSetupResults)")
//        print("Json Encoded \(jsonSetupData!)")
//        return jsonSetupData
//
//    }
//
//    func saveSetupToJSON() async {
//    // !!!This saves to device directory, whish is likely what is desired
//        let setupPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = setupPaths[0]
//        print("DocumentsDirectory: \(documentsDirectory)")
//        let setupFilePaths = documentsDirectory.appendingPathComponent(fileSetupName[0])
//        print(setupFilePaths)
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//            do {
//                let jsonSetupData = try encoder.encode(saveFinalSetupResults)
//                print(jsonSetupData)
//
//                try jsonSetupData.write(to: setupFilePaths)
//            } catch {
//                print("Error writing to JSON Setup file: \(error)")
//            }
//        }
//
//
//    func writeSetupResultsToCSV() async {
//        print("writeSetupResultsToCSV Start")
//        let formatter3 = DateFormatter()
//        formatter3.dateFormat = "HH:mm E, d MMM y"
//
//        if finalUserAgreementAgreedDate.count != 0 {
//            stringFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
//        } else {
//            print("finaluseragreementagreeddate is nil")
//        }
//
//
//        let stringFinalUserAgreementAgreed = "finalUserAgreementAgreed," + finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
//        let stringFinalUserAgreementAgreedDate = "finalUserAgreementAgreedDate," + stringFUAADate.map { String($0) }.joined(separator: ",")
//        let stringFinalFirstName = "finalFirstName," + finalFirstName.map { String($0) }.joined(separator: ",")
//        let stringFinalLastName = "finalLastName," + finalLastName.map { String($0) }.joined(separator: ",")
//        let stringFinalEmail = "finalEmail," + finalEmail.map { String($0) }.joined(separator: ",")
//        let stringFinalPassword = "finalPassword," + finalPassword.map { String($0) }.joined(separator: ",")
//        let stringFinalAge = "finalAge," + finalAge.map { String($0) }.joined(separator: ",")
//        let stringFinalGender = "finalGender," + finalGender.map { String($0) }.joined(separator: ",")
//        let stringFinalGenderIndex = "finalGenderIndex," + finalGenderIndex.map { String($0) }.joined(separator: ",")
//        let stringFinalSex = "finalSex," + finalSex.map { String($0) }.joined(separator: ",")
//        let stringFinalUserUUIDString = "finalUserUUIDString," + finalUserUUIDString.map { String($0) }.joined(separator: ",")
//
//        do {
//            let csvSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvSetupDocumentsDirectory = csvSetupPath
//            print("CSV Setup DocumentsDirectory: \(csvSetupDocumentsDirectory)")
//            let csvSetupFilePath = csvSetupDocumentsDirectory.appendingPathComponent(setupCSVName)
//            print(csvSetupFilePath)
//
//            let writerSetup = try CSVWriter(fileURL: csvSetupFilePath, append: false)
//
//            try writerSetup.write(row: [stringFinalUserAgreementAgreed])
//            try writerSetup.write(row: [stringFinalUserAgreementAgreedDate])
//            try writerSetup.write(row: [stringFinalFirstName])
//            try writerSetup.write(row: [stringFinalLastName])
//            try writerSetup.write(row: [stringFinalEmail])
//            try writerSetup.write(row: [stringFinalPassword])
//            try writerSetup.write(row: [stringFinalAge])
//            try writerSetup.write(row: [stringFinalGender])
//            try writerSetup.write(row: [stringFinalGenderIndex])
//            try writerSetup.write(row: [stringFinalSex])
//            try writerSetup.write(row: [stringFinalUserUUIDString])
//
//            print("CVS Setup Writer Success")
//        } catch {
//            print("CVSWriter Setup Error or Error Finding File for Setup CSV \(error.localizedDescription)")
//        }
//    }
//
//    func writeInputSetupResultsToCSV() async {
//        print("writeInputSetupResultsToCSV Start")
//        let formatter3 = DateFormatter()
//        formatter3.dateFormat = "HH:mm E, d MMM y"
//        if finalUserAgreementAgreedDate.count != 0 {
//            stringInputFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
//        } else {
//            print("finaluseragreementagreeddate is nil")
//        }
//        let stringFinalUserAgreementAgreed = finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
//        let stringFinalUserAgreementAgreedDate = stringFUAADate.map { String($0) }.joined(separator: ",")
//        let stringFinalFirstName = finalFirstName.map { String($0) }.joined(separator: ",")
//        let stringFinalLastName = finalLastName.map { String($0) }.joined(separator: ",")
//        let stringFinalEmail = finalEmail.map { String($0) }.joined(separator: ",")
//        let stringFinalPassword = finalPassword.map { String($0) }.joined(separator: ",")
//        let stringFinalAge = finalAge.map { String($0) }.joined(separator: ",")
//        let stringFinalGender = finalGender.map { String($0) }.joined(separator: ",")
//        let stringFinalGenderIndex = finalGenderIndex.map { String($0) }.joined(separator: ",")
//        let stringFinalSex = finalSex.map { String($0) }.joined(separator: ",")
//        let stringFinalUserUUIDString = finalUserUUIDString.map { String($0) }.joined(separator: ",")
//        do {
//            let csvInputSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//            let csvInputSetupDocumentsDirectory = csvInputSetupPath
//            print("CSV Input Setup DocumentsDirectory: \(csvInputSetupDocumentsDirectory)")
//            let csvInputSetupFilePath = csvInputSetupDocumentsDirectory.appendingPathComponent(inputSetupCSVName)
//            print(csvInputSetupFilePath)
//            let writerSetup = try CSVWriter(fileURL: csvInputSetupFilePath, append: false)
//            try writerSetup.write(row: [stringFinalUserAgreementAgreed])
//            try writerSetup.write(row: [stringFinalUserAgreementAgreedDate])
//            try writerSetup.write(row: [stringFinalFirstName])
//            try writerSetup.write(row: [stringFinalLastName])
//            try writerSetup.write(row: [stringFinalEmail])
//            try writerSetup.write(row: [stringFinalPassword])
//            try writerSetup.write(row: [stringFinalAge])
//            try writerSetup.write(row: [stringFinalGender])
//            try writerSetup.write(row: [stringFinalGenderIndex])
//            try writerSetup.write(row: [stringFinalSex])
//            try writerSetup.write(row: [stringFinalUserUUIDString])
//            print("CVS Input Setup Writer Success")
//        } catch {
//            print("CVSWriter Input Setup Error or Error Finding File for Input Setup CSV \(error.localizedDescription)")
//        }
//    }
//}


//New Attempt At JSON with Decode and Add Arrays
// THESE DID NOT WORK

//    func getJSONSetupDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//    var jsonSetupArray: [SaveFinalSetupResults] {
//        do {
//            let jsonSetupURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
//            let jsonSetupDocumentsDirectory = jsonSetupURL[0]
//            print("Json Setup DocumentsDirectory: \(jsonSetupDocumentsDirectory)")
//            let jsonSetupFilePaths = jsonSetupDocumentsDirectory.appendingPathComponent(fileSetupName[0])
//            print(jsonSetupFilePaths)
//            let jsonSetupData = try Data(contentsOf: jsonSetupFilePaths)
//            let decoder = JSONDecoder()
//            let saveFinalSetupResults = try decoder.decode([SaveFinalSetupResults].self, from: jsonSetupData)
//            print(jsonSetupData)
//            return saveFinalSetupResults
//        } catch {
//            print(error.localizedDescription)
//            return[]
//        }
//    }

//---------------
//    var jsonSetupArray: [SaveFinalSetupResults] {
//        do {
//            let jsonSetupURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
//            let jsonSetupDocumentsDirectory = jsonSetupURL[0]
//            print("Json Setup DocumentsDirectory: \(jsonSetupDocumentsDirectory)")
//            let jsonSetupFilePaths = jsonSetupDocumentsDirectory.appendingPathComponent(fileSetupName[0])
//            print(jsonSetupFilePaths)
//            do {
//                let jsonSetupData = try Data(contentsOf: jsonSetupFilePaths)
//            } catch {
//                print("!!!JsonSetupArray Errors")
//            }
//            let jsonSetupData = try! Data(contentsOf: jsonSetupFilePaths)
//            let decoder = JSONDecoder()
//            do {
//                let saveFinalSetupResults = try decoder.decode([SaveFinalSetupResults].self, from: jsonSetupData)
//                print(jsonSetupData)
//                return saveFinalSetupResults
//            } catch {
//                print(error.localizedDescription)
//                print("!!!Error in decoder")
//                return []
//            }
//        }
//    }
//-----------------------------

//    func writeJSONSetupData(saveFinalSetupResults: [SaveFinalSetupResults]) async {
//        do {
//            let jsonSetupURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
//            let jsonSetupDocumentsDirectory = jsonSetupURL[0]
//            print("Json Setup DocumentsDirectory: \(jsonSetupDocumentsDirectory)")
//            let jsonSetupFilePaths = jsonSetupDocumentsDirectory.appendingPathComponent(fileSetupName[0])
//            print(jsonSetupFilePaths)
//
//            let encoder = JSONEncoder()
//            try encoder.encode(jsonSetupArray).write(to: jsonSetupURL[0])
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    



