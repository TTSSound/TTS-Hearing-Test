//
//  UserWrittenHearingAssessmentView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//


//1. Does a hearing problem cause you to feel embarrassed when you meet new people?
//2. Does a hearing probelm cause you to feel frustrated when talking to members of your family?
//3. Do you have difficulty hearing / understanding co-workers, clients, or customers?
//4. Do you feel handicapped by a hearing problem?
//5. Does a hearing problem cause you difficulty when visiting friends, relatives or neighbors?
//6. Does a hearing problem cause you difficulty in the movies or in the theater?
//7. Does a hearing problem cause you to have arguments with family members?
//8. Does a hearing problem cause you difficulty when listenting to TV or music?
//9. Do you feel that any difficulty with your hearing limits or hampers your personal or social life?
//10. Does a hearing problem cause you difficulty when in a restaurant with relatives or friends?

import SwiftUI
import CoreData
import CodableCSV
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift


//struct HHISurveryModel: Identifiable, Hashable {
//    let question: String
//    let id = UUID()
//    var isToggled = false
//    init(question: String) {
//        self.question = question
//    }
//}


// What to Append for no response nil..... -1?
// Append Pattern by test question
// question1.append(question1no, question1sometimes, question1yes)

// No responses append pattern
    // noresponse.append(question1no, question2no,....question10no

//final no score final class append to write
// final sometimes score """"
// final yes score """
// final sum score """"


struct UserWrittenHearingAssessmentView<Link: View>: View {
    var testing: Testing?
    var relatedLinkTesting: (Testing) -> Link
    
    var body: some View {
        if let testing = testing {
            UserWrittenHearingAssessmentContent(testing: testing, relatedLinkTesting: relatedLinkTesting)
        } else {
            Text("Error Loading UserWrittenHearingAssessment View")
                .navigationTitle("")
        }
    }
}


struct SaveSurveyAssessmentResults: Codable {  // This is a model
    var jsonFinalQuestion1responses = [Int]()
    var jsonFinalQuestion2responses = [Int]()
    var jsonFinalQuestion3responses = [Int]()
    var jsonFinalQuestion4responses = [Int]()
    var jsonFinalQuestion5responses = [Int]()
    var jsonFinalQuestion6responses = [Int]()
    var jsonFinalQuestion7responses = [Int]()
    var jsonFinalQuestion8responses = [Int]()
    var jsonFinalQuestion9responses = [Int]()
    var jsonFinalQuestion10responses = [Int]()
    var jsonFinalNoResponses = [Int]()
    var jsonFinalSometimesResponses = [Int]()
    var jsonFinalYesResponses = [Int]()
    var jsonFinalSummaryResponseScore = [Int]()
    
    enum CodingKeys: String, CodingKey {
        case jsonFinalQuestion1responses
        case jsonFinalQuestion2responses
        case jsonFinalQuestion3responses
        case jsonFinalQuestion4responses
        case jsonFinalQuestion5responses
        case jsonFinalQuestion6responses
        case jsonFinalQuestion7responses
        case jsonFinalQuestion8responses
        case jsonFinalQuestion9responses
        case jsonFinalQuestion10responses
        case jsonFinalNoResponses
        case jsonFinalSometimesResponses
        case jsonFinalYesResponses
        case jsonFinalSummaryResponseScore
    }
}


struct UserWrittenHearingAssessmentContent<Link: View>: View {
    var testing: Testing
    var dataModel = DataModel.shared
    var relatedLinkTesting: (Testing) -> Link
    @EnvironmentObject private var naviationModel: NavigationModel
    
    var colorModel: ColorModel = ColorModel()
    
    @State private var inputLastName = String()
    @State private var dataFileURLComparedLastName = URL(fileURLWithPath: "")   // General and Open
    @State private var isOkayToUpload = false
    let inputFinalComparedLastNameCSV = "LastNameCSV.csv"
    
    
    @State var noResponses = [Int]()
    @State var sometimesResponses = [Int]()
    @State var yesResponses = [Int]()
    
    
    @State var question1No: Bool = false
    @State var question1Sometimes: Bool = false
    @State var question1Yes: Bool = false
    
