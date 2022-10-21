//
//  PostAllTestsSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase


struct SaveSystemSettingsInterimEHA: Codable {
    var jsonFinalInterimEndingEHASystemVolume = [Float]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalInterimEndingEHASystemVolume
    }
}

struct SaveSystemSettingsEndEPTASimple: Codable {
    
    var jsonFinalEndingSystemVolume = [Float]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalEndingSystemVolume
    }
}

struct PostAllTestsSplashView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PostAllTestsSplashContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading PostAllTestsSplash View")
                .navigationTitle("")
        }
    }
}

struct PostAllTestsSplashContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    var audioSessionModel: AudioSessionModel = AudioSessionModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var pavolume = Float()
    @State var pavolumeCorrect = Int()
    @State var pavolumeSettingIndex = Int()
    @State var paColors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var paLinkColorIndex = 0
    
    
    @State var ehaPostLinkExists = Bool()
    @State var eptaPostLinkExists = Bool()
    @State var simplePostLinkExists = Bool()
    @State var testTakenDirector = Int()
    
    @State var finalEndingSystemVolume: [Float] = [Float]()
    
    let fileSystemSettingsEndName = ["EndEPTASimpleSystemSettings.json"]
    let systemSettingsEndCSVName = "EndEPTASimpleSystemSettingsCSV.csv"
    let inputSystemSettingsEndCSVName = "InputEndEPTASimpleSystemSettingsCSV.csv"
    
    @State var saveSystemSettingsEndEPTASimple: SaveSystemSettingsEndEPTASimple? = nil
    
    @State var finalInterimEndingEHASystemVolume: [Float] = [Float]()
    @State var finalInterimStartingEHASystemVolume: [Float] = [Float]()
    
    let fileSystemInterimEHAName = ["SystemSettingsInterimEHA.json"]
    let systemInterimEHACSVName = "SystemSettingsInterimEHACSV.csv"
    let inputSystemInterimEHACSVName = "InputSystemSettingsInterimEHACSV.csv"
    
    @State var saveSystemSettingsInterimEHA: SaveSystemSettingsInterimEHA? = nil
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Post All Test Splash View To Direct To The Correct Results Screen or To EHA Interim Test Screen")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
                Button {
                    Task {
                        await checkPostEHATestLik()
                        await checkPostEPTATestLik()
                        await checkPostSimpleTestLik()
                        await returnPostTestSelected()
                    }
                } label: {
                    Text("Check Post Test System Setting")
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(24)
                    
                }
                Spacer()
                NavigationLink(destination:
                                testTakenDirector == 1 ? AnyView(EHAInterimPostEPTAView(testing: testing, relatedLinkTesting: linkTesting))
                               : testTakenDirector == 2 ? AnyView(PostEPTATestView(testing: testing, relatedLinkTesting: linkTesting))
                               : testTakenDirector == 3 ? AnyView(PostSimpleTestView(testing: testing, relatedLinkTesting: linkTesting))
                               : AnyView(PostTestDirectorSplashView(testing: testing, relatedLinkTesting: linkTesting))
                ){
                    HStack{
                        Spacer()
                        Text("Now Let's Contine!")
                        Spacer()
                        Image(systemName: "arrowshape.bounce.right")
                            .font(.title)
                        Spacer()
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(24)
                }
                Spacer()
            }
            .onAppear {
                Task{
                    audioSessionModel.setAudioSession()
                    recheckVolue()
                    await concantenateFinalSystemVolumeArray()
                    await saveTestSystemSettings()
                    audioSessionModel.cancelAudioSession()
                    await comparedLastNameCSVReader()
                }
            }
            .onChange(of: isOkayToUpload) { uploadValue in
                if uploadValue == true {
                    Task {
                        await uploadPostAllTestSettings()
                    }
                } else {
                    print("Fatal Error in uploadValue Change of Logic")
                }
            }
        }
    }
}

extension PostAllTestsSplashContent {
//MARK: -Methods Extension
    
