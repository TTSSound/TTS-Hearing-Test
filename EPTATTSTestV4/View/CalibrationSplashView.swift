//
//  CalibrationSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI


// ADD BUTTON TO RETURN TO HOME SCREEN

struct CalibrationSplashView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
//    @EnvironmentObject var deviceSelectionModel: DeviceSelectionModel
    
    
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all)
            
            ScrollView{
                Text("Non-Calibrated Equipment Notice\n")
                    .multilineTextAlignment(.center)
                    .font(.title)
                Text("It appears your testing setup is not yet calibrated for use in our tests. Taking any hearing test with uncalibrated equipment not only produces invalid results, but also causes you direct harm. At TTS we are committed to solving this problem, not enabling it by allowing invalid test completion, such that we may benefit at your expense.\n\n\n Fortunately, we have a few options that will afford you the opportunity to take a valid and calibrate test, which will yield meaningful and accurate results you can depend on.\n\n")
                Text("1. Our first recommendation for your consideration is the TTS ship to home calibrated testing system <INSERT LINK TO WEBSITE>. While this service is not free, we must let you know that this service actually costs TTS the most to deliver and we are in no way trying to upsell you.\n\n\n While it is expensive for our company to offer this service, it provides the highest degree of calibration available and therefore yields the most accurate results. This is why we continue to offer it.\n\n\n It also provides an introduction to afforable high-end, audiophile, systems, which we are passionate about and love sharing that passion with the world. If you select this route, you have the additional opportunity to trial afforable audiophile gear and hear music like you have never heard before.\n\n\n If you like what you hear, you are welcome to buy the system at a reduced price, use it for future hearing retests, also at a heavily discounted price, and for your everyday listening pleasure.\n\n Alternatively, you can return the system back to us after completing your test.\n\n")
                Text("2. Our second recommendation is for you to submit a request to have your device calibrated for testing. Upon receiving your request, we purchase multiple sets of your specific equipment and evaluate the devices against our calibration standards. If the product is of sufficient aural quality and has tight quality control between different units, we can complete our calibration procedure. After calibration is complete, we add the device to our list of approved calibrated equipment and notify you. At that point you can take our test knowing you are using a calibrate system that will yield valid and meaningful results you can depend on.\n\n")
                Text("3. Our third recommendation is for you to review the list of approved calibrate devices <INSERT LINKE TO APPROVED LIST> and see if you know anyone willing to lend you their pair of approved headphones for use in taking the test. Alternatively, if a particular approved device catches your interest, you are welcome to acquire your own pair and then complete the test with a calibrate system that will yield valid and meaningful results you can depend on.\n\n NOTE: TTS has no partnership or marketing agreements with the companies listed on our approval list and does not profit in anyway if you purchase a pair of approved headphones!\n\n")
                Text("It is unfortunately not possible for you to complete the TTS hearing tests with your current setup. We hope you consider acting on one of our recommendations, such that you may complete our tests and receive the benefits they have affored to so many.\n\n <LINK TO COMPANY WEBISTE>\n\n <LINK TO APPROVED DEVICE LIST>")
                Spacer()
                HStack {
                    NavigationLink {
                        LandingView()
                    } label: {
                        HStack {
                            Text("Return\n Home")
                            Image(systemName: "house")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.top, 20.0)
                    .padding([.top, .bottom, .trailing])
                    .padding(.leading, 5.0)
                    Spacer()
                    NavigationLink {
                        CalibrationAssessmentView()
                    } label: {
                        HStack {
                            Text("Return to Device Selection")
                            Image(systemName: "arrowshape.turn.up.backward.2")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.top, 20.0)
                    .padding([.top, .leading, .bottom])
                    .padding(.trailing, 5.0)
                }
            }
            .padding(.all)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .foregroundColor(.white)
        }
    
    }
}

//struct CalibrationSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalibrationSplashView()
//  //            .environmentObject(DeviceSelectionModel())
//    }
//}
