//
//  EHAInterimPreEHAP2View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/18/22.
//

import SwiftUI
import CodableCSV
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase



struct EHAInterimPreEHAP2View<Link: View>: View {
    
    var ehaTesting: EHATesting?
    var relatedLinkEHATesting: (EHATesting) -> Link
    
    var body: some View {
        if let ehaTesting = ehaTesting {
            EHAInterimPreEHAP2Content(ehaTesting: ehaTesting, relatedLinkEHATesting: relatedLinkEHATesting)
        } else {
            Text("Error Loading EHAInterimPreEHAP2 View")
                .navigationTitle("")
        }
    }
}

struct SaveSystemSettingsInterimPreEHAP2: Codable {
    var jsonFinalInterimPreEHAP2SystemVolume = [Float]()
    var jsonFinalInterimPreEHAP2SilentMode = Int()

    enum CodingKeys: String, CodingKey {
        case jsonFinalInterimPreEHAP2SystemVolume
        case jsonFinalInterimPreEHAP2SilentMode
    }
}

struct EHAInterimPreEHAP2Content<Link: View>: View {
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
    
    @State var volumeInterimPreEHAP2Test = Float()
    @State var volumePreEHAP2StartingTest = Float()
    
    @State var volumePreEHAP2Correct = Int()
    @State var silentPreEHAP2ModeOff = Int()
    @State var preEHAP2Colors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var preEHAP2LinkColorIndex = 0
    @State var silPreEHAP2Colors: [Color] = [Color.clear, Color.green]
    @State var silPreEHAP2LinkColorIndex = 0
    @State var preEHAP2VolumeSettingString = ["No", "Yes", "Acceptable"]
    @State var preEHAP2VolumeSettingIndex = Int()
    @State var preEHAP2SilentModeSettingString = ["No", "Yes"]
    @State var preEHAP2SilentModeSettingIndex = Int()
    
    @State var preEHAP2MonoRightEarBetterExists = Bool()
    @State var preEHAP2MonoLeftEarBetterExists = Bool()
    @State var preEHAP2MonoEarTestingPan = Float()
    
    @State var interimPreEHAP2ResultsSubmitted: Bool = false
    
    @State var finalInterimPreEHAP2SystemVolume: [Float] = [Float]()
    @State var finalInterimPreEHAP2SilentMode: [Int] = [Int]()
    
    let fileSystemInterimPreEHAP2Name = ["SystemSettingsInterimPreEHAP2.json"]
    let systemInterimPreEHAP2CSVName = "SystemSettingsInterimPreEHAP2CSV.csv"
    let inputSystemInterimPreEHAP2CSVName = "InputSystemSettingsInterimPreEHAP2CSV.csv"
    
    @State var saveSystemSettingsInterimPreEHAP2: SaveSystemSettingsInterimPreEHAP2? = nil
    