    @State var question2No: Bool = false
    @State var question2Sometimes: Bool = false
    @State var question2Yes: Bool = false
    
    @State var question3No: Bool = false
    @State var question3Sometimes: Bool = false
    @State var question3Yes: Bool = false
    
    @State var question4No: Bool = false
    @State var question4Sometimes: Bool = false
    @State var question4Yes: Bool = false
    
    @State var question5No: Bool = false
    @State var question5Sometimes: Bool = false
    @State var question5Yes: Bool = false
    
    @State var question6No: Bool = false
    @State var question6Sometimes: Bool = false
    @State var question6Yes: Bool = false
    
    @State var question7No: Bool = false
    @State var question7Sometimes: Bool = false
    @State var question7Yes: Bool = false
    
    @State var question8No: Bool = false
    @State var question8Sometimes: Bool = false
    @State var question8Yes: Bool = false
    
    @State var question9No: Bool = false
    @State var question9Sometimes: Bool = false
    @State var question9Yes: Bool = false
    
    @State var question10No: Bool = false
    @State var question10Sometimes: Bool = false
    @State var question10Yes: Bool = false
    
    @State var submitSurvey: Bool = false
    @State var surveySubmitted = [0]
    
    @State var continueColor: [Color] = [Color.clear, Color.green, Color.white]
    
    
    @State var hhsiNoResponses = [Int]()
    @State var hhsiSometimesResponses = [Int]()
    @State var hhsiYesResponses = [Int]()
    @State var hhsiScore = [Int]()
    @State var finalQuestion1responses: [Int] = [Int]()
    @State var finalQuestion2responses: [Int] = [Int]()
    @State var finalQuestion3responses: [Int] = [Int]()
    @State var finalQuestion4responses: [Int] = [Int]()
    @State var finalQuestion5responses: [Int] = [Int]()
    @State var finalQuestion6responses: [Int] = [Int]()
    @State var finalQuestion7responses: [Int] = [Int]()
    @State var finalQuestion8responses: [Int] = [Int]()
    @State var finalQuestion9responses: [Int] = [Int]()
    @State var finalQuestion10responses: [Int] = [Int]()
    @State var finalNoResponses: [Int] = [Int]()
    @State var finalSometimesResponses: [Int] = [Int]()
    @State var finalYesResponses: [Int] = [Int]()
    @State var finalSummaryResponseScore: [Int] = [Int]()
    
    let fileSurveyName = ["SurveyResults.json"]
    let surveyCSVName = "SurveyResultsCSV.csv"
    let inputSurveyCSVName = "InputSurveyResultsCSV.csv"
    
    @State var saveSurveyAssessmentResults: SaveSurveyAssessmentResults? = nil
    
