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
    @State private var accentColor: Color = .blue
    
    @Query var logs: [IntentionLog]
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                CategoriesView(accentColor: $accentColor)
            }
            Tab("Achievements", systemImage: "trophy") {
                Text("To Be Created")
            }
            Tab("Profile", systemImage: "person") {
                SettingsView()
            }
        }
        .tint(accentColor)
        .permissionSheet([.familyControls, .notifications])
        .preferredColorScheme(.dark)
        .onAppear {
            for log in logs {
                print(log.reason)
            }
        }
    }
}

#Preview {
    ContentView()
}
