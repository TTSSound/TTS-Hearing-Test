//
//  TestSelectionLandingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct TestSelectionLandingView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    var body: some View {
    //        Text("Test Selection View Test")

    // Marketing and info on EPTA vs EHA Tests
    // Direction that EHA test be taken in two parts at two different times and days
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading) {
            Spacer()
                ScrollView{
                    Text("Learn about the Different Tests & Services We Offer Below. When You Are Ready, Select Your Desired Option and Continue. Our Options Include:\n\n1. The Gold Standard True To Source Enhanced Hearing Assessment (EHA), Which Includes Your Peronalized Corrective Audio Filter to Let You Hear The True Source Sound, As The Artist Intend In Your Everyday Listening.\n\n2. The Exceedingly Valid True To Soure Extended Pure Tone Audiogram (EPTA)--A Hearing Test without Our Corrective Audio Technology For Everyday Use.\n\n3. The True To Souce Relative Hearing Test--Our Simplest Hearing Test, Which Exceeds Prevailing Medical Practices, And Serves As A Trial Offering")
                }
                .foregroundColor(.white)
                .padding()
                .padding()

                Divider()
                    .frame(width: 400, height: 3)
                    .background(.blue)
                    .foregroundColor(.blue)
                
                HStack {
                    Spacer()
                    Text("Explore Our Gold Standard True To Source Enhanced Hearing Assessment")
                        .foregroundColor(colorModel.neonGreen)

                    Spacer()
                    NavigationLink {
                        EHADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.neonGreen)
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                
                
                HStack {
                    Spacer()
                    Text("Explore The Experience of True To Source Personalized Corrective Audio")
                        .foregroundColor(colorModel.limeGreen)

                    Spacer()
                    NavigationLink {
                        CorrectiveFiltersExplanationView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.limeGreen)
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Text("Explore Our FULL SPECTRUM True To Source Extended Pure Tone Audiogram")
                        .foregroundColor(colorModel.darkNeonGreen)

                    Spacer()
                    NavigationLink {
                        EPTADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.darkNeonGreen)
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Text("Trial Our Technology With Our Simplest Hearing Test")
                        .foregroundColor(colorModel.tiffanyBlue)
                    Spacer()
                    NavigationLink {
                        SimpleTrialDescriptionView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.tiffanyBlue)
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                HStack{
                    Spacer()
                    NavigationLink {
                        TestSelectionView()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(300)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
            Spacer()
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            Spacer()
        }
    }
}

//struct TestSelectionLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestSelectionLandingView()
//    }
//}