    var body: some View {
        ZStack {
            colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack {
                Text("Hearing Self Assessment")
                    .foregroundColor(.white)
                    .font(.title2)
                Divider()
                    .padding()
                    .frame(height: 2.0)
                    .foregroundColor(colorModel.tiffanyBlue)
                    .background(colorModel.tiffanyBlue)
                ScrollView {
                    VStack{
                        Text ("1. Does a hearing problem cause you to feel embarrassed when you meet new people?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question1No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question1No) { q1No in
                                    if q1No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question1Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question1Sometimes) { q1Sometimes in
                                    if q1Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question1Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question1Yes) { q1Yes in
                                    if q1Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.tiffanyBlue)
                    VStack{
                        Text ("2. Does a hearing probelm cause you to feel frustrated when talking to members of your family?")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question2No)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question2No) { q2No in
                                    if q2No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question2Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .font(.caption)
                                .onChange(of: question2Sometimes) { q2Sometimes in
                                    if q2Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question2Yes)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question2Yes) { q2Yes in
                                    if q2Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.limeGreen)
                    
                    VStack{
                        Text ("3. Do you have difficulty hearing / understanding co-workers, clients, or customers?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question3No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question3No) { q3No in
                                    if q3No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question3Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question3Sometimes) { q3Sometimes in
                                    if q3Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question3Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question3Yes) { q3Yes in
                                    if q3Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.tiffanyBlue)
                    VStack{
                        Text ("4. Do you feel handicapped by a hearing problem?")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question4No)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question4No) { q4No in
                                    if q4No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question4Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .font(.caption)
                                .onChange(of: question4Sometimes) { q4Sometimes in
                                    if q4Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question4Yes)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question4Yes) { q4Yes in
                                    if q4Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.limeGreen)
                    VStack{
                        Text ("5. Does a hearing problem cause you difficulty when visiting friends, relatives or neighbors?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question5No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question5No) { q5No in
                                    if q5No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question5Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question5Sometimes) { q5Sometimes in
                                    if q5Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question5Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question5Yes) { q5Yes in
                                    if q5Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.tiffanyBlue)
                    VStack{
                        Text ("6. Does a hearing problem cause you difficulty in the movies or in the theater?")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question6No)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question6No) { q6No in
                                    if q6No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question6Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .font(.caption)
                                .onChange(of: question6Sometimes) { q6Sometimes in
                                    if q6Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question6Yes)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question6Yes) { q6Yes in
                                    if q6Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.limeGreen)
                    VStack{
                        Text ("7. Does a hearing problem cause you to have arguments with family members?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question7No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question7No) { q7No in
                                    if q7No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question7Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question7Sometimes) { q7Sometimes in
                                    if q7Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question7Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question7Yes) { q7Yes in
                                    if q7Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.tiffanyBlue)
                    VStack{
                        Text ("8. Does a hearing problem cause you difficulty when listenting to TV or music?")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question8No)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question8No) { q8No in
                                    if q8No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question8Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.black)
                                .font(.caption)
                                .onChange(of: question8Sometimes) { q8Sometimes in
                                    if q8Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question8Yes)
                                .foregroundColor(.black)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question8Yes) { q8Yes in
                                    if q8Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.limeGreen)
                    VStack{
                        Text ("9. Do you feel that any difficulty with your hearing limits or hampers your personal or social life?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question9No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question9No) { q9No in
                                    if q9No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question9Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question9Sometimes) { q9Sometimes in
                                    if q9Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question9Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question9Yes) { q9Yes in
                                    if q9Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                    }
                    .padding(.bottom)
                    .background(colorModel.tiffanyBlue)
                    VStack{
                        Text ("10. Does a hearing problem cause you difficulty when in a restaurant with relatives or friends?")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top)
                        HStack{
                            Toggle("No", isOn: self.$question10No)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                                .onChange(of: question10No) { q10No in
                                    if q10No == true {
                                        noResponses.append(0)
                                    }
                                }
                            Toggle("Sometimes", isOn: $question10Sometimes)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .font(.caption)
                                .onChange(of: question10Sometimes) { q10Sometimes in
                                    if q10Sometimes == true {
                                        sometimesResponses.append(2)
                                    }
                                }
                            Toggle("Yes", isOn: $question10Yes)
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.trailing)
                                .onChange(of: question10Yes) { q10Yes in
                                    if q10Yes == true {
                                        yesResponses.append(4)
                                    }
                                }
                        }
                        VStack{
                            Spacer()
                            Text("SUBMIT SURVEY RESPONSES?")
                                .font(.headline)
                                .foregroundColor(.green)
                            HStack{
                                Toggle("Yes, Submit", isOn: $submitSurvey)
                                    .foregroundColor(.green)
                                    .font(.headline)
                                    .padding(.horizontal, 100.0)
                                    .onChange(of: submitSurvey) { surveyValue in
                                        if surveyValue == true {
                                            surveySubmitted.replaceSubrange(0..<1, with: [1])
                                        }
                                    }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom)
                        .background(.black)
                        .onChange(of: submitSurvey) { _ in
                            Task(priority: .userInitiated, operation: {
                                await calculateSurveryResponses()
                                await finalQuestion1Array()
                                await finalQuestion2Array()
                                await finalQuestion3Array()
                                await finalQuestion4Array()
                                await finalQuestion5Array()
                                await finalQuestion6Array()
                                await finalQuestion7Array()
                                await finalQuestion8Array()
                                await finalQuestion9Array()
                                await finalQuestion10Array()
                                await concantenateFinalSurveyResponseArrays()
                                await saveWrittenHearingTest()
                            })
                        }
                        .onChange(of: isOkayToUpload) { uploadValue in
                            if uploadValue == true {
                                await uploadSurveyDataEntry()
                            } else {
                                print("Fatal error in uploadvalue change of logic")
                            }
                        }
                    }
                    .padding(.bottom)
                    .background(.black)
                }
                Divider()
                    .padding()
                    .frame(height: 2.0)
                    .foregroundColor(colorModel.tiffanyBlue)
                    .background(colorModel.tiffanyBlue)
                if surveySubmitted == [1] {
                    NavigationLink(destination:
                                    surveySubmitted.first == 1 ? AnyView(PreTestView(testing: testing, relatedLinkTesting: linkTesting))
                                   : surveySubmitted.first != 1 ? AnyView(SurveyErrorView(testing: testing, relatedLinkTesting: linkTesting))
                                   : AnyView(TestIDInputView(testing: testing, relatedLinkTesting: linkTesting))
                    ){
                        Text("Press to Contine!")
                            .frame(width: 300, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(24)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
            .onAppear(perform: {
                Task {
                    await comparedLastNameCSVReader()
                }
            })
            .padding(.bottom, 40)
        }
    }
}
 
extension UserWrittenHearingAssessmentContent {
//MARK: -Extension Methods
    func calculateSurveryResponses() async {
        let noSum = noResponses.reduce(0, +)
        let sometimesSum = sometimesResponses.reduce(0,+)
        let yesSum = yesResponses.reduce(0,+)
        let score = noSum + sometimesSum + yesSum
        hhsiNoResponses.append(contentsOf: noResponses)
        hhsiSometimesResponses.append(contentsOf: sometimesResponses)
        hhsiYesResponses.append(contentsOf: yesResponses)
        hhsiScore.append(score)
        print("noResponses: \(noResponses)")
        print("sometimesResponses: \(sometimesResponses)")
        print("yesResponses: \(yesResponses)")
        print("setupModel NoResponses: \(hhsiNoResponses)")
        print("setupModel SometimesResponses: \(hhsiSometimesResponses)")
        print("setupModel YesResponses: \(hhsiYesResponses)")
        print("noSum: \(noSum) sometimesSum: \(sometimesSum) yesSum: \(yesSum)")
        print("hhsi Score: \(score)")
    }
    
    func finalQuestion1Array() async {
        //Question 1 Responses
        if question1No == false {
            finalQuestion1responses.append(-1)
        } else if question1No == true {
            finalQuestion1responses.append(0)
        } else {
            print("Error in question1No Logic")
        }
        if question1Sometimes == false {
            finalQuestion1responses.append(0)
        } else if question1Sometimes == true {
            finalQuestion1responses.append(2)
        } else {
            print("Error in question1Sometimes Logic")
        }
        if question1Yes == false {
            finalQuestion1responses.append(0)
        } else if question1Yes == true {
            finalQuestion1responses.append(4)
        } else {
            print("Error in question1Yes Logic")
        }
    }
    
    func finalQuestion2Array() async {
        //Question 2 Responses
        if question2No == false {
            finalQuestion2responses.append(-1)
        } else if question2No == true {
            finalQuestion2responses.append(0)
        } else {
            print("Error in question2No Logic")
        }
        if question2Sometimes == false {
            finalQuestion2responses.append(0)
        } else if question2Sometimes == true {
            finalQuestion2responses.append(2)
        } else {
            print("Error in question2Sometimes Logic")
        }
        if question2Yes == false {
            finalQuestion2responses.append(0)
        } else if question2Yes == true {
            finalQuestion2responses.append(4)
        } else {
            print("Error in questio2Yes Logic")
        }
    }
    
    func finalQuestion3Array() async {
        //Question 3 Responses
        if question3No == false {
            finalQuestion3responses.append(-1)
        } else if question3No == true {
            finalQuestion3responses.append(0)
        } else {
            print("Error in question3No Logic")
        }
        if question3Sometimes == false {
            finalQuestion3responses.append(0)
        } else if question3Sometimes == true {
            finalQuestion3responses.append(2)
        } else {
            print("Error in question3Sometimes Logic")
        }
        if question3Yes == false {
            finalQuestion3responses.append(0)
        } else if question3Yes == true {
            finalQuestion3responses.append(4)
        } else {
            print("Error in questio3Yes Logic")
        }
    }
    
    func finalQuestion4Array() async {
        //Question 4 Responses
        if question4No == false {
            finalQuestion4responses.append(-1)
        } else if question4No == true {
            finalQuestion4responses.append(0)
        } else {
            print("Error in question4No Logic")
        }
        if question4Sometimes == false {
            finalQuestion4responses.append(0)
        } else if question4Sometimes == true {
            finalQuestion4responses.append(2)
        } else {
            print("Error in question4Sometimes Logic")
        }
        if question4Yes == false {
            finalQuestion4responses.append(0)
        } else if question4Yes == true {
            finalQuestion4responses.append(4)
        } else {
            print("Error in questio4Yes Logic")
        }
    }
    
    func finalQuestion5Array() async {
        //Question 5 Responses
        if question5No == false {
            finalQuestion5responses.append(-1)
        } else if question5No == true {
            finalQuestion5responses.append(0)
        } else {
            print("Error in question5No Logic")
        }
        if question5Sometimes == false {
            finalQuestion5responses.append(0)
        } else if question5Sometimes == true {
            finalQuestion5responses.append(2)
        } else {
            print("Error in question5Sometimes Logic")
        }
        if question5Yes == false {
            finalQuestion5responses.append(0)
        } else if question5Yes == true {
            finalQuestion5responses.append(4)
        } else {
            print("Error in questio5Yes Logic")
        }
    }
    
    func finalQuestion6Array() async {
        //Question 6 Responses
        if question6No == false {
            finalQuestion6responses.append(-1)
        } else if question6No == true {
            finalQuestion6responses.append(0)
        } else {
            print("Error in question6No Logic")
        }
        if question6Sometimes == false {
            finalQuestion6responses.append(0)
        } else if question6Sometimes == true {
            finalQuestion6responses.append(2)
        } else {
            print("Error in question6Sometimes Logic")
        }
        if question6Yes == false {
            finalQuestion6responses.append(0)
        } else if question6Yes == true {
            finalQuestion6responses.append(4)
        } else {
            print("Error in questio6Yes Logic")
        }
    }
    
    func finalQuestion7Array() async {
        //Question 7 Responses
        if question7No == false {
            finalQuestion7responses.append(-1)
        } else if question7No == true {
            finalQuestion7responses.append(0)
        } else {
            print("Error in question7No Logic")
        }
        if question7Sometimes == false {
            finalQuestion7responses.append(0)
        } else if question7Sometimes == true {
            finalQuestion7responses.append(2)
        } else {
            print("Error in question7Sometimes Logic")
        }
        if question7Yes == false {
            finalQuestion7responses.append(0)
        } else if question7Yes == true {
            finalQuestion7responses.append(4)
        } else {
            print("Error in questio7Yes Logic")
        }
    }
    
    func finalQuestion8Array() async {
        //Question 8 Responses
        if question8No == false {
            finalQuestion8responses.append(-1)
        } else if question8No == true {
            finalQuestion8responses.append(0)
        } else {
            print("Error in question8No Logic")
        }
        if question8Sometimes == false {
            finalQuestion8responses.append(0)
        } else if question8Sometimes == true {
            finalQuestion8responses.append(2)
        } else {
            print("Error in question8Sometimes Logic")
        }
        if question8Yes == false {
            finalQuestion8responses.append(0)
        } else if question8Yes == true {
            finalQuestion8responses.append(4)
        } else {
            print("Error in questio8Yes Logic")
        }
    }
    
    func finalQuestion9Array() async {
        //Question 9 Responses
        if question9No == false {
            finalQuestion9responses.append(-1)
        } else if question9No == true {
            finalQuestion9responses.append(0)
        } else {
            print("Error in question9No Logic")
        }
        if question9Sometimes == false {
            finalQuestion9responses.append(0)
        } else if question9Sometimes == true {
            finalQuestion9responses.append(2)
        } else {
            print("Error in question9Sometimes Logic")
        }
        if question9Yes == false {
            finalQuestion9responses.append(0)
        } else if question9Yes == true {
            finalQuestion9responses.append(4)
        } else {
            print("Error in questio9Yes Logic")
        }
    }
    
    func finalQuestion10Array() async {
        //Question 10 Responses
        if question10No == false {
            finalQuestion10responses.append(-1)
        } else if question10No == true {
            finalQuestion10responses.append(0)
        } else {
            print("Error in question10No Logic")
        }
        if question10Sometimes == false {
            finalQuestion10responses.append(0)
        } else if question10Sometimes == true {
            finalQuestion10responses.append(2)
        } else {
            print("Error in question10Sometimes Logic")
        }
        if question10Yes == false {
            finalQuestion10responses.append(0)
        } else if question10Yes == true {
            finalQuestion10responses.append(4)
        } else {
            print("Error in questio10Yes Logic")
        }
    }
    
    func concantenateFinalSurveyResponseArrays() async {
        // Summary HHSI Score
        finalSummaryResponseScore.append(contentsOf: hhsiScore)
        //Final No Responses
        finalNoResponses.append(finalQuestion1responses[0])
        finalNoResponses.append(finalQuestion2responses[0])
        finalNoResponses.append(finalQuestion3responses[0])
        finalNoResponses.append(finalQuestion4responses[0])
        finalNoResponses.append(finalQuestion5responses[0])
        finalNoResponses.append(finalQuestion6responses[0])
        finalNoResponses.append(finalQuestion7responses[0])
        finalNoResponses.append(finalQuestion8responses[0])
        finalNoResponses.append(finalQuestion9responses[0])
        finalNoResponses.append(finalQuestion10responses[0])
        // Final Sometimes Responses
        finalSometimesResponses.append(finalQuestion1responses[1])
        finalSometimesResponses.append(finalQuestion2responses[1])
        finalSometimesResponses.append(finalQuestion3responses[1])
        finalSometimesResponses.append(finalQuestion4responses[1])
        finalSometimesResponses.append(finalQuestion5responses[1])
        finalSometimesResponses.append(finalQuestion6responses[1])
        finalSometimesResponses.append(finalQuestion7responses[1])
        finalSometimesResponses.append(finalQuestion8responses[1])
        finalSometimesResponses.append(finalQuestion9responses[1])
        finalSometimesResponses.append(finalQuestion10responses[1])
        //Final Yes Responses
        finalYesResponses.append(finalQuestion1responses[2])
        finalYesResponses.append(finalQuestion2responses[2])
        finalYesResponses.append(finalQuestion3responses[2])
        finalYesResponses.append(finalQuestion4responses[2])
        finalYesResponses.append(finalQuestion4responses[2])
        finalYesResponses.append(finalQuestion6responses[2])
        finalYesResponses.append(finalQuestion7responses[2])
        finalYesResponses.append(finalQuestion8responses[2])
        finalYesResponses.append(finalQuestion9responses[2])
        finalYesResponses.append(finalQuestion10responses[2])
        print("finalSummaryResponseScore: \(finalSummaryResponseScore)")
        print("finalNoResponseArray: \(finalNoResponses)")
        print("finalSometimesResponseArray: \(finalSometimesResponses)")
        print("finalYesResponseArray: \(finalYesResponses)")
    }
    
    func saveWrittenHearingTest() async {
        await getSurveyData()
        await saveSurveyToJSON()
        await writeSurveyResultsToCSV()
        await writeInputSurveyResultsToCSV()
        isOkayToUpload = true
    }
    
    func uploadSurveyDataEntry() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, qos: .background) {
            uploadFile(fileName: surveyCSVName)
            uploadFile(fileName: inputSurveyCSVName)
            uploadFile(fileName: "SurveyResults.json")
        }
    }
}

extension UserWrittenHearingAssessmentContent {
    //MARK: -Extension CSV/JSON Methods
    func getSurveyData() async {
        DispatchQueue.main.async {
            Task {
                guard let surveyData = await self.getSurveyJSONData() else { return }
                print("Json Survey Data:")
                print(surveyData)
                let jsonSurveyString = String(data: surveyData, encoding: .utf8)
                print(jsonSurveyString!)
                do {
                    self.saveSurveyAssessmentResults = try JSONDecoder().decode(SaveSurveyAssessmentResults.self, from: surveyData)
                    print("JSON Get Survey Data Run")
                    print("data: \(surveyData)")
                } catch let error {
                    print("!!!Error decoding survey json data: \(error)")
                }
            }
        }
    }
    
