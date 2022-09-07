//
//  DownloadService.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/29/22.
//

//import Foundation
//import SwiftUI
//
//
//class DownloadService {
//  var downloadSession: URLSession!
//  
//    func start(file: File) {
//        let downloadTask = DownloadTask(file: file)
//
//        // Create request
//        let request = NSMutableURLRequest(url: downloadTask.url!)
//        request.httpMethod = "GET"
//        
//        // Create download task
//        downloadTask.task = downloadSession.downloadTask(with: request as URLRequest)
//
//        // Start download
//        downloadTask.task?.resume()
//        downloadTask.inProgress = true
//    }
//}
