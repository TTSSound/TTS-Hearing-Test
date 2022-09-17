//
//  PostTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostEPTATestView: View {
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()

    @State var volumeEPTAPostTest = Float()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("View for Completion of EPTA Test")
                    .foregroundColor(.white)
                Spacer()
                Text("Great Work!")
                    .foregroundColor(.white)
                Spacer()
                Text("Give Us A Moment To Calculate and Format Your Results")
                    .foregroundColor(.white)
                Spacer()
                NavigationLink {
                    EPTAResultsDisplayView()
                } label: {
                    Text("Continue To See Results")
                        .foregroundColor(.green)
                }
                Spacer()
            }
        }
        .onAppear {
            Task(priority: .userInitiated, operation: {
                audioSessionModel.setAudioSession()
                await checkEPTAPostTestVolume()
                await savePostEPTASettings()
            })
        }
//        .environmentObject(systemSettingsModel)
    }
    
    func checkEPTAPostTestVolume() async {
//        volumeEPTAPostTest = audioSessionModel.audioSession.outputVolume
//        systemSettingsModel.finalEndingSystemVolume.append(volumeEPTAPostTest)
//        print("Volume Post Test: \(volumeEPTAPostTest)")
//        print("systemSettingsModel finalEndingSystemVolume: \(systemSettingsModel.finalEndingSystemVolume)")
    }
    
    func savePostEPTASettings() async {
//        await systemSettingsModel.getSystemData()
//        await systemSettingsModel.saveSystemToJSON()
//        await systemSettingsModel.writeSystemResultsToCSV()
    }
}

//struct PostTestView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        PostEPTATestView()
//    }
//}
