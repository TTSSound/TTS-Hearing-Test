//
//  EarSimulatorManual1View.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/22/22.
//

import SwiftUI
import AVFAudio
import AVFoundation
import AVKit
import CoreMedia
import Combine
import CodableCSV


struct SamplesList: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledS = false
    init(name: String) {
        self.name = name
    }
}



struct EarSimulatorManual1View: View {
    
    @State var samples = [
        SamplesList(name: "Sample1"),
        SamplesList(name: "Sample2"),
        SamplesList(name: "Sample3"),
        SamplesList(name: "Sample4"),
        SamplesList(name: "Sample5"),
        SamplesList(name: "Sample6"),
        SamplesList(name: "Sample7"),
        SamplesList(name: "Sample8"),
        SamplesList(name: "Sample9"),
        SamplesList(name: "Sample10"),
        SamplesList(name: "Sample11"),
        SamplesList(name: "Sample12"),
        SamplesList(name: "Sample13"),
        SamplesList(name: "Sample14"),
        SamplesList(name: "Sample15"),
        SamplesList(name: "Sample16")
    ]
    
    @State var sampleSelected = [Int]()
    @State var sampleSelectionIndex = [Int]()
    @State var sampleSelectedName = [String]()
    @State var sampleSelectedID = [UUID]()
    
    
    var audioSessionModel = AudioSessionModel()
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var earSimulatorM1localPlaying = Int()
    @State var earSimulatorM1localMarkNewTestCycle = Int()
    @State var earSimulatorM1testPlayer: AVAudioPlayer?
    
    @State var earSimulatorM1localTestCount = 0
    
    @State var earSimulatorM1_volume: Float = Float()
    
    @State var earSimulatorM1_samples: [String] = ["Sample0", "Sample1"]
    @State var earSimulatorM1_index: Int = 0
    @State var earSimulatorM1_testGain: Float = 0.2
    @State var earSimulatorM1_indexForTest = [Int]()
    @State var earSimulatorM1_testCount: [Int] = [Int]()
    @State var earSimulatorM1_pan: Float = Float()
    @State var earSimulatorM1_testPan = [Float]()
    @State var earSimulatorM1_testTestGain = [Float]()
    @State var earSimulatorM1_frequency = [String]()
    
    @State var earSimulatorM1localReversal = Int()
    
    @State var earSimulatorM1_eptaSamplesCount = 1
    @State var earSimulatorM1_SamplesCountArray = [1, 1]
    @State var earSimulatorM1_SamplesCountArrayIdx = 0
    
    @State var earSimulatorM1_finalStoredIndex: [Int] = [Int]()
    @State var earSimulatorM1_finalStoredTestPan: [Int] = [Int]()
    @State var earSimulatorM1_finalStoredTestTestGain: [Float] = [Float]()
    @State var earSimulatorM1_finalStoredFrequency: [String] = [String]()
    @State var earSimulatorM1_finalStoredTestCount: [Int] = [Int]()
    
   
    @State var earSimulatorM1idxTestCount = Int() // = earSimulatorM1_TestCount.count
    @State var earSimulatorM1idxTestCountUpdated = Int() // = earSimulatorM1_TestCount.count + 1
    @State var earSimulatorM1activeFrequency = String()
    @State var earSimulatorM1testIsPlaying: Bool = false

    @State var earSimulatorM1userPausedTest: Bool = false
    
    @State var earSimulatorM1TestCompleted: Bool = false
    
    @State var earSimulatorM1fullTestCompleted: Bool = false
    @State var earSimulatorM1TestStarted: Bool = false
    
    
    let fileearSimulatorM1Name = "SummaryearSimulatorM1Results.json"
    let summaryearSimulatorM1CSVName = "SummaryearSimulatorM1ResultsCSV.csv"
    let detailedearSimulatorM1CSVName = "DetailedearSimulatorM1ResultsCSV.csv"
    let inputearSimulatorM1SummaryCSVName = "InputSummaryearSimulatorM1ResultsCSV.csv"
    let inputearSimulatorM1DetailedCSVName = "InputDetailedearSimulatorM1ResultsCSV.csv"
    
    
    let earSimulatorM1heardThread = DispatchQueue(label: "BackGroundThread", qos: .userInitiated)
    let earSimulatorM1arrayThread = DispatchQueue(label: "BackGroundPlayBack", qos: .background)
    let earSimulatorM1audioThread = DispatchQueue(label: "AudioThread", qos: .background)
    let earSimulatorM1preEventThread = DispatchQueue(label: "PreeventThread", qos: .userInitiated)
    
