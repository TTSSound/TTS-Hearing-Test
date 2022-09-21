//
//  EPTADescription.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI

struct EPTADescription: View {
    var colorModel: ColorModel = ColorModel()
    @ObservedObject var ePTADescriptionModel: EPTADescriptionModel = EPTADescriptionModel()
  
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                GroupBox(label:
                        Label("Extended Hearing Evaluation", systemImage: "ear.trianglebadge.exclamationmark").foregroundColor(colorModel.limeGreen)
                    ) {
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(ePTADescriptionModel.ePTADescriptionText)
                                .foregroundColor(.black)
                                .font(.footnote)
                        }
                        .frame(height: 425)
                    }
      
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Link("Learn More at\nTrueToSourceSound.com", destination: URL(string: "https://www.truetosourcesound.com")!).foregroundColor(colorModel.tiffanyBlue)
                        Image(systemName: "paperplane")
                        .font(.title)
                        .foregroundColor(colorModel.tiffanyBlue)
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
            Spacer()
        }
    }
}

class EPTADescriptionModel: ObservableObject {
    @Published var ePTADescriptionText: String = ""
    init() { self.load(file: "ePTADescriptionText") }
    func load(file: String) {
        if let eptaFilepath = Bundle.main.path(forResource: "ePTADescriptionText", ofType: "txt") {
            do {
                let eptaContents = try String(contentsOfFile: eptaFilepath)
                DispatchQueue.main.async {
                    self.ePTADescriptionText = eptaContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}

//struct EPTADescription_Previews: PreviewProvider {
//    static var previews: some View {
//        EPTADescription()
//    }
//}
