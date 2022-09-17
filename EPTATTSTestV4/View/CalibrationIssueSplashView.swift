//
//  CalibrationIssueSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct CalibrationIssueSplashView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
//    @EnvironmentObject var deviceSelectionModel: DeviceSelectionModel
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Spacer()
            
                Text("Device Selection Issue. Please Return To Device Selection and Try Again.")
                    .foregroundColor(.white)
                    .font(.title)
                    .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .brightness(4.0)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top, 20)
//                    .padding(.bottom, 20)
                
                
            
                Spacer()
                NavigationLink {
                    CalibrationAssessmentView()
                } label: {
                    
                    VStack {
                        Text("Return to\nDevice Selection")
                            .foregroundColor(.blue)
                            .font(.title)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        Image(systemName: "arrowshape.turn.up.backward.2")
                            .foregroundColor(.blue)
                            .font(.title)
                            .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.bottom, 20)
                }
                Spacer()
            }
        }
    }
}

//struct CalibrationIssueSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalibrationIssueSplashView()
//    //            .environmentObject(DeviceSelectionModel())
//    }
//}
