//
//  UserLoginView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
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


struct SaveFinalSetupResults2: Codable {
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


struct GenderModel2: Identifiable, Hashable {
    let gender: String
    let id = UUID()
    var isToggled = false
    init(gender: String) {
        self.gender = gender
    }
}


struct UserLoginView<Link: View>: View {
    var setup: Setup?
    var relatedLink: (Setup) -> Link
    
    var body: some View {
        
        ZStack{
            if let setup = setup {
                UserLoginContent(setup: setup, relatedLink: relatedLink)
            } else {
                Text("Error Loading User Login View")
                    .navigationTitle("")
            }
        }
    }
}


struct UserLoginContent<Link: View>: View {
    var setup: Setup
    var dataModel = DataModel.shared
    var relatedLink: (Setup) -> Link
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var accountCreatedAndLoggedIn2: Bool = false
    @State private var inputLastName = String()
    @State private var dataFileURLLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isLogin = true
    
    let fileDisclaimerName = ["DisclaimerResults.json"]
    let disclaimerCSVName = "DisclaimerResultsCSV.csv"
    let inputDisclaimerCSVName = "InputDisclaimerResultsCSV.csv"
    
    @State var dataFileURLDisclaimerJson2 = URL(fileURLWithPath: "")
    @State var dataFileURLDisclaimerCSV2 = URL(fileURLWithPath: "")
    @State var dataFileURLDisclaimerInputCSV2 = URL(fileURLWithPath: "")
    
    
    
    @State private var userDataSubmitted = false
    @State var userLoggedInSuccessful: Bool = false
    @State var userLoggedInAndSubmitted: Bool = false
    @State var userLogInError: Bool = false
    @State var presentLoginFullScreen: Bool = false
    
    @State var uLinkColors: [Color] = [Color.clear, Color.green]
    @State var uLinkColors2: [Color] = [Color.clear, Color.white]
    @State var uLinkColorIndex = Int()
    
    @State var udLinkColors: [Color] = [Color.clear, Color.green]
    @State var udLinkColors2: [Color] = [Color.clear, Color.white]
    @State var udLinkColorIndex = Int()
    
