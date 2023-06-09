//
//  PostBilateral1kHzTestView.swift
//  TTS_Hearing_Test
//
//  Created by Jeffrey Jaskunas on 9/14/22.
//

import SwiftUI
import CodableCSV
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

struct PostBilateral1kHzTestView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            PostBilateral1kHzTestContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading PostBilateral1kHzTest View")
                .navigationTitle("")
        }
    }
}

struct PostBilateral1kHzTestContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    
    @EnvironmentObject private var naviationModel: NavigationModel
    
    @StateObject var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    @State var ehaBetaLinkExists = Bool()
    @State var eptaBetaLinkExists = Bool()
    @State var betaTestsArray = ["", "Shorter EPTA", "Full EHA", "Error in Test Index"]
    @State var betaTestSelectedIdx = 0
    @State var betaTestColorArray: [Color] = [Color.blue, Color.green, Color.red]
    @State var betaEPTATestSelectedIdx = Int()
    @State var betaEHAP1TestSelectedIdx = Int()
    @State var betaEHAP2TestSelectedIdx = Int()
    
    @State var phonGain = Float()
    @State var betaUserTestedIntraEarDelta = Float()
    @State var betaUserTestedReferenceGain = Float()
    @State var betaUserBetterEar = Float()      // Left = -1,0  and Right = 1.0
    @State var betaUserVPhonDiff = Float()
    @State var phonIsGreater = Bool()
    @State var reassessGainCurve = Bool()
    @State var finalUserGainSetting = Float()
    
    @State var gainLinkName = String()
    
    
    @State var femaleBetaLinkExists: Bool = false
    @State var maleBetaLinkExists: Bool = false
    @State var age0BetaLinkExists: Bool = false
    @State var age1BetaLinkExists: Bool = false
    @State var age2BetaLinkExists: Bool = false
    @State var age3BetaLinkExists: Bool = false
    @State var age4BetaLinkExists: Bool = false
    @State var age5BetaLinkExists: Bool = false
    @State var age6BetaLinkExists: Bool = false
    
    
    @State var betaInputOnekHz_averageGainRightArray1 = Float()
    @State var betaInputOnekHz_averageGainRightArray2 = Float()
    @State var betaInputOnekHz_averageGainRightArray3 = Float()
    @State var betaInputOnekHz_averageGainRightArray4 = Float()
    @State var betaInputOnekHz_averageGainLeftArray1 = Float()
    @State var betaInputOnekHz_averageGainLeftArray2 = Float()
    @State var betaInputOnekHz_averageGainLeftArray3 = Float()
    @State var betaInputOnekHz_averageGainLeftArray4 = Float()
    @State var betaInputOnekHz_averageLowestGainRightArray = Float()
    @State var betaInputOnekHz_HoldingLowestRightGainArray = Float()
    @State var betaInputOnekHz_averageLowestGainLeftArray = Float()
    @State var betaInputOnekHz_HoldingLowestLeftGainArray = Float()
    
    @State var dataFileURL13Beta = URL(fileURLWithPath: "")
    
    @State var userSubmittedSettings = Bool()
    
    let betaInputOnekHzSummaryCSVName = "InputSummaryOnekHzResultsCSV.csv"
    
    let inputBetaEHACSVName = "EHA.csv"
    let inputBetaEPTACSVName = "EPTA.csv"
    
    
    @State var betaInputOnekHz_averageLowestGainDBRightArray = Float()
    @State var betaInputOnekHz_averageLowestGainDBLeftArray = Float()
    
    var body: some View {
        ZStack{
            Image("Background1 1").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(.all, edges: .top)
            //colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Spacer()
                // Add in code to determine phone curve here or in each test. Maybe test it here
                Text("Test Selected: \(betaTestsArray[betaTestSelectedIdx])")
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .padding(.bottom, 10)
                Text("Gain Curve: \(finalUserGainSetting)")
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                //Check Test Selection
                Button {
                    Task {
                        await checkBetaEHATestLik()
                        await checkTrainEPTATestLik()
                        await returnBetaTestSelected()
                        await checkMaleLink()
                        await checkFemaleLink()
                        await checkAge0Link()
                        await checkAge1Link()
                        await checkAge2Link()
                        await checkAge3Link()
                        await checkAge4Link()
                        await checkAge5Link()
                        await checkAge6Link()
                        await betaOnekHzInputResultsCSVReader()
                        await betaReviewWriteGainSetting()
                    }
                } label: {
                    Text("Analyze Results From The Last Test")
                        .padding()
                        .font(.subheadline)
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.266666666666667, green: 0.043137254901961, blue: 0.843137254901961)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                        .foregroundColor(.white)
                        .hoverEffect()
                        .cornerRadius(24)
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if phonGain != 0 && ehaBetaLinkExists == false && eptaBetaLinkExists == true {
                    Text("Now We're Ready To Start The Main Test Phases")
                        .font(.title)
                        .foregroundColor(colorModel.sunriseBrightYellow)
                        .padding()
                        .padding(.top, 20)
                    Spacer()
                    NavigationLink(destination: {
                        EHATTSTestPart1View(testing: testing, relatedLinkTesting: linkTesting)
                    }, label: {
                        VStack{
                            Text("Test Selected: EPTA Short Test")
                                .foregroundColor(.white)
                            Text("Continue to Start Test")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        }
                    })
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                } else if phonGain != 0 && ehaBetaLinkExists == true && eptaBetaLinkExists == false {
                    Text("Now We're Ready To Start The Main Test Phases")
                        .font(.title)
                        .foregroundColor(colorModel.sunriseBrightYellow)
                        .padding()
                        .padding(.top, 20)
                    Spacer()
                    NavigationLink(destination: {
                        EHATTSTestPart1View(testing: testing, relatedLinkTesting: linkTesting)
                    }, label: {
                        VStack{
                            Text("Test Selected: EHA Full Test")
                                .foregroundColor(.white)
                            Text("Continue to Start Test")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        }
                    })
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                } else if userSubmittedSettings == true && ehaBetaLinkExists == false && eptaBetaLinkExists == false {
                    Text("Now We're Ready To Start The Main Test Phases")
                        .font(.title)
                        .foregroundColor(colorModel.sunriseBrightYellow)
                        .padding()
                        .padding(.top, 20)
                    Spacer()
                    VStack{
                        NavigationLink(destination: {
                            EHATTSTestPart1View(testing: testing, relatedLinkTesting: linkTesting)
                        }, label: {
                            Text("1. EPTA Short Test")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        })
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        NavigationLink(destination: {
                            EHATTSTestPart1View(testing: testing, relatedLinkTesting: linkTesting)
                        }, label: {
                            Text("2. EHA Full Test")
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(LinearGradient(colors: [Color(red: 0.333333333333333, green: 0.325490196078431, blue: 0.643137254901961), Color(red: 0.945098039215686, green: 0.36078431372549, blue: 0.133333333333333)], startPoint: UnitPoint(x: 0.3, y: 0.3), endPoint: UnitPoint(x: 0.9, y: 0.4)))
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        })
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                }
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .onAppear {
                Task {
                    await comparedLastNameCSVReader()
                }
            }
            .onChange(of: phonGain) { phonValue in
                if phonValue > 0.0 {
                    Task {
                        await uploadPostBilateralData()
                    }
                } else {
                    print("Fatal error in phon value change of logic")
                }
            }
        }
    }
}
 
