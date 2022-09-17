//
//  TestSelectionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

//Add in final test selection class write int and final test tolken UUID

struct TestSelectionView: View {

    @StateObject var colorModel = ColorModel()
    @StateObject var testSelectionModel = TestSelectionModel()
    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
    @StateObject var testSelectLinkModel: TestSelectLinkModel = TestSelectLinkModel()
 
    @State var selectedEHA: Bool = false
    @State var selectedEPTA: Bool = false
    @State var selectedSimple: Bool = false
    @State var testSelectionSubmitted = [Int]()
    @State var testSelectionSuccessful = [Int]()
    @State var isOkayToContinue: Bool = false
    @State var sumSelection = Int()
    @State var singleEHA = Int()
    @State var singleEPTA = Int()
    @State var singleSimple = Int()
    @State var singleEHAArray = [Int]()
    @State var singleEPTAArray = [Int]()
    @State var singleSimpleArray = [Int]()
    @State var simpleTestUUIDString = String()
    @State var tsLinkColors: [Color] = [Color.clear, Color.green]
    @State var tsLinkColorIndex = Int()
    
 
    var body: some View {

// Marketing and info on EPTA vs EHA Tests
// Direction that EHA test be taken in two parts at two different times and days
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack {
               Spacer()
                Text("Test Selection")
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.blue)
                    .foregroundColor(.blue)
                
                Toggle("I Want the Gold Standard! Give Me The EHA!", isOn: $selectedEHA)
                    .foregroundColor(colorModel.neonGreen)
//                    .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
    //                    .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .onChange(of: selectedEHA) { ehaValue in
                        if ehaValue == true {
                            testSelectionSubmitted.removeAll()
                            testSelectionSubmitted.append(0)
                            selectedEPTA = false
                            selectedSimple = false
                            singleEHA = 0
                            singleEPTA = 0
                            singleSimple = 0
                            }
                        }
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)

                Toggle("I'm Only Interested In Assessing My Hearing. Give me the EPTA", isOn: $selectedEPTA)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .foregroundColor(colorModel.limeGreen)
//                    .foregroundColor(Color(red: 0.6901960784313725, green: 0.5529411764705883, blue: 0.3411764705882353))
                    .onChange(of: selectedEPTA) { eptaValue in
                        if eptaValue == true {
                            testSelectionSubmitted.removeAll()
                            testSelectionSubmitted.append(1)
                            selectedEHA = false
                            selectedSimple = false
                            singleEHA = 0
                            singleEPTA = 0
                            singleSimple = 0
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                
                Toggle("I'd Like To Trial The Simple Hearing Test.", isOn: $selectedSimple)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .foregroundColor(colorModel.darkNeonGreen)
                    .onChange(of: selectedSimple) { simpleValue in
                        if simpleValue == true {
                            testSelectionSubmitted.removeAll()
                            testSelectionSubmitted.append(2)
                            selectedEHA = false
                            selectedEPTA = false
                            singleEHA = 0
                            singleEPTA = 0
                            singleSimple = 0
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                
//!!!! Need to setup logic to catch mismatches, nonpurchased but selected EHA and dual or no selection and send user to a splash screen notifying to check selections again, run reset arrays function, and return user to selection screen. NOTE need to account for payment of EHA if it already went through so user does not double pay on second try at selection.
//possibly use non standard if else navigation link results
                
                if isOkayToContinue == false {
               
                    Button {
                        Task(priority: .userInitiated, operation: {
                            await singleSelection()
                            await checkMultipleSelections()
                            await isSelectionSuccessful()
                            print("button clicked")
                            //                           await assignIntToAllTests()
                            //                           await assignTempTestSelection()
                            await finalTestSelectionArrays()
                            await saveTestSelection()
                            await saveTestLinkFile()
                        })
                    } label: {
                        HStack{
                            Spacer()
                            Text("Submit Selection")
                            Spacer()
                            Image(systemName: "arrow.up.doc.fill")
                            Spacer()
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.green)
                        .cornerRadius(300)
                    }
                    .padding(.bottom, 40)
                    Spacer()
               
                } else if isOkayToContinue == true {
                    

                    
                    NavigationLink(destination:
                                    isOkayToContinue == true ? AnyView(CalibrationAssessmentView())
                                   : isOkayToContinue == false ? AnyView(TestSelectionSplashView())
                                   : AnyView(TestSelectionView())
                    ){
                        HStack{
                            Spacer()
                            Text("Continue To Setup")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(300)
                    }
                    .padding(.bottom, 40)
                    Spacer()

                }

            }
            .environmentObject(testSelectionModel)
        }
        .onAppear {
            tsLinkColorIndex = 0
            isOkayToContinue = false
        }
    }
    
    func singleSelection() async {
        if selectedEHA == true {
            singleEHA = 1
            testSelectionModel.finalTestSelected.append(1)
            testSelectionModel.finalSelectedEPTATest.append(-1)
            testSelectionModel.finalSelectedSimpleTest.append(-1)
            testSelectionModel.finalSelectedSimpleTestUUID.append("SimpleTestNOTSelected")
            singleEHAArray.append(singleEHA)
            print("SingleEHA")
        }
        if selectedEPTA == true {
            singleEPTA = 1
            testSelectionModel.finalTestSelected.append(2)
            testSelectionModel.finalSelectedEHATest.append(-1)
            testSelectionModel.finalSelectedSimpleTest.append(-1)
            testSelectionModel.finalSelectedSimpleTestUUID.append("SimpleTestNOTSelected")
            singleEPTAArray.append(singleEPTA)
            print("SingleEPTA")
        }
        if selectedSimple == true {
            singleSimple = 1
            testSelectionModel.finalTestSelected.append(3)
            testSelectionModel.finalSelectedEHATest.append(-1)
            testSelectionModel.finalSelectedEPTATest.append(-1)
            singleSimpleArray.append(singleSimple)
            simpleTestUUIDString = UUID().uuidString
            print("Simple")
            print("Simple UUID Assigned")
        }
    }
     
    func checkMultipleSelections() async {
        sumSelection = singleEHA + singleEPTA + singleSimple
        print("sumSelection: \(sumSelection)")
        if sumSelection == 1 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(1)
            tsLinkColorIndex = 1
            print("Success, only one test selected")
            print("selected Test: \(testSelectionSuccessful)")
        } else if sumSelection == 0 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("Error, no test selected else if 1")
            print("selected Test: \(testSelectionSuccessful)")
        } else if sumSelection > 1 {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("Error, multiple tests selected else if 2")
            print("selected Test: \(testSelectionSuccessful)")
        } else {
            testSelectionSuccessful.removeAll()
            testSelectionSuccessful.append(0)
            tsLinkColorIndex = 0
            print("!!!Error in singleSelection() Logic else ")
            print("selected Test: \(testSelectionSuccessful)")
        }
    }
    
    func isSelectionSuccessful() async {
        if testSelectionSuccessful == [1] {
            isOkayToContinue = true
            print("isokaytocontinue: \(isOkayToContinue)")
        } else if testSelectionSuccessful == [0] {
            isOkayToContinue = false
            print("isokaytocontinue: \(isOkayToContinue)")
        } else {
            print("isokaytocontinue: \(isOkayToContinue)")
            print("!!!Error in isSelectionSuccessful Logic")
        }
    }
    
