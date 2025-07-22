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
            Tab("Home", image: "SpiralIcon") {
                HomeView()
            }
            
            Tab("Home", systemImage: "book.circle.fill") {
                HomeView()
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