extension PostBilateral1kHzTestContent {
//MARK: -Extension Methods
    func betaReviewWriteGainSetting() async {
        await betaGainCurveGenderAge()
        await betaUserItrnaEarDeltaGain()
        await compareBetaUserPhonGains()
        await compareDetlta()
        await determineBetaGainCurve()
        await writeBetaFinalGainSettingToCSV()
    }
    
    func uploadPostBilateralData() async {
        DispatchQueue.main.async(group: .none, qos: .background) {
            uploadFile(fileName: betaInputOnekHzSummaryCSVName)
        }
    }
    
    func determineBetaGainCurve() async {
        //TODO: Unclear on how to make this work without having actual testing data. For now, just use phon value
        
        // compare actual bilateral results with gender age curve and pick the best option
        // unclear how to write this logic. Maybe based on age? Need to find a way to pick the cloest
        // or start with base of phon gain and then go from there...
        // if phon is 2.5 and + delta is < 4, use 2.5, but if it is greater than 4 and < 5, use 4 and if it is greater than 5, but less than 7, use 5, and if it is >7, but < 8, use 7, and if it is >8, but less than 11, use 8 and so on for 11, 16, 17, 24, 27
        // the logical comparitor would be X > 4 && X < 5, then use 4!!!!!!!
        
        // Only need the above logic when reference is > phon
        
        // if reference is less than phon, find the next lowest phon value below the reference value and use that phon value for the gain setting
        
        // once phon setting is determined, create a csv file with phon(#) to then look for in each test view
        
        finalUserGainSetting = phonGain
        if finalUserGainSetting == 2.5 {
            self.gainLinkName = "2_5.csv"
        } else if finalUserGainSetting == 4 {
            self.gainLinkName = "4.csv"
        } else if finalUserGainSetting == 5 {
            self.gainLinkName = "5.csv"
        }  else if finalUserGainSetting == 7 {
            self.gainLinkName = "7.csv"
        } else if finalUserGainSetting == 8 {
            self.gainLinkName = "8.csv"
        } else if finalUserGainSetting == 11 {
            self.gainLinkName = "11.csv"
        } else if finalUserGainSetting == 16 {
            self.gainLinkName = "16.csv"
        } else if finalUserGainSetting == 17 {
            self.gainLinkName = "17.csv"
        } else if finalUserGainSetting == 24 {
            self.gainLinkName = "24.csv"
        } else if finalUserGainSetting == 27 {
            self.gainLinkName = "27.csv"
        } else {
            print("!!Critical Error in determineBetaGainCurve() Logic")
        }
    }
    
