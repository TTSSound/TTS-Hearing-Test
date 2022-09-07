//
//  PostAllTestsSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostAllTestsSplashView: View {
    
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var systemSettingsEndEPTASimpleModel: SystemSettingsEndEPTASimpleModel =  SystemSettingsEndEPTASimpleModel()
    @StateObject var systemSettingsInterimEHAModel: SystemSettingsInterimEHAModel = SystemSettingsInterimEHAModel()
    @StateObject var audioSessionModel: AudioSessionModel = AudioSessionModel()
    
    @State var pavolume = Float()
    @State var pavolumeCorrect = Int()
    @State var pavolumeSettingIndex = Int()
    @State var paColors: [Color] = [Color.clear, Color.green, Color.yellow]
    @State var paLinkColorIndex = 0
    
    
    @State var ehaPostLinkExists = Bool()
    @State var eptaPostLinkExists = Bool()
    @State var simplePostLinkExists = Bool()
    @State var testTakenDirector = Int()

    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Post All Test Splash View To Direct To The Correct Results Screen or To EHA Interim Test Screen")
                    .foregroundColor(.white)
                Spacer()
                Button {
                    Task {
                        await checkPostEHATestLik()
                        await checkPostEPTATestLik()
                        await checkPostSimpleTestLik()
                        await returnPostTestSelected()
                        
                        // Get system volume?
                    }
                } label: {
                    Text("Check Test Selection")
                        .foregroundColor(.blue)
                }
                Spacer()
                
                NavigationLink(destination:
                                testTakenDirector == 1 ? AnyView(EHAInterimPostEPTAView())
                                : testTakenDirector == 2 ? AnyView(PostEPTATestView())
                                : testTakenDirector == 3 ? AnyView(PostSimpleTestView())
                                : AnyView(PostTestDirectorSplashView())
                ){
                    HStack{
                       Image(systemName: "arrowshape.bounce.right")
                            .foregroundColor(.green)
                       Text("Now Let's Contine!")
                            .foregroundColor(.green)
                   }
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
                }
            }
            
        }
       
    }
    
    func recheckVolue() {
        if audioSessionModel.audioSession.outputVolume == 0.63 {
            pavolumeCorrect = 1
            paLinkColorIndex = 1
            pavolumeSettingIndex = 1
        }
        if audioSessionModel.audioSession.outputVolume >= 0.619 && audioSessionModel.audioSession.outputVolume <= 0.626 {
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
        systemSettingsEndEPTASimpleModel.finalEndingSystemVolume.removeAll()
        systemSettingsEndEPTASimpleModel.finalEndingSystemVolume.append(pavolume)
        
        systemSettingsInterimEHAModel.finalInterimEndingEHASystemVolume.removeAll()
        systemSettingsInterimEHAModel.finalInterimEndingEHASystemVolume.append(pavolume)
        
        print("systemSettingsModel finalStartingSystemVolume: \(pavolume)")
        print("systemSettingsInterimEHAModel finalInterimEndingEHASystemVolume: \(pavolume)")
    }
    
    func saveTestSystemSettings() async {
        await systemSettingsEndEPTASimpleModel.getSystemEndData()
        await systemSettingsEndEPTASimpleModel.saveSystemEndToJSON()
        await systemSettingsEndEPTASimpleModel.writeSystemEndResultsToCSV()
        await systemSettingsEndEPTASimpleModel.writeInputSystemEndResultsToCSV()
    
        await systemSettingsInterimEHAModel.getInterimEndData()
        await systemSettingsInterimEHAModel.saveSystemInterimToJSON()
        await systemSettingsInterimEHAModel.writeSystemInterimResultsToCSV()
        await systemSettingsInterimEHAModel.writeInputSystemInterimResultsToCSV()
    }
}


//struct PostAllTestsSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostAllTestsSplashView()
//    }
//}
