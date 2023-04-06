//
//  EarSimulatorLandingView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 9/22/22.
//

import SwiftUI
import Combine

struct EarSimulatorLandingView<Link: View>: View {
    var earSimulator: EarSimulator?
    var relatedLinkEarSimulator: (EarSimulator) -> Link
    
    var body: some View {
        if let earSimulator = earSimulator {
            EarSimulatorLandingContent(earSimulator: earSimulator, relatedLinkEarSimulator: relatedLinkEarSimulator)
        } else {
            Text("Error Loading EarSimulatorLanding View")
                .navigationTitle("")
        }
    }
}


struct EarSimulatorLandingContent<Link: View>: View {
    var earSimulator: EarSimulator
    var dataModel = DataModel.shared
    var relatedLinkEarSimulator: (EarSimulator) -> Link
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    var body: some View {
        ZStack{
            colorModel.colorBackgroundLimeGreen.ignoresSafeArea(.all)
            VStack{
                Spacer()
                Text("Ear Simulator Landing View")
                    .foregroundColor(.white)
                    .font(.title)
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink("Manual Ear Simulator 0", destination: EarSimulatorManual0View())
                        .frame(width: 300, height: 100, alignment: .center)
                        .foregroundColor(.white)
                        .background(colorModel.tiffanyBlue)
                        .cornerRadius(24)
                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink("Manual Ear Simulator 1", destination: EarSimulatorManual1View())
                        .frame(width: 300, height: 100, alignment: .center)
                        .foregroundColor(.white)
                        .background(colorModel.tiffanyBlue)
                        .cornerRadius(24)
                    Spacer()
                }
                .navigationDestination(for: EarSimulator.self) { earSimulator in
                    EarSimulatorManual2View()
                }
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink("Automatic Ear Simulator", destination: EarSimulatorManual2View())
                        .frame(width: 300, height: 100, alignment: .center)
                        .foregroundColor(.white)
                        .background(colorModel.tiffanyBlue)
                        .cornerRadius(24)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    private func linkEarSimulator(earSimulator: EarSimulator) -> some View {
        EmptyView()
    }
}

//struct EarSimulatorLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        EarSimulatorLandingView(earSimulator: nil, relatedLinkEarSimulator: linkEarSimulator)
//    }
//
//    static func linkEarSimulator(earSimulator: EarSimulator) -> some View {
//        EmptyView()
//    }
//}