    func compareDetlta() async {
        if betaUserVPhonDiff >= 0.05 {
            reassessGainCurve = true
            print("!!!! Critical Difference in Bilateral Test and Phon Value")
        } else if betaUserVPhonDiff < 0.05 {
            reassessGainCurve = false
        } else {
            print("Critical Error in compareDelta() Logic")
        }
    }
    
    func compareBetaUserPhonGains() async {
        if phonGain/100 > betaUserTestedReferenceGain {
            betaUserVPhonDiff = phonGain/100 - betaUserTestedReferenceGain
            phonIsGreater = true
            print("phonGain: \(phonGain/100)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        } else if phonGain/100 < betaUserTestedReferenceGain {
            betaUserVPhonDiff = betaUserTestedReferenceGain - phonGain/100
            phonIsGreater = false
            print("phonGain: \(phonGain/100)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        } else {
            print("Critical Error in compareBetaUserPhonGains")
            print("phonGain: \(phonGain/100)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        }
    }
    
    func betaUserItrnaEarDeltaGain() async {
        print("betaInputOnekHz_averageLowestGainRightArray: \(betaInputOnekHz_averageLowestGainRightArray)")
        print("betaInputOnekHz_HoldingLowestRightGainArray: \(betaInputOnekHz_HoldingLowestRightGainArray)")
        print("betaInputOnekHz_averageLowestGainLeftArray: \(betaInputOnekHz_averageLowestGainLeftArray)")
        print("betaInputOnekHz_HoldingLowestLeftGainArray: \(betaInputOnekHz_HoldingLowestLeftGainArray)")
        
        if betaInputOnekHz_averageLowestGainRightArray > betaInputOnekHz_averageLowestGainLeftArray {
            betaUserTestedIntraEarDelta = betaInputOnekHz_averageLowestGainRightArray - betaInputOnekHz_averageLowestGainLeftArray
            betaUserTestedReferenceGain = betaInputOnekHz_averageLowestGainLeftArray
            betaUserBetterEar = -1.0
            print("betaUserTestedReferenceGain : \(betaUserTestedReferenceGain )")
            print("betaUserBetterEar: \(betaUserBetterEar)")
        } else if betaInputOnekHz_averageLowestGainRightArray <= betaInputOnekHz_averageLowestGainLeftArray {
            betaUserTestedIntraEarDelta = betaInputOnekHz_averageLowestGainLeftArray - betaInputOnekHz_averageLowestGainRightArray
            betaUserTestedReferenceGain = betaInputOnekHz_averageLowestGainRightArray
            betaUserBetterEar = 1.0
            print("betaUserTestedReferenceGain : \(betaUserTestedReferenceGain )")
            print("betaUserBetterEar: \(betaUserBetterEar)")
        } else {
            print("!!!Fatal error in betaUserIntraEarDeltaGain() Logic")
        }
    }
    
    
    
    
    
    
    func betaUserItrnaEarDeltaGainDB() async {
        print("betaInputOnekHz_averageLowestGainDBLeftArray: \(betaInputOnekHz_averageLowestGainDBLeftArray)")
        print("betaInputOnekHz_averageLowestGainDBRightArra: \(betaInputOnekHz_averageLowestGainDBRightArray)")
        
        if betaInputOnekHz_averageLowestGainDBRightArray > betaInputOnekHz_averageLowestGainDBLeftArray {
            betaUserTestedIntraEarDelta = betaInputOnekHz_averageLowestGainRightArray - betaInputOnekHz_averageLowestGainLeftArray
            betaUserTestedReferenceGain = betaInputOnekHz_averageLowestGainLeftArray
            betaUserBetterEar = -1.0
            print("betaUserTestedReferenceGain : \(betaUserTestedReferenceGain )")
            print("betaUserBetterEar: \(betaUserBetterEar)")
        } else if betaInputOnekHz_averageLowestGainDBRightArray <= betaInputOnekHz_averageLowestGainDBLeftArray {
            betaUserTestedIntraEarDelta = betaInputOnekHz_averageLowestGainLeftArray - betaInputOnekHz_averageLowestGainRightArray
            betaUserTestedReferenceGain = betaInputOnekHz_averageLowestGainRightArray
            betaUserBetterEar = 1.0
            print("betaUserTestedReferenceGain : \(betaUserTestedReferenceGain )")
            print("betaUserBetterEar: \(betaUserBetterEar)")
        } else {
            print("!!!Fatal error in betaUserIntraEarDeltaGain() Logic")
        }
    }
    
    func compareBetaUserPhonGainsDB() async {
        if phonGain > (betaUserTestedReferenceGain - 6) {
            betaUserVPhonDiff = phonGain - (betaUserTestedReferenceGain - 6)
            phonIsGreater = true
            print("phonGain: \(phonGain)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        } else if phonGain < (betaUserTestedReferenceGain-6) {
            betaUserVPhonDiff = (betaUserTestedReferenceGain-6) - phonGain
            phonIsGreater = false
            print("phonGain: \(phonGain)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        } else {
            print("Critical Error in compareBetaUserPhonGains")
            print("phonGain: \(phonGain)")
            print("betaUserTestedReferenceGain: \(betaUserTestedReferenceGain)")
        }
    }
    
    // age0 == false && age1 == false && age2 == false && age3 == false && age4 == false && age5 == false && age6 == false
    // <= 27").tag(10)   age0.csv
    // 28-39").tag(11)   age1.csv
    // 40-49").tag(12)   age2.csv
    // 50-59").tag(13)   age3.csv
    // 60-69").tag(14)   age4.csv
    // 70-79").tag(15)   age5.csv
    // 80-89").tag(16)   age6.csv
    
    func betaGainCurveGenderAge() async {
        if femaleBetaLinkExists == true && maleBetaLinkExists == false {
            // enter separate female if logic based on age
            if age0BetaLinkExists == true && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 2.5  //2.5
            } else if age0BetaLinkExists == false && age1BetaLinkExists == true && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 2.5  //2.5
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == true && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 4  //4
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == true && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 7   //7
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == true && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 11   //11
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == true && age6BetaLinkExists == false {
                phonGain = 17   //17
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == true {
                phonGain = 27   //27
            }else {
                print("!!!Fatal error in Female age section of betaGainCurveGenderAge() logic")
            }
            
        } else if femaleBetaLinkExists == false && maleBetaLinkExists == true {
            //enter male if logic base on age
            if age0BetaLinkExists == true && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 2.5  //2.5
            } else if age0BetaLinkExists == false && age1BetaLinkExists == true && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 2.5  //2.5
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == true && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 5    //5
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == true && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 8    //8
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == true && age5BetaLinkExists == false && age6BetaLinkExists == false {
                phonGain = 11   //11
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == true && age6BetaLinkExists == false {
                phonGain = 16   //16
            } else if age0BetaLinkExists == false && age1BetaLinkExists == false && age2BetaLinkExists == false && age3BetaLinkExists == false && age4BetaLinkExists == false && age5BetaLinkExists == false && age6BetaLinkExists == true {
                phonGain = 24   //24
            }else {
                print("!!!Fatal error in Male age section of betaGainCurveGenderAge() logic")
            }
        } else {
            print("!!!Fatal error in betaGainCurveGenderAge() Logic")
        }
        
    }
    
    func returnBetaTestSelected() async {
        if eptaBetaLinkExists == true && ehaBetaLinkExists == false {
            betaTestSelectedIdx = 1
            betaEPTATestSelectedIdx = 1
            betaEHAP1TestSelectedIdx = 2
            betaEHAP2TestSelectedIdx = 2
            print("EPTA Test Link Exists")
            userSubmittedSettings = true
        } else if eptaBetaLinkExists == false && ehaBetaLinkExists == true {
            betaTestSelectedIdx = 2
            betaEPTATestSelectedIdx = 2
            betaEHAP1TestSelectedIdx = 1
            betaEHAP2TestSelectedIdx = 2
            print("EHA Link Exist")
            userSubmittedSettings = true
        } else {
            betaTestSelectedIdx = 3
            betaEPTATestSelectedIdx = 2
            betaEHAP1TestSelectedIdx = 2
            betaEHAP2TestSelectedIdx = 2
            print("Error in test index")
            userSubmittedSettings = true
        }
    }
    
    func getBetaTestLinkPath() async -> String {
        let testBetaLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsBetaDirectory = testBetaLinkPaths[0]
        return documentsBetaDirectory
    }
    
    //NEED NEW APPROACH. THIS DOESN'T WORK IF TWO FILES ARE CREATED
    // NEED TO FIGURE OUT HOW TO DELETE FILES ON SECOND ATTEMPT TO TAKE TEST
    func checkBetaEHATestLik() async {
        let ehaBetaName = ["EHA.csv"]
        let fileEHABetaManager = FileManager.default
        let ehaBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: ehaBetaName)
        if fileEHABetaManager.fileExists(atPath: ehaBetaPath[0]) {
            let ehaBetaFilePath = URL(fileURLWithPath: ehaBetaPath[0])
            if ehaBetaFilePath.isFileURL  {
                ehaBetaLinkExists = true
            } else {
                print("EHA.csv Does Not Exist")
            }
        }
    }
    
    func checkTrainEPTATestLik() async {
        let eptaBetaName = ["EPTA.csv"]
        let fileEPTABetaManager = FileManager.default
        let eptaBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: eptaBetaName)
        if fileEPTABetaManager.fileExists(atPath: eptaBetaPath[0]) {
            let eptaBetaFilePath = URL(fileURLWithPath: eptaBetaPath[0])
            if eptaBetaFilePath.isFileURL  {
                eptaBetaLinkExists = true
            } else {
                print("EPTA.csv Does Not Exist")
            }
        }
    }
    
    func checkMaleLink() async {
        let maleBetaName = ["male.csv"]
        let fileMaleBetaManager = FileManager.default
        let maleBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: maleBetaName)
        if fileMaleBetaManager.fileExists(atPath: maleBetaPath[0]) {
            let maleBetaFilePath = URL(fileURLWithPath: maleBetaPath[0])
            if maleBetaFilePath.isFileURL  {
                maleBetaLinkExists = true
            } else {
                print("male.csv Does Not Exist")
            }
        }
    }
    
    func checkFemaleLink() async {
        let femaleBetaName = ["female.csv"]
        let fileFemaleBetaManager = FileManager.default
        let femaleBetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: femaleBetaName)
        if fileFemaleBetaManager.fileExists(atPath: femaleBetaPath[0]) {
            let femaleBetaFilePath = URL(fileURLWithPath: femaleBetaPath[0])
            if femaleBetaFilePath.isFileURL  {
                femaleBetaLinkExists = true
            } else {
                print("female.csv Does Not Exist")
            }
        }
    }
    
    func checkAge0Link() async {
        let age0BetaName = ["age0.csv"]
        let fileAge0BetaManager = FileManager.default
        let age0BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age0BetaName)
        if fileAge0BetaManager.fileExists(atPath: age0BetaPath[0]) {
            let age0BetaFilePath = URL(fileURLWithPath: age0BetaPath[0])
            if age0BetaFilePath.isFileURL  {
                age0BetaLinkExists = true
            } else {
                print("age0.csv Does Not Exist")
            }
        }
    }
    
    func checkAge1Link() async {
        let age1BetaName = ["age1.csv"]
        let fileAge1BetaManager = FileManager.default
        let age1BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age1BetaName)
        if fileAge1BetaManager.fileExists(atPath: age1BetaPath[0]) {
            let age1BetaFilePath = URL(fileURLWithPath: age1BetaPath[0])
            if age1BetaFilePath.isFileURL  {
                age1BetaLinkExists = true
            } else {
                print("age1.csv Does Not Exist")
            }
        }
    }
    
