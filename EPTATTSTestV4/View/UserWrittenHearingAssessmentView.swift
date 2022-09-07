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

struct UserWrittenHearingAssessmentView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @StateObject var surveyAssessmentModel: SurveyAssessmentModel = SurveyAssessmentModel()
    
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
    
    @State var continueColor: [Color] = [Color.clear, Color.green]

    var body: some View {
        ZStack {
            colorModel.colorBackgroundTopDarkNeonGreen.ignoresSafeArea(.all, edges: .top)
            VStack {
            Text("Hearing Self Assessment")
                    .foregroundColor(.white)
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
                        
                    }
                    .padding(.bottom)
                    .background(.black)
       
                
                }
                Divider()
                    .padding()
                    .frame(height: 2.0)
                    .foregroundColor(colorModel.tiffanyBlue)
                    .background(colorModel.tiffanyBlue)
                    

                NavigationLink(destination:
                                surveySubmitted.first == 1 ? AnyView(PreTestView())
                               : surveySubmitted.first != 1 ? AnyView(SurveyErrorView())
                               : AnyView(InstructionsForTakingTest())
                ){
                    Text("Press to Contine!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(continueColor[surveySubmitted[0]])
                        .padding()
                }
              
            }
        }
        .environmentObject(surveyAssessmentModel)
    }
    
    func calculateSurveryResponses() async {
        let noSum = noResponses.reduce(0, +)
        let sometimesSum = sometimesResponses.reduce(0,+)
        let yesSum = yesResponses.reduce(0,+)
        let score = noSum + sometimesSum + yesSum
        surveyAssessmentModel.hhsiNoResponses.append(contentsOf: noResponses)
        surveyAssessmentModel.hhsiSometimesResponses.append(contentsOf: sometimesResponses)
        surveyAssessmentModel.hhsiYesResponses.append(contentsOf: yesResponses)
        surveyAssessmentModel.hhsiScore.append(score)
        
       
        
        print("noResponses: \(noResponses)")
        print("sometimesResponses: \(sometimesResponses)")
        print("yesResponses: \(yesResponses)")
        print("setupModel NoResponses: \(surveyAssessmentModel.hhsiNoResponses)")
        print("setupModel SometimesResponses: \(surveyAssessmentModel.hhsiSometimesResponses)")
        print("setupModel YesResponses: \(surveyAssessmentModel.hhsiYesResponses)")
        print("noSum: \(noSum) sometimesSum: \(sometimesSum) yesSum: \(yesSum)")
        print("hhsi Score: \(score)")
    }
    
    
    func finalQuestion1Array() async {
        //Question 1 Responses
        if question1No == false {
            surveyAssessmentModel.finalQuestion1responses.append(-1)
        } else if question1No == true {
            surveyAssessmentModel.finalQuestion1responses.append(0)
        } else {
            print("Error in question1No Logic")
        }
        if question1Sometimes == false {
            surveyAssessmentModel.finalQuestion1responses.append(0)
        } else if question1Sometimes == true {
            surveyAssessmentModel.finalQuestion1responses.append(2)
        } else {
            print("Error in question1Sometimes Logic")
        }
        if question1Yes == false {
            surveyAssessmentModel.finalQuestion1responses.append(0)
        } else if question1Yes == true {
            surveyAssessmentModel.finalQuestion1responses.append(4)
        } else {
            print("Error in question1Yes Logic")
        }
    }
    
    func finalQuestion2Array() async {
        //Question 2 Responses
        if question2No == false {
            surveyAssessmentModel.finalQuestion2responses.append(-1)
        } else if question2No == true {
            surveyAssessmentModel.finalQuestion2responses.append(0)
        } else {
            print("Error in question2No Logic")
        }
        if question2Sometimes == false {
            surveyAssessmentModel.finalQuestion2responses.append(0)
        } else if question2Sometimes == true {
            surveyAssessmentModel.finalQuestion2responses.append(2)
        } else {
            print("Error in question2Sometimes Logic")
        }
        if question2Yes == false {
            surveyAssessmentModel.finalQuestion2responses.append(0)
        } else if question2Yes == true {
            surveyAssessmentModel.finalQuestion2responses.append(4)
        } else {
            print("Error in questio2Yes Logic")
        }
    }
    
    func finalQuestion3Array() async {
        //Question 3 Responses
        if question3No == false {
            surveyAssessmentModel.finalQuestion3responses.append(-1)
        } else if question3No == true {
            surveyAssessmentModel.finalQuestion3responses.append(0)
        } else {
            print("Error in question3No Logic")
        }
        if question3Sometimes == false {
            surveyAssessmentModel.finalQuestion3responses.append(0)
        } else if question3Sometimes == true {
            surveyAssessmentModel.finalQuestion3responses.append(2)
        } else {
            print("Error in question3Sometimes Logic")
        }
        if question3Yes == false {
            surveyAssessmentModel.finalQuestion3responses.append(0)
        } else if question3Yes == true {
            surveyAssessmentModel.finalQuestion3responses.append(4)
        } else {
            print("Error in questio3Yes Logic")
        }
    }
    
    func finalQuestion4Array() async {
        //Question 4 Responses
        if question4No == false {
            surveyAssessmentModel.finalQuestion4responses.append(-1)
        } else if question4No == true {
            surveyAssessmentModel.finalQuestion4responses.append(0)
        } else {
            print("Error in question4No Logic")
        }
        if question4Sometimes == false {
            surveyAssessmentModel.finalQuestion4responses.append(0)
        } else if question4Sometimes == true {
            surveyAssessmentModel.finalQuestion4responses.append(2)
        } else {
            print("Error in question4Sometimes Logic")
        }
        if question4Yes == false {
            surveyAssessmentModel.finalQuestion4responses.append(0)
        } else if question4Yes == true {
            surveyAssessmentModel.finalQuestion4responses.append(4)
        } else {
            print("Error in questio4Yes Logic")
        }
    }
    
    func finalQuestion5Array() async {
        //Question 5 Responses
        if question5No == false {
            surveyAssessmentModel.finalQuestion5responses.append(-1)
        } else if question5No == true {
            surveyAssessmentModel.finalQuestion5responses.append(0)
        } else {
            print("Error in question5No Logic")
        }
        if question5Sometimes == false {
            surveyAssessmentModel.finalQuestion5responses.append(0)
        } else if question5Sometimes == true {
            surveyAssessmentModel.finalQuestion5responses.append(2)
        } else {
            print("Error in question5Sometimes Logic")
        }
        if question5Yes == false {
            surveyAssessmentModel.finalQuestion5responses.append(0)
        } else if question5Yes == true {
            surveyAssessmentModel.finalQuestion5responses.append(4)
        } else {
            print("Error in questio5Yes Logic")
        }
    }
    
    
    func finalQuestion6Array() async {
        //Question 6 Responses
        if question6No == false {
            surveyAssessmentModel.finalQuestion6responses.append(-1)
        } else if question6No == true {
            surveyAssessmentModel.finalQuestion6responses.append(0)
        } else {
            print("Error in question6No Logic")
        }
        if question6Sometimes == false {
            surveyAssessmentModel.finalQuestion6responses.append(0)
        } else if question6Sometimes == true {
            surveyAssessmentModel.finalQuestion6responses.append(2)
        } else {
            print("Error in question6Sometimes Logic")
        }
        if question6Yes == false {
            surveyAssessmentModel.finalQuestion6responses.append(0)
        } else if question6Yes == true {
            surveyAssessmentModel.finalQuestion6responses.append(4)
        } else {
            print("Error in questio6Yes Logic")
        }
    }
    
    func finalQuestion7Array() async {
        //Question 7 Responses
        if question7No == false {
            surveyAssessmentModel.finalQuestion7responses.append(-1)
        } else if question7No == true {
            surveyAssessmentModel.finalQuestion7responses.append(0)
        } else {
            print("Error in question7No Logic")
        }
        if question7Sometimes == false {
            surveyAssessmentModel.finalQuestion7responses.append(0)
        } else if question7Sometimes == true {
            surveyAssessmentModel.finalQuestion7responses.append(2)
        } else {
            print("Error in question7Sometimes Logic")
        }
        if question7Yes == false {
            surveyAssessmentModel.finalQuestion7responses.append(0)
        } else if question7Yes == true {
            surveyAssessmentModel.finalQuestion7responses.append(4)
        } else {
            print("Error in questio7Yes Logic")
        }
    }
    
    
    func finalQuestion8Array() async {
        //Question 8 Responses
        if question8No == false {
            surveyAssessmentModel.finalQuestion8responses.append(-1)
        } else if question8No == true {
            surveyAssessmentModel.finalQuestion8responses.append(0)
        } else {
            print("Error in question8No Logic")
        }
        if question8Sometimes == false {
            surveyAssessmentModel.finalQuestion8responses.append(0)
        } else if question8Sometimes == true {
            surveyAssessmentModel.finalQuestion8responses.append(2)
        } else {
            print("Error in question8Sometimes Logic")
        }
        if question8Yes == false {
            surveyAssessmentModel.finalQuestion8responses.append(0)
        } else if question8Yes == true {
            surveyAssessmentModel.finalQuestion8responses.append(4)
        } else {
            print("Error in questio8Yes Logic")
        }
    }
    
    
    func finalQuestion9Array() async {
        //Question 9 Responses
        if question9No == false {
            surveyAssessmentModel.finalQuestion9responses.append(-1)
        } else if question9No == true {
            surveyAssessmentModel.finalQuestion9responses.append(0)
        } else {
            print("Error in question9No Logic")
        }
        if question9Sometimes == false {
            surveyAssessmentModel.finalQuestion9responses.append(0)
        } else if question9Sometimes == true {
            surveyAssessmentModel.finalQuestion9responses.append(2)
        } else {
            print("Error in question9Sometimes Logic")
        }
        if question9Yes == false {
            surveyAssessmentModel.finalQuestion9responses.append(0)
        } else if question9Yes == true {
            surveyAssessmentModel.finalQuestion9responses.append(4)
        } else {
            print("Error in questio9Yes Logic")
        }
    }
     
    
    func finalQuestion10Array() async {
        //Question 10 Responses
        if question10No == false {
            surveyAssessmentModel.finalQuestion10responses.append(-1)
        } else if question10No == true {
            surveyAssessmentModel.finalQuestion10responses.append(0)
        } else {
            print("Error in question10No Logic")
        }
        if question10Sometimes == false {
            surveyAssessmentModel.finalQuestion10responses.append(0)
        } else if question10Sometimes == true {
            surveyAssessmentModel.finalQuestion10responses.append(2)
        } else {
            print("Error in question10Sometimes Logic")
        }
        if question10Yes == false {
            surveyAssessmentModel.finalQuestion10responses.append(0)
        } else if question10Yes == true {
            surveyAssessmentModel.finalQuestion10responses.append(4)
        } else {
            print("Error in questio10Yes Logic")
        }
    }
    
    func concantenateFinalSurveyResponseArrays() async {
        // Summary HHSI Score
        surveyAssessmentModel.finalSummaryResponseScore.append(contentsOf: surveyAssessmentModel.hhsiScore)
        
        //Final No Responses
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion1responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion2responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion3responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion4responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion5responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion6responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion7responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion8responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion9responses[0])
        surveyAssessmentModel.finalNoResponses.append(surveyAssessmentModel.finalQuestion10responses[0])
    
        // Final Sometimes Responses
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion1responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion2responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion3responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion4responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion5responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion6responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion7responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion8responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion9responses[1])
        surveyAssessmentModel.finalSometimesResponses.append(surveyAssessmentModel.finalQuestion10responses[1])
        
        //Final Yes Responses
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion1responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion2responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion3responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion4responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion4responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion6responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion7responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion8responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion9responses[2])
        surveyAssessmentModel.finalYesResponses.append(surveyAssessmentModel.finalQuestion10responses[2])
        
        print("surveyAssessmentModel finalSummaryResponseScore: \(surveyAssessmentModel.finalSummaryResponseScore)")
        print("surveyAssessmentModel finalNoResponseArray: \(surveyAssessmentModel.finalNoResponses)")
        print("surveyAssessmentModel finalSometimesResponseArray: \(surveyAssessmentModel.finalSometimesResponses)")
        print("surveyAssessmentModel finalYesResponseArray: \(surveyAssessmentModel.finalYesResponses)")
    }
    
    func saveWrittenHearingTest() async {
        await surveyAssessmentModel.getSurveyData()
        await surveyAssessmentModel.saveSurveyToJSON()
        await surveyAssessmentModel.writeSurveyResultsToCSV()
        await surveyAssessmentModel.writeInputSurveyResultsToCSV()
    }
    
}

//struct SurveyErrorView: View {
//
//    @StateObject var colorModel: ColorModel = ColorModel()
//    
//    var body: some View {
//        ZStack{
//            colorModel.colorBackgroundRed.ignoresSafeArea(.all, edges: .top)
//            VStack{
//                Spacer()
//                Text("Please hit BACK and confirm you selected submit survey at the bottom of the survey questions")
//                    .foregroundColor(.white)
//                    .font(.title)
//                    .hoverEffect(/*@START_MENU_TOKEN@*/.highlight/*@END_MENU_TOKEN@*/)
//                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                    .brightness(4.0)
//                Spacer()
//            }
//        }
//     }
//}


//struct UserWrittenHearingAssessmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserWrittenHearingAssessmentView()
//    }
//}
