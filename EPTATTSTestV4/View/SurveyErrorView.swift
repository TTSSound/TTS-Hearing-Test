//
//  SurveyErrorView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct SurveyErrorView: View {
 
    @StateObject var colorModel: ColorModel = ColorModel()

    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Please hit BACK and confirm you selected submit survey at the bottom of the survey")
                    .foregroundColor(.white)
                    .font(.title)
                    .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .brightness(4.0)
                Spacer()
            }
        }
    }
}

//struct SurveyErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        SurveyErrorView()
//    }
//}
