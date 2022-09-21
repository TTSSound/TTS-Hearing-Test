//
//  TestSelectionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

//Add in final test selection class write int and final test tolken UUID

struct SaveFinalTestSelection: Codable {  // This is a model
    var jsonFinalSelectedEHATest = [Int]()
    var jsonFinalSelectedEPTATest = [Int]()
    var jsonFinalSelectedSimpleTest = [Int]()
    var jsonSelectedSimpleTestUUID = [String]()
    var jsonFinalTestSelected = [Int]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalSelectedEHATest
        case jsonFinalSelectedEPTATest
        case jsonFinalSelectedSimpleTest
        case jsonSelectedSimpleTestUUID
        case jsonFinalTestSelected
    }
}

struct TestSelectionView: View {
    var colorModel = ColorModel()
    
 
    let setupCSVName = "SetupResultsCSV.csv"
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    
    @State var selectedEHA: Bool = false
    @State var selectedEPTA: Bool = false
    @State var selectedSimple: Bool = false
    @State var testSelectionSubmitted = [Int]()
    @State var testSelectionSuccessful = [Int]()
    @State var isOkayToContinue: Bool = false
    @State var sumSelection = Int()
    @State var singleEHA = Int()
    @State var singleEPTA = Int()
    @State var singleSimple = Int()
    @State var singleEHAArray = [Int]()
    @State var singleEPTAArray = [Int]()
    @State var singleSimpleArray = [Int]()
    @State var simpleTestUUIDString = String()
    @State var tsLinkColors: [Color] = [Color.clear, Color.green]
    @State var tsLinkColorIndex = Int()
    
 
    @State var finalSelectedEHATest: [Int] = [Int]()
    @State var finalSelectedEPTATest: [Int] = [Int]()
    @State var finalSelectedSimpleTest: [Int] = [Int]()
    @State var finalSelectedSimpleTestUUID: [String] = [String]()  // 1 = Purchased The EHA Test, 2 = EPTA, 3 = simpleTest
    @State var finalTestSelected: [Int] = [Int]()
    
    let fileTestSelectionName = ["TestSelection.json"]
    let testSelectionCSVName = "TestSelectionCSV.csv"
    let inputTestSelectionCSVName = "InputTestSelectionCSV.csv"
    
    let ehaLink = "EHA.csv"
    let eptaLink = "EPTA.csv"
    let simpleLink = "Simple.csv"
    
    @State var saveFinalTestSelection: SaveFinalTestSelection? = nil
    
