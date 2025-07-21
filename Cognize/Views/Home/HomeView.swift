//
//  HomeView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ShieldViewModel
    
    @State private var selectedDuration = 5
    
    @State private var entertainmentPickerIsPresented = false
    @State private var workPickerIsPresented = false
    @State private var durationPickerIsPresented = false
    
    var body: some View {
        VStack {
            Button {
                entertainmentPickerIsPresented = true
            } label: {
                Text("Select Entertainment Apps")
            }
            .familyActivityPicker(isPresented: $entertainmentPickerIsPresented, selection: $model.entertainmentSelection)
            .onChange(of: model.entertainmentSelection) { _, _ in
                model.saveSelections()
            }
            
            Spacer()
            
            Button {
                workPickerIsPresented = true
            } label: {
                Text("Select Work Apps")
            }
            .familyActivityPicker(isPresented: $workPickerIsPresented, selection: $model.workSelection)
            .onChange(of: model.workSelection) { _, _ in
                model.saveSelections()
            }
            
            Spacer()
            
            Button {
                model.trackWorkActivities(thresholdUsageMinutes: 3, duringIntervalMinutes: 15)
            } label: {
                Text("Track Work Activities")
            }
            
            Spacer()
            
            Button {
                model.shieldEntertainment()
            } label: {
                Text("Shield Selected Activities")
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
    }
}

#Preview {
    @ObservedObject var model = ShieldViewModel()
    
    HomeView()
        .environmentObject(model)
}
