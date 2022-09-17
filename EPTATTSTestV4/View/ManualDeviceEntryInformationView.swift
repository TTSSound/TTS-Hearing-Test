//
//  ManualDeviceEntryInformationScreen.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct ManualDeviceEntryInformationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var colorModel: ColorModel = ColorModel()


  
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundTopRed.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                ScrollView {
                    Text("Pop up about results being provided, but different. Not valid with units of dBHL, but rater relative units of compared to or a % of the system output at 1kHz. Might be nice to see a trend, but cannot use it for much more than curosity.\nRecommend reviewing non-calibrated device options first, before proceeding with manual device submission.\n\n If this is agreeable to you, review our Manual Device Disclosure form and proceed with entering your information and completing the test")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                }
                .frame(width: 375, height: 350, alignment: .leading)
                .background(.clear)

                NavigationLink  {
                    CalibrationSplashView()
                } label: {
                    VStack {
                        Text("If You Would Prefer To Have Analytical Test Results, Review Our List Of Recommendations For Those That Do Not Already Own a Pair Of Calibrated Ear/Headphones")
                            .foregroundColor(.green)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.trailing)
                        HStack{
                            Spacer()
                            Image(systemName: "arrowshape.turn.up.backward.2")
                                .foregroundColor(.green)
                                .font(.title)
                            Spacer()
                        }
                    }
                }

                NavigationLink {
                    ManualDeviceDisclaimerView()
                } label: {
                    VStack {
                        Text("If Your Are Interested In Continuing With An Uncalibrated Test, Proceed To Enter Your Device Information and Review The Corresponding Agreement")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing)
                        HStack{
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                                .foregroundColor(.blue)
                                .font(.title)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
        }

        
    }
}

//struct ManualDeviceEntryInformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceEntryInformationView()
//    }
//}
