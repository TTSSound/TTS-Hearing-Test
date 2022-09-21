//
//  TestSelectionSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct TestSelectionSplashView: View {
    
    var colorModel:ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all)
            VStack {
                Spacer()
                Text("There Seems To Be An Error In Your Test Selection")
                    .foregroundColor(.white)
                    .font(.title)
                    .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .brightness(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom, 40)

                    
                VStack(alignment: .leading, spacing: 20) {
                    Text("Please Return To The Test Selection Screen")
                        .foregroundColor(.white)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .brightness(4.0)
                        .padding(.leading)
                        .padding(.trailing)
         
                    Text("Confirm You Only Have One Test Selected")
                        .foregroundColor(.white)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .brightness(4.0)
                        .padding(.leading)
                        .padding(.trailing)

                    Text("And, That The Test Selected Is The Test You Want")
                        .foregroundColor(.white)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .brightness(4.0)
                        .padding(.leading)
                        .padding(.trailing)
                    Text("And, Make Sure To SUBMIT SELECTION")
                        .foregroundColor(.white)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .brightness(4.0)
                        .padding(.leading)
                        .padding(.trailing)
                }
                
                

                Spacer()
                NavigationLink {
                    TestSelectionView()
                } label: {
                    HStack{
                        Spacer()
                        Text("Return To Test Selection")
                        Spacer()
                        Image(systemName: "arrowshape.turn.up.backward.2")
                        Spacer()
                    }
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(24)
                }
                .padding(.bottom, 20)
              
            }
        }
    }
}
//
//struct TestSelectionSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionSplashView()
//    }
//}
