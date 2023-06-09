//
//  InAppPurchaseView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase
import FileProvider

struct SaveFinalTestPurchase: Codable {  // This is a model
    var jsonFinalPurchasedEHATestUUID = [String]()
    var jsonFinalPurchasedEPTATestUUID = [String]()
    var jsonFinalPurchasedTestTolken = [String]()
    var jsonFinalTestPurchased = [Int]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalPurchasedEHATestUUID
        case jsonFinalPurchasedEPTATestUUID
        case jsonFinalPurchasedTestTolken
        case jsonFinalTestPurchased
    }
}

struct InAppPurchaseView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var inputSetupLastName = String()
    @State private var inputBetaLastName = String()
//    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var EHAPurchased: Bool = false
    @State var EPTAPurchased: Bool = false
    @State var submissionOrPurchaseTest = Int()
    
    @State var selectedTest = Int()
    @State var purchasedEHAUUID = String()
    @State var purchasedEPTAUUID = String()
    @State var simpleUUID = String()
    
    
    @State var userPurchasedTest = [Int]()   // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
    @State var userPurchasedEHAUUIDString = String()
    @State var userPurchasedEPTAUUIDString = String()
    @State var finalPurchasedEHATestUUID: [String] = [String]()
    @State var finalPurchasedEPTATestUUID: [String] = [String]()
    @State var finalPurchasedTestTolken: [String] = [String]()
    @State var finalTestPurchased: [Int] = [Int]()  // 1 = Purchased The EHA Test, 2 = EPTA
    
    let fileTestPurchasedName = ["TestPurchase.json"]
    let testPurchasedCSVName = "TestPurchaseCSV.csv"
    let inputTestPurchasedCSVName = "InputTestPurchaseCSV.csv"
    
    @State var saveFinalTestPurchase: SaveFinalTestPurchase? = nil
    
    @State var testPurchased: Bool = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("In-App Purchases")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                Toggle("Purchase EHA Test", isOn: $EHAPurchased)
                    .foregroundColor(colorModel.neonGreen)
                    .font(.title)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .onChange(of: EHAPurchased) { EHATest in
                        if EHATest == true {
                            selectedTest = 1
                            EPTAPurchased = false
                        }
                    }
                    .padding(.bottom, 60)
                    .padding(.top, 60)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                Toggle("Purchase EPTA Test", isOn: $EPTAPurchased)
                    .foregroundColor(colorModel.tiffanyBlue)
                    .font(.title)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .onChange(of: EPTAPurchased) { purchasedEPTATest in
                        if purchasedEPTATest == true {
                            selectedTest = 2
                            EHAPurchased = false
                        }
                    }
                    .padding(.bottom, 60)
                    .padding(.top, 60)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                Spacer()
                if testPurchased == false {
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                await completePurchase()
                                await saveTestSelectionTolkens()
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("Submit & Complete Purchase")
                                    .font(.title3)
                                Spacer()
                                Image(systemName: "arrow.up.doc.fill")
                                    .font(.title)
                                Spacer()
                            }
                            .frame(width: 350, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        Spacer()
                    }
                } else if testPurchased == true {
                    NavigationLink(destination: CalibrationAssessmentView()) {
                        HStack{
                            Spacer()
                            Text("Continue To Calibrated Devices")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                                .font(.title)
                            Spacer()
                        }
                        .frame(width: 350, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
                Spacer()
            }
            .onAppear {
                Task{
                    await setupCSVReader()
//                    await comparedLastNameCSVReader()
//                    await compareLastNames()
                }
            }
            .onChange(of: isOkayToUpload) { uploadValue in
                if uploadValue == true {
                    Task {
                        await uploadInAppPurchase()
                    }
                } else {
                    print("Fatal Error in uploadValue Change Of logic")
                }
            }
        }
    }
}

