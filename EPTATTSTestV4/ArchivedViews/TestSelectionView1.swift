//
//  TestSelectionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//
//
//import SwiftUI
//
//struct TestSelectionView: View {
//    
//   
//    @State var selectedEHA: Bool = false
//    @State var selectedEPTA: Bool = false
//    @State var testSelectionSubmitted = [0]
//    @State var showEHAPurchaseSheet: Bool = false
//    
//    
//    var body: some View {
//        
////        Text("Text")
////    }
//        
//// Marketing and info on EPTA vs EHA Tests
//// Direction that EHA test be taken in two parts at two different times and days
//        
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Select The Type of Test You Would Like to Complete")
//            padding(.leading)
//            Text("Information on Each Test Type, Differences, and Benfits Are Accessible Next To Each Selection")
//                .padding(.leading)
//            Spacer()
//
//            HStack {
//                Spacer()
//                Text("Enhanced Hearing\nEvaluation (EHA)")
//                Spacer()
////                NavigationLink {
////                    EHADescription()
////                } label: {
////                    Text("Learn More Here")
////                }
//                Spacer()
//            }
//            .padding(.bottom, 40)
//
////!!!!!!! NEED TO SETUP IN APP PURCHASE HERE
//    // In app purchase options
//        // Direct to website to purchse physical good options?
//            Button {
//                selectedEHA = true
//                testSelectionSubmitted.replaceSubrange(0..<1, with: [1])
//                showEHAPurchaseSheet.toggle()
//
//            } label: {
//                Text("Select the Enhanced Hearing Evaluation")
//            }
//            .fullScreenCover(isPresented: $showEHAPurchaseSheet) {
//                EHAPurchaseSheetView()
//            }
//            .padding(.trailing)
//
//
////            Toggle("Select the Enhanced Hearing Evaluation", isOn: $selectedEHA)
////                .foregroundColor(.green)
////                .font(.headline)
////                .padding(.horizontal, 100.0)
////                .onChange(of: selectedEHA) { ehaValue in
////                    if ehaValue == true {
////                        testSelectionSubmitted.replaceSubrange(0..<1, with: [1])
////                    }
////                }
////                .onChange(of: selectedEHA) { purchaseEHAValue in
////                    if testSelectionSubmitted[0] == 1 {
////                        //amy
////                    }
////                }
//
//
//            HStack {
//                Spacer()
//                Text("Extended Pure Tone\nAudiogram (EPTA)")
//                Spacer()
////                NavigationLink {
////                    EPTADescription()
////                } label: {
////                    Text("Learn More Here")
////                }
//                Spacer()
//            }
//            .padding(.bottom, 40)
//
//            Button {
//                selectedEPTA = true
//                testSelectionSubmitted.replaceSubrange(0..<1, with: [2])
//
//            } label: {
//                Text("Select the Extended Pure Tone Audiogram")
//            }
//            .padding(.trailing)
//
////            Toggle("Select the Extended Pure Tone Audiogram", isOn: $selectedEPTA)
////                .foregroundColor(.green)
////                .font(.headline)
////                .padding(.horizontal, 100.0)
////                .onChange(of: selectedEPTA) { eptaValue in
////                    if eptaValue == true {
////                        testSelectionSubmitted.replaceSubrange(0..<1, with: [2])
////                    }
////                }
//
//
//            NavigationLink(String("Press to Continue?")) {
//                CalibrationAssessmentView()
//            }
//            .foregroundColor(.green)
//            .font(.title2)
//            .padding(.bottom, 40)
//        }
//    }
//}
//
//
//
////!!!!!!! NEED TO SETUP IN APP PURCHASE HERE
//    // In app purchase options
//        // Direct to website to purchse physical good options?
//// Hardware Purhcase Option
//// Filter Purhcase Option
//// Membership Purchase Option
//
//struct EHAPurchaseSheetView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        VStack{
//            
//            Button {
//                presentationMode.wrappedValue.dismiss()
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.title)
//                    .padding(20)
//                    .foregroundColor(.red)
//            }
//            
//            Spacer()
//            Text(" EHA In App Purchase View")
//            Spacer()
//
//        }
//    }
//}
//
//
//
//
//struct TestSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionView()
//    }
//}
