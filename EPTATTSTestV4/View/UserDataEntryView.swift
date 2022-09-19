//
//  TestUserDataEntryView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/23/22.
//

import SwiftUI
import CoreData
import CodableCSV
//import Alamofire


//@State var genderList: [String] = [
//Text("Female").tag(0)
//Text("Male").tag(1)
//Text("Cisgender Female").tag(2)
//Text("Cisgender Male").tag(3)
//Text("Agender").tag(4)
//Text("Bigender").tag(5)
//Text("Gender Fluid").tag(6)
//Text("Gender Non-Conforming").tag(7)
//Text("Genderqueer").tag(8)
//Text("Intersex").tag(9)
//Text("Third Sex").tag(10)
//Text("Transgender").tag(11)
//Text("Two-Spirit").tag(12)
//Text("Prefer Not To Identify").tag(13)
//]


//            Picker(
//                selection: $genderList,
//                label: Text("Gender"),
//                content: {
//                    Text("Female").tag("1")
//                    Text("Male").tag("2")
//                    Text("Cisgender Female").tag("3")
//                    Text("Cisgender Male").tag("4")
//                    Text("Agender").tag("5")
//                    Text("Bigender").tag("6")
//                    Text("Gender Fluid").tag("7")
//                    Text("Gender Non-Conforming").tag("8")
//                    Text("Genderqueer").tag("9")
//                    Text("Intersex").tag("10")
////                    Text("Third Sex").tag("11")
////                    Text("Transgender").tag("12")
////                    Text("Two-Spirit").tag("13")
////                    Text("Prefer Not To Identify").tag("14")
//                }).pickerStyle(MenuPickerStyle())
//            .pickerStyle(SegmentedPickerStyle)

//@State var ageList: [Int] = [
//    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 92, 94, 95, 99, 100
//    ]

struct SaveFinalSetupResults: Codable {
    var jsonFinalFirstName = [String]()
    var jsonFinalLastName = [String]()
    var jsonFinalEmail = [String]()
    var jsonFinalPassword = [String]()
    var jsonFinalAge = [Int]()
    var jsonFinalGender = [String]()
    var jsonFinalGenderIndex = [Int]()
    var jsonFinalSex = [Int]()
    var jsonUserUUID = [String]()
    
    enum CodingKeys: String, CodingKey {
        case jsonFinalFirstName
        case jsonFinalLastName
        case jsonFinalEmail
        case jsonFinalPassword
        case jsonFinalAge
        case jsonFinalGender
        case jsonFinalGenderIndex
        case jsonFinalSex
        case jsonUserUUID
    }
}

struct GenderModel: Identifiable, Hashable {
    let gender: String
    let id = UUID()
    var isToggled = false
    init(gender: String) {
        self.gender = gender
    }
}

struct UserDataEntryView<Link: View>:View {
    var setup: Setup?
    var relatedLink: (Setup) -> Link
    
    
    var body: some View {
        ZStack{
            if let setup = setup {
                UserDataEntryContent(setup: setup, relatedLink: relatedLink)
            } else {
                Text("Error Loading User Login View")
                    .navigationTitle("")
            }
        }
    }
}

struct UserDataEntryContent<Link: View>:View {
    var setup: Setup
    var dataModel = DataModel.shared
    var relatedLink: (Setup) -> Link
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    
    
    @ObservedObject var whyWeAskModel: WhyWeAskModel = WhyWeAskModel()
    @State var showWhyDoWeAskSheet: Bool = false
    @State var uLinkColors: [Color] = [Color.clear, Color.green]
    @State var uLinkColors2: [Color] = [Color.clear, Color.white]
    @State var uLinkColorIndex = Int()
    @State var userDataSubmitted = Bool()
    @State var udLinkColors: [Color] = [Color.clear, Color.green]
    @State var udLinkColors2: [Color] = [Color.clear, Color.white]
    @State var udLinkColorIndex = Int()
    
    @State var firtsName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var age: Int = Int()
    @State var gender = [
        "Female or Cisgender Female",
        "Male or Cisgender Male",
        "Agender",
        "Bigender",
        "Gender Non-Conforming",
        "Genderqueer",
        "Intersex",
        "Third Sex",
        "Transgender",
        "Prefer Not To Identify"
    ]
    