    @State var nowShowSubmission: Bool = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading) {
                Text("View for EHA test takers before they start EHA Part 2. The extended phase of the hearing assessment is next.")
                    .foregroundColor(.white)
                    .padding()
                    .padding()
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                HStack{
                    Spacer()
                    Button {
                        Task{
                            audioSessionModel.setAudioSession()
                            await recheckPreEHAP2SystemVolume()
                            await recheckPreEHAP2SilentMode()
                            nowShowSubmission = true
                        }
                    } label: {
                        Text("Recheck Settings Before Proceeding")
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
                            .font(.caption)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(300)
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    Text(String(volumePreEHAP2StartingTest))
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                    Text(String(audioSessionModel.successfulStartToAudioSession))
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                    Text(String(audioSessionModel.audioSession.outputVolume))
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    Text("System Volume is: ")
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(volumePreEHAP2StartingTest))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                HStack{
                    Spacer()
                    Text("Is Volume Correct?")
                        .foregroundColor(.white)
                    Spacer()
                    Text(preEHAP2VolumeSettingString[preEHAP2VolumeSettingIndex])
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                HStack{
                    Spacer()
                    Text("Silent Mode Is Off?")
                        .foregroundColor(.white)
                    Spacer()
                    Text(preEHAP2SilentModeSettingString[preEHAP2SilentModeSettingIndex])
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                if interimPreEHAP2ResultsSubmitted == false && nowShowSubmission == true {
                    HStack{
                        Spacer()
                        Button {
                            DispatchQueue.main.async {
                                Task{
                                    await concantenateFinalPreEHAP2SystemVolumeArray()
                                    await saveInterimPreEHAP2TestSystemSettings()
                                }
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Submit Results")
                                Spacer()
                                Image(systemName: "arrow.up.doc.fill")
                                Spacer()
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }
                        Spacer()
                    }
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                } else if interimPreEHAP2ResultsSubmitted == true && nowShowSubmission == true {
                    HStack{
                        Spacer()
                        NavigationLink {
                            EHATTSTestPart2View(ehaTesting: ehaTesting, relatedLinkEHATesting: linkEHATesting)
                        } label: {
                            HStack {
                                Spacer()
                                Text("Now Let's Continue!")
                                Spacer()
                                Image(systemName: "arrowshape.bounce.right")
                                Spacer()
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }
                        Spacer()
                    }
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                }
            }
        }
        Spacer()
        .onAppear {
            Task{
                audioSessionModel.setAudioSession()
                await checkInterimPreEHAP2TestVolume()
                await checkPreEHAP2MonoRightTestLink()
                await checkPreEHAP2MonoLeftTestLink()
                await preEHAP2MonoEarBetterExists()
                await comparedLastNameCSVReader()
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                Task {
                    await uploadPreEHAP2Data()
                }
            } else {
                print("Fatal error in uploadValue changeof Logic")
            }
        }
    }
}
    
extension EHAInterimPreEHAP2Content {
//MARK: -Methods Extension
    func checkInterimPreEHAP2TestVolume() async {
        volumeInterimPreEHAP2Test = audioSessionModel.audioSession.outputVolume
        finalInterimPreEHAP2SystemVolume.append(volumeInterimPreEHAP2Test)
        print("Volume Post Test: \(volumeInterimPreEHAP2Test)")
        print("setupDataModel finalEndingSystemVolume: \(finalInterimPreEHAP2SystemVolume)")
    }
    
    func recheckPreEHAP2SystemVolume() async {
        if audioSessionModel.audioSession.outputVolume == 0.63 {
            volumePreEHAP2Correct = 1
            preEHAP2LinkColorIndex = 1
            preEHAP2VolumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.60 && audioSessionModel.audioSession.outputVolume <= 0.655 {
            volumePreEHAP2Correct = 2
            preEHAP2LinkColorIndex = 2
            preEHAP2VolumeSettingIndex = 2
            volumePreEHAP2StartingTest = audioSessionModel.audioSession.outputVolume
            print(audioSessionModel.audioSession.outputVolume)
        } else {
            volumePreEHAP2Correct = 0
            preEHAP2LinkColorIndex = 0
            preEHAP2VolumeSettingIndex = 0
            volumePreEHAP2StartingTest = audioSessionModel.audioSession.outputVolume
        }
    }
    
    func recheckPreEHAP2SilentMode() async {
        if audioSessionModel.successfulStartToAudioSession == 1 {
            silentPreEHAP2ModeOff = 1
            silPreEHAP2LinkColorIndex = 1
            preEHAP2SilentModeSettingIndex = 1
            print("Silent Mode Likely Off .... aSM.successfulStartToAudioSession = 1, : \(audioSessionModel.successfulStartToAudioSession)")
        } else if audioSessionModel.successfulStartToAudioSession == 0 {
            silentPreEHAP2ModeOff = 0
            silPreEHAP2LinkColorIndex = 0
            silPreEHAP2LinkColorIndex = 0
            print("Silent Mode Likely Off ... aSM.successfulStartToAudioSession = 0, : \(audioSessionModel.successfulStartToAudioSession)")
        } else {
            print("!!!Error in preEHAP2M checkSilentModel Logic")
        }
    }
    
    func concantenateFinalPreEHAP2SystemVolumeArray() async {
        finalInterimPreEHAP2SystemVolume.append(volumePreEHAP2StartingTest)
        finalInterimPreEHAP2SilentMode.append(silentPreEHAP2ModeOff)
        interimPreEHAP2ResultsSubmitted = true
        print("preEHAP2M setupDataModel finalStartingSystemVolume: \(volumePreEHAP2StartingTest)")
    }
    
    func saveInterimPreEHAP2TestSystemSettings() async {
        await getInterimPreEHAP2Data()
        await saveSystemInterimPreEHAP2ToJSON()
        await writeSystemInterimPreEHAP2ResultsToCSV()
        await writeInputSystemInterimPreEHAP2ResultsToCSV()
        isOkayToUpload = true
    }
    
    func uploadPreEHAP2Data() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: "SystemSettingsInterimPreEHAP2.json")
            uploadFile(fileName: systemInterimPreEHAP2CSVName)
            uploadFile(fileName: inputSystemInterimPreEHAP2CSVName)
        }
    }
    
    //TODO: Code to calculate delta at each EPTA frequency between ears. If gain delta is <= 2.5 dB (either at every frequency or in average, maybe with focus on 4kHz range, then allow user to select best ear test only for EHA Part 2. After completing this assessment, if applicable, generate a trigger csv file called. monoRightEarBetter.csv or monoLeftEarBetter.csv. Then check for each of these files and if one exists, that triggers the ability to test in that ear (Right or left) only for EHAP2. If neither file exists, then mono test is not available.
    
    func preEHAP2MonoEarBetterExists() async {
        if preEHAP2MonoRightEarBetterExists == true && preEHAP2MonoLeftEarBetterExists == false {
            preEHAP2MonoEarTestingPan = 1.0
            print("preEHAP2MonoRightEarBetter Test Link Exists")
            print("preEHAP2MonoLeftEarBetter Test Link DOES NOT Exist")
            print("preEHAP2MonoEarTestingPan: \(preEHAP2MonoEarTestingPan)")
        } else if  preEHAP2MonoRightEarBetterExists == false && preEHAP2MonoLeftEarBetterExists == true {
            preEHAP2MonoEarTestingPan = -1.0
            print("preEHAP2MonoLeftEarBetter Test Link Exists")
            print("preEHAP2MonoRightEarBetter Test Link DOES NOT Exist")
            print("preEHAP2MonoEarTestingPan: \(preEHAP2MonoEarTestingPan)")
        } else if  preEHAP2MonoRightEarBetterExists == false && preEHAP2MonoLeftEarBetterExists == false {
            preEHAP2MonoEarTestingPan = Float()
            print("preEHAP2MonoRightEarBetter Test Link DOES NOT Exist")
            print("preEHAP2MonoLeftEarBetter Test Link DOES NOT Exist")
            print("preEHAP2MonoEarTestingPan: \(preEHAP2MonoEarTestingPan)")
        } else if  preEHAP2MonoRightEarBetterExists == true && preEHAP2MonoLeftEarBetterExists == true {
            preEHAP2MonoEarTestingPan = Float()
            print("!!!Critical Error, both Left and Right Mono Ear Link Files Exist")
            print("preEHAP2MonoRightEarBetter Test Link Exists")
            print("preEHAP2MonoLeftEarBetter Test Link Exists")
            print("preEHAP2MonoEarTestingPan: \(preEHAP2MonoEarTestingPan)")
        } else {
            preEHAP2MonoEarTestingPan = Float()
            print("No mono ear link file exists ")
            print("preEHAP2MonoEarTestingPan: \(preEHAP2MonoEarTestingPan)")
        }
    }
}
    
