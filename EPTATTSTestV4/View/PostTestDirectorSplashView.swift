//
//  PostTestDirectorSplashView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

import SwiftUI

struct PostTestDirectorSplashView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PostTestDirectorSplashContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading TrainingTest View")
                .navigationTitle("")
        }
    }
}


struct PostTestDirectorSplashContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
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
                Spacer()
                NavigationLink {
                    PostAllTestsSplashView(testing: testing, relatedLinkTesting: linkTesting)
                } label: {
                    HStack {
                        Spacer()
                        Text("Return to Post Test Screen")
                        Spacer()
                        Image(systemName: "arrowshape.turn.up.backward.2")
                        Spacer()
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    .cornerRadius(24)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .padding(.bottom, 20)
                }
                Spacer()
            }
        }
    }
}

extension PostTestDirectorSplashContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

//struct PostTestDirectorSplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostTestDirectorSplashView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
