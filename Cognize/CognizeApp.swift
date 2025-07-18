//
//  CognizeApp.swift
//  Cognize
//
//  Created by Matvii Ustich on 16/07/2025.
//

import SwiftUI
import FamilyControls

@main
struct CognizeApp: App {
    let center = AuthorizationCenter.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        do { // Request Authorisation
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Failed to enroll a user with error: \(error)")
                        }
                    }
                }
        }
    }
}
