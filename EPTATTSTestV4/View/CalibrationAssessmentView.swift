//
//  CalibrationAssessmentView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

//@State var headphoneDevice: CalibratedModels = .Unknown
//enum CalibratedModels: String, CaseIterable, Identifiable {
//    case Apple_AirPods_Generation_2
//    case Apple_AirPods_Generation_3
//    case Apple_Air_Pod_Pro
//    case Apple_Air_Pods_Max
//    case Beats_Studio_Buds
//    case Beats_Fit_Pro
//    case Beats_Studio_3
//    case Jabra_Elite_85t
//    case Nura_True
//    case Skullcandy_Indy_Anc
//    case Soundcore_Liberty_3
//    case TTS_Testing_System
//    case Unknown
//    case Not_Listed
//    var id: Self { self }
//}
//
//enum Brand: String, CaseIterable, Identifiable {
//    case Apple
//    case Beats
//    case TTS
//    case Jabra
//    case Nura
//    case Skullcandy
//    case Soundcore
//    case True_To_Source
//    var id: Self { self }
//}
//
//List {
//    Picker("Ear/Headphone Device", selection: $headphoneDevice) {
//        Text("Apple AirPods Generation 2").tag(CalibratedModels.Apple_AirPods_Generation_2)
//        Text("Apple AirPods Generation 3").tag(CalibratedModels.Apple_AirPods_Generation_3)
//        Text("Apple Air Pod Pro").tag(CalibratedModels.Apple_Air_Pod_Pro)
//        Text("Apple Air Pods Max").tag(CalibratedModels.Apple_Air_Pods_Max)
//        Text("Beats Studio Buds").tag(CalibratedModels.Beats_Studio_Buds)
//        Text("Beats Fit Pro").tag(CalibratedModels.Beats_Fit_Pro)
//        Text("Beats Studio 3").tag(CalibratedModels.Beats_Studio_3)
//        Text("Jabra Elite 85t").tag(CalibratedModels.Jabra_Elite_85t)
//        Text("Nura True").tag(CalibratedModels.Nura_True)
//        Text("Skullcandy Indy Anc").tag(CalibratedModels.Skullcandy_Indy_Anc)
//        Text("Soundcore Liberty 3").tag(CalibratedModels.Soundcore_Liberty_3)
//        Text("TTS Testing System").tag(CalibratedModels.TTS_Testing_System)
//        Text("Unknown").tag(CalibratedModels.Unknown)
//        Text("Not Listed").tag(CalibratedModels.Not_Listed)
//    }
//}

import SwiftUI

struct HeadphoneModels: Identifiable, Hashable {
    let name: String
    let id = UUID()
    var isToggledH = false
    init(name: String) {
        self.name = name
    }
}

struct CalibrationAssessmentView: View {
   
    @StateObject var colorModel: ColorModel = ColorModel()
//    @State var deviceSelection = 1
    @StateObject var deviceSelectionModel: DeviceSelectionModel = DeviceSelectionModel()
    @State var showDeviceSheet: Bool = false
    @State var refreshView: Bool = false
//    @State var deviceListSheet = DeviceListSheet()
    @Environment(\.presentationMode) var presentationMode
    
    @State var deviceSelectionIndex = [Int]()
    @State var deviceApprovalFinding = Int()
    @State var selectedDeviceName: [String] = [""]
    @State var selectedDeviceUUID: [UUID] = [UUID]()
    @State var multipleDevicesCheck = [Int]()
    @State var notifyOfMultipleDevices = Int()
    @State var isOkayToProceed = Bool()
    @State var isSubmitted: Bool = false
    @State private var linkColors: [Color] = [Color.clear, Color.green]
    @State private var linkColors2: [Color] = [Color.clear, Color.white]
    @State private var linkColorIndex = 0
    
