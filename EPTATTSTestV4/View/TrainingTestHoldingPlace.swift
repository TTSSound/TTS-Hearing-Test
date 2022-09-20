//
//  TrainingTest.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct TrainingTestHoldingPlace<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            TrainingTestHoldingPlaceContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading TrainingTestHoldingPlace View")
                .navigationTitle("")
        }
    }
}

struct TrainingTestHoldingPlaceContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var ttLinkColors: [Color] = [Color.clear, Color.green]
    @State var ttLinkColorIndex = Int()

    @State var ehaTrainLinkExists = Bool()
    @State var eptaTrainLinkExists = Bool()
    @State var simpleTrainLinkExists = Bool()
    @State var returnedHoldingTrainTestSelected = 0
    @State var returnedHoldingTestSelected = 0
    @State var returnedHoldingTestSelectedArray = ["", "EHA Test", "EPTA Test", "Simple Test", "Error"]
    
    var body: some View {
        
            ZStack{
                colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                VStack{
                    Text("Practice Phase Now Complete.")
                        .foregroundColor(.white)
                        .font(.title)

                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    Text("Before Starting The Test We Need To Check Your System Settings & Test Selection")
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
                        Text("Check Settings & Test Selection")
                            
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    Text("TestReturned: \(returnedHoldingTestSelectedArray[returnedHoldingTrainTestSelected])")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    if returnedHoldingTrainTestSelected >= 1 {
                        NavigationLink(destination: Bilateral1kHzTestView(testing: testing, relatedLinkTesting: linkTesting)) {
                            HStack{
                                VStack{
                                    Text("We are Now Ready To Start The Test.")
                                        .foregroundColor(.white)
                                    Text("Continue to Get Started!")
                                        .foregroundColor(.white)
                                    Image(systemName: "arrowshape.bounce.right")
                                        .foregroundColor(.white)
                                }  
                            }
                            .frame(width: 300, height: 100, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(24)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        .padding(.bottom,20)
                    } else {
                        HStack{
                            Image(systemName: "arrowshape.bounce.right")
                                .foregroundColor(.clear)
                            Text("")
                                .foregroundColor(.clear)
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.clear)
                        .background(Color.clear)
                        .cornerRadius(24)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                Spacer()
            }
            .onAppear(perform: {
                ttLinkColorIndex = 0
            })

        }
                        
//                    NavigationLink(destination:
//                        returnedTrainTestSelected == 1 ? AnyView(EHATTSTestPart1View())
//                        : returnedTrainTestSelected == 2 ? AnyView(EPTATTSTestV4List())
//                        : returnedTrainTestSelected == 3 ? AnyView(SimpleTestView())
//                        : AnyView(TrainingTestHoldingPlace(testing: testing, relatedLinkTesting: linkTesting))
//                    ){
//                        HStack{
//                           Image(systemName: "arrowshape.bounce.right")
//                                .foregroundColor(.green)
//                           Text("We are Now Ready To Start The Test.\nClick Continue to Get Started!")
//                                .foregroundColor(.green)
//                       }
//                    }
//                    .foregroundColor(.green)
//                    .foregroundColor(ttLinkColors[ttLinkColorIndex])
//                    .padding(.top, 20)
//                    .padding(.bottom, 20)
                    
//                    Spacer()
//                    HStack{
//                        Spacer()
//                        NavigationLink("Bilateral1kHzTestView", destination: Bilateral1kHzTestView(testing: testing, relatedLinkTesting: linkTesting)).foregroundColor(.blue)
//                        Spacer()
//                        NavigationLink("EHATTSTestPart1", destination: EHATTSTestPart1View()).foregroundColor(.green)
//                        Spacer()
//                    }
//                    Spacer()
//                    HStack{
//                        Spacer()
//                        NavigationLink("EHATTSTestPart2View", destination: EHATTSTestPart2View()).foregroundColor(.orange)
//                        Spacer()
//                        NavigationLink("SimpleTest", destination: SimpleTestView()).foregroundColor(.red)
//                        Spacer()
//                    }
//                    Spacer()

    
    func returnTrainTestSelected() async {
        if ehaTrainLinkExists == true {
            returnedHoldingTrainTestSelected = 1
            print("EHA Test Link Exists")
        } else {
            print("EHA Link Does Not Exist")
        }
        if eptaTrainLinkExists == true {
            returnedHoldingTrainTestSelected = 2
            print("EPTA Test Link Exists")
        } else {
            print("EPTA Link Does Not Exist")
        }
        if simpleTrainLinkExists == true {
            returnedHoldingTrainTestSelected = 3
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
    
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

struct TrainingTestHoldingPlace_Previews: PreviewProvider {
    static var previews: some View {
        TrainingTestHoldingPlace(testing: nil, relatedLinkTesting: linkTesting)
    }

    static func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}
