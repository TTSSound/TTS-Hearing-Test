//
//  DisclaimerView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI
import CoreMedia
import CodableCSV


// Cannot use private Vars Here

struct SaveFinalDisclaimerResults: Codable {
    var jsonUserAgreementAgreed = [Int]()
    var jsonStringUserAgreementAgreedDate = String()
    var jsonUserAgreementAgreedDate = [Date]()
    
    enum CodingKeys: String, CodingKey {
        case jsonUserAgreementAgreed
        case jsonStringUserAgreementAgreedDate
        case jsonUserAgreementAgreedDate
    }
}


// Add in user agreed store variable and time of agreement CMseconds and Date
struct DisclaimerView: View {
    
    @StateObject var colorModel = ColorModel()
    
    @Binding var selectedTab: Int

        
    
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
    
    
    
    @State var userAgreement = [Bool]()
    @State var finalUserAgreementAgreed: [Int] = [Int]()
    @State var finalUserAgreementAgreedDate: [Date] = [Date]()
    
    @State var stringJsonFUAADate = String()
    @State var stringFUAADate = String()
    @State var stringInputFUAADate = String()
    
    let fileDisclaimerName = ["DisclaimerResults.json"]
    let disclaimerCSVName = "DisclaimerResultsCSV.csv"
    let inputDisclaimerCSVName = "InputDisclaimerResultsCSV.csv"
    
    @State var saveFinalDisclaimerResults: SaveFinalDisclaimerResults? = nil
    
    var body: some View {
        NavigationStack{
//        NavigationView(path: ["Disclaimer"])
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
                            Text("Continue")
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
            .onAppear {
                dLinkColorIndex = 0
            }
            
         
        }

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
        if userAgreement.count < 1 || userAgreement.count > 1{
            userAgreement.append(disclaimerSetting)
            print(userAgreement)
        } else if disclaimerSetting == false {
            userAgreement.removeAll()
            userAgreement.append(disclaimerSetting)
            print(userAgreement)
        } else {
            print("disclaimer error")
        }
    }
    
    func agreementDate() async {
        userAgreementDate = Date.now
    }
    
    func concatenateFinalUserAgreementArrays() async {
        finalUserAgreementAgreed.append(disclaimerAgreement)
        finalUserAgreementAgreedDate.append(userAgreementDate)
    }
    
    func finalUserAgreementArrays() async {
        print("finalUserAgreementAgreed: \(finalUserAgreementAgreed)")
        print("finalUserAgreementDate: \(finalUserAgreementAgreedDate)")
    }
    
    func saveDisclaimerData() async {
//        await writeJSONSetupData(saveFinalSetupResults: savefinalSetupResults)
        await getDisclaimerData()
        await saveDisclaimerToJSON()
        await writeDisclaimerResultsToCSV()
    }
    
    func getDisclaimerData() async {
        guard let disclaimerData = await self.getDemoJSONData() else { return }
        print("Json Disclaimer Data:")
        print(disclaimerData)
        let jsonDisclaimerString = String(data: disclaimerData, encoding: .utf8)
        print(jsonDisclaimerString!)
        do {
            self.saveFinalDisclaimerResults = try JSONDecoder().decode(SaveFinalDisclaimerResults.self, from: disclaimerData)
            print("JSON GetData Run")
            print("data: \(disclaimerData)")
        } catch let error {
            print("!!!Error decoding Disclaimer json data: \(error)")
        }
    }
    

    
    func getDemoJSONData() async -> Data? {
        let formatter3J = DateFormatter()
        formatter3J.dateFormat = "HH:mm E, d MMM y"
        if finalUserAgreementAgreedDate.count != 0 {
            stringJsonFUAADate = formatter3J.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
        
        let saveFinalDisclaimerResults = SaveFinalDisclaimerResults (
            jsonUserAgreementAgreed: finalUserAgreementAgreed,
            jsonStringUserAgreementAgreedDate: stringJsonFUAADate,
            jsonUserAgreementAgreedDate: finalUserAgreementAgreedDate)
        
        let jsonDisclaimerData = try? JSONEncoder().encode(saveFinalDisclaimerResults)
        print("saveFinalResults: \(saveFinalDisclaimerResults)")
        print("Json Encoded \(jsonDisclaimerData!)")
        return jsonDisclaimerData

    }
    
    func saveDisclaimerToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let disclaimerPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = disclaimerPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let disclaimerFilePaths = documentsDirectory.appendingPathComponent(fileDisclaimerName[0])
        print(disclaimerFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonDisclaimerData = try encoder.encode(saveFinalDisclaimerResults)
            print(jsonDisclaimerData)
          
            try jsonDisclaimerData.write(to: disclaimerFilePaths)
        } catch {
            print("Error writing to JSON Disclaimer file: \(error)")
        }
    }
            
    func writeDisclaimerResultsToCSV() async {
        print("writeDisclaimerResultsToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        
        if finalUserAgreementAgreedDate.count != 0 {
            stringFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
        
        
        let stringFinalUserAgreementAgreed = "finalUserAgreementAgreed," + finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUserAgreementAgreedDate = "finalUserAgreementAgreedDate," + stringFUAADate.map { String($0) }.joined(separator: ",")
        
        
        do {
            let csvDisclaimerPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvDisclaimerDocumentsDirectory = csvDisclaimerPath
            print("CSV Disclaimer DocumentsDirectory: \(csvDisclaimerDocumentsDirectory)")
            let csvDisclaimerFilePath = csvDisclaimerDocumentsDirectory.appendingPathComponent(disclaimerCSVName)
            print(csvDisclaimerFilePath)
            
            let writerDisclaimer = try CSVWriter(fileURL: csvDisclaimerFilePath, append: false)
        
            try writerDisclaimer.write(row: [stringFinalUserAgreementAgreed])
            try writerDisclaimer.write(row: [stringFinalUserAgreementAgreedDate])
        
            print("CVS Disclaimer Writer Success")
        } catch {
            print("CVSWriter Disclaimer Error or Error Finding File for Disclaimer CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputDisclaimerResultsToCSV() async {
        print("writeInputDisclaimerResultsToCSV Start")
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        if finalUserAgreementAgreedDate.count != 0 {
            stringInputFUAADate = formatter3.string(from: finalUserAgreementAgreedDate[0])
        } else {
            print("finaluseragreementagreeddate is nil")
        }
        let stringFinalUserAgreementAgreed = finalUserAgreementAgreed.map { String($0) }.joined(separator: ",")
        let stringFinalUserAgreementAgreedDate = stringFUAADate.map { String($0) }.joined(separator: ",")
        
        do {
            let csvInputDisclaimerPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputDisclaimerDocumentsDirectory = csvInputDisclaimerPath
            print("CSV Input Disclaimer DocumentsDirectory: \(csvInputDisclaimerDocumentsDirectory)")
            let csvInputDisclaimerFilePath = csvInputDisclaimerDocumentsDirectory.appendingPathComponent(inputDisclaimerCSVName)
            print(csvInputDisclaimerFilePath)
            let writerDisclaimer = try CSVWriter(fileURL: csvInputDisclaimerFilePath, append: false)
            try writerDisclaimer.write(row: [stringFinalUserAgreementAgreed])
            try writerDisclaimer.write(row: [stringFinalUserAgreementAgreedDate])
            
            print("CVS Input Disclaimer Writer Success")
        } catch {
            print("CVSWriter Input Disclaimer Error or Error Finding File for Input Disclaimer CSV \(error.localizedDescription)")
        }
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
////    @Binding var selectedTab: Int
////    @Binding var path: [Double]
//    static var previews: some View {
//        DisclaimerView()
//    }
//}