    var body: some View {

// Marketing and info on EPTA vs EHA Tests
// Direction that EHA test be taken in two parts at two different times and days
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack {
                Text("Test Selection")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.blue)
                    .foregroundColor(.gray)
                Toggle(isOn: $selectedEHA) {
                    Text("I Want the Gold Standard! Give Me The EHA!")
                        .frame(width: 200, height: 50, alignment: .center)
                    
                }
                .foregroundColor(colorModel.neonGreen)
                .padding(.leading)
                .padding(.leading)
                .padding(.trailing)
                .padding(.trailing)
                .onChange(of: selectedEHA) { ehaValue in
                    if ehaValue == true {
                        testSelectionSubmitted.removeAll()
                        testSelectionSubmitted.append(0)
                        selectedEPTA = false
                        selectedSimple = false
                        singleEHA = 0
                        singleEPTA = 0
                        singleSimple = 0
                    }
                }
                .padding(.bottom, 20)
                .padding(.top, 20)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                Toggle(isOn: $selectedEPTA) {
                    Text("I Want The Shorter Test. Give Me The EPTA")
                        .frame(width: 200, height: 50, alignment: .center)
                }
                .padding(.leading)
                .padding(.leading)
                .padding(.trailing)
                .padding(.trailing)
                .foregroundColor(colorModel.limeGreen)
                .onChange(of: selectedEPTA) { eptaValue in
                    if eptaValue == true {
                        testSelectionSubmitted.removeAll()
                        testSelectionSubmitted.append(1)
                        selectedEHA = false
                        selectedSimple = false
                        singleEHA = 0
                        singleEPTA = 0
                        singleSimple = 0
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                Toggle(isOn: $selectedSimple) {
                    Text("I Only Want A Trial. Give me the Simple Test.")
                        .frame(width: 200, height: 50, alignment: .center)
                }
                .padding(.leading)
                .padding(.leading)
                .padding(.trailing)
                .padding(.trailing)
                .foregroundColor(colorModel.darkNeonGreen)
                .onChange(of: selectedSimple) { simpleValue in
                    if simpleValue == true {
                        testSelectionSubmitted.removeAll()
                        testSelectionSubmitted.append(2)
                        selectedEHA = false
                        selectedEPTA = false
                        singleEHA = 0
                        singleEPTA = 0
                        singleSimple = 0
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                
                //!!!! Need to setup logic to catch mismatches, nonpurchased but selected EHA and dual or no selection and send user to a splash screen notifying to check selections again, run reset arrays function, and return user to selection screen. NOTE need to account for payment of EHA if it already went through so user does not double pay on second try at selection.
                //possibly use non standard if else navigation link results
                
                HStack{
                    Spacer()
                    if isOkayToContinue == false {
                        HStack{
                            Spacer()
                            Button {
                                Task(priority: .userInitiated, operation: {
                                    await singleSelection()
                                    await checkMultipleSelections()
                                    await isSelectionSuccessful()
                                    print("button clicked")
                                    await finalTestSelectionArrays()
                                    await saveTestSelection()
                                    await saveTestLinkFile()
                                })
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("Submit Selection")
                                    Spacer()
                                    Image(systemName: "arrow.up.doc.fill")
                                    Spacer()
                                }
                                .frame(width: 280, height: 50, alignment: .center)
                                .background(Color.blue).opacity(0.7)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                            }
                            Spacer()
                        }
                        .padding(.top, 80)
                        .padding(.bottom, 20)
                    } else if isOkayToContinue == true && selectedSimple == true {
                        HStack{
                            Spacer()
                            NavigationLink(destination:
                                            isOkayToContinue == true ? AnyView(CalibrationAssessmentView())
                                           : isOkayToContinue == false ? AnyView(TestSelectionSplashView())
                                           : AnyView(TestSelectionView())
                            ){
                                HStack{
                                    Spacer()
                                    Text("Continue To Setup")
                                    Spacer()
                                    Image(systemName: "arrowshape.bounce.right")
                                    Spacer()
                                }
                                .frame(width: 280, height: 50, alignment: .center)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                            }
                            Spacer()
                        }
                        .padding(.top, 80)
                        .padding(.bottom, 20)
                    } else if isOkayToContinue == true && selectedEHA == true || selectedEPTA == true {
                        HStack{
                            Spacer()
                            NavigationLink(destination:
                                            isOkayToContinue == true ? AnyView(InAppPurchaseView())
                                           : isOkayToContinue == false ? AnyView(TestSelectionSplashView())
                                           : AnyView(TestSelectionView())
                            ){
                                HStack{
                                    Spacer()
                                    Text("Continue To Purchase")
                                    Spacer()
                                    Image(systemName: "purchased.circle")
                                    Spacer()
                                }
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .hoverEffect()
                                .cornerRadius(24)
                            }
                            Spacer()
                        }
                        .padding(.top, 80)
                        .padding(.bottom, 20)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            tsLinkColorIndex = 0
            isOkayToContinue = false
            isOkayToUpload = false
            Task{
                await setupCSVReader()
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                uploadTestSelection()
            } else {
                print("Fatal Upload Error in Change of")
            }
        }
    }
    
    func singleSelection() async {
        if selectedEHA == true {
            singleEHA = 1
            finalTestSelected.append(1)
            finalSelectedEPTATest.append(-1)
            finalSelectedSimpleTest.append(-1)
            finalSelectedSimpleTestUUID.append("SimpleTestNOTSelected")
            singleEHAArray.append(singleEHA)
            print("SingleEHA")
        }
        if selectedEPTA == true {
            singleEPTA = 1
            finalTestSelected.append(2)
            finalSelectedEHATest.append(-1)
            finalSelectedSimpleTest.append(-1)
            finalSelectedSimpleTestUUID.append("SimpleTestNOTSelected")
            singleEPTAArray.append(singleEPTA)
            print("SingleEPTA")
        }
        if selectedSimple == true {
            singleSimple = 1
            finalTestSelected.append(3)
            finalSelectedEHATest.append(-1)
            finalSelectedEPTATest.append(-1)
            singleSimpleArray.append(singleSimple)
            simpleTestUUIDString = UUID().uuidString
            print("Simple")
            print("Simple UUID Assigned")
        }
    }
     
    func checkMultipleSelections() async {
        sumSelection = singleEHA + singleEPTA + singleSimple
        print("sumSelection: \(sumSelection)")
        if sumSelection == 1 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(1)
            tsLinkColorIndex = 1
            print("Success, only one test selected")
            print("selected Test: \(testSelectionSuccessful)")
        } else if sumSelection == 0 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("Error, no test selected else if 1")
            print("selected Test: \(testSelectionSuccessful)")
        } else if sumSelection > 1 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("Error, multiple tests selected else if 2")
            print("selected Test: \(testSelectionSuccessful)")
        } else {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("!!!Error in singleSelection() Logic else ")
            print("selected Test: \(testSelectionSuccessful)")
        }
    }
    
    func isSelectionSuccessful() async {
        if testSelectionSuccessful == [1] {
            isOkayToContinue = true
            print("isokaytocontinue: \(isOkayToContinue)")
        } else if testSelectionSuccessful == [0] {
            isOkayToContinue = false
            print("isokaytocontinue: \(isOkayToContinue)")
        } else {
            print("isokaytocontinue: \(isOkayToContinue)")
            print("!!!Error in isSelectionSuccessful Logic")
        }
    }
    
    func finalTestSelectionArrays() async {
        finalSelectedEHATest.append(contentsOf: singleEHAArray)
        finalSelectedEPTATest.append(contentsOf: singleEPTAArray)
        finalSelectedSimpleTest.append(contentsOf: singleSimpleArray)
        finalSelectedSimpleTestUUID.append(simpleTestUUIDString)
        print("testSelectionModel finalSelectedEHATest: \(finalSelectedEHATest)")
        print("testSelectionModel finalSelectedEPTATest: \(finalSelectedEPTATest)")
        print("testSelectionModel finalSelectedSimpleTest: \(finalSelectedSimpleTest)")
        print("UUID: \(simpleTestUUIDString)")
        print("testSelectionModel simpleTestUUID: \(finalSelectedSimpleTestUUID)")

    }

    func saveTestSelection() async {
        await getTestSelectionData()
        await saveTestSelectionToJSON()
        await writeTestSelectionToCSV()
        await writeInputTestSelectionToCSV()
    }
    
    func saveTestLinkFile() async {
        if singleEHA == 1 {
            await writeEHATestLinkToCSV()
            isOkayToUpload = true
        } else {
            print("!!Error in singleEHA test link logic")
        }
        if singleEPTA == 1 {
            await writeEPTATestLinkToCSV()
            isOkayToUpload = true
        } else {
            print("!!Error in singleEPTA test link logic")
        }
        if singleSimple == 1 {
            await writeSimpleTestLinkToCSV()
            isOkayToUpload = true
        } else {
            print("!!Error in singleSimple test link logic")
        }
    }
    
    func uploadTestSelection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, qos: .background) {
            uploadFile(fileName: testSelectionCSVName)
            uploadFile(fileName: inputTestSelectionCSVName)
            uploadFile(fileName: "TestSelection.json")
        }
    }
    
    
    
