//
//  ResultsLandingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/19/22.
//

import SwiftUI

struct ResultsLandingView<Link: View>: View{
    
    var closing: Closing?
    var relatedLinkClosing: (Closing) -> Link
    
    var body: some View {
        if let closing = closing {
            ResultsLandingContent(closing: closing, relatedLinkClosing: relatedLinkClosing)
        } else {
            Text("Error Loading ResultsLanding View")
                .navigationTitle("")
        }
    }
}



struct ResultsLandingContent<Link: View>: View {
    var closing: Closing
    var dataModel = DataModel.shared
    var relatedLinkClosing: (Closing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    var colorModel: ColorModel = ColorModel()
    
    
    @State var results_TestTaken = Int() // 1 = EPTA / 2 = EHA / 3 = Simple
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                VStack(alignment: .leading, spacing: 20) {
                    HStack{
                        Spacer()
                        Text("Test Results and Closing Landing View")
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top,40)
                    .padding(.leading, 20)
                    Spacer()
                    Text("Give Us A Moment To Calculate and Format Your Results")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                    Text("Determine Type of Test Taken and appropriate results. If Uncalibrated Test was Taken, Remind User That Results Are Relative Only and Not Valid or Meaningful. Then Drive Them To Purchase TTS System")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    HStack {
                        Spacer()
                        Picker(selection: $results_TestTaken) {
                            Text("Force Test Selection").tag(0)
                                .foregroundColor(.blue)
                            Text("EPTA Test").tag(1)
                            Text("EHA Test").tag(2)
                            Text("Simple Test").tag(3)
                        } label: {
                            Text("Force Test Selection")
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    Spacer()
                    
                    NavigationLink {
                        results_TestTaken == 1 ? AnyView(EPTAResultsDisplayView())
                        : results_TestTaken == 2 ? AnyView(EHAResultsDisplayView())
                        : results_TestTaken == 3 ? AnyView(SimpleResultsDisplayView())
                        : AnyView(LandingView())
                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue To See Results")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color .green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

extension ResultsLandingContent {
//MARK: -NavigationLink Extension
    private func linkClosing(closing: Closing) -> some View {
        EmptyView()
    }
}

//struct ResultsLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsLandingView(closing: nil, relatedLinkClosing: linkClosing)
//
//    }
//
//    static func linkClosing(closing: Closing) -> some View {
//        EmptyView()
//    }
//}