    func recheckVolue() {
        if audioSessionModel.audioSession.outputVolume == 0.63 {
            pavolumeCorrect = 1
            paLinkColorIndex = 1
            pavolumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.60 && audioSessionModel.audioSession.outputVolume <= 0.655 {
            pavolumeCorrect = 2
            paLinkColorIndex = 2
            pavolumeSettingIndex = 2
            pavolume = audioSessionModel.audioSession.outputVolume
            print(audioSessionModel.audioSession.outputVolume)
        } else {
            pavolumeCorrect = 0
            paLinkColorIndex = 0
            pavolumeSettingIndex = 0
            pavolume = audioSessionModel.audioSession.outputVolume
        }
    }
    
//    func whatTest() async {
//        if testSelectionModel.finalSelectedEHATest == [1] {
//            testTakenDirector = 1
//        } else if testSelectionModel.finalSelectedEPTATest == [1] {
//            testTakenDirector = 2
//        } else if testSelectionModel.finalSelectedSimpleTest == [1] {
//            testTakenDirector = 3
//        } else {
//            print("!!!Error in whatTest Logic")
//        }
//    }
    
    func returnPostTestSelected() async {
        if ehaPostLinkExists == true {
            testTakenDirector = 1
            print("EHA Test Link Exists")
        } else {
            print("EHA Link Does Not Exist")
        }
        if eptaPostLinkExists == true {
            testTakenDirector = 2
            print("EPTA Test Link Exists")
        } else {
            print("EPTA Link Does Not Exist")
        }
        if simplePostLinkExists == true {
            testTakenDirector = 3
            print("Simple Test Link Exists")
        } else {
            print("Simple Link Does Not Exist")
        }
    }
    
    func getPostTestLinkPath() async -> String {
        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = testLinkPaths[0]
        return documentsDirectory
    }

    func checkPostEHATestLik() async {
        let ehaName = ["EHA.csv"]
        let fileManager = FileManager.default
        let ehaPath = (await self.getPostTestLinkPath() as NSString).strings(byAppendingPaths: ehaName)
        if fileManager.fileExists(atPath: ehaPath[0]) {
            let ehaFilePath = URL(fileURLWithPath: ehaPath[0])
            if ehaFilePath.isFileURL  {
                ehaPostLinkExists = true
            } else {
                print("EHA.csv Does Not Exist")
            }
        }
    }
        
    func checkPostEPTATestLik() async {
        let eptaName = ["EPTA.csv"]
        let fileManager = FileManager.default
        let eptaPath = (await self.getPostTestLinkPath() as NSString).strings(byAppendingPaths: eptaName)
        if fileManager.fileExists(atPath: eptaPath[0]) {
            let eptaFilePath = URL(fileURLWithPath: eptaPath[0])
            if eptaFilePath.isFileURL  {
                eptaPostLinkExists = true
            } else {
                print("EPTA.csv Does Not Exist")
            }
        }
    }
    
    func checkPostSimpleTestLik() async {
        let simpleName = ["Simple.csv"]
        let fileManager = FileManager.default
        let simplePath = (await self.getPostTestLinkPath() as NSString).strings(byAppendingPaths: simpleName)
        if fileManager.fileExists(atPath: simplePath[0]) {
            let simpleFilePath = URL(fileURLWithPath: simplePath[0])
            if simpleFilePath.isFileURL  {
                simplePostLinkExists = true
            } else {
                print("Simple.csv Does Not Exist")
            }
        }
    }
    
    func concantenateFinalSystemVolumeArray() async {
        finalEndingSystemVolume.removeAll()
        finalEndingSystemVolume.append(pavolume)
        finalInterimEndingEHASystemVolume.removeAll()
        finalInterimEndingEHASystemVolume.append(pavolume)
        print("finalStartingSystemVolume: \(pavolume)")
        print("finalInterimEndingEHASystemVolume: \(pavolume)")
    }
    
    func saveTestSystemSettings() async {
        await getSystemEndData()
        await saveSystemEndToJSON()
        await writeSystemEndResultsToCSV()
        await writeInputSystemEndResultsToCSV()
        await getInterimEndData()
        await saveSystemInterimToJSON()
        await writeSystemInterimResultsToCSV()
        await writeInputSystemInterimResultsToCSV()
        isOkayToUpload = true
    }
        
    func uploadPostAllTestSettings() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: "EndEPTASimpleSystemSettings.json")
            uploadFile(fileName: systemSettingsEndCSVName)
            uploadFile(fileName: inputSystemSettingsEndCSVName)
            uploadFile(fileName: "SystemSettingsInterimEHA.json")
            uploadFile(fileName: systemInterimEHACSVName)
        }
    }
}


