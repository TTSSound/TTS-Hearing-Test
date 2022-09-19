//
//  UserLoginView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI


struct UserLoginView<Link: View>: View {
    var setup: Setup?
    var relatedLink: (Setup) -> Link
    
    var body: some View {
        
        ZStack{
            if let setup = setup {
                UserLoginContent(setup: setup, relatedLink: relatedLink)
            } else {
                Text("Error Loading User Login View")
                    .navigationTitle("")
            }
        }
    }
}


// This is modeled after the RecipeDetail file in the Apple Docs
struct UserLoginContent<Link: View>: View {
    var setup: Setup
    var dataModel = DataModel.shared
    var relatedLink: (Setup) -> Link
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var colorModel: ColorModel = ColorModel()
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 10, content: {
                Text("User Login Screen")
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.leading,10)
                    .padding(.trailing, 10)
                Text("Figure Out How to Setup Login Function and Option to Stay Logged In")
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.leading,10)
                    .padding(.trailing, 10)
                Text("Also figure out how to make disclaimer agreement persist")
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.leading,10)
                    .padding(.trailing, 10)
        
                NavigationLink("Disclaimer", destination: DisclaimerView(setup: setup, relatedLink: link))
                    .foregroundColor(.green)
                
            })
            .foregroundColor(.pink)
        }
        .navigationTitle(setup.name)
    }
// !!!!!! WILL NEED TO ADD VARIABLES FOR THIS ACTION INTO SETUPDATAMODEL, JSONS AND CSV WRITERS
    
    private func link(setup: Setup) -> some View {
        EmptyView()
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(setup: nil, relatedLink: link)
    }
    
    static func link(setup: Setup) -> some View {
        EmptyView()
    }
}
