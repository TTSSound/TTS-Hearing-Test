//
//  CalibrationAssessmentView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

//@State var headphoneDevice: CalibratedModels = .Unknown
//enum CalibratedModels: String, CaseIterable, Identifiable {
//    case Apple_AirPods_Generation_2
//    case Apple_AirPods_Generation_3
//    case Apple_Air_Pod_Pro
//    case Apple_Air_Pods_Max
//    case Beats_Studio_Buds
//    case Beats_Fit_Pro
//    case Beats_Studio_3
//    case Jabra_Elite_85t
//    case Nura_True
//    case Skullcandy_Indy_Anc
//    case Soundcore_Liberty_3
//    case TTS_Testing_System
//    case Unknown
//    case Not_Listed
//    var id: Self { self }
//}
//
//enum Brand: String, CaseIterable, Identifiable {
//    case Apple
//    case Beats
//    case TTS
//    case Jabra
//    case Nura
//    case Skullcandy
//    case Soundcore
//    case True_To_Source
//    var id: Self { self }
//}
//
//List {
//    Picker("Ear/Headphone Device", selection: $headphoneDevice) {
//        Text("Apple AirPods Generation 2").tag(CalibratedModels.Apple_AirPods_Generation_2)
//        Text("Apple AirPods Generation 3").tag(CalibratedModels.Apple_AirPods_Generation_3)
//        Text("Apple Air Pod Pro").tag(CalibratedModels.Apple_Air_Pod_Pro)
//        Text("Apple Air Pods Max").tag(CalibratedModels.Apple_Air_Pods_Max)
//        Text("Beats Studio Buds").tag(CalibratedModels.Beats_Studio_Buds)
//        Text("Beats Fit Pro").tag(CalibratedModels.Beats_Fit_Pro)
//        Text("Beats Studio 3").tag(CalibratedModels.Beats_Studio_3)
//        Text("Jabra Elite 85t").tag(CalibratedModels.Jabra_Elite_85t)
//        Text("Nura True").tag(CalibratedModels.Nura_True)
//        Text("Skullcandy Indy Anc").tag(CalibratedModels.Skullcandy_Indy_Anc)
//        Text("Soundcore Liberty 3").tag(CalibratedModels.Soundcore_Liberty_3)
//        Text("TTS Testing System").tag(CalibratedModels.TTS_Testing_System)
//        Text("Unknown").tag(CalibratedModels.Unknown)
//        Text("Not Listed").tag(CalibratedModels.Not_Listed)
//    }
//}

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift


struct SaveFinalDeviceSelection: Codable {  // This is a model
    var jsonFinalDevicSelectionName = [String]()
    var jsonFinalDeviceSelectionIndex = [Int]()
    var jsonStringFinalDeviceSelectionUUID = [String]()
    var jsonFinalDeviceSelectionUUID = [UUID]()
    var jsonFinalHeadphoneModelIsUnknownIndex = [Int]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalDevicSelectionName
        case jsonFinalDeviceSelectionIndex
        case jsonStringFinalDeviceSelectionUUID
        case jsonFinalDeviceSelectionUUID
        case jsonFinalHeadphoneModelIsUnknownIndex
    }
}


struct HeadphoneModels: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledH = false
    init(name: String) {
        self.name = name
    }
}

struct CalibrationAssessmentView: View {
    var colorModel: ColorModel = ColorModel()
    
    
    let setupCSVName = "SetupResultsCSV.csv"
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    
    
    @State var showDeviceSheet: Bool = false
    @State var refreshView: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var deviceSelectionIndex = [Int]()
    @State var deviceApprovalFinding = Int()
    @State var selectedDeviceName: [String] = [""]
    @State var selectedDeviceUUID: [UUID] = [UUID]()
    @State var multipleDevicesCheck = [Int]()
    @State var notifyOfMultipleDevices = Int()
    @State var isOkayToProceed = Bool()
    @State var isSubmitted: Bool = false
    @State private var linkColors: [Color] = [Color.clear, Color.green]
    @State private var linkColors2: [Color] = [Color.clear, Color.white]
    @State private var linkColorIndex = 0
    
