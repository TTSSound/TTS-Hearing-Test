//
//  SetupDataModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/21/22.
//

import Foundation
import CoreMedia
import AudioToolbox
import QuartzCore
import SwiftUI
import CoreData
import CodableCSV
//import Alamofire


struct SaveFinalSetupResults: Codable {  // This is a model
    var id = Int()
    var jsonUserAgreementAgreed = [Int]()
    var jsonStringUserAgreementAgreedDate = String()
    var jsonUserAgreementAgreedDate = [Date]()
    var jsonFinalFirstName = [String]()
    var jsonFinalLastName = [String]()
    var jsonFinalEmail = [String]()
    var jsonFinalPassword = [String]()
    var jsonFinalAge = [Int]()
    var jsonFinalGender = [String]()
    var jsonFinalGenderIndex = [Int]()
    var jsonFinalSex = [Int]()
    var jsonUserUUID = [String]()
//    var jsonFinalSelectedEHATest = [Int]()
//    var jsonFinalSelectedEPTATest = [Int]()
//    var jsonFinalSelectedSimpleTest = [Int]()
//    var jsonSelectedEHATestUUID = [String]()
//    var jsonSelectedEPTATestUUID = [String]()
//    var jsonSelectedSimpleTestUUID = [String]()
//    var jsonFinalTestTolken = [String]()
//    var jsonFinalTestSelected = [Int]()
//    var jsonFinalDevicSelectionName = [String]()
//    var jsonFinalDeviceSelectionIndex = [Int]()
//    var jsonStringFinalDeviceSelectionUUID = [String]()
//    var jsonFinalDeviceSelectionUUID = [UUID]()
//    var jsonFinalHeadphoneModelIsUnknownIndex = [Int]()
//    var jsonFinalUncalibratedUserAgreementAgreed = [Bool]()
//    var jsonStringFinalUncalibratedUserAgreementAgreedDate = String()
//    var jsonFinalUncalibratedUserAgreementAgreedDate = [Date]()
//    var jsonFinalManualDeviceBrand = [String]()
//    var jsonFinalManualDeviceModel = [String]()
//    var jsonFinalStartingSystemVolume = [Float]()
//    var jsonFinalQuestion1responses = [Int]()
//    var jsonFinalQuestion2responses = [Int]()
//    var jsonFinalQuestion3responses = [Int]()
//    var jsonFinalQuestion4responses = [Int]()
//    var jsonFinalQuestion5responses = [Int]()
//    var jsonFinalQuestion6responses = [Int]()
//    var jsonFinalQuestion7responses = [Int]()
//    var jsonFinalQuestion8responses = [Int]()
//    var jsonFinalQuestion9responses = [Int]()
//    var jsonFinalQuestion10responses = [Int]()
//    var jsonFinalNoResponses = [Int]()
//    var jsonFinalSometimesResponses = [Int]()
//    var jsonFinalYesResponses = [Int]()
//    var jsonFinalSummaryResponseScore = [Int]()
//    var jsonFinalEndingSystemVolume = [Float]()
//    var jsonFinalInterimEndingEHASystemVolume = [Float]()
//    var jsonFinalInterimStartingEHASystemVolume = [Float]()
//    var jsonFinalEndingEHASystemVolume = [Float]()


