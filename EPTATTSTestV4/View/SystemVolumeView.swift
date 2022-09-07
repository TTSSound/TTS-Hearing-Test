//
//  SystemVolumeView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct SystemVolumeView: View {
    @State var systemVolumeSetting = false
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("Next, We Your Help Setting The Proper Volume.")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text("We need this to meet our calibration specifications and produce valid results.")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                Text("Let's use Siri again!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                Text("Press and hold the power button on the right side of your phone for 1 second and you heard a chime. Release the power button and say:")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading, .trailing])
                Text("HEY SIRI, TURN THE VOLUME TO 63 PERCENT!")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(23.0)
                Toggle(isOn: $systemVolumeSetting) {
                    Text("Select When System Volume Is Changed To 63%")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                        .padding(.all)
                        .shadow(radius: 5)
                }
                Spacer()
            }
        }
    }
}

//struct SystemVolumeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SystemVolumeView()
//            .environmentObject(SystemSettingsModel())
//    }
//}
