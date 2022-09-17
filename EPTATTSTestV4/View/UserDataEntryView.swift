//
//  TestUserDataEntryView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/23/22.
//

import SwiftUI


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
    var id = Int()
    var jsonUserAgreementAgreed = [Int]()
    var jsonStringUserAgreementAgreedDate = String()
    var jsonUserAgreementAgreedDate = [Date]()
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
        case id
        case jsonUserAgreementAgreed
        case jsonStringUserAgreementAgreedDate
        case jsonUserAgreementAgreedDate
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





struct GenderModel: Identifiable, Hashable {
    let gender: String
    let id = UUID()
    var isToggled = false
    init(gender: String) {
        self.gender = gender
    }
}

struct UserDataEntryView: View {
    

    @StateObject var colorModel: ColorModel = ColorModel()
    @Environment(\.presentationMode) var presentationMode
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
    @EnvironmentObject var setupDataModel: SetupDataModel
    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
    
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
    
    @Published var userFirstName = [String]()
    @Published var userLastName = [String]()
    @Published var userEmail = [String]()
    @Published var userPassword = [String]()
    @Published var userAge = [Int]()
    @Published var userBirthDate = [Date]()
    @Published var userGender = [String]()
    @Published var userGenderIndex = [Int]()
    @Published var userSex = [Int]()
    @Published var userUUIDString = [String]()
    @Published var userAgreement = [Bool]()
    @Published var finalUserAgreementAgreed: [Int] = [Int]()
    @Published var finalUserAgreementAgreedDate: [Date] = [Date]()
    // Demo Variables
    @Published var finalFirstName: [String] = [String]()
    @Published var finalLastName: [String] = [String]()
    @Published var finalEmail: [String] = [String]()
    @Published var finalPassword: [String] = [String]()
    @Published var finalAge: [Int] = [Int]()
    @Published var finalGender: [String] = [String]()
    @Published var finalGenderIndex: [Int] = [Int]()
    @Published var finalSex: [Int] = [Int]()
    @Published var finalUserUUIDString: [String] = [String]()
    @Published var stringJsonFUAADate = String()
    @Published var stringFUAADate = String()
    @Published var stringInputFUAADate = String()
    let fileSetupName = ["SetupResults.json"]
    let setupCSVName = "SetupResultsCSV.csv"
    let inputSetupCSVName = "InputSetupResultsCSV.csv"
    
