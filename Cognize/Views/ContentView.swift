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
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        VStack {
            switch activeTab {
            case .home:
                CategoriesView()
            case .achievements:
                Text("To Be Created")
            case .profile:
                SettingsView()
            }
            
            Spacer()
            
            CustomTabBar(activeTab: $activeTab) { _ in
                
            } onSearchTextChanged: { _ in
                
            }

        }

        
    }
    
}

#Preview {
    ContentView()
}
