//
//  ContentView.swift
//  BetterRest
//
//  Created by Bryan Williamson on 6/6/24.
//

import CoreML
import SwiftUI
/*
 Resources:
 - https://www.hackingwithswift.com/books/ios-swiftui/betterrest-introduction
 - https://www.hackingwithswift.com/books/ios-swiftui/entering-numbers-with-stepper
 - https://www.hackingwithswift.com/books/ios-swiftui/selecting-dates-and-times-with-datepicker
 - https://www.hackingwithswift.com/books/ios-swiftui/working-with-dates
 - https://www.hackingwithswift.com/books/ios-swiftui/training-a-model-with-create-ml
 - https://www.hackingwithswift.com/books/ios-swiftui/building-a-basic-layout
 - https://www.hackingwithswift.com/books/ios-swiftui/connecting-swiftui-to-core-ml
 - https://www.hackingwithswift.com/books/ios-swiftui/cleaning-up-the-user-interface
 */

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var bedTime = Date.now
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration() //
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep // bedtime
            return "Your ideal bedtime is " + sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "There was an error"
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section() {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.title)
                }
                
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text(String($0))
                            
                        }
                    }
                }
                
                Text(sleepResults)
                    .font(.title3)
                
            }
        }
    }
    
 
}

#Preview {
    ContentView()
}