    @State var headphones = [
        HeadphoneModels(name: "Not Listed"),
        HeadphoneModels(name: "Unknown"),
        HeadphoneModels(name: "TTS Testing System"),
        HeadphoneModels(name: "Apple AirPods Generation 2"),
        HeadphoneModels(name: "Apple AirPods Generation 3"),
        HeadphoneModels(name: "Apple Air Pod Pro"),
        HeadphoneModels(name: "Apple Air Pods Max"),
        HeadphoneModels(name: "Beats Studio Buds"),
        HeadphoneModels(name: "Beats Fit Pro"),
        HeadphoneModels(name: "Beats Studio 3"),
        HeadphoneModels(name: "Jabra Elite 85t"),
        HeadphoneModels(name: "Nura True"),
        HeadphoneModels(name: "Skullcandy Indy Anc"),
        HeadphoneModels(name: "Soundcore Liberty 3")
    ]
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
                VStack {
                Spacer()
                    Text("Select The Type of Ear/Headphones You Are Using or Select The Most Appropriate Option Available.")
                        .padding()
                        .foregroundColor(.white)
                    
                    Text("ONLY SELECT ONE ITEM!")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showDeviceSheet.toggle()
                       
                    }, label: {
                        Text("Open Our List of Calibrated Ear/Headphones")
                            .padding()
                            .foregroundColor(colorModel.neonGreen)
                        Image(systemName: "arrow.up.doc.on.clipboard")
                            .padding()
                            .foregroundColor(colorModel.neonGreen)
                    })
                    Spacer()
                    .fullScreenCover(isPresented: $showDeviceSheet, content: {
                        VStack(alignment: .leading) {
            
                            Button(action: {
                                showDeviceSheet.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .padding(10)
                                    .foregroundColor(.red)
                            })
                            List {
                                ForEach(headphones.indices, id: \.self) {index in
                                HStack {
                                   
                                    Text("\(self.headphones[index].name)")
                                        .foregroundColor(.blue)
                                  
                                    Toggle("", isOn: self.$headphones[index].isToggledH)
                                        .foregroundColor(.blue)
                                        .onChange(of: self.headphones[index].isToggledH) { nameIndex in
                                            Task(priority: .userInitiated, operation: {
//                                                deviceApprovalFinding = Int()
//                                                selectedDeviceName.removeAll()
//                                                selectedDeviceUUID.removeAll()
//                                                deviceSelectionModel.userSelectedDeviceName.removeAll()
//                                                deviceSelectionModel.userSelectedDeviceUUID.removeAll()
//                                                deviceSelectionModel.userSelectedDeviceIndex.removeAll()
//                                                deviceSelectionModel.headphoneModelsUnknownIndex.removeAll()
                                                deviceSelectionIndex.removeAll()
                                                selectedDeviceName.append(self.headphones[index].name)
                                                selectedDeviceUUID.append(self.headphones[index].id)
                                                
                                                deviceApprovalFinding = index
                                                multipleDevicesCheck.append(deviceApprovalFinding)
                                                deviceSelectionModel.userSelectedDeviceName.append(headphones[index].name)
                                                deviceSelectionModel.userSelectedDeviceUUID.append(headphones[index].id)
                                                deviceSelectionModel.userSelectedDeviceIndex.append(index)
                                                deviceSelectionModel.headphoneModelsUnknownIndex.append(self.headphones.count)
                                                deviceSelectionIndex.append(index)
                                                
                                                print("isokaytoproceed: \(isOkayToProceed)")
                                                print("multipledevices: \(multipleDevicesCheck)")
                                                print(index)
                                                print(nameIndex)
                                                print(selectedDeviceName)
                                                print(selectedDeviceUUID)
                                                print(self.headphones[index].name)
                                                print(self.headphones[index].id)
                                                print(self.headphones[0].id)
                                                print(deviceSelectionIndex)
                                                print(deviceSelectionModel.userSelectedDeviceName)
                                                print(deviceSelectionModel.userSelectedDeviceUUID)
                                                print(deviceSelectionModel.userSelectedDeviceIndex)
                                            })
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                Task(priority: .userInitiated, operation: {
                                    deviceApprovalFinding = Int()
                                    isSubmitted = false
                                    notifyOfMultipleDevices = Int()
                                    isOkayToProceed = false
                                    deviceApprovalFinding = Int()
                                    selectedDeviceName.removeAll()
                                    selectedDeviceUUID.removeAll()
                                    deviceSelectionModel.userSelectedDeviceName.removeAll()
                                    deviceSelectionModel.userSelectedDeviceUUID.removeAll()
                                    deviceSelectionModel.userSelectedDeviceIndex.removeAll()
                                    deviceSelectionModel.headphoneModelsUnknownIndex.removeAll()
                                    deviceSelectionIndex.removeAll()
                                    deviceSelectionModel.deviceSelection.removeAll()
                                })
                            }
                        }
                    })
                    HStack{
                        Spacer()
                        Toggle("Submit Selection", isOn: $isSubmitted)
                            .foregroundColor(.blue)
                            .font(.title3)
                            .padding(.leading)
                            .padding(.trailing)
                            .toggleStyle(.switch)
                            .onChange(of: isSubmitted) { submittedValue in
                                Task(priority: .userInitiated, operation: {
                                    if submittedValue == true {
                                        await checkMultipleDevices()
                                        await manualDeviceEntryNeeded()
                                        await compareDeviceCalibration()
                                        }
                                    })
                                }
                        Spacer()
                    }
                    .onChange(of: notifyOfMultipleDevices) { notifyofMultipleValues in
                        Task(priority: .userInitiated, operation: {
                            if notifyofMultipleValues == 1 {
                                isSubmitted.toggle()
                                self.isOkayToProceed = false
                                self.linkColorIndex = 1
                                multipleDevicesCheck.removeAll()
                            } else if notifyofMultipleValues == 2 {
                                self.isOkayToProceed = true
                                self.linkColorIndex = 1
                                Task {
                                    await appendDeviceCalibrationResults()
                                    await concentenateFinalDeviceArrays()
                                    await saveCalibrationData()
                                }
                                multipleDevicesCheck.removeAll()
                            }
                        })
                    }
                    Spacer()
                    NavigationLink(destination:
                                    isOkayToProceed == false ? AnyView(CalibrationIssueSplashView())
                                    : multipleDevicesCheck.count > 1 ? AnyView(CalibrationIssueSplashView())
                                    : deviceApprovalFinding == 0 ? AnyView(CalibrationSplashView())
                                    : deviceApprovalFinding == 1 ? AnyView(ManualDeviceEntryInformationView())
                                    : AnyView(InstructionsForTakingTest())
                    ){
                        HStack{
                            Spacer()
                            Text("Now Let's Contine!")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                       }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(linkColors[linkColorIndex])
                        .foregroundColor(linkColors2[linkColorIndex])
                        .cornerRadius(300)
                    }
                    Spacer()
                }
            Spacer()
            }
            .onAppear {
                isSubmitted = false
                linkColorIndex = 0
            }
            .environmentObject(deviceSelectionModel)
    }
    
    
    func manualDeviceEntryNeeded() async {
        if deviceSelectionIndex.count > 0 {
            if deviceSelectionIndex.last! == 0 {
                //Not Listed Selected; Go To Splash
                deviceSelectionModel.deviceSelection.append(0)
                print("User is using an unapproved device")
            } else if deviceSelectionIndex.last! == 1 {
                //Unknow selected; Go To Manual Entry
                deviceSelectionModel.deviceSelection.append(1)
                print("User is using an unknown device")
            } else if deviceSelectionIndex.last! >= 2 {
                // Accepted device selected; proceed to disclaimer view
                deviceSelectionModel.deviceSelection.append(2)
                print("User is using a Approved device")
            } else {
              // Error go to Manual Entry
                deviceSelectionModel.deviceSelection.append(3)
                print("!!!Error Device Selection Error")
            }
        } else {
            print("!!!Error in manualDeviceEntryNeeded First Logic Block")
        }
    }
       
    func compareDeviceCalibration()  async {
        if  deviceApprovalFinding == 0 {
//            deviceApprovalFinding = 0
            deviceSelectionModel.manualDeviceEntryRequired.append(0)
//            print(deviceApprovalFinding)
//            print(deviceSelectionModel.manualDeviceEntryRequired)
            print("User is using an unapproved device")
//            print(deviceApprovalFinding)
//            print(deviceSelectionModel.userSelectedDeviceName)
//            print(deviceSelectionModel.userSelectedDeviceUUID)
//            print(deviceSelectionModel.userSelectedDeviceIndex)
        } else if   deviceApprovalFinding == 1 {
            deviceApprovalFinding = 1
            deviceSelectionModel.manualDeviceEntryRequired.append(0)
//            print(deviceApprovalFinding)
//            print(deviceSelectionModel.manualDeviceEntryRequired)
            print("User is using an unknown device")
//            print(deviceSelectionModel.userSelectedDeviceName)
//            print(deviceSelectionModel.userSelectedDeviceUUID)
//            print(deviceSelectionModel.userSelectedDeviceIndex)
        } else if deviceApprovalFinding > 1 {
            deviceApprovalFinding = 2
            deviceSelectionModel.manualDeviceEntryRequired.append(2)
//            print(deviceApprovalFinding)
//            print(deviceSelectionModel.manualDeviceEntryRequired)
            print("User States Device is Unknown")
            print("Manual Device Entry is Required")
//            print(deviceSelectionModel.userSelectedDeviceName)
//            print(deviceSelectionModel.userSelectedDeviceUUID)
//            print(deviceSelectionModel.userSelectedDeviceIndex)
        } else {
            print("Error!!! in compareDeviceCalibration Func")
//            print(deviceApprovalFinding)
//            print(deviceSelectionModel.manualDeviceEntryRequired)
//            print(deviceSelectionModel.userSelectedDeviceName)
//            print(deviceSelectionModel.userSelectedDeviceUUID)
//            print(deviceSelectionModel.userSelectedDeviceIndex)
        }
    }
    
    func checkMultipleDevices() async {
        if multipleDevicesCheck.count > 1 {
            self.isOkayToProceed = false
            notifyOfMultipleDevices = 1
            self.linkColorIndex = 0
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("Error, multiple Devices Selected in check multiple devices")
        } else if multipleDevicesCheck.count == 1 {
            self.isOkayToProceed = true
            notifyOfMultipleDevices = 2
            self.linkColorIndex = 1
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("Only On Device Selected")
        } else {
            self.isOkayToProceed = false
            notifyOfMultipleDevices = 1
            self.linkColorIndex = 0
            print("isokaytoproceed check: \(isOkayToProceed)")
            print("multipleDevices check: \(multipleDevicesCheck)")
            print("!!!Error in checkMultipleDevices() Logic")
        }
    }
    
    
    func resetCheckMultipleDevices() async {
        multipleDevicesCheck.removeAll()
        isOkayToProceed = false
        notifyOfMultipleDevices = Int()
        linkColorIndex = 0
        print("multipleDevices reset: \(multipleDevicesCheck)")
        print("isokaytoproceed reset: \(isOkayToProceed)")
    }