    @State var headphones = [
        HeadphoneModels(name: "Not Listed"),
        HeadphoneModels(name: "Unknown"),
        HeadphoneModels(name: "TTS Testing System"),
        HeadphoneModels(name: "Apple AirPods Generation 2"),
        HeadphoneModels(name: "Apple AirPods Generation 3"),
        HeadphoneModels(name: "Apple Air Pod Pro"),
        HeadphoneModels(name: "Apple Air Pods Max"),
        HeadphoneModels(name: "Beats Studio Buds"),
        HeadphoneModels(name: "Beats Fit Pro"),
        HeadphoneModels(name: "Beats Studio 3"),
        HeadphoneModels(name: "Jabra Elite 85t"),
        HeadphoneModels(name: "Nura True"),
        HeadphoneModels(name: "Skullcandy Indy Anc"),
        HeadphoneModels(name: "Soundcore Liberty 3")
    ]
    
    
    @State var deviceSelection = [Int]()
    @State var userSelectedDeviceName = [String]()
    @State var userSelectedDeviceUUID = [UUID]()
    @State var userSelectedDeviceIndex = [Int]()
    @State var headphoneModelsUnknownIndex = [Int]()
    @State var manualDeviceEntryRequired = [Int]()
    @State var finalDevicSelectionName: [String] = [String]()
    @State var finalDeviceSelectionIndex: [Int] = [Int]()
    @State var finalDeviceSelectionUUID: [UUID] = [UUID]()
    @State var finalHeadphoneModelIsUnknownIndex: [Int] = [Int]()
    @State var stringJsonFDSUUID = [String]()
    @State var stringFDSUUID = [String]()
    @State var stringInputFDSUUID = [String]()
    
    let fileDeviceName = ["DeviceSelection.json"]
    let deviceCSVName = "DeviceSelectionCSV.csv"
    let inputDeviceCSVName = "InputDeviceSelectionCSV.csv"
    