extension EHAInterimPreEHAP2Content {
//MARK: -CSV/JSON Extension
    func getPreEHAP2TestLinkPath() async -> String {
        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = testLinkPaths[0]
        return documentsDirectory
    }
    
    func checkPreEHAP2MonoRightTestLink() async {
        let preEHAP2MonoRightEarBetterName = ["preEHAP2MonoRightEarBetter.csv"]
        let fileManager = FileManager.default
        let preEHAP2MonoRightEarBetterPath = (await self.getPreEHAP2TestLinkPath() as NSString).strings(byAppendingPaths: preEHAP2MonoRightEarBetterName)
        if fileManager.fileExists(atPath: preEHAP2MonoRightEarBetterPath[0]) {
            let preEHAP2MonoRightEarBetterPath = URL(fileURLWithPath: preEHAP2MonoRightEarBetterPath[0])
            if preEHAP2MonoRightEarBetterPath.isFileURL  {
                preEHAP2MonoRightEarBetterExists = true
            } else {
                print("preEHAP2MonoRightEarBetter.csv Does Not Exist")
            }
        }
    }
    
    func checkPreEHAP2MonoLeftTestLink() async {
        let preEHAP2MonoLeftEarBetterName = ["preEHAP2MonoLeftEarBetter.csv"]
        let fileManager = FileManager.default
        let preEHAP2MonoLeftEarBetterPath = (await self.getPreEHAP2TestLinkPath() as NSString).strings(byAppendingPaths: preEHAP2MonoLeftEarBetterName)
        if fileManager.fileExists(atPath: preEHAP2MonoLeftEarBetterPath[0]) {
            let preEHAP2MonoLeftEarBetterPath = URL(fileURLWithPath: preEHAP2MonoLeftEarBetterPath[0])
            if preEHAP2MonoLeftEarBetterPath.isFileURL  {
                preEHAP2MonoLeftEarBetterExists = true
            } else {
                print("preEHAP2MonoLeftEarBetter.csv Does Not Exist")
            }
        }
    }
    
