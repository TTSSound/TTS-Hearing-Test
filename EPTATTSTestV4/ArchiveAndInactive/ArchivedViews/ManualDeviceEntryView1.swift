//
//  ManualDeviceEntryView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

//import SwiftUI

// NEED TO LINK THIS VIEW IN THE SPLASH PAGE INFO

// NEED TO CREATE A WARNING HERE ON MANUAL ENTRY AND PROCEEDING, POSSIBLY NOTING RESULTS WILL BE MARKED UNCALIBRATED UNREFERENCED ASSESSMENT, POSSIBLY A GRAPH WILL BE PROVIDED WITHOUT ACTUAL HLDB, JUST RELATIVE TO ONE AND OTHER IN % OF SYSTEM GAIN...MEANINGLESS

// PROVIDE RECOMMENDATION THAT THEY REVIEW THE SPLASH PAGE BEFORE SUBMITTING DEVICE INFO AND OR PROCEEDING

//struct ManualDeviceEntryView1: View {
//
//    @StateObject var colorModel: ColorModel = ColorModel()
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
//
//    @State var brand = String()
//    @State var model: String = ""
//    @State var manualUserDataSubmitted = Bool()
//
//    @State var manColors: [Color] = [Color.clear, Color.green]
//    @State var manLinkColorIndex = 0
//
//    var body: some View {
//
//        ZStack{
//            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Manual Device Entry")
//                    .foregroundColor(.white)
//                    .foregroundColor(.black)
//                    .padding(.leading)
//                Text("Complete Each Field Based On The Ear/Headphones You Want To Use For This Test")
//                    .foregroundColor(.white)
//                    .foregroundColor(.black)
//                    .padding(.leading)
//    //                .padding(.top, 20.0)
//    //                .padding(.bottom, 20.0)
//
//                VStack {
//                    Text("Enter Your Ear/\nHeadphones Brand")
//                        .foregroundColor(.white)
//                    Spacer()
//                    TextField("Brand", text: $brand)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .foregroundColor(.blue)
//
//                    Spacer()
//                }
//                .padding(.leading)
//
//                VStack{
//                    Text("Enter Your Ear/\nHeadphones Model")
//                        .foregroundColor(.white)
//                    Spacer()
//                    TextField("Model", text: $model)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                            foregroundColor(.blue)
//                    Spacer()
//                    }
//                .padding(.leading)
////            Spacer()
//                HStack{
//                    Spacer()
//                    Button {
//                        Task {
//                            manualUserDataSubmitted = true
//                            manLinkColorIndex = 1
//                            await appendManualDeviceData()
//                            await transmitManualDeviceData()
//                            print("FIGURE OUT HOW TO EMAIL RESULTS")
//                        }
//                    } label: {
//                        HStack{
//                            Text("Submit/Email\nTransmitData\nAppendData")
//                                .foregroundColor(.blue)
//                                .padding(.leading)
//                            Image(systemName: "arrow.up.doc.on.clipboard")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    Spacer()
//                    NavigationLink(destination:
//                                    manualUserDataSubmitted == true ? AnyView(ReadyForSiriSetup())
//                                    : manualUserDataSubmitted == false ? AnyView(ManualDeviceDisclaimerView())
//                                    : AnyView(ManualDeviceDisclaimerView())
//                    ){  VStack{
//                        Text("Continue to\nDevice Setup")
//                            .foregroundColor(manColors[manLinkColorIndex])
//                        Image(systemName: "arrowshape.bounce.right")
//                            .foregroundColor(manColors[manLinkColorIndex])
//                        }
//                    }
//
//                    Spacer()
//                }
//                .padding(.leading)
//                .padding(.bottom, 60)
//            }
//            .onAppear {
//                manualUserDataSubmitted = false
//                manLinkColorIndex = 0
//            }
//        }
//
////!!!!!!!!! STILL NEEDED
//// DETERMINE HOW TO USE Function to email brand model to company
//
//
//    }
//
//    func appendManualDeviceData() async {
//        setupDataModel.userBrand.append(brand)
//        setupDataModel.userModel.append(model)
//
//        print("Brand: \(brand)")
//        print("Model: \(model)")
//        print("setupData userBrand: \(setupDataModel.userBrand)")
//        print("setupDate userModel: \(setupDataModel.userModel)")
//    }
//
//    func transmitManualDeviceData() async {
//        print("!!!!!!!Still need to figure out how to email data results")
//        // NEED TO FIGURE OUT HOW TO DO THIS
//    }
//}

//struct ManualDeviceEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceEntryView()
//    }
//}