    @State var saveFinalDeviceSelection: SaveFinalDeviceSelection? = nil
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                Text("Select The Type of Ear/Headphones You Are Using or Select The Most Appropriate Option Available.")
                    .padding()
                    .foregroundColor(.white)
                    .font(.title3)
                Text("ONLY SELECT ONE ITEM!")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    showDeviceSheet.toggle()
                    
                }, label: {
                    Text("Open Our List of Calibrated Ear/Headphones")
                        .padding()
                        .foregroundColor(colorModel.neonGreen)
                    Image(systemName: "arrow.up.doc.on.clipboard")
                        .padding()
                        .foregroundColor(colorModel.neonGreen)
                })
                Spacer()
                    .fullScreenCover(isPresented: $showDeviceSheet, content: {
                        VStack(alignment: .leading) {
                            
                            Button(action: {
                                showDeviceSheet.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .padding(10)
                                    .foregroundColor(.red)
                            })
                            List {
                                ForEach(headphones.indices, id: \.self) {index in
                                    HStack {
                                        
                                        Text("\(self.headphones[index].name)")
                                            .foregroundColor(.blue)
                                        
                                        Toggle("", isOn: self.$headphones[index].isToggledH)
                                            .foregroundColor(.blue)
                                            .onChange(of: self.headphones[index].isToggledH) { nameIndex in
                                                Task(priority: .userInitiated, operation: {
                                                    deviceSelectionIndex.removeAll()
                                                    selectedDeviceName.append(self.headphones[index].name)
                                                    selectedDeviceUUID.append(self.headphones[index].id)
                                                    
                                                    deviceApprovalFinding = index
                                                    multipleDevicesCheck.append(deviceApprovalFinding)
                                                    userSelectedDeviceName.append(headphones[index].name)
                                                    userSelectedDeviceUUID.append(headphones[index].id)
                                                    userSelectedDeviceIndex.append(index)
                                                    headphoneModelsUnknownIndex.append(self.headphones.count)
                                                    deviceSelectionIndex.append(index)
                                                    
                                                    print("isokaytoproceed: \(isOkayToProceed)")
                                                    print("multipledevices: \(multipleDevicesCheck)")
                                                    print(index)
                                                    print(nameIndex)
                                                    print(selectedDeviceName)
                                                    print(selectedDeviceUUID)
                                                    print(self.headphones[index].name)
                                                    print(self.headphones[index].id)
                                                    print(self.headphones[0].id)
                                                    print(deviceSelectionIndex)
                                                    print(userSelectedDeviceName)
                                                    print(userSelectedDeviceUUID)
                                                    print(userSelectedDeviceIndex)
                                                })
                                            }
                                    }
                                }
                            }
                            .onAppear {
                                Task(priority: .userInitiated, operation: {
                                    deviceApprovalFinding = Int()
                                    isSubmitted = false
                                    notifyOfMultipleDevices = Int()
                                    isOkayToProceed = false
                                    deviceApprovalFinding = Int()
                                    selectedDeviceName.removeAll()
                                    selectedDeviceUUID.removeAll()
                                    userSelectedDeviceName.removeAll()
                                    userSelectedDeviceUUID.removeAll()
                                    userSelectedDeviceIndex.removeAll()
                                    headphoneModelsUnknownIndex.removeAll()
                                    deviceSelectionIndex.removeAll()
                                    deviceSelection.removeAll()
                                })
                            }
                        }
                    })
                HStack{
                    Spacer()
                    Toggle("Submit Selection", isOn: $isSubmitted)
                        .foregroundColor(.blue)
                        .font(.title3)
                        .padding(.leading)
                        .padding(.trailing)
                        .toggleStyle(.switch)
                        .onChange(of: isSubmitted) { submittedValue in
                            Task(priority: .userInitiated, operation: {
                                if submittedValue == true {
                                    await checkMultipleDevices()
                                    await manualDeviceEntryNeeded()
                                    await compareDeviceCalibration()
                                }
                            })
                        }
                    Spacer()
                }
                .onChange(of: notifyOfMultipleDevices) { notifyofMultipleValues in
                    Task(priority: .userInitiated, operation: {
                        if notifyofMultipleValues == 1 {
                            isSubmitted.toggle()
                            self.isOkayToProceed = false
                            self.linkColorIndex = 1
                            multipleDevicesCheck.removeAll()
                        } else if notifyofMultipleValues == 2 {
                            self.isOkayToProceed = true
                            self.linkColorIndex = 1
                            Task {
                                await appendDeviceCalibrationResults()
                                await concentenateFinalDeviceArrays()
                                await saveCalibrationData()
                            }
                            multipleDevicesCheck.removeAll()
                            isOkayToUpload = true
                        }
                    })
                }
                Spacer()
                NavigationLink(destination:
                                isOkayToProceed == false ? AnyView(CalibrationIssueSplashView())
                               : multipleDevicesCheck.count > 1 ? AnyView(CalibrationIssueSplashView())
                               : deviceApprovalFinding == 0 ? AnyView(CalibrationSplashView())
                               : deviceApprovalFinding == 1 ? AnyView(ManualDeviceEntryInformationView())
                               : AnyView(InstructionsForTakingTest())
                ){
                    HStack{
                        Spacer()
                        Text("Now Let's Contine!")
                        Spacer()
                        Image(systemName: "arrowshape.bounce.right")
                        Spacer()
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .background(linkColors[linkColorIndex])
                    .foregroundColor(linkColors2[linkColorIndex])
                    .cornerRadius(24)
                }
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            isSubmitted = false
            linkColorIndex = 0
            Task {
                await setupCSVReader()
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                Task{
                    await uploadDeviceData()
                    print("Upload Data Started")
                }
            } else {
                print("Fatal error in upload data change logic")
            }
        }
    }
}
    
extension CalibrationAssessmentView {
//MARK: -Extension Methods
    func manualDeviceEntryNeeded() async {
        if deviceSelectionIndex.count > 0 {
            if deviceSelectionIndex.last! == 0 {
                //Not Listed Selected; Go To Splash
                deviceSelection.append(0)
                print("User is using an unapproved device")
            } else if deviceSelectionIndex.last! == 1 {
                //Unknow selected; Go To Manual Entry
                deviceSelection.append(1)
                print("User is using an unknown device")
            } else if deviceSelectionIndex.last! >= 2 {
                // Accepted device selected; proceed to disclaimer view
                deviceSelection.append(2)
                print("User is using a Approved device")
            } else {
                // Error go to Manual Entry
                deviceSelection.append(3)
                print("!!!Error Device Selection Error")
            }
        } else {
            print("!!!Error in manualDeviceEntryNeeded First Logic Block")
        }
    }
    
