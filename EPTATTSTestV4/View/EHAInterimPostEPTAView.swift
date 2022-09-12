//
//  EHAPostEPTAView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/23/22.
//

import SwiftUI

struct EHAInterimPostEPTAView: View {
    
    @ObservedObject var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var systemSettingsInterimStartEHAModel: SystemSettingsInterimStartEHAModel = SystemSettingsInterimStartEHAModel()
    @State var volumeInterimEHATest = Float()
    @State var volumeEHAStartingTest = Float()
    
    @State var volumeEHACorrect = Int()
    @State var silentEHAModeOff = Int()
    @State var ehaColors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var ehaLinkColorIndex = 0
    @State var silEHAColors: [Color] = [Color.clear, Color.green]
    @State var silEHALinkColorIndex = 0
    @State var ehaVolumeSettingString = ["No, Volume Is Not Set Correctly. Please Repeat Volume Setup", "Yes, Volume Is Set Perfectly", "Yes, Volume Is Set To Acceptable Range"]
    @State var ehaVolumeSettingIndex = Int()
    @State var ehaSilentModeSettingString = ["No, Silent Mode Is Not Off. Please Repeat Silent Mode Setup", "Yes, Silent Mode Is Off"]
    @State var ehaSilentModeSettingIndex = Int()
    
    
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("View for EHA test takers after they have completed the EPTA test")
                    .foregroundColor(.white)
                Text("Great Work!")
                    .foregroundColor(.white)
                Text("Let's take a moment for a break")
                    .foregroundColor(.white)
                
                HStack{
                    Spacer()
                    Button {
                        Task{
                            audioSessionModel.setAudioSession()
                            await recheckEHASystemVolume()
                            await recheckEHASilentMode()
    //                        audioSessionModel.cancelAudioSession()
                        }
                    } label: {
                            Text("Recheck Settings Before Proceeding")
                            .foregroundColor(.red)
                        }
                    Spacer()
                    }
            
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
                
                
                
                VStack{
                    HStack{
                        Text("System Volume is Set To: ")
                            .foregroundColor(.white)
                        Text(String(volumeEHAStartingTest))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Is Volume Set Correctly?")
                            .foregroundColor(.white)
                        Text(ehaVolumeSettingString[ehaVolumeSettingIndex])
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding()
                    }
                    Text("Volume Is Set Correctly")
                        .foregroundColor(ehaColors[ehaLinkColorIndex])
                }
       
                VStack{
                    HStack{
                        Text("Is Silent Mode Turned Off?")
                            .foregroundColor(.white)
                        Text(ehaSilentModeSettingString[ehaSilentModeSettingIndex])
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Silent Mode Is Off")
                            .foregroundColor(silEHAColors[silEHALinkColorIndex])
                            .padding()
                        Text("Silent Mode Off Int: \(silentEHAModeOff)")
                    }
                }
                
                HStack{
                    Button {
                        Task{
                            await concantenateFinalEHASystemVolumeArray()
                            await saveInterimEHATestSystemSettings()
                        }
                    } label: {
                        Text("Submit Results")
                            .foregroundColor(.green)
                    }

                }
                    NavigationLink {
                        EHATTSTestPart2View()
                    } label: {
                        Text("Continue To Start the extended phase of the hearing assessment")
                            .foregroundColor(.green)
                    }
                }
            }
        .onAppear {
            Task{
                audioSessionModel.setAudioSession()
                await checkInterimEHATestVolume()
            }
        }
    }
    
    func checkInterimEHATestVolume() async {
        volumeInterimEHATest = audioSessionModel.audioSession.outputVolume
        systemSettingsInterimStartEHAModel.finalInterimStartingEHASystemVolume.append(volumeInterimEHATest)
        print("Volume Post Test: \(volumeInterimEHATest)")
        print("setupDataModel finalEndingSystemVolume: \(systemSettingsInterimStartEHAModel.finalInterimStartingEHASystemVolume)")
    }
    
    func recheckEHASystemVolume() async {
        if audioSessionModel.audioSession.outputVolume == 0.63 {
            volumeEHACorrect = 1
            ehaLinkColorIndex = 1
            ehaVolumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.619 && audioSessionModel.audioSession.outputVolume <= 0.626 {
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
        systemSettingsInterimStartEHAModel.finalInterimStartingEHASystemVolume.append(volumeEHAStartingTest)
        systemSettingsInterimStartEHAModel.finalInterimStartingEHASilentMode.append(silentEHAModeOff)
        print("setupDataModel finalStartingSystemVolume: \(volumeEHAStartingTest)")
    }
    
    func saveInterimEHATestSystemSettings() async {
        await systemSettingsInterimStartEHAModel.getInterimStartingEHAData()
        await systemSettingsInterimStartEHAModel.saveSystemInterimStartingEHAToJSON()
        await systemSettingsInterimStartEHAModel.writeSystemInterimStartingEHAResultsToCSV()
        await systemSettingsInterimStartEHAModel.writeInputSystemInterimStartingEHAResultsToCSV()
    }
}

//struct EHAPostEPTAView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAPostEPTAView()
//    }
//}
