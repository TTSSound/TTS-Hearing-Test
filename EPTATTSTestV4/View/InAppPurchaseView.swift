//
//  InAppPurchaseView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct InAppPurchaseView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var inAppPurchaseModel: InAppPurchaseModel = InAppPurchaseModel()
    
    @State var EHAPurchased: Bool = false
    @State var EPTAPurchased: Bool = false
    @State var submissionOrPurchaseTest = Int()
    
    @State var selectedTest = Int()
    @State var purchasedEHAUUID = String()
    @State var purchasedEPTAUUID = String()
    @State var simpleUUID = String()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
               
                Text("In-App Purchases")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
               
                
                Toggle("Purchase EHA Test", isOn: $EHAPurchased)
                    .foregroundColor(colorModel.neonGreen)
                    .font(.title)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .onChange(of: EHAPurchased) { EHATest in
                        if EHATest == true {
                            selectedTest = 1
                            EPTAPurchased = false
                        }
                    }
                    .padding(.bottom, 60)
                    .padding(.top, 60)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                
               
                
                Toggle("Purchase EPTA Test", isOn: $EPTAPurchased)
                    .foregroundColor(colorModel.tiffanyBlue)
                    .font(.title)
                    .padding(.leading)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.trailing)
                    .onChange(of: EPTAPurchased) { purchasedEPTATest in
                        if purchasedEPTATest == true {
                            selectedTest = 2
                            EHAPurchased = false
                        }
                    }
                    .padding(.bottom, 60)
                    .padding(.top, 60)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.gray)
                    .foregroundColor(.gray)
                

                Spacer()
                
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await completePurchase()
                            await saveTestSelectionTolkens()
                        }
                    } label: {
                        VStack{
                            Image(systemName: "arrow.up.doc.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text("Submit & Complete Purchase")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                      
                    }
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
    func completePurchase() async {
        if EHAPurchased == true && EPTAPurchased == false {
            selectedTest = 1
            purchasedEHAUUID = UUID().uuidString
            inAppPurchaseModel.userPurchasedTest.append(selectedTest)
            inAppPurchaseModel.userPurchasedEHAUUIDString.append(purchasedEHAUUID)
            print("EHA userUUID: \(purchasedEHAUUID)")
            print("EHA selectedTest: \(selectedTest)")
            print("EHA testSelectionModel userPurchasedEHAUUID: \(inAppPurchaseModel.userPurchasedEHAUUIDString)")
            print("EHA testSelectionModel userPurchasedTest EHA: \(inAppPurchaseModel.userPurchasedTest)")
            inAppPurchaseModel.finalPurchasedEHATestUUID.append(inAppPurchaseModel.userPurchasedEHAUUIDString)
            print("EHA testSelectionModel finalPurchasedEHATestUUID: \(inAppPurchaseModel.finalPurchasedEHATestUUID)")
            inAppPurchaseModel.finalPurchasedTestTolken.append(inAppPurchaseModel.userPurchasedEHAUUIDString)
            inAppPurchaseModel.finalTestPurchased.append(selectedTest)
            
            //Making holding false values for EPTA
            let noEPTA = "NoEPTAPruchased"
            inAppPurchaseModel.userPurchasedEPTAUUIDString.append(noEPTA)
            print("EHA testSelectionModel userPurchasedEPTAUUID: \(inAppPurchaseModel.userPurchasedEPTAUUIDString)")
            inAppPurchaseModel.finalPurchasedEPTATestUUID.append(inAppPurchaseModel.userPurchasedEPTAUUIDString)
            print("EHA testSelectionModel finalPurchasedEPTATestUUID: \(inAppPurchaseModel.finalPurchasedEPTATestUUID)")
            print("EHA PURCHASED!")
        } else if EHAPurchased == false && EPTAPurchased == true {
            selectedTest = 2
            purchasedEPTAUUID = UUID().uuidString
            inAppPurchaseModel.userPurchasedTest.append(selectedTest)
            inAppPurchaseModel.userPurchasedEPTAUUIDString.append(purchasedEPTAUUID)
            print("EPTA userUUID: \(purchasedEPTAUUID)")
            print("EPTA selectedTest: \(selectedTest)")
            print("EPTA testSelectionModel userPurchasedEPTAUUID: \(inAppPurchaseModel.userPurchasedEPTAUUIDString)")
            print("EPTA testSelectionModel userPurchasedTest EPTA: \(inAppPurchaseModel.userPurchasedTest)")
            inAppPurchaseModel.finalPurchasedEPTATestUUID.append(inAppPurchaseModel.userPurchasedEPTAUUIDString)
            print("EPTA testSelectionModel finalPurchasedEPTATestUUID: \(inAppPurchaseModel.finalPurchasedEPTATestUUID)")
            inAppPurchaseModel.finalPurchasedTestTolken.append(inAppPurchaseModel.userPurchasedEPTAUUIDString)
            inAppPurchaseModel.finalTestPurchased.append(selectedTest)
            
            let noEHA = "NoEHAPurchased"
            inAppPurchaseModel.userPurchasedEHAUUIDString.append(noEHA)
            print("EPTA testSelectionModel userPurchasedEHAAUUID: \(inAppPurchaseModel.userPurchasedEHAUUIDString)")
            inAppPurchaseModel.finalPurchasedEHATestUUID.append(inAppPurchaseModel.userPurchasedEHAUUIDString)
            print("EPTA testSelectionModel finalPurchasedEPTATestUUID: \(inAppPurchaseModel.finalPurchasedEHATestUUID)")
            print("EPTA PURCHASED!")
        } else {
            print("!!! Error in complete Purchase Logic")
        }
    }
    
//    func generateEHAUUID() async {
//        purchasedEHAUUID = UUID().uuidString
//        inAppPurchaseModel.userPurchasedEHAUUIDString.append(purchasedEHAUUID)
//
//        inAppPurchaseModel.userPurchasedTest.append(selectedTest)
//        print("userUUID: \(purchasedEHAUUID)")
//        print("selectedTest: \(selectedTest)")
//        print("testSelectionModel userPurchasedEHAUUID: \(inAppPurchaseModel.userPurchasedEHAUUIDString)")
//        print("testSelectionModel userPurchasedTest EHA: \(inAppPurchaseModel.userPurchasedTest)")
//    }
//
//    func generateEPTAUUID() async {
//        purchasedEPTAUUID = UUID().uuidString
//        inAppPurchaseModel.userPurchasedEPTAUUIDString.append(purchasedEPTAUUID)
//        selectedTest = 2
//        inAppPurchaseModel.userPurchasedTest.append(selectedTest)
//        print("userUUID: \(purchasedEPTAUUID)")
//        print("testSelectionModel userPurchasedEPTAUUID: \(inAppPurchaseModel.userPurchasedEPTAUUIDString)")
//        print("testSelectionModel userPurchasedTest EPTA: \(inAppPurchaseModel.userPurchasedTest)")
//    }
//
//    func concatenatePurchaseTestFinalArrays() async {
//        inAppPurchaseModel.finalPurchasedEHATestUUID.append(inAppPurchaseModel.userPurchasedEHAUUIDString)
//        inAppPurchaseModel.finalPurchasedEPTATestUUID.append(inAppPurchaseModel.userPurchasedEPTAUUIDString)
//        print("testSelectionModel finalPurchasedEHATestUUID: \(inAppPurchaseModel.finalPurchasedEHATestUUID)")
//        print("testSelectionModel finalPurchasedEPTATestUUID: \(inAppPurchaseModel.finalPurchasedEPTATestUUID)")
//    }
//
//    func assignFinalTestTolken() async {
//        if selectedTest == 1 {
//            inAppPurchaseModel.finalPurchasedTestTolken.append(inAppPurchaseModel.userPurchasedEHAUUIDString)
//            inAppPurchaseModel.finalTestPurchased.append(selectedTest)
//        } else if selectedTest == 2 {
//            inAppPurchaseModel.finalPurchasedTestTolken.append(inAppPurchaseModel.userPurchasedEPTAUUIDString)
//            inAppPurchaseModel.finalTestPurchased.append(selectedTest)
//        } else {
//            print("!!!Error in assignFinalTestTolken Logic")
//        }
//        print("inAppPurchaseModel finalTestPurchased: \(inAppPurchaseModel.finalTestPurchased)")
//        print("inAppPurchaseModel finalPurchasedTestTolken: \(inAppPurchaseModel.finalPurchasedTestTolken)")
//    }

    func saveTestSelectionTolkens() async {
        await inAppPurchaseModel.getTestPurchaseData()
        await inAppPurchaseModel.saveTestPurchaseToJSON()
        await inAppPurchaseModel.writeTestPurchaseToCSV()
        await inAppPurchaseModel.writeInputTestPurchaseToCSV()
    }
}


//struct InAppPurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        InAppPurchaseView()
//    }
//}