    func compareDeviceCalibration()  async {
        if  deviceApprovalFinding == 0 {
            manualDeviceEntryRequired.append(0)
            print("User is using an unapproved device")
        } else if   deviceApprovalFinding == 1 {
            deviceApprovalFinding = 1
            manualDeviceEntryRequired.append(0)
            print("User is using an unknown device")
        } else if deviceApprovalFinding > 1 {
            deviceApprovalFinding = 2
            manualDeviceEntryRequired.append(2)
            print("User States Device is Unknown")
            print("Manual Device Entry is Required")
        } else {
            print("Error!!! in compareDeviceCalibration Func")
        }
    }
    
    func checkMultipleDevices() async {
        if multipleDevicesCheck.count > 1 {
            self.isOkayToProceed = false
            notifyOfMultipleDevices = 1
            self.linkColorIndex = 0
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("Error, multiple Devices Selected in check multiple devices")
        } else if multipleDevicesCheck.count == 1 {
            self.isOkayToProceed = true
            notifyOfMultipleDevices = 2
            self.linkColorIndex = 1
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("Only On Device Selected")
        } else {
            self.isOkayToProceed = false
            notifyOfMultipleDevices = 1
            self.linkColorIndex = 0
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("!!!Error in checkMultipleDevices() Logic")
        }
    }
    
    func resetCheckMultipleDevices() async {
        multipleDevicesCheck.removeAll()
        isOkayToProceed = false
        notifyOfMultipleDevices = Int()
        linkColorIndex = 0
        print("multipleDevices reset: \(multipleDevicesCheck)")
        print("isokaytoproceed reset: \(isOkayToProceed)")
    }
    
    func appendDeviceCalibrationResults()  async {
        print("userSelectedDeviceName: \(userSelectedDeviceName)")
        print("userSelectedDeviceUUID: \(userSelectedDeviceUUID)")
        print("userSelectedDeviceIndex: \(userSelectedDeviceIndex)")
        print("headphoneModelisUnknownIndex: \(headphoneModelsUnknownIndex)")
    }
    
    func concentenateFinalDeviceArrays() async {
        finalDevicSelectionName.append(contentsOf: userSelectedDeviceName)
        finalDeviceSelectionIndex.append(contentsOf: userSelectedDeviceIndex)
        finalDeviceSelectionUUID.append(contentsOf: userSelectedDeviceUUID)
        finalHeadphoneModelIsUnknownIndex.append(contentsOf: headphoneModelsUnknownIndex)
        print("finalDeviceSelectionName: \(finalDevicSelectionName)")
        print("finalDeviceSelectionIndex: \(finalDeviceSelectionIndex)")
        print("finalDeviceSelectionUUID: \(finalDeviceSelectionUUID)")
        print("finalHeadphoneModelIsUnknownIndex: \(finalHeadphoneModelIsUnknownIndex)")
    }
    
    func saveCalibrationData() async {
        await getDeviceData()
        await saveDeviceToJSON()
        await writeDeviceResultsToCSV()
        await writeInputDeviceResultsToCSV()
    }
    
    func uploadDeviceData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: deviceCSVName)
            uploadFile(fileName: inputDeviceCSVName)
            uploadFile(fileName: "DeviceSelection.json")
        }
    }
}
 
extension CalibrationAssessmentView {
//MARK: -Extension CSV/JSON Methods
    func getDeviceData() async {
        guard let deviceSelectionData = await getDeviceJSONData() else { return }
        print("Json Device Selection Data:")
        print(deviceSelectionData)
        let jsonDeviceSelectionString = String(data: deviceSelectionData, encoding: .utf8)
        print(jsonDeviceSelectionString!)
        do {
        self.saveFinalDeviceSelection = try JSONDecoder().decode(SaveFinalDeviceSelection.self, from: deviceSelectionData)
            print("JSON GetDeviceSelectionData Run")
            print("data: \(deviceSelectionData)")
        } catch let error {
            print("!!!Error decoding Device selection json data: \(error)")
        }
    }
    
