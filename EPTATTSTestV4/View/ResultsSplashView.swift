//
//  ResultsSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/19/22.
//

import SwiftUI

struct ResultsSplashView<Link: View>: View {
    var closing: Closing?
    var relatedLinkClosing: (Closing) -> Link
    
    var body: some View {
        if let closing = closing {
            ResultsSplashContent(closing: closing, relatedLinkClosing: relatedLinkClosing)
        } else {
            Text("Error Loading ResultsLanding View")
                .navigationTitle("")
        }
    }
}

struct ResultsSplashContent<Link: View>: View {
    var closing: Closing
    var dataModel = DataModel.shared
    var relatedLinkClosing: (Closing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Text("Results Splash View")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                NavigationLink(destination: ResultsLandingView(closing: closing, relatedLinkClosing: linkClosing)) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("There was an error presenting your results.")
                            .font(.title3)
                        Text("Return to the test calculation screen")
                            .font(.title3)
                        HStack{
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                                .font(.title)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.all)
                    }
                    .frame(width: 300, height: 200, alignment: .center)
                    .foregroundColor(.blue)
                    .padding(.all)
                }
                Spacer()
            }
        }
    }
}

extension ResultsSplashContent {
//MARK: -NavigationLink Method Extension

    private func linkClosing(closing: Closing) -> some View {
        EmptyView()
    }
}

//struct ResultsSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsSplashView(closing: nil, relatedLinkClosing: linkClosing)
//    }
//
//    static func linkClosing(closing: Closing) -> some View {
//        EmptyView()
//    }
//}