    enum CodingKeys: String, CodingKey {
        case id
        case jsonUserAgreementAgreed
        case jsonStringUserAgreementAgreedDate
        case jsonUserAgreementAgreedDate
        case jsonFinalFirstName
        case jsonFinalLastName
        case jsonFinalEmail
        case jsonFinalPassword
        case jsonFinalAge
        case jsonFinalGender
        case jsonFinalGenderIndex
        case jsonFinalSex
        case jsonUserUUID
//        case jsonFinalSelectedEHATest
//        case jsonFinalSelectedEPTATest
//        case jsonFinalSelectedSimpleTest
//        case jsonSelectedEHATestUUID
//        case jsonSelectedEPTATestUUID
//        case jsonSelectedSimpleTestUUID
//        case jsonFinalTestTolken
//        case jsonFinalTestSelected
//        case jsonFinalDevicSelectionName
//        case jsonFinalDeviceSelectionIndex
//        case jsonStringFinalDeviceSelectionUUID
//        case jsonFinalDeviceSelectionUUID
//        case jsonFinalHeadphoneModelIsUnknownIndex
//        case jsonFinalUncalibratedUserAgreementAgreed
//        case jsonStringFinalUncalibratedUserAgreementAgreedDate
//        case jsonFinalUncalibratedUserAgreementAgreedDate
//        case jsonFinalManualDeviceBrand
//        case jsonFinalManualDeviceModel
//        case jsonFinalStartingSystemVolume
//        case jsonFinalQuestion1responses
//        case jsonFinalQuestion2responses
//        case jsonFinalQuestion3responses
//        case jsonFinalQuestion4responses
//        case jsonFinalQuestion5responses
//        case jsonFinalQuestion6responses
//        case jsonFinalQuestion7responses
//        case jsonFinalQuestion8responses
//        case jsonFinalQuestion9responses
//        case jsonFinalQuestion10responses
//        case jsonFinalNoResponses
//        case jsonFinalSometimesResponses
//        case jsonFinalYesResponses
//        case jsonFinalSummaryResponseScore
//        case jsonFinalEndingSystemVolume
//        case jsonFinalInterimEndingEHASystemVolume
//        case jsonFinalInterimStartingEHASystemVolume
//        case jsonFinalEndingEHASystemVolume
    }
}

class SetupDataModel: ObservableObject {
    
    
    //Login Demographic Variables
    @Published var userFirstName = [String]()
    @Published var userLastName = [String]()
    @Published var userEmail = [String]()
    @Published var userPassword = [String]()
    @Published var userAge = [Int]()
    @Published var userBirthDate = [Date]()
    @Published var userGender = [String]()
    @Published var userGenderIndex = [Int]()
    @Published var userSex = [Int]()
    @Published var userUUIDString = [String]()
    
    // Test Selection Holding Variables
//    @Published var userSelectedEHATest = [Int]()
//    @Published var userSelectedEPTATest = [Int]()
//    @Published var userSelectedSimpleTest = [Int]()
//    @Published var userSelectedSimpleTestUUIDString = [String]()
 
//    //Purchasing Variables
//    @Published var userPurchasedTest = [Int]()   // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
//    @Published var userPurchasedEHAUUIDString = String()
//    @Published var userPurchasedEPTAUUIDString = String()
  
    
    //System Setup Variables
//    @Published var silentModeStatus = [Bool]()
//    @Published var doNotDisturbStatus = [Bool]()
//    @Published var systemVolumeStatus = [Bool]()
    @Published var userAgreement = [Bool]()
//    @Published var deviceSelection = [Int]()
    
//    @Published var uncalibratedUserAgreement = [Bool]()

//    //Calibration Assessment Variables
//    @Published var userSelectedDeviceName = [String]()
//    @Published var userSelectedDeviceUUID = [UUID]()
//    @Published var userSelectedDeviceIndex = [Int]()
//    @Published var headphoneModelsUnknownIndex = [Int]()
//    @Published var manualDeviceEntryRequired = [Int]()
//
//    //Manual Device Entry Variables
//    @Published var userBrand = [String]()
//    @Published var userModel = [String]()
    
    //Hearing Self Assessment Variables
//    @Published var hhsiNoResponses = [Int]()
//    @Published var hhsiSometimesResponses = [Int]()
//    @Published var hhsiYesResponses = [Int]()
//    @Published var hhsiScore = [Int]()
      
    
  
//Final Demo Setup Variables
    
    //Final Result Variables for Writing
    @Published var finalUserAgreementAgreed: [Int] = [Int]()
    @Published var finalUserAgreementAgreedDate: [Date] = [Date]()
    
    // Demo Variables
    @Published var finalFirstName: [String] = [String]()
    @Published var finalLastName: [String] = [String]()
    @Published var finalEmail: [String] = [String]()
    @Published var finalPassword: [String] = [String]()
    @Published var finalAge: [Int] = [Int]()
    @Published var finalGender: [String] = [String]()
    @Published var finalGenderIndex: [Int] = [Int]()
    @Published var finalSex: [Int] = [Int]()
    @Published var finalUserUUIDString: [String] = [String]()
    

