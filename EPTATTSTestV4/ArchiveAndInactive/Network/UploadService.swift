//
//  UploadService.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/29/22.
//

//import Foundation
//import SwiftUI
//
//class UploadService {
//  var uploadSession: URLSession!
//    
//    func start(file: File) {
//        let uploadTask = UploadTask(file: file)
//        let uploadData =  Data(file.data.utf8)
//
//        // Create request
//        let url = URL(string: file.link)!;
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        // Set headers if required, e.g.
//        //request.setValue("application/json", forHTTPHeaderField: "Accept")
//    
//        // Create upload task
//        uploadTask.task = uploadSession.uploadTask(with: request, from: uploadData)
//
//        // Start upload
//        uploadTask.task?.resume()
//        uploadTask.inProgress = true
//        
//    }
//}
