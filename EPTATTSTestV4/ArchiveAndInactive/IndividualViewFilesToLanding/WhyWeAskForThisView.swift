//
//  WhyWeAskForThisView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

//import SwiftUI
//
//struct WhyWeAskForThisView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    @State var showDeviceSheet: Bool = false
//    
//    var body: some View {
//        VStack{
//            Button(action: {
//                showDeviceSheet.toggle()
//
//            }, label: {
//                Text("Why we ask this")
//                    .padding()
//                    .foregroundColor(.blue)
//            })
//            .fullScreenCover(isPresented: $showDeviceSheet, content: {
//                
//                VStack(alignment: .leading) {
//
//                    Button(action: {
//                        showDeviceSheet.toggle()
//                    }, label: {
//                        Image(systemName: "xmark")
//                            .font(.headline)
//                            .padding(10)
//                            .foregroundColor(.red)
//                    })
//                    Spacer()
//                    Text("Explain why we ask for gender information")
//                        .foregroundColor(.black)
//                    Spacer()
//                    Text(" LARGE \n\n HOLDING \n\n SPACE")
//                        .foregroundColor(.black)
//                    Spacer()
//                }
//            })
//        }
//    }
//}
//        
//struct WhyWeAskForThisView_Previews: PreviewProvider {
//    static var previews: some View {
//        WhyWeAskForThisView()
//    }
//}