extension PostAllTestsSplashContent {
//MARK: -CSV/JSON Methods Extensions
    
    func getSystemEndData() async {
        guard let systemSettingsEndData = await getSystemEndJSONData() else { return }
        print("Json System Settings End Data:")
        print(systemSettingsEndData)
        let jsonSystemSettingsEndString = String(data: systemSettingsEndData, encoding: .utf8)
        print(jsonSystemSettingsEndString!)
        do {
        self.saveSystemSettingsEndEPTASimple = try JSONDecoder().decode(SaveSystemSettingsEndEPTASimple.self, from: systemSettingsEndData)
            print("JSON Get System End Settings Run")
            print("data: \(systemSettingsEndData)")
        } catch let error {
            print("!!!Error decoding system Settings End json data: \(error)")
        }
    }
    
    func getSystemEndJSONData() async -> Data? {
        let saveSystemSettingsEndEPTASimple = SaveSystemSettingsEndEPTASimple (
        jsonFinalEndingSystemVolume: finalEndingSystemVolume)
        let jsonSystemSettingsEndData = try? JSONEncoder().encode(saveSystemSettingsEndEPTASimple)
        print("saveFinalResults: \(saveSystemSettingsEndEPTASimple)")
        print("Json Encoded \(jsonSystemSettingsEndData!)")
        return jsonSystemSettingsEndData
    }
    