    //Purchasing Variables and Test Selection
//    @Published var finalSelectedEHATest = [Int]()
//    @Published var finalSelectedEPTATest = [Int]()
//    @Published var finalSelectedSimpleTest = [Int]()
//    @Published var finalPurchasedEHATestUUID = [String]()
//    @Published var finalPurchasedEPTATestUUID = [String]()
//    @Published var finalSelectedSimpleTestUUID = [String]()  // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
//    @Published var finalTestTolken: [String] = [String]()
//    @Published var finalTestSelected: [Int] = [Int]()
    
//    @Published var finalDevicSelectionName: [String] = [String]()
//    @Published var finalDeviceSelectionIndex: [Int] = [Int]()
//    @Published var finalDeviceSelectionUUID: [UUID] = [UUID]()
//    @Published var finalHeadphoneModelIsUnknownIndex: [Int] = [Int]()
//
//    @Published var finalUncalibratedUserAgreementAgreed: [Bool] = [Bool]()
//    @Published var finalUncalibratedUserAgreementAgreedDate: [Date] = [Date]()
//
//    @Published var finalManualDeviceBrand: [String] = [String]()
//    @Published var finalManualDeviceModel: [String] = [String]()

//    @Published var finalStartingSystemVolume: [Float] = [Float]()

//    @Published var finalQuestion1responses: [Int] = [Int]()
//    @Published var finalQuestion2responses: [Int] = [Int]()
//    @Published var finalQuestion3responses: [Int] = [Int]()
//    @Published var finalQuestion4responses: [Int] = [Int]()
//    @Published var finalQuestion5responses: [Int] = [Int]()
//    @Published var finalQuestion6responses: [Int] = [Int]()
//    @Published var finalQuestion7responses: [Int] = [Int]()
//    @Published var finalQuestion8responses: [Int] = [Int]()
//    @Published var finalQuestion9responses: [Int] = [Int]()
//    @Published var finalQuestion10responses: [Int] = [Int]()
//
//    @Published var finalNoResponses: [Int] = [Int]()
//    @Published var finalSometimesResponses: [Int] = [Int]()
//    @Published var finalYesResponses: [Int] = [Int]()
//    @Published var finalSummaryResponseScore: [Int] = [Int]()


//    @Published var finalEndingSystemVolume: [Float] = [Float]()
//    @Published var finalInterimEndingEHASystemVolume: [Float] = [Float]()
//    @Published var finalInterimStartingEHASystemVolume: [Float] = [Float]()
//    @Published var finalInterimStartingEHASilentMode: [Int] = [Int]()
//    @Published var finalEndingEHASystemVolume: [Float] = [Float]()
    
    
    @Published var stringJsonFUAADate = String()
//    @Published var stringJsonFUUAADate = String()
//    @Published var stringJsonFDSUUID = [String]()
    
