//
//  ManualSetupInstructionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/3/22.
//

import SwiftUI

struct ManualSetupInstructionView: View {
    
    var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                ScrollView{
                    Text("1. Check the left side of your phone for the silence switch and with your finger, flip it to the upper position. If you can see red at the switch, your device is still silenced and you need to flip the switch.")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .bottom, .trailing])
                    Text("2. Place your finger in the upper right corner of your screen and swipe down. On the new screen that appears, select the Focus button, which has a moon next to it.")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading, .trailing])
                    Text("3. Using the volume buttons on the left side of your phone, press the top buttone to turn your device's volume all the way up. Then.....")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.all)
                    Text("4. Find the lower volume button on the left side of your phone. Press the volume down button 6 times")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .bottom, .trailing])
                    Text("5. After making these changes, press the 'Test Settings' button below, which will confirm your device is configured for a calibrated and valid test. ")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .bottom, .trailing])
                    Text("6. If an issue is found when testing your device settings, you will be notified of what setting requires further adjustment.")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .bottom, .trailing])
                }
                .padding(.horizontal)
                Spacer()
                VStack{
                    NavigationLink {
                        TestDeviceSetupView()
                        } label: {
                        Text("Click To Continue To Confirm Device Settings")
                            .fontWeight(.heavy)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .padding(.all)
                        }
                        .padding([.leading, .bottom])
                }
                .frame(width: 350, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

//struct ManualSetupInstructionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualSetupInstructionView()
//    }
//}