    func checkAge2Link() async {
        let age2BetaName = ["age2.csv"]
        let fileAge2BetaManager = FileManager.default
        let age2BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age2BetaName)
        if fileAge2BetaManager.fileExists(atPath: age2BetaPath[0]) {
            let age2BetaFilePath = URL(fileURLWithPath: age2BetaPath[0])
            if age2BetaFilePath.isFileURL  {
                age2BetaLinkExists = true
            } else {
                print("age2.csv Does Not Exist")
            }
        }
    }
    
    func checkAge3Link() async {
        let age3BetaName = ["age3.csv"]
        let fileAge3BetaManager = FileManager.default
        let age3BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age3BetaName)
        if fileAge3BetaManager.fileExists(atPath: age3BetaPath[0]) {
            let age3BetaFilePath = URL(fileURLWithPath: age3BetaPath[0])
            if age3BetaFilePath.isFileURL  {
                age3BetaLinkExists = true
            } else {
                print("age3.csv Does Not Exist")
            }
        }
    }
    
    func checkAge4Link() async {
        let age4BetaName = ["age4.csv"]
        let fileAge4BetaManager = FileManager.default
        let age4BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age4BetaName)
        if fileAge4BetaManager.fileExists(atPath: age4BetaPath[0]) {
            let age4BetaFilePath = URL(fileURLWithPath: age4BetaPath[0])
            if age4BetaFilePath.isFileURL  {
                age4BetaLinkExists = true
            } else {
                print("age4.csv Does Not Exist")
            }
        }
    }
    
    func checkAge5Link() async {
        let age5BetaName = ["age5.csv"]
        let fileAge5BetaManager = FileManager.default
        let age5BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age5BetaName)
        if fileAge5BetaManager.fileExists(atPath: age5BetaPath[0]) {
            let age5BetaFilePath = URL(fileURLWithPath: age5BetaPath[0])
            if age5BetaFilePath.isFileURL  {
                age5BetaLinkExists = true
            } else {
                print("age5.csv Does Not Exist")
            }
        }
    }
    
    func checkAge6Link() async {
        let age6BetaName = ["age6.csv"]
        let fileAge6BetaManager = FileManager.default
        let age6BetaPath = (await self.getBetaTestLinkPath() as NSString).strings(byAppendingPaths: age6BetaName)
        if fileAge6BetaManager.fileExists(atPath: age6BetaPath[0]) {
            let age6BetaFilePath = URL(fileURLWithPath: age6BetaPath[0])
            if age6BetaFilePath.isFileURL  {
                age6BetaLinkExists = true
            } else {
                print("age6.csv Does Not Exist")
            }
        }
    }
    
    
    
    func betaGetDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
    }
}
 