    func getDeviceJSONData() async -> Data? {
        let formatter3J = DateFormatter()
        formatter3J.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringJsonFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let saveFinalDeviceSelection = SaveFinalDeviceSelection (
            jsonFinalDevicSelectionName: finalDevicSelectionName,
            jsonFinalDeviceSelectionIndex: finalDeviceSelectionIndex,
            jsonStringFinalDeviceSelectionUUID: stringJsonFDSUUID,
            jsonFinalDeviceSelectionUUID: finalDeviceSelectionUUID,
            jsonFinalHeadphoneModelIsUnknownIndex: finalHeadphoneModelIsUnknownIndex)
        let jsonDeviceData = try? JSONEncoder().encode(saveFinalDeviceSelection)
        print("saveFinalDeviceSelection: \(saveFinalDeviceSelection)")
        print("Json Encoded \(jsonDeviceData!)")
        return jsonDeviceData
    }

    func saveDeviceToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let devicePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = devicePaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let deviceFilePaths = documentsDirectory.appendingPathComponent(fileDeviceName[0])
        print(deviceFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonDeviceData = try encoder.encode(saveFinalDeviceSelection)
            print(jsonDeviceData)
          
            try jsonDeviceData.write(to: deviceFilePaths)
        } catch {
            print("Error writing to JSON Device Selection file: \(error)")
        }
    }

    func writeDeviceResultsToCSV() async {
        print("writeDeviceSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let stringFinalDevicSelectionName = "finalDevicSelectionName," +  finalDevicSelectionName.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionIndex = "finalDeviceSelectionIndex," + finalDeviceSelectionIndex.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionUUID = "finalDeviceSelectionUUID," + stringFDSUUID.map { String($0) }.joined(separator: ",")
        let stringFinalHeadphoneModelIsUnknownIndex = "finalHeadphoneModelIsUnknownIndex," + finalHeadphoneModelIsUnknownIndex.map { String($0) }.joined(separator: ",")
        do {
            let csvDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvDeviceDocumentsDirectory = csvDevicePath
            print("CSV Device Selection DocumentsDirectory: \(csvDeviceDocumentsDirectory)")
            let csvDeviceFilePath = csvDeviceDocumentsDirectory.appendingPathComponent(deviceCSVName)
            print(csvDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalDevicSelectionName])
            try writerSetup.write(row: [stringFinalDeviceSelectionIndex])
            try writerSetup.write(row: [stringFinalDeviceSelectionUUID])
            try writerSetup.write(row: [stringFinalHeadphoneModelIsUnknownIndex])
            print("CVS Device Selection Writer Success")
        } catch {
            print("CVSWriter Device Selection Error or Error Finding File for Device Selection CSV \(error.localizedDescription)")
        }
    
    }
    
    func writeInputDeviceResultsToCSV() async {
        print("writeInputDeviceSelectionToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalDeviceSelectionUUID.count != 0 {
            stringInputFDSUUID = finalDeviceSelectionUUID.map { ($0).uuidString }
        } else {
            print("finalDeviceSelectionUUID is nil")
        }
        let stringFinalDevicSelectionName = finalDevicSelectionName.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionIndex = finalDeviceSelectionIndex.map { String($0) }.joined(separator: ",")
        let stringFinalDeviceSelectionUUID = stringFDSUUID.map { String($0) }.joined(separator: ",")
        let stringFinalHeadphoneModelIsUnknownIndex = finalHeadphoneModelIsUnknownIndex.map { String($0) }.joined(separator: ",")
        do {
            let csvInputDevicePath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputDeviceDocumentsDirectory = csvInputDevicePath
            print("CSV Input Device Selection DocumentsDirectory: \(csvInputDeviceDocumentsDirectory)")
            let csvInputDeviceFilePath = csvInputDeviceDocumentsDirectory.appendingPathComponent(inputDeviceCSVName)
            print(csvInputDeviceFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputDeviceFilePath, append: false)
            try writerSetup.write(row: [stringFinalDevicSelectionName])
            try writerSetup.write(row: [stringFinalDeviceSelectionIndex])
            try writerSetup.write(row: [stringFinalDeviceSelectionUUID])
            try writerSetup.write(row: [stringFinalHeadphoneModelIsUnknownIndex])
            print("CVS Input Device Selection Writer Success")
        } catch {
            print("CVSWriter Input Device Selection Error or Error Finding File for Input Device Selection CSV \(error.localizedDescription)")
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


//struct CalibrationAssessmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalibrationAssessmentView()
//            
//    }
//}