    func getSurveyJSONData() async -> Data? {
        let saveSurveyAssessmentResults = SaveSurveyAssessmentResults (
            jsonFinalQuestion1responses: finalQuestion1responses,
            jsonFinalQuestion2responses: finalQuestion2responses,
            jsonFinalQuestion3responses: finalQuestion3responses,
            jsonFinalQuestion4responses: finalQuestion4responses,
            jsonFinalQuestion5responses: finalQuestion5responses,
            jsonFinalQuestion6responses: finalQuestion6responses,
            jsonFinalQuestion7responses: finalQuestion7responses,
            jsonFinalQuestion8responses: finalQuestion8responses,
            jsonFinalQuestion9responses: finalQuestion9responses,
            jsonFinalQuestion10responses: finalQuestion10responses,
            jsonFinalNoResponses: finalNoResponses,
            jsonFinalSometimesResponses: finalSometimesResponses,
            jsonFinalYesResponses: finalYesResponses,
            jsonFinalSummaryResponseScore: finalSummaryResponseScore)
        let jsonSurveyData = try? JSONEncoder().encode(saveSurveyAssessmentResults)
        print("saveSurveyResults: \(saveSurveyAssessmentResults)")
        print("Json Encoded \(jsonSurveyData!)")
        return jsonSurveyData
    }
    
    
    func saveSurveyToJSON() async {
        // !!!This saves to device directory, whish is likely what is desired
        let surveyPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = surveyPaths[0]
        print("DocumentsDirectory: \(documentsDirectory)")
        let surveyFilePaths = documentsDirectory.appendingPathComponent(fileSurveyName[0])
        print(surveyFilePaths)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonSurveyData = try encoder.encode(saveSurveyAssessmentResults)
            print(jsonSurveyData)
            
            try jsonSurveyData.write(to: surveyFilePaths)
        } catch {
            print("Error writing to JSON Survey file: \(error)")
        }
    }
    
