//
//  EHAPostEPTAView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/23/22.
//

import SwiftUI
import CodableCSV
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase

struct SaveSystemSettingsInterimStartEHA: Codable {
    var jsonFinalInterimStartingEHASystemVolume = [Float]()
    var jsonFinalInterimStartingEHASilentMode = Int()

    enum CodingKeys: String, CodingKey {
        case jsonFinalInterimStartingEHASystemVolume
        case jsonFinalInterimStartingEHASilentMode
    }
}


struct EHAInterimPostEPTAView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            EHAInterimPostEPTAContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading EHAInterimPostEPTA View")
                .navigationTitle("")
        }
    }
}


struct EHAInterimPostEPTAContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var volumeInterimEHATest = Float()
    @State var volumeEHAStartingTest = Float()
    
    @State var volumeEHACorrect = Int()
    @State var silentEHAModeOff = Int()
    @State var ehaColors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var ehaLinkColorIndex = 0
    @State var silEHAColors: [Color] = [Color.clear, Color.green]
    @State var silEHALinkColorIndex = 0
    @State var ehaVolumeSettingString = ["No", "Yes", "Acceptable"]
    @State var ehaVolumeSettingIndex = Int()
    @State var ehaSilentModeSettingString = ["No", "Yes"]
    @State var ehaSilentModeSettingIndex = Int()
    
    @State var monoRightEarBetterExists = Bool()
    @State var monoLeftEarBetterExists = Bool()
    @State var monoEarTestingPan = Float()
    
    @State var interimEHAResultsSubmitted: Bool = false
    
    @State var finalInterimStartingEHASystemVolume: [Float] = [Float]()
    @State var finalInterimStartingEHASilentMode: [Int] = [Int]()
    
    let fileSystemInterimStartingEHAName = ["SystemSettingsInterimStartingEHA.json"]
    let systemInterimStartingEHACSVName = "SystemSettingsInterimStartingEHACSV.csv"
    let inputSystemInterimStartingEHACSVName = "InputSystemSettingsInterimStartingEHACSV.csv"
    
    @State var saveSystemSettingsInterimStartEHA: SaveSystemSettingsInterimStartEHA? = nil
    
    var body: some View {
        ZStack{
            Image("Background1 1").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all, edges: .top)
            //colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading) {
                Text("View for EHA test takers after they have completed the EPTA test. The extended phase of the hearing assessment is next.")
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
                            await recheckEHASystemVolume()
                            await recheckEHASilentMode()
                        }
                    } label: {
                        Text("Recheck Settings Now")
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.266666666666667, green: 0.043137254901961, blue: 0.843137254901961)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                            .foregroundColor(.white)
                            .cornerRadius(300)
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    Text(String(volumeEHAStartingTest))
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
                    Text(String(volumeEHAStartingTest))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                HStack{
                    Spacer()
                    Text("Is Volume Correct?")
                        .foregroundColor(.white)
                    Spacer()
                    Text(ehaVolumeSettingString[ehaVolumeSettingIndex])
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                HStack{
                    Spacer()
                    Text("Silent Mode Is Off?")
                        .foregroundColor(.white)
                    Spacer()
                    Text(ehaSilentModeSettingString[ehaSilentModeSettingIndex])
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.trailing)
                if interimEHAResultsSubmitted == false {
                    HStack{
                        Spacer()
                        Button {
                            DispatchQueue.main.async {
                                Task{
                                    await concantenateFinalEHASystemVolumeArray()
                                    await saveInterimEHATestSystemSettings()
                                }
                            }
                        } label: {
                            Text("Submit Results")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                                .foregroundColor(.white)
                                .cornerRadius(300)
                        }
                        Spacer()
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 20)
                } else if interimEHAResultsSubmitted == true {
                    HStack{
                        Spacer()
                        Text("Return Home To Enable and Access The Second Test Phase")
                            .padding()
                            .foregroundColor(.red)
                            .font(.title)
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
                await checkInterimEHATestVolume()
                await checkMonoRightTestLink()
                await checkMonoLeftTestLink()
                await monoEarBetterExists()
                await comparedLastNameCSVReader()
            }
        }
        .onChange(of: isOkayToUpload) { uploadValue in
            if uploadValue == true {
                Task {
                    await uploadEHAP1InterimPostSettings()
                }
            } else {
                print("Fatal Error in uploadValue Change Of Logic")
            }
        }
    }
}
 
