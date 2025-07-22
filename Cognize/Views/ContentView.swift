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
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "book.circle.fill") {
                HomeView()
            }
            
            Tab("Report", systemImage: "paperplane.fill") {
                ReportView()
            }
            
            Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
            
        }
        .environmentObject(model)

    }
    
}

#Preview {
    ContentView()
}