    func writeSurveyResultsToCSV() async {
        print("writeSurveyResultsToCSV Start")
        let stringFinalQuestion1responses = "finalQuestion1responses," + finalQuestion1responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion2responses = "finalQuestion2responses," + finalQuestion2responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion3responses = "finalQuestion3responses," + finalQuestion3responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion4responses = "finalQuestion4responses," + finalQuestion4responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion5responses = "finalQuestion5responses," + finalQuestion5responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion6responses = "finalQuestion6responses," + finalQuestion6responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion7responses = "finalQuestion7responses," + finalQuestion7responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion8responses = "finalQuestion8responses," + finalQuestion8responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion9responses = "finalQuestion9responses," + finalQuestion9responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion10responses = "finalQuestion10responses," + finalQuestion10responses.map { String($0) }.joined(separator: ",")
        let stringFinalNoResponses = "finalNoResponses," + finalNoResponses.map { String($0) }.joined(separator: ",")
        let stringFinalSometimesResponses = "finalSometimesResponses," + finalSometimesResponses.map { String($0) }.joined(separator: ",")
        let stringFinalYesResponses = "finalYesResponses," + finalYesResponses.map { String($0) }.joined(separator: ",")
        let stringFinalSummaryResponseScore = "finalSummaryResponseScore," + finalSummaryResponseScore.map { String($0) }.joined(separator: ",")
        do {
            let csvSurveyPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvSurveyDocumentsDirectory = csvSurveyPath
            print("CSV Survey DocumentsDirectory: \(csvSurveyDocumentsDirectory)")
            let csvSurveyFilePath = csvSurveyDocumentsDirectory.appendingPathComponent(surveyCSVName)
            print(csvSurveyFilePath)
            let writerSetup = try CSVWriter(fileURL: csvSurveyFilePath, append: false)
            try writerSetup.write(row: [stringFinalQuestion1responses])
            try writerSetup.write(row: [stringFinalQuestion2responses])
            try writerSetup.write(row: [stringFinalQuestion3responses])
            try writerSetup.write(row: [stringFinalQuestion4responses])
            try writerSetup.write(row: [stringFinalQuestion5responses])
            try writerSetup.write(row: [stringFinalQuestion6responses])
            try writerSetup.write(row: [stringFinalQuestion7responses])
            try writerSetup.write(row: [stringFinalQuestion8responses])
            try writerSetup.write(row: [stringFinalQuestion9responses])
            try writerSetup.write(row: [stringFinalQuestion10responses])
            try writerSetup.write(row: [stringFinalNoResponses])
            try writerSetup.write(row: [stringFinalSometimesResponses])
            try writerSetup.write(row: [stringFinalYesResponses])
            try writerSetup.write(row: [stringFinalSummaryResponseScore])
            print("CVS Survey Writer Success")
        } catch {
            print("CVSWriter Survey Error or Error Finding File for Survey CSV \(error.localizedDescription)")
        }
    }
    
