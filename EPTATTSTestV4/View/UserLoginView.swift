//
//  UserLoginView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 8/26/22.
//

import SwiftUI

struct UserLoginView: View {
    
    @StateObject var colorModel: ColorModel = ColorModel()
    @EnvironmentObject var setupDataModel: SetupDataModel
    @EnvironmentObject var manualDeviceSelectionModel: ManualDeviceSelectionModel
    
    var body: some View {
        
        ZStack{
            colorModel.colorBackgroundBottomTiffanyBlue.ignoresSafeArea(.all, edges: .top)
            VStack{
                Text("User Login Screen")
                
                Text("Figure Out How to Setup Login Function and Option to Stay Logged In")
                
                Text("Also figure out how to make disclaimer agreement persist")
            }
            .foregroundColor(.pink)
        }
        .environmentObject(setupDataModel)
    }
// !!!!!! WILL NEED TO ADD VARIABLES FOR THIS ACTION INTO SETUPDATAMODEL, JSONS AND CSV WRITERS
    func saveLoginInformation() async {
        await setupDataModel.getSetupData()
        await setupDataModel.saveSetupToJSON()
        await setupDataModel.writeSetupResultsToCSV()
        await setupDataModel.writeInputSetupResultsToCSV()

    }
}

//struct UserLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserLoginView()
//            .environmentObject(SetupDataModel())
//    }
//}
