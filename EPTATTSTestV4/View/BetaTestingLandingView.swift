//
//  BetaTestingLandingView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/14/22.
//

import SwiftUI
import CodableCSV


struct BetaTestingLandingView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State var betaSexIdx = Int()
    @State var betaSexTitle = "Sex"
    @State var betaAgeIdx = Int()
    @State var betaTestSelectionIdx = Int()
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
    
    @State var inputBetaAgeCSVName = String()
        // <= 27").tag(0)   age0.csv
        // 28-39").tag(2)   age1.csv
        // 40-49").tag(3)   age2.csv
        // 50-59").tag(4)   age3.csv
        // 60-69").tag(5)   age4.csv
        // 70-79").tag(6)   age5.csv
        // 80-89").tag(7)   age6.csv
    
    @State var inputBetaSexCSVName = String()
        // 0 idx  = female.csv
        // 1 idx = male.csv
    
    var body: some View {
        
        
        NavigationStack{
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
                    
                    Toggle("Shorter EPTA Selected", isOn: $betaEPTA)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                        
                    Toggle("Full EHA Selected", isOn: $betaEHA)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                    if betaSelectionsSubmitted == false {
                        Button {
                            Task(priority: .userInitiated) {
                                await writeBetaSex()
                                await writeBetaAge()
                                await writeBetaTest()

                                betaSelectionsSubmitted = true
                            }
                        } label: {
                            VStack{
                                Image(systemName: "arrow.up.doc.fill")
                                    .font(.title)
                                    .padding()
                                Text("Submit Selection")
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                    if betaSelectionsSubmitted == true {
                        NavigationLink {
                            TestIDInputView()
//                            Bilateral1kHzTestView()
                        } label: {
                            VStack{
                                Image(systemName: "arrowshape.bounce.right")
                                    .foregroundColor(.green)
                                    .font(.title)
                                    .padding(.all)
                                Text("We are Now Ready To Start The Test.\nClick Continue to Get Started!")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                  //End Vstack
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
    
    func assignBetaAge() async {
        if age0 == true {
            inputBetaAgeCSVName = "age0.csv"
        } else if age1 == true {
            inputBetaAgeCSVName = "age1.csv"
        } else if age2 == true {
            inputBetaAgeCSVName = "age2.csv"
        } else if age3 == true {
            inputBetaAgeCSVName = "age3.csv"
        } else if age4 == true {
            inputBetaAgeCSVName = "age4.csv"
        } else if age5 == true {
            inputBetaAgeCSVName = "age5.csv"
        } else if age6 == true {
            inputBetaAgeCSVName = "age6.csv"
        } else {
            print("Error in assignBetaAge Logic")
        }
    }
    
    func assignBetaSex() async {
        if betaFemale == true {
            inputBetaSexCSVName = "female.csv"
        } else if betaMale == true {
            inputBetaSexCSVName = "male.csv"
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
        } else if betaEPTA == false && betaEHA == true {
            await writeBetaEHAInputTestSelectionToCSV()
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
   
    func writeBetaAge0InputTestSelectionToCSV() async {
        let betaAge0 = "age0" + "age0"
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
        let betaAge1 = "age1" + "age1"
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
        let betaAge2 = "age2" + "age2"
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
        let betaAge3 = "age3" + "age3"
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
        let betaAge4 = "age4" + "age4"
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
        let betaAge5 = "age5" + "age5"
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
        let betaAge6 = "age6" + "age6"
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
        let betaMaleSelected = "male" + "male"
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
        let betaFemaleSelected = "female" + "female"
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
        let selectedBetaEPTATest = "EPTA" + "EPTA"
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
    
    
}

//struct BetaTestingLandingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetaTestingLandingView()
//    }
//}
