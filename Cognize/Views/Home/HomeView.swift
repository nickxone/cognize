//
//  HomeView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI
import DeviceActivity

struct HomeView: View {
    @EnvironmentObject var model: ShieldViewModel
    
    @State private var selectedDuration = 5
    
    @State private var entertainmentPickerIsPresented = false
    @State private var workPickerIsPresented = false
    @State private var durationPickerIsPresented = false
    
    var body: some View {
        VStack {
            DeviceActivityReport(.totalActivity)
            
            Button {
                entertainmentPickerIsPresented = true
            } label: {
                Text("Select Entertainment Apps")
            }
            .sheet(isPresented: $entertainmentPickerIsPresented) {
                CustomFamilyActivityPicker(shieldCategory: .entertainment)
            }
            
            Spacer()
            
            Button {
                workPickerIsPresented = true
            } label: {
                Text("Select Work Apps")
            }
            .sheet(isPresented: $workPickerIsPresented, content: {
                CustomFamilyActivityPicker(shieldCategory: .work)
            })
            
            Spacer()
            
            Button {
                model.trackWorkActivities(thresholdUsageMinutes: 3, duringIntervalMinutes: 15)
            } label: {
                Text("Track Work Activities")
            }
            
            Spacer()
            
            Button {
                model.shield(.entertainment)
                model.shield(.work)
            } label: {
                Text("Shield Work & Entertainment Selected Activities")
            }
            
            Spacer()
            
            Button {
                durationPickerIsPresented = true
            } label: {
                Text("Unlock apps")
            }
            .sheet(isPresented: $durationPickerIsPresented) {
                DurationPickerView(selectedDuration: $selectedDuration) {
                    model.unlockEntertainmentActivities(for: selectedDuration)
                    durationPickerIsPresented = false
                }
                .presentationDetents([.medium])
            }
            
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    @ObservedObject var model = ShieldViewModel()
    
    HomeView()
        .environmentObject(model)
}
