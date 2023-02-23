//
//  EarSimulatorManual0View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 2/20/23.
//

import SwiftUI
import AVFAudio
import AVFoundation
import AVKit
import CoreMedia
import Combine


struct SamplesESM0List: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}

struct EarSimulatorManual0View: View {
    
    @State private var samples = [SamplesESM0List]()
    
    @State private var samplesHighResStd = [
        SamplesESM0List(name: "Sample1"),
        SamplesESM0List(name: "Sample2"),
        SamplesESM0List(name: "Sample3"),
        SamplesESM0List(name: "Sample4"),
        SamplesESM0List(name: "Sample5"),
        SamplesESM0List(name: "Sample6"),
        SamplesESM0List(name: "Sample7"),
        SamplesESM0List(name: "Sample8"),
        SamplesESM0List(name: "Sample9"),
        SamplesESM0List(name: "Sample10"),
        SamplesESM0List(name: "Sample11"),
        SamplesESM0List(name: "Sample12"),
        SamplesESM0List(name: "Sample13"),
        SamplesESM0List(name: "Sample14"),
        SamplesESM0List(name: "Sample15"),
        SamplesESM0List(name: "Sample16")
    ]
    
    @State private var samplesHighResFaded = [
        SamplesESM0List(name: "FSample1"),
        SamplesESM0List(name: "FSample2"),
        SamplesESM0List(name: "FSample3"),
        SamplesESM0List(name: "FSample4"),
        SamplesESM0List(name: "FSample5"),
        SamplesESM0List(name: "FSample6"),
        SamplesESM0List(name: "FSample7"),
        SamplesESM0List(name: "FSample8"),
        SamplesESM0List(name: "FSample9"),
        SamplesESM0List(name: "FSample10"),
        SamplesESM0List(name: "FSample11"),
        SamplesESM0List(name: "FSample12"),
        SamplesESM0List(name: "FSample13"),
        SamplesESM0List(name: "FSample14"),
        SamplesESM0List(name: "FSample15"),
        SamplesESM0List(name: "FSample16")
    ]

//
//
// Only These Below are needed for the samples. I had tested multiple versions of the samples, but am now only using this version--faded in/out and dithered to 44.1kHz at 16bit
    @State private var samplesCDDitheredFaded = [
        SamplesESM0List(name: "FDSample1"),
        SamplesESM0List(name: "FDSample2"),
        SamplesESM0List(name: "FDSample3"),
        SamplesESM0List(name: "FDSample4"),
        SamplesESM0List(name: "FDSample5"),
        SamplesESM0List(name: "FDSample6"),
        SamplesESM0List(name: "FDSample7"),
        SamplesESM0List(name: "FDSample8"),
        SamplesESM0List(name: "FDSample9"),
        SamplesESM0List(name: "FDSample10"),
        SamplesESM0List(name: "FDSample11"),
        SamplesESM0List(name: "FDSample12"),
        SamplesESM0List(name: "FDSample13"),
        SamplesESM0List(name: "FDSample14"),
        SamplesESM0List(name: "FDSample15"),
        SamplesESM0List(name: "FDSample16")
    ]
// Only Need samples above, not all three versions
//
//
    
    @State private var sampleSelected = [Int]()
    @State private var sampleSelectionIndex = [Int]()
    @State private var sampleSelectedName = [String]()
    @State private var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var ESM0localHeard = 0
    @State private var ESM0localPlaying = Int()    // Playing = 1. Stopped = -1
    @State private var ESM0localReversal = Int()
    @State private var ESM0testPlayer: AVAudioPlayer?
    @State private var ESM0endTestSeriesValue: Bool = false
    @State private var ESM0showTestCompletionSheet: Bool = false
    
    @State private var ESM0_samples: [String] = [String]()
    
    @State private var cdFadedDitheredSamples: [String] =  ["FDSample1", "FDSample2", "FDSample3", "FDSample4", "FDSample5", "FDSample6", "FDSample7", "FDSample8",
                                                            "FDSample9", "FDSample10", "FDSample11", "FDSample12", "FDSample13", "FDSample14", "FDSample15", "FDSample16"]
//
//
//Will not need sample versions below
    @State private var highResStdSamples: [String] =  ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8",
                                                       "Sample9", "Sample10", "Sample11", "Sample12", "Sample13", "Sample14", "Sample15", "Sample16"]
    
    @State private var highResFadedSamples: [String] =  ["FSample1", "FSample2", "FSample3", "FSample4", "FSample5", "FSample6", "FSample7", "FSample8",
                                                         "FSample9", "FSample10", "FSample11", "FSample12", "FSample13", "FSample14", "FSample15", "FSample16"]
