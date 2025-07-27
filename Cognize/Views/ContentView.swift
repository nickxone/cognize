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
    @State private var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab(value: 0) {
                CategoriesView()
            } label: {
                Label("Home", systemImage: "book.circle.fill")
            }
            
            Tab(value: 1) {
                ReportView()
            } label: {
                Label("Report", systemImage: "paperplane.fill")
            }
            
            Tab(value: 2) {
                SettingsView()
            } label: {
                Label("Settings", systemImage: "gearshape.fill")
            }
            
        }
        .sensoryFeedback(.impact, trigger: tabSelection)
        
    }
    
}

#Preview {
    ContentView()
}
