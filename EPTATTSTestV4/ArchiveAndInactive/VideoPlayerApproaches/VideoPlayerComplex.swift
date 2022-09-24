//
//  ExplanationYouTubeVideoView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/27/22.
//

//import SwiftUI
//import WebKit
//import UIKit
//
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
//        self.url = url
//    }
//}
//
////<iframe width="560" height="315" src="https://www.youtube.com/embed/KzQ4cYPZnfo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
//
//struct VideoPlayerComplex: View {
//    
//    @State var progress: Double = 0
//    @ObservedObject var webViewModel = WebViewModel(url: "https://www.youtube.com/watch?v=KzQ4cYPZnfo")
//        //"https://youtu.be/KzQ4cYPZnfo")
//    @State var pIdx = Int()
//    let progressIndex = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
//    let timer = Timer.publish(every: 0.25, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
//        
//    var body: some View {
//
//        ZStack {
// 
//                WebViewContainer(webViewModel: webViewModel)
//                .frame(width: 300, height: 300, alignment: .center)
//               
////                if webViewModel.isLoading {
////                    CircularProgressView(progress: progress)
////                        .frame(height: 30)
////                }
////                NavigationLink("TestSelectionLandingView") {
////                    TestSelectionLandingView()
////                }
////                .padding(.bottom, 60)
//            }
//
//            .navigationBarTitle(Text(webViewModel.title), displayMode: .inline)
//            .navigationBarItems(leading: Button(action: {
//                webViewModel.shouldGoBack.toggle()
//            }, label: {
//                if webViewModel.canGoBack {
//                    Image(systemName: "arrow.left")
//                        .frame(width: 44, height: 44, alignment: .center)
//                        .foregroundColor(.black)
//                } else {
//                    EmptyView()
//                        .frame(width: 0, height: 0, alignment: .center)
//                }
//            })
//            )
//    }
//}
//
//
//struct CircularProgressView: View {
//    let progress: Double
//    
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(
//                    Color.pink.opacity(0.5),
//                    lineWidth: 30
//                )
//            Circle()
//                .trim(from: 0, to: progress)
//                .stroke(
//                    Color.pink,
//                    style: StrokeStyle(
//                        lineWidth: 30,
//                        lineCap: .round
//                    )
//                )
//                .rotationEffect(.degrees(-90))
//                .animation(.easeOut, value: progress)
//        }
//        .frame(width: 200, height: 100, alignment: .center)
//        .padding(.bottom, 20)
//    }
//}
//
////struct ContentView: View {
////    var body: some View {
////        CircularProgressView(progress: 0.8)
////            .frame(width: 200, height: 200)
////    }
////}
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
//
//struct ExplanationYouTubeVideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoPlayerComplex()
//    }
//}