// This is duplicating the appends in the toggle functions in view
    func appendDeviceCalibrationResults()  async {
//        deviceSelectionModel.userSelectedDeviceName.append(contentsOf: selectedDeviceName)
//        deviceSelectionModel.userSelectedDeviceUUID.append(contentsOf: selectedDeviceUUID)
//        deviceSelectionModel.userSelectedDeviceIndex.append(contentsOf: deviceSelectionIndex)
//        deviceSelectionModel.headphoneModelsUnknownIndex.append(self.headphones.count)
        print("deviceSelectionModel userSelectedDeviceName: \(deviceSelectionModel.userSelectedDeviceName)")
        print("deviceSelectionModel userSelectedDeviceUUID: \(deviceSelectionModel.userSelectedDeviceUUID)")
        print("deviceSelectionModel userSelectedDeviceIndex: \(deviceSelectionModel.userSelectedDeviceIndex)")
        print("deviceSelectionModel headphoneModelisUnknownIndex: \(deviceSelectionModel.headphoneModelsUnknownIndex)")
    }
    
    func concentenateFinalDeviceArrays() async {
        deviceSelectionModel.finalDevicSelectionName.append(contentsOf: deviceSelectionModel.userSelectedDeviceName)
        deviceSelectionModel.finalDeviceSelectionIndex.append(contentsOf: deviceSelectionModel.userSelectedDeviceIndex)
        deviceSelectionModel.finalDeviceSelectionUUID.append(contentsOf: deviceSelectionModel.userSelectedDeviceUUID)
        deviceSelectionModel.finalHeadphoneModelIsUnknownIndex.append(contentsOf: deviceSelectionModel.headphoneModelsUnknownIndex)
        print("deviceSelectionModel finalDeviceSelectionName: \(deviceSelectionModel.finalDevicSelectionName)")
        print("deviceSelectionModel finalDeviceSelectionIndex: \(deviceSelectionModel.finalDeviceSelectionIndex)")
        print("deviceSelectionModel finalDeviceSelectionUUID: \(deviceSelectionModel.finalDeviceSelectionUUID)")
        print("deviceSelectionModel finalHeadphoneModelIsUnknownIndex: \(deviceSelectionModel.finalHeadphoneModelIsUnknownIndex)")
    }
    
    func saveCalibrationData() async {
        await deviceSelectionModel.getDeviceData()
        await deviceSelectionModel.saveDeviceToJSON()
        await deviceSelectionModel.writeDeviceResultsToCSV()
        await deviceSelectionModel.writeInputDeviceResultsToCSV()
    }
    
}


//struct CalibrationAssessmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalibrationAssessmentView()
//            .environmentObject(DeviceSelectionModel())
//            
//    }
//}


