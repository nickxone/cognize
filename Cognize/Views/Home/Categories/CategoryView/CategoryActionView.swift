//
//  CategoryActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import SwiftData
import FamilyControls

struct CategoryActionView: View {
    let category: Category
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showCreateIntentionView = false
    
    @Query private var latestLog: [IntentionLog]
    
    
    var body: some View {
        ZStack {
            ColorfulBackground(color: category.color, animate: false)
            
        }
        .glassEffect(in: .rect(cornerRadius: 20))
        .sheet(isPresented: $showCreateIntentionView) {
            IntentionCreationView(category: category)
        }
        .preferredColorScheme(.dark)
    }
}

struct ShieldActionView: View {
    let category: Category
    let shieldConfig: ShieldConfig
    let shieldUsageStore = ShieldUsageStore()
    
    var body: some View {
        VStack {
            switch shieldConfig.limit {
            case .openLimit(let openLimit, _):
                Text("Opens Used")
                ProgressView(value: Float(shieldUsageStore.used(for: category.id, config: shieldConfig)), total: Float(openLimit))
            case .timeLimit(let minutesAllowed):
                Text("Time Used")
                ProgressView(value: Float(shieldUsageStore.used(for: category.id, config: shieldConfig)), total: Float(minutesAllowed))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let configuration = RestrictionConfiguration.shield( ShieldConfig(limit: .timeLimit(minutesAllowed: 30)))
    let category = Category(name: "Social", appSelection: FamilyActivitySelection(), color: .blue, configuration: configuration)
    
    CategoryActionView(category: category)
}

