//
//  ColorModel.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 8/25/22.
//

import Foundation
import SwiftUI

class ColorModel: ObservableObject {
    
    //#150F3B
    @Published var petrolColor: Color = Color(red: 0.082352941176471, green: 0.058823529411765, blue: 0.231372549019608)
        //(red: 21, green: 15, blue: 59)
    
    //5553A4
    @Published var sunrisePurple: Color = Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961)
        //(red: 85, green: 83, blue: 164) // oppacity off = 30%, on = 100%
    
    //#F15C22
    @Published var sunriseOrange: Color = Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)
        //(red: 241, green: 92, blue: 34) // oppacity off = 30%, on = 100%
    
    // #FFD111
    @Published var sunriseBrightYellow: Color = Color(red: 1.0, green: 0.819607843137255, blue: 0.066666666666667)
        //(red: 255, green: 209, blue: 17)
    
    // #ED1D6B
    @Published var sunriseBrightPink: Color = Color(red: 0.929411764705882, green: 0.113725490196078, blue: 0.475555555555556)
        //(red: 237, green: 29, blue: 107)
    
    //#44087D
    @Published var purpleBrightColor: Color = Color(red: 0.266666666666667, green: 0.043137254901961, blue: 0.843137254901961)
        // divide by 255 (red: 68, green: 11, blue: 215)
    
    //#217189
    @Published var purpleBrightColor2: Color = Color(red: 0.152941176470588, green: 0.090196078431373, blue: 0.537254901960784)    //(red: 39, green: 23, blue: 137)
    
    @Published var darkSunriseGradient: LinearGradient = LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4))
    
    @Published var brightSunriseGradient: LinearGradient = LinearGradient(colors: [Color(red: 1.0, green: 0.819607843137255, blue: 0.066666666666667), Color(red: 0.929411764705882, green: 0.113725490196078, blue: 0.475555555555556)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4))
    
/*
 
    Dark Sunsire Gradient
        .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
        .foregroundColor(.white)
    
     Petrol Gradient
        .background(LinearGradient(colors: [Color(red: 0.082352941176471, green: 0.058823529411765, blue: 0.231372549019608), Color(red: 0.152941176470588, green: 0.090196078431373, blue: 0.537254901960784)], startPoint: UnitPoint(x: 0.7, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
    
     Purple Gradient
        .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.266666666666667, green: 0.043137254901961, blue: 0.843137254901961)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))

*/
    
    
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
