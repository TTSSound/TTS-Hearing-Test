//
//  PostTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostEPTATestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PostEPTATestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading PostEPTATest View")
                .navigationTitle("")
        }
    }
}

struct PostEPTATestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    //    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var volumeEPTAPostTest = Float()
    
    var body: some View {
        ZStack{
            Image("Background1 1").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all, edges: .top)
            //colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("View for Completion of EPTA Test")
                    .foregroundColor(.white)
                Spacer()
                Text("Great Work!")
                    .foregroundColor(.white)
                Spacer()
                Text("Return Home To Navigate To Your Results")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                //                NavigationLink {
                //                    EPTAResultsDisplayView()
                //                } label: {
                //                    Text("Continue To See Results")
                //                        .foregroundColor(.green)
                //                }
                //                Spacer()
            }
        }
        //        .onAppear {
        //            Task(priority: .userInitiated, operation: {
        //                audioSessionModel.setAudioSession()
        //                await checkEPTAPostTestVolume()
        //                await savePostEPTASettings()
        //            })
        //        }
    }
}
 
extension PostEPTATestContent {
//MARK: -Methods Extension
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

extension PostEPTATestContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

//struct PostTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostEPTATestView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//    
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