    @State var genderIdx = Int()
    @State var sex = [Int]()
    @State var userUUID = String()
    
    @State var genderList = [
        GenderModel(gender: "Female or Cisgender Female"),
        GenderModel(gender: "Male or Cisgender Male"),
        GenderModel(gender: "Agender"),
        GenderModel(gender: "Bigender"),
        GenderModel(gender: "Gender Non-Conforming"),
        GenderModel(gender: "Genderqueer"),
        GenderModel(gender: "Intersex"),
        GenderModel(gender: "Third Sex"),
        GenderModel(gender: "Transgender"),
        GenderModel(gender: "Prefer Not To Identify")
    ]
    @State private var selectedGender = ""
    
    @State var userFirstName = [String]()
    @State var userLastName = [String]()
    @State var userEmail = [String]()
    @State var userPassword = [String]()
    @State var userAge = [Int]()
    @State var userBirthDate = [Date]()
    @State var userGender = [String]()
    @State var userGenderIndex = [Int]()
    @State var userSex = [Int]()
    @State var userUUIDString = [String]()
    
    // Demo Variables
    @State var finalFirstName: [String] = [String]()
    @State var finalLastName: [String] = [String]()
    @State var finalEmail: [String] = [String]()
    @State var finalPassword: [String] = [String]()
    @State var finalAge: [Int] = [Int]()
    @State var finalGender: [String] = [String]()
    @State var finalGenderIndex: [Int] = [Int]()
    @State var finalSex: [Int] = [Int]()
    @State var finalUserUUIDString: [String] = [String]()
    
    let fileSetupName = ["SetupResults.json"]
    let setupCSVName = "SetupResultsCSV.csv"
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    
    @State var saveFinalSetupResults: SaveFinalSetupResults? = nil
    
