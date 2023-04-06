//
//  LandingView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

// First Screeen
// Landing View


// Thank you for trusting TTS to deliver valid, proven, and superior hearing tests
// and innovative corrective hearing filtes (need new name)


// Before we go any further, we need to talk about a few things


// 1. What this test is and is not
// 2. TTS mission to provide valid test results
// 3. The harm caused by invalid or non-calibrated test results
// 4. The importance of calibration and what it is
// 5. Why we ask what devices you are using, our list of calibrated devices that is ever going
    // and why we will not let you take our test without a calibrated valid setup
        // we will not contribute to pseudo science and invalid health results that cause harm to the user
    // How this test can be complete if you don't own already calibrated equipment
    // How to submit a request to have your device(s) calibrated for testing
// 6. The type of tests offered and why you would want one over the other
// 7. What to expect as you complete this test
// 8. Importance of Device Setup Process
// 9. How long this will take

// Imbed Link to Video covering those topics above


// Immediately ask user to select the device they are using from the approved calibrated list
    // If their device is not on the list. Ask them to input the device and request TTS calibrate it for testing
    // Offer upsell for ship to home offering to complete the test




// Go To Next Screen--Disclaimer


import SwiftUI


//MARK: - LandingView
struct LandingView: View {
    
    @StateObject var colorModel = ColorModel()
    @State var selectedTabe = 1
    @State var selectedTab: Int = 0
    
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack{
                colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                    VStack(alignment: .leading, spacing: 20) {
                        Text("-------------------------------------------")
                            .foregroundColor(colorModel.textMain)
                        Text("Replace This Text With Small Opening")
                            .foregroundColor(colorModel.textMain)
                        Text("Thank you for trusting TTS to deliver valid, proven, and superior hearing tests and innovative corrective hearing filtes (need new name)")
                            .foregroundColor(colorModel.textMain)
                        Text("Before we go any further, we need to gather some basic information and discuss a few things about the TTS hearing test and advanced corrective filters")
                            .foregroundColor(colorModel.textMain)
                        Spacer()
                    }
                    .padding()
            }
//            .tabItem {
//                Image(systemName: "house")
//                    .foregroundColor(colorModel.tabColorMain)
//                Text("Home")
//                    .foregroundColor(colorModel.tabColorMain)
//            }
//            .tag(0)
//            
//            BetaTestingLandingView()
//            .tabItem {
//                Image(systemName: "ear.fill")
//                    .accentColor(colorModel.tiffanyBlue)
//                Text("Start")
//                    .foregroundColor(colorModel.proceedColor)
//                    .background(colorModel.proceedColor)
//                
//            }
//            .tag(1)
//            
//            DisclaimerView(selectedTab: $selectedTab)
//            .tabItem {
//                Image(systemName: "arrowshape.zigzag.right.fill")
//                    .accentColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
//                Text("Start")
//                    .foregroundColor(colorModel.proceedColor)
//                    .background(colorModel.proceedColor)
//            }
//            .tag(2)
        }
    }
}
          



//struct LandingView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        LandingView()
//
//    }
//}
