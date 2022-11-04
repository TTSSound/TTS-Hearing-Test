//
//  PostEHATestView.swift
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
import FileProvider


struct SaveSystemSettingsEndEHA: Codable {
    var jsonFinalEndingEHASystemVolume = [Float]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalEndingEHASystemVolume
    }
}

struct PostEHATestView<Link: View>: View {
    var ehaTesting: EHATesting?
    var relatedLinkEHATesting: (EHATesting) -> Link
    
    var body: some View {
        if let ehaTesting = ehaTesting {
            PostEHATestContent(ehaTesting: ehaTesting, relatedLinkEHATesting: relatedLinkEHATesting)
        } else {
            Text("Error Loading EHAInterimPreEHAP2 View")
                .navigationTitle("")
        }
    }
}


struct PostEHATestContent<Link: View>: View {
    var ehaTesting: EHATesting
    var dataModel = DataModel.shared
    var relatedLinkEHATesting: (EHATesting) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var volumeEHAPostTest = Float()
    
    
    @State var finalEndingEHASystemVolume: [Float] = [Float]()
    
    let fileSystemEndEHAName = ["SystemSettingsEndEHA.json"]
    let systemEndEHACSVName = "SystemSettingsEndEHACSV.csv"
    let inputSystemEndEHACSVName = "InputSystemSettingsEndEHACSV.csv"
    
    @State var saveSystemSettingsEndEHA: SaveSystemSettingsEndEHA? = nil
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("View for Completion of EHA Full Test")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top,40)
                    .padding(.bottom, 20)
                Spacer()
                Text("Great Work!")
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Text("Give Us A Moment To Calculate and Format Your Results")
                    .foregroundColor(.white)
                Spacer()
                
                Text("Return Home to Navigate To Results")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding(.bottom, 40)
                Spacer()
            }
        }
        .onAppear {
            Task{
                audioSessionModel.setAudioSession()
                await checkEHAPostTestVolume()
                await savePostEHATestSystemSettings()
                await comparedLastNameCSVReader()
                //                await checkMonoRightTestLink()
                //                await checkMonoLeftTestLink()
                //                await monoEarBetterExists()
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                Task {
                    await uploadPostEHAP2Settings()
                }
            } else {
                print("Fatal Error in uploadValue Change Of Logic")
            }
        }
    }
}
 
extension PostEHATestContent {
    //MARK: -Methods Extension
    func checkEHAPostTestVolume() async {
        volumeEHAPostTest = audioSessionModel.audioSession.outputVolume
        finalEndingEHASystemVolume.append(volumeEHAPostTest)
        print("EHA Volume Post Test: \(volumeEHAPostTest)")
        print("setupDataModel finalEndingEHASystemVolume: \(finalEndingEHASystemVolume)")
    }
    
    func savePostEHATestSystemSettings() async {
        await getSystemEndEHAData()
        await saveSystemEndEHAToJSON()
        await writeSystemEndEHAResultsToCSV()
        await writeInputSystemEndEHAResultsToCSV()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, qos: .userInteractive) {
            isOkayToUpload = true
        }
    }
    
    func uploadPostEHAP2Settings() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: "SystemSettingsEndEHA.json")
            uploadFile(fileName: systemEndEHACSVName)
            uploadFile(fileName: inputSystemEndEHACSVName)
        }
    }
}

extension PostEHATestContent {
//MARK: -CSV/JSON Methods Extension
    func getSystemEndEHAData() async {
        guard let systemSettingsEndEHAData = await getSystemEndEHAJSONData() else { return }
        print("Json System Settings End EHA Data:")
        print(systemSettingsEndEHAData)
        let jsonSystemSettingsEndEHAString = String(data: systemSettingsEndEHAData, encoding: .utf8)
        print(jsonSystemSettingsEndEHAString!)
        do {
        self.saveSystemSettingsEndEHA = try JSONDecoder().decode(SaveSystemSettingsEndEHA.self, from: systemSettingsEndEHAData)
            print("JSON Get System Settings End EHA Run")
            print("data: \(systemSettingsEndEHAData)")
        } catch let error {
            print("!!!Error decoding system Settings End EHA json data: \(error)")
        }
    }
    
    func getSystemEndEHAJSONData() async -> Data? {
        let saveSystemSettingsEndEHA = SaveSystemSettingsEndEHA (
        jsonFinalEndingEHASystemVolume: finalEndingEHASystemVolume)
        let jsonSystemEndEHASettingsData = try? JSONEncoder().encode(saveSystemSettingsEndEHA)
        print("saveFinalResults: \(saveSystemSettingsEndEHA)")
        print("Json Encoded \(jsonSystemEndEHASettingsData!)")
        return jsonSystemEndEHASettingsData
    }
    
    func saveSystemEndEHAToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let systemEndEHAPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let endEHADocumentsDirectory = systemEndEHAPaths[0]
        print("endEHADocumentsDirectory: \(endEHADocumentsDirectory)")
        let systemEndEHAFilePaths = endEHADocumentsDirectory.appendingPathComponent(fileSystemEndEHAName[0])
        print(systemEndEHAFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemEndEHAData = try encoder.encode(saveSystemSettingsEndEHA)
            print(jsonSystemEndEHAData)
            try jsonSystemEndEHAData.write(to: systemEndEHAFilePaths)
        } catch {
            print("Error writing to JSON System End EHA Settings file: \(error)")
        }
    }

    func writeSystemEndEHAResultsToCSV() async {
        print("writeSystemEndEHAResultsToCSV Start")
        let stringfinalEndingEHASystemVolume = "finalEndingEHASystemVolume," + finalEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvSystemEndEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemEndEHADocumentsDirectory = csvSystemEndEHAPath
            print("CSV System End EHA Settings DocumentsDirectory: \(csvSystemEndEHADocumentsDirectory)")
            let csvSystemEndEHAFilePath = csvSystemEndEHADocumentsDirectory.appendingPathComponent(systemEndEHACSVName)
            print(csvSystemEndEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemEndEHAFilePath, append: false)
            try writerSetup.write(row: [stringfinalEndingEHASystemVolume])
            print("CVS System End EHA Settings Writer Success")
        } catch {
            print("CVSWriter System End EHA Settings Error or Error Finding File for System End EHA Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemEndEHAResultsToCSV() async {
        print("writeInputSystemInterimResultsToCSV Start")
        let stringfinalEndingEHASystemVolume = finalEndingEHASystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSystemEndEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemEndEHADocumentsDirectory = csvInputSystemEndEHAPath
            print("CSV Input System End EHA Settings DocumentsDirectory: \(csvInputSystemEndEHADocumentsDirectory)")
            let csvInputSystemEndEHAFilePath = csvInputSystemEndEHADocumentsDirectory.appendingPathComponent(inputSystemEndEHACSVName)
            print(csvInputSystemEndEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemEndEHAFilePath, append: false)
            try writerSetup.write(row: [stringfinalEndingEHASystemVolume])
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

extension EHATTSTestPart2Content {
//MARK: -NavigationLink Extension
    
    private func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
}


//struct PostEHATestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostEHATestView(ehaTesting: nil, relatedLinkEHATesting: linkEHATesting)
//    }
//
//    static func linkEHATesting(ehaTesting: EHATesting) -> some View {
//        EmptyView()
//    }
//}
