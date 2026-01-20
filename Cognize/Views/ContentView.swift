//
//  ContentView.swift
//  Cognize
//
//  Created by Matvii Ustich on 16/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                CategoriesView()
            }
            Tab("Achievements", systemImage: "trophy") {
                Text("To Be Created")
            }
            Tab("Profile", systemImage: "person") {
                SettingsView()
            }
        }
        .permissionSheet([.familyControls, .notifications])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
