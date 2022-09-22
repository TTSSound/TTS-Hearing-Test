//
//  ClosingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI
import CodableCSV

//struct SetupResults: Codable, Identifiable {
//    let id: Int
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



struct ClosingView: View {
    
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
    
    
    @State var dataFileURL = URL(fileURLWithPath: "")
    @State var dataFileURL1 = URL(fileURLWithPath: "")
    @State var dataFileURL2 = URL(fileURLWithPath: "")
    @State var dataFileURL3 = URL(fileURLWithPath: "")
    @State var dataFileURL4 = URL(fileURLWithPath: "")
    @State var dataFileURL5 = URL(fileURLWithPath: "")
    @State var dataFileURL6 = URL(fileURLWithPath: "")
    @State var dataFileURL7 = URL(fileURLWithPath: "")
    @State var dataFileURL8 = URL(fileURLWithPath: "")
    @State var dataFileURL9 = URL(fileURLWithPath: "")
    @State var dataFileURL10 = URL(fileURLWithPath: "")
    @State var dataFileURL11 = URL(fileURLWithPath: "")
    @State var dataFileURL12 = URL(fileURLWithPath: "")
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
    
    
    
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Closing View & End of Test Protocol / Results / App")
                    .foregroundColor(.white)
                Spacer()
                Text("Return Home At This Time")
                    .font(.title)
                    .foregroundColor(.red)
                Spacer()
//                Button {
//                    Task {
////                        await checkSetupDataLink()
//                        await inAppPurchaseCSVReader()
//                    }
//                } label: {
//                    Text("Try CSV Reader")
//                        .foregroundColor(.green)
//                }
//                Spacer()
                
                // We are done with testing (for now if EHA)
                
                // Here is that to expect next
                    // Email of detailed results that you own
                    // high res image of results
                
                // Filter generation if selected and when you will receive them in your email
                
                // Don't forget to turn off Do Not Distrub and set volume back to your normal listening level
                
                // Final opportunity to purchase EHA test
                    // Possibly at a discount??
                
                // opportunity to purchase filters, calibrated equipment, lifetime membership at a discount
                    // Especially for EHA
            }
        }
    }
    
    func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
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

//struct ClosingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClosingView()
//    }
//}
