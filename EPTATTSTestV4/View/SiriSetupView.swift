//
//  SiriSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct SiriSetupView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 10) {
                Text("To Ensure Your Device is Setup Properly, Three Steps Need To Be Completed.\n\nAfter completing step 3, access the final 4th setp to test your device and confirm it is setup properly. If there is an issue, we'll notify you.")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top, 40)
                Spacer()
                HStack{
                    Spacer()
                    Text("If you would prefer to complete all steps manually, press below.")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom, 20)
                HStack{
                    Spacer()
                    NavigationLink {
                        ManualSetupView()
                    } label: {
                        Text("Manual Device Setup Instructions")
                            .frame(width: 300, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(.blue)
                            .opacity(0.6)
                            .cornerRadius(24)
                    }
                    Spacer()
                }
                Divider()
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: SilentModeSetupView()) {
                        VStack{
                        Image(systemName: "1.square.fill")
                            .foregroundColor(.white)
                        Text("Silence Mode")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: DNDSiriSetupView()) {
                        VStack{
                        Image(systemName: "2.square.fill")
                            .foregroundColor(.white)
                        Text("Don't Distrub")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: SystemVolumeView()) {
                        VStack{
                        Image(systemName: "3.square.fill")
                            .foregroundColor(.white)
                        Text("Set Volume")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: TestDeviceSetupView()) {
                        VStack{
                        Image(systemName: "4.square.fill")
                            .foregroundColor(.white)
                        Text("Test Setup")
                            .font(.footnote)
                            .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
        }
     }
}


//struct SiriSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SiriSetupView()
//    }
//}
