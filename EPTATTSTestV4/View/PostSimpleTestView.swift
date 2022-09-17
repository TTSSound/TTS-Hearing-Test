//
//  PostSimpleTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostSimpleTestView: View {
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()

    @State var volumePostSimpleTest = Float()
    
    
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("View for Completion of Simple Test")
                    .foregroundColor(.white)
                Spacer()
                Text("Great Work!")
                    .foregroundColor(.white)
                Spacer()
                Text("Give Us A Moment To Calculate and Format Your Results")
                    .foregroundColor(.white)
                Spacer()
                NavigationLink {
                    SimpleResultsDisplayView()
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
                await checkPostTestVolume()
                await savePostSimpleSettings()
            })
        }
    }
    
    func checkPostTestVolume() async {
        volumePostSimpleTest = audioSessionModel.audioSession.outputVolume
//        systemSettingsModel.finalEndingSystemVolume.append(volumePostSimpleTest)
        print("Volume Post Test: \(volumePostSimpleTest)")
//        print("setupDataModel finalEndingSystemVolume: \(systemSettingsModel.finalEndingSystemVolume)")
    }
    
    func savePostSimpleSettings() async {
//        await systemSettingsModel.getSystemData()
//        await systemSettingsModel.saveSystemToJSON()
//        await systemSettingsModel.writeSystemResultsToCSV()
    }
}

//struct PostSimpleTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostSimpleTestView()
//    }
//}
