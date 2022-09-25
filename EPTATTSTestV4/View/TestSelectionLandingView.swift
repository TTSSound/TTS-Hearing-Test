//
//  TestSelectionLandingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import SwiftUI

struct TestSelectionLandingView: View {
    @StateObject  var colorModel: ColorModel = ColorModel()
    
    var body: some View {
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
                    Text("Explore The Complete Enhanced Hearing Assessment (EHA)")
                        .foregroundColor(.green)
                        .frame(width: 340, height: 50, alignment: .leading)
                    Spacer()
                    NavigationLink {
                        EHADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.title)
                            .frame(width: 20, height: 50, alignment: .center)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top)
                HStack {
                    Spacer()
                    Text("Explore Personalized Corrective Audio")
                        .foregroundColor(.green)
                        .frame(width: 340, height: 50, alignment: .leading)

                    Spacer()
                    NavigationLink {
                        CorrectiveFiltersExplanationView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.title)
                            .frame(width: 20, height: 50, alignment: .center)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                HStack {
                    Spacer()
                    Text("Explore The Entry Extended Pure Tone Audiogram")
                        .foregroundColor(.green)
                        .frame(width: 340, height: 50, alignment: .leading)
                    Spacer()
                    NavigationLink {
                        EPTADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.title)
                            .frame(width: 20, height: 50, alignment: .center)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                HStack {
                    Spacer()
                    Text("Explore Our Simplest, Trial Hearing Test")
                        .foregroundColor(.green)
                        .frame(width: 340, height: 50, alignment: .leading)
                    Spacer()
                    NavigationLink {
                        SimpleTrialDescriptionView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.title)
                            .frame(width: 20, height: 50, alignment: .center)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom)
                HStack{
                    Spacer()
                    NavigationLink {
                        TestSelectionView()
                    } label: {
                        HStack{
                            Spacer()
                            Text("Now Let's Contine!")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
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
