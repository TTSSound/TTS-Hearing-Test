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

struct TestDeviceSetupView: View {
    

    //System Setup Variables
//    @Published var silentModeStatus = [Bool]()
//    @Published var doNotDisturbStatus = [Bool]()
//    @Published var systemVolumeStatus = [Bool]()
    
    @ObservedObject var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var systemSettingsModel: SystemSettingsModel = SystemSettingsModel()
    @State var volume = Float()
//    let timerThread = DispatchQueue(label: "TimerBackground", qos: .userInteractive)
    
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

//    init() { print(audioSessionModel.volume) }
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
// !!!! Figure out how to deinit audiosession and then reset on next screen !!!!!
                VStack{
                    HStack{
                        Text("System Volume is Set To: ")
                            .foregroundColor(.white)
                        Text(String(volume))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Is Volume Set Correctly?")
                            .foregroundColor(.white)
                        Text(volumeSettingString[volumeSettingIndex])
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding()
                    }
                    Text("Volume Is Set Correctly")
                        .foregroundColor(tdColors[tdLinkColorIndex])
                }
                Spacer()
                VStack{
                    HStack{
                        Text("Is Silent Mode Turned Off?")
                            .foregroundColor(.white)
                        Text(silentModeSettingString[silentModeSettingIndex])
                            .foregroundColor(.white)
                    }
                    Text("Silent Mode Is Off")
                        .foregroundColor(silColors[silLinkColorIndex])
                        .padding()
                 
                }
               
/// THIS    IS THE KEY TO GETTING IT TO REFRESH VALUE !!!!!!!!!!
                Button {
                    Task{
                        audioSessionModel.setAudioSession()
                        checkVolue()
                        checkSilentMode()
//                        audioSessionModel.cancelAudioSession()
                        
                        await concantenateFinalSystemVolumeArray()
                        await saveTestSystemSettings()
                    }
                } label: {
                    VStack{
                        Text(String(volume))
                        Text("Recheck Volume And System Settings")
                     
                        Text(String(audioSessionModel.successfulStartToAudioSession))
                        Text("Silent Mode Off Int: \(silentModeOff)")
                    }
                    
                }
                Spacer()
               
                // Below Works To Display Update from Button Above
                Text(String(audioSessionModel.audioSession.outputVolume))
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding()
                Spacer()
                


                
                NavigationLink(
                    destination: LandingView(),
//                    destination: TestIDInputView(),
                    label: {
                    Text("Continue to Return Home and Start The Hearing Test")
//                    Text("Continue to Start The Hearing Test")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)

                })
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
//                    audioSessionModel.cancelAudioSession()
                    await concantenateFinalSystemVolumeArray()
                    await saveTestSystemSettings()
                }
            }
        }
        .environmentObject(systemSettingsModel)
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
        systemSettingsModel.finalStartingSystemVolume.removeAll()
        systemSettingsModel.finalStartingSystemVolume.append(volume)
        print("systemSettingsModel finalStartingSystemVolume: \(volume)")
    }
    
    func saveTestSystemSettings() async {
        await systemSettingsModel.getSystemData()
        await systemSettingsModel.saveSystemToJSON()
        await systemSettingsModel.writeSystemResultsToCSV()
        await systemSettingsModel.writeInputSystemResultsToCSV()
    }
    
}


//struct TestDeviceSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestDeviceSetupView()
//            .environmentObject(SystemSettingsModel())
//    }
//}
