//
//  SilentModeSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct SilentModeSetupView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    @State var silentSetting = false
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(spacing: 5) {
                Text("First, We Must Ensure Device is Not Silenced")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("Complete The Following Steps:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 35.0)
                Spacer()
                Text("1. Locate the silence switch on the left side of your device.\n 2. With your finger, flip the switch to the upper position.\n 3. Look at the switch and confirm you do NOT see a red strip.\n 4. If you can see red at the switch, your device is still silenced!\n 5. If red is still visible, flip the switch in the opposite position.\n 6. Confirm you no longer see a red strip at the switch.\n 7. Mark this step as complete with the switch below, then select the Silence Tab.")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading, .trailing])
                Spacer()
                Toggle(isOn: $silentSetting) {
                    Text("Select When Silent Mode is Disabled")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                        .padding(.all)
                        .shadow(radius: 5)
                }
                .padding(.trailing, 30.0)
                Spacer()
            }
        } 
     }
}

//struct SilentModeSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SilentModeSetupView()
//    }
//}