    @State var earSimulatorM1showTestCompletionSheet: Bool = false
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                HStack{
                    Spacer()
                    Text("\(earSimulatorM1activeFrequency)")
                        .foregroundColor(.white)
                    Spacer()
                }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                Button {    // Start Button
                    Task(priority: .userInitiated) {
                        audioSessionModel.setAudioSession()
                        earSimulatorM1localPlaying = 1
                        print("Start Button Clicked. Playing = \(earSimulatorM1localPlaying)")
                    }
                } label: {
                    Text("Click to Start")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 200, height: 40, alignment: .center)
                        .background(colorModel.tiffanyBlue)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                HStack{
                    Spacer()
                    Button {    // Pause Button
                        earSimulatorM1localPlaying = 0
                        earSimulatorM1stop()
                        earSimulatorM1userPausedTest = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, qos: .userInitiated) {
                            earSimulatorM1localPlaying = 0
                            earSimulatorM1stop()
                            earSimulatorM1userPausedTest = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9, qos: .userInitiated) {
                            earSimulatorM1localPlaying = 0
                            earSimulatorM1stop()
                            earSimulatorM1userPausedTest = true
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
                        earSimulatorM1pauseRestartTestCycle()
                        audioSessionModel.setAudioSession()
                        earSimulatorM1localPlaying = 1
                        earSimulatorM1userPausedTest = false
                    } label: {
                        Text("Restart")
                            .frame(width: 100, height: 40, alignment: .center)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                    Spacer()
                }
                
                //View System Volume and Reset Audio Session to View Updated System Volume (2 wide Hstack)
                HStack{
                    Spacer()
                    Button {
                        audioSessionModel.setAudioSession()
                        earSimulatorM1_volume = audioSessionModel.audioSession.outputVolume
                        //                    audioSessionModel.cancelAudioSession()
                    } label: {
                        Text("Volume: \(earSimulatorM1_volume)")
                    }
                    Spacer()
                }
                .frame(width: 300, height: 40, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(24)
                .padding(.top, 20)
                .padding(.bottom, 20)

                //View Current Gain
                HStack{
                    Spacer()
                    Text("Gain: \(earSimulatorM1_testGain)")
                    Spacer()
                }
                .frame(width: 300, height: 30, alignment: .center)
                .foregroundColor(.white)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 10)
                
                HStack{
                    //Button For Gain Change of 0.1 (10% / 10 db?)
                    Spacer()
                    Button {
                        Task{
                            let newGain: Float = earSimulatorM1_testGain - 0.1
                            if newGain > 0.0 {
                                earSimulatorM1_testGain -= 0.1
                            } else if newGain == 0.0 {
                                earSimulatorM1_testGain -= 0.1
                            } else {
                                earSimulatorM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.1")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain + 0.1
                            if newGain < 1.0 {
                                earSimulatorM1_testGain += 0.1
                            } else if newGain == 1.0 {
                                earSimulatorM1_testGain += 0.1
                            } else {
                                earSimulatorM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
                    
                HStack{
                    // Button for gain Change of 0.05 (5% / 5 db?)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain - 0.05
                            if newGain > 0.0 {
                                earSimulatorM1_testGain -= 0.05
                            } else if newGain == 0.0 {
                                earSimulatorM1_testGain -= 0.05
                            } else {
                                earSimulatorM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.05")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain + 0.05
                            if newGain < 1.0 {
                                earSimulatorM1_testGain += 0.05
                            } else if newGain == 1.0 {
                                earSimulatorM1_testGain += 0.05
                            } else {
                                earSimulatorM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)

                HStack{
                    // Button for gain change of 0.01 (1% / 1db)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain - 0.01
                            if newGain > 0.0 {
                                earSimulatorM1_testGain -= 0.01
                            } else if newGain == 0.0 {
                                earSimulatorM1_testGain -= 0.01
                            } else {
                                earSimulatorM1_testGain = 0.0
                            }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text("0.01")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain + 0.01
                            if newGain < 1.0 {
                                earSimulatorM1_testGain += 0.01
                            } else if newGain == 1.0 {
                                earSimulatorM1_testGain += 0.01
                            } else {
                                earSimulatorM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
                
                HStack{
                    // Button for gain change of 0.001 (0.1% 0.1dB?)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain - 0.001
                            if newGain > 0.0 {
                                earSimulatorM1_testGain -= 0.001
                            } else if newGain == 0.0 {
                                earSimulatorM1_testGain -= 0.001
                            } else {
                                earSimulatorM1_testGain = 0.0
                            }
                        }
                    } label: {
                        VStack{
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                    Text("0.001")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        Task {
                            let newGain: Float = earSimulatorM1_testGain + 0.001
                            if newGain < 1.0 {
                                earSimulatorM1_testGain += 0.001
                            } else if newGain == 1.0 {
                                earSimulatorM1_testGain += 0.001
                            } else {
                                earSimulatorM1_testGain = 1.0
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.clear)
                .cornerRadius(12)
                .padding(.bottom, 20)
            
                HStack{
                    Spacer()
                    // Left Pan
                    Button {
                        earSimulatorM1_pan = -1.0
                    } label: {
                        Text("Left Pan")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    
                    // Middle Pan
                    Button {
                        earSimulatorM1_pan = 0.0
                    } label: {
                        Text("Middle Pan")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    // Right Pan
                    Button {
                        earSimulatorM1_pan = 1.0
                    } label: {
                        Text("Right Pan")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .frame(width: 380, height: 50, alignment: .center)
                .font(.caption)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 40)

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
                        List {
                            ForEach(samples.indices, id: \.self) { index in
                                HStack {
                                    Text("\(self.samples[index].name)")
                                        .foregroundColor(.blue)
                                    Toggle("", isOn: self.$samples[index].isToggledS)
                                        .foregroundColor(.blue)
                                        .onChange(of: self.samples[index].isToggledS) { nameIndex in
                                            sampleSelectionIndex.removeAll()
                                            sampleSelectedName.append(self.samples[index].name)
                                            sampleSelectedID.append(self.samples[index].id)
                                            sampleSelectionIndex.append(index)
                                            earSimulatorM1activeFrequency = sampleSelectedName[0]
                                            print(".samples[index].name: \(samples[index].name)")
                                            print("sampleSelectedName: \(sampleSelectedName)")
                                            print("earSimulatorM1activeFrequency: \(earSimulatorM1activeFrequency)")
                                            print("index: \(index)")
                                        }
                                }
                            }
                        }
                        .onAppear {
                            sampleSelectionIndex.removeAll()
                            sampleSelectedName.removeAll()
                            sampleSelectedID.removeAll()
                        }
                        Spacer()
                        HStack{
                            Spacer()
                            Button("Dismiss and Start") {
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
            
            .onChange(of: earSimulatorM1localPlaying) { earSimulatorM1playingValue in
                
                //Change This To Picker Frequency Selection
                    //earSimulatorM1activeFrequency is keyed into formula
                earSimulatorM1activeFrequency = earSimulatorM1activeFrequency

                // GAIN SETTING Bound to Gain Change Buttons
                earSimulatorM1_testGain = earSimulatorM1_testGain
                
                // Pan Setting
                    // earSimulatorM1_pan is bound to play function
                earSimulatorM1_pan = earSimulatorM1_pan
                
                earSimulatorM1TestStarted = true
                if earSimulatorM1playingValue == 1{
                    
                    earSimulatorM1audioThread.async {
                        earSimulatorM1loadAndTestPresentation(sample: earSimulatorM1activeFrequency, gain: earSimulatorM1_testGain, pan: earSimulatorM1_pan)
                        }
                    }
                    earSimulatorM1preEventThread.async {
                        earSimulatorM1preEventLogging()
                    }
                    
                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 3.0) {
                        earSimulatorM1localTestCount += 1
                        Task(priority: .userInitiated) {
                            await earSimulatorM1count()
                            await earSimulatorM1resetPlaying()
                            await earSimulatorM1reversalStart()
                        }
                    }
                }
            // end of first .onChange of
            .onChange(of: earSimulatorM1localReversal) { earSimulatorM1reversalValue in
                if earSimulatorM1reversalValue == 1 {
                    DispatchQueue.global(qos: .userInitiated).async {
                        Task(priority: .userInitiated) {
                            await earSimulatorM1restartPresentation()
                            print("Prepare to Start Next Presentation")
                        }
                    }
                }
            }
        }
    }
}


extension EarSimulatorManual1View {
    enum earSimulatorM1LastErrors: Error {
        case earSimulatorM1lastError
        case earSimulatorM1lastUnexpected(code: Int)
    }
    
    func earSimulatorM1pauseRestartTestCycle() {
        earSimulatorM1localMarkNewTestCycle = 0
        earSimulatorM1_index = earSimulatorM1_index
        earSimulatorM1_testGain = earSimulatorM1_testGain // May Need To Modify This Code
        earSimulatorM1testIsPlaying = false
        earSimulatorM1localPlaying = 0
    }
    
    func earSimulatorM1loadAndTestPresentation(sample: String, gain: Float, pan: Float) {
        do{
            let earSimulatorM1urlSample = Bundle.main.path(forResource: earSimulatorM1activeFrequency, ofType: ".wav")
            guard let earSimulatorM1urlSample = earSimulatorM1urlSample else { return print(earSimulatorM1LastErrors.earSimulatorM1lastError) }
            earSimulatorM1testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: earSimulatorM1urlSample))
            guard let earSimulatorM1testPlayer = earSimulatorM1testPlayer else { return }
            earSimulatorM1testPlayer.prepareToPlay()    // Test Player Prepare to Play
            earSimulatorM1testPlayer.setVolume(earSimulatorM1_testGain, fadeDuration: 0)      // Set Gain for Playback
            earSimulatorM1testPlayer.pan = earSimulatorM1_pan
            earSimulatorM1testPlayer.play()   // Start Playback
        } catch { print("Error in playerSessionSetUp Function Execution") }
    }
    
    func earSimulatorM1stop() {
        do{
            let earSimulatorM1urlSample = Bundle.main.path(forResource: "Sample0", ofType: ".wav")
            guard let earSimulatorM1urlSample = earSimulatorM1urlSample else { return print(earSimulatorM1LastErrors.earSimulatorM1lastError) }
            earSimulatorM1testPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: earSimulatorM1urlSample))
            guard let earSimulatorM1testPlayer = earSimulatorM1testPlayer else { return }
            earSimulatorM1testPlayer.stop()
        } catch { print("Error in Player Stop Function") }
    }
    
    func earSimulatorM1resetPlaying() async { self.earSimulatorM1localPlaying = 0 }
    
    func earSimulatorM1logNotPlaying() async { self.earSimulatorM1localPlaying = -1 }
    
    func earSimulatorM1reversalStart() async { self.earSimulatorM1localReversal = 1}
    
    func earSimulatorM1preEventLogging() {
        DispatchQueue.main.async(group: .none, qos: .userInitiated, flags: .barrier) {
            earSimulatorM1_indexForTest.append(earSimulatorM1_index)
        }
        DispatchQueue.global(qos: .default).async {
            earSimulatorM1_testTestGain.append(earSimulatorM1_testGain)
        }
        DispatchQueue.global(qos: .background).async {
            earSimulatorM1_frequency.append(earSimulatorM1activeFrequency)
            earSimulatorM1_testPan.append(earSimulatorM1_pan)
        }
    }
    
    func earSimulatorM1count() async {
        earSimulatorM1idxTestCountUpdated = earSimulatorM1_testCount.count + 1
        earSimulatorM1_testCount.append(earSimulatorM1idxTestCountUpdated)
    }
    
    
    func earSimulatorM1restartPresentation() async {
        earSimulatorM1localPlaying = 1
    }
}


extension EarSimulatorManual1View {
//MARK: -Extension Methods Reversals

    func earSimulatorM1reversalOfATenth() async {
        earSimulatorM1_testGain += 0.001
    }
    
    func earSimulatorM1reversalOfOne() async {
        earSimulatorM1_testGain += 0.01
    }
    
    func earSimulatorM1reversalOfFive() async {
        earSimulatorM1_testGain += 0.05
    }
    
    func earSimulatorM1reversalOfTen() async {
        earSimulatorM1_testGain += 0.1
    }
}


extension EarSimulatorManual1View {
//    private func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }

}

struct EarSimulatorManual1View_Previews: PreviewProvider {
    static var previews: some View {
        EarSimulatorManual1View()
    }
}
