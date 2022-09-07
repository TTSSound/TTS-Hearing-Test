//
//  RestultsDisplay.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct SimpleResultsDisplayView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                
                Text("Holding Place To Display Simple Test Bogus Non-Calibrated Results")
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink {
                    PurchaseView()
                } label: {
                    Text("What's Next?")
                        .foregroundColor(.green)
                }
                Spacer()
            }
        }
    }
}

//struct RestultsDisplay_Previews: PreviewProvider {
//    static var previews: some View {
//        RestultsNonCalibratedDisplayView()
//    }
//}
