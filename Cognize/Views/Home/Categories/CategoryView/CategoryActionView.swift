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
    
    @Environment(\.modelContext) private var context
    
    @State private var showCreateIntentionView = false
    
    @Query private var latestLog: [IntentionLog]
    
    
    var body: some View {
        ZStack {
            ColorfulBackground(color: category.color, animate: false)
            switch category.configuration {
            case .shield(let shieldConfig):
                ShieldActionView(category: category, shieldConfig: shieldConfig)
            case .interval(let intervalConfig):
                IntervalActionView(category: category, intervalConfig: intervalConfig)
            case .open( _):
                Text("Open")
            }
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
            
            Button {
                print("Pressed")
            } label: {
                Text("New Intention")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        ZStack {
                            Capsule()
                                .fill(category.color.gradient)
                            Capsule()
                                .fill(.black.opacity(0.2))
                        }
                        .clipShape(Capsule())
                    }
                    .foregroundStyle(.white)
            }

        }
        .padding()
    }
}

struct IntervalActionView: View {
    let category: Category
    let intervalConfig: IntervalConfig
    
    var body: some View {
        
    }
}

#Preview {
    let category = Category.sampleData[0]
    
    CategoryActionView(category: category)
}

