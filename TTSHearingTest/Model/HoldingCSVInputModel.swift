//
//  HoldingCSVInputModel.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift



//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift
//let setupCSVName = "SetupResultsCSV.csv"
//@State private var inputLastName = String()
//@State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
//@State private var isOkayToUpload = false
//
//
//func uploadUserDataEntry() {
//    DispatchQueue.main.async(group: .none, qos: .background) {
//        uploadFile(fileName: setupCSVName)
//        uploadFile(fileName: inputSetupCSVName)
//        uploadFile(fileName: "SetupResults.json")
//    }
//}
//
//func getDataLinkPath() async -> String {
//    let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//    let documentsDirectory = dataLinkPaths[0]
//    return documentsDirectory
//}
//
//private func setupCSVReader() async {
//    let dataSetupName = "InputSetupResultsCSV.csv"
//    let fileSetupManager = FileManager.default
//    let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
//    if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
//        let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
//        if dataSetupFilePath.isFileURL  {
//            dataFileURLLastName = dataSetupFilePath
//            print("dataSetupFilePath: \(dataSetupFilePath)")
//            print("dataFileURL1: \(dataFileURLLastName)")
//            print("Setup Input File Exists")
//        } else {
//            print("Setup Data File Path Does Not Exist")
//        }
//    }
//    do {
//        let results = try CSVReader.decode(input: dataFileURLLastName)
//        print(results)
//        print("Setup Results Read")
//        let rows = results.columns
//        print("rows: \(rows)")
//        let fieldLastName: String = results[row: 1, column: 0]
//        print("fieldLastName: \(fieldLastName)")
//        inputLastName = fieldLastName
//        print("inputLastName: \(inputLastName)")
//    } catch {
//        print("Error in reading Last Name results")
//    }
//}
//


//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift


////    e.g. fileName variable is setupCSVName with value of "SetupResultsCSV.csv"
//
////    let setupCSVName = "SetupResultsCSV.csv"
////    let inputSetupCSVName = "InputSetupResultsCSV.csv"
//
//    func getDirectoryPath() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//    // Only Use Files that have a pure string name assigned, not a name of ["String"]
//  private func uploadFile(fileName: String) {
//DispatchQueue.global(qos: .userInteractive).async {
//    let storageRef = Storage.storage().reference()
//    let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
//    let lastNameRef = storageRef.child(inputLastName)
//    let fileManager = FileManager.default
//    let filePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [fileName])
//    if fileManager.fileExists(atPath: filePath[0]) {
//        let filePath = URL(fileURLWithPath: filePath[0])
//        let localFile = filePath
////                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
//        let fileRef = lastNameRef.child("\(fileName)")
//
//        let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
//            if error == nil && metadata == nil {
//                //TSave a reference to firestore database
//            }
//            return
//        }
//        print(uploadTask)
//    } else {
//        print("No File")
//    }
//}


class HoldingCSVInputModel: ObservableObject {
    
    //Setup Model Variables
    @State var inputLastName = String()
    @State var inputAge = Int()
    @State var inputGender = String()
    @State var inputGenderIndex = Int()
    @State var inputSex = Int()
    @State var inputUserUUID = String()
    
    //Beta Demo Variables
    @State var inputBetaLastName = String()
    @State var inputBetaTestSelected = String()
    @State var inputBetaAge = String()
    @State var inputBetaSex = String()
    
    //Compared Last Name
    @State var inputComparedLastName = String()
    
    //Test Selection Variables
    @State var inputEHATest = Int()
    @State var inputEPTATest = Int()
    @State var inputSimpleTest = Int()
    @State var inputSimpleTestUUID = String()
    @State var inputTestSelected = Int()
    
    //Device Selection Variables
    @State var inputDeviceSelection = String()
    @State var inputDeviceIndex = Int()
    @State var inputDeviceUUID = String()
    @State var inputUnknownModelIndex = Int()
    
    //Manual Disclaimer Model Variables
    @State var inputUncalibratedUserAgreed = Bool()
    @State var inputUncalibratedStringUADate = String()
    @State var inputUncalibratedUADate = String()
    
    //Manual Device Entry
    @State var inputManualBrand = String()
    @State var inputManualModel = String()
    
    //System Settings Model
    @State var inputStartingSystemVolume = Float()
    
    //Survey Hearing Assessment
    @State var inputSurveySummaryScore = Int()
    
    //Ending EPTA Simple System Settings
    @State var inputEndingEPTASimpleSystemVolume = Float()
    
    //Interim Starting EHA System Settings
    @State var inputInterimStartingEHAVolume = Float()
    @State var inputInterimStartingEHASilentMode = Int()
    
    //Ending EHA System Settings
    @State var inputEndingEHASystemVolume = Float()
    
    //In-App Purchases
    @State var inputPurchasedEHATTestUUID = String()
    @State var inputPurchasedEPTATestUUID = String()
    @State var inputPurchasedTestTolken = String()
    @State var inputTestPurchased = Int()
    
    // 1kHz Bilateral Test Results
//    @State var inputOnekHzactiveFrequency = String()
//    @State var inputRightEar1kHzdBFinal = Float()
//    @State var inputLeftEar1kHzdBFinal = Float()
//    @State var inputonekHzIntraEarDeltaHLFinal = Float()
//    @State var inputOnekHzFinalComboLRGains = [String]()
//    @State var inputOnekHzFinalComboRightGains = Float()
//    @State var inputOnekHzFinalComboLeltGains = Float()
//    @State var inputOnekHzFinalComboDeltaGains = Float()
    
    @State var inputOnekHz_averageGainRightArray1 = Float()
    @State var inputOnekHz_averageGainRightArray2 = Float()
    @State var inputOnekHz_averageGainRightArray3 = Float()
    @State var inputOnekHz_averageGainRightArray4 = Float()
    @State var inputOnekHz_averageGainLeftArray1 = Float()
    @State var inputOnekHz_averageGainLeftArray2 = Float()
    @State var inputOnekHz_averageGainLeftArray3 = Float()
    @State var inputOnekHz_averageGainLeftArray4 = Float()
    @State var inputOnekHz_averageLowestGainRightArray = Float()
    @State var inputOnekHz_HoldingLowestRightGainArray = Float()
    @State var inputOnekHz_averageLowestGainLeftArray = Float()
    @State var inputOnekHz_HoldingLowestLeftGainArray = Float()
    
    // EHA Part 1 input Results
    @State var inputRightFinalGainsArraySample1 = Float()
    @State var inputRightFinalGainsArraySample2 = Float()
    @State var inputRightFinalGainsArraySample3 = Float()
    @State var inputRightFinalGainsArraySample4 = Float()
    @State var inputRightFinalGainsArraySample5 = Float()
    @State var inputRightFinalGainsArraySample6 = Float()
    @State var inputRightFinalGainsArraySample7 = Float()
    @State var inputRightFinalGainsArraySample8 = Float()
    @State var inputRightFinalGainsArraySample9 = Float()
    @State var inputRightFinalGainsArraySample10 = Float()
    @State var inputRightFinalGainsArraySample11 = Float()
    @State var inputRightFinalGainsArraySample12 = Float()
    @State var inputRightFinalGainsArraySample13 = Float()
    @State var inputRightFinalGainsArraySample14 = Float()
    @State var inputRightFinalGainsArraySample15 = Float()
    @State var inputRightFinalGainsArraySample16 = Float()
    @State var inputRightFinalStoredRightFinalGainsArray = Float()
    
    @State var inputLeftFinalGainsArraySample1 = Float()
    @State var inputLeftFinalGainsArraySample2 = Float()
    @State var inputLeftFinalGainsArraySample3 = Float()
    @State var inputLeftFinalGainsArraySample4 = Float()
    @State var inputLeftFinalGainsArraySample5 = Float()
    @State var inputLeftFinalGainsArraySample6 = Float()
    @State var inputLeftFinalGainsArraySample7 = Float()
    @State var inputLeftFinalGainsArraySample8 = Float()
    @State var inputLeftFinalGainsArraySample9 = Float()
    @State var inputLeftFinalGainsArraySample10 = Float()
    @State var inputLeftFinalGainsArraySample11 = Float()
    @State var inputLeftFinalGainsArraySample12 = Float()
    @State var inputLeftFinalGainsArraySample13 = Float()
    @State var inputLeftFinalGainsArraySample14 = Float()
    @State var inputLeftFinalGainsArraySample15 = Float()
    @State var inputLeftFinalGainsArraySample16 = Float()
    @State var inputLeftFinalStoredLeftFinalGainsArray = Float()
    
    
    //URLS
    @State var dataFileURL = URL(fileURLWithPath: "")   // General and Open
    @State var dataFileURL1 = URL(fileURLWithPath: "")  // Setup Model
    @State var dataFileURL2 = URL(fileURLWithPath: "")  // Test Selection
    @State var dataFileURL3 = URL(fileURLWithPath: "")  // Hold for Test Selction Index Model
    @State var dataFileURL4 = URL(fileURLWithPath: "")  // Device Selection Model
    @State var dataFileURL5 = URL(fileURLWithPath: "")  // Manual Disclaimer Model
    @State var dataFileURL6 = URL(fileURLWithPath: "")  // Manual Device Entry Model
    @State var dataFileURL7 = URL(fileURLWithPath: "")  // Survey Assessment
    @State var dataFileURL8 = URL(fileURLWithPath: "")  // System Settings
    @State var dataFileURL9 = URL(fileURLWithPath: "")  // End EPTA/Simple System Settings Model
    @State var dataFileURL10 = URL(fileURLWithPath: "") // Interim Start EHA System Settings Model
    @State var dataFileURL11 = URL(fileURLWithPath: "") // End EHA Test System Settings
    @State var dataFileURL12 = URL(fileURLWithPath: "") // In-App Purchase
    @State var dataFileURL13 = URL(fileURLWithPath: "") // 1kHZ Bilateral test results
    @State var dataFileURL14 = URL(fileURLWithPath: "") // right EHA Part 1 Results
    @State var dataFileURL15 = URL(fileURLWithPath: "") // left EHA Part 1 results
    @State var dataFileURL16 = URL(fileURLWithPath: "") // beta demo setup variables
    @State var dataFileURL17 = URL(fileURLWithPath: "") // Compared Last Name
    @State var dataFileURL18 = URL(fileURLWithPath: "")
    @State var dataFileURL19 = URL(fileURLWithPath: "")
    @State var dataFileURL20 = URL(fileURLWithPath: "")
    
    
    
