//
//  ResultsDisplayView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI

struct EPTAResultsDisplayView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Holding Place To Display EPTA Results")
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

//struct ResultsDisplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsDisplayView()
//    }
//}
