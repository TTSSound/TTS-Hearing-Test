//
//  SurveyAssessmentModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/31/22.
//

import Foundation
import CoreMedia
import AudioToolbox
import QuartzCore
import SwiftUI
import CoreData
import CodableCSV
//import Alamofire


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

class SurveyAssessmentModel: ObservableObject {
     
    //Hearing Self Assessment Variables
    @Published var hhsiNoResponses = [Int]()
    @Published var hhsiSometimesResponses = [Int]()
    @Published var hhsiYesResponses = [Int]()
    @Published var hhsiScore = [Int]()
    
    //Final Result Variables for Writing
//    @Published var finalUserAgreementAgreed: [Int] = [Int]()
//    @Published var finalUserAgreementAgreedDate: [Date] = [Date]()
    @Published var finalQuestion1responses: [Int] = [Int]()
    @Published var finalQuestion2responses: [Int] = [Int]()
    @Published var finalQuestion3responses: [Int] = [Int]()
    @Published var finalQuestion4responses: [Int] = [Int]()
    @Published var finalQuestion5responses: [Int] = [Int]()
    @Published var finalQuestion6responses: [Int] = [Int]()
    @Published var finalQuestion7responses: [Int] = [Int]()
    @Published var finalQuestion8responses: [Int] = [Int]()
    @Published var finalQuestion9responses: [Int] = [Int]()
    @Published var finalQuestion10responses: [Int] = [Int]()
    @Published var finalNoResponses: [Int] = [Int]()
    @Published var finalSometimesResponses: [Int] = [Int]()
    @Published var finalYesResponses: [Int] = [Int]()
    @Published var finalSummaryResponseScore: [Int] = [Int]()

    let fileSurveyName = ["SurveyResults.json"]
    let surveyCSVName = "SurveyResultsCSV.csv"
    let inputSurveyCSVName = "InputSurveyResultsCSV.csv"
    
    @Published var saveSurveyAssessmentResults: SaveSurveyAssessmentResults? = nil
 
// Original JSON Functions that Overwrite data at each call with only data in that view. Seems like class variables are not persisting across views in this class
    // JSON Variables
    func getSurveyData() async {
        guard let surveyData = await getSurveyJSONData() else { return }
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
}