    func writeInputSurveyResultsToCSV() async {
        print("writeInputSurveyResultsToCSV Start")
        let stringFinalQuestion1responses = finalQuestion1responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion2responses = finalQuestion2responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion3responses = finalQuestion3responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion4responses = finalQuestion4responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion5responses = finalQuestion5responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion6responses = finalQuestion6responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion7responses = finalQuestion7responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion8responses = finalQuestion8responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion9responses = finalQuestion9responses.map { String($0) }.joined(separator: ",")
        let stringFinalQuestion10responses = finalQuestion10responses.map { String($0) }.joined(separator: ",")
        let stringFinalNoResponses = finalNoResponses.map { String($0) }.joined(separator: ",")
        let stringFinalSometimesResponses = finalSometimesResponses.map { String($0) }.joined(separator: ",")
        let stringFinalYesResponses = finalYesResponses.map { String($0) }.joined(separator: ",")
        let stringFinalSummaryResponseScore = finalSummaryResponseScore.map { String($0) }.joined(separator: ",")
        do {
            let csvInputSurveyPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let csvInputSurveyDocumentsDirectory = csvInputSurveyPath
            print("CSV Input Survey DocumentsDirectory: \(csvInputSurveyDocumentsDirectory)")
            let csvInputSurveyFilePath = csvInputSurveyDocumentsDirectory.appendingPathComponent(inputSurveyCSVName)
            print(csvInputSurveyFilePath)
            let writerSetup = try CSVWriter(fileURL: csvInputSurveyFilePath, append: false)
            try writerSetup.write(row: [stringFinalQuestion1responses])
            try writerSetup.write(row: [stringFinalQuestion2responses])
            try writerSetup.write(row: [stringFinalQuestion3responses])
            try writerSetup.write(row: [stringFinalQuestion4responses])
            try writerSetup.write(row: [stringFinalQuestion5responses])
            try writerSetup.write(row: [stringFinalQuestion6responses])
            try writerSetup.write(row: [stringFinalQuestion7responses])
            try writerSetup.write(row: [stringFinalQuestion8responses])
            try writerSetup.write(row: [stringFinalQuestion9responses])
            try writerSetup.write(row: [stringFinalQuestion10responses])
            try writerSetup.write(row: [stringFinalNoResponses])
            try writerSetup.write(row: [stringFinalSometimesResponses])
            try writerSetup.write(row: [stringFinalYesResponses])
            try writerSetup.write(row: [stringFinalSummaryResponseScore])
            print("CVS Input Survey Writer Success")
        } catch {
            print("CVSWriter Input Survey Error or Error Finding File for Input Survey CSV \(error.localizedDescription)")
        }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getDataLinkPath() async -> String {
        let dataLinkPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = dataLinkPaths[0]
        return documentsDirectory
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

extension UserWrittenHearingAssessmentContent {
//MARK: -NavigationLink Extension
    private func linkTesting(testing: Testing) -> some View {
        EmptyView()
    }
}


//struct UserWrittenHearingAssessmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserWrittenHearingAssessmentView(testing: nil, relatedLinkTesting: linkTesting)
//    }
//
//    static func linkTesting(testing: Testing) -> some View {
//        EmptyView()
//    }
//}