    @Published var stringFUAADate = String()
    @Published var stringInputFUAADate = String()
//    @Published var stringFUUAADate = String()
//    @Published var stringFDSUUID = [String]()
    
    
    let fileSetupName = ["SetupResults.json"]
    let setupCSVName = "SetupResultsCSV.csv"
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    
    @Published var saveFinalSetupResults: SaveFinalSetupResults? = nil

    

// Original JSON Functions that Overwrite data at each call with only data in that view. Seems like class variables are not persisting across views in this class
    // JSON Variables
    func getSetupData() async {
        guard let setupData = await getDemoJSONData() else { return }
        print("Json Setup Data:")
        print(setupData)
        let jsonSetupString = String(data: setupData, encoding: .utf8)
        print(jsonSetupString!)
        do {
        self.saveFinalSetupResults = try JSONDecoder().decode(SaveFinalSetupResults.self, from: setupData)
            print("JSON GetData Run")
            print("data: \(setupData)")
        } catch let error {
            print("!!!Error decoding setup json data: \(error)")
        }
    }
    

    
    func getDemoJSONData() async -> Data? {
        let formatter3J = DateFormatter()
        formatter3J.dateFormat = "HH:mm E, d MMM y"
        if finalUserAgreementAgreedDate.count != 0 {
            stringJsonFUAADate = formatter3J.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
//        if finalUncalibratedUserAgreementAgreedDate.count != 0 {
//            stringJsonFUUAADate = formatter3J.string(from: finalUncalibratedUserAgreementAgreedDate[0])
//        } else {
//            print("finaluncalibrateduseragreementdata is nil")
//        }
//        if finalDeviceSelectionUUID.count != 0 {
//            stringJsonFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
//        } else {
//            print("finalDeviceSelectionUUID is nil")
//        }
        
        let saveFinalSetupResults = SaveFinalSetupResults (
            id: 11111,
            jsonUserAgreementAgreed: finalUserAgreementAgreed,
            jsonStringUserAgreementAgreedDate: stringJsonFUAADate,
            jsonUserAgreementAgreedDate: finalUserAgreementAgreedDate,
            jsonFinalFirstName: finalFirstName,
            jsonFinalLastName: finalLastName,
            jsonFinalEmail: finalEmail,
            jsonFinalPassword: finalPassword,
            jsonFinalAge: finalAge,
            jsonFinalGender: finalGender,
            jsonFinalGenderIndex: finalGenderIndex,
            jsonFinalSex: finalSex,
            jsonUserUUID: finalUserUUIDString)
//            jsonFinalSelectedEHATest: finalSelectedEHATest,
//            jsonFinalSelectedEPTATest: finalSelectedEPTATest,
//            jsonFinalSelectedSimpleTest: finalSelectedSimpleTest,
//            jsonSelectedEHATestUUID: finalPurchasedEHATestUUID,
//            jsonSelectedEPTATestUUID: finalPurchasedEPTATestUUID,
//            jsonSelectedSimpleTestUUID: finalSelectedSimpleTestUUID,
//            jsonFinalTestTolken: finalTestTolken,
//            jsonFinalTestSelected: finalTestSelected,
//            jsonFinalDevicSelectionName: finalDevicSelectionName,
//            jsonFinalDeviceSelectionIndex: finalDeviceSelectionIndex,
//            jsonStringFinalDeviceSelectionUUID: stringJsonFDSUUID,
//            jsonFinalDeviceSelectionUUID: finalDeviceSelectionUUID,
//            jsonFinalHeadphoneModelIsUnknownIndex: finalHeadphoneModelIsUnknownIndex,
//            jsonFinalUncalibratedUserAgreementAgreed: finalUncalibratedUserAgreementAgreed,
//            jsonStringFinalUncalibratedUserAgreementAgreedDate: stringJsonFUUAADate,
//            jsonFinalUncalibratedUserAgreementAgreedDate: finalUncalibratedUserAgreementAgreedDate,
//            jsonFinalManualDeviceBrand: finalManualDeviceBrand,
//            jsonFinalManualDeviceModel: finalManualDeviceBrand,
//            jsonFinalStartingSystemVolume: finalStartingSystemVolume,
//            jsonFinalQuestion1responses: finalQuestion1responses,
//            jsonFinalQuestion2responses: finalQuestion2responses,
//            jsonFinalQuestion3responses: finalQuestion3responses,
//            jsonFinalQuestion4responses: finalQuestion4responses,
//            jsonFinalQuestion5responses: finalQuestion5responses,
//            jsonFinalQuestion6responses: finalQuestion6responses,
//            jsonFinalQuestion7responses: finalQuestion7responses,
//            jsonFinalQuestion8responses: finalQuestion8responses,
//            jsonFinalQuestion9responses: finalQuestion9responses,
//            jsonFinalQuestion10responses: finalQuestion10responses,
//            jsonFinalNoResponses: finalNoResponses,
//            jsonFinalSometimesResponses: finalSometimesResponses,
//            jsonFinalYesResponses: finalYesResponses,
//            jsonFinalSummaryResponseScore: finalSummaryResponseScore,
//            jsonFinalEndingSystemVolume: finalEndingSystemVolume,
//            jsonFinalInterimEndingEHASystemVolume: finalInterimEndingEHASystemVolume,
//            jsonFinalInterimStartingEHASystemVolume: finalInterimStartingEHASystemVolume,
//            jsonFinalEndingEHASystemVolume: finalEndingEHASystemVolume)

        let jsonSetupData = try? JSONEncoder().encode(saveFinalSetupResults)
        print("saveFinalResults: \(saveFinalSetupResults)")
        print("Json Encoded \(jsonSetupData!)")
        return jsonSetupData
    }
    
    func saveSetupToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let setupPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = setupPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let setupFilePaths = documentsDirectory.appendingPathComponent(fileSetupName[0])
        print(setupFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
            do {
                let jsonSetupData = try encoder.encode(saveFinalSetupResults)
                print(jsonSetupData)
              
                try jsonSetupData.write(to: setupFilePaths)
            } catch {
                print("Error writing to JSON Setup file: \(error)")
            }
        }

    
    func writeSetupResultsToCSV() async {
        print("writeSetupResultsToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        
        if finalUserAgreementAgreedDate.count != 0 {
            stringFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
//        if finalUncalibratedUserAgreementAgreedDate.count != 0 {
//            stringFUUAADate = formatter3.string(from: finalUncalibratedUserAgreementAgreedDate[0])
//        } else {
//            print("finaluncalibrateduseragreementdata is nil")
//        }
//        if finalDeviceSelectionUUID.count != 0 {
//            stringFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
//        } else {
//            print("finalDeviceSelectionUUID is nil")
//        }
        
        
        let stringFinalUserAgreementAgreed = "finalUserAgreementAgreed," + finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUserAgreementAgreedDate = "finalUserAgreementAgreedDate," + stringFUAADate.map { String($0) }.joined(separator: ",")
        let stringFinalFirstName = "finalFirstName," + finalFirstName.map { String($0) }.joined(separator: ",")
        let stringFinalLastName = "finalLastName," + finalLastName.map { String($0) }.joined(separator: ",")
        let stringFinalEmail = "finalEmail," + finalEmail.map { String($0) }.joined(separator: ",")
        let stringFinalPassword = "finalPassword," + finalPassword.map { String($0) }.joined(separator: ",")
        let stringFinalAge = "finalAge," + finalAge.map { String($0) }.joined(separator: ",")
        let stringFinalGender = "finalGender," + finalGender.map { String($0) }.joined(separator: ",")
        let stringFinalGenderIndex = "finalGenderIndex," + finalGenderIndex.map { String($0) }.joined(separator: ",")
        let stringFinalSex = "finalSex," + finalSex.map { String($0) }.joined(separator: ",")
        let stringFinalUserUUIDString = "finalUserUUIDString," + finalUserUUIDString.map { String($0) }.joined(separator: ",")
//        let stringFinalSelectedEHATest = "finalSelectedEHATest," + finalSelectedEHATest.map { String($0) }.joined(separator: ",")
//        let stringFinalSelectedEPTATest = "finalSelectedEPTATest," + finalSelectedEPTATest.map { String($0) }.joined(separator: ",")
//        let stringFinalSelectedSimpleTest = "finalSelectedSimpleTest," + finalSelectedSimpleTest.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedEHATestUUID = "finalPurchasedEHATestUUID," + finalPurchasedEHATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalPurchasedEPTATestUUID = "finalPurchasedEPTATestUUID," + finalPurchasedEPTATestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalSelectedSimpleTestUUID = "finalSelectedSimpleTestUUID," + finalSelectedSimpleTestUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalTestTolken = "finalTestTolken," + finalTestTolken.map { String($0) }.joined(separator: ",")
//        let stringFinalTestSelected = "finalTestSelected," + finalTestSelected.map { String($0) }.joined(separator: ",")
//        let stringFinalDevicSelectionName = "finalDevicSelectionName," +  finalDevicSelectionName.map { String($0) }.joined(separator: ",")
//        let stringFinalDeviceSelectionIndex = "finalDeviceSelectionIndex," + finalDeviceSelectionIndex.map { String($0) }.joined(separator: ",")
//        let stringFinalDeviceSelectionUUID = "finalDeviceSelectionUUID," + stringFDSUUID.map { String($0) }.joined(separator: ",")
////        let stringFinalDeviceSelectionUUID = finalDeviceSelectionUUID.map { ($0).uuidString }.joined(separator: ",")
////        let stringFinalDeviceSelectionUUID = finalDeviceSelectionUUID.map { String($0) }.joined(separator: ",")
//        let stringFinalHeadphoneModelIsUnknownIndex = "finalHeadphoneModelIsUnknownIndex," + finalHeadphoneModelIsUnknownIndex.map { String($0) }.joined(separator: ",")
//        let stringFinalUncalibratedUserAgreementAgreed = "finalUncalibratedUserAgreementAgreed," + finalUncalibratedUserAgreementAgreed.map { String($0) }.joined(separator: ",")
//        let stringFinalUncalibratedUserAgreementAgreedDate = "finalUncalibratedUserAgreementAgreedDate," + stringFUUAADate.map { String($0) }.joined(separator: ",")
//        let stringFinalManualDeviceBrand = "finalManualDeviceBrand," + finalManualDeviceBrand.map { String($0) }.joined(separator: ",")
//        let stringFinalManualDeviceModel = "finalManualDeviceModel," + finalManualDeviceModel.map { String($0) }.joined(separator: ",")
//        let stringFinalStartingSystemVolume = "finalStartingSystemVolume," + finalStartingSystemVolume.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion1responses = "finalQuestion1responses," + finalQuestion1responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion2responses = "finalQuestion2responses," + finalQuestion2responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion3responses = "finalQuestion3responses," + finalQuestion3responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion4responses = "finalQuestion4responses," + finalQuestion4responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion5responses = "finalQuestion5responses," + finalQuestion5responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion6responses = "finalQuestion6responses," + finalQuestion6responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion7responses = "finalQuestion7responses," + finalQuestion7responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion8responses = "finalQuestion8responses," + finalQuestion8responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion9responses = "finalQuestion9responses," + finalQuestion9responses.map { String($0) }.joined(separator: ",")
//        let stringFinalQuestion10responses = "finalQuestion10responses," + finalQuestion10responses.map { String($0) }.joined(separator: ",")
//        let stringFinalNoResponses = "finalNoResponses," + finalNoResponses.map { String($0) }.joined(separator: ",")
//        let stringFinalSometimesResponses = "finalSometimesResponses," + finalSometimesResponses.map { String($0) }.joined(separator: ",")
//        let stringFinalYesResponses = "finalYesResponses," + finalYesResponses.map { String($0) }.joined(separator: ",")
//        let stringFinalSummaryResponseScore = "finalSummaryResponseScore," + finalSummaryResponseScore.map { String($0) }.joined(separator: ",")
//        let stringFinalEndingSystemVolume = "finalEndingSystemVolume," + finalEndingSystemVolume.map { String($0) }.joined(separator: ",")
//        let stringFinalInterimEndingEHASystemVolume = "finalInterimEndingEHASystemVolume," + finalInterimEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        let stringFinalInterimStartingEHASystemVolume = "finalInterimStartingEHASystemVolume," + finalInterimStartingEHASystemVolume.map { String($0) }.joined(separator: ",")
//        let stringfinalEndingEHASystemVolume = "finalEndingEHASystemVolume," + finalEndingEHASystemVolume.map { String($0) }.joined(separator: ",")


        do {
            let csvSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSetupDocumentsDirectory = csvSetupPath
            print("CSV Setup DocumentsDirectory: \(csvSetupDocumentsDirectory)")
            let csvSetupFilePath = csvSetupDocumentsDirectory.appendingPathComponent(setupCSVName)
            print(csvSetupFilePath)
            
            let writerSetup = try CSVWriter(fileURL: csvSetupFilePath, append: false)
        
            try writerSetup.write(row: [stringFinalUserAgreementAgreed])
            try writerSetup.write(row: [stringFinalUserAgreementAgreedDate])
            try writerSetup.write(row: [stringFinalFirstName])
            try writerSetup.write(row: [stringFinalLastName])
            try writerSetup.write(row: [stringFinalEmail])
            try writerSetup.write(row: [stringFinalPassword])
            try writerSetup.write(row: [stringFinalAge])
            try writerSetup.write(row: [stringFinalGender])
            try writerSetup.write(row: [stringFinalGenderIndex])
            try writerSetup.write(row: [stringFinalSex])
            try writerSetup.write(row: [stringFinalUserUUIDString])
//            try writerSetup.write(row: [stringFinalSelectedEHATest])
//            try writerSetup.write(row: [stringFinalSelectedEPTATest])
//            try writerSetup.write(row: [stringFinalSelectedSimpleTest])
//            try writerSetup.write(row: [stringFinalPurchasedEHATestUUID])
//            try writerSetup.write(row: [stringFinalPurchasedEPTATestUUID])
//            try writerSetup.write(row: [stringFinalSelectedSimpleTestUUID])
//            try writerSetup.write(row: [stringFinalTestTolken])
//            try writerSetup.write(row: [stringFinalTestSelected])
//            try writerSetup.write(row: [stringFinalDevicSelectionName])
//            try writerSetup.write(row: [stringFinalDeviceSelectionIndex])
//            try writerSetup.write(row: [stringFinalDeviceSelectionUUID])
//            try writerSetup.write(row: [stringFinalHeadphoneModelIsUnknownIndex])
//            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreed])
//            try writerSetup.write(row: [stringFinalUncalibratedUserAgreementAgreedDate])
//            try writerSetup.write(row: [stringFinalManualDeviceBrand])
//            try writerSetup.write(row: [stringFinalManualDeviceModel])
//            try writerSetup.write(row: [stringFinalStartingSystemVolume])
//            try writerSetup.write(row: [stringFinalQuestion1responses])
//            try writerSetup.write(row: [stringFinalQuestion2responses])
//            try writerSetup.write(row: [stringFinalQuestion3responses])
//            try writerSetup.write(row: [stringFinalQuestion4responses])
//            try writerSetup.write(row: [stringFinalQuestion5responses])
//            try writerSetup.write(row: [stringFinalQuestion6responses])
//            try writerSetup.write(row: [stringFinalQuestion7responses])
//            try writerSetup.write(row: [stringFinalQuestion8responses])
//            try writerSetup.write(row: [stringFinalQuestion9responses])
//            try writerSetup.write(row: [stringFinalQuestion10responses])
//            try writerSetup.write(row: [stringFinalNoResponses])
//            try writerSetup.write(row: [stringFinalSometimesResponses])
//            try writerSetup.write(row: [stringFinalYesResponses])
//            try writerSetup.write(row: [stringFinalSummaryResponseScore])
//            try writerSetup.write(row: [stringFinalEndingSystemVolume])
//            try writerSetup.write(row: [stringFinalInterimEndingEHASystemVolume])
//            try writerSetup.write(row: [stringFinalInterimStartingEHASystemVolume])
//            try writerSetup.write(row: [stringfinalEndingEHASystemVolume])
        
            print("CVS Setup Writer Success")
        } catch {
            print("CVSWriter Setup Error or Error Finding File for Setup CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSetupResultsToCSV() async {
        print("writeInputSetupResultsToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalUserAgreementAgreedDate.count != 0 {
            stringInputFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
        let stringFinalUserAgreementAgreed = finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUserAgreementAgreedDate = stringFUAADate.map { String($0) }.joined(separator: ",")
        let stringFinalFirstName = finalFirstName.map { String($0) }.joined(separator: ",")
        let stringFinalLastName = finalLastName.map { String($0) }.joined(separator: ",")
        let stringFinalEmail = finalEmail.map { String($0) }.joined(separator: ",")
        let stringFinalPassword = finalPassword.map { String($0) }.joined(separator: ",")
        let stringFinalAge = finalAge.map { String($0) }.joined(separator: ",")
        let stringFinalGender = finalGender.map { String($0) }.joined(separator: ",")
        let stringFinalGenderIndex = finalGenderIndex.map { String($0) }.joined(separator: ",")
        let stringFinalSex = finalSex.map { String($0) }.joined(separator: ",")
        let stringFinalUserUUIDString = finalUserUUIDString.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSetupDocumentsDirectory = csvInputSetupPath
            print("CSV Input Setup DocumentsDirectory: \(csvInputSetupDocumentsDirectory)")
            let csvInputSetupFilePath = csvInputSetupDocumentsDirectory.appendingPathComponent(inputSetupCSVName)
            print(csvInputSetupFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSetupFilePath, append: false)
            try writerSetup.write(row: [stringFinalUserAgreementAgreed])
            try writerSetup.write(row: [stringFinalUserAgreementAgreedDate])
            try writerSetup.write(row: [stringFinalFirstName])
            try writerSetup.write(row: [stringFinalLastName])
            try writerSetup.write(row: [stringFinalEmail])
            try writerSetup.write(row: [stringFinalPassword])
            try writerSetup.write(row: [stringFinalAge])
            try writerSetup.write(row: [stringFinalGender])
            try writerSetup.write(row: [stringFinalGenderIndex])
            try writerSetup.write(row: [stringFinalSex])
            try writerSetup.write(row: [stringFinalUserUUIDString])
            print("CVS Input Setup Writer Success")
        } catch {
            print("CVSWriter Input Setup Error or Error Finding File for Input Setup CSV \(error.localizedDescription)")
        }
    }
}


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
    



