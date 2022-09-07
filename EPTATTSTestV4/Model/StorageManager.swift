//
//  StorageManager.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/30/22.
//

//import Foundation
//import SwiftUI
//import Firebase
//import FirebaseStorage
//import FirebaseFirestoreSwift
//import Firebase
//
//public class StorageManager: ObservableObject {
//    enum FirebaseErrors: Error {
//        case unknownFileURL
//    }
//    
//    let storage = Storage.storage()
//    let storageRef = Storage.storage().reference()
//    var myData: Data?
//    
//    
//    func uploadCSV(csv: Data) {
//        let filepath = Bundle.main.url(forResource: "SetupResultsCSV", withExtension: "csv")
//        guard let filepath = filepath else { return print(FirebaseErrors.unknownFileURL) }
//        
//        let localFile = filepath
//        
//        let setupResultsCSVRef = storageRef.child("CSV/SetupResultsCSV.csv")
//        let uploadTask = setupResultsCSVRef.putFile(from: localFile, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                print("!!!Error in uploadCSV File Located")
//                return
//            }
////            let size = metadata.size
//        }
//    }
//    
//}
    


    // Uploads the selected image/file data there is any.
//    func uploadSavedData() {
//        guard let data = myData else { return } // Checks whether there is actual data to upload.
//
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child("userUID/files/documentName.png")
//
//        let uploadTask = fileRef.putData(data, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else { return } // Cancels task if there is any error
//
////            fileRef.downloadURL { (url, error) in {
////                guard let downloadURL = url else { return }
////                print(downloadURL) // Prints the URL to the newly uploaded data.
////            }
//        }
//    }

