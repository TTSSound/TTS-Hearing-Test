//
//  SimpleTrialDescriptionView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct SimpleTrialDescriptionView: View {
    @StateObject var colorModel: ColorModel = ColorModel()
    @ObservedObject var simpleTrialDescriptionModel: SimpleTrialDescriptionModel = SimpleTrialDescriptionModel()
  
    var body: some View {
        ZStack{
            colorModel.colorBackgroundNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack{
               Spacer()
                GroupBox(label:
                            Label("Simple Trial Relative Hearing Test", systemImage: "ear")
                                .foregroundColor(.white)
                    ) {
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(simpleTrialDescriptionModel.simpleTrialDescriptionText)
                                .font(.footnote)
                        }
                        .frame(height: 425)
                    }
                Spacer()
                HStack{
                    Spacer()
                        VStack{
                            Link("Learn More at\nTrueToSourceSound.com", destination: URL(string: "https://www.truetosourcesound.com")!).foregroundColor(colorModel.tiffanyBlue)
                                .padding()
                            Image(systemName: "paperplane")
                                .font(.title)
                                .foregroundColor(colorModel.tiffanyBlue)
                        }

                    Spacer()
                }
                Spacer()
            }
        }
    }
}

class SimpleTrialDescriptionModel: ObservableObject {
    @Published var simpleTrialDescriptionText: String = ""
    init() { self.load(file: "simpleTrialDescriptionText") }
    func load(file: String) {
        if let simpleFilepath = Bundle.main.path(forResource: "simpleTrialDescriptionText", ofType: "txt") {
            do {
                let simpleContents = try String(contentsOfFile: simpleFilepath)
                DispatchQueue.main.async {
                    self.simpleTrialDescriptionText = simpleContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}

//struct SimpleTrialDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleTrialDescriptionView()
//    }
//}
