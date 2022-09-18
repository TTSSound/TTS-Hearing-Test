//
//  TrainingTest.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct TrainingTestHoldingPlace: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var ttLinkColors: [Color] = [Color.clear, Color.green]
    @State var ttLinkColorIndex = Int()

    @State var ehaTrainLinkExists = Bool()
    @State var eptaTrainLinkExists = Bool()
    @State var simpleTrainLinkExists = Bool()
    @State var returnedTrainTestSelected = Int()
    
    var body: some View {
        

//        NavigationView{
            ZStack{
                colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                VStack{
                    NavigationLink {
                        PostAllTestsSplashView()
                    } label: {
                        Text("Test Phase Now Complete, Proceed Here")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    Text("Hold Place for Training Test")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    Button {
                        Task {
                            await checkTrainEHATestLik()
                            await checkTrainEPTATestLik()
                            await checkTrainSimpleTestLik()
                            await returnTrainTestSelected()
                        }
                    } label: {
                        Text("Check Test Selection")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Text("TestReturned: \(returnedTrainTestSelected)")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination:
                        returnedTrainTestSelected == 1 ? AnyView(EHATTSTestPart1View())
                        : returnedTrainTestSelected == 2 ? AnyView(EPTATTSTestV4List())
                        : returnedTrainTestSelected == 3 ? AnyView(SimpleTestView())
                        : AnyView(TrainingTestHoldingPlace())
                    ){
                        HStack{
                           Image(systemName: "arrowshape.bounce.right")
                                .foregroundColor(.green)
                           Text("We are Now Ready To Start The Test.\nClick Continue to Get Started!")
                                .foregroundColor(.green)
                       }
                    }
                    .foregroundColor(.green)
                    .foregroundColor(ttLinkColors[ttLinkColorIndex])
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink("Bilateral1kHzTestView", destination: Bilateral1kHzTestView()).foregroundColor(.blue)
                        Spacer()
                        NavigationLink("EHATTSTestPart1", destination: EHATTSTestPart1View()).foregroundColor(.green)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink("EHATTSTestPart2View", destination: EHATTSTestPart2View()).foregroundColor(.orange)
                        Spacer()
                        NavigationLink("SimpleTest", destination: SimpleTestView()).foregroundColor(.red)
                        Spacer()
                    }
                    Spacer()
     
                }
                .onAppear(perform: {
                    ttLinkColorIndex = 0
                })
                .padding(.leading)
                .padding(.trailing)

            // Present training tones before the test starts
            // this then links to EPTATTSTestV4List
            }
        }
//    }
    
    func returnTrainTestSelected() async {
        if ehaTrainLinkExists == true {
            returnedTrainTestSelected = 1
            print("EHA Test Link Exists")
        } else {
            print("EHA Link Does Not Exist")
        }
        if eptaTrainLinkExists == true {
            returnedTrainTestSelected = 2
            print("EPTA Test Link Exists")
        } else {
            print("EPTA Link Does Not Exist")
        }
        if simpleTrainLinkExists == true {
            returnedTrainTestSelected = 3
            print("Simple Test Link Exists")
        } else {
            print("Simple Link Does Not Exist")
        }
    }
    
    func getTrainTestLinkPath() async -> String {
        let testLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = testLinkPaths[0]
        return documentsDirectory
    }

//NEED NEW APPROACH. THIS DOESN'T WORK IF TWO FILES ARE CREATED
// NEED TO FIGURE OUT HOW TO DELETE FILES ON SECOND ATTEMPT TO TAKE TEST
    func checkTrainEHATestLik() async {
        let ehaName = ["EHA.csv"]
        let fileManager = FileManager.default
        let ehaPath = (await self.getTrainTestLinkPath() as NSString).strings(byAppendingPaths: ehaName)
        if fileManager.fileExists(atPath: ehaPath[0]) {
            let ehaFilePath = URL(fileURLWithPath: ehaPath[0])
            if ehaFilePath.isFileURL  {
                ehaTrainLinkExists = true
            } else {
                print("EHA.csv Does Not Exist")
            }
        }
    }
        
    func checkTrainEPTATestLik() async {
        let eptaName = ["EPTA.csv"]
        let fileManager = FileManager.default
        let eptaPath = (await self.getTrainTestLinkPath() as NSString).strings(byAppendingPaths: eptaName)
        if fileManager.fileExists(atPath: eptaPath[0]) {
            let eptaFilePath = URL(fileURLWithPath: eptaPath[0])
            if eptaFilePath.isFileURL  {
                eptaTrainLinkExists = true
            } else {
                print("EPTA.csv Does Not Exist")
            }
        }
    }
    
    func checkTrainSimpleTestLik() async {
        let simpleName = ["Simple.csv"]
        let fileManager = FileManager.default
        let simplePath = (await self.getTrainTestLinkPath() as NSString).strings(byAppendingPaths: simpleName)
        if fileManager.fileExists(atPath: simplePath[0]) {
            let simpleFilePath = URL(fileURLWithPath: simplePath[0])
            if simpleFilePath.isFileURL  {
                simpleTrainLinkExists = true
            } else {
                print("Simple.csv Does Not Exist")
            }
        }
    }
}

//struct TrainingTest_Previews: PreviewProvider {
//    static var previews: some View {
//        TrainingTest()
//    }
//}
