//
//  EHAResultsDisplayView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct EHAResultsDisplayView: View {
    var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Holding Place To Display Full EHA Results")
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

//struct EHAResultsDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAResultsDisplayView()
//    }
//}
