//
//  InstructionsForTakingTest.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI
import AVKit
import WebKit

struct InstructionsForTakingTest: View {
    

    @StateObject var colorModel: ColorModel = ColorModel()
   
    
    let videoInstructionLink = "KzQ4cYPZnfo"
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
            Spacer()
                Text("Instructions for Hearing Tests")
                    .foregroundColor(.black)
            Spacer()
            
                
                VideoInstructionView(videoInstructionID: videoInstructionLink)
                    .frame(minHeight: 0, maxHeight:
                            UIScreen.main.bounds.height * 0.3)
                    .cornerRadius(12)
                    .padding(.horizontal, 12)
                
                
            Spacer()
                NavigationLink(
                    destination: SiriSetupView(),
                    label: {
                    Text("Start System Setup for The Hearing Test")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.green)
                
                    })
            Spacer()
            }
        }
    }
}




struct VideoInstructionView: UIViewRepresentable {
    
    let videoInstructionID: String
    //KzQ4cYPZnfo
    
    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
        return WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoInstructionID)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
    
}

//struct InstructionsForTakingTest_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionsForTakingTest()
//    }
//}
