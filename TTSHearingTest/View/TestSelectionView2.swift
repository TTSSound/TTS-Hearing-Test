//
//  TestSelectionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

//import SwiftUI
//
//struct TestSelectionView: View {
//    enum PurchaseErrors {
//        case arrayError
//    }
//    
//    @Environment(\.presentationMode) var presentationMode
//    @State var ehaPurchased = [Int]()
//    @State var eptaSelected = [Int]()
//    
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
//    @State var selectedEHA: Bool = false
//    @State var selectedEPTA: Bool = false
//    @State var testSelectionSubmitted = [0]
//    @State var showEHAPurchaseSheet: Bool = false
//    @State var ehaPurchsedConfirmed = [Int]()
//    @State var testSelectionSuccessful = [Int]()
//    @State var testEPTASelectionSuccessful = [Int]()
//    @State var numberOfTestsSelected = [Int]()
//    @State var ehaPurchaseTryInt = Int()
//    @State var ehaPurchaseTryArray = [Int]()
//    @State var eptaSelectedTryInt = Int()
//    @State var eptaSelectedTryArray = [Int]()
//    
//    var body: some View {
//        
////        Text("Test Selection View Test")
//
//// Marketing and info on EPTA vs EHA Tests
//// Direction that EHA test be taken in two parts at two different times and days
//
//        VStack(alignment: .leading) {
//            Text("We offer two Tests. The Gold Standard True To Source Enhanced Hearing Assessment (EHA). And, The Exceedingly Valid Informational True To Soure Extended Pure Tone Audiogram (EPTA).")
//                .padding(.leading)
//                .padding(.leading)
//                .padding(.trailing)
//            Text("Which Test Would You Like To Take? ")
//                .padding(.leading)
//                .padding(.leading)
//                .padding(.bottom, 40)
//            Divider()
//                .frame(width: 400, height: 3)
//                .background(.gray)
//                .foregroundColor(.gray)
//            HStack {
//                Spacer()
//                Text("Enhanced Hearing\nEvaluation (EHA)")
//                Spacer()
//                NavigationLink {
//                    EHADescription()
//                } label: {
//                    Text("Learn More Here")
//                        .foregroundColor(.blue)
//                }
//                Spacer()
//            }
//            .padding(.trailing)
//            .padding(.top, 20)
//            .padding(.bottom)
//
////!!!!!!! NEED TO SETUP IN APP PURCHASE HERE
//// In app purchase options
//// Direct to website to purchse physical good options?
////            Button {
////                selectedEHA = true
////                testSelectionSubmitted.replaceSubrange(0..<1, with: [1])
////                showEHAPurchaseSheet.toggle()
////
////            } label: {
////                Text("I Want the Best the Gold Standard! Give Me The EHA!")
////                    .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
//////                    .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
////
////                    .padding(.leading)
////
////            }
////            .padding(.leading)
////            .fullScreenCover(isPresented: $showEHAPurchaseSheet) {
////                EHAPurchaseSheetView()
////            }
////            .padding(.bottom,20)
//           
//
//            Toggle("I Want the Gold Standard! Give Me The EHA!", isOn: $selectedEHA)
//                .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
////                    .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
//                .padding(.leading)
//                .padding(.leading)
//                .padding(.trailing)
//                .padding(.trailing)
//                .onChange(of: selectedEHA) { ehaValue in
//                    if ehaValue == true {
//                        Task {
//                            testSelectionSubmitted.replaceSubrange(0..<1, with: [1])
//                            showEHAPurchaseSheet = true
//                        }
//                    }
//                }
//                .fullScreenCover(isPresented: $showEHAPurchaseSheet, onDismiss: {
//                    showEHAPurchaseSheet = false
//                }, content: {
//                    VStack{
//                        Button {
//                            showEHAPurchaseSheet.toggle()
////                            presentationMode.wrappedValue.dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.title)
//                                .padding(20)
//                                .foregroundColor(.red)
//                        }
//                        Spacer()
//                        Text(" EHA In App Purchase View")
//                        Spacer()
//                        Button {
//                            Task {
//                                await purchasedEHATest()
//                            }
//                        } label: {
//                            Text("Complete Purchase")
//                                .foregroundColor(.mint)
//                        }
//                    }
//                })
////                .fullScreenCover(isPresented: $showEHAPurchaseSheet) {
////                    EHAPurchaseSheetView()
//
////                }
//
//
//
//            Divider()
//                .frame(width: 400, height: 3)
//                .background(.gray)
//                .foregroundColor(.gray)
//            
//            HStack {
//                Spacer()
//                Text("Extended Pure Tone\nAudiogram (EPTA)")
//                Spacer()
//                NavigationLink {
//                    EPTADescription()
//                } label: {
//                    Text("Learn More Here")
//                        .foregroundColor(.blue)
//                }
//                Spacer()
//            }
//            .padding(.trailing)
//            .padding(.top, 20)
//            .padding(.bottom, 20)
//
////            Button {
////                selectedEPTA = true
////                testSelectionSubmitted.replaceSubrange(0..<1, with: [2])
////
////            } label: {
////                Text("I'm Only Interested In Assessing My Hearing. Give me the EPTA")
////                    .foregroundColor(Color(red: 0.6901960784313725, green: 0.5529411764705883, blue: 0.3411764705882353))   // Bronze
////                    .padding(.leading)
////            }
////            .padding(.leading)
////            .padding(.bottom, 20)
//
//            Toggle("I'm Only Interested In Assessing My Hearing. Give me the EPTA", isOn: $selectedEPTA)
//                .padding(.leading)
//                .padding(.leading)
//                .padding(.trailing)
//                .padding(.trailing)
//                .foregroundColor(Color(red: 0.6901960784313725, green: 0.5529411764705883, blue: 0.3411764705882353))
//                .onChange(of: selectedEPTA) { eptaValue in
//                    if eptaValue == true {
//                        Task {
//                            eptaSelected.append(2)
//                            testSelectionSubmitted.replaceSubrange(0..<1, with: [2])
//                            if setupDataModel.userSelectedEPTATest[0] >= 0 {
//                                setupDataModel.userSelectedEPTATest.removeAll()
//                                setupDataModel.userSelectedEPTATest.append(contentsOf: [2])
//                            } else {
//                                setupDataModel.userSelectedEPTATest.append(contentsOf: [2])
//                            }
//                        }
//                    }
//                }
//                .padding(.bottom, 20)
//            
//            Divider()
//                .frame(width: 400, height: 3)
//                .background(.gray)
//                .foregroundColor(.gray)
//            
//            HStack{
//                Spacer()
//                Button {
//                    Task {
//                        await testArrays()
//                        await checkEHALenght()
//                        await checkETPALength()
//                        await confirmEHAPurchase()
//                        await confirmEPTASelection()
//                        await confirmSingleSelection()
//                    }
//                } label: {
//                    Text("Submit Test\nSelection")
//                        .foregroundColor(.blue)
//                }
//                Spacer()
////!!!! Need to setup logic to catch mismatches, nonpurchased but selected EHA and dual or no selection and send user to a splash screen notifying to check selections again, run reset arrays function, and return user to selection screen. NOTE need to account for payment of EHA if it already went through so user does not double pay on second try at selection.
//                //possibly use non standard if else navigation link results
//                
//                NavigationLink(String("Press to\nContinue?")) {
//                    CalibrationAssessmentView()
//                }
//                .foregroundColor(.green)
//                .font(.title2)
//                Spacer()
//            }
//            .padding(.top, 40)
//            .padding(.bottom, 40)
//        }
//    }
//    
//    func purchasedEHATest() async {
//        ehaPurchased.append(1)
//        setupDataModel.userPurchasedEHATest.append(contentsOf: ehaPurchased)
//        print("ehaPruchased: \(ehaPurchased)")
//        print("setupData ehaPurchased: \(setupDataModel.userPurchasedEHATest)")
//    }
//    
//    func testArrays() async {
//        print("ehaPruchased: \(ehaPurchased)")
//        print("setupData ehaPurchased: \(setupDataModel.userPurchasedEHATest)")
//    }
//    
//    func checkEHALenght() async {
//        print(setupDataModel.userPurchasedEHATest)
//        if setupDataModel.userPurchasedEHATest.count <= 0 {
//            print("Array Error in confirmEHAPurchase() in setup.userPurchasedEHATest array")
//        } else if ehaPurchased.count <= 0 {
//            print("Array error in confirmEHAPurchase() in ehaPurchased array")
//        } else if setupDataModel.userSelectedEPTATest.count > 0 {
//            ehaPurchaseTryInt = setupDataModel.userPurchasedEHATest.first!
//            ehaPurchaseTryArray.append(eptaSelectedTryInt)
//            print("Made it to confirmEHAPurchaseLogic, Start Success!!!")
//        } else {
//            print("!!! Error in chechEHALength()")
//        }
//    }
//    
//    func confirmEHAPurchase() async {
//        if ehaPurchaseTryArray.count > 0 {
//            if ehaPurchased[0] == 1 &&  testSelectionSubmitted[0] == 1 {
//                ehaPurchsedConfirmed.append(1)
//                testSelectionSuccessful.append(1)
//                print("sucessful purchase and confirmation of EHA Test. Okay to proceed")
//            } else if ehaPurchased[0] == 0 && testSelectionSubmitted[0] == 1 {
//                ehaPurchsedConfirmed.append(0)
//                testSelectionSuccessful.append(0)
//                print("Error in EHA. Mismatch no purchase but still selected")
//                print("User needs to either complete purchase or unselect EHA and select EPTA")
//            } else if ehaPurchased[0] == 1 && testSelectionSubmitted[0]  != 1 {
//                ehaPurchsedConfirmed.append(1)
//                selectedEHA = true
//                testSelectionSuccessful.append(1)
//                print("Error, user purchased EHA, but did not select it.")
//                print("Apply EHA test as test selection as user paid for it")
//            } else if ehaPurchased[0] == 0 && testSelectionSubmitted[0] != 1 {
//                ehaPurchsedConfirmed.append(0)
//                testSelectionSuccessful.append(0)
//                print("User did not purchase or select EHA")
//            } else {
//                print("!!!ERROR in confirmEHAPurchase Logic")
//            }
//        }
//    }
//    
//    func checkETPALength() async {
//        print(setupDataModel.userSelectedEPTATest)
//        if setupDataModel.userSelectedEPTATest.count <= 0 {
//            print("Array Error in confirmEPTASelection() in setup.userPurchasedEPTATest array")
//        } else if eptaSelected.count <= 0 {
//            print("Array error in confirmEPTASelection() in ehaPurchased array")
//        } else if setupDataModel.userSelectedEPTATest.count > 0 {
//            eptaSelectedTryInt = setupDataModel.userSelectedEPTATest.first!
//            eptaSelectedTryArray.append(eptaSelectedTryInt)
//            print("Made it to confirmEHAPurchaseLogic, Start Success!!!")
//        } else {
//            print("!!! Error in checkEPTALength() ")
//        }
//    }
//    
//    func confirmEPTASelection() async {
//        if eptaSelectedTryArray.count > 0 {
//            if eptaSelected[0] == 2 && testSelectionSubmitted[0]  == 2 {
//                testEPTASelectionSuccessful.append(2)
//                print("Sucessful selection of EPTA test")
//            } else if eptaSelected[0] == 2 && testSelectionSuccessful[0] != 2 {
//                testEPTASelectionSuccessful.append(0)
//                print("Error in EPTA Selection")
//                print("User needs to review selections and submit again")
//            } else if eptaSelected[0] != 2 {
//                testEPTASelectionSuccessful.append(0)
//                print("User did not select EPTA Test")
//            } else {
//                print("!!!Error in confirmEPTASelection Logic")
//            }
//        } else {
//            print("Error in confirmEPTASelection Starting Logic")
//        }
//    }
//    
//    func confirmSingleSelection() async {
//        if selectedEHA == true && selectedEPTA == true {
//            numberOfTestsSelected.append(2)
//            print("!!!Error, user has selected two tests")
//        } else if selectedEHA == true && selectedEPTA == false {
//            numberOfTestsSelected.append(1)
//            print("Success, User only selected one test")
//        } else if selectedEHA == false && selectedEPTA == true {
//            numberOfTestsSelected.append(1)
//            print("Success, User only selected one test")
//        } else if selectedEHA == false && selectedEPTA == false {
//            numberOfTestsSelected.append(0)
//            print("Error, User has not selected a test")
//        } else {
//            print("!!!!Error in confirmingSingleSelection Logic")
//        }
//    }
//
//
//    func resetSelectionArrays() async {
//        selectedEHA = false
//        ehaPurchased.removeAll()
//        eptaSelected.removeAll()
//        ehaPurchaseTryInt = Int()
//        eptaSelectedTryInt = Int()
//        setupDataModel.userPurchasedEHATest.removeAll()
//        testSelectionSubmitted.removeAll()
//        ehaPurchsedConfirmed.removeAll()
//        testSelectionSuccessful.removeAll()
//        selectedEHA = false
//        setupDataModel.userSelectedEPTATest.removeAll()
//        testSelectionSubmitted.removeAll()
//        testEPTASelectionSuccessful.removeAll()
//        numberOfTestsSelected.removeAll()
//    }
//}
//
//////!!!!!!! NEED TO SETUP IN APP PURCHASE HERE
////    // In app purchase options
////        // Direct to website to purchse physical good options?
////// Hardware Purhcase Option
////// Filter Purhcase Option
////// Membership Purchase Option
////
////struct EHAPurchaseSheetView: View {
////
////    @Environment(\.presentationMode) var presentationMode
////
////    var body: some View {
////        VStack{
////
////            Button {
////                presentationMode.wrappedValue.dismiss()
////            } label: {
////                Image(systemName: "xmark")
////                    .font(.title)
////                    .padding(20)
////                    .foregroundColor(.red)
////            }
////
////            Spacer()
////            Text(" EHA In App Purchase View")
////            Spacer()
////
//  
//
//
//struct TestSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionView()
//    }
//}
