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
            .onChange(of: model.selectionToDiscourage) { _, _ in
                model.saveSelectionToDiscourage()
            }
            
            Spacer()
            
            Button {
                model.shieldActivities()
            } label: {
                Text("Shield Selected Activities")
            }
            
            Spacer()
            
            Button {
                model.unlockActivities(for: 1)
            } label: {
                Text("Unlock apps for 5 minutes")
            }
            
            Spacer()
            
            Button {
                stopMonitoring()
            } label: {
                Text("Clear All Settings")
            }

        }
        .padding()
    }
    
    func stopMonitoring() {
        model.clearAllSettings()
    }

}

#Preview {
    ContentView()
}