extension EHAInterimPostEPTAContent {
//MARK: -Methods Extension
    func checkInterimEHATestVolume() async {
        volumeInterimEHATest = audioSessionModel.audioSession.outputVolume
        finalInterimStartingEHASystemVolume.append(volumeInterimEHATest)
        print("Volume Post Test: \(volumeInterimEHATest)")
        print("setupDataModel finalEndingSystemVolume: \(finalInterimStartingEHASystemVolume)")
    }
    
    func recheckEHASystemVolume() async {
        if audioSessionModel.audioSession.outputVolume == 1.0 {
            volumeEHACorrect = 1
            ehaLinkColorIndex = 1
            ehaVolumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.98 && audioSessionModel.audioSession.outputVolume <= 1.0 {
            volumeEHACorrect = 2
            ehaLinkColorIndex = 2
            ehaVolumeSettingIndex = 2
            volumeEHAStartingTest = audioSessionModel.audioSession.outputVolume
            print(audioSessionModel.audioSession.outputVolume)
        } else {
            volumeEHACorrect = 0
            ehaLinkColorIndex = 0
            ehaVolumeSettingIndex = 0
            volumeEHAStartingTest = audioSessionModel.audioSession.outputVolume
        }
    }
    
    func recheckEHASilentMode() async {
        if audioSessionModel.successfulStartToAudioSession == 1 {
            silentEHAModeOff = 1
            silEHALinkColorIndex = 1
            ehaSilentModeSettingIndex = 1
            print("Silent Mode Likely Off .... aSM.successfulStartToAudioSession = 1, : \(audioSessionModel.successfulStartToAudioSession)")
        } else if audioSessionModel.successfulStartToAudioSession == 0 {
            silentEHAModeOff = 0
            silEHALinkColorIndex = 0
            silEHALinkColorIndex = 0
            print("Silent Mode Likely Off ... aSM.successfulStartToAudioSession = 0, : \(audioSessionModel.successfulStartToAudioSession)")
        } else {
            print("!!!Error in checkSilentModel Logic")
        }
    }
    
    func concantenateFinalEHASystemVolumeArray() async {
        finalInterimStartingEHASystemVolume.append(volumeEHAStartingTest)
        finalInterimStartingEHASilentMode.append(silentEHAModeOff)
        interimEHAResultsSubmitted = true
        print("setupDataModel finalStartingSystemVolume: \(volumeEHAStartingTest)")
    }
    
    func saveInterimEHATestSystemSettings() async {
        await getInterimStartingEHAData()
        await saveSystemInterimStartingEHAToJSON()
        await writeSystemInterimStartingEHAResultsToCSV()
        await writeInputSystemInterimStartingEHAResultsToCSV()
        isOkayToUpload = true
    }
    
    //TODO: Code to calculate delta at each EPTA frequency between ears. If gain delta is <= 2.5 dB (either at every frequency or in average, maybe with focus on 4kHz range, then allow user to select best ear test only for EHA Part 2. After completing this assessment, if applicable, generate a trigger csv file called. monoRightEarBetter.csv or monoLeftEarBetter.csv. Then check for each of these files and if one exists, that triggers the ability to test in that ear (Right or left) only for EHAP2. If neither file exists, then mono test is not available.
    
    func monoEarBetterExists() async {
        if monoRightEarBetterExists == true && monoLeftEarBetterExists == false {
            monoEarTestingPan = 1.0
            print("monoRightEarBetter Test Link Exists")
            print("monoLeftEarBetter Test Link DOES NOT Exist")
            print("monoEarTestingPan: \(monoEarTestingPan)")
        } else if  monoRightEarBetterExists == false && monoLeftEarBetterExists == true {
            monoEarTestingPan = -1.0
            print("monoLeftEarBetter Test Link Exists")
            print("monoRightEarBetter Test Link DOES NOT Exist")
            print("monoEarTestingPan: \(monoEarTestingPan)")
        } else if  monoRightEarBetterExists == false && monoLeftEarBetterExists == false {
            monoEarTestingPan = Float()
            print("monoRightEarBetter Test Link DOES NOT Exist")
            print("monoLeftEarBetter Test Link DOES NOT Exist")
            print("monoEarTestingPan: \(monoEarTestingPan)")
        } else if  monoRightEarBetterExists == true && monoLeftEarBetterExists == true {
            monoEarTestingPan = Float()
            print("!!!Critical Error, both Left and Right Mono Ear Link Files Exist")
            print("monoRightEarBetter Test Link Exists")
            print("monoLeftEarBetter Test Link Exists")
            print("monoEarTestingPan: \(monoEarTestingPan)")
        } else {
            monoEarTestingPan = Float()
            print("No mono ear link file exists ")
            print("monoEarTestingPan: \(monoEarTestingPan)")
        }
    }
    
    func getTestLinkPath() async -> String {
        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = testLinkPaths[0]
        return documentsDirectory
    }

    func checkMonoRightTestLink() async {
        let monoRightEarBetterName = ["monoRightEarBetter.csv"]
        let fileManager = FileManager.default
        let monoRightEarBetterPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: monoRightEarBetterName)
        if fileManager.fileExists(atPath: monoRightEarBetterPath[0]) {
            let monoRightEarBetterPath = URL(fileURLWithPath: monoRightEarBetterPath[0])
            if monoRightEarBetterPath.isFileURL  {
                monoRightEarBetterExists = true
            } else {
                print("monoRightEarBetter.csv Does Not Exist")
            }
        }
    }
    
