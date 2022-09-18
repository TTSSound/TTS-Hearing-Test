//
//  NavigationView.swift
//  EPTATTSTestV4
//
//  Created by Jeffrey Jaskunas on 9/17/22.
//

import SwiftUI
import Combine

class DataModel: ObservableObject {
    @Published var setups: [Setup] = []
    
    private var setupsById: [Setup.ID: Setup]? = nil
    private var cancellables: [AnyCancellable] = []
    
    static let shared: DataModel = DataModel()
    
    private init() {
        setups = builtInSetups
        $setups
            .sink { [weak self] _ in
                self?.setupsById = nil
            }
            .store(in: &cancellables)
    }
    
    func setups(relatedTo setup: Setup) -> [Setup] {
        setups
            .filter { setup.related.contains($0.id) }
            .sorted { $0.name < $1.name }
    }
    
    subscript(setupId: Setup.ID) -> Setup? {
        if setupsById == nil {
            setupsById = Dictionary(
                uniqueKeysWithValues: setups.map { ($0.id, $0) })
        }
        return setupsById![setupId]
    }
}
    
private let builtInSetups: [Setup] = {
    var setups = [
        "Disclaimer": Setup(id: 1.0, name: "Disclaimer", related: []),
        "User Setup": Setup(id: 2.0, name: "User Setup", related: []),
        "User Login": Setup(id: 2.01, name: "User Login", related: []),
        "UserDataSplash": Setup(id: 2.02, name: "UserDataSplash", related: []),
        "Test Explanation": Setup(id: 3.0, name: "Test Explanation", related: []),
        "Test Selection Home": Setup(id: 4.0, name: "Test Selection Home", related: []),
        "Test Selection": Setup(id: 4.2, name: "Test Selection", related: []),
        "TestSelectionSplash": Setup(id: 4.21, name: "TestSelectionSplash", related: []),
        "EHA Description": Setup(id: 4.01, name: "EHA Description", related: []),
        "Corrective Filters": Setup(id: 4.02, name: "Corrective Filters", related: []),
        "EPTA Description": Setup(id: 4.03, name: "EPTA Description", related: []),
        "Simple Trial Description": Setup(id: 4.04, name: "Simple Trial Description", related: []),
        "Calibrated Devices": Setup(id: 5.0, name: "Calibrated Devices", related: []),
        "CalibratedDevicesSplash": Setup(id: 5.01, name: "CalibratedDevicesSplash", related: []),
        "CalibratedDevicesIssue": Setup(id: 5.02, name: "CalibratedDevicesIssue", related: []),
        "Manual Device Information": Setup(id: 5.1, name: "Manual Device Information", related: []),
        "Disclaimer Manual Device": Setup(id: 5.11, name: "Disclaimer Manual Device", related: []),
        "Manual Device Entry": Setup(id: 5.12, name: "Manual Device Entry", related: []),
        "ManualDeviceEntrySplash": Setup(id: 5.13, name: "ManualDeviceEntrySplash", related: []),
        "Test Instructions": Setup(id: 6.0, name: "Test Instructions", related: []),
        "Siri Setup": Setup(id: 7.0, name: "Siri Setup", related: []),
        "Silent Mode": Setup(id: 7.01, name: "Silent Mode", related: []),
        "Do Not Disturb Mode": Setup(id: 7.02, name: "Do Not Disturb Mode", related: []),
        "System Volume Mode": Setup(id: 7.03, name: "System Volume Mode", related: []),
        "Manual System Setup": Setup(id: 7.1, name: "Manual System Setup", related: []),
        "Manual Setup Instructions": Setup(id: 7.11, name: "Manual Setup Instructions", related: []),
        "Test Device Settings": Setup(id: 7.2, name: "Test Device Settings", related: []),
        "In App Purchase": Setup(id: 4.1, name: "In App Purchase", related: [])
    ]
    
    setups["User Setup"]!.related = [
        setups["User Login"]!.id,
        setups["UserDataSplash"]!.id
    ]
    
    setups["User Login"]!.related = [setups["UserDataSplash"]!.id]
    setups["UserDataSplash"]!.related = [setups["User Login"]!.id]
    
    
    setups["Test Selection Home"]!.related = [
        setups["Test Selection"]!.id,
        //        setups["TestSelectionSplash"]!.id,
        setups["EHA Description"]!.id,
        setups["Corrective Filters"]!.id,
        setups["EPTA Description"]!.id,
        setups["Simple Trial Description"]!.id,
        setups["In App Purchase"]!.id,
        //        setups["Calibrated Devices"]!.id
    ]
    
    setups["Test Selection"]!.related = [setups["Test Selection Home"]!.id]
    
    //    setups["Test Selection Home"]!.related = [setups["EHA Description"]!.id]
    setups["EHA Description"]!.related = [setups["Test Selection Home"]!.id]
    setups["EHA Description"]!.related = [setups["In App Purchase"]!.id]
    setups["In App Purchase"]!.related = [setups["EHA Description"]!.id]
    
    //    setups["Test Selection Home"]!.related = [setups["Corrective Filters"]!.id]
    setups["Corrective Filters"]!.related = [setups["Test Selection Home"]!.id]
    setups["Corrective Filters"]!.related = [setups["In App Purchase"]!.id]
    setups["In App Purchase"]!.related = [setups["Corrective Filters"]!.id]
    
    //    setups["Test Selection Home"]!.related = [setups["EPTA Description"]!.id]
    setups["EPTA Description"]!.related = [setups["Test Selection Home"]!.id]
    setups["EPTA Description"]!.related = [setups["In App Purchase"]!.id]
    setups["In App Purchase"]!.related = [setups["EPTA Description"]!.id]
    
    //    setups["Test Selection Home"]!.related = [setups["Simple Trial Description"]!.id]
    setups["Simple Trial Description"]!.related = [setups["Test Selection Home"]!.id]
    setups["Simple Trial Description"]!.related = [setups["In App Purchase"]!.id]
    setups["In App Purchase"]!.related = [setups["Simple Trial Description"]!.id]
    
    
    setups["Test Selection"]!.related = [
        setups["TestSelectionSplash"]!.id,
        //        setups["EHA Description"]!.id,
        //        setups["Corrective Filters"]!.id,
        //        setups["EPTA Description"]!.id,
        //        setups["Simple Trial Description"]!.id,
        //        setups["In App Purchase"]!.id,
        setups["Calibrated Devices"]!.id
    ]
    
    setups["TestSelectionSplash"]!.related = [setups["Test Selection"]!.id]
    setups["Calibrated Devices"]!.related = [setups["Test Selection"]!.id]
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //Stopping Here for Relationships to Test Navigation Thus Far
    
    
    setups["Calibrated Devices"]!.related = [
        setups["CalibratedDevicesSplash"]!.id,
        setups["CalibratedDevicesIssue"]!.id,
        setups["Manual Device Information"]!.id,
        setups["Disclaimer Manual Device"]!.id,
        setups["Manual Device Entry"]!.id,
        setups["ManualDeviceEntrySplash"]!.id
    ]
    
    setups["Siri Setup"]!.related = [
        setups["Silent Mode"]!.id,
        setups["Do Not Disturb Mode"]!.id,
        setups["System Volume Mode"]!.id,
        setups["Manual System Setup"]!.id,
        setups["Manual Setup Instructions"]!.id
    ]
    
    return Array(setups.values)
}()



