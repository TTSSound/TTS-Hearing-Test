//
//  PreTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/28/22.
//

import SwiftUI

struct PreTestView: View {

    @StateObject var colorModel: ColorModel = ColorModel()
//    @EnvironmentObject var testSelectionModel: TestSelectionModel
    @ObservedObject var testSelectLinkModel: TestSelectLinkModel = TestSelectLinkModel()

    @State var ehaLinkExists = Bool()
    @State var eptaLinkExists = Bool()
    @State var simpleLinkExists = Bool()
    @State var returnedTestSelected = Int()
 


    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text(" Pre Test View for a break and to get user's phon and reference curve data/funtions")
                    .foregroundColor(.white)
                Spacer()
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
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("TestReturned: \(returnedTestSelected)")
                    .foregroundColor(.white)
                
                NavigationLink {
                    LandingView()
//                   TrainingTestHoldingPlace()
                } label: {
                    Text("We are Now Ready To Start The Test.\nClick Continue to Get Started!")
                        .foregroundColor(.green)
                }
                
                
                Spacer()
            }
        }
    }
    
    func returnTestSelected() async {
        if ehaLinkExists == true {
            returnedTestSelected = 1
            print("EHA Test Link Exists")
        } else {
            print("EHA Link Does Not Exist")
        }
        if eptaLinkExists == true {
            returnedTestSelected = 2
            print("EPTA Test Link Exists")
        } else {
            print("EPTA Link Does Not Exist")
        }
        if simpleLinkExists == true {
            returnedTestSelected = 3
            print("Simple Test Link Exists")
        } else {
            print("Simple Link Does Not Exist")
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

// CSV DECODING NEEDED NOW TO POPULATE NEW DATA Set To Reference and Read Only
//Button {
//    Task{
//        await jsonParserCombineViewModel.getLocalDirectoryPath()

//}



//struct PreTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreTestView()
//    }
//}
