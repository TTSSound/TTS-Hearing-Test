//
//  ManualDeviceDisclaimerView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI


// Add in user agreed store variable and time of agreement CMseconds and Date

struct ManualDeviceDisclaimerView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @State var uncalibratedAgreementModel: UncalibratedAgreementModel = UncalibratedAgreementModel()
//    @EnvironmentObject var deviceSelectionModel: DeviceSelectionModel
//    @StateObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
//    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
    @StateObject var manualDisclaimerModel: ManualDisclaimerModel = ManualDisclaimerModel()
    @State var uncalDisclaimerSetting = Bool()
    @State var uncalDisclaimerAgreement = Int()
    @State var unLinkColors: [Color] = [Color.clear, Color.green]
    @State var unLinkColorIndex = Int()
    @State var uncalUserAgreed: Bool = false
    @State var uncalUserAgreedDate: Date = Date()
    var urlFile: URL = URL(fileURLWithPath: "uncalibratedAgreementText.txt")
    
    var body: some View {

        ZStack{
            colorModel.colorBackgroundBottomRed .ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                GroupBox(label:
                            Label("Uncalibrated Device Agreement", systemImage: "building.columns").foregroundColor(.black)
                    ) {
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(uncalibratedAgreementModel.uncalibratedAgreementText)
                                .foregroundColor(.black)
                                .font(.footnote)
                        }
                        .frame(height: 375)
                        Toggle(isOn: $uncalUserAgreed) {
                            Text("I agree to the above terms")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                        .padding(.leading)
                    }
                    .padding()
                    .onAppear(perform: {
                        loadUncalibratedAgreement()
                    })
                    .onChange(of: uncalUserAgreed) { _ in
                        Task {
                            unLinkColorIndex = 1
                            uncalDisclaimerSetting = uncalUserAgreed
                            uncalUserAgreedDate = Date.now
                            await uncalCompareDisclaimerAgreement()
                            await uncalDisclaimerResponse()
                            await concentenateFinalUncalDisclaimerArrays()
                            await saveManualDeviceDisclaimer()
                            print("uncalDisclaimerSetting: \(uncalDisclaimerSetting)")
                            print("uncalDisclaimerAgreement: \(uncalDisclaimerAgreement)")
                        }
                    }
                Spacer()
                NavigationLink(destination:
                                uncalUserAgreed == true ? AnyView(ManualDeviceEntryView())
                                : uncalUserAgreed == false ? AnyView(ManualDeviceEntryInformationView())
                                : AnyView(ManualDeviceEntryInformationView())
                ){  VStack{
                    Image(systemName: "arrowshape.bounce.right")
                    Text("Let's Proceed")
                    }
                }
                .foregroundColor(unLinkColors[unLinkColorIndex])
                .onTapGesture {
                    Task(priority: .userInitiated, operation: {
//                        await uncalCompareDisclaimerAgreement()
//                        await uncalDisclaimerResponse()
//                        await concentenateFinalUncalDisclaimerArrays()
//                        await saveManualDeviceDisclaimer()
                        print("uncalDisclaimerSetting: \(uncalDisclaimerSetting)")
                        print("uncalDisclaimerAgreement: \(uncalDisclaimerAgreement)")
                    })
                }
                .padding(.bottom, 40)
                Spacer()
            }
            .environmentObject(manualDisclaimerModel)
        }
    }


    func loadUncalibratedAgreement() {
        uncalibratedAgreementModel.load(file: uncalibratedAgreementModel.uncalibratedAgreementText)
    }

    func uncalCompareDisclaimerAgreement() async {
        if uncalDisclaimerSetting == true {
        uncalDisclaimerAgreement = 1
        print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")

        } else if uncalDisclaimerSetting == false {
            uncalDisclaimerAgreement = 0
        print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")
        } else {
            uncalDisclaimerAgreement = 2
        print("Disclaimer Response: \(uncalDisclaimerAgreement) & \(uncalDisclaimerSetting)")
        }
    }

    func uncalDisclaimerResponse() async {
        uncalDisclaimerSetting = true
        if manualDisclaimerModel.uncalibratedUserAgreement.count < 1 || manualDisclaimerModel.uncalibratedUserAgreement.count > 1{
            manualDisclaimerModel.uncalibratedUserAgreement.append(uncalDisclaimerSetting)
            print(manualDisclaimerModel.uncalibratedUserAgreement)
        } else if uncalDisclaimerSetting == false {
            manualDisclaimerModel.uncalibratedUserAgreement.removeAll()
            manualDisclaimerModel.uncalibratedUserAgreement.append(uncalDisclaimerSetting)
            print(manualDisclaimerModel.uncalibratedUserAgreement)
        } else {
            print("disclaimer error")
        }
    }
    
    func concentenateFinalUncalDisclaimerArrays() async {
        manualDisclaimerModel.finalUncalibratedUserAgreementAgreed.append(contentsOf: manualDisclaimerModel.uncalibratedUserAgreement)
        manualDisclaimerModel.finalUncalibratedUserAgreementAgreedDate.append(uncalUserAgreedDate)
        print("manualDisclaimerModel finalUncalibratedUserAgreementAgreed: \(manualDisclaimerModel.finalUncalibratedUserAgreementAgreed)")
        print("manualDisclaimerModel finalUncalibratedUserAgreementAgreedDate: \(manualDisclaimerModel.finalUncalibratedUserAgreementAgreedDate)")
    }
    
    func saveManualDeviceDisclaimer() async {
        await manualDisclaimerModel.getManualDisclaimerData()
        await manualDisclaimerModel.saveManualDisclaimerToJSON()
        await manualDisclaimerModel.writeManualDisclaimerToCSV()
        await manualDisclaimerModel.writeInputManualDisclaimerToCSV()
    }
}


class UncalibratedAgreementModel: ObservableObject {
    @EnvironmentObject var manualDisclaimerModel: ManualDisclaimerModel
    @Published var uncalibratedAgreementText: String = ""
        init() { self.load(file: "uncalibratedAgreementText") }
        func load(file: String) {
        if let uncalFilepath = Bundle.main.path(forResource: "uncalibratedAgreementText", ofType: "txt") {
            do {
                let uncalAgreementContents = try String(contentsOfFile: uncalFilepath)
                DispatchQueue.main.async {
                    self.uncalibratedAgreementText = uncalAgreementContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
        print("File not found")
        }
    }
}

//struct ManualDeviceDisclaimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualDeviceDisclaimerView()
//            .environmentObject(DeviceSelectionModel())
//            .environmentObject(ManualDisclaimerModel())
//    }
//}
