//
//  DisclaimerView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI
import CoreMedia

// Cannot use private Vars Here



// Add in user agreed store variable and time of agreement CMseconds and Date
struct DisclaimerView: View {
    
    @StateObject var colorModel = ColorModel()
    @State var savefinalSetupResults = [SaveFinalSetupResults]()
    @Binding var selectedTab: Int
//    @ObservedObject var setupDataModel: SetupDataModel = SetupDataModel()
    
    @EnvironmentObject var setupDataModel: SetupDataModel
    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
        
    
    @ObservedObject var userAgreementModel: UserAgreementModel = UserAgreementModel()
    @State var disclaimerSetting = Bool()
    @State var disclaimerAgreement = Int()
    @State var dLinkColors: [Color] = [Color.clear, Color.green]
    @State var dLinkColors2: [Color] = [Color.clear, Color.white]
    @State var dLinkColorIndex = Int()
   
    @State var userAgreed: Bool = false
    @State var userAgreementTime = Float()
    @State var userAgreementDate = Date()
    var urlFile: URL = URL(fileURLWithPath: "userAgreementText.txt")
    
    var body: some View {
        NavigationView{
            ZStack{
                colorModel.colorBackgroundTopTiffanyBlue .ignoresSafeArea(.all, edges: .top)
                VStack {
                    GroupBox(label:
                            Label("End-User Agreement", systemImage: "building.columns")
                        ) {
                            ScrollView(.vertical, showsIndicators: true) {
                                Text(userAgreementModel.userAgreementText)
                                    .font(.footnote)
                            }
                            .frame(height: 425)
                            Toggle(isOn: $userAgreed) {
                                Text("I agree to the above terms")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing)
                            .padding(.leading)
                        }
                        .onAppear(perform: {
                            loadUserAgreement()
                        })
                        .onChange(of: userAgreed) { _ in
                            DispatchQueue.main.async(group: .none, qos: .userInitiated) {
                                Task(priority: .userInitiated, operation: {
                                    dLinkColorIndex = 1
                                    disclaimerSetting = userAgreed
                                    await compareDisclaimerAgreement()
                                    await disclaimerResponse()
                                    await agreementDate()
                                    await concatenateFinalUserAgreementArrays()
                                    await finalUserAgreementArrays()
                                    await saveDisclaimerData()
                                    print(disclaimerSetting)
                                    print(disclaimerAgreement)
                                })
                            }
                        }
                    Spacer()
                    NavigationLink(destination:
                                    userAgreed == true ? AnyView(UserDataEntryView())
                                    : userAgreed == false ? AnyView(LandingView())
                                    : AnyView(LandingView())
                    ){  HStack {
                            Spacer()
                            Text("Now Let's Contine!")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(dLinkColors[dLinkColorIndex])
                        .foregroundColor(dLinkColors2[dLinkColorIndex])
                        .cornerRadius(300)
                        
                    }
                    .padding(.bottom, 40)
                    Spacer()
//                    .onTapGesture {
//                        Task(priority: .userInitiated, operation: {
//                            await compareDisclaimerAgreement()
//                            await disclaimerResponse()
//                            await agreementDate()
//                            await concatenateFinalUserAgreementArrays()
//                            await finalUserAgreementArrays()
//                            await saveDisclaimerData()
//                            print(disclaimerSetting)
//                            print(disclaimerAgreement)
//                        })
//                    }
//                    .padding(.bottom, 40)
//                    Spacer()
                }
            }
        }
        .onAppear {
            dLinkColorIndex = 0
        }
        .environmentObject(setupDataModel)
    }
    
    func loadUserAgreement() {
        userAgreementModel.load(file: userAgreementModel.userAgreementText)
    }

    func compareDisclaimerAgreement() async {
        if disclaimerSetting == true {
            disclaimerAgreement = 1
            print("Disclaimer Response: \(disclaimerAgreement) & \(disclaimerSetting)")
        } else if disclaimerSetting == false {
            disclaimerAgreement = 0
            print("Disclaimer Response: \(disclaimerAgreement) & \(disclaimerSetting)")
        } else {
            disclaimerAgreement = 2
            print("Disclaimer Response: \(disclaimerAgreement) & \(disclaimerSetting)")
        }
    }

    func disclaimerResponse() async {
        disclaimerSetting = true
        if setupDataModel.userAgreement.count < 1 || setupDataModel.userAgreement.count > 1{
            setupDataModel.userAgreement.append(disclaimerSetting)
            print(setupDataModel.userAgreement)
        } else if disclaimerSetting == false {
            setupDataModel.userAgreement.removeAll()
            setupDataModel.userAgreement.append(disclaimerSetting)
            print(setupDataModel.userAgreement)
        } else {
            print("disclaimer error")
        }
    }
    
    func agreementDate() async {
        userAgreementDate = Date.now
    }
    
    func concatenateFinalUserAgreementArrays() async {
        setupDataModel.finalUserAgreementAgreed.append(disclaimerAgreement)
        setupDataModel.finalUserAgreementAgreedDate.append(userAgreementDate)
    }
    
    func finalUserAgreementArrays() async {
        print("finalUserAgreementAgreed: \(setupDataModel.finalUserAgreementAgreed)")
        print("finalUserAgreementDate: \(setupDataModel.finalUserAgreementAgreedDate)")
    }
    
    func saveDisclaimerData() async {
//        await setupDataModel.writeJSONSetupData(saveFinalSetupResults: savefinalSetupResults)
        await setupDataModel.getSetupData()
        await setupDataModel.saveSetupToJSON()
        await setupDataModel.writeSetupResultsToCSV()
    }
    
    
}


class UserAgreementModel: ObservableObject {
    @Published var userAgreementText: String = ""
    init() { self.load(file: "userAgreementText") }
    func load(file: String) {
        if let filepath = Bundle.main.path(forResource: "userAgreementText", ofType: "txt") {
            do {
                let userAgreementContents = try String(contentsOfFile: filepath)
                DispatchQueue.main.async {
                    self.userAgreementText = userAgreementContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}


//struct DisclaimerView_Previews: PreviewProvider {
//    
//    @Binding var selectedTab: Int
//    static var previews: some View {
//        DisclaimerView()
//            .environmentObject(SetupDataModel())
//    }
//}
