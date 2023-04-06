//
//  ContentView.swift
//  ButtonEventTesting
//
//  Created by Jeffrey Jaskunas on 7/25/22.
//

//import SwiftUI
//   
//struct ContentView: View {
//
//    @State private var volume: Double = 0
//    @State private var hasChanged: Bool = false
//    
//    
//    private let range: ClosedRange<Double> = 0...100
//    private let step: Double = 5
//    
//    
//    var body: some View {
//        
//        VStack{
//            Text(" Set Volume to  100. Current Volume = \(Int(volume)) ")
//            
//            HStack{
//                decreaseBtn
//                
//                Slider(value: $volume,
//                       in: range,
//                       step: step) {
//                    // Leave Label Closure Blank
//                } minimumValueLabel: {
//                    Text("\(Int(range.lowerBound))")
//                } maximumValueLabel: {
//                    Text("\(Int(range.upperBound))")
//                } onEditingChanged: { hasChanged in
//                    self.hasChanged = hasChanged
//                }
//                
////                Slider(value: $volume,
////                       in: range,
////                       step: step) { hasChanged in
////                    self.hasChanged = hasChanged
////                }
//                
//                increaseBtn
//            }
//        }
//        .padding()
//    }
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//private extension ContentView {
//    
//    func increase() {
//        guard volume < range.upperBound else { return }
//        volume += step
//    }
//    
//    func decrease() {
//        guard volume < range.lowerBound else { return }
//        volume -= step
//    }
//}
//
//
//private extension ContentView {
//    
//    var increaseBtn: some View {
//        Button {
//            withAnimation {
//                increase()
//            }
//        } label: {
//            Image(systemName: "plus")
//        }
//        .opacity(hasChanged ? 0.5 : 1)
//        .disabled(hasChanged)
//    }
//    
//    var decreaseBtn: some View {
//        Button {
//            withAnimation {
//                decrease()
//            }
//        } label: {
//            Image(systemName: "minus")
//        }
//        .opacity(hasChanged ? 0.5 : 1)
//        .disabled(hasChanged)
//    }
//    
//}
