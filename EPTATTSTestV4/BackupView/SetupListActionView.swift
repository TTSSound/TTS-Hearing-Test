//
//  SetupListActionView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/19/22.
//

//import SwiftUI
//import UIKit

//struct SetupListActionView: View {
//
//    private var dataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
//
//    var silentView: SilentView = SilentView()
//
//    init(){
//        UITableView.appearance().backgroundColor = .clear
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack{
//                RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]),
//                               center: .bottom,
//                    startRadius: -10,
//                    endRadius: 300).ignoresSafeArea()
//
//                List {
//                        NavigationLink { SilentView() }
//                        label: {
//                            Text("   1. Set Device Silent Mode")
//                                .fontWeight(.bold)
//
//                                .foregroundColor(.white)
//                        }
//                        .listRowBackground( RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
//                                                           center: .topLeading,
//                                                           startRadius: 10,
//                                                           endRadius: 330))
//
//                        NavigationLink { DoNotDisturbView() }
//                        label: {
//                            Text("   2. Set Device Do Not Distrub Mode")
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                        .listRowBackground( RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
//                                                           center: .topLeading,
//                                                           startRadius: 10,
//                                                           endRadius: 333))
//
//                        NavigationLink { SystemVolumeView() }
//                        label: {
//                            Text("   3. Set Device Volume")
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                        .listRowBackground( RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
//                                                           center: .topLeading,
//                                                           startRadius: 10,
//                                                           endRadius: 336))
//
//                        NavigationLink { TestSystemSettingsView4() }
//                        label: {
//                            Text("   4. Test New Device Settings")
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                        .listRowBackground( RadialGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
//                                                           center: .topLeading,
//                                                           startRadius: 10,
//                                                           endRadius: 339))
//                }
//                .listRowBackground(Color.clear)
//            }
//            .listStyle(.sidebar)
//        }
//    }
//}

//struct SilentView: View {
//
//    @State var silentSetting = false
//    private var silentDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
//
//    var body: some View {
//        ZStack{
//            RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]),
//                           center: .bottom,
//                startRadius: 180,
//                endRadius: 300).ignoresSafeArea()
//
//            VStack {
//                Text("Check the left side of your phone for the silence switch.")
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding([.top, .trailing], 60.0)
//                    .frame(width: /*@START_MENU_TOKEN@*/350.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
//
//                Text("With your finger, flip the switch to the upper position.")
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//
//                Text("Look at the switch and confirm you do NOT see a red strip.")
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.leading)
//                    .padding(.trailing)
//                    .frame(width: 350.0, height: 50.0)
//
//                Text("If you can see red at the switch, your device is still silenced!")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//
//                Text("Use your finger to flip the switch in its opposite position.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//
//                Text("Confirm you no longer see a red strip at the switch")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//
//                Divider()
//
//                Text("Mark this step as complete with the switch below")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 70.0)
//                    .frame(width: 350.0, height: 50.0)
//                Divider()
//
//                Toggle(isOn: $silentSetting) {
//                    Text("Select When Silent Mode is Disabled")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color.white)
//                        .padding(.leading, 40.0)
//                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                        .brightness(/*@START_MENU_TOKEN@*/2.6/*@END_MENU_TOKEN@*/)
//                }
//                .padding(.top, 150.0)
//                .toggleStyle(.automatic)
//                .foregroundColor(.white)
//                .padding(/*@START_MENU_TOKEN@*/.trailing, 20.0/*@END_MENU_TOKEN@*/)
//                .accentColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
//                .onChange(of: silentSetting) { _ in
//                    silentModeOff()
//                }
//            }
//            .padding(.bottom, 90.0)
//            .padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
//
//        }
//    }
//
//    func silentModeOff() {
//        self.silentSetting = true
//        if silentDataObjectModel.silentModeStatus.count < 1 || silentDataObjectModel.silentModeStatus.count > 1{
//            silentDataObjectModel.silentModeStatus.append(silentSetting)
//            print(silentDataObjectModel.silentModeStatus)
//        } else {
//            silentDataObjectModel.silentModeStatus.removeAll()
//            silentDataObjectModel.silentModeStatus.append(silentSetting)
//            print(silentDataObjectModel.silentModeStatus)
//        }
//    }
//}


//struct DoNotDisturbView: View {
//
//    @State var doNotDisturbSetting = false
//    private var dNDSDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
//
//    var body: some View {
//
//        ZStack{
//            RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]),
//                           center: .bottom,
//                startRadius: 180,
//                endRadius: 300).ignoresSafeArea()
//            VStack{
//                Text("Use your finger to flip the switch in its opposite position.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 55.0)
//                Text("Place your finger in the upper right corner of your screen and swipe down.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 80.0)
//                    .frame(width: 350.0, height: 70.0)
//                Text("On the new screen that appears, select the Focus button, which has a moon next to it.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 70.0)
//                Divider()
//                Text("Mark this step as complete with the switch below")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 70.0)
//                    .frame(width: 350.0, height: 50.0)
//                Spacer()
//            }
//            Spacer()
//        Divider()
//            Spacer()
//            VStack{
//                Spacer()
//                Toggle(isOn: $doNotDisturbSetting) {
//                    Text("Select When Do Not Disturb is Enabled")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color.white)
//                        .padding(.leading, 40.0)
//                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                        .brightness(/*@START_MENU_TOKEN@*/2.6/*@END_MENU_TOKEN@*/)
//                }
//                .padding(.top, 150.0)
//                .toggleStyle(.automatic)
//                .foregroundColor(.white)
//                .padding(/*@START_MENU_TOKEN@*/.trailing, 20.0/*@END_MENU_TOKEN@*/)
//                .accentColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
//                .onChange(of: doNotDisturbSetting) { _ in
//                    DoNotDisturbModeOn()
//                }
//            }
//            .padding(.bottom, 50.0)
//            .padding(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
//        }
//    }
//
//    func DoNotDisturbModeOn() {
//        self.doNotDisturbSetting = true
//        if dNDSDataObjectModel.doNotDisturbStatus.count < 1 || dNDSDataObjectModel.doNotDisturbStatus.count > 1{
//            dNDSDataObjectModel.doNotDisturbStatus.append(doNotDisturbSetting)
//            print(dNDSDataObjectModel.doNotDisturbStatus)
//        } else {
//            dNDSDataObjectModel.doNotDisturbStatus.removeAll()
//            dNDSDataObjectModel.doNotDisturbStatus.append(doNotDisturbSetting)
//            print(dNDSDataObjectModel.doNotDisturbStatus)
//        }
//    }
//}

//struct SystemVolumeView: View {
//
//    @State var systemVolumeSetting = false
//    private var systemVolumeDataObjectModel: EnvDataObjectModel = EnvDataObjectModel()
//
//    var body: some View {
//
//        ZStack{
//            RadialGradient(gradient: Gradient(colors: [Color.blue, Color.black]),
//                           center: .bottom,
//                startRadius: 180,
//                endRadius: 300).ignoresSafeArea()
//            VStack{
//                Text("Locate the volume buttons on the left side of your phone.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 80.0)
//                    .frame(width: 350.0, height: 50.0)
//                Text("Press the top, volume up, button until your device's volume reaches its maximum.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 50.0)
//                    .frame(width: 350.0, height: 70.0)
//                Text("Then..........................")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 180.0)
//                    .frame(width: 350.0, height: 50.0)
//                Divider()
//                Text("Find the lower volume button on the left side of your phone.")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//                Text("Press the volume down button 6 times")
//                    .foregroundColor(.white)
//                    .fontWeight(.heavy)
//                    .padding(.trailing, 80.0)
//                    .frame(width: 350.0, height: 50.0)
//                Divider()
//
//                Text("Mark this step as complete with the switch below")
//                    .foregroundColor(.white)
//                    .padding(.trailing, 60.0)
//                    .frame(width: 350.0, height: 50.0)
//                Spacer()
//
//            }
//
//            Divider()
//            Spacer()
//            VStack{
//                Spacer()
//                Toggle(isOn: $systemVolumeSetting) {
//                    Text("Select When System Volume Steps are Complete")
//                        .font(.headline)
//                        .fontWeight(.heavy)
//                        .foregroundColor(Color.white)
//                        .padding(.leading, 40.0)
//                        .frame(width: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                        .brightness(/*@START_MENU_TOKEN@*/2.6/*@END_MENU_TOKEN@*/)
//                }
//                .padding(.top, 150.0)
//                .toggleStyle(.automatic)
//                .foregroundColor(.white)
//                .padding(/*@START_MENU_TOKEN@*/.trailing, 20.0/*@END_MENU_TOKEN@*/)
//                .accentColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
//                .onChange(of: systemVolumeSetting) { _ in
//                    SystemVolumeSettings()
//                }
//            }
//            .padding(.bottom, 50.0)
//            .padding(.trailing)
//        }
//
//
//    }
//// !!!!!!!!! PICK UP HERE!!!!!!!!!!!!!!!!!!
//    func SystemVolumeSettings() {
//
//
//    }
//}

// Make this its own class or actor in another sheet
//struct TestSystemSettingsView4: View {
//    
//    var body: some View {
//        Text("This is View 4")
//    }
//}
//
//struct SetupListActionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetupListActionView()
//    }
//}



//Text("2. Place your finger in the upper right corner of your screen and swipe down. On the new screen that appears, select the Focus button, which has a moon next to it.")
//    .fontWeight(.bold)
//    .foregroundColor(.white)
//    .multilineTextAlignment(.leading)
//    .padding([.top, .leading, .trailing])
//Text("3. Using the volume buttons on the left side of your phone, press the top buttone to turn your device's volume all the way up. Then.....")
//    .fontWeight(.bold)
//    .foregroundColor(.white)
//    .multilineTextAlignment(.leading)
//    .padding(.all)
//Text("4. Find the lower volume button on the left side of your phone. Press the volume down button 6 times")
//    .fontWeight(.bold)
//    .foregroundColor(.white)
//    .multilineTextAlignment(.leading)
//    .padding([.leading, .bottom, .trailing])
//Text("5. After making these changes, press the 'Test Settings' button below, which will confirm your device is configured for a calibrated and valid test. ")
//    .fontWeight(.bold)
//    .foregroundColor(.white)
//    .multilineTextAlignment(.leading)
//    .padding([.leading, .bottom, .trailing])
//Text("6. If an issue is found when testing your device settings, you will be notified of what setting requires further adjustment.")
//    .fontWeight(.bold)
//    .foregroundColor(.white)
//    .multilineTextAlignment(.leading)
//    .padding([.leading, .bottom, .trailing])
