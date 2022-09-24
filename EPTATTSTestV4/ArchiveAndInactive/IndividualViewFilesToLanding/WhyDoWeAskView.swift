//
//  WhyDoWeAskView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

//import SwiftUI
//
//struct WhyDoWeAskView: View {
//    
//    @ObservedObject var whyWeAskModel: WhyWeAskModel = WhyWeAskModel()
//    @State var showWhyDoWeAskSheet: Bool = false
//    
//    var body: some View {
//        
//            VStack(alignment: .leading) {
//
//                Button(action: {
//                    showWhyDoWeAskSheet.toggle()
//                }, label: {
//                    Image(systemName: "xmark")
//                        .font(.headline)
//                        .foregroundColor(.red)
//                })
//                .padding(.top, 40)
//                .padding(.leading, 20)
//           
//            
//            GroupBox(label:
//                    Label("Why Do We Ask", systemImage: "person.fill.questionmark")
//                ) {
//                    ScrollView(.vertical, showsIndicators: true) {
//                        Text(whyWeAskModel.whyDoWeAskForThisText)
//                            .font(.footnote)
//                    }
//                    .frame(height: 500)
////                    Toggle(isOn: $userAgreed) {
////                        Text("I agree to the above terms")
////                    }
//                }
//                .onAppear(perform: {
//                    loadWhyWeAsk()
//                })
//                Spacer()
//        }
//
//    }
    
    
//    func loadWhyWeAsk() {
//        whyWeAskModel.load(file: whyWeAskModel.whyDoWeAskForThisText)
//    }
//
//}
//
//
//class WhyWeAskModel: ObservableObject {
//    @Published var whyDoWeAskForThisText: String = ""
//    init() { self.load(file: "whyDoWeAskForThisText") }
//    func load(file: String) {
//        if let whyFilepath = Bundle.main.path(forResource: "whyDoWeAskForThisText", ofType: "txt") {
//            do {
//                let whyDoWeAskContents = try String(contentsOfFile: whyFilepath)
//                DispatchQueue.main.async {
//                    self.whyDoWeAskForThisText = whyDoWeAskContents
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        } else {
//            print("File not found")
//        }
//    }
//}
//
//
//
//struct WhyDoWeAskView_Previews: PreviewProvider {
//    static var previews: some View {
//        WhyDoWeAskView()
//    }
//}
