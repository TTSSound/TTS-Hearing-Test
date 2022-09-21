//
//  WelcomeSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/19/22.
//

import SwiftUI
//import MediaPlayer

struct ManualSetupView: View {
    var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea()
            VStack(){
                Text("If The Prior System Setup Using Siri Did Not Work, Here is a Manual Setup Process")
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Text("This involves three steps!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                Text("1. Ensure your device is not silenced!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                Text("This can prevent the evaluation from running properly")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1.0)
                    .padding(/*@START_MENU_TOKEN@*/.trailing, 30.0/*@END_MENU_TOKEN@*/)
                Text("2. Turn on Do Not Disturb!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 105.0)
                    .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
                Text("We don't want your test to be interrupted by an alert.")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(/*@START_MENU_TOKEN@*/.leading, 39.0/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 1.0)
                    .padding(/*@START_MENU_TOKEN@*/.trailing, 38.0/*@END_MENU_TOKEN@*/)
                Text("3. Manually setting your devices volume to the correct level.")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(/*@START_MENU_TOKEN@*/.leading, 30.0/*@END_MENU_TOKEN@*/)
                    .padding(/*@START_MENU_TOKEN@*/[.top, .trailing]/*@END_MENU_TOKEN@*/)
                Text("This ensures test calibration and validity")
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                    .padding(/*@START_MENU_TOKEN@*/.top, 1.0/*@END_MENU_TOKEN@*/)
                NavigationLink {
                    ManualSetupInstructionView()
                } label: {
                    Text("Click to continue for instructions on how to manually complete each of these three actions:")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 80.0)
                        .padding(/*@START_MENU_TOKEN@*/.trailing, 15.0/*@END_MENU_TOKEN@*/)
                        .padding(/*@START_MENU_TOKEN@*/.leading, 29.0/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

//struct ManualSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualSetupView()
//    }
//}