extension InAppPurchaseView {
    //MARK: -Methods Extension
    func completePurchase() async {
        if EHAPurchased == true && EPTAPurchased == false {
            selectedTest = 1
            purchasedEHAUUID = UUID().uuidString
            userPurchasedTest.append(selectedTest)
            userPurchasedEHAUUIDString.append(purchasedEHAUUID)
            print("EHA userUUID: \(purchasedEHAUUID)")
            print("EHA selectedTest: \(selectedTest)")
            print("EHA testSelectionModel userPurchasedEHAUUID: \(userPurchasedEHAUUIDString)")
            print("EHA testSelectionModel userPurchasedTest EHA: \(userPurchasedTest)")
            finalPurchasedEHATestUUID.append(userPurchasedEHAUUIDString)
            print("EHA testSelectionModel finalPurchasedEHATestUUID: \(finalPurchasedEHATestUUID)")
            finalPurchasedTestTolken.append(userPurchasedEHAUUIDString)
            finalTestPurchased.append(selectedTest)
            testPurchased = true
            //Making holding false values for EPTA
            let noEPTA = "NoEPTAPruchased"
            userPurchasedEPTAUUIDString.append(noEPTA)
            print("EHA testSelectionModel userPurchasedEPTAUUID: \(userPurchasedEPTAUUIDString)")
            finalPurchasedEPTATestUUID.append(userPurchasedEPTAUUIDString)
            print("EHA testSelectionModel finalPurchasedEPTATestUUID: \(finalPurchasedEPTATestUUID)")
            print("EHA PURCHASED!")
        } else if EHAPurchased == false && EPTAPurchased == true {
            selectedTest = 2
            purchasedEPTAUUID = UUID().uuidString
            userPurchasedTest.append(selectedTest)
            userPurchasedEPTAUUIDString.append(purchasedEPTAUUID)
            print("EPTA userUUID: \(purchasedEPTAUUID)")
            print("EPTA selectedTest: \(selectedTest)")
            print("EPTA testSelectionModel userPurchasedEPTAUUID: \(userPurchasedEPTAUUIDString)")
            print("EPTA testSelectionModel userPurchasedTest EPTA: \(userPurchasedTest)")
            finalPurchasedEPTATestUUID.append(userPurchasedEPTAUUIDString)
            print("EPTA testSelectionModel finalPurchasedEPTATestUUID: \(finalPurchasedEPTATestUUID)")
            finalPurchasedTestTolken.append(userPurchasedEPTAUUIDString)
            finalTestPurchased.append(selectedTest)
            testPurchased = true
            
            let noEHA = "NoEHAPurchased"
            userPurchasedEHAUUIDString.append(noEHA)
            print("EPTA testSelectionModel userPurchasedEHAAUUID: \(userPurchasedEHAUUIDString)")
            finalPurchasedEHATestUUID.append(userPurchasedEHAUUIDString)
            print("EPTA testSelectionModel finalPurchasedEPTATestUUID: \(finalPurchasedEHATestUUID)")
            print("EPTA PURCHASED!")
        } else {
            print("!!! Error in complete Purchase Logic")
            testPurchased = false
        }
    }
    
    //    func generateEHAUUID() async {
    //        purchasedEHAUUID = UUID().uuidString
    //        userPurchasedEHAUUIDString.append(purchasedEHAUUID)
    //
    //        userPurchasedTest.append(selectedTest)
    //        print("userUUID: \(purchasedEHAUUID)")
    //        print("selectedTest: \(selectedTest)")
    //        print("testSelectionModel userPurchasedEHAUUID: \(userPurchasedEHAUUIDString)")
    //        print("testSelectionModel userPurchasedTest EHA: \(userPurchasedTest)")
    //    }
    //
    //    func generateEPTAUUID() async {
    //        purchasedEPTAUUID = UUID().uuidString
    //        userPurchasedEPTAUUIDString.append(purchasedEPTAUUID)
    //        selectedTest = 2
    //        userPurchasedTest.append(selectedTest)
    //        print("userUUID: \(purchasedEPTAUUID)")
    //        print("testSelectionModel userPurchasedEPTAUUID: \(userPurchasedEPTAUUIDString)")
    //        print("testSelectionModel userPurchasedTest EPTA: \(userPurchasedTest)")
    //    }
    //
    //    func concatenatePurchaseTestFinalArrays() async {
    //        finalPurchasedEHATestUUID.append(userPurchasedEHAUUIDString)
    //        finalPurchasedEPTATestUUID.append(userPurchasedEPTAUUIDString)
    //        print("testSelectionModel finalPurchasedEHATestUUID: \(finalPurchasedEHATestUUID)")
    //        print("testSelectionModel finalPurchasedEPTATestUUID: \(finalPurchasedEPTATestUUID)")
    //    }
    //
    //    func assignFinalTestTolken() async {
    //        if selectedTest == 1 {
    //            finalPurchasedTestTolken.append(userPurchasedEHAUUIDString)
    //            finalTestPurchased.append(selectedTest)
    //        } else if selectedTest == 2 {
    //            finalPurchasedTestTolken.append(userPurchasedEPTAUUIDString)
    //            finalTestPurchased.append(selectedTest)
    //        } else {
    //            print("!!!Error in assignFinalTestTolken Logic")
    //        }
    //        print("finalTestPurchased: \(finalTestPurchased)")
    //        print("finalPurchasedTestTolken: \(finalPurchasedTestTolken)")
    //    }
    
