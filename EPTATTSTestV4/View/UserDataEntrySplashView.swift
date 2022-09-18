//
//  UserDataEntrySplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct UserDataEntrySplashView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Spacer()
            
                Text("There Was An Issue Processing Your Entries. Please Return and Try Again. Ensure All Fields Are Completed Before Submitting Your Data")
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
                    UserDataEntryView()
                } label: {
                    
                    HStack {
                        Spacer()
                        Text("Return to User Sign-up or Login")
                        Spacer()
                        Image(systemName: "arrowshape.turn.up.backward.2")
                        Spacer()
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50, alignment: .center)
                    .cornerRadius(300)
                    .padding(.bottom, 20)
                }
                Spacer()
            }
        }
    }
}

//struct UserDataEntrySplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDataEntrySplashView()
//    }
//}