struct Setup: Hashable, Identifiable {
    let id: Double
    var name: String
    var related: [Setup.ID] = []
}



// StructContentView in Apple Sample Project
struct NavigationView: View {
    
    @StateObject private var navigationModel = NavigationModel()
    var dataModel = DataModel.shared
    @State var userLogInSetup: Setup = Setup(id: 2.01, name: "User Login")
    @State var userLoginName: String = String()
    
    
    var body: some View {
        NavigationStack(path: $navigationModel.setupPath) {
            
            NavigationLink("User Login", value: dataModel.setups[2])
                .foregroundColor(.green)
            
            List{
//                ForEach(dataModel.setups, id: \.self) { setup in
//                    NavigationLink(setup.name, value: setup)
//                }
            }
            .navigationDestination(for: Setup.self) { setup in
                UserLoginView(setup: setup, relatedLink: link)
            }
            .onAppear {
//                getLinks()
//                ForEach(dataModel.setups, id: \.self) { setup in
//                    NavigationLink(setup.name, value: setup)
//                }
            }
        }

    }
    func link(setup: Setup) -> some View {
        EmptyView()
    }
    
//    func getLinks() {
//        userLogInSetup = dataModel.setups[2]
//        userLoginName = userLogInSetup.name
////        NavigationLink(userLogInSetup.name, value: userLogInSetup)
//        print(userLogInSetup)
//        print(dataModel.setups)
//        
//    }
}

//struct NavigationView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        NavigationView()
//    }
//}


final class NavigationModel: ObservableObject, Codable {
    
    @Published var setupPath: [Setup]
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    init(setupPath: [Setup] = []
    ) {
        self.setupPath = setupPath
    }
    
    var selectedSetup: Setup? {
        get { setupPath.first }
        set { setupPath = [newValue].compactMap { $0 } }
    }
    
    
    var jsonData: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let data = newValue,
                  let model = try? decoder.decode(Self.self, from: data)
            else { return }
            setupPath = model.setupPath
        }
    }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let setupPathIds = try container.decode(
            [Setup.ID].self, forKey: .setupPathIds)
        self.setupPath = setupPathIds.compactMap { DataModel.shared[$0] }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setupPath.map(\.id), forKey: .setupPathIds)
    }

    enum CodingKeys: String, CodingKey {
        case setupPathIds
    }
}