//Will not need sample versions above
//
//


//
//
// Many of these variables are carried over from how I coded the testing, and would not be needed if just coding a simple audio player from scratch, which is all this really is.
    @State private var ESM0_index: Int = 0
    @State private var ESM0_testGain: Float = 0
    @State private var ESM0_heardArray: [Int] = [Int]()
    @State private var ESM0_indexForTest = [Int]()
    @State private var ESM0_pan: Float = Float()
    @State private var ESM0activeFrequency = String()
    @State private var ESM0testIsPlaying: Bool = false
    @State private var ESM0playingString: [String] = ["", "Restart Test", "Great Job, You've Completed This Test Segment"]
    @State private var ESM0playingStringColor: [Color] = [Color.clear, Color.yellow, Color.green]
    @State private var ESM0playingStringColorIndex = 0
    @State private var ESM0userPausedTest: Bool = false
    @State private var ESM0TestStarted: Bool = false
    
    let earSimulatorM1heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM1arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM1audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State private var earSimulatorM1_volume = Float()
    @State private var newactiveFrequency = String()
    @State private var earSimulatorM1Cycle: Bool = false
    
    @State private var changeSampleArray: Bool = false
    @State private var highResStandard: Bool = false
    @State private var highResFaded: Bool = false
    @State private var cdFadedDithered: Bool = false
    @State private var sampleArraySet: Bool = false
    
    @State private var earSimulatorM1showTestCompletionSheet: Bool = false
    
    let earSimulatorM1ThreadBackground = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1ThreadDefault = DispatchQueue(label: "AudioThread", qos: .default)
    let earSimulatorM1ThreadUserInteractive = DispatchQueue(label: "AudioThread", qos: .userInteractive)
    let earSimulatorM1ThreadUserInitiated = DispatchQueue(label: "AudioThread", qos: .userInitiated)
    
    @State private var showQoSThreads: Bool = false
    @State private var qualityOfService = Int()
    @State private var qosBackground: Bool = false
    @State private var qosDefault: Bool = false
    @State private var qosUserInteractive: Bool = false
    @State private var qosUserInitiated: Bool = false
    
    
