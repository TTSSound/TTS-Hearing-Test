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


struct PostEHATestView_Previews: PreviewProvider {
    static var previews: some View {
        PostEHATestView(ehaTesting: nil, relatedLinkEHATesting: linkEHATesting)
    }
    
    static func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
}
