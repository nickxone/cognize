//
//  HomeView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ShieldViewModel
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
                model.shieldEntertainment()
            } label: {
                Text("Shield Selected Activities")
            }
            
            Spacer()
            
            Button {
                model.unlockActivities(for: 1)
            } label: {
                Text("Unlock apps for 5 minutes")
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
