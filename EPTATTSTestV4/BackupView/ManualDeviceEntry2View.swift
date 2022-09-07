//
//  ManualDeviceEntry2View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

//import SwiftUI
//
//struct ManualDeviceEntry2View: View {
//
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
//    
//    @State var brand = String()
//    @State var model: String = ""
//    
//    var body: some View {
//        
//        VStack(alignment: .center, spacing: 20) {
//            Text("ManualDeviceEntry2View")
//                .padding(.top, 40.0)
//                .padding(.bottom, 40.0)
//   
//            Text("Before entering your device information, you need to know a few things!\nPop up about results being provided, but different. Not valid with units of dBHL, but rater relative units of compared to or a % of the system output at 1kHz. Might be nice to see a trend, but cannot use it for much more than curosity.")
//            
//            Text("Additional User Agreement and Disclosure Popup")
//            Spacer()
//            
//            Text("Complete Each Field Based On The Ear/Headphones You Want To Use For This Test")
//                .foregroundColor(.black)
//                .padding(.leading, 0.0)
////                .padding(.top, 20.0)
////                .padding(.bottom, 20.0)
//
//            HStack {
//                Spacer()
//                VStack(alignment: .center, spacing: 10) {
//                Text("Enter Your Ear/Headphones Brand")
//                    .foregroundColor(.black)
//
//          
//                TextField("Brand of Ear/Headphones", text: $brand)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.leading, 42.0)
//                
//                }
//                Spacer()
//                VStack{
//                    Text("Enter Your Ear/Headphones Model")
//                        .foregroundColor(.black)
//                        .padding(.trailing, 30.0)
//                      
//                      
//                    TextField("Model of Ear/Headphones", text: $model)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.leading, 30.0)
//
//                    }
//                Spacer()
//            }
//    
//            HStack{
//                Spacer()
//                Button {
//                    Task {
//                        await appendManualDeviceData()
//                        await transmitManualDeviceData()
//                    }
//                } label: {
//                    Text("Submit/Email\nTransmitData\nAppendData")
//                }
//
//                
//                Spacer()
//                NavigationLink(String("Press to\nContinue")) {
//                    SiriSetupView()
//                }
//                Spacer()
//            }
//        Spacer()
//
//                
////!!!!!!!!! STILL NEEDED
//// DETERMINE HOW TO USE Function to email brand model to company
//
//
//        }
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
//        
//        // NEED TO FIGURE OUT HOW TO DO THIS
//    }
//}

//struct ManualDeviceEntry2View_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceEntry2View()
//    }
//}