    var body: some View {
        
        ZStack {
            colorModel.colorBackgroundTopTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 10) {
                
                VStack{
                    HStack{
                        Spacer()
                        Text("Complete Each Field & Create an Account")
                            .foregroundColor(.white)
                            .padding(.top, 20.0)
                            .padding(.bottom, 20.0)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("Already Have an Account?")
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink {
                            UserLoginView(setup: setup, relatedLink: relatedLink)
                        } label: {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                
                HStack() {
                    Spacer()
                    Text("First Name")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("First Name", text: $firtsName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Text("Last Name")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Text("Email")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("EnterYourEmail@Here.com", text: $email)
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
                    TextField("Select A Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                
                HStack {
                    Spacer()
                    Text("Select Your Age in Years")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top)
                .padding(.top)
                
                // GENDER SELECTION
                VStack{
                    HStack{
                        Picker(
                            selection: $age,
                            label: Text("Age in Years").foregroundColor(.blue),
                            content: {
                                ForEach(6..<100) { number in
                                    Text("\(number)")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .tag("\(number)")
                                }
                            })
                    }
                    
                    HStack{
                        Spacer()
                        Text("Select Your Gender")
                            .foregroundColor(.white)
                        Spacer()
                        
                        Button(action: {
                            showWhyDoWeAskSheet.toggle()
                            
                        }, label: {
                            Image(systemName: "person.fill.questionmark")
                                .foregroundColor(.purple)
                                .padding(.trailing)
                        })
                    }
                    .fullScreenCover(isPresented: $showWhyDoWeAskSheet, content: {
                        ZStack {
                            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea()
                            VStack(alignment: .leading) {
                                
                                Button(action: {
                                    showWhyDoWeAskSheet.toggle()
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .padding()
                                })
                                .padding(.top, 40)
                                .padding(.leading, 20)
                                
                                GroupBox(label:
                                            Label("Why Do We Ask", systemImage: "person.fill.questionmark").foregroundColor(.purple)
                                ) {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(whyWeAskModel.whyDoWeAskForThisText)
                                            .font(.footnote)
                                            .foregroundColor(.purple)
                                    }
                                    .frame(height: 500)
                                }
                                .foregroundColor(.purple)
                                .onAppear(perform: {
                                    loadWhyWeAsk()
                                })
                                Spacer()
                            }
                        }
                    })
                }
                .foregroundColor(.purple)
                .padding(.leading)
                .padding(.bottom)
                
                HStack{
                    Spacer()
                    Picker("Gender", selection: $genderIdx) {
                        Text("Female or Cisgender Female").tag(0)
                        Text("Male or Cisgender Male").tag(1)
                        Text("Agender").tag(2)
                        Text("Bigender").tag(3)
                        Text("Gender Non-Conforming").tag(4)
                        Text("Genderqueer").tag(5)
                        Text("Intersex").tag(6)
                        Text("Third Sex").tag(7)
                        Text("Transgender").tag(8)
                        Text("Prefer Not To Identify").tag(9)
                    }
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom, 60)
                
                if userDataSubmitted == false {
                    HStack{
                        Spacer()
                        Button {
                            DispatchQueue.main.async(group: .none, qos: .userInitiated) {
                                Task(priority: .userInitiated, operation: {
                                    await assignSex()
                                    await areDemoFieldsEmpty()
                                    await saveDemographicData()
                                    await generateUserUUID()
                                    await concatenateDemoFinalArrays()
                                    await printFinalDemoArrays()
                                    await saveUserDataEntry()
                                    print("Data Submission Pressed. Function Need to be created")
                                })
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("Submit Selection")
                                Spacer()
                                Image(systemName: "arrow.up.doc.fill")
                                Spacer()
                            }
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(300)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 80)
                } else if  userDataSubmitted == true {
                    HStack{
                        Spacer()
                        NavigationLink {
                            userDataSubmitted == false ? AnyView(UserDataEntrySplashView(setup: setup, relatedLink: link))
                            : userDataSubmitted == true ? AnyView(ExplanationView())
                            : AnyView(UserDataEntrySplashView(setup: setup, relatedLink: link))
                        } label: {
                            HStack{
                                Spacer()
                                Text("Now Let's Contine!")
                                Spacer()
                                Image(systemName: "arrowshape.bounce.right")
                                Spacer()
                            }
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(300)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 80)
                }
            }
            .onAppear(perform: {
                uLinkColorIndex = 0
                userDataSubmitted = false
            })
            .padding(.leading)
            .padding(.trailing)
        }.navigationTitle("User Setup")
        
    }
    
}

extension UserDataEntryContent {
    
    func loadWhyWeAsk() {
        whyWeAskModel.load(file: whyWeAskModel.whyDoWeAskForThisText)
    }
    
    func assignSex() async {
        if genderIdx == 0 {
            sex.append(0) // Female
        } else if genderIdx == 1 {
            sex.append(1) // Maled
        } else  if genderIdx > 1 && genderIdx < 10 {
            sex.append(1) // Default to Male to ensure lower starting thresholds if birth sex is unknown
            print("default gender selectd: \(genderIdx) \(gender[genderIdx])")
        }
    }
    
    func areDemoFieldsEmpty() async {
        
        if firtsName.count > 0 && lastName.count > 0 && email.count > 0 && password.count > 0 && genderIdx >= 0 {
            userDataSubmitted = true
            udLinkColorIndex = 1
            print("All Demo Fields are Completed")
        } else if firtsName.count <= 0 || lastName.count <= 0 || email.count <= 0 || password.count <= 0 || age < 0 || genderIdx < 0 {
            userDataSubmitted = false
            udLinkColorIndex = 0
        } else {
            userDataSubmitted = false
            udLinkColorIndex = 1
            print("!!!Error in areDemoFieldsEmpty() Logic ")
        }
    }
    
    func generateUserUUID() async {
        userUUID = UUID().uuidString
        print("userUUID: \(userUUID)")
    }
    
    func saveDemographicData() async {
        let adjustedAge = age + 6
        selectedGender = gender[genderIdx]
        userFirstName.append(firtsName)
        userLastName.append(lastName)
        userEmail.append(email)
        userPassword.append(password)
        userAge.append(adjustedAge)
        userGender.append(gender[genderIdx])
        userGenderIndex.append(genderIdx)
        userSex.append(contentsOf: sex)
        userUUIDString.append(userUUID)
        print("selected gender: \(selectedGender)")
        print("firstName: \(firtsName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("password: \(password)")
        print("age, adjustedAge: \(age) \(adjustedAge)")
        print("gender: \(selectedGender)")
        print("genderIdx: \(genderIdx)")
        print("sex: \(sex)")
        print("userUUID: \(userUUID)")
        print("SetupModel firstName: \(userFirstName)")
        print("SetupModel lastName: \(userLastName)")
        print("SetupModel email: \(userEmail)")
        print("SetupModel password: \(userPassword)")
        print("SetupModel age: \(userAge)")
        print("SetupModel gender: \(userGender)")
        print("SetupModel genderIdx: \(userGenderIndex)")
        print("SetupModel sex: \(userSex)")
        print("SetupModel userUUIDString: \(userUUIDString)")
      }
    
    
    func concatenateDemoFinalArrays() async {
        finalFirstName.append(contentsOf: userFirstName)
        finalLastName.append(contentsOf: userLastName)
        finalEmail.append(contentsOf: userEmail)
        finalPassword.append(contentsOf: userPassword)
        finalAge.append(contentsOf: userAge)
        finalGender.append(contentsOf: userGender)
        finalGenderIndex.append(contentsOf: userGenderIndex)
        finalSex.append(contentsOf: userSex)
        finalUserUUIDString.append(userUUID)
    }
    
    func printFinalDemoArrays() async {
        
        print("finalFirstName: \(finalFirstName)")
        print("finalLastName: \(finalLastName)")
        print("finalEmail: \(finalEmail)")
        print("finalPassword: \(finalPassword)")
        print("finalAge: \(finalAge)")
        print("finalGender: \(finalGender)")
        print("finalGenderIndex: \(finalGenderIndex)")
        print("finalSex: \(finalSex)")
        print("finalUserUUIDString: \(finalUserUUIDString)")
    }
    
    func saveUserDataEntry() async {
        await getSetupData()
        await saveSetupToJSON()
        await writeSetupResultsToCSV()
        await writeInputSetupResultsToCSV()
    }
    
    func getSetupData() async {
        guard let setupData = await self.getDemoJSONData() else { return }
        print("Json Setup Data:")
        print(setupData)
        let jsonSetupString = String(data: setupData, encoding: .utf8)
        print(jsonSetupString!)
        do {
            self.saveFinalSetupResults = try JSONDecoder().decode(SaveFinalSetupResults.self, from: setupData)
            print("JSON GetData Run")
            print("data: \(setupData)")
        } catch let error {
            print("!!!Error decoding setup json data: \(error)")
        }
    }
    

    
    func getDemoJSONData() async -> Data? {
        
        let saveFinalSetupResults = SaveFinalSetupResults (
            jsonFinalFirstName: finalFirstName,
            jsonFinalLastName: finalLastName,
            jsonFinalEmail: finalEmail,
            jsonFinalPassword: finalPassword,
            jsonFinalAge: finalAge,
            jsonFinalGender: finalGender,
            jsonFinalGenderIndex: finalGenderIndex,
            jsonFinalSex: finalSex,
            jsonUserUUID: finalUserUUIDString)
        
        let jsonSetupData = try? JSONEncoder().encode(saveFinalSetupResults)
        print("saveFinalResults: \(saveFinalSetupResults)")
        print("Json Encoded \(jsonSetupData!)")
        return jsonSetupData

    }
    
    func saveSetupToJSON() async {
    // !!!This saves to device directory, whish is likely what is desired
        let setupPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = setupPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let setupFilePaths = documentsDirectory.appendingPathComponent(fileSetupName[0])
        print(setupFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSetupData = try encoder.encode(saveFinalSetupResults)
            print(jsonSetupData)
          
            try jsonSetupData.write(to: setupFilePaths)
        } catch {
            print("Error writing to JSON Setup file: \(error)")
        }
    }

    
    func writeSetupResultsToCSV() async {
        print("writeSetupResultsToCSV Start")
        
        let stringFinalFirstName = "finalFirstName," + finalFirstName.map { String($0) }.joined(separator: ",")
        let stringFinalLastName = "finalLastName," + finalLastName.map { String($0) }.joined(separator: ",")
        let stringFinalEmail = "finalEmail," + finalEmail.map { String($0) }.joined(separator: ",")
        let stringFinalPassword = "finalPassword," + finalPassword.map { String($0) }.joined(separator: ",")
        let stringFinalAge = "finalAge," + finalAge.map { String($0) }.joined(separator: ",")
        let stringFinalGender = "finalGender," + finalGender.map { String($0) }.joined(separator: ",")
        let stringFinalGenderIndex = "finalGenderIndex," + finalGenderIndex.map { String($0) }.joined(separator: ",")
        let stringFinalSex = "finalSex," + finalSex.map { String($0) }.joined(separator: ",")
        let stringFinalUserUUIDString = "finalUserUUIDString," + finalUserUUIDString.map { String($0) }.joined(separator: ",")
        
        do {
            let csvSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSetupDocumentsDirectory = csvSetupPath
            print("CSV Setup DocumentsDirectory: \(csvSetupDocumentsDirectory)")
            let csvSetupFilePath = csvSetupDocumentsDirectory.appendingPathComponent(setupCSVName)
            print(csvSetupFilePath)
            
            let writerSetup = try CSVWriter(fileURL: csvSetupFilePath, append: false)
        
            try writerSetup.write(row: [stringFinalFirstName])
            try writerSetup.write(row: [stringFinalLastName])
            try writerSetup.write(row: [stringFinalEmail])
            try writerSetup.write(row: [stringFinalPassword])
            try writerSetup.write(row: [stringFinalAge])
            try writerSetup.write(row: [stringFinalGender])
            try writerSetup.write(row: [stringFinalGenderIndex])
            try writerSetup.write(row: [stringFinalSex])
            try writerSetup.write(row: [stringFinalUserUUIDString])
        
            print("CVS Setup Writer Success")
        } catch {
            print("CVSWriter Setup Error or Error Finding File for Setup CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSetupResultsToCSV() async {
        print("writeInputSetupResultsToCSV Start")
        
        let stringFinalFirstName = finalFirstName.map { String($0) }.joined(separator: ",")
        let stringFinalLastName = finalLastName.map { String($0) }.joined(separator: ",")
        let stringFinalEmail = finalEmail.map { String($0) }.joined(separator: ",")
        let stringFinalPassword = finalPassword.map { String($0) }.joined(separator: ",")
        let stringFinalAge = finalAge.map { String($0) }.joined(separator: ",")
        let stringFinalGender = finalGender.map { String($0) }.joined(separator: ",")
        let stringFinalGenderIndex = finalGenderIndex.map { String($0) }.joined(separator: ",")
        let stringFinalSex = finalSex.map { String($0) }.joined(separator: ",")
        let stringFinalUserUUIDString = finalUserUUIDString.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSetupPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSetupDocumentsDirectory = csvInputSetupPath
            print("CSV Input Setup DocumentsDirectory: \(csvInputSetupDocumentsDirectory)")
            let csvInputSetupFilePath = csvInputSetupDocumentsDirectory.appendingPathComponent(inputSetupCSVName)
            print(csvInputSetupFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSetupFilePath, append: false)
            try writerSetup.write(row: [stringFinalFirstName])
            try writerSetup.write(row: [stringFinalLastName])
            try writerSetup.write(row: [stringFinalEmail])
            try writerSetup.write(row: [stringFinalPassword])
            try writerSetup.write(row: [stringFinalAge])
            try writerSetup.write(row: [stringFinalGender])
            try writerSetup.write(row: [stringFinalGenderIndex])
            try writerSetup.write(row: [stringFinalSex])
            try writerSetup.write(row: [stringFinalUserUUIDString])
            print("CVS Input Setup Writer Success")
        } catch {
            print("CVSWriter Input Setup Error or Error Finding File for Input Setup CSV \(error.localizedDescription)")
        }
    }
    
    private func link(setup: Setup) -> some View {
        EmptyView()
    }
}


class WhyWeAskModel: ObservableObject {
    @Published var whyDoWeAskForThisText: String = ""
    init() { self.load(file: "whyDoWeAskForThisText") }
    func load(file: String) {
        if let whyFilepath = Bundle.main.path(forResource: "whyDoWeAskForThisText", ofType: "txt") {
            do {
                let whyDoWeAskContents = try String(contentsOfFile: whyFilepath)
                DispatchQueue.main.async {
                    self.whyDoWeAskForThisText = whyDoWeAskContents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}



struct TestUserDataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataEntryView(setup: nil, relatedLink: link)
    }
    
    static func link(setup: Setup) -> some View {
        EmptyView()
    }
}

