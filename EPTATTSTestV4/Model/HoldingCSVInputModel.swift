//
//  HoldingCSVInputModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/2/22.
//

import SwiftUI
import CodableCSV




class HoldingCSVInputModel: ObservableObject {
    
    //Setup Model Variables
    @State var inputAge = Int()
    @State var inputGender = String()
    @State var inputGenderIndex = Int()
    @State var inputSex = Int()
    @State var inputUserUUID = String()
    
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
    @State var dataFileURL13 = URL(fileURLWithPath: "")
    
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
    
    
    
    //ENVDataObjectModel
    let inputSummaryCSVName = "InputSummaryResultsCSV.csv"
    let inputDetailedCSVName = "InputDetailedResultsCSV.csv"

    
    
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
            let fieldAge: String = results[row:6, column: 0]
            let fieldGender: String = results[row:7, column: 0]
            let fieldGenderIndex: String = results[row:8, column: 0]
            let fieldSex: String = results[row:9, column: 0]
            let fieldUserUUID: String = results[row:10, column: 0]
            print("fieldAge: \(fieldAge)")
            print("fieldGender: \(fieldGender)")
            print("fieldGenderIndex: \(fieldGenderIndex)")
            print("fieldSex: \(fieldSex)")
            print("fieldUserUUID: \(fieldUserUUID)")
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
                print("systemSettingsEndEHAFileURL9: \(dataFileURL11)")
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
                print("InAppPurchaseURL9: \(dataFileURL12)")
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
