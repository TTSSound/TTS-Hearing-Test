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
                        .padding(.bottom, 20)
                    NavigationLink  {
                        CalibrationSplashView()
                    } label: {
                        VStack {
                            Text("If You Would Prefer To Have Analytical Test Results, Review Our List Of Recommendations For Those That Do Not Already Own a Pair Of Calibrated Ear/Headphones")
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                                .padding(.trailing)
                                .foregroundColor(.white)
                            HStack{
                                Spacer()
                                Image(systemName: "arrowshape.turn.up.backward.2")
                                    .font(.title)
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 300, height: 200, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(24)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink {
                        ManualDeviceDisclaimerView()
                    } label: {
                        VStack {
                            Text("If Your Are Interested In Continuing With An Uncalibrated Test, Proceed To Enter Your Device Information and Review The Corresponding Agreement")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding(.trailing)
                                .padding(.leading)
                            HStack{
                                Spacer()
                                Image(systemName: "arrowshape.bounce.right")
                                    .foregroundColor(.blue)
                                    .font(.title)
                                Spacer()
                            }
                        }
                        .frame(width: 300, height: 200, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(24)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                .padding(.leading)
                .padding(.trailing)
                .cornerRadius(24)
                .background(.clear)
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