    func saveTestSelectionTolkens() async {
        await getTestPurchaseData()
        await saveTestPurchaseToJSON()
        await writeTestPurchaseToCSV()
        await writeInputTestPurchaseToCSV()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, qos: .userInteractive) {
            isOkayToUpload = true
        }
    }
    
    func uploadInAppPurchase() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: "TestPurchase.json")
            uploadFile(fileName: testPurchasedCSVName)
            uploadFile(fileName: inputTestPurchasedCSVName)
        }
    }
}

extension InAppPurchaseView {
//MARK: -CSV/JSON Methods Extension
    func getTestPurchaseData() async {
        guard let testPurchaseData = await getTestPurchseJSONData() else { return }
        print("Json Test Purchase Data")
        print(testPurchaseData)
        let jsonTestPurchaseString = String(data: testPurchaseData, encoding: .utf8)
        print(jsonTestPurchaseString!)
        do {
        self.saveFinalTestPurchase = try JSONDecoder().decode(SaveFinalTestPurchase.self, from: testPurchaseData)
            print("JSON GetTestPurchaseData Run")
            print("data: \(testPurchaseData)")
        } catch let error {
            print("!!!Error decoding test purchase json data: \(error)")
        }
    }
    
    func getTestPurchseJSONData() async -> Data? {
        let saveFinalTestPurchase = SaveFinalTestPurchase (
            jsonFinalPurchasedEHATestUUID: finalPurchasedEHATestUUID,
            jsonFinalPurchasedEPTATestUUID: finalPurchasedEPTATestUUID,
            jsonFinalPurchasedTestTolken: finalPurchasedTestTolken,
            jsonFinalTestPurchased: finalTestPurchased)
        let jsonTestPurchaseData = try? JSONEncoder().encode(saveFinalTestPurchase)
        print("saveTestPurchase: \(saveFinalTestPurchase)")
        print("Json Encoded \(jsonTestPurchaseData!)")
        return jsonTestPurchaseData
    }
    