//    func assignIntToAllTests() async {
//        if selectedEHA == true {
//            singleEHA = 1
//            singleEPTA = -1
//            singleSimple = -1
//            print("SingleEHA Assigned")
//        }
//        if selectedEPTA == true {
//            singleEPTA = 1
//            singleEHA = -1
//            singleSimple = -1
//            print("SingleEPTA Assigned")
//        }
//        if selectedSimple == true {
//            singleSimple = 1
//            singleEHA = -1
//            singleEPTA = -1
//            print("Simple Assigned")
//        }
//    }
    
//    func assignTempTestSelection() async {
//
//        if selectedEHA == true {
//            testSelectionModel.finalTestSelected.append(1)
//        } else {
//            print("Error in EHA assign temp")
//        }
//        if selectedEPTA == true {
//            testSelectionModel.finalTestSelected.append(2)
//        } else {
//            print("Error in EPTA assign temp")
//        }
//        if selectedSimple == true {
//            testSelectionModel.finalTestSelected.append(3)
//        } else {
//            print("Error in Simple assign temp")
//        }
//    }
    
    func finalTestSelectionArrays() async {
        testSelectionModel.finalSelectedEHATest.append(contentsOf: singleEHAArray)
        testSelectionModel.finalSelectedEPTATest.append(contentsOf: singleEPTAArray)
        testSelectionModel.finalSelectedSimpleTest.append(contentsOf: singleSimpleArray)
//        simpleTestUUIDString = UUID().uuidString
        testSelectionModel.finalSelectedSimpleTestUUID.append(simpleTestUUIDString)
        print("testSelectionModel finalSelectedEHATest: \(testSelectionModel.finalSelectedEHATest)")
        print("testSelectionModel finalSelectedEPTATest: \(testSelectionModel.finalSelectedEPTATest)")
        print("testSelectionModel finalSelectedSimpleTest: \(testSelectionModel.finalSelectedSimpleTest)")
        print("UUID: \(simpleTestUUIDString)")
        print("testSelectionModel simpleTestUUID: \(testSelectionModel.finalSelectedSimpleTestUUID)")

    }

    func saveTestSelection() async {
        await testSelectionModel.getTestSelectionData()
        await testSelectionModel.saveTestSelectionToJSON()
        await testSelectionModel.writeTestSelectionToCSV()
        await testSelectionModel.writeInputTestSelectionToCSV()
    }
    
    func saveTestLinkFile() async {
        if singleEHA == 1 {
            await testSelectLinkModel.writeEHATestLinkToCSV()
        } else {
            print("!!Error in singleEHA test link logic")
        }
        if singleEPTA == 1 {
            await testSelectLinkModel.writeEPTATestLinkToCSV()
        } else {
            print("!!Error in singleEPTA test link logic")
        }
        if singleSimple == 1 {
            await testSelectLinkModel.writeSimpleTestLinkToCSV()
        } else {
            print("!!Error in singleSimple test link logic")
        }
    }
}


//struct TestSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionView()
//            .environmentObject(TestSelectionModel())
//    }
//}
