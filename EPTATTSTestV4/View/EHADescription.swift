//
//  EHADescription.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI

struct EHADescription: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @ObservedObject var ehaDescriptionModel: EHADescriptionModel = EHADescriptionModel()
  
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopLimeGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                GroupBox(label:
                            Label("Extended Hearing Evaluation", systemImage:  "ear.and.waveform").foregroundColor(colorModel.tiffanyBlue) //"hearingdevice.ear")
                    .foregroundColor(.black)
                    ){
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(ehaDescriptionModel.eHADescriptionText)
                                .foregroundColor(.black)
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                        .frame(height: 425)
                    }
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Link("Learn More at\nTrueToSourceSound.com", destination: URL(string: "https://www.truetosourcesound.com")!).foregroundColor(colorModel.tiffanyBlue)
                        Image(systemName: "paperplane")
                            .foregroundColor(colorModel.tiffanyBlue)
                        .font(.title)
                        .foregroundColor(.blue)
                        Spacer()
                    }
                    Spacer()
                    VStack{
                        Spacer()

                        NavigationLink {
                            InAppPurchaseView()
                        } label: {
                            VStack {
                                Spacer()
                                Text("Direct Puchase")
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Image(systemName: "purchased.circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

class EHADescriptionModel: ObservableObject {
    @Published var eHADescriptionText: String = ""
    init() { self.load(file: "eHADescriptionText") }
    func load(file: String) {
        if let ehaFilepath = Bundle.main.path(forResource: "eHADescriptionText", ofType: "txt") {
            do {
                let ehaContents = try String(contentsOfFile: ehaFilepath)
                DispatchQueue.main.async {
                    self.eHADescriptionText = ehaContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}

//struct EHADescription_Previews: PreviewProvider {
//    static var previews: some View {
//        EHADescription()
//    }
//}
