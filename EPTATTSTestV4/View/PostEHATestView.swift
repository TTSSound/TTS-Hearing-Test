//
//  PostEHATestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI


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
    var colorModel: ColorModel = ColorModel()
    @StateObject var systemSettingsEndEHAModel: SystemSettingsEndEHAModel = SystemSettingsEndEHAModel()
    @State var volumeEHAPostTest = Float()
    
    //    @State var monoRightEarBetterExists = Bool()
    //    @State var monoLeftEarBetterExists = Bool()
    //    @State var monoEarTestingPan = Float()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                
                Text("View for Completion of EHA Full Test")
                    .foregroundColor(.white)
                    .padding(.top,40)
                    .padding(.bottom, 20)
                Spacer()
                Text("Great Work!")
                    .foregroundColor(.white)
                Spacer()
                Text("Give Us A Moment To Calculate and Format Your Results")
                    .foregroundColor(.white)
                Spacer()

                Text("Return Home to Navigate To Results")
                    .font(.title)
                    .foregroundColor(.red)
                }
                Spacer()
            }
            .onAppear {
                Task{
                    audioSessionModel.setAudioSession()
                    await checkEHAPostTestVolume()
                    await savePostEHATestSystemSettings()
                    //                await checkMonoRightTestLink()
                    //                await checkMonoLeftTestLink()
                    //                await monoEarBetterExists()
                    
                }
            }
        
    }
    
    func checkEHAPostTestVolume() async {
        volumeEHAPostTest = audioSessionModel.audioSession.outputVolume
        systemSettingsEndEHAModel.finalEndingEHASystemVolume.append(volumeEHAPostTest)
        print("EHA Volume Post Test: \(volumeEHAPostTest)")
        print("setupDataModel finalEndingEHASystemVolume: \(systemSettingsEndEHAModel.finalEndingEHASystemVolume)")
    }
    
    func savePostEHATestSystemSettings() async {
        await systemSettingsEndEHAModel.getSystemEndEHAData()
        await systemSettingsEndEHAModel.saveSystemEndEHAToJSON()
        await systemSettingsEndEHAModel.writeSystemEndEHAResultsToCSV()
        await systemSettingsEndEHAModel.writeInputSystemEndEHAResultsToCSV()
    }
 
    private func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
    
}
//    //TODO: Code to calculate delta at each EPTA frequency between ears. If gain delta is <= 2.5 dB (either at every frequency or in average, maybe with focus on 4kHz range, then allow user to select best ear test only for EHA Part 2. After completing this assessment, if applicable, generate a trigger csv file called. monoRightEarBetter.csv or monoLeftEarBetter.csv. Then check for each of these files and if one exists, that triggers the ability to test in that ear (Right or left) only for EHAP2. If neither file exists, then mono test is not available.
//    
//    func monoEarBetterExists() async {
//        if monoRightEarBetterExists == true && monoLeftEarBetterExists == false {
//            monoEarTestingPan = 1.0
//            print("monoRightEarBetter Test Link Exists")
//            print("monoLeftEarBetter Test Link DOES NOT Exist")
//            print("monoEarTestingPan: \(monoEarTestingPan)")
//        } else if  monoRightEarBetterExists == false && monoLeftEarBetterExists == true {
//            monoEarTestingPan = -1.0
//            print("monoLeftEarBetter Test Link Exists")
//            print("monoRightEarBetter Test Link DOES NOT Exist")
//            print("monoEarTestingPan: \(monoEarTestingPan)")
//        } else if  monoRightEarBetterExists == false && monoLeftEarBetterExists == false {
//            monoEarTestingPan = Float()
//            print("monoRightEarBetter Test Link DOES NOT Exist")
//            print("monoLeftEarBetter Test Link DOES NOT Exist")
//            print("monoEarTestingPan: \(monoEarTestingPan)")
//        } else if  monoRightEarBetterExists == true && monoLeftEarBetterExists == true {
//            monoEarTestingPan = Float()
//            print("!!!Critical Error, both Left and Right Mono Ear Link Files Exist")
//            print("monoRightEarBetter Test Link Exists")
//            print("monoLeftEarBetter Test Link Exists")
//            print("monoEarTestingPan: \(monoEarTestingPan)")
//        } else {
//            monoEarTestingPan = Float()
//            print("No mono ear link file exists ")
//            print("monoEarTestingPan: \(monoEarTestingPan)")
//        }
//    }
//    
//    func getTestLinkPath() async -> String {
//        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = testLinkPaths[0]
//        return documentsDirectory
//    }
//
//    func checkMonoRightTestLink() async {
//        let monoRightEarBetterName = ["monoRightEarBetter.csv"]
//        let fileManager = FileManager.default
//        let monoRightEarBetterPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: monoRightEarBetterName)
//        if fileManager.fileExists(atPath: monoRightEarBetterPath[0]) {
//            let monoRightEarBetterPath = URL(fileURLWithPath: monoRightEarBetterPath[0])
//            if monoRightEarBetterPath.isFileURL  {
//                monoRightEarBetterExists = true
//            } else {
//                print("monoRightEarBetter.csv Does Not Exist")
//            }
//        }
//    }
//    
//    func checkMonoLeftTestLink() async {
//        let monoLeftEarBetterName = ["monoLeftEarBetter.csv"]
//        let fileManager = FileManager.default
//        let monoLeftEarBetterPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: monoLeftEarBetterName)
//        if fileManager.fileExists(atPath: monoLeftEarBetterPath[0]) {
//            let monoLeftEarBetterPath = URL(fileURLWithPath: monoLeftEarBetterPath[0])
//            if monoLeftEarBetterPath.isFileURL  {
//                monoLeftEarBetterExists = true
//            } else {
//                print("monoLeftEarBetter.csv Does Not Exist")
//            }
//        }
//    }
//
//}

struct PostEHATestView_Previews: PreviewProvider {
    static var previews: some View {
        PostEHATestView(ehaTesting: nil, relatedLinkEHATesting: linkEHATesting)
    }
    
    static func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
}
