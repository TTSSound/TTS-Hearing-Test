//
//  DONOTChangeColorModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 3/11/23.
//
//
//import Foundation

//
//  ColorModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

/*
import Foundation
import SwiftUI

class ColorModel: ObservableObject {
    
    @Published var neonGreen: Color = Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805)
    @Published var darkNeonGreen: Color = Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706)
    @Published var limeGreen: Color = Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569)
    @Published var tiffanyBlue: Color = Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333)
    
    @Published var textMain: Color = Color.white
    
    @Published var proceedColor: Color = Color.green
    @Published var submitColor: Color = Color.mint
    
    @Published var tabColorMain: Color = Color.gray
    
    //Radial Gradient Color Variables
    @Published var Gradient1 = Color.blue
    @Published var Gradient2 =  Color.black
    @Published var GradientCenter = ".center"
    @Published var GradientStartRadius = -100
    @Published var GradientEndRadius = 300
    
//    @Published var colorBackgroundBlue = RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black], center: .center, startRadius: -100, endRadius: 300)) as! CGColor
    
    @Published var colorBackgroundBlue = RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseBlue = RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomBlue = RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomBlue = RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopBlue = RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopBlue = RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]), center: .top, startRadius: -10, endRadius: 300)
    
    
    @Published var colorBackgroundRed = RadialGradient(gradient: Gradient(colors: [Color.red, Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseRed = RadialGradient(gradient: Gradient(colors: [Color.black, Color.red]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomRed = RadialGradient(gradient: Gradient(colors: [Color.red, Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomRed = RadialGradient(gradient: Gradient(colors: [Color.black, Color.red]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopRed = RadialGradient(gradient: Gradient(colors: [Color.red, Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopRed = RadialGradient(gradient: Gradient(colors: [Color.black, Color.red]), center: .top, startRadius: -10, endRadius: 300)

    
    @Published var colorBackgroundWhite = RadialGradient(gradient: Gradient(colors: [Color.white, Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseWhite = RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomWhite = RadialGradient(gradient: Gradient(colors: [Color.white, Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomWhite = RadialGradient(gradient: Gradient(colors: [Color.black, Color.white]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopWhite = RadialGradient(gradient: Gradient(colors: [Color.white, Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopWhite = RadialGradient(gradient: Gradient(colors: [Color.black, Color.white]), center: .top, startRadius: -10, endRadius: 300)

// LIME GREEN    #10bc10
//    Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569))
    @Published var colorBackgroundLimeGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569), Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseLimeGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569)]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomLimeGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569), Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomLimeGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569)]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopLimeGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569), Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopLimeGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.06274509803921569, green: 0.7372549019607844, blue: 0.06274509803921569)]), center: .top, startRadius: -10, endRadius: 300)
 
    
//Dark Neon Green  #2ab67b
    //Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706))
    @Published var colorBackgroundDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.blue]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706)]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706), Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopDarkNeonGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.16470588235294117, green: 0.7137254901960784, blue: 0.4823529411764706)]), center: .top, startRadius: -10, endRadius: 300)
    
    
//Neon Green  #31ed31
    //Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805)
    @Published var colorBackgroundNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805), Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805), Color.blue]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805), Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomNeonGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805)]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopNeonGreen = RadialGradient(gradient: Gradient(colors: [Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805), Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopNeonGreen = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.19215686274509805, green: 0.9294117647058824, blue: 0.19215686274509805)]), center: .top, startRadius: -10, endRadius: 300)
    
    
//Tiffany Blue  #11a7bb
    // Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333)
    @Published var colorBackgroundTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.black]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundReverseTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.blue]), center: .center, startRadius: -100, endRadius: 300)
    @Published var colorBackgroundBottomTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.black]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseBottomTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333)]), center: .bottom, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundTopTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333), Color.black]), center: .top, startRadius: -10, endRadius: 300)
    @Published var colorBackgroundReverseTopTiffanyBlue = RadialGradient(gradient: Gradient(colors: [Color.black, Color(red: 0.06666666666666667, green: 0.6549019607843137, blue: 0.7333333333333333)]), center: .top, startRadius: -10, endRadius: 300)
}
*/
