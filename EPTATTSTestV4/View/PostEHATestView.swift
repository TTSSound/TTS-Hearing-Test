//
//  PostEHATestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostEHATestView: View {
    @ObservedObject var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var systemSettingsEndEHAModel: SystemSettingsEndEHAModel = SystemSettingsEndEHAModel()
    @State var volumeEHAPostTest = Float()
    
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
                    EHAResultsDisplayView()
                } label: {
                    Text("Continue To See Results")
                        .foregroundColor(.green)
                }
                Spacer()
            }
        }
        .onAppear {
            Task{
                audioSessionModel.setAudioSession()
                await checkEHAPostTestVolume()
                await savePostEHATestSystemSettings()
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
}

//struct PostEHATestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostEHATestView()
//    }
//}
