//
//  PostTestDirectorSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostTestDirectorSplashView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
           
                Text("There Was An Issue Identifying The Test Type Take and Directing You To Those Results")
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
                    PostAllTestsSplashView()
                } label: {
                    
                    VStack {
                        Text("Return to Post Test Screen")
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

//struct PostTestDirectorSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostTestDirectorSplashView()
//    }
//}