extension PostBilateral1kHzTestContent {
//MARK: -CSV/JSON Methods Extenstion
    func betaOnekHzInputResultsCSVReader() async {
        let onekHzSummaryCSVName = [betaInputOnekHzSummaryCSVName]
        let fileOnekHzManager = FileManager.default
        let onekHZPath = (await self.betaGetDataLinkPath() as NSString).strings(byAppendingPaths: onekHzSummaryCSVName)
        if fileOnekHzManager.fileExists(atPath: onekHZPath[0]) {
            let onekHZFilePath = URL(fileURLWithPath: onekHZPath[0])
            if onekHZFilePath.isFileURL  {
                dataFileURL13Beta = onekHZFilePath
                print("onekHZFilePath: \(onekHZFilePath)")
                print("onekHZURL13: \(dataFileURL13Beta)")
                print("onekHZ Input File Exists")
            } else {
                print("onekHZ Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURL13Beta)
            print(results)
            print("onekHZResults Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldOnekHz_averageLowestGainRightArray: String = results[row:2, column: 0]
            let fieldOnekHz_HoldingLowestRightGainArray: String = results[row:3, column: 0]
            let fieldOnekHz_averageLowestGainLeftArray: String = results[row:4, column: 0]
            let fieldOnekHz_HoldingLowestLeftGainArray: String = results[row:5, column: 0]
            
            let fieldOnekHz_averageLowestGainDBRightArray: String = results[row:6, column: 0]
            let fieldOnekHz_averageLowestGainDBLeftArray: String = results[row:8, column: 0]
            
            print("fieldOnekHz_averageLowestGainRightArray: \(fieldOnekHz_averageLowestGainRightArray)")
            print("fieldOnekHz_HoldingLowestRightGainArray: \(fieldOnekHz_HoldingLowestRightGainArray)")
            print("fieldOnekHz_averageLowestGainLeftArray: \(fieldOnekHz_averageLowestGainLeftArray)")
            print("fieldOnekHz_HoldingLowestLeftGainArray: \(fieldOnekHz_HoldingLowestLeftGainArray)")
            print("fieldOnekHz_averageLowestGainDBRightArray: \(fieldOnekHz_averageLowestGainDBRightArray)")
            print("fieldOnekHz_averageLowestGainDBLeftArray: \(fieldOnekHz_averageLowestGainDBLeftArray)")
            
            let inputOnekHz_averageLowestGainRightArry = Float(fieldOnekHz_averageLowestGainRightArray)
            betaInputOnekHz_averageLowestGainRightArray = inputOnekHz_averageLowestGainRightArry ?? -99.9
            
            let inputOnekHz_HoldingLowestRightGainArry = Float(fieldOnekHz_HoldingLowestRightGainArray)
            betaInputOnekHz_HoldingLowestRightGainArray = inputOnekHz_HoldingLowestRightGainArry ?? -99.9
            
            let inputOnekHz_averageLowestGainLeftArry = Float(fieldOnekHz_averageLowestGainLeftArray)
            betaInputOnekHz_averageLowestGainLeftArray = inputOnekHz_averageLowestGainLeftArry ?? -99.9
            
            let inputOnekHz_HoldingLowestLeftGainArry = Float(fieldOnekHz_HoldingLowestLeftGainArray)
            betaInputOnekHz_HoldingLowestLeftGainArray = inputOnekHz_HoldingLowestLeftGainArry ?? -99.9
            
            let inputOnekHz_averageLowestGainDBRightArry = Float(fieldOnekHz_averageLowestGainDBRightArray)
            betaInputOnekHz_averageLowestGainDBRightArray = inputOnekHz_averageLowestGainDBRightArry ?? -99.9
            
            let inputOnekHz_HoldingLowestLeftGainDBArry = Float(fieldOnekHz_averageLowestGainDBLeftArray)
            betaInputOnekHz_averageLowestGainDBLeftArray = inputOnekHz_HoldingLowestLeftGainDBArry ?? -99.9
            
            
            print("inputOnekHz_averageGainRightArray1: \(betaInputOnekHz_averageGainRightArray1)")
            print("inputOnekHz_averageGainRightArray2: \(betaInputOnekHz_averageGainRightArray2)")
            print("inputOnekHz_averageGainRightArray3: \(betaInputOnekHz_averageGainRightArray3)")
            print("inputOnekHz_averageGainRightArray4: \(betaInputOnekHz_averageGainRightArray4)")
            print("inputOnekHz_averageGainLeftArray1: \(betaInputOnekHz_averageGainLeftArray1)")
            print("inputOnekHz_averageGainLeftArray2: \(betaInputOnekHz_averageGainLeftArray2)")
            print("inputOnekHz_averageGainLeftArray3: \(betaInputOnekHz_averageGainLeftArray3)")
            print("inputOnekHz_averageGainLeftArray4: \(betaInputOnekHz_averageGainLeftArray4)")
            print("inputOnekHz_averageLowestGainRightArray: \(betaInputOnekHz_averageLowestGainRightArray)")
            print("inputOnekHz_HoldingLowestRightGainArray: \(betaInputOnekHz_HoldingLowestRightGainArray)")
            print("inputOnekHz_averageLowestGainLeftArray: \(betaInputOnekHz_averageLowestGainLeftArray)")
            print("inputOnekHz_HoldingLowestLeftGainArray: \(betaInputOnekHz_HoldingLowestLeftGainArray)")
            print("betaInputOnekHz_averageLowestGainDBRightArray: \(betaInputOnekHz_averageLowestGainDBRightArray)")
            print("betaInputOnekHz_averageLowestGainDBLeftArray: \(betaInputOnekHz_averageLowestGainDBLeftArray)")
        } catch {
            print("Error in reading onekHZ results")
        }
    }
    
    func writeBetaFinalGainSettingToCSV() async {
        let gainSettingsName = gainLinkName
        print("writeBetaFinalGainSettingToCSV Start")
        do {
            let csvBetaFinalGainSettingPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvBetaFinalGainSettingDocumentsDirectory = csvBetaFinalGainSettingPath
            print("CSV BetaBetaFinalGainSetting DocumentsDirectory: \(csvBetaFinalGainSettingDocumentsDirectory)")
            let csvBetaFinalGainSettingFilePath = csvBetaFinalGainSettingDocumentsDirectory.appendingPathComponent(gainLinkName)
            print(csvBetaFinalGainSettingFilePath)
            let writerSetup = try CSVWriter(fileURL: csvBetaFinalGainSettingFilePath, append: false)
            try writerSetup.write(row: [gainSettingsName])
            print("CVS BetaBetaFinalGainSetting Writer Success")
        } catch {
            print("CVSWriter BetaBetaFinalGainSetting Error or Error Finding File for BetaBetaFinalGainSetting CSV \(error.localizedDescription)")
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
        DispatchQueue.global(qos: .background).async {
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
    
    func comparedLastNameCSVReader() async {
        let dataSetupName = inputFinalComparedLastNameCSV
        let fileSetupManager = FileManager.default
        let dataSetupPath = (await self.getDataLinkPath() as NSString).strings(byAppendingPaths: [dataSetupName])
        if fileSetupManager.fileExists(atPath: dataSetupPath[0]) {
            let dataSetupFilePath = URL(fileURLWithPath: dataSetupPath[0])
            if dataSetupFilePath.isFileURL  {
                dataFileURLComparedLastName = dataSetupFilePath
                print("dataSetupFilePath: \(dataSetupFilePath)")
                print("dataFileURL1: \(dataFileURLComparedLastName)")
                print("Setup Input File Exists")
            } else {
                print("Setup Data File Path Does Not Exist")
            }
        }
        do {
            let results = try CSVReader.decode(input: dataFileURLComparedLastName)
            print(results)
            print("Setup Results Read")
            let rows = results.columns
            print("rows: \(rows)")
            let fieldLastName: String = results[row: 0, column: 0]
            print("fieldLastName: \(fieldLastName)")
            inputLastName = fieldLastName
            print("inputLastName: \(inputLastName)")
        } catch {
            print("Error in reading Last Name results")
        }
    }
}

extension PostBilateral1kHzTestContent {
//MARK: -NavigationLink Extension

    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}

//struct PostBilateral1kHzTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostBilateral1kHzTestView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
