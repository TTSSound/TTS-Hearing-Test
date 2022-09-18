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



struct UserLoginContent<Link: View>: View {
    var setup: Setup
    var dataModel = DataModel.shared
    var relatedLink: (Setup) -> Link
    
    
    @StateObject var colorModel: ColorModel = ColorModel()

    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("User Login Screen")
                
                Text("Figure Out How to Setup Login Function and Option to Stay Logged In")
                
                Text("Also figure out how to make disclaimer agreement persist")
            }
            .foregroundColor(.pink)
        }
        .navigationTitle(setup.name)
    }
// !!!!!! WILL NEED TO ADD VARIABLES FOR THIS ACTION INTO SETUPDATAMODEL, JSONS AND CSV WRITERS
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(setup: nil, relatedLink: link)
    }
    
    static func link(setup: Setup) -> some View {
        EmptyView()
    }
}