    // Gain Setting Functions for EHAP1/EPTA/EHAP2 Tests
    @State var dataFileURLGain1 = URL(fileURLWithPath: "")
    @State var dataFileURLGain2 = URL(fileURLWithPath: "")
    @State var dataFileURLGain3 = URL(fileURLWithPath: "")
    @State var dataFileURLGain4 = URL(fileURLWithPath: "")
    @State var dataFileURLGain5 = URL(fileURLWithPath: "")
    @State var dataFileURLGain6 = URL(fileURLWithPath: "")
    @State var dataFileURLGain7 = URL(fileURLWithPath: "")
    @State var dataFileURLGain8 = URL(fileURLWithPath: "")
    @State var dataFileURLGain9 = URL(fileURLWithPath: "")
    @State var dataFileURLGain10 = URL(fileURLWithPath: "")
    
    
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    let inputTestSelectionCSVName = "InputTestSelectionCSV.csv"
    let ehaLink = "EHA.csv"
    let eptaLink = "EPTA.csv"
    let simpleLink = "Simple.csv"
    let inputDeviceCSVName = "InputDeviceSelectionCSV.csv"
    let inputManuaDisclaimerCSVName = "InputManualDisclaimerAgreementCSV.csv"
    let inputManualDeviceCSVName = "InputManualDeviceSelectionCSV.csv"
    let inputSystemCSVName = "InputSystemSettingsCSV.csv"
    let inputSurveyCSVName = "InputSurveyResultsCSV.csv"
    let inputSystemSettingsEndCSVName = "InputEndEPTASimpleSystemSettingsCSV.csv"
    let inputSystemInterimEHACSVName = "InputSystemSettingsInterimEHACSV.csv"
    let inputSystemInterimStartingEHACSVName = "InputSystemSettingsInterimStartingEHACSV.csv"
    let inputSystemEndEHACSVName = "InputSystemSettingsEndEHACSV.csv"
    let inputTestPurchasedCSVName = "InputTestPurchaseCSV.csv"
    
    // Bilateral 1kHz test input results
    let inputOnekHzSummaryCSVName = "InputSummaryOnekHzResultsCSV.csv"
    
    
    // EHA Part 1 input Results
//    let inputEHAP1SummaryCSVName = "InputSummaryEHAP1ResultsCSV.csv"
//    let inputEHAP1LRSummaryCSVName = "InputDetailedEHAP1LRResultsCSV.csv"
    let inputEHAP1RightSummaryCSVName = "InputDetailedEHAP1RightResultsCSV.csv"
    let inputEHAP1LeftSummaryCSVName = "InputDetailedEHAP1LeftResultsCSV.csv"
    
    //ENVDataObjectModel
    let inputSummaryCSVName = "InputSummaryResultsCSV.csv"
    let inputDetailedCSVName = "InputDetailedResultsCSV.csv"

    // Compared Last Name
    let inputBetaSummaryCSVName = "InputBetaSummaryCSV.csv"
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }

    func checkDataLink() async {
        let dataName = ["!!!INSERT FILE NAME VARIABLE!!!"]
        let fileManager = FileManager.default
        let dataPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: dataName)
        if fileManager.fileExists(atPath: dataPath[0]) {
            let dataFilePath = URL(fileURLWithPath: dataPath[0])
            if dataFilePath.isFileURL  {
                dataFileURL = dataFilePath
                print("dataFilePath: \(dataFilePath)")
                print("dataFileURL: \(dataFileURL)")
                print("Input File Exists")
            } else {
                print("Data File Path Does Not Exist")
            }
        }
    }
    
    
//MARK: -SetupDataModel Input
    func setupCSVReader() async {
        let dataSetupName = [inputSetupCSVName]
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: dataSetupName)
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURL1 = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURL1)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL1)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 1, column: 0]
            let fieldAge: String = results[row:5, column: 0]
            let fieldGender: String = results[row:6, column: 0]
            let fieldGenderIndex: String = results[row:7, column: 0]
            let fieldSex: String = results[row:8, column: 0]
            let fieldUserUUID: String = results[row:8, column: 0]
            print("fieldAge: \(fieldAge)")
            print("fieldGender: \(fieldGender)")
            print("fieldGenderIndex: \(fieldGenderIndex)")
            print("fieldSex: \(fieldSex)")
            print("fieldUserUUID: \(fieldUserUUID)")
            inputLastName = fieldLastName
            let inputAg = Int(fieldAge)
            inputAge = inputAg ?? -999
            inputGender = fieldGender
            let inputGenderIdx = Int(fieldGenderIndex)
            inputGenderIndex = inputGenderIdx ?? -999
            let inputSx = Int(fieldSex)
            inputSex = inputSx ?? -999
            inputUserUUID = fieldUserUUID
            print("inputAge: \(inputAge)")
            print("inputGender: \(inputGender)")
            print("inputGenderIndex: \(inputGenderIndex)")
            print("inputSex: \(inputSex)")
            print("inputUserUUID: \(inputUserUUID)")
        } catch {
            print("Error in reading Setup results")
        }
    }

