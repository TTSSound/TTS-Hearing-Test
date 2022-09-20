//
//  EHATokenInput.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct TestIDInputView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            TestIDInputContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading TestIDInput View")
                .navigationTitle("")
        }
    }
}

struct TestIDInputContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @State var testIDKey: String = ""
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                Text("Enter Your Test ID Key")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)
           
                HStack{
                    Text("Test Key")
                        .foregroundColor(.white)
                    TextField("Enter Key", text: $testIDKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.leading)
        
                ScrollView {
                    Text(" Require input of Test ID/Tolken to....Have a Purchase Token Input of EHA and EPTA purchased tests Another set of tolkens/IDs indicating it is trial free simple audiogram test Identify the test for later uses with a unique ID that is not directly associated to the user or can be easily parsed from the user\n\nThis is a security measure")
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 200, alignment: .center)
           
//!!!!!!!NEED TO DETERMINE HOW TO AUTHORIZE TOLKENS"
                
                Text("NEED TO DETERMINE HOW TO AUTHORIZE TOLKENS")
                    .foregroundColor(.pink)
                Spacer()
                
          Spacer()
                NavigationLink {
                    UserWrittenHearingAssessmentView(testing: testing, relatedLinkTesting: linkTesting)
                } label: {
                    Text("Continue To Start Hering Assessment")
                        .padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(24)
                }
            Spacer()
            }
        }
    }
    
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
}

struct TestIDInputView_Previews: PreviewProvider {
    static var previews: some View {
        TestIDInputView(testing: nil, relatedLinkTesting: linkTesting)
    }
    
    static func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
}
