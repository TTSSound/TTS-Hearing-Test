//
//  ManualDeviceDisclaimerView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift


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


struct ManualDeviceDisclaimerView: View {
    var colorModel: ColorModel = ColorModel()
    @ObservedObject var uncalibratedAgreementModel: UncalibratedAgreementModel = UncalibratedAgreementModel()
    
    let setupCSVName = "SetupResultsCSV.csv"
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    
    @State var uncalDisclaimerSetting = Bool()
    @State var uncalDisclaimerAgreement = Int()
    @State var unLinkColors: [Color] = [Color.clear, Color.green]
    @State var unLinkColorIndex = Int()
    @State var uncalUserAgreed: Bool = false
    @State var uncalUserAgreedDate: Date = Date()
    var urlFile: URL = URL(fileURLWithPath: "uncalibratedAgreementText.txt")
    
    
    @State var uncalibratedUserAgreement = [Bool]()
    @State var finalUncalibratedUserAgreementAgreed: [Bool] = [Bool]()
    @State var finalUncalibratedUserAgreementAgreedDate: [Date] = [Date]()
    @State var stringJsonFUUAADate = String()
    @State var stringFUUAADate = String()
    @State var stringInputFUUAADate = String()
    
    let fileManualDisclaimerName = ["ManualDisclaimerAgreement.json"]
    let manuaDisclaimerCSVName = "ManualDisclaimerAgreementCSV.csv"
    let inputManuaDisclaimerCSVName = "InputManualDisclaimerAgreementCSV.csv"
    
    @State var saveFinalManualDisclaimerAgreement: SaveFinalManualDisclaimerAgreement? = nil
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomRed .ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                GroupBox(label:
                            Label("Uncalibrated Device Agreement", systemImage: "building.columns").foregroundColor(.black)
                ) {
                    ScrollView(.vertical, showsIndicators: true) {
                        Text(uncalibratedAgreementModel.uncalibratedAgreementText)
                            .foregroundColor(.black)
                            .font(.footnote)
                    }
                    .frame(height: 375)
                    Toggle(isOn: $uncalUserAgreed) {
                        Text("I agree to the above terms")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                    .padding(.leading)
                }
                .padding()
                .onAppear(perform: {
                    loadUncalibratedAgreement()
                })
                .onChange(of: uncalUserAgreed) { _ in
                    Task {
                        unLinkColorIndex = 1
                        uncalDisclaimerSetting = uncalUserAgreed
                        uncalUserAgreedDate = Date.now
                        await uncalCompareDisclaimerAgreement()
                        await uncalDisclaimerResponse()
                        await concentenateFinalUncalDisclaimerArrays()
                        await saveManualDeviceDisclaimer()
                        print("uncalDisclaimerSetting: \(uncalDisclaimerSetting)")
                        print("uncalDisclaimerAgreement: \(uncalDisclaimerAgreement)")
                        isOkayToUpload = true
                    }
                }
                Spacer()
                if uncalUserAgreed == true {
                    NavigationLink(destination:
                                    uncalUserAgreed == true ? AnyView(ManualDeviceEntryView())
                                   : uncalUserAgreed == false ? AnyView(ManualDeviceEntryInformationView())
                                   : AnyView(ManualDeviceEntryInformationView())
                    ){  HStack{
                        Spacer()
                        Text("Now Let's Continue")
                        Spacer()
                        Image(systemName: "arrowshape.bounce.right")
                        Spacer()
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(24)
                    }
                    .foregroundColor(unLinkColors[unLinkColorIndex])
                    .onTapGesture {
                        Task {
                            await uploadManualDeviceDisclaimer()
                            print("uncalDisclaimerSetting: \(uncalDisclaimerSetting)")
                            print("uncalDisclaimerAgreement: \(uncalDisclaimerAgreement)")
                        }
                    }
                }
            }
            .onAppear(perform: {
                Task {
                    await setupCSVReader()
                }
            })
            .padding(.bottom, 40)
            Spacer()
        }
    }
}

extension ManualDeviceDisclaimerView {
    //MARK: -Extension Methods
    func loadUncalibratedAgreement() {
        uncalibratedAgreementModel.load(file: uncalibratedAgreementModel.uncalibratedAgreementText)
    }
    
    func uncalCompareDisclaimerAgreement() async {
        if uncalDisclaimerSetting == true {
            uncalDisclaimerAgreement = 1
            print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")
            
        } else if uncalDisclaimerSetting == false {
            uncalDisclaimerAgreement = 0
            print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")
        } else {
            uncalDisclaimerAgreement = 2
            print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")
        }
    }
    
    func uncalDisclaimerResponse() async {
        uncalDisclaimerSetting = true
        if uncalibratedUserAgreement.count < 1 || uncalibratedUserAgreement.count > 1{
            uncalibratedUserAgreement.append(uncalDisclaimerSetting)
            print(uncalibratedUserAgreement)
        } else if uncalDisclaimerSetting == false {
            uncalibratedUserAgreement.removeAll()
            uncalibratedUserAgreement.append(uncalDisclaimerSetting)
            print(uncalibratedUserAgreement)
        } else {
            print("disclaimer error")
        }
    }
    
    func concentenateFinalUncalDisclaimerArrays() async {
        finalUncalibratedUserAgreementAgreed.append(contentsOf: uncalibratedUserAgreement)
        finalUncalibratedUserAgreementAgreedDate.append(uncalUserAgreedDate)
        print("finalUncalibratedUserAgreementAgreed: \(finalUncalibratedUserAgreementAgreed)")
        print("finalUncalibratedUserAgreementAgreedDate: \(finalUncalibratedUserAgreementAgreedDate)")
    }
    
    func saveManualDeviceDisclaimer() async {
        await getManualDisclaimerData()
        await saveManualDisclaimerToJSON()
        await writeManualDisclaimerToCSV()
        await writeInputManualDisclaimerToCSV()
    }
    
    func uploadManualDeviceDisclaimer() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: manuaDisclaimerCSVName)
            uploadFile(fileName: inputManuaDisclaimerCSVName)
            uploadFile(fileName: "ManualDisclaimerAgreement.json")
        }
    }
}
 
extension ManualDeviceDisclaimerView {
//MARK: -Extenstion CSV/JSON Methods
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


class UncalibratedAgreementModel: ObservableObject {
    @Published var uncalibratedAgreementText: String = ""
        init() { self.load(file: "uncalibratedAgreementText") }
        func load(file: String) {
        if let uncalFilepath = Bundle.main.path(forResource: "uncalibratedAgreementText", ofType: "txt") {
            do {
                let uncalAgreementContents = try String(contentsOfFile: uncalFilepath)
                DispatchQueue.main.async {
                    self.uncalibratedAgreementText = uncalAgreementContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
        print("File not found")
        }
    }
}

//struct ManualDeviceDisclaimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceDisclaimerView()
//    }
//}