//
//
//Long View Section
    var body: some View {
        ZStack {
            colorModel.colorBackgroundTopNeonGreen.ignoresSafeArea(.all)
            VStack{
                HStack{
                    Spacer()
//
//
//Button to open popup view to select sample to load into audio player (and QOS thread type here and different sample versions, neither of which are needed any more for the next/future use). Only need to select from 16 samples... FDSample1...FDSample16
                    Button {
                        if changeSampleArray == true {
                            self.highResStandard = highResStandard
                            self.highResFaded = highResFaded
                            self.cdFadedDithered = cdFadedDithered
                            self.sampleArraySet = sampleArraySet
                        }
                        earSimulatorM1showTestCompletionSheet = true
                        ESM0stop()
                    } label: {
                        Text("\(ESM0activeFrequency)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(24)
                    Spacer()

//
//
//Button to query system volume and display result
                    Button {
                        audioSessionModel.setAudioSession()
                        earSimulatorM1_volume = audioSessionModel.audioSession.outputVolume
                    } label: {
                        Text("Vol: \(earSimulatorM1_volume)")
                    }
                    .frame(width: 180, height: 30, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(24)
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
//
//
//Button to start plackback of loaded sample
                if ESM0TestStarted == false {
                    Button {    // Start Button
                        Task(priority: .userInitiated) {
                            audioSessionModel.setAudioSession()
                            ESM0localPlaying = 1
                            ESM0endTestSeriesValue = false
                            print("Start Button Clicked. Playing = \(ESM0localPlaying)")
                        }
                    } label: {
                        Text("Click to Start")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 300, height: 40, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

//
//
// Below replaces the play button with a pause and restart button
// Neither are really needed. Only one button is needed to play a loaded sample when triggered
                } else if ESM0TestStarted == true {
                    HStack{
                        Spacer()
                        Button {    // Pause Button
                            ESM0localPlaying = 0
                            ESM0stop()
                            ESM0userPausedTest = true
                            ESM0playingStringColorIndex = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.6, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.4, qos: .userInitiated) {
                                ESM0localPlaying = 0
                                ESM0stop()
                                ESM0userPausedTest = true
                                ESM0playingStringColorIndex = 1
                            }
                        } label: {
                            Text("Pause")
                                .frame(width: 100, height: 40, alignment: .center)
                                .background(Color .yellow)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                            
                        }
                        Spacer()

                        Button {    //Restart Button
                            ESM0_heardArray.removeAll()
                            ESM0pauseRestartTestCycle()
                            audioSessionModel.setAudioSession()
                            ESM0localPlaying = 1
                            ESM0userPausedTest = false
                            ESM0playingStringColorIndex = 0
                        } label: {
                            Text("Restart")
                                .frame(width: 100, height: 40, alignment: .center)
                                .foregroundColor(.white)
                                .background(colorModel.tiffanyBlue)
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
//
//
// Display gain parameter of audio player as assigned based on the manual gain change buttons
// Display gain to 16 decimal places
                HStack{
                    Text(String(format: "%.16f", ESM0_testGain))
                }
                .frame(width: 400, height: 30, alignment: .center)
                .foregroundColor(.white)
                .font(.title)
                .padding(.bottom, 10)
//
//
//Reset Gain Button
//Reset gain to empty float element
                Button("GainReset=0") {
                    ESM0_testGain = Float()
                }
                .fontWeight(.bold)
                .frame(width: 200, height: 30, alignment: .center)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(24)
                .padding(.trailing, 160)
                .padding(.leading, 10)
                .padding(.top, 10)
                .padding(.bottom, 20)

//
//
//Scroll View #1 of Gain Change Buttons
                ScrollView{
                    HStack{
                        Spacer()
                        Button {
                            Task{
                                let newGain: Float = ESM0_testGain - 10E-17 //0.0000000000000001
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-17 //0.0000000000000001
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-17 //0.0000000000000001
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-17")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-17
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-17
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-17
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task{
                                let newGain: Float = ESM0_testGain - 10E-16
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-16
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-16
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-16")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-16
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-16
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-16
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-15
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-15
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-15
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-15")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-15
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-15
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-15
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-14
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-14
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-14
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-14")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-14
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-14
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-14
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-13
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-13
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-13
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-13")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-13
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-13
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-13
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-12
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-12
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-12
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-12")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-12
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-12
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-12
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-11
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-11
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-11
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-11")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-11
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-11
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-11
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-10
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-10
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-10
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-10")
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-10
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-10
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-10
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                }
                .frame(width: 400, height: 190, alignment: .center)
                .background(Color.clear)
                .padding(.top, 10)
                .padding(.bottom, 30)
//End of Scroll View #1
//
//
                
//
//
//Scroll View #2 of Gain Change Buttons
                ScrollView{
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-9
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-9
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-9
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-9")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-9
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-9
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-9
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-8
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-8
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-8
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-8")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-8
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-8
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-8
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-7
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-7
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-7
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-7")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-7
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-7
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-7
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-6
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-6
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-6
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-6")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-6
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-6
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-6
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-5
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-5
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-5
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-5")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-5
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-5
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-5
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-4
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-4
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-4
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-4")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-4
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-4
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-4
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-3
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-3
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-3
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-3")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-3
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-3
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-3
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain - 10E-2
                                if newGain > 0.0 {
                                    ESM0_testGain -= 10E-2
                                } else if newGain == 0.0 {
                                    ESM0_testGain -= 10E-2
                                } else {
                                    ESM0_testGain = 0.0
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Text("Gain: 10E-2")
                            .foregroundColor(.blue)
                        Spacer()
                        Button {
                            Task {
                                let newGain: Float = ESM0_testGain + 10E-2
                                if newGain < 1.0 {
                                    ESM0_testGain += 10E-2
                                } else if newGain == 1.0 {
                                    ESM0_testGain += 10E-2
                                } else {
                                    ESM0_testGain = 1.0
                                }
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 400, height: 50, alignment: .center)
                    .background(Color.clear)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
// Pan Buttons in Scroll View #2
                    HStack{
                        Spacer()
                        Button {    // Left Pan
                            ESM0_pan = -1.0
                        } label: {
                            Text("Left Pan")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        Button {    // Middle Pan
                            ESM0_pan = 0.0
                        } label: {
                            Text("Middle Pan")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Button {    // Right Pan
                            ESM0_pan = 1.0
                        } label: {
                            Text("Right Pan")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .frame(width: 480, height: 50, alignment: .center)
                    .font(.caption)
                    .background(Color.clear)
                    .cornerRadius(24)
                    .padding(.bottom, 10)
                    
                }
                .frame(width: 400, height: 190, alignment: .center)
                .background(Color.clear)
                .padding(.bottom, 40)

// End of Scroll View #2
//
//
                
//
//
// Popup Menu to select different Samples
            }
            .onAppear(perform: {
                earSimulatorM1showTestCompletionSheet = true
             })
            .fullScreenCover(isPresented: $earSimulatorM1showTestCompletionSheet, content: {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        
                        Button(action: {
                            earSimulatorM1showTestCompletionSheet.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .padding(10)
                                .foregroundColor(.red)
                        })
                        
//Below is not needed related to QOS
// This was to try different QOS assignments to see thread and CPU usage
// Not Needed anymore
                        VStack(alignment: .leading, spacing: 10){
                            Toggle(isOn: $showQoSThreads) {
                                Text("Change Qos Threads")
                                    .foregroundColor(.blue)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                            if showQoSThreads == true {
                                HStack{
                                    Toggle("Background", isOn: $qosBackground)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                    Toggle("Default", isOn: $qosDefault)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                                HStack{
                                    Toggle("UserInteractive", isOn: $qosUserInteractive)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                    Toggle("UserInitiated", isOn: $qosUserInitiated)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                            }
                        }
                        .onChange(of: qosBackground) { backgroundValue in
                            if backgroundValue == true {
                                qosBackground = true
                                qosDefault = false
                                qosUserInteractive = false
                                qosUserInitiated = false
                                qualityOfService = 1
                            }
                        }
                        .onChange(of: qosDefault) { defaultValue in
                            if defaultValue == true {
                                qosBackground = false
                                qosDefault = true
                                qosUserInteractive = false
                                qosUserInitiated = false
                                qualityOfService = 2
                            }
                        }
                        .onChange(of: qosUserInteractive) { interactiveValue in
                            if interactiveValue == true {
                                qosBackground = false
                                qosDefault = false
                                qosUserInteractive = true
                                qosUserInitiated = false
                                qualityOfService = 3
                            }
                        }
                        .onChange(of: qosUserInitiated) { initiatedValue in
                            if initiatedValue == true {
                                qosBackground = false
                                qosDefault = false
                                qosUserInteractive = false
                                qosUserInitiated = true
                                qualityOfService = 4
                            }
                        }
//Below is not needed
//Only need to have one set of samples
//This was to try different sample versions by selection within view, but is not needed anymore
                        VStack{
                            Toggle(isOn: $changeSampleArray) {
                                Text("ChangeSampleType")
                                    .foregroundColor(.blue)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                            if changeSampleArray == true {
                                HStack{
                                    Toggle("92/24\nStd", isOn: $highResStandard)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                    Toggle("92/24\nFaded", isOn: $highResFaded)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                    Toggle("48/16\nFaded", isOn: $cdFadedDithered)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    Spacer()
                                }
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                            }
                        }
                        .onChange(of: changeSampleArray) { change in
                            if change == true {
                                sampleArraySet = false
                            } else if change == false {
                                sampleArraySet = true
                            }
                        }
                        .onChange(of: highResStandard) { highResValue in
                            sampleArraySet = false
                            if highResValue == true && sampleArraySet == false {
                                //remove array values
                                samples.removeAll()
                                //set other toggles to fales
                                highResFaded = false
                                cdFadedDithered = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesHighResStd)
                                print("samples: \(samples)")
                            }

                        }
                        .onChange(of: highResFaded) { highResFadedValue in
                            sampleArraySet = false
                            if highResFadedValue == true && sampleArraySet == false {
                                //remove array values
                                samples.removeAll()
                                //set other toggles to fales
                                highResStandard = false
                                cdFadedDithered = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesHighResFaded)
                                print("samples: \(samples)")
                            }
                        }
                        .onChange(of: cdFadedDithered) { cdFadedDitheredValue in
                            sampleArraySet = false
                            if cdFadedDitheredValue == true && sampleArraySet == false {
                                //remove array values
                                samples.removeAll()
                                //set other toggles to fales
                                highResStandard = false
                                highResFaded = false
                                sampleArraySet = true
                                //append new highresstd values
                                samples.append(contentsOf: samplesCDDitheredFaded)
                                print("samples: \(samples)")
                            }
                        }
//
//
//Sample Selection List
                        List {
                            ForEach(samples.indices, id: \.self) { index in
                                HStack {
                                    Text("\(self.samples[index].name)")
                                        .foregroundColor(.white)
                                    Toggle("", isOn: self.$samples[index].isToggledS)
                                        .foregroundColor(.white)
                                        .onChange(of: self.samples[index].isToggledS) { nameIndex in
                                            sampleSelectionIndex.removeAll()
                                            sampleSelectedName.append(self.samples[index].name)
                                            sampleSelectedID.append(self.samples[index].id)
                                            sampleSelectionIndex.append(index)
                                            ESM0activeFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM1activeFrequency: \(ESM0activeFrequency)")
                                            print("index: \(index)")
                                        }
                                }
                                .cornerRadius(12)
                                .scrollContentBackground(.hidden)
                                .listRowInsets(nil)
                                .listRowBackground(Color.clear)
                            }
                        }
                        .background(colorModel.colorBackgroundTopDarkNeonGreen)
                        .scrollContentBackground(.hidden)
                        .listRowInsets(nil)
                        .listRowBackground(Color.clear)
//
//
// Below is not needed, as you will not have multiple different version of the same samples
                        .onAppear {
                            sampleSelectionIndex.removeAll()
                            sampleSelectedName.removeAll()
                            sampleSelectedID.removeAll()
                            if sampleArraySet == false && highResStandard == false && highResFaded == false && cdFadedDithered == false {
                                highResStandard = true
                                highResFaded = false
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResStd)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == true && highResFaded == false && cdFadedDithered == false {
                                highResStandard = true
                                highResFaded = false
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResStd)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == false && highResFaded == true && cdFadedDithered == false {
                                highResStandard = false
                                highResFaded = true
                                cdFadedDithered = false
                                //append highresstd to array
                                samples.append(contentsOf: samplesHighResFaded)
                                sampleArraySet = true
                            } else if sampleArraySet == false && highResStandard == false && highResFaded == false && cdFadedDithered == true {
                                highResStandard = false
                                highResFaded = false
                                cdFadedDithered = true
                                //append highresstd to array
                                samples.append(contentsOf: samplesCDDitheredFaded)
                                sampleArraySet = true
                            }
                        }
//
//
// Dismiss Popup
                        Spacer()
                        HStack{
                            Spacer()
                            Button("Dismiss and Start") {
                                ESM0_samples.removeAll()
                                earSimulatorM1showTestCompletionSheet.toggle()
                            }
                            .frame(width: 200, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(24)
                        Spacer()
                        }
                        Spacer()
                    }
                }
            })

//
//
// Nothing below is needed except for maybe starting an audio session
            .onChange(of: ESM0testIsPlaying, perform: { ESM0testBoolValue in
                if ESM0testBoolValue == true && ESM0endTestSeriesValue == false {
                    //User is starting test for first time
                    audioSessionModel.setAudioSession()
                    ESM0localPlaying = 1
                    ESM0playingStringColorIndex = 0
                    ESM0userPausedTest = false
                } else if ESM0testBoolValue == false && ESM0endTestSeriesValue == false {
                    // User is pausing test for firts time
                    ESM0stop()
                    ESM0localPlaying = 0
                    ESM0playingStringColorIndex = 1
                    ESM0userPausedTest = true
                } else if ESM0testBoolValue == true && ESM0endTestSeriesValue == true {
                    ESM0stop()
                    ESM0localPlaying = -1
                    ESM0playingStringColorIndex = 2
                    ESM0userPausedTest = true
                } else {
                    print("Critical error in pause logic")
                }
            })
            .onChange(of: ESM0localPlaying) { ESM0playingValue in
                ESM0_samples.append(ESM0activeFrequency)
                ESM0localHeard = 0
                ESM0localReversal = 0
                newactiveFrequency = ESM0_samples[ESM0_index]
                ESM0TestStarted = true
                if ESM0playingValue == 1{
                    
                    if qualityOfService == 1 {
                        print("QOS Thread Background")
                        earSimulatorM1ThreadBackground.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 2 {
                        print("QOS Thread Default")
                        earSimulatorM1ThreadDefault.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 3 {
                        print("QOS Thread UserInteractive")
                        earSimulatorM1ThreadUserInteractive.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else if qualityOfService == 4 {
                        print("QOS Thread UserInitiated")
                        earSimulatorM1ThreadUserInitiated.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    } else {
                        print("QOS Thread Not Set, Catch Setting of Default")
                        earSimulatorM1audioThread.async {
                            ESM0loadAndTestPresentation(sample: ESM0activeFrequency, gain: ESM0_testGain, pan: ESM0_pan)
                            while ESM0testPlayer!.isPlaying == true && self.ESM0localHeard == 0 { }
                            if ESM0localHeard == 1 {
                                ESM0testPlayer!.stop()
                                print("Stopped in while if: Returned Array \(ESM0localHeard)")
                            } else {
                                ESM0testPlayer!.stop()
                                self.ESM0localHeard = -1
                                print("Stopped naturally: Returned Array \(ESM0localHeard)")
                            }
                        }
                    }
// End of Not Needed Items from Above
//
//

// Restart Button functions, likely not needed if play button is set to just retrigger audio playback
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.6) {
                        Task(priority: .userInitiated) {
                            await ESM0logNotPlaying()
                            await ESM0resetPlaying()
                            await ESM0resetHeard()
                        }
                    }
                }
            }
            .onChange(of: ESM0localReversal) { ESM0reversalValue in
                if ESM0reversalValue == 1 {
                    DispatchQueue.global(qos: .background).async {
                        Task(priority: .userInitiated) {
                            await ESM0restartPresentation()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual0View {
    enum ESM0SampleErrors: Error {
        case ESM0notFound
        case earSimulatorM1lastUnexpected(code: Int)
    }

    private func ESM0loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
            do{
                let ESM0urlSample = Bundle.main.path(forResource: newactiveFrequency, ofType: ".wav")
                guard let ESM0urlSample = ESM0urlSample else { return print(ESM0SampleErrors.ESM0notFound) }
                ESM0testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM0urlSample))
                guard let ESM0testPlayer = ESM0testPlayer else { return }
                ESM0testPlayer.prepareToPlay()    // Test Player Prepare to Play
                ESM0testPlayer.setVolume(ESM0_testGain, fadeDuration: 0)      // Set Gain for Playback
                ESM0testPlayer.pan = ESM0_pan
                ESM0testPlayer.play()   // Start Playback
            } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    private func ESM0stop() {
      do{
          let ESM0urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
          guard let ESM0urlSample = ESM0urlSample else { return print(ESM0SampleErrors.ESM0notFound) }
          ESM0testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: ESM0urlSample))
          guard let ESM0testPlayer = ESM0testPlayer else { return }
          ESM0testPlayer.stop()
      } catch { print("Error in Player Stop Function") }
  }

    private func ESM0resetPlaying() async { self.ESM0localPlaying = 0 }

    private func ESM0logNotPlaying() async { self.ESM0localPlaying = -1 }

    private func ESM0resetHeard() async { self.ESM0localHeard = 0 }

    private func ESM0reversalStart() async { self.ESM0localReversal = 1}
    
    private func ESM0restartPresentation() async {
        if ESM0endTestSeriesValue == false && ESM0userPausedTest == false && earSimulatorM1Cycle == true {
            ESM0localPlaying = 1
            ESM0endTestSeriesValue = false
        } else if ESM0endTestSeriesValue == true && ESM0userPausedTest == true && earSimulatorM1Cycle == true {
            ESM0localPlaying = -1
            ESM0endTestSeriesValue = true
            ESM0showTestCompletionSheet = true
            ESM0playingStringColorIndex = 2
        }  else if earSimulatorM1Cycle == false {
            ESM0localPlaying = -1
            ESM0endTestSeriesValue = true
            ESM0showTestCompletionSheet = true
            ESM0playingStringColorIndex = 2
        }
    }
    
    private func ESM0pauseRestartTestCycle() {
        ESM0_index = 0
        ESM0_samples.removeAll()
        ESM0_samples.append(ESM0activeFrequency)
        newactiveFrequency = ESM0_samples[ESM0_index]
        ESM0_testGain = ESM0_testGain
        ESM0testIsPlaying = false
        ESM0localPlaying = 0
    }
}

extension EarSimulatorManual0View {
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }

}

//struct EarSimulatorManual0View_Previews: PreviewProvider {
//    static var previews: some View {
//        EarSimulatorManual0View()
//    }
//}
