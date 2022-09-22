//
//  EHATokenInput.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

struct TestIDInputView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            TestIDInputContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading TestIDInput View")
                .navigationTitle("")
        }
    }
}

struct TestIDInputContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputBetaLastName = String()
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var dataFileURLBetaLastName = URL(fileURLWithPath: "")
    @State private var isOkayToUpload = false
    @State private var comparedLastName = String()
    @State private var comparedUserLastName = [String]()
    @State private var finalComparedLastName = [String]()
    
    
    let inputBetaSummaryCSVName = "InputBetaSummaryCSV.csv"
    
    let setupCSVName = "SetupResultsCSV.csv"
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var testIDKey: String = ""
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Enter Your Test ID Key")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)
                
                HStack{
                    Text("Test Key")
                        .foregroundColor(.white)
                    TextField("Enter Key", text: $testIDKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
                ScrollView {
                    Text(" Require input of Test ID/Tolken to....Have a Purchase Token Input of EHA and EPTA purchased tests Another set of tolkens/IDs indicating it is trial free simple audiogram test Identify the test for later uses with a unique ID that is not directly associated to the user or can be easily parsed from the user\n\nThis is a security measure")
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 200, alignment: .center)
                
                //!!!!!!!NEED TO DETERMINE HOW TO AUTHORIZE TOLKENS"
                
                Text("NEED TO DETERMINE HOW TO AUTHORIZE TOLKENS")
                    .foregroundColor(.pink)
                Spacer()
                
                Spacer()
                NavigationLink {
                    UserWrittenHearingAssessmentView(testing: testing, relatedLinkTesting: linkTesting)
                } label: {
                    Text("Continue To Start Test")
                        .padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(24)
                }
                Spacer()
            }
        }
        .onAppear {
            Task {
                await setupLastNameCSVReader()
                await setupBetaLastNameCSVReader()
                await compareLastNames()
                await writeLastNameToCSV()
            }
        }
    }
}
 
extension TestIDInputContent {
//MARK: -Extension CSV/JSON Methods
    private func setupLastNameCSVReader() async {
        let dataSetupName = inputSetupCSVName
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURLLastName: \(dataFileURLLastName)")
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
    
    private func setupBetaLastNameCSVReader() async {
        let dataSetupName = inputBetaSummaryCSVName
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLBetaLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLBetaLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLBetaLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputBetaLastName = fieldLastName
            print("inputBetaLastName: \(inputBetaLastName)")
        } catch {
            print("Error in reading Beta Last Name results")
        }
    }
    
    func compareLastNames() async {
        print("inputLastName: \(inputLastName)")
        print("inputBetaLastName: \(inputBetaLastName)")
        print("finalComparedLastName: \(finalComparedLastName)")
        if inputLastName == inputBetaLastName && inputLastName != "" {
            comparedLastName = inputLastName
            comparedUserLastName.append(comparedLastName)
            finalComparedLastName.append(contentsOf: comparedUserLastName)
        } else if inputLastName != inputBetaLastName && inputLastName != "" {
            comparedLastName = inputLastName
            comparedUserLastName.append(comparedLastName)
            finalComparedLastName.append(contentsOf: comparedUserLastName)
        } else {
            comparedLastName = "ErrorLastName"
            comparedUserLastName.append(comparedLastName)
            finalComparedLastName.append(contentsOf: comparedUserLastName)
            print("Fatal Error in input or beta last name")
        }
    }
    
    func writeLastNameToCSV() async {
        print("writeLastNameToCSV Start")
        let stringFinalInputLastName = finalComparedLastName.map { String($0) }.joined(separator: ",")
        do {
            let csvBetaEHAInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaEHAInputSummaryDocumentsDirectory = csvBetaEHAInputSummaryPath
            print("CSV Beta EHA Input Summary Selection DocumentsDirectory: \(csvBetaEHAInputSummaryDocumentsDirectory)")
            let csvBetaEHAInputSummaryFilePath = csvBetaEHAInputSummaryDocumentsDirectory.appendingPathComponent(inputFinalComparedLastNameCSV)
            print(csvBetaEHAInputSummaryFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaEHAInputSummaryFilePath, append: false)
            try writerSetup.write(row: [stringFinalInputLastName])
            
            print("CVS Last Na,e Writer Success")
        } catch {
            print("CVSWriter Last Name Error or Error Finding File for Last Name CSV \(error.localizedDescription)")
        }
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
}

extension TestIDInputContent {
//MARK: -NavigationLink Extenstion
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
}

//struct TestIDInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestIDInputView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
