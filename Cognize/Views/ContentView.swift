//
//  ContentView.swift
//  Cognize
//
//  Created by Matvii Ustich on 16/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch activeTab {
                case .home:
                    CategoriesView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .transition(.opacity)
                case .achievements:
                    Text("To Be Created")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .transition(.opacity)
                case .profile:
                    SettingsView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: activeTab)

            CustomTabBar(activeTab: $activeTab) { _ in
                // Tab tapped
            } onSearchTextChanged: { _ in
                // Search input
            }
        }
        .permissionSheet([.familyControls, .notifications])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
