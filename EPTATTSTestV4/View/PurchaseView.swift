//
//  PurchaseView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct PurchaseView: View {
    var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("Post Test Up-Sell Purchase View")
                    .foregroundColor(.white)
                    .padding(.bottom,80)
                // EHA Purchase Option
                // Hardware Purhcase Option
                // Filter Purhcase Option
                // Membership Purchase Option
                
                NavigationLink {
                    ClosingView()
                } label: {
                    Text("In Conclusion")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

//struct PurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        PurchaseView()
//    }
//}