//MARK: -TestSelectionModel Input
    func testSelectionCSVReader() async {
        let dataTestSelectionName = [inputTestSelectionCSVName]
        let fileTestSelectionManager = FileManager.default
        let dataTestSelectionPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: dataTestSelectionName)
        if fileTestSelectionManager.fileExists(atPath: dataTestSelectionPath[0]) {
            let dataTestSelectionFilePath = URL(fileURLWithPath: dataTestSelectionPath[0])
            if dataTestSelectionFilePath.isFileURL  {
                dataFileURL2 = dataTestSelectionFilePath
                print("dataTestSelectionFilePath: \(dataTestSelectionFilePath)")
                print("dataFileURL2: \(dataFileURL2)")
                print("Test Selection Input File Exists")
            } else {
                print("Test Selection Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL2)
            print(results)
            print("Test Selection Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldEHA: String = results[row:0, column: 0]
            let fieldEPTA: String = results[row:1, column: 0]
            let fieldSimple: String = results[row:2, column: 0]
            let fieldSimpleUUID: String = results[row:3, column: 0]
            let fieldTestSelected: String = results[row:4, column: 0]
            print("fieldEHA: \(fieldEHA)")
            print("fieldEPTA: \(fieldEPTA)")
            print("fieldSimple: \(fieldSimple)")
            print("fieldSimpleUUID: \(fieldSimpleUUID)")
            print("fieldTestSelected: \(fieldTestSelected)")
            let inputEHATst = Int(fieldEHA)
            inputEHATest = inputEHATst ?? -999
            let inputEPTATst = Int(fieldEPTA)
            inputEHATest = inputEPTATst ?? -999
            let inputSimpleTst = Int(fieldSimple)
            inputSimpleTest = inputSimpleTst ?? -999
            inputSimpleTestUUID = fieldSimpleUUID
            let inputTstSelected = Int(fieldTestSelected)
            inputTestSelected = inputTstSelected ?? -999
            print("inputEHATest: \(inputEHATest)")
            print("inputEPTATest: \(inputEPTATest)")
            print("inputSimpleTest: \(inputSimpleTest)")
            print("inputSimpleTestUUID: \(inputSimpleTestUUID)")
            print("inputTestSelected: \(inputTestSelected)")
        } catch {
            print("Error in reading Test Selection results")
        }
    }
    
//MARK: -DeviceSelectionModel Input
    func deviceSelectionCSVReader() async {
        let deviceSelectionName = [inputDeviceCSVName]
        let fileDeviceSelectionManager = FileManager.default
        let deviceSelectionPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: deviceSelectionName)
        if fileDeviceSelectionManager.fileExists(atPath: deviceSelectionPath[0]) {
            let deviceSelectionFilePath = URL(fileURLWithPath: deviceSelectionPath[0])
            if deviceSelectionFilePath.isFileURL  {
                dataFileURL4 = deviceSelectionFilePath
                print("deviceSelectionFilePath: \(deviceSelectionFilePath)")
                print("deviceFileURL4: \(dataFileURL4)")
                print("Device Selection Input File Exists")
            } else {
                print("Device Selection Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL4)
            print(results)
            print("Device Selection Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldDeviceSelection: String = results[row:0, column: 0]
            let fieldDeviceIndex: String = results[row:1, column: 0]
            let fieldDeviceUUID: String = results[row:2, column: 0]
            let fieldUnknownModelIndex: String = results[row:3, column: 0]
            print("fieldDeviceSelection: \(fieldDeviceSelection)")
            print("fieldDeviceIndex: \(fieldDeviceIndex)")
            print("fieldDeviceUUID: \(fieldDeviceUUID)")
            print("fieldUnknownModelIndex: \(fieldUnknownModelIndex)")
            inputDeviceSelection = fieldDeviceSelection
            let inputDeviceIdx = Int(fieldDeviceIndex)
            inputDeviceIndex = inputDeviceIdx ?? -999
            inputDeviceUUID = fieldDeviceUUID
            let inputUnknownModelIdx = Int(fieldUnknownModelIndex)
            inputUnknownModelIndex = inputUnknownModelIdx ?? -999
            print("inputDeviceSelection: \(inputDeviceSelection)")
            print("inputDeviceIndex: \(inputDeviceIndex)")
            print("inputDeviceUUID: \(inputDeviceUUID)")
            print("inputUnknownModelIndex: \(inputUnknownModelIndex)")
        } catch {
            print("Error in reading Device Selection results")
        }
    }

//MARK: -ManualDisclaimerModel Input
    func manualDisclaimerCSVReader() async {
        let manualDisclaimerName = [inputManuaDisclaimerCSVName]
        let fileManualDisclaimerManager = FileManager.default
        let manualDisclaimerPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: manualDisclaimerName)
        if fileManualDisclaimerManager.fileExists(atPath: manualDisclaimerPath[0]) {
            let manualDisclaimerFilePath = URL(fileURLWithPath: manualDisclaimerPath[0])
            if manualDisclaimerFilePath.isFileURL  {
                dataFileURL5 = manualDisclaimerFilePath
                print("manualDisclaimerFilePath: \(manualDisclaimerFilePath)")
                print("manualDisclaimerFileURL5: \(dataFileURL5)")
                print("Manual Disclaimer Input File Exists")
            } else {
                print("Manual Disclaimer Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL5)
            print(results)
            print("Manual Disclaimer Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldUncalibratedUserAgreed: String = results[row:0, column: 0]
            let fieldUncalibratedStringUADate: String = results[row:1, column: 0]
            let fieldUncalibratedUADate: String = results[row:2, column: 0]
            print("fieldUncalibratedUserAgreed: \(fieldUncalibratedUserAgreed)")
            print("fieldUncalibratedStringUADate: \(fieldUncalibratedStringUADate)")
            print("fieldUncalibratedUADate: \(fieldUncalibratedUADate)")
            let inputUncalibratedUserAgd = Bool(fieldUncalibratedUserAgreed)
            inputUncalibratedUserAgreed = inputUncalibratedUserAgd ?? false
            inputUncalibratedStringUADate = fieldUncalibratedStringUADate
            inputUncalibratedUADate = fieldUncalibratedUADate
            print("inputUncalibratedUserAgreed: \(inputUncalibratedUserAgreed)")
            print("inputUncalibratedStringUADate: \(inputUncalibratedStringUADate)")
            print("inputUncalibratedUADate: \(inputUncalibratedUADate)")
        } catch {
            print("Error in reading Manual Disclaimer results")
        }
    }
    
//MARK: -Manual Device Input
    func manualDeviceCSVReader() async {
        let manualDeviceName = [inputManualDeviceCSVName]
        let fileManualDeviceManager = FileManager.default
        let manualDevicePath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: manualDeviceName)
        if fileManualDeviceManager.fileExists(atPath: manualDevicePath[0]) {
            let manualDeviceFilePath = URL(fileURLWithPath: manualDevicePath[0])
            if manualDeviceFilePath.isFileURL  {
                dataFileURL6 = manualDeviceFilePath
                print("manualDeviceFilePath: \(manualDeviceFilePath)")
                print("manualDeviceFileURL5: \(dataFileURL6)")
                print("Manual Device Input File Exists")
            } else {
                print("Manual Device Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL6)
            print(results)
            print("Manual Device Entry Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldManualBrand: String = results[row:0, column: 0]
            let fieldManualModel: String = results[row:1, column: 0]
            print("fieldManualBrand: \(fieldManualBrand)")
            print("fieldManualModel: \(fieldManualModel)")
            inputManualBrand = fieldManualBrand
            inputManualModel = fieldManualModel
            print("inputManualBrand: \(inputManualBrand)")
            print("inputManualModel: \(inputManualModel)")
        } catch {
            print("Error in reading Manual Device Entry results")
        }
    }

    
//MARK: -Survey Hearing Assessment
    func surveyAssessmentCSVReader() async {
        let surveyAssessmentName = [inputSurveyCSVName]
        let fileSurveyAssessmentManager = FileManager.default
        let surveyAssessmentPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: surveyAssessmentName)
        if fileSurveyAssessmentManager.fileExists(atPath: surveyAssessmentPath[0]) {
            let surveyAssessmentPath = URL(fileURLWithPath: surveyAssessmentPath[0])
            if surveyAssessmentPath.isFileURL  {
                dataFileURL7 = surveyAssessmentPath
                print("surveyAssessmentPath: \(surveyAssessmentPath)")
                print("surveyAssessmentFileURL7: \(dataFileURL7)")
                print("surveyAssessment Input File Exists")
            } else {
                print("surveyAssessment Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL7)
            print(results)
            print("surveyAssessment Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldSurveySummaryScore: String = results[row:13, column: 0]
            print("fieldSurveySummaryScore: \(fieldSurveySummaryScore)")
            let inputSurveySummaryScr = Int(fieldSurveySummaryScore)
            inputSurveySummaryScore = inputSurveySummaryScr ?? -999
            print("inputSurveySummaryScore: \(inputSurveySummaryScore)")
        } catch {
            print("Error in reading surveyAssessmentresults")
        }
    }
    

//MARK: -System Settings Model
    func systemSettingsCSVReader() async {
        let systemSettingsName = [inputSystemCSVName]
        let fileSystemSettingsManager = FileManager.default
        let systemSettingsPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: systemSettingsName)
        if fileSystemSettingsManager.fileExists(atPath: systemSettingsPath[0]) {
            let systemSettingsFilePath = URL(fileURLWithPath: systemSettingsPath[0])
            if systemSettingsFilePath.isFileURL  {
                dataFileURL8 = systemSettingsFilePath
                print("systemSettingsFilePath: \(systemSettingsFilePath)")
                print("systemSettingsFileURL8: \(dataFileURL8)")
                print("System Setting Input File Exists")
            } else {
                print("System Setting Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL8)
            print(results)
            print("System Settings Entry Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldStartingSystemVolume: String = results[row:0, column: 0]
            print("fieldStartingSystemVolume: \(fieldStartingSystemVolume)")
            let inputStartingSystemVol = Float(fieldStartingSystemVolume)
            inputStartingSystemVolume = inputStartingSystemVol ?? -9.99
            print("inputStartingSystemVolume: \(inputStartingSystemVolume)")
        } catch {
            print("Error in reading System Settings results")
        }
    }
    
    
//MARK: -End EPTA/Simple System Settings Model
    func systemSettingsEndEPTASimpleCSVReader() async {
        let systemSettingsEndEPTASimpleName = [inputSystemSettingsEndCSVName]
        let fileSystemSettingsEndEPTASimpleManager = FileManager.default
        let systemSettingsEndEPTASimplePath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: systemSettingsEndEPTASimpleName)
        if fileSystemSettingsEndEPTASimpleManager.fileExists(atPath: systemSettingsEndEPTASimplePath[0]) {
            let systemSettingsEndEPTASimpleFilePath = URL(fileURLWithPath: systemSettingsEndEPTASimplePath[0])
            if systemSettingsEndEPTASimpleFilePath.isFileURL  {
                dataFileURL9 = systemSettingsEndEPTASimpleFilePath
                print("systemSettingsEndEPTASimpleFilePath: \(systemSettingsEndEPTASimpleFilePath)")
                print("systemSettingsEndEPTASimpleFileURL9: \(dataFileURL9)")
                print("System Setting EndEPTASimple Input File Exists")
            } else {
                print("System Setting EndEPTASimple Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL9)
            print(results)
            print("System Settings EndEPTASimple Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldEndingEPTASimpleSystemVolume: String = results[row:0, column: 0]
            print("fieldEndingEPTASimpleSystemVolume: \(fieldEndingEPTASimpleSystemVolume)")
            let inputEndingEPTASimpleSystemVol = Float(fieldEndingEPTASimpleSystemVolume)
            inputEndingEPTASimpleSystemVolume = inputEndingEPTASimpleSystemVol ?? -9.99
            print("inputStartingSystemVolume: \(inputEndingEPTASimpleSystemVolume)")
        } catch {
            print("Error in reading System Settings Ending EPTA Simple results")
        }
    }
    
    
    
    
//MARK: -Interim Start EHA System Settings Model
    func systemSettingsInterimStartEHACSVReader() async {
        let systemSettingsInterimStartEHAName = [inputSystemInterimStartingEHACSVName]
        let fileSystemSettingsInterimStartEHAManager = FileManager.default
        let systemSettingsInterimStartEHAPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: systemSettingsInterimStartEHAName)
        if fileSystemSettingsInterimStartEHAManager.fileExists(atPath: systemSettingsInterimStartEHAPath[0]) {
            let systemSettingsInterimStartEHAFilePath = URL(fileURLWithPath: systemSettingsInterimStartEHAPath[0])
            if systemSettingsInterimStartEHAFilePath.isFileURL  {
                dataFileURL10 = systemSettingsInterimStartEHAFilePath
                print("systemSettingsInterimStartEHAFilePath: \(systemSettingsInterimStartEHAFilePath)")
                print("systemSettingsInterimStartEHAFileURL10: \(dataFileURL10)")
                print("System Setting InterimStartEHA Input File Exists")
            } else {
                print("System Setting InterimStartEHA Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL10)
            print(results)
            print("System Settings InterimStartEHA Entry Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldInterimStartingEHAVolume: String = results[row:0, column: 0]
            let fieldInterimStartingEHASilentMode: String = results[row:1, column: 0]
            print("fieldInterimStartingEHAVolume: \(fieldInterimStartingEHAVolume)")
            print("fieldInterimStartingEHASilentMode: \(fieldInterimStartingEHASilentMode)")
            let inputInterimStartingEHAVol = Float(fieldInterimStartingEHAVolume)
            inputInterimStartingEHAVolume = inputInterimStartingEHAVol ?? -9.99
            let inputInterimStartingEHASilentMde = Int(fieldInterimStartingEHASilentMode)
            inputInterimStartingEHASilentMode = inputInterimStartingEHASilentMde ?? -999
            print("inputInterimStartingEHAVolume: \(inputInterimStartingEHAVolume)")
            print("inputInterimStartingEHASilentMode: \(inputInterimStartingEHASilentMode)")
        } catch {
            print("Error in reading System Settings InterimStartEHA results")
        }
    }
    
    
//MARK: -End EHA System Settings
    //
    
    func systemSettingsEndEHACSVReader() async {
        let systemSettingsEndEHAName = [inputSystemEndEHACSVName]
        let fileSystemSettingsEndEHAManager = FileManager.default
        let systemSettingsEndEHAPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: systemSettingsEndEHAName)
        if fileSystemSettingsEndEHAManager.fileExists(atPath: systemSettingsEndEHAPath[0]) {
            let systemSettingsEndEHAFilePath = URL(fileURLWithPath: systemSettingsEndEHAPath[0])
            if systemSettingsEndEHAFilePath.isFileURL  {
                dataFileURL11 = systemSettingsEndEHAFilePath
                print("systemSettingsEndEHAFilePath: \(systemSettingsEndEHAFilePath)")
                print("systemSettingsEndEHAFileURL11: \(dataFileURL11)")
                print("System Setting End EHA Input File Exists")
            } else {
                print("System Setting End EHA Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL11)
            print(results)
            print("System Settings End EHA Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldEndingEHASystemVolume: String = results[row:0, column: 0]
            print("fieldEndingEHASystemVolume: \(fieldEndingEHASystemVolume)")
            let inputEndingEHASystemVol = Float(fieldEndingEHASystemVolume)
            inputEndingEHASystemVolume = inputEndingEHASystemVol ?? -9.99
            print("inputEndingEHASystemVolume: \(inputEndingEHASystemVolume)")
        } catch {
            print("Error in reading System Settings Ending EHA results")
        }
    }
    
//Mark: -In App Purchases
    //let inputTestPurchasedCSVName = "InputTestPurchaseCSV.csv"
    
    func inAppPurchaseCSVReader() async {
        let inAppPurchaseName = [inputTestPurchasedCSVName]
        let fileInAppPurchaseManager = FileManager.default
        let inAppPurchasePath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: inAppPurchaseName)
        if fileInAppPurchaseManager.fileExists(atPath: inAppPurchasePath[0]) {
            let inAppPurchaseFilePath = URL(fileURLWithPath: inAppPurchasePath[0])
            if inAppPurchaseFilePath.isFileURL  {
                dataFileURL12 = inAppPurchaseFilePath
                print("InAppPurchaseFilePath: \(inAppPurchaseFilePath)")
                print("InAppPurchaseURL12: \(dataFileURL12)")
                print("InAppPurchase Input File Exists")
            } else {
                print("InAppPurchase Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL12)
            print(results)
            print("InAppPurchaseResults Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldPurchasedEHATTestUUID: String = results[row:0, column: 0]
            let fieldPurchasedEPTATestUUID: String = results[row:1, column: 0]
            let fieldPurchasedTestTolken: String = results[row:2, column: 0]
            let fieldTestPurchased: String = results[row:3, column: 0]
            print("fieldPurchasedEHATTestUUID: \(fieldPurchasedEHATTestUUID)")
            print("fieldPurchasedEPTATestUUID: \(fieldPurchasedEPTATestUUID)")
            print("fieldPurchasedTestTolken: \(fieldPurchasedTestTolken)")
            print("fieldTestPurchased: \(fieldTestPurchased)")
            inputPurchasedEHATTestUUID = fieldPurchasedEHATTestUUID
            inputPurchasedEPTATestUUID = fieldPurchasedEPTATestUUID
            inputPurchasedTestTolken = fieldPurchasedTestTolken
            let inputTestPurch = Int(fieldTestPurchased)
            inputTestPurchased = inputTestPurch ?? -999
            print("inputPurchasedEHATTestUUID: \(inputPurchasedEHATTestUUID)")
            print("inputPurchasedEPTATestUUID: \(inputPurchasedEPTATestUUID)")
            print("inputPurchasedTestTolken: \(inputPurchasedTestTolken)")
            print("inputTestPurchased: \(inputTestPurchased)")
        } catch {
            print("Error in reading InAppPurchase results")
        }
    }
    
    
//Mark: -1kHZ Bilateral Test Input Results
    //let inputOnekHzSummaryCSVName = "InputSummaryOnekHzResultsCSV.csv.csv"
    
//onekHz_averageGainRightArray: [0.185, 0.025005, 0.345, 0.185]
//onekHz_averageGainLeftArray: [0.025005, 0.345, 0.185, 0.205]
//onekHz_averageLowestGainRightArray: [0.025005]
//onekHz_HoldingLowestRightGainArray: [0.025005]
//onekHz_averageLowestGainLeftArray: [0.025005]
//onekHz_HoldingLowestLeftGainArray: [0.025005]
//Users/jeffreyjaskunas/Library/Developer/CoreSimulator/Devices/05B0F8D8-D5E9-4CF8-8E31-EB5EDC61373D/data/Containers/Data/Application/546DACC7-B118-4E3D-94DC-CA9C5A252994/Documents/InputSummaryOnekHzResultsCSV.csv

    
    
    
    
    
// Beta Test Entry Demo Input Results
    func betaSetupCSVReader() async {
        let dataSetupName = inputBetaSummaryCSVName
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURL16 = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURL16)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL16)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            let fieldTestSelected: String = results[row:1, column: 0]
            let fieldAge: String = results[row:2, column: 0]
            let fieldSex: String = results[row:3, column: 0]
            print("fieldLastName: \(fieldLastName)")
            print("fieldTestSelected: \(fieldTestSelected)")
            print("fieldAge: \(fieldAge)")
            print("fieldSex: \(fieldSex)")

            inputBetaLastName = fieldLastName
            inputBetaTestSelected = fieldTestSelected
            inputBetaAge = fieldAge
            inputBetaSex = fieldSex
            
            print("inputLastName: \(inputLastName)")
            print("inputTestSelected:\(inputTestSelected)")
            print("inputAge: \(inputAge)")
            print("inputSex: \(inputSex)")
        } catch {
            print("Error in reading Setup results")
        }
    }
    
    
    
    
    func onekHzInputResultsCSVReader() async {
        
        let onekHzSummaryCSVName = [inputOnekHzSummaryCSVName]
        
        let fileOnekHzManager = FileManager.default
        let onekHZPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: onekHzSummaryCSVName)
        if fileOnekHzManager.fileExists(atPath: onekHZPath[0]) {
            let onekHZFilePath = URL(fileURLWithPath: onekHZPath[0])
            if onekHZFilePath.isFileURL  {
                dataFileURL13 = onekHZFilePath
                print("onekHZFilePath: \(onekHZFilePath)")
                print("onekHZURL13: \(dataFileURL13)")
                print("onekHZ Input File Exists")
            } else {
                print("onekHZ Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL13)
            print(results)
            print("onekHZResults Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldOnekHz_averageGainRightArray1: String = results[row:0, column: 0]
            let fieldOnekHz_averageGainRightArray2: String = results[row:0, column: 1]
            let fieldOnekHz_averageGainRightArray3: String = results[row:0, column: 2]
            let fieldOnekHz_averageGainRightArray4: String = results[row:0, column: 3]
            let fieldOnekHz_averageGainLeftArray1: String = results[row:1, column: 0]
            let fieldOnekHz_averageGainLeftArray2: String = results[row:1, column: 1]
            let fieldOnekHz_averageGainLeftArray3: String = results[row:1, column: 2]
            let fieldOnekHz_averageGainLeftArray4: String = results[row:1, column: 3]
            let fieldOnekHz_averageLowestGainRightArray: String = results[row:2, column: 0]
            let fieldOnekHz_HoldingLowestRightGainArray: String = results[row:3, column: 0]
            let fieldOnekHz_averageLowestGainLeftArray: String = results[row:4, column: 0]
            let fieldOnekHz_HoldingLowestLeftGainArray: String = results[row:5, column: 0]
         
            print("fieldOnekHz_averageGainRightArray1: \(fieldOnekHz_averageGainRightArray1)")
            print("fieldOnekHz_averageGainRightArray2: \(fieldOnekHz_averageGainRightArray2)")
            print("fieldOnekHz_averageGainRightArray3: \(fieldOnekHz_averageGainRightArray3)")
            print("fieldOnekHz_averageGainRightArray4: \(fieldOnekHz_averageGainRightArray4)")
            print("fieldOnekHz_averageGainLeftArray1: \(fieldOnekHz_averageGainLeftArray1)")
            print("fieldOnekHz_averageGainLeftArray2: \(fieldOnekHz_averageGainLeftArray2)")
            print("fieldOnekHz_averageGainLeftArray3: \(fieldOnekHz_averageGainLeftArray3)")
            print("fieldOnekHz_averageGainLeftArray4: \(fieldOnekHz_averageGainLeftArray4)")
            print("fieldOnekHz_averageLowestGainRightArray: \(fieldOnekHz_averageLowestGainRightArray)")
            print("fieldOnekHz_HoldingLowestRightGainArray: \(fieldOnekHz_HoldingLowestRightGainArray)")
            print("fieldOnekHz_averageLowestGainLeftArray: \(fieldOnekHz_averageLowestGainLeftArray)")
            print("fieldOnekHz_HoldingLowestLeftGainArray: \(fieldOnekHz_HoldingLowestLeftGainArray)")
            
            let inputOnekHz_averageGainRightArry1 = Float(fieldOnekHz_averageGainRightArray1)
            inputOnekHz_averageGainRightArray1 = inputOnekHz_averageGainRightArry1 ?? -99.9
            
            let inputOnekHz_averageGainRightArry2 = Float(fieldOnekHz_averageGainRightArray2)
            inputOnekHz_averageGainRightArray2 = inputOnekHz_averageGainRightArry2 ?? -99.9
            
            let inputOnekHz_averageGainRightArry3 = Float(fieldOnekHz_averageGainRightArray3)
            inputOnekHz_averageGainRightArray3 = inputOnekHz_averageGainRightArry3 ?? -99.9
            
            let inputOnekHz_averageGainRightArry4 = Float(fieldOnekHz_averageGainRightArray4)
            inputOnekHz_averageGainRightArray4 = inputOnekHz_averageGainRightArry4 ?? -99.9
            
            let inputOnekHz_averageGainLeftArry1 = Float(fieldOnekHz_averageGainLeftArray1)
            inputOnekHz_averageGainLeftArray1 = inputOnekHz_averageGainLeftArry1 ?? -99.9
            
            let inputOnekHz_averageGainLeftArry2 = Float(fieldOnekHz_averageGainLeftArray2)
            inputOnekHz_averageGainLeftArray2 = inputOnekHz_averageGainLeftArry2 ?? -99.9
            
            let inputOnekHz_averageGainLeftArry3 = Float(fieldOnekHz_averageGainLeftArray3)
            inputOnekHz_averageGainLeftArray3 = inputOnekHz_averageGainLeftArry3 ?? -99.9
            
            let inputOnekHz_averageGainLeftArry4 = Float(fieldOnekHz_averageGainLeftArray4)
            inputOnekHz_averageGainLeftArray4 = inputOnekHz_averageGainLeftArry4 ?? -99.9
            
            let inputOnekHz_averageLowestGainRightArry = Float(fieldOnekHz_averageLowestGainRightArray)
            inputOnekHz_averageLowestGainRightArray = inputOnekHz_averageLowestGainRightArry ?? -99.9
            
            let inputOnekHz_HoldingLowestRightGainArry = Float(fieldOnekHz_HoldingLowestRightGainArray)
            inputOnekHz_HoldingLowestRightGainArray = inputOnekHz_HoldingLowestRightGainArry ?? -99.9
            
            let inputOnekHz_averageLowestGainLeftArry = Float(fieldOnekHz_averageLowestGainLeftArray)
            inputOnekHz_averageLowestGainLeftArray = inputOnekHz_averageLowestGainLeftArry ?? -99.9
            
            let inputOnekHz_HoldingLowestLeftGainArry = Float(fieldOnekHz_HoldingLowestLeftGainArray)
            inputOnekHz_HoldingLowestLeftGainArray = inputOnekHz_HoldingLowestLeftGainArry ?? -99.9
            

            print("inputOnekHz_averageGainRightArray1: \(inputOnekHz_averageGainRightArray1)")
            print("inputOnekHz_averageGainRightArray2: \(inputOnekHz_averageGainRightArray2)")
            print("inputOnekHz_averageGainRightArray3: \(inputOnekHz_averageGainRightArray3)")
            print("inputOnekHz_averageGainRightArray4: \(inputOnekHz_averageGainRightArray4)")
            print("inputOnekHz_averageGainLeftArray1: \(inputOnekHz_averageGainLeftArray1)")
            print("inputOnekHz_averageGainLeftArray2: \(inputOnekHz_averageGainLeftArray2)")
            print("inputOnekHz_averageGainLeftArray3: \(inputOnekHz_averageGainLeftArray3)")
            print("inputOnekHz_averageGainLeftArray4: \(inputOnekHz_averageGainLeftArray4)")
            print("inputOnekHz_averageLowestGainRightArray: \(inputOnekHz_averageLowestGainRightArray)")
            print("inputOnekHz_HoldingLowestRightGainArray: \(inputOnekHz_HoldingLowestRightGainArray)")
            print("inputOnekHz_averageLowestGainLeftArray: \(inputOnekHz_averageLowestGainLeftArray)")
            print("inputOnekHz_HoldingLowestLeftGainArray: \(inputOnekHz_HoldingLowestLeftGainArray)")
        } catch {
            print("Error in reading onekHZ results")
        }
    }
    
    func rightEHAP1InputResultsCSVReader() async {
        
        let rightEHAP1SummaryCSVName = [inputEHAP1RightSummaryCSVName]
        
        let fileRightEHAP1Manager = FileManager.default
        let rightEHAP1Path = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: rightEHAP1SummaryCSVName)
        if fileRightEHAP1Manager.fileExists(atPath: rightEHAP1Path[0]) {
            let rightEHAP1FilePath = URL(fileURLWithPath: rightEHAP1Path[0])
            if rightEHAP1FilePath.isFileURL  {
                dataFileURL14 = rightEHAP1FilePath
                print("rightEHAP1FilePath: \(rightEHAP1FilePath)")
                print("rightEHAP1URL14: \(dataFileURL14)")
                print("rightEHAP1 Input File Exists")
            } else {
                print("rightEHAP1 Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL14)
            print(results)
            print("rightEHAP1Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldRightFinalGainsArraySample1: String = results[row:0, column: 0]
            let fieldRightFinalGainsArraySample2: String = results[row:0, column: 1]
            let fieldRightFinalGainsArraySample3: String = results[row:0, column: 2]
            let fieldRightFinalGainsArraySample4: String = results[row:0, column: 3]
            let fieldRightFinalGainsArraySample5: String = results[row:0, column: 4]
            let fieldRightFinalGainsArraySample6: String = results[row:0, column: 5]
            let fieldRightFinalGainsArraySample7: String = results[row:0, column: 6]
            let fieldRightFinalGainsArraySample8: String = results[row:0, column: 7]
            let fieldRightFinalGainsArraySample9: String = results[row:0, column: 8]
            let fieldRightFinalGainsArraySample10: String = results[row:0, column: 9]
            let fieldRightFinalGainsArraySample11: String = results[row:0, column: 10]
            let fieldRightFinalGainsArraySample12: String = results[row:0, column: 11]
            let fieldRightFinalGainsArraySample13: String = results[row:0, column: 12]
            let fieldRightFinalGainsArraySample14: String = results[row:0, column: 13]
            let fieldRightFinalGainsArraySample15: String = results[row:0, column: 14]
            let fieldRightFinalGainsArraySample16: String = results[row:0, column: 15]
            
            let fieldRightFinalStoredRightFinalGainsArray: String = results[row:1, column: 0]

            
            print("fieldRightFinalGainsArraySample1: \(fieldRightFinalGainsArraySample1)")
            print("fieldRightFinalGainsArraySample2: \(fieldRightFinalGainsArraySample2)")
            print("fieldRightFinalGainsArraySample3: \(fieldRightFinalGainsArraySample3)")
            print("fieldRightFinalGainsArraySample4: \(fieldRightFinalGainsArraySample4)")
            print("fieldRightFinalGainsArraySample5: \(fieldRightFinalGainsArraySample5)")
            print("fieldRightFinalGainsArraySample6: \(fieldRightFinalGainsArraySample6)")
            print("fieldRightFinalGainsArraySample7: \(fieldRightFinalGainsArraySample7)")
            print("fieldRightFinalGainsArraySample8: \(fieldRightFinalGainsArraySample8)")
            print("fieldRightFinalGainsArraySample9: \(fieldRightFinalGainsArraySample9)")
            print("fieldRightFinalGainsArraySample10: \(fieldRightFinalGainsArraySample10)")
            print("fieldRightFinalGainsArraySample11: \(fieldRightFinalGainsArraySample11)")
            print("fieldRightFinalGainsArraySample12: \(fieldRightFinalGainsArraySample12)")
            print("fieldRightFinalGainsArraySample13: \(fieldRightFinalGainsArraySample13)")
            print("fieldRightFinalGainsArraySample14: \(fieldRightFinalGainsArraySample14)")
            print("fieldRightFinalGainsArraySample15: \(fieldRightFinalGainsArraySample15)")
            print("fieldRightFinalGainsArraySample16: \(fieldRightFinalGainsArraySample16)")
            print("fieldRightFinalStoredRightFinalGainsArray: \(fieldRightFinalStoredRightFinalGainsArray)")
            
            let inputRTFinalGainsArraySample1 = Float(fieldRightFinalGainsArraySample1)
            inputRightFinalGainsArraySample1 = inputRTFinalGainsArraySample1 ?? -99.9

            let inputRTFinalGainsArraySample2 = Float(fieldRightFinalGainsArraySample2)
            inputRightFinalGainsArraySample2 = inputRTFinalGainsArraySample2 ?? -99.9
            
            let inputRTFinalGainsArraySample3 = Float(fieldRightFinalGainsArraySample2)
            inputRightFinalGainsArraySample3 = inputRTFinalGainsArraySample3 ?? -99.9
            
            let inputRTFinalGainsArraySample4 = Float(fieldRightFinalGainsArraySample4)
            inputRightFinalGainsArraySample4 = inputRTFinalGainsArraySample4 ?? -99.9
            
            let inputRTFinalGainsArraySample5 = Float(fieldRightFinalGainsArraySample5)
            inputRightFinalGainsArraySample5 = inputRTFinalGainsArraySample5 ?? -99.9
            
            let inputRTFinalGainsArraySample6 = Float(fieldRightFinalGainsArraySample6)
            inputRightFinalGainsArraySample6 = inputRTFinalGainsArraySample6 ?? -99.9
            
            let inputRTFinalGainsArraySample7 = Float(fieldRightFinalGainsArraySample7)
            inputRightFinalGainsArraySample7 = inputRTFinalGainsArraySample7 ?? -99.9
            
            let inputRTFinalGainsArraySample8 = Float(fieldRightFinalGainsArraySample8)
            inputRightFinalGainsArraySample8 = inputRTFinalGainsArraySample8 ?? -99.9
            
            let inputRTFinalGainsArraySample9 = Float(fieldRightFinalGainsArraySample9)
            inputRightFinalGainsArraySample9 = inputRTFinalGainsArraySample9 ?? -99.9
            
            let inputRTFinalGainsArraySample10 = Float(fieldRightFinalGainsArraySample10)
            inputRightFinalGainsArraySample10 = inputRTFinalGainsArraySample10 ?? -99.9
            
            let inputRTFinalGainsArraySample11 = Float(fieldRightFinalGainsArraySample11)
            inputRightFinalGainsArraySample11 = inputRTFinalGainsArraySample11 ?? -99.9
            
            let inputRTFinalGainsArraySample12 = Float(fieldRightFinalGainsArraySample12)
            inputRightFinalGainsArraySample12 = inputRTFinalGainsArraySample12 ?? -99.9
            
            let inputRTFinalGainsArraySample13 = Float(fieldRightFinalGainsArraySample13)
            inputRightFinalGainsArraySample13 = inputRTFinalGainsArraySample13 ?? -99.9
            
            let inputRTFinalGainsArraySample14 = Float(fieldRightFinalGainsArraySample14)
            inputRightFinalGainsArraySample14 = inputRTFinalGainsArraySample14 ?? -99.9
            
            let inputRTFinalGainsArraySample15 = Float(fieldRightFinalGainsArraySample15)
            inputRightFinalGainsArraySample15 = inputRTFinalGainsArraySample15 ?? -99.9
            
            let inputRTFinalGainsArraySample16 = Float(fieldRightFinalGainsArraySample16)
            inputRightFinalGainsArraySample16 = inputRTFinalGainsArraySample16 ?? -99.9
            
            let inputRTFinalStoredRightFinalGainsArray = Float(fieldRightFinalStoredRightFinalGainsArray)
            inputRightFinalStoredRightFinalGainsArray = inputRTFinalStoredRightFinalGainsArray ?? -99.9
            
            print("inputRightFinalGainsArraySample1: \(inputRightFinalGainsArraySample1)")
            print("inputRightFinalGainsArraySample2: \(inputRightFinalGainsArraySample2)")
            print("inputRightFinalGainsArraySample3: \(inputRightFinalGainsArraySample3)")
            print("inputRightFinalGainsArraySample4: \(inputRightFinalGainsArraySample4)")
            print("inputRightFinalGainsArraySample5: \(inputRightFinalGainsArraySample5)")
            print("inputRightFinalGainsArraySample6: \(inputRightFinalGainsArraySample6)")
            print("inputRightFinalGainsArraySample7: \(inputRightFinalGainsArraySample7)")
            print("inputRightFinalGainsArraySample8: \(inputRightFinalGainsArraySample8)")
            print("inputRightFinalGainsArraySample9: \(inputRightFinalGainsArraySample9)")
            print("inputRightFinalGainsArraySample10: \(inputRightFinalGainsArraySample10)")
            print("inputRightFinalGainsArraySample11: \(inputRightFinalGainsArraySample11)")
            print("inputRightFinalGainsArraySample12: \(inputRightFinalGainsArraySample12)")
            print("inputRightFinalGainsArraySample13: \(inputRightFinalGainsArraySample13)")
            print("inputRightFinalGainsArraySample14: \(inputRightFinalGainsArraySample14)")
            print("inputRightFinalGainsArraySample15: \(inputRightFinalGainsArraySample15)")
            print("inputRightFinalGainsArraySample16: \(inputRightFinalGainsArraySample16)")
        } catch {
            print("Error in reading onekHZ results")
        }
    }
    
    func leftEHAP1InputResultsCSVReader() async {
      
        let leftEHAP1SummaryCSVName = [inputEHAP1LeftSummaryCSVName]
        
        let fileLeftEHAP1Manager = FileManager.default
        let leftEHAP1Path = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: leftEHAP1SummaryCSVName)
        if fileLeftEHAP1Manager.fileExists(atPath: leftEHAP1Path[0]) {
            let leftEHAP1FilePath = URL(fileURLWithPath: leftEHAP1Path[0])
            if leftEHAP1FilePath.isFileURL  {
                dataFileURL15 = leftEHAP1FilePath
                print("LeftEHAP1FilePath: \(leftEHAP1FilePath)")
                print("LeftEHAP1URL15: \(dataFileURL15)")
                print("LeftEHAP1 Input File Exists")
            } else {
                print("LeftEHAP1 Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL15)
            print(results)
            print("LeftEHAP1Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLeftFinalGainsArraySample1: String = results[row:0, column: 0]
            let fieldLeftFinalGainsArraySample2: String = results[row:0, column: 1]
            let fieldLeftFinalGainsArraySample3: String = results[row:0, column: 2]
            let fieldLeftFinalGainsArraySample4: String = results[row:0, column: 3]
            let fieldLeftFinalGainsArraySample5: String = results[row:0, column: 4]
            let fieldLeftFinalGainsArraySample6: String = results[row:0, column: 5]
            let fieldLeftFinalGainsArraySample7: String = results[row:0, column: 6]
            let fieldLeftFinalGainsArraySample8: String = results[row:0, column: 7]
            let fieldLeftFinalGainsArraySample9: String = results[row:0, column: 8]
            let fieldLeftFinalGainsArraySample10: String = results[row:0, column: 9]
            let fieldLeftFinalGainsArraySample11: String = results[row:0, column: 10]
            let fieldLeftFinalGainsArraySample12: String = results[row:0, column: 11]
            let fieldLeftFinalGainsArraySample13: String = results[row:0, column: 12]
            let fieldLeftFinalGainsArraySample14: String = results[row:0, column: 13]
            let fieldLeftFinalGainsArraySample15: String = results[row:0, column: 14]
            let fieldLeftFinalGainsArraySample16: String = results[row:0, column: 15]
            
            let fieldLeftFinalStoredLeftFinalGainsArray: String = results[row:1, column: 0]

            
            print("fieldLeftFinalGainsArraySample1: \(fieldLeftFinalGainsArraySample1)")
            print("fieldLeftFinalGainsArraySample2: \(fieldLeftFinalGainsArraySample2)")
            print("fieldLeftFinalGainsArraySample3: \(fieldLeftFinalGainsArraySample3)")
            print("fieldLeftFinalGainsArraySample4: \(fieldLeftFinalGainsArraySample4)")
            print("fieldLeftFinalGainsArraySample5: \(fieldLeftFinalGainsArraySample5)")
            print("fieldLeftFinalGainsArraySample6: \(fieldLeftFinalGainsArraySample6)")
            print("fieldLeftFinalGainsArraySample7: \(fieldLeftFinalGainsArraySample7)")
            print("fieldLeftFinalGainsArraySample8: \(fieldLeftFinalGainsArraySample8)")
            print("fieldLeftFinalGainsArraySample9: \(fieldLeftFinalGainsArraySample9)")
            print("fieldLeftFinalGainsArraySample10: \(fieldLeftFinalGainsArraySample10)")
            print("fieldLeftFinalGainsArraySample11: \(fieldLeftFinalGainsArraySample11)")
            print("fieldLeftFinalGainsArraySample12: \(fieldLeftFinalGainsArraySample12)")
            print("fieldLeftFinalGainsArraySample13: \(fieldLeftFinalGainsArraySample13)")
            print("fieldLeftFinalGainsArraySample14: \(fieldLeftFinalGainsArraySample14)")
            print("fieldLeftFinalGainsArraySample15: \(fieldLeftFinalGainsArraySample15)")
            print("fieldLeftFinalGainsArraySample16: \(fieldLeftFinalGainsArraySample16)")
            print("fieldLeftFinalStoredLeftFinalGainsArray: \(fieldLeftFinalStoredLeftFinalGainsArray)")
            
            let inputRTFinalGainsArraySample1 = Float(fieldLeftFinalGainsArraySample1)
            inputLeftFinalGainsArraySample1 = inputRTFinalGainsArraySample1 ?? -99.9

            let inputRTFinalGainsArraySample2 = Float(fieldLeftFinalGainsArraySample2)
            inputLeftFinalGainsArraySample2 = inputRTFinalGainsArraySample2 ?? -99.9
            
            let inputRTFinalGainsArraySample3 = Float(fieldLeftFinalGainsArraySample2)
            inputLeftFinalGainsArraySample3 = inputRTFinalGainsArraySample3 ?? -99.9
            
            let inputRTFinalGainsArraySample4 = Float(fieldLeftFinalGainsArraySample4)
            inputLeftFinalGainsArraySample4 = inputRTFinalGainsArraySample4 ?? -99.9
            
            let inputRTFinalGainsArraySample5 = Float(fieldLeftFinalGainsArraySample5)
            inputLeftFinalGainsArraySample5 = inputRTFinalGainsArraySample5 ?? -99.9
            
            let inputRTFinalGainsArraySample6 = Float(fieldLeftFinalGainsArraySample6)
            inputLeftFinalGainsArraySample6 = inputRTFinalGainsArraySample6 ?? -99.9
            
            let inputRTFinalGainsArraySample7 = Float(fieldLeftFinalGainsArraySample7)
            inputLeftFinalGainsArraySample7 = inputRTFinalGainsArraySample7 ?? -99.9
            
            let inputRTFinalGainsArraySample8 = Float(fieldLeftFinalGainsArraySample8)
            inputLeftFinalGainsArraySample8 = inputRTFinalGainsArraySample8 ?? -99.9
            
            let inputRTFinalGainsArraySample9 = Float(fieldLeftFinalGainsArraySample9)
            inputLeftFinalGainsArraySample9 = inputRTFinalGainsArraySample9 ?? -99.9
            
            let inputRTFinalGainsArraySample10 = Float(fieldLeftFinalGainsArraySample10)
            inputLeftFinalGainsArraySample10 = inputRTFinalGainsArraySample10 ?? -99.9
            
            let inputRTFinalGainsArraySample11 = Float(fieldLeftFinalGainsArraySample11)
            inputLeftFinalGainsArraySample11 = inputRTFinalGainsArraySample11 ?? -99.9
            
            let inputRTFinalGainsArraySample12 = Float(fieldLeftFinalGainsArraySample12)
            inputLeftFinalGainsArraySample12 = inputRTFinalGainsArraySample12 ?? -99.9
            
            let inputRTFinalGainsArraySample13 = Float(fieldLeftFinalGainsArraySample13)
            inputLeftFinalGainsArraySample13 = inputRTFinalGainsArraySample13 ?? -99.9
            
            let inputRTFinalGainsArraySample14 = Float(fieldLeftFinalGainsArraySample14)
            inputLeftFinalGainsArraySample14 = inputRTFinalGainsArraySample14 ?? -99.9
            
            let inputRTFinalGainsArraySample15 = Float(fieldLeftFinalGainsArraySample15)
            inputLeftFinalGainsArraySample15 = inputRTFinalGainsArraySample15 ?? -99.9
            
            let inputRTFinalGainsArraySample16 = Float(fieldLeftFinalGainsArraySample16)
            inputLeftFinalGainsArraySample16 = inputRTFinalGainsArraySample16 ?? -99.9
            
            let inputRTFinalStoredLeftFinalGainsArray = Float(fieldLeftFinalStoredLeftFinalGainsArray)
            inputLeftFinalStoredLeftFinalGainsArray = inputRTFinalStoredLeftFinalGainsArray ?? -99.9
            
            print("inputLeftFinalGainsArraySample1: \(inputLeftFinalGainsArraySample1)")
            print("inputLeftFinalGainsArraySample2: \(inputLeftFinalGainsArraySample2)")
            print("inputLeftFinalGainsArraySample3: \(inputLeftFinalGainsArraySample3)")
            print("inputLeftFinalGainsArraySample4: \(inputLeftFinalGainsArraySample4)")
            print("inputLeftFinalGainsArraySample5: \(inputLeftFinalGainsArraySample5)")
            print("inputLeftFinalGainsArraySample6: \(inputLeftFinalGainsArraySample6)")
            print("inputLeftFinalGainsArraySample7: \(inputLeftFinalGainsArraySample7)")
            print("inputLeftFinalGainsArraySample8: \(inputLeftFinalGainsArraySample8)")
            print("inputLeftFinalGainsArraySample9: \(inputLeftFinalGainsArraySample9)")
            print("inputLeftFinalGainsArraySample10: \(inputLeftFinalGainsArraySample10)")
            print("inputLeftFinalGainsArraySample11: \(inputLeftFinalGainsArraySample11)")
            print("inputLeftFinalGainsArraySample12: \(inputLeftFinalGainsArraySample12)")
            print("inputLeftFinalGainsArraySample13: \(inputLeftFinalGainsArraySample13)")
            print("inputLeftFinalGainsArraySample14: \(inputLeftFinalGainsArraySample14)")
            print("inputLeftFinalGainsArraySample15: \(inputLeftFinalGainsArraySample15)")
            print("inputLeftFinalGainsArraySample16: \(inputLeftFinalGainsArraySample16)")
        } catch {
            print("Error in reading onekHZ results")
        }
    }
    

    
    func getGainDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }

    
    func checkGain2_5DataLink() async {
        let dataGain2_5Name = ["2_5.csv"]
        let fileGain2_5Manager = FileManager.default
        let dataGain2_5Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain2_5Name)
        if fileGain2_5Manager.fileExists(atPath: dataGain2_5Path[0]) {
            let dataGain2_5FilePath = URL(fileURLWithPath: dataGain2_5Path[0])
            if dataGain2_5FilePath.isFileURL  {
                dataFileURLGain1 = dataGain2_5FilePath
                print("2_5.csv dataFilePath: \(dataGain2_5FilePath)")
                print("2_5.csv dataFileURL: \(dataFileURLGain1)")
                print("2_5.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 2.5
            } else {
                print("2_5.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain4DataLink() async {
        let dataGain4Name = ["4.csv"]
        let fileGain4Manager = FileManager.default
        let dataGain4Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain4Name)
        if fileGain4Manager.fileExists(atPath: dataGain4Path[0]) {
            let dataGain4FilePath = URL(fileURLWithPath: dataGain4Path[0])
            if dataGain4FilePath.isFileURL  {
                dataFileURLGain2 = dataGain4FilePath
                print("4.csv dataFilePath: \(dataGain4FilePath)")
                print("4.csv dataFileURL: \(dataFileURLGain2)")
                print("4.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 4
            } else {
                print("4.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain5DataLink() async {
        let dataGain5Name = ["5.csv"]
        let fileGain5Manager = FileManager.default
        let dataGain5Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain5Name)
        if fileGain5Manager.fileExists(atPath: dataGain5Path[0]) {
            let dataGain5FilePath = URL(fileURLWithPath: dataGain5Path[0])
            if dataGain5FilePath.isFileURL  {
                dataFileURLGain3 = dataGain5FilePath
                print("5.csv dataFilePath: \(dataGain5FilePath)")
                print("5.csv dataFileURL: \(dataFileURLGain3)")
                print("5.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 5
            } else {
                print("5.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain7DataLink() async {
        let dataGain7Name = ["7.csv"]
        let fileGain7Manager = FileManager.default
        let dataGain7Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain7Name)
        if fileGain7Manager.fileExists(atPath: dataGain7Path[0]) {
            let dataGain7FilePath = URL(fileURLWithPath: dataGain7Path[0])
            if dataGain7FilePath.isFileURL  {
                dataFileURLGain4 = dataGain7FilePath
                print("7.csv dataFilePath: \(dataGain7FilePath)")
                print("7.csv dataFileURL: \(dataFileURLGain4)")
                print("7.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 7
            } else {
                print("7.csv Data File Path Does Not Exist")
            }
        }
    }

    func checkGain8DataLink() async {
        let dataGain8Name = ["8.csv"]
        let fileGain8Manager = FileManager.default
        let dataGain8Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain8Name)
        if fileGain8Manager.fileExists(atPath: dataGain8Path[0]) {
            let dataGain8FilePath = URL(fileURLWithPath: dataGain8Path[0])
            if dataGain8FilePath.isFileURL  {
                dataFileURLGain5 = dataGain8FilePath
                print("8.csv dataFilePath: \(dataGain8FilePath)")
                print("8.csv dataFileURL: \(dataFileURLGain5)")
                print("8.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 8
            } else {
                print("8.csv Data File Path Does Not Exist")
            }
        }
    }

    func checkGain11DataLink() async {
        let dataGain11Name = ["11.csv"]
        let fileGain11Manager = FileManager.default
        let dataGain11Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain11Name)
        if fileGain11Manager.fileExists(atPath: dataGain11Path[0]) {
            let dataGain11FilePath = URL(fileURLWithPath: dataGain11Path[0])
            if dataGain11FilePath.isFileURL  {
                dataFileURLGain6 = dataGain11FilePath
                print("11.csv dataFilePath: \(dataGain11FilePath)")
                print("11.csv dataFileURL: \(dataFileURLGain6)")
                print("11.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 11
            } else {
                print("11.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain16DataLink() async {
        let dataGain16Name = ["16.csv"]
        let fileGain16Manager = FileManager.default
        let dataGain16Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain16Name)
        if fileGain16Manager.fileExists(atPath: dataGain16Path[0]) {
            let dataGain16FilePath = URL(fileURLWithPath: dataGain16Path[0])
            if dataGain16FilePath.isFileURL  {
                dataFileURLGain7 = dataGain16FilePath
                print("16.csv dataFilePath: \(dataGain16FilePath)")
                print("16.csv dataFileURL: \(dataFileURLGain7)")
                print("16.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 16
            } else {
                print("16.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain17DataLink() async {
        let dataGain17Name = ["17.csv"]
        let fileGain17Manager = FileManager.default
        let dataGain17Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain17Name)
        if fileGain17Manager.fileExists(atPath: dataGain17Path[0]) {
            let dataGain17FilePath = URL(fileURLWithPath: dataGain17Path[0])
            if dataGain17FilePath.isFileURL  {
                dataFileURLGain8 = dataGain17FilePath
                print("17.csv dataFilePath: \(dataGain17FilePath)")
                print("17.csv dataFileURL: \(dataFileURLGain8)")
                print("17.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 17
            } else {
                print("17.csv Data File Path Does Not Exist")
            }
        }
    }
    
    func checkGain24DataLink() async {
        let dataGain24Name = ["24.csv"]
        let fileGain24Manager = FileManager.default
        let dataGain24Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain24Name)
        if fileGain24Manager.fileExists(atPath: dataGain24Path[0]) {
            let dataGain24FilePath = URL(fileURLWithPath: dataGain24Path[0])
            if dataGain24FilePath.isFileURL  {
                dataFileURLGain9 = dataGain24FilePath
                print("24.csv dataFilePath: \(dataGain24FilePath)")
                print("24.csv dataFileURL: \(dataFileURLGain9)")
                print("24.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 24
            } else {
                print("24.csv Data File Path Does Not Exist")
            }
        }
    }

    func checkGain27DataLink() async {
        let dataGain27Name = ["27.csv"]
        let fileGain27Manager = FileManager.default
        let dataGain27Path = (await self.getGainDataLinkPath() as NSString).strings(byAppendingPaths: dataGain27Name)
        if fileGain27Manager.fileExists(atPath: dataGain27Path[0]) {
            let dataGain27FilePath = URL(fileURLWithPath: dataGain27Path[0])
            if dataGain27FilePath.isFileURL  {
                dataFileURLGain10 = dataGain27FilePath
                print("27.csv dataFilePath: \(dataGain27FilePath)")
                print("27.csv dataFileURL: \(dataFileURLGain10)")
                print("27.csv Input File Exists")
                // CHANGE THIS VARIABLE PER VIEW
//                let gainSettingArray = 27
            } else {
                print("27.csv Data File Path Does Not Exist")
            }
        }
    }




//    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
//    @State var inputComparedLastName = String()
    
    func comparedLastNameCSVReader() async {
        let dataSetupName = inputFinalComparedLastNameCSV
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURL16 = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURL16)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL16)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputComparedLastName = fieldLastName
            print("inputLastName: \(inputComparedLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
}

extension HoldingCSVInputModel {
    
//    func checkDataLink() async {
//        let dataName = ["InputSetupResultsCSV.csv"]
//        let fileManager = FileManager.default
//        let dataPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: dataName)
//        if fileManager.fileExists(atPath: dataPath[0]) {
//            let dataFilePath = URL(fileURLWithPath: dataPath[0])
//            if dataFilePath.isFileURL  {
//                dataFileURL = dataFilePath
//                print(dataFilePath)
//                print(dataFileURL)
//            } else {
//                print("Data File Path Does Not Exist")
//            }
//        }
//    }
//
//    func csvReader() async {
//        do {
//            let results = try CSVReader.decode(input: dataFileURL)
//            print(results)
//            print("Results Read")
//            let rows = results.columns
//            print("rows: \(rows)")
//            let rowAge = results[6]
//            let rowGender = results[7]
//            let rowGenderIndex = results[8]
//            let rowSex = results[9]
//            let rowUserUUID = results[10]
//            print("rowAge: \(rowAge)")
//            print("rowGender: \(rowGender)")
//            print("rowGenderIndex: \(rowGenderIndex)")
//            print("rowSex: \(rowSex)")
//            print("rowUserUUID: \(rowUserUUID)")
//// THIS IS FUNCTIONAL FOR GETTING ELEMENT VALUE FOR INPUTSETUPRESULTSCSV.CSV
//            let fieldAge: String = results[row:6, column: 0]
//            let fieldGender: String = results[row:7, column: 0]
//            let fieldGenderIndex: String = results[row:8, column: 0]
//            let fieldSex: String = results[row:9, column: 0]
//            let fieldUserUUID: String = results[row:10, column: 0]
//            print("fieldAge: \(fieldAge)")
//            print("fieldGender: \(fieldGender)")
//            print("fieldGenderIndex: \(fieldGenderIndex)")
//            print("fieldSex: \(fieldSex)")
//            print("fieldUserUUID: \(fieldUserUUID)")
//        } catch {
//            print("Error in reading results")
//        }
//    }
//
//    // THIS IS FUNCTIONAL FOR GETTING ELEMENT VALUE FOR INPUTSETUPRESULTSCSV.CSV
//        func csvReaderRecords() async {
//            do {
//                let reader = try CSVReader(input: dataFileURL) { $0.headerStrategy = .firstLine }
//                print("reader successful")
//                let headers = reader.headers
//                print("headers: \(headers)")
//                let recordA = try reader.readRecord()
//                let rowA = recordA!.row
//                let fieldA = recordA![0]
//                print(rowA)
//                print(fieldA)
//                let recordB = try reader.readRecord()
//                let rowB = recordB!.row
//                let fieldB = recordB![0]
//                print(rowB)
//                print(fieldB)
//                let recordC = try reader.readRecord()
//                let rowC = recordC!.row
//                let fieldC = recordC![0]
//                print(rowC)
//                print(fieldC)
//                let recordD = try reader.readRecord()
//                let rowD = recordD!.row
//                let fieldD = recordD![0]
//                print(rowD)
//                print(fieldD)
//                let recordE = try reader.readRecord()
//                let rowE = recordE!.row
//                let fieldE = recordE![0]
//                print(rowE)
//                print(fieldE)
//                let recordF = try reader.readRecord()
//                let rowF = recordF!.row
//                let fieldF = recordF![0]
//                print(rowF)
//                print(fieldF)
//                let recordG = try reader.readRecord()
//                let rowG = recordG!.row
//                let fieldG = recordG![0]
//                print(rowG)
//                print(fieldG)
//                let recordH = try reader.readRecord()
//                let rowH = recordH!.row
//                let fieldH = recordH![0]
//                print(rowH)
//                print(fieldH)
//                let recordI = try reader.readRecord()
//                let rowI = recordI!.row
//                let fieldI = recordI![0]
//                print(rowI)
//                print(fieldI)
//                let recordJ = try reader.readRecord()
//                let rowJ = recordJ!.row
//                let fieldJ = recordJ![0]
//                print(rowJ)
//                print(fieldJ)
//                print("Elements Successful")
//            } catch {
//                print("read records error")
//            }
//        }
}