    @Published var saveFinalSetupResults: SaveFinalSetupResults? = nil
    
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
                            UserLoginView()
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
                Spacer()

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
                            .foregroundColor(.green)
                            .cornerRadius(300)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                } else if  userDataSubmitted == true {
                    HStack{
                        Spacer()
                        NavigationLink {
                            userDataSubmitted == false ? AnyView(UserDataEntrySplashView())
                            : userDataSubmitted == true ? AnyView(ExplanationView())
                            : AnyView(UserDataEntrySplashView())
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
                    .padding(.bottom, 40)
                }
            }
            .onAppear(perform: {
                uLinkColorIndex = 0
                userDataSubmitted = false
            })
            .padding(.leading)
            .padding(.trailing)
        }
        .environmentObject(setupDataModel)
    }
    
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
        setupDataModel.userFirstName.append(firtsName)
        setupDataModel.userLastName.append(lastName)
        setupDataModel.userEmail.append(email)
        setupDataModel.userPassword.append(password)
        setupDataModel.userAge.append(adjustedAge)
        setupDataModel.userGender.append(gender[genderIdx])
        setupDataModel.userGenderIndex.append(genderIdx)
        setupDataModel.userSex.append(contentsOf: sex)
        setupDataModel.userUUIDString.append(userUUID)
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
        print("SetupModel firstName: \(setupDataModel.userFirstName)")
        print("SetupModel lastName: \(setupDataModel.userLastName)")
        print("SetupModel email: \(setupDataModel.userEmail)")
        print("SetupModel password: \(setupDataModel.userPassword)")
        print("SetupModel age: \(setupDataModel.userAge)")
        print("SetupModel gender: \(setupDataModel.userGender)")
        print("SetupModel genderIdx: \(setupDataModel.userGenderIndex)")
        print("SetupModel sex: \(setupDataModel.userSex)")
        print("SetupModel userUUIDString: \(setupDataModel.userUUIDString)")
      }
    
    
    func concatenateDemoFinalArrays() async {
        setupDataModel.finalFirstName.append(contentsOf: setupDataModel.userFirstName)
        setupDataModel.finalLastName.append(contentsOf: setupDataModel.userLastName)
        setupDataModel.finalEmail.append(contentsOf: setupDataModel.userEmail)
        setupDataModel.finalPassword.append(contentsOf: setupDataModel.userPassword)
        setupDataModel.finalAge.append(contentsOf: setupDataModel.userAge)
        setupDataModel.finalGender.append(contentsOf: setupDataModel.userGender)
        setupDataModel.finalGenderIndex.append(contentsOf: setupDataModel.userGenderIndex)
        setupDataModel.finalSex.append(contentsOf: setupDataModel.userSex)
        setupDataModel.finalUserUUIDString.append(userUUID)
    }
    
    func printFinalDemoArrays() async {
        
        print("finalFirstName: \(setupDataModel.finalFirstName)")
        print("finalLastName: \(setupDataModel.finalLastName)")
        print("finalEmail: \(setupDataModel.finalEmail)")
        print("finalPassword: \(setupDataModel.finalPassword)")
        print("finalAge: \(setupDataModel.finalAge)")
        print("finalGender: \(setupDataModel.finalGender)")
        print("finalGenderIndex: \(setupDataModel.finalGenderIndex)")
        print("finalSex: \(setupDataModel.finalSex)")
        print("finalUserUUIDString: \(setupDataModel.finalUserUUIDString)")
    }
    
    func saveUserDataEntry() async {
        await setupDataModel.getSetupData()
        await setupDataModel.saveSetupToJSON()
        await setupDataModel.writeSetupResultsToCSV()
        await setupDataModel.writeInputSetupResultsToCSV()
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



//struct GenderListView: View {
//
//    @StateObject var setupDataModel: SetupDataModel = SetupDataModel()
//
//    @State var gender = [String]()
//    @State var genderIdx = [Int]()
//    @State var sex = [Int]()
//    @State var genderList = [
//        GenderModel(gender: "Female"),
//        GenderModel(gender: "Male"),
//        GenderModel(gender: "Cisgender Female"),
//        GenderModel(gender: "Cisgender Male"),
//        GenderModel(gender: "Agender"),
//        GenderModel(gender: "Bigender"),
//        GenderModel(gender: "Gender Fluid"),
//        GenderModel(gender: "Gender Non-Conforming"),
//        GenderModel(gender: "Genderqueer"),
//        GenderModel(gender: "Intersex"),
//        GenderModel(gender: "Third Sex"),
//        GenderModel(gender: "Transgender"),
//        GenderModel(gender: "Two-Spirit"),
//        GenderModel(gender: "Prefer Not To Identify")
//    ]
//    @State private var selectedGender = ""
//
//    var body: some View {
//
//        List {
//            ForEach(genderList.indices, id: \.self) {index in
//            HStack {
//                Text("\(self.genderList[index].gender)")
//                    .foregroundColor(.blue)
//                Toggle("", isOn: self.$genderList[index].isToggled)
//                    .foregroundColor(.blue)
//                    .onChange(of: self.genderList[index].isToggled) { genderIndex in
//                        Task(priority: .userInitiated, operation: {
//                            gender.append(self.genderList[index].gender)
//                            genderIdx.append(index)
//                            setupDataModel.userGender.append(self.genderList[index].gender)
//                            setupDataModel.userGenderIndex.append(index)
//                            print(index)
//                            print(genderIndex)
//                            print(self.genderList[index].gender)
//                            print(setupDataModel.userGender)
//                            print(setupDataModel.userGenderIndex)
//                        })
//                    }
//                }
//            }
//
//        }
//    }
//}

//struct TestUserDataEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDataEntryView()
//            .environmentObject(SetupDataModel())
//    }
//}