    func saveTestPurchaseToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let testPurchasePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let purchaseDocumentsDirectory = testPurchasePaths[0]
        print("purchaseDocumentsDirectory: \(purchaseDocumentsDirectory)")
        let testPurchaseFilePaths = purchaseDocumentsDirectory.appendingPathComponent(fileTestPurchasedName[0])
        print(testPurchaseFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonTestPurchaseData = try encoder.encode(saveFinalTestPurchase)
            print(jsonTestPurchaseData)
          
            try jsonTestPurchaseData.write(to: testPurchaseFilePaths)
        } catch {
            print("Error writing to JSON Test Purchase file: \(error)")
        }
    }

    func writeTestPurchaseToCSV() async {
        print("writeTestPurchaseToCSV Start")
        let stringFinalPurchasedEHATestUUID = "finalPurchasedEHATestUUID," + finalPurchasedEHATestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalPurchasedEPTATestUUID = "finalPurchasedEPTATestUUID," + finalPurchasedEPTATestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalPurchasedTestTolken = "finalTestTolkenPurchased," + finalPurchasedTestTolken.map { String($0) }.joined(separator: ",")
        let stringFinalTestPurchased = "finalTestPurchased," + finalTestPurchased.map { String($0) }.joined(separator: ",")
        do {
            let csvTestPurchasePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvTestPurchaseDocumentsDirectory = csvTestPurchasePath
            print("CSV Test Purchase DocumentsDirectory: \(csvTestPurchaseDocumentsDirectory)")
            let csvTestPurchaseFilePath = csvTestPurchaseDocumentsDirectory.appendingPathComponent(testPurchasedCSVName)
            print(csvTestPurchaseFilePath)
            let writerSetup = try CSVWriter(fileURL: csvTestPurchaseFilePath, append: false)
            try writerSetup.write(row: [stringFinalPurchasedEHATestUUID])
            try writerSetup.write(row: [stringFinalPurchasedEPTATestUUID])
            try writerSetup.write(row: [stringFinalPurchasedTestTolken])
            try writerSetup.write(row: [stringFinalTestPurchased])
            print("CVS Test Purchase Writer Success")
        } catch {
            print("CVSWriter Test Purchase Error or Error Finding File for Test Purchase CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputTestPurchaseToCSV() async {
        print("writeInputTestSelectionToCSV Start")
        let stringFinalPurchasedEHATestUUID = finalPurchasedEHATestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalPurchasedEPTATestUUID = finalPurchasedEPTATestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalPurchasedTestTolken = finalPurchasedTestTolken.map { String($0) }.joined(separator: ",")
        let stringFinalTestPurchased = finalTestPurchased.map { String($0) }.joined(separator: ",")
        do {
            let csvInputTestPurchasePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputTestPurchaseDocumentsDirectory = csvInputTestPurchasePath
            print("CSV Input Test Purchase DocumentsDirectory: \(csvInputTestPurchaseDocumentsDirectory)")
            let csvInputTestPurchaseFilePath = csvInputTestPurchaseDocumentsDirectory.appendingPathComponent(inputTestPurchasedCSVName)
            print(csvInputTestPurchaseFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputTestPurchaseFilePath, append: false)
            try writerSetup.write(row: [stringFinalPurchasedEHATestUUID])
            try writerSetup.write(row: [stringFinalPurchasedEPTATestUUID])
            try writerSetup.write(row: [stringFinalPurchasedTestTolken])
            try writerSetup.write(row: [stringFinalTestPurchased])
            print("CVS Input Test Purchase Writer Success")
        } catch {
            print("CVSWriter Input Test Purchase Error or Error Finding File for Input Test Purchase CSV \(error.localizedDescription)")
        }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
//    func comparedLastNameCSVReader() async {
//        let dataSetupName = inputFinalComparedLastNameCSV
//        let fileSetupManager = FileManager.default
//        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
//        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
//            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
//            if dataSetupFilePath.isFileURL  {
//                dataFileURLComparedLastName = dataSetupFilePath
//                print("dataSetupFilePath: \(dataSetupFilePath)")
//                print("dataFileURL1: \(dataFileURLComparedLastName)")
//                print("Setup Input File Exists")
//            } else {
//                print("Setup Data File Path Does Not Exist")
//            }
//        }
//        do {
//            let results = try CSVReader.decode(input: dataFileURLComparedLastName)
//            print(results)
//            print("Setup Results Read")
//            let rows = results.columns
//            print("rows: \(rows)")
//            let fieldLastName: String = results[row: 0, column: 0]
//            print("fieldLastName: \(fieldLastName)")
//            inputBetaLastName = fieldLastName
//            print("inputLastName: \(inputLastName)")
//        } catch {
//            print("Error in reading Last Name results")
//        }
//    }
    
    private func setupCSVReader() async {
        let dataSetupName = "InputSetupResultsCSV.csv"
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 1, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputLastName = fieldLastName
            print("inputLastName: \(inputLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
    
//    func compareLastNames() async {
//        if inputSetupLastName == inputBetaLastName && inputSetupLastName != "" {
//            inputLastName = inputSetupLastName
//        } else if inputLastName != inputBetaLastName && inputLastName != "" {
//            inputLastName = inputSetupLastName
//        } else {
//            inputLastName = "ErrorLastName"
//            print("Fatal Error in input or beta last name")
//        }
//    }
    
    private func uploadFile(fileName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let storageRef = Storage.storage().reference()
            let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
            let lastNameRef = storageRef.child(inputLastName)
            let fileManager = FileManager.default
            let filePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [fileName])
            if fileManager.fileExists(atPath: filePath[0]) {
                let filePath = URL(fileURLWithPath: filePath[0])
                let localFile = filePath
                //                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
                let fileRef = lastNameRef.child("\(fileName)")
                
                let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
                    if error == nil && metadata == nil {
                        //TSave a reference to firestore database
                    }
                    return
                }
                print(uploadTask)
            } else {
                print("No File")
            }
        }
    }
}


//struct InAppPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        InAppPurchaseView()
//    }
//}
