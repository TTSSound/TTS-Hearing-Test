//
//  DNDSiriSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct DNDSiriSetupView: View {
    var colorModel: ColorModel = ColorModel()
    @State var doNotDisturbSetting = false
    
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("Next, We Higly Recommend Turning On Do Not Disturb!")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .bottom, .trailing])
                Text("We don't want alerts and other device distractions interrupting your test. If this occurs, your test results will be invalid")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading, .trailing])
                Text("Let's use Siri to Complete This Step!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 35.0)
                Text("Press and hold the power button on the right side of your phone for 1 second and you heard a chime. Release the power button and say:")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding([.top, .leading, .trailing])
                Text("HEY SIRI, TURN ON DO NOT DISTURB!")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                Toggle(isOn: $doNotDisturbSetting) {
                    Text("Select When Do Not Disturb is Enabled")
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

//struct DNDSiriSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DNDSiriSetupView()
//    }
//}
