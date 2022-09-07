//
//  SimpleTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/1/22.
//

import SwiftUI

struct SimpleTestView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("Holding Place for Simple Test View")
                    .foregroundColor(.white)
                // EHA Purchase Option
                // Hardware Purhcase Option
                // Filter Purhcase Option
                // Membership Purchase Option
                
                NavigationLink {
                    PostAllTestsSplashView()
                } label: {
                    Text("In Conclusion")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

//struct SimpleTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTestView()
//    }
//}
