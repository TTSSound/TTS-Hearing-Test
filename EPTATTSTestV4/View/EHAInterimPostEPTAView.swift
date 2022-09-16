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
    
    @State var monoRightEarBetterExists = Bool()
    @State var monoLeftEarBetterExists = Bool()
    @State var monoEarTestingPan = Float()
    
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("View for EHA test takers after they have completed the EPTA test")
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
                            .foregroundColor(.green)
                            .font(.title)
                        }
                    Spacer()
                    }
                .padding(.all)
            
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
                .padding(.all)
                
                
                VStack{
                    HStack{
                        Text("System Volume is Set To: ")
                            .foregroundColor(.white)
                        Text(String(volumeEHAStartingTest))
                            .foregroundColor(.white)
                    }
                    .padding(.all)
                    HStack{
                        Text("Is Volume Set Correctly?")
                            .foregroundColor(.white)
                        Text(ehaVolumeSettingString[ehaVolumeSettingIndex])
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding()
                    }
                    .padding(.all)
                    Text("Volume Is Set Correctly")
                        .foregroundColor(ehaColors[ehaLinkColorIndex])
                        .padding(.all)
                }
       
                VStack{
                    HStack{
                        Text("Is Silent Mode Turned Off?")
                            .foregroundColor(.white)
                        Text(ehaSilentModeSettingString[ehaSilentModeSettingIndex])
                            .foregroundColor(.white)
                    }
                    .padding(.all)
                    HStack{
                        Text("Silent Mode Is Off")
                            .foregroundColor(silEHAColors[silEHALinkColorIndex])
                            .padding()
                        Text("Silent Mode Off Int: \(silentEHAModeOff)")
                    }
                    .padding(.all)
                }
                
                HStack{
                    Button {
                        DispatchQueue.main.async {
                            Task{
                                await concantenateFinalEHASystemVolumeArray()
                                await saveInterimEHATestSystemSettings()
                            }
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
        Spacer()
        .onAppear {
            Task{
                audioSessionModel.setAudioSession()
                await checkInterimEHATestVolume()
                await checkMonoRightTestLink()
                await checkMonoLeftTestLink()
                await monoEarBetterExists()
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
        if audioSessionModel.audioSession.outputVolume >= 0.60 && audioSessionModel.audioSession.outputVolume <= 0.626 {
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
}

//struct EHAPostEPTAView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAPostEPTAView()
//    }
//}
