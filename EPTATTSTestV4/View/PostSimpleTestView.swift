//
//  PostSimpleTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostSimpleTestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PostSimpleTestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading PostSimpleTest View")
                .navigationTitle("")
        }
    }
}

struct PostSimpleTestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    //    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    //    @State var volumePostSimpleTest = Float()

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
                Text("Return Home To Navigate To Your Results")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                //                NavigationLink {
                //                    SimpleResultsDisplayView()
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
        //                await checkPostTestVolume()
        //                await savePostSimpleSettings()
        //            })
        //        }
    }
}
 
extension PostSimpleTestContent {
//MARK: -Methods Extension
    func checkPostTestVolume() async {
        //        volumePostSimpleTest = audioSessionModel.audioSession.outputVolume
        //        systemSettingsModel.finalEndingSystemVolume.append(volumePostSimpleTest)
        //        print("Volume Post Test: \(volumePostSimpleTest)")
        //        print("setupDataModel finalEndingSystemVolume: \(systemSettingsModel.finalEndingSystemVolume)")
    }
    
    func savePostSimpleSettings() async {
        //        await systemSettingsModel.getSystemData()
        //        await systemSettingsModel.saveSystemToJSON()
        //        await systemSettingsModel.writeSystemResultsToCSV()
    }
}

extension PostSimpleTestContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

struct PostSimpleTestView_Previews: PreviewProvider {
    static var previews: some View {
        PostSimpleTestView(testing: nil, relatedLinkTesting: linkTesting)
    }
    
    static func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}
