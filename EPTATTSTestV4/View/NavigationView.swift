//
//  NavigationView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/17/22.
//

import SwiftUI
import Combine
//import Firebase


struct NavigationView: View {

    var dataModel = DataModel.shared
    @StateObject private var navigationModel = NavigationModel()
    
    @StateObject var colorModel = ColorModel()
    @State var selectedTab: Int = 0
    
    @State var firstTestingTabEnabled: Bool = false
    @State var firstTestingTabValueArray = [nil, EPTATTSTestV4.Testing(id: 8.0, name: "Beta Testing Home", related: [])]
    @State var firstTestingTabValue = EPTATTSTestV4.Testing(id: 0.0, name: "", related: [])
    
    @State var secondTestingTabEnabled: Bool = false
    @State var secondTestingTabValueArray = [nil, EPTATTSTestV4.EHATesting(id: 14.1, name: "EHA Interim Pre Part 2 Test", related: [])]
    @State var secondTestingTabValue = EPTATTSTestV4.EHATesting(id: 0.0, name: "", related: [])
    
    @State var closingTabEnabled: Bool = false
    @State var closingTabValueArray = [nil, EPTATTSTestV4.Closing(id: 15.0, name: "Results Landing View", related: [])]
    @State var closingTabValue = EPTATTSTestV4.Closing(id: 0.0, name: "", related: [])
    
    @State var showEarSimulator: Bool = false
    
