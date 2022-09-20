//
//  DeviceSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/18/22.
//


// Test Setup of device after siri setup or manual setup
// This links after to UserDataEntryView

import Foundation
import AVFoundation
import AVFAudio
import AVKit
import SwiftUI
import CoreMedia
import MediaPlayer
import CodableCSV


struct SaveSystemSettings: Codable {  // This is a model
    var jsonFinalStartingSystemVolume = [Float]()

    enum CodingKeys: String, CodingKey {
        case jsonFinalStartingSystemVolume
    }
}

struct TestDeviceSetupView: View {
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var volume = Float()
    
    @State var volumeCorrect = Int()
    @State var silentModeOff = Int()
    @State var tdColors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var tdLinkColorIndex = 0
    @State var silColors: [Color] = [Color.clear, Color.green]
    @State var silLinkColorIndex = 0
    @State var volumeSettingString = ["No, Volume Is Not Set Correctly. Please Repeat Volume Setup", "Yes, Volume Is Set Perfectly", "Yes, Volume Is Set To Acceptable Range"]
    @State var volumeSettingIndex = Int()
    @State var silentModeSettingString = ["No, Silent Mode Is Not Off. Please Repeat Silent Mode Setup", "Yes, Silent Mode Is Off"]
    @State var silentModeSettingIndex = Int()

    
    @State var silentModeStatus = [Bool]()
    @State var doNotDisturbStatus = [Bool]()
    @State var systemVolumeStatus = [Bool]()
    @State var finalStartingSystemVolume: [Float] = [Float]()

    let fileSystemName = ["SystemSettings.json"]
    let systemCSVName = "SystemSettingsCSV.csv"
    let inputSystemCSVName = "InputSystemSettingsCSV.csv"
    
    @State var saveSystemSettings: SaveSystemSettings? = nil
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()

