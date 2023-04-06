//
//  PreTestView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/28/22.
//

import SwiftUI

struct PreTestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PreTestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading PreTest View")
                .navigationTitle("")
        }
    }
}


struct PreTestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var ehaLinkExists = Bool()
    @State var eptaLinkExists = Bool()
    @State var simpleLinkExists = Bool()
    @State var returnedTestSelected = 0
    @State var returnedTestSelectedArray = ["", "EHA Test", "EPTA Test", "Simple Test", "Error"]
    
    
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text(" Pre Test View for a break and to get user's phon and reference curve data/funtions. Then Start Practice Test")
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                Button {
                    Task {
                        //                        await getTestLinkPath()
                        await checkEHATestLik()
                        await checkEPTATestLik()
                        await checkSimpleTestLik()
                        await returnTestSelected()
                    }
                } label: {
                    Text("Check Test Selection")
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(24)
                }
                Spacer()
                Text("TestReturned: \(returnedTestSelectedArray[returnedTestSelected])")
                    .foregroundColor(.white)
                Spacer()
                if returnedTestSelected < 1 {
                    VStack{
                        Text("We are Now Ready To Take a Practice Test.")
                            .foregroundColor(.clear)
                            .padding(.bottom, 20)
                        Text("Continue")
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(Color.clear)
                            .foregroundColor(.clear)
                            .cornerRadius(24)
                        
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                } else if returnedTestSelected >= 1 {
                    NavigationLink {
                        TrainingTestView(testing: testing, relatedLinkTesting: linkTesting)
                    } label: {
                        VStack{
                            Text("We are Now Ready To Take a Practice Test.")
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                            Text("Continue")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                            
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                    }
                }
                Spacer()
            }
        }
    }
}
 
extension PreTestContent {
    //MARK: -Extension Methods
    func returnTestSelected() async {
        if ehaLinkExists == true && eptaLinkExists == false && simpleLinkExists == false {
            returnedTestSelected = 1
            print("EHA Test Link Exists")
            print("EPTA Link Does Not Exist")
            print("Simple Link Does Not Exist")
        } else if ehaLinkExists == false && eptaLinkExists == true && simpleLinkExists == false {
            returnedTestSelected = 2
            print("EPTA Test Link Exists")
            print("EHA Link Does Not Exist")
            print("Simple Link Does Not Exist")
        } else  if ehaLinkExists == false && eptaLinkExists == false && simpleLinkExists == true {
            returnedTestSelected = 3
            print("Simple Test Link Exists")
            print("EHA Link Does Not Exist")
            print("EPTA Link Does Not Exist")
        } else {
            returnedTestSelected = 4
            print("Critical Error in returnTestSelected Logic")
        }
    }
    
    func getTestLinkPath() async -> String {
        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = testLinkPaths[0]
        return documentsDirectory
    }
    
    func checkEHATestLik() async {
        let ehaName = ["EHA.csv"]
        let fileManager = FileManager.default
        let ehaPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: ehaName)
        if fileManager.fileExists(atPath: ehaPath[0]) {
            let ehaFilePath = URL(fileURLWithPath: ehaPath[0])
            if ehaFilePath.isFileURL  {
                ehaLinkExists = true
            } else {
                print("EHA.csv Does Not Exist")
            }
        }
    }
    
    func checkEPTATestLik() async {
        let eptaName = ["EPTA.csv"]
        let fileManager = FileManager.default
        let eptaPath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: eptaName)
        if fileManager.fileExists(atPath: eptaPath[0]) {
            let eptaFilePath = URL(fileURLWithPath: eptaPath[0])
            if eptaFilePath.isFileURL  {
                eptaLinkExists = true
            } else {
                print("EPTA.csv Does Not Exist")
            }
        }
    }
    
    func checkSimpleTestLik() async {
        let simpleName = ["Simple.csv"]
        let fileManager = FileManager.default
        let simplePath = (await self.getTestLinkPath() as NSString).strings(byAppendingPaths: simpleName)
        if fileManager.fileExists(atPath: simplePath[0]) {
            let simpleFilePath = URL(fileURLWithPath: simplePath[0])
            if simpleFilePath.isFileURL  {
                simpleLinkExists = true
            } else {
                print("Simple.csv Does Not Exist")
            }
        }
    }
}

extension PreTestContent {
//MARK: -NavigationLink Extenstion
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
}


//struct PreTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreTestView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//    
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