//MARK: -TestSelectionModel Funcst
    
    func getTestSelectionData() async {
        guard let testSelectionData = await getTestSelectionJSONData() else { return }
        print("Json Test Selection Data:")
        print(testSelectionData)
        let jsonTestSelectionString = String(data: testSelectionData, encoding: .utf8)
        print(jsonTestSelectionString!)
        do {
        self.saveFinalTestSelection = try JSONDecoder().decode(SaveFinalTestSelection.self, from: testSelectionData)
            print("JSON GetTestSelectionData Run")
            print("data: \(testSelectionData)")
        } catch let error {
            print("!!!Error decoding test selection json data: \(error)")
        }
    }
 
    func getTestSelectionJSONData() async -> Data? {
        let saveFinalTestSelection = SaveFinalTestSelection (
            jsonFinalSelectedEHATest: finalSelectedEHATest,
            jsonFinalSelectedEPTATest: finalSelectedEPTATest,
            jsonFinalSelectedSimpleTest: finalSelectedSimpleTest,
            jsonSelectedSimpleTestUUID: finalSelectedSimpleTestUUID,
            jsonFinalTestSelected: finalTestSelected)

        let jsonTestSelectionData = try? JSONEncoder().encode(saveFinalTestSelection)
        print("saveTestSelection: \(saveFinalTestSelection)")
        print("Json Encoded \(jsonTestSelectionData!)")
        return jsonTestSelectionData
    }
    
    func saveTestSelectionToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let testSelectionPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = testSelectionPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let testSelectionFilePaths = documentsDirectory.appendingPathComponent(fileTestSelectionName[0])
        print(testSelectionFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonTestSelectionData = try encoder.encode(saveFinalTestSelection)
            print(jsonTestSelectionData)
          
            try jsonTestSelectionData.write(to: testSelectionFilePaths)
        } catch {
            print("Error writing to JSON Test Selection file: \(error)")
        }
    }
    
    func writeTestSelectionToCSV() async {
        print("writeTestSelectionToCSV Start")
        let stringFinalSelectedEHATest = "finalSelectedEHATest," + finalSelectedEHATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedEPTATest = "finalSelectedEPTATest," + finalSelectedEPTATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTest = "finalSelectedSimpleTest," + finalSelectedSimpleTest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTestUUID = "finalSelectedSimpleTestUUID," + finalSelectedSimpleTestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalTestSelected = "finalTestSelected," + finalTestSelected.map { String($0) }.joined(separator: ",")
        do {
            let csvTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvTestDocumentsDirectory = csvTestPath
            print("CSV Test Selection DocumentsDirectory: \(csvTestDocumentsDirectory)")
            let csvTestFilePath = csvTestDocumentsDirectory.appendingPathComponent(testSelectionCSVName)
            print(csvTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvTestFilePath, append: false)
            try writerSetup.write(row: [stringFinalSelectedEHATest])
            try writerSetup.write(row: [stringFinalSelectedEPTATest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTestUUID])
            try writerSetup.write(row: [stringFinalTestSelected])
            print("CVS Test Selection Writer Success")
        } catch {
            print("CVSWriter Test Selection Error or Error Finding File for Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputTestSelectionToCSV() async {
        print("writeInputTestSelectionToCSV Start")
        let stringFinalSelectedEHATest = finalSelectedEHATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedEPTATest = finalSelectedEPTATest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTest = finalSelectedSimpleTest.map { String($0) }.joined(separator: ",")
        let stringFinalSelectedSimpleTestUUID = finalSelectedSimpleTestUUID.map { String($0) }.joined(separator: ",")
        let stringFinalTestSelected = finalTestSelected.map { String($0) }.joined(separator: ",")
        do {
            let csvInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputTestDocumentsDirectory = csvInputTestPath
            print("CSV Input Test Selection DocumentsDirectory: \(csvInputTestDocumentsDirectory)")
            let csvInputTestFilePath = csvInputTestDocumentsDirectory.appendingPathComponent(inputTestSelectionCSVName)
            print(csvInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputTestFilePath, append: false)
            try writerSetup.write(row: [stringFinalSelectedEHATest])
            try writerSetup.write(row: [stringFinalSelectedEPTATest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTest])
            try writerSetup.write(row: [stringFinalSelectedSimpleTestUUID])
            try writerSetup.write(row: [stringFinalTestSelected])
            print("CVS Input Test Selection Writer Success")
        } catch {
            print("CVSWriter Input Test Selection Error or Error Finding File for Input Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    
//MARK: -TestSelectionLinkModel Funcs
    func writeEHATestLinkToCSV() async {
        print("writeEHATestSelectionLinkToCSV Start")
        let selectedEHATest = "EHA," + "EHA"
        do {
            let ehaTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let ehaSetupDocumentsDirectory = ehaTestLinkPath
            print("CSV Setup DocumentsDirectory: \(ehaSetupDocumentsDirectory)")
            let ehaLinkFilePath = ehaSetupDocumentsDirectory.appendingPathComponent("EHA.csv")
            print(ehaLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: ehaLinkFilePath, append: false)
            try writerSetup.write(row: [selectedEHATest])
            print("CVS EHA Link Writer Success")
        } catch {
            print("CVSWriter EHA Link  Error or Error Finding File for EHA Link CSV \(error.localizedDescription)")
        }
    }
    
    func writeEPTATestLinkToCSV() async {
        print("writeEPTATestSelectionLinkToCSV Start")
        let selectedEPTATest = "EPTA," + "EPTA"
        do {
            let eptaTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let eptaSetupDocumentsDirectory = eptaTestLinkPath
            print("CSV Setup DocumentsDirectory: \(eptaSetupDocumentsDirectory)")
            let eptaLinkFilePath = eptaSetupDocumentsDirectory.appendingPathComponent("EPTA.csv")
            print(eptaLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: eptaLinkFilePath, append: false)
            try writerSetup.write(row: [selectedEPTATest])
            print("CVS EPTA Link Writer Success")
        } catch {
            print("CVSWriter EPTA Link  Error or Error Finding File for EPTA Link CSV \(error.localizedDescription)")
        }
    }
    
    func writeSimpleTestLinkToCSV() async {
        print("writeSimpleTestSelectionLinkToCSV Start")
        let selectedSimpleTest = "Simple," + "Simple"
        do {
            let simpleTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let simpleSetupDocumentsDirectory = simpleTestLinkPath
            print("CSV Setup DocumentsDirectory: \(simpleSetupDocumentsDirectory)")
            let simpleLinkFilePath = simpleSetupDocumentsDirectory.appendingPathComponent("Simple.csv")
            print(simpleLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: simpleLinkFilePath, append: false)
            try writerSetup.write(row: [selectedSimpleTest])
            print("CVS Simple Link Writer Success")
        } catch {
            print("CVSWriter Simple Link  Error or Error Finding File for Simple Link CSV \(error.localizedDescription)")
        }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    // Only Use Files that have a pure string name assigned, not a name of ["String"]
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
    
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
}


//struct TestSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionView()
//    }
//}
