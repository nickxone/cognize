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
    
    @State private var pickerIsPresented = false
    @State private var durationPickerIsPresented = false
    
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
                    model.unlockActivities(for: selectedDuration)
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
