//
//  FailedEPTATTSTestV4List.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/9/22.
//
// Failed view as of 08.09.2022

/*
 
 import SwiftUI
 import Foundation
 import AVFAudio
 import AVFoundation
 import AVKit
 import CoreMedia
 import Darwin
 import Security
 import Combine


 //_____________Items to Add_____________//
 // Pop up disclosure with attestation
 // User entry pop up--name, age, sex, email
 // Screen for test type selection (Purchase option)
     // Headphone, Devices & system Selection--> Calibrated only
         // Make request for your device to be calibrated
 // Pop up notification to turn on do not disturb or airplane mode and to set volume to max
     // Close all other applications when testing
         // This all helps with calibration
 // Attestation that all of these have been done
 // MPView Volume Slider to set it to 50% output volume
     // Then have volume slider hide
 // Then screen to explain test and user instructions
     // Explanation about pausing the test
     // Expl;anation about taking EPTA and EHA in two sittings
 // Then practice sound and response
 // Then start the test
 // End of Test
 // Display results in graph and notice that more details will be emailed
 // Reminder to turn down volume, turn off airplane mode and turn off do not disturb
 // Exit App
 //
 //____________________________________//



 struct EPTATTSTestV4List: View {

     
     @StateObject private var envDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
     var audioSessionModel = AudioSessionModel()
     @State var heardArrayValue = [Int]()
     
     let heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInteractive)
     let playbackThread = DispatchQueue(label: "BackGroundPlayBack", qos: .utility)
     let audioThread = DispatchQueue(label: "AudioThread", qos: .userInteractive)
     
     var body: some View {
         ZStack{
             RadialGradient(
                 gradient: Gradient(colors: [Color.blue, Color.black]),
                 center: .center,
                 startRadius: -100,
                 endRadius: 300).ignoresSafeArea()
     
         VStack{
  
             
             Text("RePrint Data")
                 .fontWeight(.bold)
                 .padding()
                 .foregroundColor(.white)
                 .onTapGesture{
                     print("Test")
                     Task {
                        await envDataObjectModel.printData()
                     }
                 }
         Spacer()

             Text("Click to setaudioSession")
                 .fontWeight(.bold)
                 .padding()
                 .foregroundColor(.white)
                 .onTapGesture {
                     audioSessionModel.setAudioSession()
                     print("Text Tapped")
                 }
         Spacer()
             
             
             Text("Click to Stat Test Tone")
                 .fontWeight(.bold)
                 .padding()
                 .foregroundColor(.white)
                 .onTapGesture {
                         envDataObjectModel.playing = 1
                     print("Start Button Clicked")
                 }
             Spacer()
             
             Spacer()
             Text("Press if You Hear The Tone")
                 .fontWeight(.semibold)
                 .padding()
                 .frame(width: 300, height: 100, alignment: .center)
                 .background(Color .green)
                 .foregroundColor(.black)
                 .cornerRadius(300)
                 .onTapGesture(count: 1) {
                             envDataObjectModel.heardArray.append(1)
                             envDataObjectModel.stop()
                             envDataObjectModel.playing = -1
                 }

             Spacer()
             }
             .onChange(of: envDataObjectModel.playing, perform: { _ in
                 Task(priority: .userInitiated) {
                     await envDataObjectModel.preEventLogging()
                 }
                 Task(priority: .high) {
                     envDataObjectModel.loadAndTestPresentation(sample: envDataObjectModel.samples[0], gain: envDataObjectModel.testGain, pan: envDataObjectModel.pan)
                 }
                 Task(priority: .high) {
                     envDataObjectModel.playTesting()
                 }
                 Task(priority: .low) {
                     print(envDataObjectModel.returnHeardArrayLast())
                     if envDataObjectModel.heardArray.last == 1 {
                         await envDataObjectModel.postEventLogging()
                         await envDataObjectModel.heardEventLogging()
                         await envDataObjectModel.heardArrayNormalize()
                         await envDataObjectModel.arrayTesting()
                         await envDataObjectModel.printData()
                     } else if envDataObjectModel.heardArray.last == 0 {
                         await envDataObjectModel.postEventLogging()
                         await envDataObjectModel.nonHeardEventLogging()
                         await envDataObjectModel.heardArrayNormalize()
                         await envDataObjectModel.arrayTesting()
                         await envDataObjectModel.printData()
                     } else {
                         print("Fatal Error")
                     }
                 }
             })
         Spacer()
         }
     }
 }


 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         EPTATTSTestV4List()
     }
 }

 */
