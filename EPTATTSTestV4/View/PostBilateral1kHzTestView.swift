//
//  PostBilateral1kHzTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/14/22.
//

import SwiftUI
import CodableCSV

struct PostBilateral1kHzTestView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var ehaBetaLinkExists = Bool()
    @State var eptaBetaLinkExists = Bool()
    @State var betaTestsArray = ["Shorter EPTA", "Full EHA", "Error in Test Index"]
    @State var betaTestSelectedIdx = Int()
    @State var betaTestColorArray: [Color] = [Color.blue, Color.green, Color.red]
    
    let inputBetaEHACSVName = "EHA.csv"
    let inputBetaEPTACSVName = "EPTA.csv"
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                
                // Add in code to determine phone curve here or in each test. Maybe test it here
                
                
                //Check Test Selection
                Button {
                    Task {
                        await checkBetaEHATestLik()
                        await checkTrainEPTATestLik()
                        await returnBetaTestSelected()
                    }
                } label: {
                    Text("Check Test Selection")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                Text("Test Selected: \(betaTestsArray[betaTestSelectedIdx])")
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Spacer()
                NavigationLink("EPTA Test", destination: EHATTSTestPart1View()).foregroundColor(betaTestColorArray[betaTestSelectedIdx])
                Spacer()
                NavigationLink("EHATTSTestPart1", destination: EHATTSTestPart1View()).foregroundColor(betaTestColorArray[betaTestSelectedIdx])
                Spacer()
                NavigationLink("EHATTSTestPart2", destination: EHATTSTestPart2View()).foregroundColor(betaTestColorArray[betaTestSelectedIdx])
                Spacer()
                
            }
        }
    }
    
    func returnBetaTestSelected() async {
        if eptaBetaLinkExists == true && ehaBetaLinkExists == false {
            betaTestSelectedIdx = 0
            print("EPTA Test Link Exists")
        } else if eptaBetaLinkExists == false && ehaBetaLinkExists == true {
            betaTestSelectedIdx = 1
            print("EHA Link Exist")
        } else {
            betaTestSelectedIdx = 2
            print("Error in test index")
        }
    }
    
    func getBetaTestLinkPath() async -> String {
        let testBetaLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsBetaDirectory = testBetaLinkPaths[0]
        return documentsBetaDirectory
    }

//NEED NEW APPROACH. THIS DOESN'T WORK IF TWO FILES ARE CREATED
// NEED TO FIGURE OUT HOW TO DELETE FILES ON SECOND ATTEMPT TO TAKE TEST
    func checkBetaEHATestLik() async {
        let ehaBetaName = ["eha.csv"]
        let fileEHABetaManager = FileManager.default
        let ehaBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: ehaBetaName)
        if fileEHABetaManager.fileExists(atPath: ehaBetaPath[0]) {
            let ehaBetaFilePath = URL(fileURLWithPath: ehaBetaPath[0])
            if ehaBetaFilePath.isFileURL  {
                ehaBetaLinkExists = true
            } else {
                print("EHA.csv Does Not Exist")
            }
        }
    }
        
    func checkTrainEPTATestLik() async {
        let eptaBetaName = ["epta.csv"]
        let fileEPTABetaManager = FileManager.default
        let eptaBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: eptaBetaName)
        if fileEPTABetaManager.fileExists(atPath: eptaBetaPath[0]) {
            let eptaBetaFilePath = URL(fileURLWithPath: eptaBetaPath[0])
            if eptaBetaFilePath.isFileURL  {
                eptaBetaLinkExists = true
            } else {
                print("EPTA.csv Does Not Exist")
            }
        }
    }
    
    
}

struct PostBilateral1kHzTestView_Previews: PreviewProvider {
    static var previews: some View {
        PostBilateral1kHzTestView()
    }
}
