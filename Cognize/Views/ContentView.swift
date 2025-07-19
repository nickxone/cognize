//
//  ContentView.swift
//  Cognize
//
//  Created by Matvii Ustich on 16/07/2025.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ContentView: View {
    @ObservedObject private var model = ShieldViewModel()
    @State private var pickerIsPresented = false
    var body: some View {
        VStack {
            Button {
                pickerIsPresented = true
            } label: {
                Text("Select Apps")
            }
            .familyActivityPicker(isPresented: $pickerIsPresented, selection: $model.activitySelection)
            
            Spacer()
            
            Button {
                model.shieldActivities()
            } label: {
                Text("Shield Selected Activities")
            }
            
//            Button {
//                
//            } label: {
//                Text("Create Schedule")
//            }

        }
        .padding()
    }
    
    func createSchedule() {
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59), repeats: true)
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("Error occured setting a schedule: \(error)")
        }
    }

}

#Preview {
    ContentView()
}
