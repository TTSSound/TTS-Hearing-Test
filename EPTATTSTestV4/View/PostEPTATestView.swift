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
                Text("View for Completion of Test Phase #1")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Text("Great Work!")
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Text("Return Home to Navigate To The Second Phase of The Test. Enable the Toggle Button for It and Access it By the Tab Menu.")
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()
                Text("Make sure to unmount and remount your earbuds before starting the 2nd test phase!")
                    .foregroundColor(colorModel.sunriseBrightYellow)
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
            .padding(.leading, 30)
            .padding(.trailing, 30)
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
