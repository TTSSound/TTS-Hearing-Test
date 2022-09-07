//
//  TestSelectLinkModel.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/1/22.
//

import Foundation
import CodableCSV
//import Firebase
//import FirebaseStorage

class TestSelectLinkModel: ObservableObject {
    
    let ehaLink = "EHA.csv"
    let eptaLink = "EPTA.csv"
    let simpleLink = "Simple.csv"
    
    
    func writeEHATestLinkToCSV() async {
        print("writeEHATestSelectionLinkToCSV Start")
        let selectedEHATest = "EHA," + "EHA"
        do {
            let ehaTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let ehaSetupDocumentsDirectory = ehaTestLinkPath
            print("CSV Setup DocumentsDirectory: \(ehaSetupDocumentsDirectory)")
            let ehaLinkFilePath = ehaSetupDocumentsDirectory.appendingPathComponent("EHA.csv")
            print(ehaLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: ehaLinkFilePath, append: false)
            try writerSetup.write(row: [selectedEHATest])
            print("CVS EHA Link Writer Success")
        } catch {
            print("CVSWriter EHA Link  Error or Error Finding File for EHA Link CSV \(error.localizedDescription)")
        }
    }
    
    func writeEPTATestLinkToCSV() async {
        print("writeEPTATestSelectionLinkToCSV Start")
        let selectedEPTATest = "EPTA," + "EPTA"
        do {
            let eptaTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let eptaSetupDocumentsDirectory = eptaTestLinkPath
            print("CSV Setup DocumentsDirectory: \(eptaSetupDocumentsDirectory)")
            let eptaLinkFilePath = eptaSetupDocumentsDirectory.appendingPathComponent("EPTA.csv")
            print(eptaLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: eptaLinkFilePath, append: false)
            try writerSetup.write(row: [selectedEPTATest])
            print("CVS EPTA Link Writer Success")
        } catch {
            print("CVSWriter EPTA Link  Error or Error Finding File for EPTA Link CSV \(error.localizedDescription)")
        }
    }
    
    func writeSimpleTestLinkToCSV() async {
        print("writeSimpleTestSelectionLinkToCSV Start")
        let selectedSimpleTest = "Simple," + "Simple"
        do {
            let simpleTestLinkPath = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let simpleSetupDocumentsDirectory = simpleTestLinkPath
            print("CSV Setup DocumentsDirectory: \(simpleSetupDocumentsDirectory)")
            let simpleLinkFilePath = simpleSetupDocumentsDirectory.appendingPathComponent("Simple.csv")
            print(simpleLinkFilePath)
            let writerSetup = try CSVWriter(fileURL: simpleLinkFilePath, append: false)
            try writerSetup.write(row: [selectedSimpleTest])
            print("CVS Simple Link Writer Success")
        } catch {
            print("CVSWriter Simple Link  Error or Error Finding File for Simple Link CSV \(error.localizedDescription)")
        }
    }
}
