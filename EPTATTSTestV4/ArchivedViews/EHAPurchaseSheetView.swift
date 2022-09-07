//
//  EHAPurchaseSheetView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//
//
//import SwiftUI
//

//!!!!!!! NEED TO SETUP IN APP PURCHASE HERE
    // In app purchase options
        // Direct to website to purchse physical good options?
// Hardware Purhcase Option
// Filter Purhcase Option
// Membership Purchase Option

//struct EHAPurchaseSheetView: View {
//
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
//    @State var ehaPurchased = [Int]()
//
//    var body: some View {
//        VStack{
//            Button {
//                presentationMode.wrappedValue.dismiss()
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.title)
//                    .padding(20)
//                    .foregroundColor(.red)
//            }
//            Spacer()
//            Text(" EHA In App Purchase View")
//            Spacer()
//            Button {
//                purchasedEHATest()
//            } label: {
//                Text("Complete Purchase")
//                    .foregroundColor(.mint)
//            }
//        }
//    }
//    
//    func purchasedEHATest() {
//        ehaPurchased.append(1)
//        setupDataModel.userPurchasedEHATest.append(contentsOf: ehaPurchased)
//        print("ehaPruchased: \(ehaPurchased)")
//        print("setupData ehaPurchased: \(setupDataModel.userPurchasedEHATest)")
//    }
//}

//struct EHAPurchaseSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EHAPurchaseSheetView()
//    }
//}