    func checkMonoLeftTestLink() async {
        let monoLeftEarBetterName = ["monoLeftEarBetter.csv"]
        let fileManager = FileManager.default
        let monoLeftEarBetterPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: monoLeftEarBetterName)
        if fileManager.fileExists(atPath: monoLeftEarBetterPath[0]) {
            let monoLeftEarBetterPath = URL(fileURLWithPath: monoLeftEarBetterPath[0])
            if monoLeftEarBetterPath.isFileURL  {
                monoLeftEarBetterExists = true
            } else {
                print("monoLeftEarBetter.csv Does Not Exist")
            }
        }
    }
    
    func uploadEHAP1InterimPostSettings() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: "SystemSettingsInterimStartingEHA.json")
            uploadFile(fileName: systemInterimStartingEHACSVName)
            uploadFile(fileName: inputSystemInterimStartingEHACSVName)
        }
    }
}


extension EHAInterimPostEPTAContent {
//MARK: -CSV/JSON Extension
    func getInterimStartingEHAData() async {
        guard let systemSettingsInterimStartingEHAData = await getSystemInterimStartingEHAJSONData() else { return }
        print("Json System Settings Interim Starting EHA Data:")
        print(systemSettingsInterimStartingEHAData)
        let jsonSystemSettingsInterimStartingEHAString = String(data: systemSettingsInterimStartingEHAData, encoding: .utf8)
        print(jsonSystemSettingsInterimStartingEHAString!)
        do {
            self.saveSystemSettingsInterimStartEHA = try JSONDecoder().decode(SaveSystemSettingsInterimStartEHA.self, from: systemSettingsInterimStartingEHAData)
            print("JSON Get System Interim Starting EHA Settings Run")
            print("data: \(systemSettingsInterimStartingEHAData)")
        } catch let error {
            print("!!!Error decoding system Settings Interim Starting EHA json data: \(error)")
        }
    }
    
    func getSystemInterimStartingEHAJSONData() async -> Data? {
        let saveSystemSettingsInterimStartEHA = SaveSystemSettingsInterimStartEHA (
            jsonFinalInterimStartingEHASystemVolume: finalInterimStartingEHASystemVolume)
        let jsonSystemInterimStartingEHASettingsData = try? JSONEncoder().encode(saveSystemSettingsInterimStartEHA)
        print("saveFinalResults: \(saveSystemSettingsInterimStartEHA)")
        print("Json Encoded \(jsonSystemInterimStartingEHASettingsData!)")
        return jsonSystemInterimStartingEHASettingsData
    }
    
    func saveSystemInterimStartingEHAToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let systemInterimStartingEHAPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let interimStartingEHADocumentsDirectory = systemInterimStartingEHAPaths[0]
        print("interimStartingEHADocumentsDirectory: \(interimStartingEHADocumentsDirectory)")
        let systemInterimStartingEHAFilePaths = interimStartingEHADocumentsDirectory.appendingPathComponent(fileSystemInterimStartingEHAName[0])
        print(systemInterimStartingEHAFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemInterimStartingEHAData = try encoder.encode(saveSystemSettingsInterimStartEHA)
            print(jsonSystemInterimStartingEHAData)
            try jsonSystemInterimStartingEHAData.write(to: systemInterimStartingEHAFilePaths)
        } catch {
            print("Error writing to JSON System Interim Starting EHA Settings file: \(error)")
        }
    }
    
    func writeSystemInterimStartingEHAResultsToCSV() async {
        print("writeSystemInterimStartingEHAResultsToCSV Start")
        let stringFinalInterimStartingEHASystemVolume = "finalInterimStartingEHASystemVolume," + finalInterimStartingEHASystemVolume.map { String($0) }.joined(separator: ",")
        let stringFinalInterimStartingEHASilentMode = "finalInterimStartingEHASilentMode," + finalInterimStartingEHASilentMode.map { String($0) }.joined(separator: "'")
        do {
            let csvSystemInterimStartingEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemInterimStartingEHADocumentsDirectory = csvSystemInterimStartingEHAPath
            print("CSV System Interim Starting EHA Settings DocumentsDirectory: \(csvSystemInterimStartingEHADocumentsDirectory)")
            let csvSystemInterimStartingEHAFilePath = csvSystemInterimStartingEHADocumentsDirectory.appendingPathComponent(systemInterimStartingEHACSVName)
            print(csvSystemInterimStartingEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemInterimStartingEHAFilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimStartingEHASystemVolume])
            try writerSetup.write(row: [stringFinalInterimStartingEHASilentMode])
            print("CVS System Starting EHA Settings Writer Success")
        } catch {
            print("CVSWriter System Starting EHA Settings Error or Error Finding File for System Starting EHA Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemInterimStartingEHAResultsToCSV() async {
        print("writeInputSystemInterimStartingEHAResultsToCSV Start")
        
        let stringFinalInterimStartingEHASystemVolume = finalInterimStartingEHASystemVolume.map { String($0) }.joined(separator: ",")
        let stringFinalInterimStartingEHASilentMode = finalInterimStartingEHASilentMode.map { String($0) }.joined(separator: "'")
        do {
            let csvInputSystemInterimStartingEHAPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemInterimStartingEHADocumentsDirectory = csvInputSystemInterimStartingEHAPath
            print("CSV Input System Interim Starting EHA Settings DocumentsDirectory: \(csvInputSystemInterimStartingEHADocumentsDirectory)")
            let csvInputSystemInterimStartingEHAFilePath = csvInputSystemInterimStartingEHADocumentsDirectory.appendingPathComponent(inputSystemInterimStartingEHACSVName)
            print(csvInputSystemInterimStartingEHAFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemInterimStartingEHAFilePath, append: false)
            try writerSetup.write(row: [stringFinalInterimStartingEHASystemVolume])
            try writerSetup.write(row: [stringFinalInterimStartingEHASilentMode])
            print("CVS Input System Interim Starting EHA Settings Writer Success")
        } catch {
            print("CVSWriter Input System Interim Starting EHA Settings Error or Error Finding File for Input System Starting EHA Settings CSV \(error.localizedDescription)")
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
 
extension EHAInterimPostEPTAContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

//struct EHAInterimPostEPTAView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAInterimPostEPTAView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
