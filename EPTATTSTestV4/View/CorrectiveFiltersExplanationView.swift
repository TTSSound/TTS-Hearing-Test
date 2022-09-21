//
//  CorrectiveFiltersExplanationView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI

struct CorrectiveFiltersExplanationView: View {
    
    var colorModel: ColorModel = ColorModel()
    @ObservedObject var correctiveFiltersExplanationModel: CorrectiveFiltersExplanationModel = CorrectiveFiltersExplanationModel()
  
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTopTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                GroupBox(label:
                            Label("Personalized Corrective Audio Filters", systemImage:  "headphones.circle").foregroundColor(colorModel.darkNeonGreen)
                    ){
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(correctiveFiltersExplanationModel.correctiveFiltersExplanationText)
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
            }
            Spacer()
        }
    }
}

class CorrectiveFiltersExplanationModel: ObservableObject {
    @Published var correctiveFiltersExplanationText: String = ""
    init() { self.load(file: "eHADescriptionText") }
    func load(file: String) {
        if let filterFilepath = Bundle.main.path(forResource: "correctiveFiltersExplanationText", ofType: "txt") {
            do {
                let filterContents = try String(contentsOfFile: filterFilepath)
                DispatchQueue.main.async {
                    self.correctiveFiltersExplanationText = filterContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}

//struct CorrectiveFiltersExplanationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CorrectiveFiltersExplanationView()
//    }
//}
