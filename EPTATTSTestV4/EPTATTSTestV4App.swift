//
//  EPTATTSTestV4App.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/5/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct EPTATTSTestV4App: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
//            EPTATTSTestV4List()
//            DeviceSetupView()
//            WelcomeSetupView()
//            //SetupListActionView()
//            TestDeviceSetupView()
//            SiriSetupView()
//            CalibrationAssessmentView()
//            CalibrationSplashView()
//            LandingView()
//            UserWrittenHearingAssessmentView()
//            ManualDeviceEntryInformationView()
//            ManualDeviceEntryView()
//            TestDeviceSetupView()
//            ExplanationView()
//            InstructionsForTakingTest()
//            TestIDInputView()
//            PreTestView()
//            ClosingView()
//            TrainingTestView()
//            Bilateral1kHzTestView()
//            EHATTSTestPart1View()
//            SimpleTestView()
//            EHATTSTestView()
//            PostBilateral1kHzTestView()
//            EHATTSTestPart2View()
            NavigationView()

        }
    }
}
