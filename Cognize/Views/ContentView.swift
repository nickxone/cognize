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
                Text("Select Apps to Discourage")
            }
            .familyActivityPicker(isPresented: $pickerIsPresented, selection: $model.selectionToDiscourage)
            
            Spacer()
            
            Button {
                model.shieldActivities()
            } label: {
                Text("Shield Selected Activities")
            }
            
            Spacer()
            
            Button {
                createAllowSchedule()
            } label: {
                Text("Unlock apps for 15 minutes")
            }
            
            Spacer()
            
            Button {
                stopMonitoring()
            } label: {
                Text("Clear all Settings")
            }

        }
        .padding()
    }
    
    func stopMonitoring() {
        model.clearAllSettings()
    }
    
    func createAllowSchedule() {
        
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 15, to: now)!
        
        let intervalStart = Calendar.current.dateComponents([.hour, .minute], from: now)
        let intervalEnd = Calendar.current.dateComponents([.hour, .minute], from: endDate)
        print(intervalStart.hour!, intervalStart.minute!)
        print(intervalEnd.hour!, intervalEnd.minute!)
        
        let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false)
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.allow, during: schedule)
        } catch {
            print("Error occured setting a schedule: \(error)")
        }
        
    }

}

#Preview {
    ContentView()
}
