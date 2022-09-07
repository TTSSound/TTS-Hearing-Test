//
//  JSONPaserCombineViewModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/1/22.
//

import Foundation
import CodableCSV
import Firebase
import FirebaseStorage


//struct SetupResults: Codable, Identifiable {
//    let id: String
//    let jsonFinalFirstName: String
//    let jsonFinalLastName: String
//    let jsonFinalEmail: String
//    let jsonFinalPassword: String
//    let jsonFinalAge: Int
//    let jsonFinalGender: String
//    let jsonFinalSex: Int
//    let jsonFinalGenderIndex: Int
//    let jsonUserAgreementAgreed: Int
//    let jsonStringUserAgreementAgreedDate: String
//    let jsonUserAgreementAgreedDate: Double
//}
//
//func decode(_ file: String) -> [String: SetupResults] {
//    guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
//        fatalError("Failed to locate \(file) in bundle.")
//    }
//    guard let data = try? Data(contentsOf: url) else {
//        fatalError("Failed to load \(file) from bundle.")
//    }
//
//    let decoder = JSONDecoder()
//
//    guard let loaded = try? decoder.decode([String: SetupResults].self, from: data) else {
//        fatalError("Failed to decode \(file) from bundle.")
//    }
//
//    return loaded
//}


class JSONParserCombineViewModel: ObservableObject {

    //SetupDataModel
    let fileSetupName = "SetupResults.json"
    let setupCSVName = "SetupResultsCSV.csv"

    //TestSelectionModel
    let fileTestSelectionName = "TestSelection.json"
    let testSelectionCSVName = "TestSelectionCSV.csv"

    //DeviceSelectionModel
    let fileDeviceName = "DeviceSelection.json"
    let deviceCSVName = "DeviceSelectionCSV.csv"

    //ManualDisclaimerModel
    let fileManualDisclaimerName = "ManualDisclaimerAgreement.json"
    let manuaDisclaimerCSVName = "ManualDisclaimerAgreementCSV.csv"

    //ManualDeviceSelectionModel
    let fileManualDeviceName = "ManualDeviceSelection.json"
    let manualDeviceCSVName = "ManualDeviceSelectionCSV.csv"

    //SystemSettingsModel
    let fileSystemName = "SystemSettings.json"
    let systemCSVName = "SystemSettingsCSV.csv"

    //SurveyAssessmentModel
    let fileSurveyName = "SurveyResults.json"
    let surveyCSVName = "SurveyResultsCSV.csv"

    var parseFilePath: URL = URL(fileURLWithPath: "")
    var readJSONData = Data()




    struct JSONData: Codable {
        let title: String
        let data: String
    }




    func getLocalDirectoryPath() async -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getLocalFilePathURL(fileName: String) async {
//        let setupCSVName = ["SetupResultsCSV.csv"]
        let jsonName = [fileName]
        let fileManager = FileManager.default
        let jsonFilePaths = (await self.getLocalDirectoryPath() as NSString).strings(byAppendingPaths: jsonName)
        if fileManager.fileExists(atPath: jsonFilePaths[0]) {
            let localFilePath = URL(fileURLWithPath: jsonFilePaths[0])
            parseFilePath = localFilePath
            print(parseFilePath)
        } else {
            print("!!!Error No JSON File Found")
        }
    }

    func readJSONFile(parseFilePath: URL) async -> Data? {
        do {
            let jsonData = try String(contentsOf: parseFilePath).data(using: .utf8)
            let readJSONData = jsonData
            print(readJSONData!)
            return jsonData
        } catch {
            print("!!!Error Reading JSON File")
            return nil
        }
    }

    func parseJSON(jsonData: Data) async {
        do {
            let decodedData = try JSONDecoder().decode(JSONData.self, from: jsonData)

            print("variable: \(decodedData.title)")
            print("data: \(decodedData.data)")

        } catch {
            print("!!!Error Decoding JSON")
        }
    }


//FireBase Storage Upload CSV File Code
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func uploadCSV() async {
//        let storage = Storage.storage()
        let storageRef = Storage.storage().reference()
        let setupCSVName = ["SetupResultsCSV.csv"]
        let fileManager = FileManager.default
        let csvPath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: setupCSVName)
        if fileManager.fileExists(atPath: csvPath[0]) {
            let filePath = URL(fileURLWithPath: csvPath[0])
            let localFile = filePath
            let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
            let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
                if error == nil && metadata == nil {
                    //TSave a reference to firestore database
                }

                return
            }
            print(uploadTask)
//                guard let metadata = metadata else {
//                    print("!!!Error in uploadCSV File Located")
//                    return
//                }
        } else {
            print("No File")
        }
    }
}