                VStack{
                    HStack{
                        Spacer()
                        Text("System Volume is Set To: ")
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(volume))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    HStack{
                        Spacer()
                        Text("Is Volume Set\nCorrectly?")
                            .foregroundColor(.white)
                        Spacer()
                        Text(volumeSettingString[volumeSettingIndex])
                            .foregroundColor(.white)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    Text("Volume Is Set\nCorrectly")
                        .foregroundColor(tdColors[tdLinkColorIndex])
                }
                Spacer()
                VStack{
                    HStack{
                        Text("Is Silent Mode\nTurned Off?")
                            .foregroundColor(.white)
                        Text(silentModeSettingString[silentModeSettingIndex])
                            .foregroundColor(.white)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    Text("Silent Mode\nIs Off")
                        .foregroundColor(silColors[silLinkColorIndex])
                        .padding()
                }
/// THIS    IS THE KEY TO GETTING IT TO REFRESH VALUE !!!!!!!!!!
                Button {
                    Task{
                        audioSessionModel.setAudioSession()
                        checkVolue()
                        checkSilentMode()
                        await concantenateFinalSystemVolumeArray()
                        await saveTestSystemSettings()
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("Recheck Volume And System Settings")
                        Spacer()
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                }
                Spacer()
                // Below Works To Display Update from Button Above
//                Text(String(audioSessionModel.audioSession.outputVolume))
//                    .foregroundColor(.white)
//                    .font(.caption)
//                    .padding()
                Spacer()
                if volumeCorrect >= 1 {
                    HStack{
                        Text("Return Home and Select The Testing Tab to Start The Hearing Test")
                            .padding(.leading)
                            .padding(.trailing)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.red)
                        //                    Text("Continue to Start The Hearing Test")
                    }
                } else {
                    HStack{
                        Text("Return Home and Select The Testing Tab to Start The Hearing Test")
                            .padding(.leading)
                            .padding(.trailing)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.clear)
                    }
                }


//                NavigationLink(
//                    destination: LandingView(),
////                    destination: TestIDInputView(),
//                    label: {
//                    Text("Continue to Return Home and Start The Hearing Test")
////                    Text("Continue to Start The Hearing Test")
//                        .fontWeight(.bold)
//                        .padding()
//                        .foregroundColor(.white)
//
//                })
//                .onTapGesture {
//                    Task(priority: .userInitiated, operation: {
//                        await concantenateFinalSystemVolumeArray()
//                        await saveTestSystemSettings()
//                    })
//                }
                Spacer()
            }
            .onAppear {
                Task{
                    audioSessionModel.setAudioSession()
                    checkVolue()
                    checkSilentMode()
                    await concantenateFinalSystemVolumeArray()
                    await saveTestSystemSettings()
                }
            }
        }
    }
    
    func checkVolue() {
        if audioSessionModel.audioSession.outputVolume == 0.63 {
            volumeCorrect = 1
            tdLinkColorIndex = 1
            volumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.60 && audioSessionModel.audioSession.outputVolume <= 0.626 {
            volumeCorrect = 2
            tdLinkColorIndex = 2
            volumeSettingIndex = 2
            volume = audioSessionModel.audioSession.outputVolume
            print(audioSessionModel.audioSession.outputVolume)
        } else {
            volumeCorrect = 0
            tdLinkColorIndex = 0
            volumeSettingIndex = 0
            volume = audioSessionModel.audioSession.outputVolume
        }
    }
    
    func checkSilentMode() {
        if audioSessionModel.successfulStartToAudioSession == 1 {
            silentModeOff = 1
            silLinkColorIndex = 1
            silentModeSettingIndex = 1
            print("Silent Mode Likely Off .... aSM.successfulStartToAudioSession = 1, : \(audioSessionModel.successfulStartToAudioSession)")
        } else if audioSessionModel.successfulStartToAudioSession == 0 {
            silentModeOff = 0
            silLinkColorIndex = 0
            silLinkColorIndex = 0
            print("Silent Mode Likely Off ... aSM.successfulStartToAudioSession = 0, : \(audioSessionModel.successfulStartToAudioSession)")
        } else {
            print("!!!Error in checkSilentModel Logic")
        }
    }
    
    func concantenateFinalSystemVolumeArray() async {
        finalStartingSystemVolume.removeAll()
        finalStartingSystemVolume.append(volume)
        print("finalStartingSystemVolume: \(volume)")
    }
    
    func saveTestSystemSettings() async {
        await getSystemData()
        await saveSystemToJSON()
        await writeSystemResultsToCSV()
        await writeInputSystemResultsToCSV()
    }
    
    
    func getSystemData() async {
        guard let systemSettingsData = await getSystemJSONData() else { return }
        print("Json System Settings Data:")
        print(systemSettingsData)
        let jsonSystemSettingsString = String(data: systemSettingsData, encoding: .utf8)
        print(jsonSystemSettingsString!)
        do {
        self.saveSystemSettings = try JSONDecoder().decode(SaveSystemSettings.self, from: systemSettingsData)
            print("JSON Get System Settings Run")
            print("data: \(systemSettingsData)")
        } catch let error {
            print("!!!Error decoding system Settings json data: \(error)")
        }
    }
    
    func getSystemJSONData() async -> Data? {
        let saveSystemSettings = SaveSystemSettings (
        jsonFinalStartingSystemVolume: finalStartingSystemVolume)
        let jsonSystemSettingsData = try? JSONEncoder().encode(saveSystemSettings)
        print("saveFinalResults: \(saveSystemSettings)")
        print("Json Encoded \(jsonSystemSettingsData!)")
        return jsonSystemSettingsData
    }
    
    func saveSystemToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let systemPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = systemPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let systemFilePaths = documentsDirectory.appendingPathComponent(fileSystemName[0])
        print(systemFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSystemData = try encoder.encode(saveSystemSettings)
            print(jsonSystemData)
          
            try jsonSystemData.write(to: systemFilePaths)
        } catch {
            print("Error writing to JSON System Settings file: \(error)")
        }
    }

    func writeSystemResultsToCSV() async {
        print("writeSystemResultsToCSV Start")
        let stringFinalStartingSystemVolume = "finalStartingSystemVolume," + finalStartingSystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvSystemPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSystemDocumentsDirectory = csvSystemPath
            print("CSV System Settings DocumentsDirectory: \(csvSystemDocumentsDirectory)")
            let csvSystemFilePath = csvSystemDocumentsDirectory.appendingPathComponent(systemCSVName)
            print(csvSystemFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSystemFilePath, append: false)
            try writerSetup.write(row: [stringFinalStartingSystemVolume])
            print("CVS System Settings Writer Success")
        } catch {
            print("CVSWriter System Settings Error or Error Finding File for System Settings CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSystemResultsToCSV() async {
        print("writeInputSystemResultsToCSV Start")
        let stringFinalStartingSystemVolume = finalStartingSystemVolume.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSystemPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSystemDocumentsDirectory = csvInputSystemPath
            print("CSV Input System Settings DocumentsDirectory: \(csvInputSystemDocumentsDirectory)")
            let csvInputSystemFilePath = csvInputSystemDocumentsDirectory.appendingPathComponent(inputSystemCSVName)
            print(csvInputSystemFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSystemFilePath, append: false)
            try writerSetup.write(row: [stringFinalStartingSystemVolume])
            print("CVS Input System Settings Writer Success")
        } catch {
            print("CVSWriter Input System Settings Error or Error Finding File for Input System Settings CSV \(error.localizedDescription)")
        }
    }
}


//struct TestDeviceSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestDeviceSetupView()
//    }
//}