    func getInterimPreEHAP2Data() async {
        guard let systemSettingsInterimPreEHAP2Data = await getSystemInterimPreEHAP2JSONData() else { return }
        print("Json System Settings Interim Starting PreEHAP2 Data:")
        print(systemSettingsInterimPreEHAP2Data)
        let jsonSystemSettingsInterimPreEHAP2String = String(data: systemSettingsInterimPreEHAP2Data, encoding: .utf8)
        print(jsonSystemSettingsInterimPreEHAP2String!)
        do {
            self.saveSystemSettingsInterimPreEHAP2 = try JSONDecoder().decode(SaveSystemSettingsInterimPreEHAP2.self, from: systemSettingsInterimPreEHAP2Data)
            print("JSON Get System Interim PreEHAP2 Settings Run")
            print("data: \(systemSettingsInterimPreEHAP2Data)")
        } catch let error {
            print("!!!Error decoding system Settings Interim PreEHAP2 json data: \(error)")
        }
    }
    
    func getSystemInterimPreEHAP2JSONData() async -> Data? {
        let saveSystemSettingsInterimPreEHAP2 = SaveSystemSettingsInterimPreEHAP2 (
            jsonFinalInterimPreEHAP2SystemVolume: finalInterimPreEHAP2SystemVolume)
        let jsonSystemInterimPreEHAP2SettingsData = try? JSONEncoder().encode(saveSystemSettingsInterimPreEHAP2)
        print("saveFinalResults: \(saveSystemSettingsInterimPreEHAP2)")
        print("Json Encoded \(jsonSystemInterimPreEHAP2SettingsData!)")
        return jsonSystemInterimPreEHAP2SettingsData
    }
    
