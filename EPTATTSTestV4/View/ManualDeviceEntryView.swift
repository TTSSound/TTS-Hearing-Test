//
//  ManualDeviceEntryView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct ManualDeviceEntryView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
//    @EnvironmentObject var deviceSelectionModel: DeviceSelectionModel
//    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
    @StateObject var manualDeviceSelectionModel: ManualDeviceSelectionModel = ManualDeviceSelectionModel()
    @State var deviceBrand: String = ""
    @State var deviceModel: String = ""
    @State var manualUserDataSubmitted = Bool()
    @State var manColors: [Color] = [Color.clear, Color.green]
    @State var manLinkColorIndex = 0
    @State var showManualSplashSheet = Bool()

    var body: some View {
    
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
            VStack(alignment: .leading) {
                
                HStack{
                    Spacer()
                    Text("Manual Device Entry")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .padding(.top, 40)
                .padding(.bottom, 40)

                Text("Complete Each Field Below For The\n   Earphones, or\n   Headphones, or\n   In-Ear Monitors\nYou Will Use For This Test.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
      

                Text("Enter Your Ear / Headphones Brand")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)
                    .padding(.top)
                    
                    
                
                HStack{
                    Text("Device Brand")
                        .foregroundColor(.white)
                    TextField("Enter Brand", text: $deviceBrand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom)
                
            
                Text("Enter Your Ear / Headphones Model")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)

                HStack{
                    Text("Device Model")
                        .foregroundColor(.white)
                    TextField("Enter Model", text: $deviceModel)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
               
                
                Spacer()
                HStack{
                    Button {
                        Task(priority: .userInitiated, operation: {
                            await areDMFieldsEmpty()
                            await appendManualDeviceData()
                            await concantenateFinalManualDeviceArrays()
                            await saveManualDeviceData()
//                            await transmitManualDeviceData()
                            print("FIGURE OUT HOW TO EMAIL RESULTS")
                        })
                    } label: {
                        VStack{
                            Text("Submit Email Transmit Data Append Data")
                                .foregroundColor(.green)
                                .padding()
                            Image(systemName: "arrow.up.doc.on.clipboard")
                                .foregroundColor(.green)
                        }
                    }

                    NavigationLink(destination:
                                    manualUserDataSubmitted == true ? AnyView(InstructionsForTakingTest())
                                    : manualUserDataSubmitted == false ? AnyView(ManualDeviceEntryIssueSplashView())
                                    : AnyView(ManualDeviceEntryIssueSplashView())
                    ){  VStack{
                        Text("Continue to\nDevice Setup")
                            .foregroundColor(manColors[manLinkColorIndex])
                            .padding()
                        Image(systemName: "arrowshape.bounce.right")
                            .foregroundColor(manColors[manLinkColorIndex])
                        }
                    .padding()
                    }
                }
                Spacer()
            }
            .onAppear {
                Task(priority: .userInitiated) {
                    manualUserDataSubmitted = false
                    manLinkColorIndex = 0
                }
            }
        }
        .environmentObject(manualDeviceSelectionModel)
    }
    //!!!!!!!!! STILL NEEDED
    // DETERMINE HOW TO USE Function to email brand model to company
    
    func areDMFieldsEmpty() async {
        if deviceBrand.count > 0 && deviceModel.count > 0 {
            manualUserDataSubmitted = true
            manLinkColorIndex = 1
            print("Device and Model Field Completed")
        } else if deviceBrand.count <= 0 && deviceModel.count > 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Device Field Empty, But Model Field Filled")
        } else if deviceBrand.count > 0 && deviceModel.count <= 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Device Field Completed, But Model Field Empty")
        } else if deviceBrand.count <= 0 && deviceModel.count <= 0 {
            manualUserDataSubmitted = false
            showManualSplashSheet = true
            manLinkColorIndex = 0
            print("Both Device and Model Fields Are Empty")
        } else {
            showManualSplashSheet = true
            manLinkColorIndex = 1
            print("!!!Error in areDMFieldsEmpty() Logic")
        }
    
    }
    
    func appendManualDeviceData() async {
        manualDeviceSelectionModel.userBrand.append(deviceBrand)
        manualDeviceSelectionModel.userModel.append(deviceModel)

        print("Brand: \(deviceBrand)")
        print("Model: \(deviceModel)")
        print("setupData userBrand: \(manualDeviceSelectionModel.userBrand)")
        print("setupDate userModel: \(manualDeviceSelectionModel.userModel)")
    }
    
    func concantenateFinalManualDeviceArrays() async {
        manualDeviceSelectionModel.finalManualDeviceBrand.append(contentsOf: manualDeviceSelectionModel.userBrand)
        manualDeviceSelectionModel.finalManualDeviceModel.append(contentsOf: manualDeviceSelectionModel.userModel)
        print("manualDeviceSelectionModel finalManualDeviceBrand: \(manualDeviceSelectionModel.finalManualDeviceBrand)")
        print("manualDeviceSelectionModel finalManualDeviceModel: \(manualDeviceSelectionModel.finalManualDeviceModel)")
    }
    
//    func transmitManualDeviceData() async {
//        print("!!!!!!!Still need to figure out how to email data results")
//        // NEED TO FIGURE OUT HOW TO DO THIS
//    }
    
    func saveManualDeviceData() async {
        await manualDeviceSelectionModel.getManualDeviceData()
        await manualDeviceSelectionModel.saveManualDeviceToJSON()
        await manualDeviceSelectionModel.writeManualDeviceResultsToCSV()
        await manualDeviceSelectionModel.writeInputManualDeviceResultsToCSV()
    }
}

//struct ManualDeviceEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceEntryView()
//            .environmentObject(ManualDeviceSelectionModel())
//    }
//}
