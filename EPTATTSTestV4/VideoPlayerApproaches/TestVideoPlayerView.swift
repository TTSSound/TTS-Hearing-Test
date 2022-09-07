//
//  TestVideoPlayerView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/28/22.
//

//import SwiftUI
//import AVKit
//import WebKit
//
//struct TestVideoPlayerView: View {
//    var body: some View {
//
//        VideoView(videoID: "KzQ4cYPZnfo")
//            .frame(minHeight: 0, maxHeight:
//                    UIScreen.main.bounds.height * 0.3)
//            .cornerRadius(12)
//            .padding(.horizontal, 24)
//    }
//}
//
//struct TestVideoPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestVideoPlayerView()
//    }
//}


//struct VideoView: UIViewRepresentable {
//
//    let videoID: String
//    //KzQ4cYPZnfo
//
//    func makeUIView(context: Context) -> WKWebView {
////        return WKWebView()
//        return WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
//        uiView.scrollView.isScrollEnabled = false
//        uiView.load(URLRequest(url: youtubeURL))
//    }
//
//}