    func saveSystemInterimPreEHAP2ToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let systemInterimPreEHAP2Paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let interimPreEHAP2DocumentsDirectory = systemInterimPreEHAP2Paths[0]
        print("interimPreEHAP2DocumentsDirectory: \(interimPreEHAP2DocumentsDirectory)")
        let systemInterimPreEHAP2FilePaths = interimPreEHAP2DocumentsDirectory.appendingPathComponent(fileSystemInterimPreEHAP2Name[0])
        print(systemInterimPreEHAP2FilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemInterimPreEHAP2Data = try encoder.encode(saveSystemSettingsInterimPreEHAP2)
            print(jsonSystemInterimPreEHAP2Data)
            try jsonSystemInterimPreEHAP2Data.write(to: systemInterimPreEHAP2FilePaths)
        } catch {
            print("Error writing to JSON System Interim PreEHAP2 Settings file: \(error)")
        }
    }
    
    func writeSystemInterimPreEHAP2ResultsToCSV() async {
        print("writeSystemInterimPreEHAP2ResultsToCSV Start")
        let stringFinalInterimPreEHAP2SystemVolume = "finalInterimPreEHAP2SystemVolume," + finalInterimPreEHAP2SystemVolume.map { String($0) }.joined(separator: ",")
        let stringFinalInterimPreEHAP2SilentMode = "finalInterimPreEHAP2SilentMode," + finalInterimPreEHAP2SilentMode.map { String($0) }.joined(separator: "'")
        do {
            let csvSystemInterimPreEHAP2Path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemInterimPreEHAP2DocumentsDirectory = csvSystemInterimPreEHAP2Path
            print("CSV System Interim PreEHAP2 Settings DocumentsDirectory: \(csvSystemInterimPreEHAP2DocumentsDirectory)")
            let csvSystemInterimPreEHAP2FilePath = csvSystemInterimPreEHAP2DocumentsDirectory.appendingPathComponent(systemInterimPreEHAP2CSVName)
            print(csvSystemInterimPreEHAP2FilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemInterimPreEHAP2FilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimPreEHAP2SystemVolume])
            try writerSetup.write(row: [stringFinalInterimPreEHAP2SilentMode])
            print("CVS System PreEHAP2 Settings Writer Success")
        } catch {
            print("CVSWriter System PreEHAP2 Settings Error or Error Finding File for System PreEHAP2 Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemInterimPreEHAP2ResultsToCSV() async {
        print("writeInputSystemInterimPreEHAP2ResultsToCSV Start")
        
        let stringFinalInterimPreEHAP2SystemVolume = finalInterimPreEHAP2SystemVolume.map { String($0) }.joined(separator: ",")
        let stringFinalInterimPreEHAP2SilentMode = finalInterimPreEHAP2SilentMode.map { String($0) }.joined(separator: "'")
        do {
            let csvInputSystemInterimPreEHAP2Path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemInterimPreEHAP2DocumentsDirectory = csvInputSystemInterimPreEHAP2Path
            print("CSV Input System Interim PreEHAP2 Settings DocumentsDirectory: \(csvInputSystemInterimPreEHAP2DocumentsDirectory)")
            let csvInputSystemInterimPreEHAP2FilePath = csvInputSystemInterimPreEHAP2DocumentsDirectory.appendingPathComponent(inputSystemInterimPreEHAP2CSVName)
            print(csvInputSystemInterimPreEHAP2FilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemInterimPreEHAP2FilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimPreEHAP2SystemVolume])
            try writerSetup.write(row: [stringFinalInterimPreEHAP2SilentMode])
            print("CVS Input System Interim PreEHAP2 Settings Writer Success")
        } catch {
            print("CVSWriter Input System Interim PreEHAP2 Settings Error or Error Finding File for Input System PreEHAP2 Settings CSV \(error.localizedDescription)")
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

extension EHAInterimPreEHAP2Content {
//MARK: -NavigationLink Extension
    private func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
}

//struct EHAInterimPreEHAP2View_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAInterimPreEHAP2View(ehaTesting: nil, relatedLinkEHATesting: linkEHATesting)
//    }
//
//    static func linkEHATesting(ehaTesting: EHATesting) -> some View {
//        EmptyView()
//    }
//}
