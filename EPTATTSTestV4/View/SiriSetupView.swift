//
//  SiriSetupView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/20/22.
//

import SwiftUI

struct SiriSetupView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
//    @State var siriLinkColors: [Color] = [Color.clear, Color.green]
//    @State var siriLinkColorIndex = Int()
    
    
    var body: some View {

        ZStack{
            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack(spacing: 10) {
                Text("To Ensure Your Device is Setup Properly, Three Steps Need To Be Completed.\n\nAfter completing step 3, access the final 4th setp to test your device and confirm it is setup properly. If there is an issue, we'll notify you.")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                NavigationLink {
                    ManualSetupView()
                } label: {
                    Text("If you would prefer to complete all steps manually, instructions on how to do this may be accessed here.")
                }


                Divider()
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: SilentModeSetupView()) {
                        VStack{
                        Image(systemName: "1.square.fill")
                            .foregroundColor(.white)
                        Text("Silence Mode")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: DNDSiriSetupView()) {
                        VStack{
                        Image(systemName: "2.square.fill")
                            .foregroundColor(.white)
                        Text("Don't Distrub")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: SystemVolumeView()) {
                        VStack{
                        Image(systemName: "3.square.fill")
                            .foregroundColor(.white)
                        Text("Set Volume")
                            .font(.footnote)
                            .foregroundColor(.white)
                            }
                    }
                    Spacer()
                    NavigationLink(destination: TestDeviceSetupView()) {
                        VStack{
                        Image(systemName: "4.square.fill")
                            .foregroundColor(.white)
                        Text("Test Setup")
                            .font(.footnote)
                            .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
        }
     }
}

//
//struct SiriSetupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SiriSetupView()
//    }
//}


//struct SilentModeSetupView: View {
    
//    @State var silentSetting = false
//    @State var setupDataModel: SetupDataModel = SetupDataModel()
//
//    var body: some View {
//
//            ZStack{
//                RadialGradient(
//                gradient: Gradient(colors: [Color.blue, Color.black]),
//                center: .center,
//                startRadius: -100,
//                endRadius: 300).ignoresSafeArea()
//                VStack(spacing: 5) {
//                    Text("First, We Must Ensure Device is Not Silenced")
//                        .font(.title)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    Text("Complete The Following Steps:")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal, 35.0)
//                    Spacer()
//                    Text("1. Locate the silence switch on the left side of your device.\n 2. With your finger, flip the switch to the upper position.\n 3. Look at the switch and confirm you do NOT see a red strip.\n 4. If you can see red at the switch, your device is still silenced!\n 5. If red is still visible, flip the switch in the opposite position.\n 6. Confirm you no longer see a red strip at the switch.\n 7. Mark this step as complete with the switch below, then select the Silence Tab.")
//                        .fontWeight(.regular)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.leading)
//                        .padding([.top, .leading, .trailing])
//                    Spacer()
//                    Toggle(isOn: $silentSetting) {
//                        Text("Select When Silent Mode is Disabled")
//                            .font(.title3)
//                            .fontWeight(.heavy)
//                            .foregroundColor(.green)
//                            .multilineTextAlignment(.leading)
//                            .padding(.all)
//                            .shadow(radius: 5)
//                    }
//                    .padding(.trailing, 30.0)
//                    .onChange(of: silentSetting) { _ in
//                        silentModeOff()
//                    }
//                    Spacer()
////                    SetupHSTACKNavigation()
//                    Spacer()
//                }
//            }
//     }
//
//    func silentModeOff() {
//        self.silentSetting = true
//        if setupDataModel.silentModeStatus.count < 1 || setupDataModel.silentModeStatus.count > 1{
//            setupDataModel.silentModeStatus.append(silentSetting)
//            print(setupDataModel.silentModeStatus)
//        } else {
//            setupDataModel.silentModeStatus.removeAll()
//            setupDataModel.silentModeStatus.append(silentSetting)
//            print(setupDataModel.silentModeStatus)
//        }
//    }
//}



//struct DNDSiriSetup: View {
    
//    @State var doNotDisturbSetting = false
//    @State var setupDataModel: SetupDataModel = SetupDataModel()
//    @State var colorModel: ColorModel = ColorModel()
//    
//    var body: some View {
//        ZStack{
//            colorModel.colorBackgroundTiffanyBlue.ignoresSafeArea(.all, edges: .top)
//            VStack{
//                Text("Next, We Higly Recommend Turning On Do Not Disturb!")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding([.leading, .bottom, .trailing])
//                Text("We don't want alerts and other device distractions interrupting your test. If this occurs, your test results will be invalid")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding([.top, .leading, .trailing])
//                Text("Let's use Siri to Complete This Step!")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal, 35.0)
//                Text("Press and hold the power button on the right side of your phone for 1 second and you heard a chime. Release the power button and say:")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding([.top, .leading, .trailing])
//                Text("HEY SIRI, TURN ON DO NOT DISTURB!")
//                    .font(.title2)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.vertical)
//                Toggle(isOn: $doNotDisturbSetting) {
//                    Text("Select When Do Not Disturb is Enabled")
//                        .font(.title3)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.green)
//                        .multilineTextAlignment(.leading)
//                        .padding(.all)
//                        .shadow(radius: 5)
//                }
//                .onChange(of: doNotDisturbSetting) { _ in
//                    DoNotDisturbModeOn()
//                }
//                Spacer()
////                SetupHSTACKNavigation()
//                Spacer()
//            }
//        }
//    }
//    
//    func DoNotDisturbModeOn() {
//        self.doNotDisturbSetting = true
//        if setupDataModel.doNotDisturbStatus.count < 1 || setupDataModel.doNotDisturbStatus.count > 1{
//            setupDataModel.doNotDisturbStatus.append(doNotDisturbSetting)
//            print(setupDataModel.doNotDisturbStatus)
//        } else {
//            setupDataModel.doNotDisturbStatus.removeAll()
//            setupDataModel.doNotDisturbStatus.append(doNotDisturbSetting)
//            print(setupDataModel.doNotDisturbStatus)
//        }
//    }
//}



//struct SystemVolumeView: View {
//    
//    @State var systemVolumeSetting = false
//    @State var setupDataModel: SetupDataModel = SetupDataModel()
//
//    var body: some View {
//
//        ZStack{
//            RadialGradient(
//            gradient: Gradient(colors: [Color.blue, Color.black]),
//            center: .center,
//            startRadius: -100,
//            endRadius: 300).ignoresSafeArea()
//            VStack{
//                Text("Next, We Your Help Setting The Proper Volume.")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                Text("We need this to meet our calibration specifications and produce valid results.")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding([.top, .leading, .trailing])
//                Text("Let's use Siri again!")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding([.top, .leading, .trailing])
//                Text("Press and hold the power button on the right side of your phone for 1 second and you heard a chime. Release the power button and say:")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding([.top, .leading, .trailing])
//                Text("HEY SIRI, TURN THE VOLUME TO 63 PERCENT!")
//                    .font(.title2)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(23.0)
//                Toggle(isOn: $systemVolumeSetting) {
//                    Text("Select When System Volume Is Changed To 63%")
//                        .font(.title3)
//                        .fontWeight(.heavy)
//                        .foregroundColor(.green)
//                        .multilineTextAlignment(.leading)
//                        .padding(.all)
//                        .shadow(radius: 5)
//                }
//                .onChange(of: systemVolumeSetting) { _ in
//                    systemVolumeNowSet()
//                }
//                Spacer()
//            }
//        }
//    }
//
//
//    func systemVolumeNowSet() {
//        self.systemVolumeSetting = true
//        if setupDataModel.systemVolumeStatus.count < 1 || setupDataModel.systemVolumeStatus.count > 1{
//            setupDataModel.systemVolumeStatus.append(systemVolumeSetting)
//            print(setupDataModel.systemVolumeStatus)
//        } else {
//            setupDataModel.systemVolumeStatus.removeAll()
//            setupDataModel.systemVolumeStatus.append(systemVolumeSetting)
//            print(setupDataModel.systemVolumeStatus)
//        }
//    }
//
//}




