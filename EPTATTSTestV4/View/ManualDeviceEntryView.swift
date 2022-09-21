//
//  ManualDeviceEntryView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

struct SaveFinalManualDeviceSelection: Codable {  // This is a model
    var jsonFinalManualDeviceBrand = [String]()
    var jsonFinalManualDeviceModel = [String]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalManualDeviceBrand
        case jsonFinalManualDeviceModel
    }
}

struct ManualDeviceEntryView: View {
    
    var colorModel: ColorModel = ColorModel()

    let setupCSVName = "SetupResultsCSV.csv"
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false

    @State var deviceBrand: String = ""
    @State var deviceModel: String = ""
    @State var manualUserDataSubmitted = Bool()
    @State var manColors: [Color] = [Color.clear, Color.green]
    @State var manLinkColorIndex = 0
    @State var showManualSplashSheet = Bool()
    
    
    @State var userBrand = [String]()
    @State var userModel = [String]()
    @State var finalManualDeviceBrand: [String] = [String]()
    @State var finalManualDeviceModel: [String] = [String]()
    let fileManualDeviceName = ["ManualDeviceSelection.json"]
    let manualDeviceCSVName = "ManualDeviceSelectionCSV.csv"
    let inputManualDeviceCSVName = "InputManualDeviceSelectionCSV.csv"
    @State var saveFinalManualDeviceSelection: SaveFinalManualDeviceSelection? = nil

    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading) {
                HStack{
                    Spacer()
                    Text("Manual Device Entry")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .padding(.top, 40)
                .padding(.bottom, 40)
                Text("Complete Each Field Below For The\n   Earphones, or\n   Headphones, or\n   In-Ear Monitors\nYou Will Use For This Test.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                Text("Enter Your Ear / Headphones Brand")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.top)
                HStack{
                    Text("Device Brand")
                        .foregroundColor(.white)
                    TextField("Enter Brand", text: $deviceBrand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom)
                Text("Enter Your Ear / Headphones Model")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)
                HStack{
                    Text("Device Model")
                        .foregroundColor(.white)
                    TextField("Enter Model", text: $deviceModel)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
                Spacer()
                if manualUserDataSubmitted == false {
                    HStack{
                        Spacer()
                        Button {
                            Task(priority: .userInitiated, operation: {
                                await areDMFieldsEmpty()
                                await appendManualDeviceData()
                                await concantenateFinalManualDeviceArrays()
                                await saveManualDeviceData()
                            })
                        } label: {
                            HStack{
                                Spacer()
                                Text("Submit Data")
                                Spacer()
                                Image(systemName: "arrow.up.doc.on.clipboard")
                                Spacer()
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(24)
                        }
                    Spacer()
                    }
                } else if manualUserDataSubmitted == true {
                    HStack{
                        Spacer()
                        NavigationLink(destination:
                                        manualUserDataSubmitted == true ? AnyView(InstructionsForTakingTest())
                                       : manualUserDataSubmitted == false ? AnyView(ManualDeviceEntryIssueSplashView())
                                       : AnyView(ManualDeviceEntryIssueSplashView())
                                       
                        ){  HStack{
                            Spacer()
                            Text("Continue to Device Setup")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(24)
                        }
                    Spacer()
                    }
                }
                Spacer()
            }
            .onAppear {
                Task(priority: .userInitiated) {
                    manualUserDataSubmitted = false
                    manLinkColorIndex = 0
                    await setupCSVReader()
                }
            }
            .onChange(of: isOkayToUpload) { uploadValue in
                if uploadValue == true {
                    uploadManualDeviceData()
                } else {
                    print("Fatal error in upload value change logic")
                }
            }
        }
    }
    
    func areDMFieldsEmpty() async {
        if deviceBrand.count > 0 && deviceModel.count > 0 {
            manualUserDataSubmitted = true
            manLinkColorIndex = 1
            print("Device and Model Field Completed")
        } else if deviceBrand.count <= 0 && deviceModel.count > 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Device Field Empty, But Model Field Filled")
        } else if deviceBrand.count > 0 && deviceModel.count <= 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Device Field Completed, But Model Field Empty")
        } else if deviceBrand.count <= 0 && deviceModel.count <= 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Both Device and Model Fields Are Empty")
        } else {
            showManualSplashSheet = true
            manLinkColorIndex = 1
            print("!!!Error in areDMFieldsEmpty() Logic")
        }
    }
    
    func appendManualDeviceData() async {
        userBrand.append(deviceBrand)
        userModel.append(deviceModel)

        print("Brand: \(deviceBrand)")
        print("Model: \(deviceModel)")
        print("setupData userBrand: \(userBrand)")
        print("setupDate userModel: \(userModel)")
    }
    
    func concantenateFinalManualDeviceArrays() async {
        finalManualDeviceBrand.append(contentsOf: userBrand)
        finalManualDeviceModel.append(contentsOf: userModel)
        print("manualDeviceSelectionModel finalManualDeviceBrand: \(finalManualDeviceBrand)")
        print("manualDeviceSelectionModel finalManualDeviceModel: \(finalManualDeviceModel)")
    }
    
    func saveManualDeviceData() async {
        await getManualDeviceData()
        await saveManualDeviceToJSON()
        await writeManualDeviceResultsToCSV()
        await writeInputManualDeviceResultsToCSV()
        isOkayToUpload = true
    }

    func uploadManualDeviceData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, qos: .background) {
            uploadFile(fileName: manualDeviceCSVName)
            uploadFile(fileName: inputManualDeviceCSVName)
            uploadFile(fileName: "ManualDeviceSelection.json")
        }
    }
    
    func getManualDeviceData() async {
        guard let manualDeviceSelectionData = await getManualDeviceJSONData() else { return }
        print("Json Manual Device Selection Data:")
        print(manualDeviceSelectionData)
        let jsonManualDeviceSelectionString = String(data: manualDeviceSelectionData, encoding: .utf8)
        print(jsonManualDeviceSelectionString!)
        do {
        self.saveFinalManualDeviceSelection = try JSONDecoder().decode(SaveFinalManualDeviceSelection.self, from: manualDeviceSelectionData)
            print("JSON GetManualDeviceSelectionData Run")
            print("data: \(manualDeviceSelectionData)")
        } catch let error {
            print("!!!Error decoding Manual Device selection json data: \(error)")
        }
    }
    
    func getManualDeviceJSONData() async -> Data? {
        let saveFinalManualDeviceSelection = SaveFinalManualDeviceSelection (
            jsonFinalManualDeviceBrand: finalManualDeviceBrand,
            jsonFinalManualDeviceModel: finalManualDeviceBrand)
        let jsonManualDeviceData = try? JSONEncoder().encode(saveFinalManualDeviceSelection)
        print("saveFinalManualDeviceSelection: \(saveFinalManualDeviceSelection)")
        print("Json Manual Device Encoded \(jsonManualDeviceData!)")
        return jsonManualDeviceData
    }

    func saveManualDeviceToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let manualDevicePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = manualDevicePaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let manualDeviceFilePaths = documentsDirectory.appendingPathComponent(fileManualDeviceName[0])
        print(manualDeviceFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonManualDeviceData = try encoder.encode(saveFinalManualDeviceSelection)
            print(jsonManualDeviceData)
          
            try jsonManualDeviceData.write(to: manualDeviceFilePaths)
        } catch {
            print("Error writing to JSON Manual Device Selection file: \(error)")
        }
    }

    func writeManualDeviceResultsToCSV() async {
        print("writeManualDeviceSelectionToCSV Start")
        let stringFinalManualDeviceBrand = "finalManualDeviceBrand," + finalManualDeviceBrand.map { String($0) }.joined(separator: ",")
        let stringFinalManualDeviceModel = "finalManualDeviceModel," + finalManualDeviceModel.map { String($0) }.joined(separator: ",")
        do {
            let csvManualDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvManualDeviceDocumentsDirectory = csvManualDevicePath
            print("CSV Device Selection DocumentsDirectory: \(csvManualDeviceDocumentsDirectory)")
            let csvManualDeviceFilePath = csvManualDeviceDocumentsDirectory.appendingPathComponent(manualDeviceCSVName)
            print(csvManualDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvManualDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalManualDeviceBrand])
            try writerSetup.write(row: [stringFinalManualDeviceModel])
            print("CVS Manual Device Selection Writer Success")
        } catch {
            print("CVSWriter Manual Device Selection Error or Error Finding File for Manual Device Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputManualDeviceResultsToCSV() async {
        print("writeInputManualDeviceSelectionToCSV Start")
        let stringFinalManualDeviceBrand = finalManualDeviceBrand.map { String($0) }.joined(separator: ",")
        let stringFinalManualDeviceModel = finalManualDeviceModel.map { String($0) }.joined(separator: ",")
        do {
            let csvInputManualDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputManualDeviceDocumentsDirectory = csvInputManualDevicePath
            print("CSV Input Device Selection DocumentsDirectory: \(csvInputManualDeviceDocumentsDirectory)")
            let csvInputManualDeviceFilePath = csvInputManualDeviceDocumentsDirectory.appendingPathComponent(inputManualDeviceCSVName)
            print(csvInputManualDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputManualDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalManualDeviceBrand])
            try writerSetup.write(row: [stringFinalManualDeviceModel])
    
            print("CVS Input Manual Device Selection Writer Success")
        } catch {
            print("CVSWriter Input Manual Device Selection Error or Error Finding File for Input Manual Device Selection CSV \(error.localizedDescription)")
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

//struct ManualDeviceEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceEntryView()
//    }
//}
