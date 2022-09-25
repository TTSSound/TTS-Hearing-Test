//
//  BetaTestingLandingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/14/22.
//

import SwiftUI
import CoreData
import CodableCSV
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

struct BetaTestingLandingView<Link: View>: View {
    
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            BetaTestingLandingContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading BetaTestingLanding View")
                .navigationTitle("")
        }
    }
}


struct BetaTestingLandingContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var finalLastName = [String]()
    @State private var userLastName = [String]()
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userLoggedInSuccessful: Bool = false
    @State private var logInAttempt: Bool = false
    
    @State var betaSexIdx = Int()
    @State var betaSexTitle = "Sex"
    @State var betaAgeIdx = Int()
    @State var betaTestSelectionIdx = Int()
    @State var betaTestSelectionName = [String]()
    @State var betaTestSelection = [String]()
    @State var betaTestName = String()
    @State var betaSelectionsSubmitted: Bool = false
    
    @State var betaFemale: Bool = false
    @State var betaMale: Bool = false
    @State var age0: Bool = false
    @State var age1: Bool = false
    @State var age2: Bool = false
    @State var age3: Bool = false
    @State var age4: Bool = false
    @State var age5: Bool = false
    @State var age6: Bool = false
    
    @State var betaEPTA: Bool = false
    @State var betaEHA: Bool = false
    
    let betaSelectedEHATest = "EHA"
    let betaSelectedEPTATest = "EPTA"
    let inputBetaEHATestSelectionCSVName = "EHA.csv"
    let inputBetaEPTATestSelectionCSVName = "EPTA.csv"
    
    let inputBetaSummaryCSVName = "InputBetaSummaryCSV.csv"
    
    @State var inputBetaAgeCSVName = [String]()
    @State var inputBetaAgeName = [String]()
    @State var inputBetaAge = String()
    // <= 27").tag(0)   age0.csv
    // 28-39").tag(2)   age1.csv
    // 40-49").tag(3)   age2.csv
    // 50-59").tag(4)   age3.csv
    // 60-69").tag(5)   age4.csv
    // 70-79").tag(6)   age5.csv
    // 80-89").tag(7)   age6.csv
    
    @State var inputBetaSexCSVName = [String]()
    @State var inputBetaSexName = [String]()
    @State var inputBetaSex = String()
    // 0 idx  = female.csv
    // 1 idx = male.csv
    
    @State var showBetaNameScreen = Bool()
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("Select Sex and Age")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.top, 40)
                HStack{
                    Spacer()
                    Toggle("Female", isOn: $betaFemale)
                        .foregroundColor(.green)
                    Spacer()
                    Toggle("Male", isOn: $betaMale)
                        .foregroundColor(.green)
                    Spacer()
                }
                .padding(.top, 20)
                HStack{
                    Toggle("<= 27", isOn: $age0)
                    Toggle("28-39", isOn: $age1)
                    Toggle("40-49", isOn: $age2)
                }
                .foregroundColor(.green)
                .padding(.top,20)
                HStack{
                    Toggle("50-59", isOn: $age3)
                    Toggle("60-69", isOn: $age4)
                    Toggle("70-79", isOn: $age5)
                }
                .foregroundColor(.green)
                .padding(.top, 20)
                HStack{
                    Toggle("80-89", isOn: $age6)
                }
                .foregroundColor(.green)
                .padding(.top, 20)
                HStack{
                    Spacer()
                    Text("Test Selected")
                        .foregroundColor(.white)
                        .font(.title)
                    Spacer()
                }
                .padding(.top, 20)
                Toggle("Full EHA Selected", isOn: $betaEHA)
                    .foregroundColor(.green)
                    .padding(.top, 10)
                    .padding(.leading)
                    .padding(.trailing)
                Toggle("Shorter EPTA Selected", isOn: $betaEPTA)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
                    .padding(.leading)
                    .padding(.trailing)
                if betaSelectionsSubmitted == false && userLoggedInSuccessful == true || userLoggedInSuccessful == false {
                    Button {
                        Task(priority: .userInitiated) {
                            await writeBetaSex()
                            await writeBetaAge()
                            await writeBetaTest()
                            await writeBetaInputSummaryToCSV()
                            betaSelectionsSubmitted = true
                        }
                    } label: {
                        HStack{
                            Text("Submit Selection")
                                .padding()
                            Image(systemName: "arrow.up.doc.fill")
                                .font(.title)
                                .padding()
                            
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                if betaSelectionsSubmitted == true && userLoggedInSuccessful == true {
                    NavigationLink {
                        TestIDInputView(testing: testing, relatedLinkTesting: linkTesting)
                    } label: {
                        HStack{
                            Spacer()
                            Text("Continue to Start Testing!")
                            Spacer()
                            Image(systemName: "arrowshape.bounce.right")
                            Spacer()
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                //End Vstack
            }
            .fullScreenCover(isPresented: $showBetaNameScreen) {
                ZStack{
                colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all)
                    VStack(alignment: .leading) {
                        Text("This Is A Shortcut For App Testing Use To Surpass the Main Setup Process, While Still Entering The Key Demographic Variables Needed For The Actual Test")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .padding(.bottom, 10)
                        
                        Text("If you completed the full setup process, still enter the information requested")
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        HStack{
                            Spacer()
                            Text("Last Name")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Last Name", text: $inputLastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                        Text(" Use The Tester Profile Info Below To Login.")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.bottom, 2)
                        Text("Tester@TrueToSourceSound.com")
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                        Text("password")
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .padding(.top, 2)
                            .padding(.bottom, 10)
                        
                        HStack{
                            Spacer()
                            Text("Email  ")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Enter_Email@Here.com", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        
                        HStack{
                            Spacer()
                            Text("Password")
                                .foregroundColor(.white)
                            Spacer()
                            TextField("Enter Your Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.bottom, 40)
                        if logInAttempt == false {
                            HStack{
                                Spacer()
                                Button {
                                    loginUser3()
                                    logInAttempt = true
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Login")
                                        Spacer()
                                        Image(systemName: "arrow.up.doc.fill")
                                        Spacer()
                                    }
                                }
                                .frame(width: 300, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(24)
                                Spacer()
                            }
                            .padding(.bottom, 20)
                        } else if logInAttempt == true {
                            if userLoggedInSuccessful == false {
                                HStack {
                                    Spacer()
                                    Button {
                                        loginUser3()
                                    } label: {
                                        HStack{
                                            Spacer()
                                            Text("Checking Login for Error.\nPress To Reset")
                                                .font(.caption)
                                            Spacer()
                                            Image(systemName: "arrowshape.turn.up.backward.2")
                                            Spacer()
                                        }
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .foregroundColor(.black)
                                        .background(Color.yellow)
                                        .cornerRadius(24)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 20)
                            } else if userLoggedInSuccessful == true {
                                HStack{
                                    Spacer()
                                    Button {
                                        showBetaNameScreen.toggle()
                                        logInAttempt = false
                                        userLoggedInSuccessful = true
                                    } label: {
                                        HStack{
                                            Spacer()
                                            Text("Continue")
                                            Spacer()
                                            Image(systemName: "arrowshape.bounce.right")
                                            Spacer()
                                        }
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(24)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 20)
                            }
                        } else {
                            Text("Fatal Error in Toggle Sub Stack")
                                .frame(width: 350, height: 250, alignment: .center)
                                .foregroundColor(.red)
                                .background(Color.black)
                                .cornerRadius(24)
                                .padding(.bottom, 20)
                        }
                    }
//                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            userLoggedInSuccessful = false
            showBetaNameScreen = true
            logInAttempt = false
        }
        .onChange(of: betaSelectionsSubmitted ) { submittedValue in
            if betaSelectionsSubmitted == true && userLoggedInSuccessful {
                uploadBetaDataEntry()
            } else {
                print("Fatal Error in betaselection upload change of logic")
            }
        }
    }
}

    // <= 27").tag(10)   age0.csv
    // 28-39").tag(11)   age1.csv
    // 40-49").tag(12)   age2.csv
    // 50-59").tag(13)   age3.csv
    // 60-69").tag(14)   age4.csv
    // 70-79").tag(15)   age5.csv
    // 80-89").tag(16)   age6.csv

extension BetaTestingLandingContent {
    //MARK: -Extension Authorization Methods
    private func loginUser3() {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            print("Successfully logged in with ID: \(result?.user.uid ?? "")")
            userLoggedInSuccessful = true
            print("userLoggedInSuccessful: \(userLoggedInSuccessful)")
        }
    }
    
    private func createUser2() {
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, err in
            if let err = err {
                print("Failed due to error:", err)
                return
            }
            print("Successfully created account with ID: \(result?.user.uid ?? "")")
        })
    }
}

extension BetaTestingLandingContent {
    //MARK: -Extension Methods
    func assignBetaAge() async {
        if age0 == true {
            inputBetaAge = "age0.csv"
        } else if age1 == true {
            inputBetaAge = "age1.csv"
        } else if age2 == true {
            inputBetaAge = "age2.csv"
        } else if age3 == true {
            inputBetaAge = "age3.csv"
        } else if age4 == true {
            inputBetaAge = "age4.csv"
        } else if age5 == true {
            inputBetaAge = "age5.csv"
        } else if age6 == true {
            inputBetaAge = "age6.csv"
        } else {
            print("Error in assignBetaAge Logic")
        }
    }
    
    func assignBetaSex() async {
        if betaFemale == true {
            inputBetaSex = "female.csv"
        } else if betaMale == true {
            inputBetaSex = "male.csv"
        } else {
            print("Error in assignBetaSex Logic")
        }
    }
    
    func writeBetaSex() async {
        if betaFemale == true && betaMale == false {
            await writeBetaSexFemaleInputTestSelectionToCSV()
        } else if betaFemale == false && betaMale == true {
            await writeBetaSexMaleInputTestSelectionToCSV()
        } else {
            print("critical error in writeBetaSex logic")
        }
    }
    
    func writeBetaTest() async {
        if betaEPTA == true && betaEHA == false {
            await writeBetaEPTAInputTestSelectionToCSV()
            betaTestName = "EPTA.csv"
        } else if betaEPTA == false && betaEHA == true {
            await writeBetaEHAInputTestSelectionToCSV()
            betaTestName = "EHA.csv"
        } else {
            print("critical error in writeBetaTest Logic")
        }
    }
    
    func writeBetaAge() async {
        if age0 == true && age1 == false && age2 == false && age3 == false && age4 == false && age5 == false && age6 == false {
            await writeBetaAge0InputTestSelectionToCSV()
        } else if age0 == false && age1 == true && age2 == false && age3 == false && age4 == false && age5 == false && age6 == false {
            await writeBetaAge1InputTestSelectionToCSV()
        } else if age0 == false && age1 == false && age2 == true && age3 == false && age4 == false && age5 == false && age6 == false {
            await writeBetaAge2InputTestSelectionToCSV()
        } else if age0 == false && age1 == false && age2 == false && age3 == true && age4 == false && age5 == false && age6 == false {
            await writeBetaAge3InputTestSelectionToCSV()
        } else if age0 == false && age1 == false && age2 == false && age3 == false && age4 == true && age5 == false && age6 == false  {
            await writeBetaAge4InputTestSelectionToCSV()
        } else if age0 == false && age1 == false && age2 == false && age3 == false && age4 == false && age5 == true && age6 == false {
            await writeBetaAge5InputTestSelectionToCSV()
        } else if age0 == false && age1 == false && age2 == false && age3 == false && age4 == false && age5 == false && age6 == true {
            await writeBetaAge6InputTestSelectionToCSV()
        } else {
            print("Critical error in writeBetaAge Logic")
        }
    }
    
    func uploadBetaDataEntry() {
        DispatchQueue.main.async(group: .none, qos: .background) {
            uploadFile(fileName: inputBetaSummaryCSVName)
        }
    }
}

extension BetaTestingLandingContent{
    //MARK: -Extension CSV/JSON Methods
    func writeBetaAge0InputTestSelectionToCSV() async {
        let betaAge0 = "age0," + "age0"
        print("writeBetaAge0InputTestSelectionToCSV Start")
        do {
            let csvBetaAge0InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge0InputTestDocumentsDirectory = csvBetaAge0InputTestPath
            print("CSV Beta Age0 Input Test Selection DocumentsDirectory: \(csvBetaAge0InputTestDocumentsDirectory)")
            let csvBetaAge0InputTestFilePath = csvBetaAge0InputTestDocumentsDirectory.appendingPathComponent("age0.csv")
            print(csvBetaAge0InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge0InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge0])
            print("CVS Beta Age0 Writer Success")
        } catch {
            print("CVSWriter Beta Age0 Error or Error Finding File for Input Age0 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge1InputTestSelectionToCSV() async {
        let betaAge1 = "age1," + "age1"
        print("writeBetaAge1InputTestSelectionToCSV Start")
        do {
            let csvBetaAge1InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge1InputTestDocumentsDirectory = csvBetaAge1InputTestPath
            print("CSV Beta Age1 Input Test Selection DocumentsDirectory: \(csvBetaAge1InputTestDocumentsDirectory)")
            let csvBetaAge1InputTestFilePath = csvBetaAge1InputTestDocumentsDirectory.appendingPathComponent("age1.csv")
            print(csvBetaAge1InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge1InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge1])
            print("CVS Beta Age1 Writer Success")
        } catch {
            print("CVSWriter Beta Age1 Error or Error Finding File for Input Age1 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge2InputTestSelectionToCSV() async {
        let betaAge2 = "age2," + "age2"
        print("writeBetaAge2InputTestSelectionToCSV Start")
        do {
            let csvBetaAge2InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge2InputTestDocumentsDirectory = csvBetaAge2InputTestPath
            print("CSV Beta Age2 Input Test Selection DocumentsDirectory: \(csvBetaAge2InputTestDocumentsDirectory)")
            let csvBetaAge2InputTestFilePath = csvBetaAge2InputTestDocumentsDirectory.appendingPathComponent("age2.csv")
            print(csvBetaAge2InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge2InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge2])
            print("CVS Beta Age2 Writer Success")
        } catch {
            print("CVSWriter Beta Age2 Error or Error Finding File for Input Age2 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge3InputTestSelectionToCSV() async {
        let betaAge3 = "age3," + "age3"
        print("writeBetaAge3InputTestSelectionToCSV Start")
        do {
            let csvBetaAge3InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge3InputTestDocumentsDirectory = csvBetaAge3InputTestPath
            print("CSV Beta Age3 Input Test Selection DocumentsDirectory: \(csvBetaAge3InputTestDocumentsDirectory)")
            let csvBetaAge3InputTestFilePath = csvBetaAge3InputTestDocumentsDirectory.appendingPathComponent("age3.csv")
            print(csvBetaAge3InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge3InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge3])
            print("CVS Beta Age3 Writer Success")
        } catch {
            print("CVSWriter Beta Age3 Error or Error Finding File for Input Age3 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge4InputTestSelectionToCSV() async {
        let betaAge4 = "age4," + "age4"
        print("writeBetaAge4InputTestSelectionToCSV Start")
        do {
            let csvBetaAge4InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge4InputTestDocumentsDirectory = csvBetaAge4InputTestPath
            print("CSV Beta Age4 Input Test Selection DocumentsDirectory: \(csvBetaAge4InputTestDocumentsDirectory)")
            let csvBetaAge4InputTestFilePath = csvBetaAge4InputTestDocumentsDirectory.appendingPathComponent("age4.csv")
            print(csvBetaAge4InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge4InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge4])
            print("CVS Beta Age4 Writer Success")
        } catch {
            print("CVSWriter Beta Age4 Error or Error Finding File for Input Age4 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge5InputTestSelectionToCSV() async {
        let betaAge5 = "age5," + "age5"
        print("writeBetaAge5InputTestSelectionToCSV Start")
        do {
            let csvBetaAge5InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge5InputTestDocumentsDirectory = csvBetaAge5InputTestPath
            print("CSV Beta Age5 Input Test Selection DocumentsDirectory: \(csvBetaAge5InputTestDocumentsDirectory)")
            let csvBetaAge5InputTestFilePath = csvBetaAge5InputTestDocumentsDirectory.appendingPathComponent("age5.csv")
            print(csvBetaAge5InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge5InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge5])
            print("CVS Beta Age5 Writer Success")
        } catch {
            print("CVSWriter Beta Age5 Error or Error Finding File for Input Age5 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaAge6InputTestSelectionToCSV() async {
        let betaAge6 = "age6," + "age6"
        print("writeBetaAge6InputTestSelectionToCSV Start")
        do {
            let csvBetaAge6InputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaAge6InputTestDocumentsDirectory = csvBetaAge6InputTestPath
            print("CSV Beta Age6 Input Test Selection DocumentsDirectory: \(csvBetaAge6InputTestDocumentsDirectory)")
            let csvBetaAge6InputTestFilePath = csvBetaAge6InputTestDocumentsDirectory.appendingPathComponent("age6.csv")
            print(csvBetaAge6InputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaAge6InputTestFilePath, append: false)
            try writerSetup.write(row: [betaAge6])
            print("CVS Beta Age6 Writer Success")
        } catch {
            print("CVSWriter Beta Age6 Error or Error Finding File for Input Age6 CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaSexMaleInputTestSelectionToCSV() async {
        let betaMaleSelected = "male," + "male"
        print("writeBetaSexMaleInputTestSelectionToCSV Start")
        do {
            let csvBetaSexMaleInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaSexMaleInputTestDocumentsDirectory = csvBetaSexMaleInputTestPath
            print("CSV Beta SexMale Male Input Test Selection DocumentsDirectory: \(csvBetaSexMaleInputTestDocumentsDirectory)")
            let csvBetaSexMaleInputTestFilePath = csvBetaSexMaleInputTestDocumentsDirectory.appendingPathComponent("male.csv")
            print(csvBetaSexMaleInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaSexMaleInputTestFilePath, append: false)
            try writerSetup.write(row: [betaMaleSelected])
            print("CVS Beta SexMale Male Writer Success")
        } catch {
            print("CVSWriter Beta SexMale MAle Error or Error Finding File for Input SexMale CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaSexFemaleInputTestSelectionToCSV() async {
        let betaFemaleSelected = "female," + "female"
        print("writeBetaSexFemaleInputTestSelectionToCSV Start")
        do {
            let csvBetaSexFemaleInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaSexFemaleInputTestDocumentsDirectory = csvBetaSexFemaleInputTestPath
            print("CSV Beta Sex Female Input Test Selection DocumentsDirectory: \(csvBetaSexFemaleInputTestDocumentsDirectory)")
            let csvBetaSexFemaleInputTestFilePath = csvBetaSexFemaleInputTestDocumentsDirectory.appendingPathComponent("female.csv")
            print(csvBetaSexFemaleInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaSexFemaleInputTestFilePath, append: false)
            try writerSetup.write(row: [betaFemaleSelected])
            print("CVS Beta SexFemale Writer Success")
        } catch {
            print("CVSWriter Beta SexFemale Error or Error Finding File for Input SexFemale CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaEPTAInputTestSelectionToCSV() async {
        let selectedBetaEPTATest = "EPTA," + "EPTA"
        print("writeBetaEPTAInputTestSelectionToCSV Start")
        do {
            let csvBetaEPTAInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaEPTAInputTestDocumentsDirectory = csvBetaEPTAInputTestPath
            print("CSV Beta EPTA Input Test Selection DocumentsDirectory: \(csvBetaEPTAInputTestDocumentsDirectory)")
            let csvBetaEPTAInputTestFilePath = csvBetaEPTAInputTestDocumentsDirectory.appendingPathComponent("EPTA.csv")
            print(csvBetaEPTAInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaEPTAInputTestFilePath, append: false)
            try writerSetup.write(row: [selectedBetaEPTATest])
            print("CVS Beta Input Test Selection Writer Success")
        } catch {
            print("CVSWriter Beta Input Test Selection Error or Error Finding File for Input Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaEHAInputTestSelectionToCSV() async {
        let selectedBetaEHATest = "EHA," + "EHA"
        print("writeBetaEHAInputTestSelectionToCSV Start")
        do {
            let csvBetaEHAInputTestPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaEHAInputTestDocumentsDirectory = csvBetaEHAInputTestPath
            print("CSV Beta EHA Input Test Selection DocumentsDirectory: \(csvBetaEHAInputTestDocumentsDirectory)")
            let csvBetaEHAInputTestFilePath = csvBetaEHAInputTestDocumentsDirectory.appendingPathComponent("EHA.csv")
            print(csvBetaEHAInputTestFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaEHAInputTestFilePath, append: false)
            try writerSetup.write(row: [selectedBetaEHATest])
            
            print("CVS Beta EHA Input Test Selection Writer Success")
        } catch {
            print("CVSWriter Beta EHA Input Test Selection Error or Error Finding File for Input Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    func writeBetaInputSummaryToCSV() async {
        userLastName.append(inputLastName)
        finalLastName.append(contentsOf: userLastName)
        betaTestSelection.append(betaTestName)
        betaTestSelectionName.append(contentsOf: betaTestSelection)
        inputBetaAgeName.append(inputBetaAge)
        inputBetaAgeCSVName.append(contentsOf: inputBetaAgeName)
        inputBetaSexName.append(inputBetaSex)
        inputBetaSexCSVName.append(contentsOf: inputBetaSexName)
        print("writeBetaEHAInputSummaryToCSV Start")
        let stringFinalInputLastName = finalLastName.map { String($0) }.joined(separator: ",")
        let stringFinalBetaTestSelection = betaTestSelectionName.map { String($0) }.joined(separator: ",")
        let stringFinalInputBetaAge = inputBetaAgeCSVName.map { String($0) }.joined(separator: ",")
        let stringFinalInputBetaSex = inputBetaSexCSVName.map { String($0) }.joined(separator: ",")
        do {
            let csvBetaEHAInputSummaryPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaEHAInputSummaryDocumentsDirectory = csvBetaEHAInputSummaryPath
            print("CSV Beta EHA Input Summary Selection DocumentsDirectory: \(csvBetaEHAInputSummaryDocumentsDirectory)")
            let csvBetaEHAInputSummaryFilePath = csvBetaEHAInputSummaryDocumentsDirectory.appendingPathComponent(inputBetaSummaryCSVName)
            print(csvBetaEHAInputSummaryFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaEHAInputSummaryFilePath, append: false)
            try writerSetup.write(row: [stringFinalInputLastName])
            try writerSetup.write(row: [stringFinalBetaTestSelection])
            try writerSetup.write(row: [stringFinalInputBetaAge])
            try writerSetup.write(row: [stringFinalInputBetaSex])
            print("CVS Beta Input Summary Writer Success")
        } catch {
            print("CVSWriter Beta EHA Input Test Selection Error or Error Finding File for Input Test Selection CSV \(error.localizedDescription)")
        }
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Only Use Files that have a pure string name assigned, not a name of ["String"]
    private func uploadFile(fileName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let storageRef = Storage.storage().reference()
            let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
            let lastNameRef = storageRef.child(inputLastName)
            let fileManager = FileManager.default
            let filePath = (self.getDirectoryPath() as NSString).strings(byAppendingPaths: [fileName])
            if fileManager.fileExists(atPath: filePath[0]) {
                let filePath = URL(fileURLWithPath: filePath[0])
                let localFile = filePath
                //                let fileRef = storageRef.child("CSV/SetupResultsCSV.csv")    //("CSV/\(UUID().uuidString).csv") // Add UUID as name
                let fileRef = lastNameRef.child("\(fileName)")
                let uploadTask = fileRef.putFile(from: localFile, metadata: nil) { metadata, error in
                    if error == nil && metadata == nil {
                        //TSave a reference to firestore database
                    }
                    return
                }
                print(uploadTask)
            } else {
                print("No File")
            }
        }
    }
}

extension BetaTestingLandingContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
    
}

//struct BetaTestingLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetaTestingLandingView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//    
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