    func saveSystemEndToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let systemEndPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let endDocumentsDirectory = systemEndPaths[0]
        print("endDocumentsDirectory: \(endDocumentsDirectory)")
        let systemEndFilePaths = endDocumentsDirectory.appendingPathComponent(fileSystemSettingsEndName[0])
        print(systemEndFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemEndData = try encoder.encode(saveSystemSettingsEndEPTASimple)
            print(jsonSystemEndData)
          
            try jsonSystemEndData.write(to: systemEndFilePaths)
        } catch {
            print("Error writing to JSON System End Settings file: \(error)")
        }
    }

    func writeSystemEndResultsToCSV() async {
        print("writeSystemEndResultsToCSV Start")
        let stringFinalEndingSystemVolume = "finalEndingSystemVolume," + finalEndingSystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvSystemEndPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemEndDocumentsDirectory = csvSystemEndPath
            print("CSV System End Settings DocumentsDirectory: \(csvSystemEndDocumentsDirectory)")
            let csvSystemEndFilePath = csvSystemEndDocumentsDirectory.appendingPathComponent(systemSettingsEndCSVName)
            print(csvSystemEndFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemEndFilePath, append: false)
            try writerSetup.write(row: [stringFinalEndingSystemVolume])
            print("CVS System End Settings Writer Success")
        } catch {
            print("CVSWriter System End Settings Error or Error Finding File for System End Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemEndResultsToCSV() async {
        print("writeInputSystemEndResultsToCSV Start")
        let stringFinalEndingSystemVolume = finalEndingSystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSystemEndPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemEndDocumentsDirectory = csvInputSystemEndPath
            print("CSV Input System End Settings DocumentsDirectory: \(csvInputSystemEndDocumentsDirectory)")
            let csvInputSystemEndFilePath = csvInputSystemEndDocumentsDirectory.appendingPathComponent(inputSystemSettingsEndCSVName)
            print(csvInputSystemEndFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemEndFilePath, append: false)
            try writerSetup.write(row: [stringFinalEndingSystemVolume])
            print("CVS Input System End Settings Writer Success")
        } catch {
            print("CVSWriter Input System End Settings Error or Error Finding File for Input System End Settings CSV \(error.localizedDescription)")
        }
    }
    
    func getInterimEndData() async {
        guard let systemSettingsInterimData = await getSystemInterimJSONData() else { return }
        print("Json System Settings Interim Data:")
        print(systemSettingsInterimData)
        let jsonSystemSettingsInterimString = String(data: systemSettingsInterimData, encoding: .utf8)
        print(jsonSystemSettingsInterimString!)
        do {
            self.saveSystemSettingsInterimEHA = try JSONDecoder().decode(SaveSystemSettingsInterimEHA.self, from: systemSettingsInterimData)
            print("JSON Get System Interim Settings Run")
            print("data: \(systemSettingsInterimData)")
        } catch let error {
            print("!!!Error decoding system Settings Interim json data: \(error)")
        }
    }
    
    func getSystemInterimJSONData() async -> Data? {
        let saveSystemSettingsInterimEHA = SaveSystemSettingsInterimEHA (
            jsonFinalInterimEndingEHASystemVolume: finalInterimEndingEHASystemVolume)
        let jsonSystemInterimSettingsData = try? JSONEncoder().encode(saveSystemSettingsInterimEHA)
        print("saveFinalResults: \(saveSystemSettingsInterimEHA)")
        print("Json Encoded \(jsonSystemInterimSettingsData!)")
        return jsonSystemInterimSettingsData
    }
    
    func saveSystemInterimToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let systemInterimPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let interimDocumentsDirectory = systemInterimPaths[0]
        print("interimDocumentsDirectory: \(interimDocumentsDirectory)")
        let systemInterimFilePaths = interimDocumentsDirectory.appendingPathComponent(fileSystemInterimEHAName[0])
        print(systemInterimFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemInterimData = try encoder.encode(saveSystemSettingsInterimEHA)
            print(jsonSystemInterimData)
            try jsonSystemInterimData.write(to: systemInterimFilePaths)
        } catch {
            print("Error writing to JSON System Interim Settings file: \(error)")
        }
    }
    
    func writeSystemInterimResultsToCSV() async {
        print("writeSystemInterimResultsToCSV Start")
        let stringFinalInterimEndingEHASystemVolume = "finalInterimEndingEHASystemVolume," + finalInterimEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvSystemInterimPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemInterimDocumentsDirectory = csvSystemInterimPath
            print("CSV System Interim Settings DocumentsDirectory: \(csvSystemInterimDocumentsDirectory)")
            let csvSystemInterimFilePath = csvSystemInterimDocumentsDirectory.appendingPathComponent(systemInterimEHACSVName)
            print(csvSystemInterimFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemInterimFilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimEndingEHASystemVolume])
            print("CVS System Settings Writer Success")
        } catch {
            print("CVSWriter System Settings Error or Error Finding File for System Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemInterimResultsToCSV() async {
        print("writeInputSystemInterimResultsToCSV Start")
        let stringFinalInterimEndingEHASystemVolume = finalInterimEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSystemInterimPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemInterimDocumentsDirectory = csvInputSystemInterimPath
            print("CSV Input System Interim Settings DocumentsDirectory: \(csvInputSystemInterimDocumentsDirectory)")
            let csvInputSystemInterimFilePath = csvInputSystemInterimDocumentsDirectory.appendingPathComponent(inputSystemInterimEHACSVName)
            print(csvInputSystemInterimFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemInterimFilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimEndingEHASystemVolume])
            print("CVS Input System Interim Settings Writer Success")
        } catch {
            print("CVSWriter Input System Interim Settings Error or Error Finding File for Input System Settings CSV \(error.localizedDescription)")
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
    
    func comparedLastNameCSVReader() async {
        let dataSetupName = inputFinalComparedLastNameCSV
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLComparedLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLComparedLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLComparedLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputLastName = fieldLastName
            print("inputLastName: \(inputLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
    
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

extension PostAllTestsSplashContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

//struct PostAllTestsSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostAllTestsSplashView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//    
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
