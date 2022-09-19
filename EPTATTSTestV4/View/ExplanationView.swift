//
//  ExplanationView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/24/22.
//

import SwiftUI
import WebKit
import AVKit


// REPEATED HEARING TESTS ARE RECOMMENDED EVERY 1-3 YEARS

struct ExplanationView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    let videoExplanationLink = "KzQ4cYPZnfo"

//    let youtubeURL =  URL(string: "https://www.youtube.com/embed/KzQ4cYPZnfo")
//    @ObservedObject var webViewModel = WebViewModel(url: "https://www.youtube.com/embed/KzQ4cYPZnfo")

   
    var body: some View {
        
        ZStack {
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack {
                Spacer()
                VideoView(videoID: videoExplanationLink)
                    .frame(minHeight: 0, maxHeight:
                            UIScreen.main.bounds.height * 0.3)
                    .cornerRadius(12)
                    .padding(.horizontal, 12)
                
//                WebViewContainer(webViewModel: webViewModel)
//                    .frame(minHeight: 0, maxHeight:
//                            UIScreen.main.bounds.height * 0.3)
//                    .cornerRadius(12)
//                    .padding(.horizontal, 12)

                Spacer()
                
                ScrollView {
                    Text("ITEMS THE VIDEO WILL NEED TO ADDRESS\n\n1. What this test is and is not\n 2. TTS mission to provide valid test results\n 3. The harm caused by invalid or non-calibrated test results\n 4. The importance of calibration and what it is\n 5. Why we ask what devices you are using, our list of calibrated devices that is ever going and why we will not let you take our test without a calibrated valid setup\n\n We will not contribute to pseudo science and invalid health results that cause harm to the user!\n 6. How this test can be complete if you don't own calibrated equipment and how to submit a request to have your device(s) calibrated for testing\n 7. The type of tests offered and why you would want one over the other\n 8.What to expect as you complete this test\n 9. Importance of Device Setup Process\n 10. How long this will take")
                        .foregroundColor(.white)
                }
                .frame(minHeight: 0, maxHeight:
                        UIScreen.main.bounds.height * 0.3)
                .cornerRadius(12)
                .padding(.horizontal, 12)
                
                Spacer()
                
                NavigationLink {
                    TestSelectionLandingView()
                } label: {
                    HStack{
                        Spacer()
                        Text("Continue")
                        Spacer()
                        Image(systemName: "arrowshape.bounce.right")
                        Spacer()
                    }
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(300)
                }
                .padding(.bottom, 40)
                Spacer()
            }
        }
    }
    
}

//struct ExplanationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExplanationView()
//    }
//}


struct VideoView: UIViewRepresentable {

    let videoID: String
    //KzQ4cYPZnfo
    let videoThread = DispatchQueue(label: "BackGroundVideoThread", qos: .userInitiated)
    
    
    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
        return WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}


//
//class WebViewModel: ObservableObject {
//    @Published var isLoading: Bool = false
//    @Published var canGoBack: Bool = false
//    @Published var shouldGoBack: Bool = false
//    @Published var title: String = ""
//
//    var url: String
//
//    init(url: String) {
//        self.url = "https://www.youtube.com/embed/KzQ4cYPZnfo"
//    }
//}
//
//
//struct WebViewContainer: UIViewRepresentable {
//    @ObservedObject var webViewModel: WebViewModel
//
//    func makeCoordinator() -> WebViewContainer.Coordinator {
//        Coordinator(self, webViewModel)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        guard let url = URL(string: self.webViewModel.url) else {
//            return WKWebView()
//        }
//
//        let request = URLRequest(url: url)
////        let webView = WKWebView()
//        let webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1))
//        webView.navigationDelegate = context.coordinator
////        webView.uiDelegate = self
//        webView.allowsBackForwardNavigationGestures = true
//        webView.allowsLinkPreview = true
////        webView.navigationDelegate = self
//        webView.load(request)
//
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if webViewModel.shouldGoBack {
//            uiView.goBack()
//            webViewModel.shouldGoBack = false
//        }
//    }
//}
//
//extension WebViewContainer {
//    class Coordinator: NSObject, WKNavigationDelegate {
//        @ObservedObject private var webViewModel: WebViewModel
//        private let parent: WebViewContainer
//
//        init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
//            self.parent = parent
//            self.webViewModel = webViewModel
//        }
//
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            webViewModel.isLoading = true
//        }
//
//        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
//
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            webViewModel.isLoading = false
//            webViewModel.title = webView.title ?? ""
//            webViewModel.canGoBack = webView.canGoBack
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            webViewModel.isLoading = false
//        }
//    }
//}
