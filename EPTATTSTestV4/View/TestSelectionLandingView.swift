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
    //            .frame(width: 400, height: 300, alignment: .leading)
                Divider()
                    .frame(width: 400, height: 3)
                    .background(.blue)
                    .foregroundColor(.blue)
                
                HStack {
                    Spacer()
                    Text("Explore Our Gold Standard True To Source Enhanced Hearing Assessment")
                        .foregroundColor(colorModel.neonGreen)
//                        .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
//                        .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
                    Spacer()
                    NavigationLink {
                        EHADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.neonGreen)
//                            .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
//                            .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
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
//                        .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
//                        .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
                    Spacer()
                    NavigationLink {
                        CorrectiveFiltersExplanationView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.limeGreen)
//                            .foregroundColor(Color(red: 0.8980392156862745, green: 0.8941176470588236, blue: 0.8862745098039215)) // Platinum
//                            .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 10)
                .padding(.bottom, 10)
    //            Divider()
    //                .frame(width: 400, height: 3)
    //                .background(.gray)
    //                .foregroundColor(.gray)
                
                HStack {
                    Spacer()
                    Text("Explore Our FULL SPECTRUM True To Source Extended Pure Tone Audiogram")
                        .foregroundColor(colorModel.darkNeonGreen)
//                        .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
//                        .foregroundColor(Color(red: 0.6901960784313725, green: 0.5529411764705883, blue: 0.3411764705882353))   // Bronze
                    Spacer()
                    NavigationLink {
                        EPTADescription()
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundColor(colorModel.darkNeonGreen)
//                            .foregroundColor(Color(red: 0.8313725490196079, green: 0.6862745098039216, blue: 0.21568627450980393)) // Gold
//                            .foregroundColor(Color(red: 0.6901960784313725, green: 0.5529411764705883, blue: 0.3411764705882353))   // Bronze
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
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(300)
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
