//
//  SettingsView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: ShieldViewModel
    
    var body: some View {
        Button {
            model.clearAllSettings()
        } label: {
            Text("Clear All Settings")
        }
    }
}

#Preview {
    SettingsView()
}
