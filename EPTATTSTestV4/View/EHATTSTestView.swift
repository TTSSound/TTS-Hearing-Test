//
//  EHATTSTestView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI

struct EHATTSTestView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("EHA Test View")
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink {
                    PostEHATestView()
                } label: {
                    Text("Continue To See Results")
                        .foregroundColor(.green)
                }
                Spacer()
            }
        }
    }
}

//struct EHATTSTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHATTSTestView()
//    }
//}