    @State private var firtsName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: Int = Int()
    @State private var gender = [
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
    
    @State private var genderIdx = Int()
    @State private var sex = [Int]()
    @State private var userUUID = String()
    
    @State private var genderList = [
        GenderModel2(gender: "Female or Cisgender Female"),
        GenderModel2(gender: "Male or Cisgender Male"),
        GenderModel2(gender: "Agender"),
        GenderModel2(gender: "Bigender"),
        GenderModel2(gender: "Gender Non-Conforming"),
        GenderModel2(gender: "Genderqueer"),
        GenderModel2(gender: "Intersex"),
        GenderModel2(gender: "Third Sex"),
        GenderModel2(gender: "Transgender"),
        GenderModel2(gender: "Prefer Not To Identify")
    ]
    @State private var selectedGender = ""
    
    @State private var userFirstName = [String]()
    @State private var userLastName = [String]()
    @State private var userEmail = [String]()
    @State private var userPassword = [String]()
    @State private var userAge = [Int]()
    @State private var userBirthDate = [Date]()
    @State private var userGender = [String]()
    @State private var userGenderIndex = [Int]()
    @State private var userSex = [Int]()
    @State private var userUUIDString = [String]()
    
    // Demo Variables
    @State private var finalFirstName: [String] = [String]()
    @State private var finalLastName: [String] = [String]()
    @State private var finalEmail: [String] = [String]()
    @State private var finalPassword: [String] = [String]()
    @State private var finalAge: [Int] = [Int]()
    @State private var finalGender: [String] = [String]()
    @State private var finalGenderIndex: [Int] = [Int]()
    @State private var finalSex: [Int] = [Int]()
    @State private var finalUserUUIDString: [String] = [String]()
    
    let fileSetupName = ["SetupResults.json"]
    let setupCSVName = "SetupResultsCSV.csv"
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    
    
    @State var saveFinalSetupResults2: SaveFinalSetupResults2? = nil
    
    var body: some View {
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                HStack{
                    Spacer()
                    Text("User Login Screen")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                HStack{
                    VStack(alignment: .leading) {
                        Text(" Use The Tester Profile Info Below To Login.")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.bottom, 5)
                        Text("Tester@TrueToSourceSound.com")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                        Text("password")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .padding(.top, 5)
                            .padding(.bottom, 20)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
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
                Spacer()
                if userDataSubmitted == false && userLoggedInSuccessful == false {
                    HStack{
                        Spacer()
                        Button {
                            loginUser2()
                            presentLoginFullScreen = true
                            print("Data Submission Pressed. Function Need to be created")
                        } label: {
                            HStack{
                                Spacer()
                                Text("Login")
                                Spacer()
                                Image(systemName: "arrow.up.doc.fill")
                                Spacer()
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .cornerRadius(24)
                        Spacer()
                    }
                } else if userDataSubmitted == true || userLoggedInSuccessful == true  {
                    HStack{
                        Spacer()
                        NavigationLink {
                            userLoggedInAndSubmitted == false && userDataSubmitted == false ? AnyView(UserDataEntrySplashView(setup: setup, relatedLink: link))
                            : userLoggedInAndSubmitted == true && userDataSubmitted == true ? AnyView(ExplanationView(setup: setup, relatedLink: link))
                            : AnyView(UserDataEntrySplashView(setup: setup, relatedLink: link))
                        } label: {
                            HStack{
                                Spacer()
                                Text("Check Profile and Continue")
                                Spacer()
                                Image(systemName: "arrowshape.bounce.right")
                                Spacer()
                            }
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }
                        .frame(width: 300, height: 50, alignment: .center)
                        .cornerRadius(24)
                        Spacer()
                    }
                }
                HStack{
                    NavigationLink("ExplanationView", destination: ExplanationView(setup: setup, relatedLink: link))
                        .foregroundColor(.clear)
                        .background(Color.clear)
                }
                .frame(width: 300, height: 50, alignment: .center)
                .foregroundColor(.clear)
                .background(Color.clear)
                .cornerRadius(24)
                .padding(.bottom, 60)
                .navigationDestination(isPresented: $userLoggedInAndSubmitted) {
                    ExplanationView(setup: setup, relatedLink: link)
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $presentLoginFullScreen) {
                ZStack {
                    colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea()
                    VStack {
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
                        VStack{
                            HStack{
                                Spacer()
                                Text("Select Your Age")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.bottom, 5)
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
                            .padding(.bottom, 5)
                            HStack{
                                Spacer()
                                Text("Select Your Gender")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .padding(.top, 20)
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
                        // Need to add trigger variable to this function series to trigger navigation to the next screen
                        if userDataSubmitted == false {
                            HStack{
                                Spacer()
                                Button {
                                    userDataSubmitted = true
                                    DispatchQueue.main.async(group: .none, qos: .userInitiated) {
                                        Task(priority: .userInitiated, operation: {
                                            await assignSex2()
                                            await areDemoFieldsEmpty2()
                                            await saveDemographicData2()
                                            await generateUserUUID2()
                                            await concatenateDemoFinalArrays2()
                                            await printFinalDemoArrays2()
                                            await saveUserDataEntry2()
                                            loginUser2()
                                            await loginAndDataSuccessful()
                                            print("Data Submission Pressed. Function Need to be created")
                                        })
                                    }
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Upload Your Data")
                                        Spacer()
                                        Image(systemName: "arrow.up.doc.fill")
                                        Spacer()
                                    }
                                    .frame(width: 300, height: 50, alignment: .center)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(24)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 60)
                        } else if userDataSubmitted == true {
                            HStack{
                                Spacer()
                                Button {
                                    self.userDataSubmitted = true
                                    presentLoginFullScreen.toggle()
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Now Let's Contine!")
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
                            .padding(.bottom, 60)
                        }
                    }
                }
                .onAppear(perform: {
                    userDataSubmitted = false
                    userLoggedInSuccessful = false
                    userLoggedInAndSubmitted = false
                    isLogin = true
                    Task {
                        await checkDataLinkJson2()
                        await checkDataLinkCSV2()
                        await checkDataLinkInputCSV2()
                    }
                })
                .onChange(of: userLoggedInAndSubmitted) { uLIASValue in
                    if uLIASValue == true {
                        Task {
                            await uploadUserDataEntry()
                            print("Success creating, loging in and starting upload")
                        }
                    } else {
                        print("Fatal Error in accountCreatedAndLoggedIn logic")
                    }
                }
            }
            .navigationTitle("")
        }
    }
}

extension UserLoginContent {
//MARK: -Extenstion Authorization Methods
    private func loginUser2() {
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


extension UserLoginContent {
//MARK: -Extension Methods
    
    func loginAndDataSuccessful() async {
        if userLoggedInSuccessful == true && userDataSubmitted == true {
            userLoggedInAndSubmitted = true
            print("userLoggedInAndSubmitted: \(userLoggedInAndSubmitted)")
        } else if userLoggedInSuccessful == false || userDataSubmitted == false {
            userLoggedInAndSubmitted = false
            userLogInError = true
            print("userLoggedInAndSubmitted: \(userLoggedInAndSubmitted)")
            print("userLoggedInSuccessful: \(userLoggedInSuccessful)")
            print("userDataSubmitted: \(userDataSubmitted)")
        } else {
            userLogInError = true
            print("!!Fatal error in loginAndDataSuccessful() Logic")
        }
    }
    
    func assignSex2() async {
        if genderIdx == 0 {
            sex.append(0) // Female
        } else if genderIdx == 1 {
            sex.append(1) // Maled
        } else  if genderIdx > 1 && genderIdx < 10 {
            sex.append(1) // Default to Male to ensure lower starting thresholds if birth sex is unknown
            print("default gender selectd: \(genderIdx) \(gender[genderIdx])")
        }
    }
    
    func areDemoFieldsEmpty2() async {
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
    
    func generateUserUUID2() async {
        userUUID = UUID().uuidString
        print("userUUID: \(userUUID)")
    }
    
    func saveDemographicData2() async {
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
    
    func concatenateDemoFinalArrays2() async {
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
    
    func printFinalDemoArrays2() async {
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
    
    func saveUserDataEntry2() async {
        await getSetupData2()
        await saveSetupToJSON2()
        await writeSetupResultsToCSV2()
        await writeInputSetupResultsToCSV2()
        inputLastName = lastName
    }
    
    func uploadUserDataEntry() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            uploadFile2(fileName: disclaimerCSVName)
            uploadFile2(fileName: inputDisclaimerCSVName)
            uploadFile2(fileName: "DisclaimerResults.json")
            
            uploadFile2(fileName: setupCSVName)
            uploadFile2(fileName: inputSetupCSVName)
            uploadFile2(fileName: "SetupResults.json")
        }
    }
}

extension UserLoginContent {
    //MARK: -Extension CSV/JSON Methods
    func getSetupData2() async {
        guard let setupData = await self.getDemoJSONData2() else { return }
        print("Json Setup Data 2:")
        print(setupData)
        let jsonSetupString = String(data: setupData, encoding: .utf8)
        print(jsonSetupString!)
        do {
            self.saveFinalSetupResults2 = try JSONDecoder().decode(SaveFinalSetupResults2.self, from: setupData)
            print("JSON GetData Run 2")
            print("data: \(setupData)")
        } catch let error {
            print("!!!Error decoding setup json data: \(error)")
        }
    }
    
    func getDemoJSONData2() async -> Data? {
        let saveFinalSetupResults2 = SaveFinalSetupResults2 (
            jsonFinalFirstName: finalFirstName,
            jsonFinalLastName: finalLastName,
            jsonFinalEmail: finalEmail,
            jsonFinalPassword: finalPassword,
            jsonFinalAge: finalAge,
            jsonFinalGender: finalGender,
            jsonFinalGenderIndex: finalGenderIndex,
            jsonFinalSex: finalSex,
            jsonUserUUID: finalUserUUIDString)
        let jsonSetupData = try? JSONEncoder().encode(saveFinalSetupResults2)
        print("saveFinalResults: \(saveFinalSetupResults2)")
        print("Json Encoded \(jsonSetupData!)")
        return jsonSetupData
        
    }
    
    func saveSetupToJSON2() async {
        // !!!This saves to device directory, whish is likely what is desired
        let setupPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = setupPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let setupFilePaths = documentsDirectory.appendingPathComponent(fileSetupName[0])
        print(setupFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSetupData = try encoder.encode(saveFinalSetupResults2)
            print(jsonSetupData)
            
            try jsonSetupData.write(to: setupFilePaths)
        } catch {
            print("Error writing to JSON Setup file 2: \(error)")
        }
    }
    
    func writeSetupResultsToCSV2() async {
        print("writeSetupResultsToCSV2 Start")
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
            print("CSV Setup DocumentsDirectory 2: \(csvSetupDocumentsDirectory)")
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
            print("CVS Setup Writer 2 Success")
        } catch {
            print("CVSWriter Setup 2 Error or Error Finding File for Setup 2 CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSetupResultsToCSV2() async {
        print("writeInputSetupResultsToCSV2 Start")
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
            print("CSV Input Setup DocumentsDirectory 2: \(csvInputSetupDocumentsDirectory)")
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
            print("CVSWriter Input Setup 2 Error or Error Finding File for Input Setup 2 CSV \(error.localizedDescription)")
        }
    }
    
    
    private func getDirectoryPath2() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Only Use Files that have a pure string name assigned, not a name of ["String"]
    private func uploadFile2(fileName: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let storageRef = Storage.storage().reference()
            let fileName = fileName //e.g.  let setupCSVName = ["SetupResultsCSV.csv"] with an input from (let setupCSVName = "SetupResultsCSV.csv")
            let lastNameRef = storageRef.child(inputLastName)
            let fileManager = FileManager.default
            let filePath = (self.getDirectoryPath2() as NSString).strings(byAppendingPaths: [fileName])
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
    
    private func getDataLinkPath2() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
    
    private func checkDataLinkJson2() async {
        //        let dataName = ["!!!INSERT FILE NAME VARIABLE!!!"]
        let dataName = "DisclaimerResults.json"
        let fileManager = FileManager.default
        let dataPath = (await self.getDataLinkPath2() as NSString).strings(byAppendingPaths: [dataName])
        if fileManager.fileExists(atPath: dataPath[0]) {
            let dataFilePath = URL(fileURLWithPath: dataPath[0])
            if dataFilePath.isFileURL  {
                dataFileURLDisclaimerJson2 = dataFilePath
                print("dataFilePath: \(dataFilePath)")
                print("dataFileURL: \(dataFileURLDisclaimerJson2)")
                print("Input File Exists")
            } else {
                print("Data File Path Does Not Exist")
            }
        }
    }
    
    private func checkDataLinkCSV2() async {
        //        let dataName = ["!!!INSERT FILE NAME VARIABLE!!!"]
        let dataName = "DisclaimerResultsCSV.csv"
        let fileManager = FileManager.default
        let dataPath = (await self.getDataLinkPath2() as NSString).strings(byAppendingPaths: [dataName])
        if fileManager.fileExists(atPath: dataPath[0]) {
            let dataFilePath = URL(fileURLWithPath: dataPath[0])
            if dataFilePath.isFileURL  {
                dataFileURLDisclaimerCSV2 = dataFilePath
                print("dataFilePath: \(dataFilePath)")
                print("dataFileURL: \(dataFileURLDisclaimerCSV2)")
                print("Input File Exists")
            } else {
                print("Data File Path Does Not Exist")
            }
        }
    }
    
    private func checkDataLinkInputCSV2() async {
        //        let dataName = ["!!!INSERT FILE NAME VARIABLE!!!"]
        let dataName = "InputDisclaimerResultsCSV.csv"
        let fileManager = FileManager.default
        let dataPath = (await self.getDataLinkPath2() as NSString).strings(byAppendingPaths: [dataName])
        if fileManager.fileExists(atPath: dataPath[0]) {
            let dataFilePath = URL(fileURLWithPath: dataPath[0])
            if dataFilePath.isFileURL  {
                dataFileURLDisclaimerInputCSV2 = dataFilePath
                print("dataFilePath: \(dataFilePath)")
                print("dataFileURL: \(dataFileURLDisclaimerInputCSV2)")
                print("Input File Exists")
            } else {
                print("Data File Path Does Not Exist")
            }
        }
    }
}

extension UserLoginContent {
//MARK: -NavigationLink Method
    private func link(setup: Setup) -> some View {
        EmptyView()
    }
}

//struct UserLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserLoginView(setup: nil, relatedLink: link)
//    }
//
//    static func link(setup: Setup) -> some View {
//        EmptyView()
//    }
//}
