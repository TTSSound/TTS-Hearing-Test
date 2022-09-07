//
//  WelcomeSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/19/22.
//

import SwiftUI
import MediaPlayer

struct ManualSetupView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
 
            VStack(){
                Text("If The Prior System Setup Using Siri Did Not Work, Here is a Manual Setup Process")
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Text("This involves three steps!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                Text("1. Ensure your device is not silenced!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                Text("This can prevent the evaluation from running properly")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1.0)
                    .padding(/*@START_MENU_TOKEN@*/.trailing, 30.0/*@END_MENU_TOKEN@*/)
                Text("2. Turn on Do Not Disturb!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 105.0)
                    .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                Text("We don't want your test to be interrupted by an alert.")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(/*@START_MENU_TOKEN@*/.leading, 39.0/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 1.0)
                    .padding(/*@START_MENU_TOKEN@*/.trailing, 38.0/*@END_MENU_TOKEN@*/)
                Text("3. Manually setting your devices volume to the correct level.")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(/*@START_MENU_TOKEN@*/.leading, 30.0/*@END_MENU_TOKEN@*/)
                    .padding(/*@START_MENU_TOKEN@*/[.top, .trailing]/*@END_MENU_TOKEN@*/)
                Text("This ensures test calibration and validity")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                    .padding(/*@START_MENU_TOKEN@*/.top, 1.0/*@END_MENU_TOKEN@*/)
                NavigationLink {
                    ManualSetupInstructionView()
                } label: {
                    Text("Click to continue for instructions on how to manually complete each of these three actions:")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 80.0)
                        .padding(/*@START_MENU_TOKEN@*/.trailing, 15.0/*@END_MENU_TOKEN@*/)
                        .padding(/*@START_MENU_TOKEN@*/.leading, 29.0/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}


//struct ManualSetupInstructionView: View {
    
//    @StateObject var colorModel: ColorModel = ColorModel()
////    @EnvironmentObject var systemSettingsModel: SystemSettingsModel
//    
//    var body: some View {
//        ZStack{
//            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
//            VStack(alignment: .leading, spacing: 10) {
//                ScrollView{
//                    Text("1. Check the left side of your phone for the silence switch and with your finger, flip it to the upper position. If you can see red at the switch, your device is still silenced and you need to flip the switch.")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.leading, .bottom, .trailing])
//                    Text("2. Place your finger in the upper right corner of your screen and swipe down. On the new screen that appears, select the Focus button, which has a moon next to it.")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.top, .leading, .trailing])
//                    Text("3. Using the volume buttons on the left side of your phone, press the top buttone to turn your device's volume all the way up. Then.....")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding(.all)
//                    Text("4. Find the lower volume button on the left side of your phone. Press the volume down button 6 times")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.leading, .bottom, .trailing])
//                    Text("5. After making these changes, press the 'Test Settings' button below, which will confirm your device is configured for a calibrated and valid test. ")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.leading, .bottom, .trailing])
//                    Text("6. If an issue is found when testing your device settings, you will be notified of what setting requires further adjustment.")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.leading, .bottom, .trailing])
//                }
//                .padding(.horizontal)
//                Spacer()
//                VStack{
//                    NavigationLink {
//                        TestDeviceSetupView()
//                        } label: {
//                        Text("Click To Continue To Confirm Device Settings")
//                            .fontWeight(.heavy)
//                            .foregroundColor(.green)
//                            .multilineTextAlignment(.center)
//                            .padding(.all)
//                        }
//                        .padding([.leading, .bottom])
//                }
//                .frame(width: 350, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
//            }
//        }
//    }
//}
//
//struct ManualSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualSetupView()
//    }
//}