    var body: some View {
        //        NavigationStack(path: $navigationModel.setupPath) {
        //
        //            NavigationLink("User Login", value: dataModel.setups[2])
        //                .foregroundColor(.green)
        //
        //            List{
        //                ForEach(dataModel.setups, id: \.self) { setup in
        //                    NavigationLink(setup.name, value: setup)
        //                }
        //            }
        //            .navigationDestination(for: Setup.self) { setup in
        //                UserLoginView(setup: setup, relatedLink: link)
        //            }
        //            .environmentObject(navigationModel)
        //                .onAppear {
        //                    ForEach(dataModel.setups, id: \.self) { setup in
        //                        NavigationLink(setup.name, value: setup)
        //                    }
        //            }
        //        }

        TabView(selection: $selectedTab) {
            ZStack{
                colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                VStack(alignment: .leading) {
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            showEarSimulator = true
                        } label: {
                            Image(systemName: "waveform.and.magnifyingglass")
                                .foregroundColor(colorModel.tiffanyBlue)
                                .opacity(0.85)
                                .font(.title3)
                                .padding(.trailing, 20)
                        }
                        
                    }
                    .padding(.trailing)
                    .padding(.bottom, 20)
                    HStack{
                        VStack(alignment: .leading) {
                            Text("PROCESS FLOW OF APP FOR ALPHA USE.")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.leading)
                                .padding(.bottom, 10)
                            Text("COMPLETE TABS IN THIS ORDER")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.leading)
                                
                        }
                    }
                    .padding(.bottom, 20)
                    Text("1. Setup Tab\n2. 1st Testing Tab\n3. 2nd Testing Tab\n4. Results Tab")
                        .foregroundColor(.green)
                        .padding(.leading)
                        .padding(.bottom, 20)
                    Text("2nd, 3rd, & 4th tab disabled as default, enable them as prior tab is completed")
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.bottom, 20)
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button {
                            firstTestingTabEnabled.toggle()
                        } label: {
                            Text("Enable 1st Testing")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(colorModel.tiffanyBlue)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .onChange(of: firstTestingTabEnabled) { newValue in
                            firstTestingTabValue = firstTestingTabValueArray[1] ?? EPTATTSTestV4.Testing(id: 8.0, name: "Beta Testing Home", related: [])
                        }
                        Spacer()
                        Toggle("Enable 1st Testing", isOn: $firstTestingTabEnabled)
                            .foregroundColor(.clear)
                            .onChange(of: firstTestingTabEnabled) { newValue in
                                if newValue == true {
                                    firstTestingTabValue = firstTestingTabValueArray[1] ?? EPTATTSTestV4.Testing(id: 8.0, name: "Beta Testing Home", related: [])
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    HStack{
                        Spacer()
                        Button {
                            secondTestingTabEnabled.toggle()
                        } label: {
                            Text("Enable 2nd Testing")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(colorModel.tiffanyBlue)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .onChange(of: secondTestingTabEnabled) { newValue in
                            secondTestingTabValue = secondTestingTabValueArray[1] ?? EPTATTSTestV4.EHATesting(id: 14.1, name: "EHA Interim Pre Part 2 Test", related: [])
                        }
                        Spacer()
                        Toggle("Enable 2nd Testing", isOn: $secondTestingTabEnabled)
                            .onChange(of: secondTestingTabEnabled) { newValue in
                                if newValue == true {
                                    secondTestingTabValue = secondTestingTabValueArray[1] ?? EPTATTSTestV4.EHATesting(id: 14.1, name: "EHA Interim Pre Part 2 Test", related: [])
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    HStack{
                        Spacer()
                        Button {
                            closingTabEnabled.toggle()
                        } label: {
                            Text("Enable Results")
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(colorModel.tiffanyBlue)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        .onChange(of: closingTabEnabled) { newValue in
                            closingTabValue = closingTabValueArray[1] ?? EPTATTSTestV4.Closing(id: 15.0, name: "Results Landing View", related: [])
                        }
                        Spacer()
                        Toggle("Enable Results", isOn: $closingTabEnabled)
                            .onChange(of: closingTabEnabled) { newValue in
                                if newValue == true {
                                    closingTabValue = closingTabValueArray[1] ?? EPTATTSTestV4.Closing(id: 15.0, name: "Results Landing View", related: [])
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                .padding()
            }
            .fullScreenCover(isPresented: $showEarSimulator, content: {
                NavigationStack(path: $navigationModel.earSimulatorPath) {
                    ZStack{
                        colorModel.colorBackgroundBottomLimeGreen.ignoresSafeArea(.all)
                        VStack(alignment: .leading, spacing: 20) {
                            Button {
                                showEarSimulator.toggle()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .opacity(0.7)
                                    .padding(10)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            HStack{
                                Spacer()
                                NavigationLink("Ear Simulators", value: EPTATTSTestV4.EarSimulator(id: 20.0, name: "Ear Simulator Landing", related: []))
                                    .font(.title)
                                    .padding()
                                    .frame(width: 300, height: 100, alignment: .center)
                                    .background(colorModel.limeGreen)
                                    .foregroundColor(.white)
                                    .cornerRadius(24)
                                    .hoverEffect()
                                    .navigationDestination(for: EarSimulator.self) { earSimulator in
                                        EarSimulatorLandingView(earSimulator: earSimulator, relatedLinkEarSimulator: linkEarSimulator)
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            })
            .environmentObject(navigationModel)
            .onAppear {
                getLinks()
                firstTestingTabValue = EPTATTSTestV4.Testing(id: 0.0, name: "", related: [])
            }
            .tabItem {
                Image(systemName: "house")
                    .foregroundColor(colorModel.tabColorMain)
                Text("Home")
                    .foregroundColor(colorModel.tabColorMain)
            }
            .tag(0)
            
            NavigationStack(path: $navigationModel.setupPath) {
                ZStack{
                    colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                    VStack{
                        Spacer()
                        HStack{
                            Text("Before Proceeding, Ensure All Other Applications Are Closed.\n\nFailure To Do This May Cause Less Than Optimal Test Performance.")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        Spacer()
                        NavigationLink("Let's Begin The Setup Process", value: EPTATTSTestV4.Setup(id: 1.0, name: "Disclaimer", related: []))
                            .font(.title)
                            .padding()
                            .frame(width: 300, height: 100, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                            .hoverEffect()
                            .navigationDestination(for: Setup.self) { setup in
                                DisclaimerView(setup: setup, relatedLink: link)
                            }
                        Spacer()
                    }
                }
            }
            .tabItem {
                Image(systemName: "arrowshape.zigzag.right.fill")
                    .accentColor(.blue)
                Text("1. Setup")
                    .foregroundColor(.blue)
            }
            .tag(1)
            
            
            NavigationStack(path: $navigationModel.testingPath) {
                ZStack{
                    colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
//                    NavigationLink("Let's Begin Testing!", value: EPTATTSTestV4.Testing(id: 8.0, name: "Beta Testing Home", related: []))
                    if firstTestingTabEnabled == true {
                        VStack{
                            Spacer()
                            NavigationLink("Let's Begin Testing!", value: EPTATTSTestV4.Testing(id: 8.0, name: "Beta Testing Home", related: []))
                                .font(.title)
                                .padding()
                                .frame(width: 300, height: 100, alignment: .center)
                                .background(colorModel.tiffanyBlue)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                                .hoverEffect()
                                .navigationDestination(for: Testing.self) { testing in
                                    BetaTestingLandingView(testing: testing, relatedLinkTesting: linkTesting)
                                }
//                            Spacer()
//                            NavigationLink("Test Phase 1", value: EPTATTSTestV4.Testing(id: 12.0, name: "EPTA EHAP1 Test", related: []))
//                                .font(.title)
//                                .padding()
//                                .frame(width: 300, height: 100, alignment: .center)
//                                .background(colorModel.tiffanyBlue)
//                                .foregroundColor(.white)
//                                .cornerRadius(24)
//                                .hoverEffect()
//                                .navigationDestination(for: Testing.self) { testing in
//                                    EHATTSTestPart1View(testing: testing, relatedLinkTesting: linkTesting)
//                                }
                            Spacer()
                        }
                    } else {
                        Text("Please complete the setup tab first")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
            }
            .tabItem {
                Image(systemName: "ear.fill")
                    .accentColor(colorModel.tiffanyBlue)
                Text("2. 1st Testing")
                    .foregroundColor(colorModel.proceedColor)
                    .background(colorModel.proceedColor)
                    .font(.caption)
                
            }
            .tag(2)
            
            NavigationStack(path: $navigationModel.ehaTestingPath) {
                ZStack{
                    colorModel.colorBackgroundDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
                    if secondTestingTabEnabled == true {
                        NavigationLink("Let's Begin The Full EHA Test!", value: EPTATTSTestV4.EHATesting(id: 14.1, name: "EHA Interim Pre Part 2 Test", related: []))
                            .font(.title)
                            .padding()
                            .frame(width: 300, height: 100, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                            .hoverEffect()
                            .navigationDestination(for: EHATesting.self) { ehaTesting in
                                EHAInterimPreEHAP2View(ehaTesting: ehaTesting, relatedLinkEHATesting: linkEHATesting)
                            }
                    } else {
                        Text("Please complete the Setup Tab & the First Test Tab before trying the second test phase")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
            }
            .tabItem {
                Image(systemName: "ear.and.waveform")
                    .accentColor(colorModel.tiffanyBlue)
                Text("3. 2nd Testing")
                    .foregroundColor(colorModel.proceedColor)
                    .background(colorModel.proceedColor)
                    .font(.caption)
                
            }
            .tag(3)
            
            NavigationStack(path: $navigationModel.closingPath) {
                ZStack{
                    colorModel.colorBackgroundBottomDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
//                    NavigationLink("Let's Go View Your Results!", value: EPTATTSTestV4.Closing(id: 15.0, name: "Results Landing View", related: []))
                    if closingTabEnabled == true {
                        NavigationLink("Let's Go View Your Results!", value: EPTATTSTestV4.Closing(id: 15.0, name: "Results Landing View", related: []))
                            .font(.title)
                            .padding()
                            .frame(width: 300, height: 100, alignment: .center)
                            .background(colorModel.tiffanyBlue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                            .hoverEffect()
                            .navigationDestination(for: Closing.self) { closing in
                                ResultsLandingView(closing: closing, relatedLinkClosing: linkClosing)
                            }
                    } else {
                        Text("Please complete the Setup Tab & the First Test Tab & the Second Test Tab before reviewing results")
                        .foregroundColor(.red)
                        .font(.title)
                    }
                }
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard.fill")
                    .foregroundColor(.blue)
                    .background(Color.blue)
                Text("4. Results")
                    .foregroundColor(.blue)
                    .background(Color.blue)
            }
            .tag(4)
            
//            NavigationStack(path: $navigationModel.earSimulatorPath) {
//                ZStack{
//                    colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
//                    NavigationLink("Ear Simulators", value: EPTATTSTestV4.EarSimulator(id: 20.0, name: "Ear Simulator Landing", related: []))
//                        .font(.title)
//                        .padding()
//                        .frame(width: 300, height: 100, alignment: .center)
//                        .background(colorModel.tiffanyBlue)
//                        .foregroundColor(.white)
//                        .cornerRadius(24)
//                        .hoverEffect()
//                        .navigationDestination(for: EarSimulator.self) { earSimulator in
//                            EarSimulatorLandingView(earSimulator: earSimulator, relatedLinkEarSimulator: linkEarSimulator)
//                        }
//                }
//            }
//            .tabItem {
//                Image(systemName: "list.bullet.clipboard.fill")
//                    .foregroundColor(.blue)
//                    .background(Color.blue)
//                Text("4. Results")
//                    .foregroundColor(.blue)
//                    .background(Color.blue)
//            }
//            .tag(5)
        }
    }



            //            HStack{
            //                NavigationLink("User Login", value: dataModel.setups[2])
            //                    .foregroundColor(.green)
            //            }
            //            .navigationDestination(for: Setup.self) { setup in
            //                UserLoginView(setup: setup, relatedLink: link)
            //            }
//            NavigationStack(path: $navigationModel.setupPath) {
//                NavigationLink("Disclaimer", value: EPTATTSTestV4.Setup(id: 1.0, name: "Disclaimer", related: []))
//                    .foregroundColor(.blue)
//                    .navigationDestination(for: Setup.self) { setup in
//                        DisclaimerView(setup: setup, relatedLink: link)
//                    }
                //            List{
                //                ForEach(dataModel.setups, id: \.self) { setup in
                //                    NavigationLink(setup.name, value: setup)
                //                }
                //            }
                
                //            .navigationDestination(for: Setup.self, destination: { setup2 in
                //
                //                DisclaimerView(setup: setup2, relatedLink: link)
                //            })
//
//                    NavigationLink("Login View", value: Setup(id: 2.01, name: "User Login"))
//
//                }
//                .navigationDestination(for: Setup.self) { setup in
//                    DisclaimerView(setup: setup, relatedLink: link)
//                }
//                .navigationDestination(for: Setup.self, destination: { setup in
//                    UserLoginView(setup: setup, relatedLink: link)
//                })
//
//                .environmentObject(navigationModel)
//                .onAppear {
//                    getLinks()
//                }
////            }




    
    func getLinks() {
//        ForEach(dataModel.setups, id: \.self) { setup in
//            NavigationLink(setup.name, value: setup)
//        }
//        ForEach(dataModel.testings, id: \.self) { testing in
//            NavigationLink(testing.name, value: testing)
//        }
//        ForEach(dataModel.ehaTestings, id: \.self) { ehaTesting in
//            NavigationLink(ehaTesting.name, value: ehaTesting)
//        }
//        ForEach(dataModel.closings, id: \.self) { closing in
//            NavigationLink(closing.name, value: closing)
//        }
        print(dataModel.setups)
    }
    
    private func link(setup: Setup) -> some View {
        EmptyView()
    }
    
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
    private func linkEHATesting(ehaTesting: EHATesting) -> some View {
        EmptyView()
    }
    
    private func linkClosing(closing: Closing) -> some View {
        EmptyView()
    }
    
    private func linkEarSimulator(earSimulator: EarSimulator) -> some View {
        EmptyView()
    }
}

/*
struct NavigationView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView()
    }
}
*/


//====================================================
//*************SAVE THIS *****************************
// Original Functional New Nav Links Approach
//
            //NavigationStack(path: $navigationModel.setupPath) {
            //
            //    NavigationLink("User Login", value: dataModel.setups[2])
            //        .foregroundColor(.green)
            //
            //    List{
            //        ForEach(dataModel.setups, id: \.self) { setup in
            //            NavigationLink(setup.name, value: setup)
            //        }
            //    }
            //    .navigationDestination(for: Setup.self) { setup in
            //        UserLoginView(setup: setup, relatedLink: link)
            //    }
            //    .environmentObject(navigationModel)
//                .onAppear {
//                    ForEach(dataModel.setups, id: \.self) { setup in
//                        NavigationLink(setup.name, value: setup)
//                    }
            //    }
            //}
//
// Original Functional New Nav Links Approach
//*************SAVE THIS *****************************
//====================================================



class DataModel: ObservableObject {
    @Published var setups: [Setup] = []
    @Published var testings: [Testing] = []
    @Published var ehaTestings: [EHATesting] = []
    @Published var closings: [Closing] = []
    @Published var earSimulators: [EarSimulator] = []
    
    
    private var setupsById: [Setup.ID: Setup]? = nil
    private var cancellables: [AnyCancellable] = []
    
    private var testingsById: [Testing.ID: Testing]? = nil
    private var testingsCancellables: [AnyCancellable] = []

    private var ehaTestingsById: [EHATesting.ID: EHATesting]? = nil
    private var ehaTestingsCancellables: [AnyCancellable] = []

    private var closingsById: [Closing.ID: Closing]? = nil
    private var closingsCancellables: [AnyCancellable] = []
    
    private var earSimulatorsById: [EarSimulator.ID: EarSimulator]? = nil
    private var earSimulatorsCancellables: [AnyCancellable] = []

    static let shared: DataModel = DataModel()
    
    private init() {
        setups = builtInSetups
        $setups
            .sink { [weak self] _ in
                self?.setupsById = nil
            }
            .store(in: &cancellables)
        
        testings = builtInTestings
        $testings
            .sink { [weak self] _ in
                self?.testingsById = nil
            }
            .store(in: &testingsCancellables)
        
        ehaTestings = builtInEHATestings
        $ehaTestings
            .sink { [weak self] _ in
                self?.ehaTestingsById = nil
            }
            .store(in: &ehaTestingsCancellables)
        
        closings = builtInClosings
        $closings
            .sink { [weak self] _ in
                self?.closingsById = nil
            }
            .store(in: &closingsCancellables)
        
        earSimulators = builtInEarSimulators
        $earSimulators
            .sink { [weak self] _ in
                self?.earSimulatorsById = nil
            }
            .store(in: &earSimulatorsCancellables)
    }
    
    func setups(relatedTo setup: Setup) -> [Setup] {
        setups
            .filter { setup.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(setupId: Setup.ID) -> Setup? {
        if setupsById == nil {
            setupsById = Dictionary(
                uniqueKeysWithValues: setups.map { ($0.id, $0) })
        }
        return setupsById![setupId]
    }
    
    func testings(relatedTo testing: Testing) -> [Testing] {
        testings
            .filter { testing.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(testingId: Testing.ID) -> Testing? {
        if testingsById == nil {
            testingsById = Dictionary(
                uniqueKeysWithValues: testings.map { ($0.id, $0) })
        }
        return testingsById![testingId]
    }
    
    func ehaTestings(relatedTo ehaTesting: EHATesting) -> [EHATesting] {
        ehaTestings
            .filter { ehaTesting.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(ehaTestingId: EHATesting.ID) -> EHATesting? {
        if ehaTestingsById == nil {
            ehaTestingsById = Dictionary(
                uniqueKeysWithValues: ehaTestings.map { ($0.id, $0) })
        }
        return ehaTestingsById![ehaTestingId]
    }
    
    func closings(relatedTo closing: Closing) -> [Closing] {
        closings
            .filter { closing.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(closingId: Closing.ID) -> Closing? {
        if closingsById == nil {
            closingsById = Dictionary(
                uniqueKeysWithValues: closings.map { ($0.id, $0) })
        }
        return closingsById![closingId]
    }

    func earSimulators(relatedTo earSimulator: EarSimulator) -> [EarSimulator] {
        earSimulators
            .filter { earSimulator.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(earSimulatorId: EarSimulator.ID) -> EarSimulator? {
        if earSimulatorsById == nil {
            earSimulatorsById = Dictionary(
                uniqueKeysWithValues: earSimulators.map { ($0.id, $0) })
        }
        return earSimulatorsById![earSimulatorId]
    }
}
    
private let builtInSetups: [Setup] = {
    var setups = [
        "Disclaimer": Setup(id: 1.0, name: "Disclaimer", related: []),
        "User Setup": Setup(id: 2.0, name: "User Setup", related: []),
        "User Login": Setup(id: 2.01, name: "User Login", related: []),
        "UserDataSplash": Setup(id: 2.02, name: "UserDataSplash", related: []),
        "Test Explanation": Setup(id: 3.0, name: "Test Explanation", related: []),
        "Test Selection Home": Setup(id: 4.0, name: "Test Selection Home", related: []),
        "Test Selection": Setup(id: 4.2, name: "Test Selection", related: []),
        "TestSelectionSplash": Setup(id: 4.21, name: "TestSelectionSplash", related: []),
        "EHA Description": Setup(id: 4.01, name: "EHA Description", related: []),
        "Corrective Filters": Setup(id: 4.02, name: "Corrective Filters", related: []),
        "EPTA Description": Setup(id: 4.03, name: "EPTA Description", related: []),
        "Simple Trial Description": Setup(id: 4.04, name: "Simple Trial Description", related: []),
        "Calibrated Devices": Setup(id: 5.0, name: "Calibrated Devices", related: []),
        "CalibratedDevicesSplash": Setup(id: 5.01, name: "CalibratedDevicesSplash", related: []),
        "CalibratedDevicesIssue": Setup(id: 5.02, name: "CalibratedDevicesIssue", related: []),
        "Manual Device Information": Setup(id: 5.1, name: "Manual Device Information", related: []),
        "Disclaimer Manual Device": Setup(id: 5.11, name: "Disclaimer Manual Device", related: []),
        "Manual Device Entry": Setup(id: 5.12, name: "Manual Device Entry", related: []),
        "ManualDeviceEntrySplash": Setup(id: 5.13, name: "ManualDeviceEntrySplash", related: []),
        "Test Instructions": Setup(id: 6.0, name: "Test Instructions", related: []),
        "Siri Setup": Setup(id: 7.0, name: "Siri Setup", related: []),
        "Silent Mode": Setup(id: 7.01, name: "Silent Mode", related: []),
        "Do Not Disturb Mode": Setup(id: 7.02, name: "Do Not Disturb Mode", related: []),
        "System Volume Mode": Setup(id: 7.03, name: "System Volume Mode", related: []),
        "Manual System Setup": Setup(id: 7.1, name: "Manual System Setup", related: []),
        "Manual Setup Instructions": Setup(id: 7.11, name: "Manual Setup Instructions", related: []),
        "Test Device Settings": Setup(id: 7.2, name: "Test Device Settings", related: []),
        "In App Purchase": Setup(id: 4.1, name: "In App Purchase", related: [])
    ]
    
//    setups["User Setup"]!.related = [
  //        setups["User Login"]!.id,
  //        setups["UserDataSplash"]!.id
  //    ]
  //
  //    setups["User Login"]!.related = [setups["UserDataSplash"]!.id]
  //    setups["UserDataSplash"]!.related = [setups["User Login"]!.id]
  //
  //
  //    setups["Test Selection Home"]!.related = [
  //        setups["Test Selection"]!.id,
  //        //        setups["TestSelectionSplash"]!.id,
  //        setups["EHA Description"]!.id,
  //        setups["Corrective Filters"]!.id,
  //        setups["EPTA Description"]!.id,
  //        setups["Simple Trial Description"]!.id,
  //        setups["In App Purchase"]!.id,
  //        //        setups["Calibrated Devices"]!.id
  //    ]
  //
  //    setups["Test Selection"]!.related = [setups["Test Selection Home"]!.id]
  //
  //    //    setups["Test Selection Home"]!.related = [setups["EHA Description"]!.id]
  //    setups["EHA Description"]!.related = [setups["Test Selection Home"]!.id]
  //    setups["EHA Description"]!.related = [setups["In App Purchase"]!.id]
  //    setups["In App Purchase"]!.related = [setups["EHA Description"]!.id]
  //
  //    //    setups["Test Selection Home"]!.related = [setups["Corrective Filters"]!.id]
  //    setups["Corrective Filters"]!.related = [setups["Test Selection Home"]!.id]
  //    setups["Corrective Filters"]!.related = [setups["In App Purchase"]!.id]
  //    setups["In App Purchase"]!.related = [setups["Corrective Filters"]!.id]
  //
  //    //    setups["Test Selection Home"]!.related = [setups["EPTA Description"]!.id]
  //    setups["EPTA Description"]!.related = [setups["Test Selection Home"]!.id]
  //    setups["EPTA Description"]!.related = [setups["In App Purchase"]!.id]
  //    setups["In App Purchase"]!.related = [setups["EPTA Description"]!.id]
  //
  //    //    setups["Test Selection Home"]!.related = [setups["Simple Trial Description"]!.id]
  //    setups["Simple Trial Description"]!.related = [setups["Test Selection Home"]!.id]
  //    setups["Simple Trial Description"]!.related = [setups["In App Purchase"]!.id]
  //    setups["In App Purchase"]!.related = [setups["Simple Trial Description"]!.id]
  //
  //
  //    setups["Test Selection"]!.related = [
  //        setups["TestSelectionSplash"]!.id,
  //        //        setups["EHA Description"]!.id,
  //        //        setups["Corrective Filters"]!.id,
  //        //        setups["EPTA Description"]!.id,
  //        //        setups["Simple Trial Description"]!.id,
  //        //        setups["In App Purchase"]!.id,
  //        setups["Calibrated Devices"]!.id
  //    ]
  //
  //    setups["TestSelectionSplash"]!.related = [setups["Test Selection"]!.id]
  //    setups["Calibrated Devices"]!.related = [setups["Test Selection"]!.id]
  //
  //    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  //    //Stopping Here for Relationships to Test Navigation Thus Far
  //
  //
  //    setups["Calibrated Devices"]!.related = [
  //        setups["CalibratedDevicesSplash"]!.id,
  //        setups["CalibratedDevicesIssue"]!.id,
  //        setups["Manual Device Information"]!.id,
  //        setups["Disclaimer Manual Device"]!.id,
  //        setups["Manual Device Entry"]!.id,
  //        setups["ManualDeviceEntrySplash"]!.id
  //    ]
  //
  //    setups["Siri Setup"]!.related = [
  //        setups["Silent Mode"]!.id,
  //        setups["Do Not Disturb Mode"]!.id,
  //        setups["System Volume Mode"]!.id,
  //        setups["Manual System Setup"]!.id,
  //        setups["Manual Setup Instructions"]!.id
  //    ]
    
    return Array(setups.values)
    
}()
        
        
private let builtInTestings: [Testing] = {
    var testings = [
        "Beta Testing Home": Testing(id: 8.0, name: "Beta Testing Home", related: []),
        "Test ID Entry": Testing(id: 9.0, name: "Test ID Entry", related: []),
        "Hearing Survey": Testing(id: 10.0, name: "Hearing Survey", related: []),
        "SurveyErrorView": Testing(id: 10.01, name: "SurveyErrorView", related: []),
        "Pre Test Landing": Testing(id: 11, name: "Pre Test Landing", related: []),
        "Training Test": Testing(id: 11.1, name: "Training Test", related: []),
        "Training Test Holding": Testing(id: 11.11, name: "Training Test Holding", related: []),
        "1kHz Test": Testing(id: 11.2, name: "1kHz Test", related: []),
        "Post 1kHz Test": Testing(id: 11.21, name: "Post 1kHz Test", related: []),
        "EPTA EHA Part 1 Test": Testing(id: 12.0, name: "EPTA EHAP1 Test", related: []),
        "Simple Test": Testing(id: 12.1, name: "Simple Test", related: []),
        "Post All Test Landing": Testing(id: 13.0, name: "Post All Test Landing", related:[]),
        "Post Test Director": Testing(id: 13.1, name: "Post Test Director", related: []),
        "Post EPTA Test": Testing(id: 13.2, name: "Post EPTA Test", related: []),
        "Post Simple Test": Testing(id: 13.3, name: "Post Simple Test", related: []),
        "EHA Interim Post Test": Testing(id: 14.0, name: "EHA Interim Post Test", related: [])
    ]
    
    return Array(testings.values)
}()

private let builtInEHATestings: [EHATesting] = {
    var ehaTestings = [
        "EHA Interim Pre Part 2 Test": EHATesting(id: 14.1, name: "EHA Interim Pre Part 2 Test", related: []),
        "EHA Part 2 Test": EHATesting(id: 14.1, name: "EHA Part 2 Test", related: []),
        "Post EHA Part 2 Test": EHATesting(id: 14.2, name: "Post EHA Part 2 Test", related: [])
    ]
    
    return Array(ehaTestings.values)
}()
    
private let builtInClosings: [Closing] = {
    var closings = [
        "Test Results Landing": Closing(id: 15.0, name: "Test Results Landing", related: []),
        "EPTA Test Results": Closing(id: 15.1, name: "EPTA Test Results", related: []),
        "EHA Test Results": Closing(id: 15.2, name: "EHA Test Results", related: []),
        "Simple Test Results": Closing(id: 15.3, name: "Simple Test Results", related: []),
        "Test Results Holding 1": Closing(id: 15.4, name: "Test Results Holding 1", related: []),
        "Test Results Holding 2": Closing(id: 15.5, name: "Test Results Holding 2", related: []),
        "Test Results Holding 3": Closing(id: 15.6, name: "Test Results Holding 3", related: []),
        "Post Test Purchse": Closing(id: 16.0, name: "Post Test Purchse", related: []),
        "Post Test Purchse Holding 1": Closing(id: 16.1, name: "Post Test Purchse Holding 1", related: []),
        "Post Test Purchse Holding 2": Closing(id: 16.1, name: "Post Test Purchse Holding 2", related: []),
        "Closing": Closing(id: 17.0, name: "Closing", related: []),
        "Closing Holding 1": Closing(id: 17.1, name: "Closing Holding 1", related: []),
        "Closing Holding 2": Closing(id: 17.2, name: "Closing Holding 2", related: [])
    ]
    
    return Array(closings.values)
}()

private let builtInEarSimulators: [EarSimulator] = {
    var earSimulators = [
        "Ear Simulator Landing": EarSimulator(id: 20.0, name: "Ear Simulator Landing", related: []),
        "Ear Simulator Manual 1": EarSimulator(id: 20.1, name: "Ear Simulator Manual 1", related: []),
        "Ear Simulator Manual 2": EarSimulator(id: 20.2, name: "Ear Simulator Manual 2", related: []),
        "Ear Simulator Manual 0": EarSimulator(id: 20.3, name: "Ear Simulator Manual 2", related: [])
    ]
    
    return Array(earSimulators.values)
}()
    

struct Setup: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [Setup.ID] = []
}

struct Testing: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [Testing.ID] = []
}

struct EHATesting: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [EHATesting.ID] = []
}

struct Closing: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [Closing.ID] = []
}

struct EarSimulator: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [EarSimulator.ID] = []
}



final class NavigationModel: ObservableObject, Codable {
    
    @Published var setupPath: [Setup]
    @Published var testingPath: [Testing]
    @Published var ehaTestingPath: [EHATesting]
    @Published var closingPath: [Closing]
    @Published var earSimulatorPath: [EarSimulator]
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    private lazy var decoderTesting = JSONDecoder()
    private lazy var encoderTesting = JSONEncoder()
    
    private lazy var decoderEHATesting = JSONDecoder()
    private lazy var encoderEHATesting = JSONEncoder()
    
    private lazy var decoderClosing = JSONDecoder()
    private lazy var encoderClosing = JSONEncoder()
    
    private lazy var decoderEarSimulator = JSONDecoder()
    private lazy var encoderEarSimulator = JSONEncoder()
    
    init(setupPath: [Setup] = [], testingPath: [Testing] = [], ehaTestingPath: [EHATesting] = [], closingPath: [Closing] = [], earSimulatorPath: [EarSimulator] = []
    ) {
        self.setupPath = setupPath
        self.testingPath = testingPath
        self.ehaTestingPath = ehaTestingPath
        self.closingPath = closingPath
        self.earSimulatorPath = earSimulatorPath
    }
    
    var selectedSetup: Setup? {
        get { setupPath.first }
        set { setupPath = [newValue].compactMap { $0 } }
    }
    
    var selectedTesting: Testing? {
        get { testingPath.first }
        set { testingPath = [newValue].compactMap { $0 } }
    }
    
    var selectedEHATesting: EHATesting? {
        get { ehaTestingPath.first }
        set { ehaTestingPath = [newValue].compactMap { $0 } }
    }
    
    var selectedClosing: Closing? {
        get { closingPath.first }
        set { closingPath = [newValue].compactMap { $0 } }
    }
    
    var selectedEarSimulator: EarSimulator? {
        get { earSimulatorPath.first }
        set { earSimulatorPath = [newValue].compactMap { $0 } }
    }
    
    var jsonData: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let data = newValue,
                  let model = try? decoder.decode(Self.self, from: data)
            else { return }
            setupPath = model.setupPath
        }
    }
    
    var jsonDataTesting: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let dataTesting = newValue,
                  let model = try? decoder.decode(Self.self, from: dataTesting)
            else { return }
            testingPath = model.testingPath
        }
    }

    var jsonDataEHATesting: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let dataEHATesting = newValue,
                  let model = try? decoder.decode(Self.self, from: dataEHATesting)
            else { return }
            ehaTestingPath = model.ehaTestingPath
        }
    }
    
    var jsonDataClosing: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let dataClosing = newValue,
                  let model = try? decoder.decode(Self.self, from: dataClosing)
            else { return }
            closingPath = model.closingPath
        }
    }
    
    var jsonDataEarSimulator: Data? {
        get { try? encoderEarSimulator.encode(self) }
        set {
            guard let dataEarSimulator = newValue,
                  let model = try? decoderEarSimulator.decode(Self.self, from: dataEarSimulator)
            else { return }
            earSimulatorPath = model.earSimulatorPath
        }
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let setupPathIds = try container.decode(
            [Setup.ID].self, forKey: .setupPathIds)
        let testingPathIds = try container.decode(
            [Testing.ID].self, forKey: .testingPathIds)
        let ehaTestingPathIds = try container.decode(
            [EHATesting.ID].self, forKey: .ehaTestingPathIds)
        let closingPathIds = try container.decode(
            [Closing.ID].self, forKey: .closingPathIds)
        let earSimulatorPathIds = try container.decode(
            [EarSimulator.ID].self, forKey: .ehaTestingPathIds)
            
        self.setupPath = setupPathIds.compactMap { DataModel.shared[$0] }
        self.testingPath = testingPathIds.compactMap { DataModel.shared[$0] }
        self.ehaTestingPath = ehaTestingPathIds.compactMap { DataModel.shared[$0] }
        self.closingPath = closingPathIds.compactMap { DataModel.shared[$0] }
        self.earSimulatorPath = earSimulatorPathIds.compactMap { DataModel.shared[$0] }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setupPath.map(\.id), forKey: .setupPathIds)
        try container.encode(testingPath.map(\.id), forKey: .testingPathIds)
        try container.encode(ehaTestingPath.map(\.id), forKey: .ehaTestingPathIds)
        try container.encode(closingPath.map(\.id), forKey: .closingPathIds)
        try container.encode(earSimulatorPath.map(\.id), forKey: .earSimulatorPathIds)
    }

    enum CodingKeys: String, CodingKey {
        case setupPathIds
        case testingPathIds
        case ehaTestingPathIds
        case closingPathIds
        case earSimulatorPathIds
    }
}
