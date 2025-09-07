//
//  CategoryActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryActionView: View {
    let category: Category
    
    @State private var showCreateIntentionView = false
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: category.color, animate: false)
            
            switch category.configuration {
            case .shield( _, let shieldConfig):
                ShieldActionView(category: category, shieldConfig: shieldConfig)
            default:
                Text("Default")
            }
            VStack {
                Spacer()
                
                Button {
                    showCreateIntentionView = true
                } label: {
                    Text("Create Intention")
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
        .frame(width: UIScreen.main.bounds.width - 60,
               height: UIScreen.main.bounds.height * 0.2)
        .cornerRadius(20)
        .shadow(color: category.color.opacity(0.25), radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(category.color.opacity(0.15), lineWidth: 1)
        )
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
    let configuration = RestrictionConfiguration.shield(common: .init( startTime: DateComponents(hour: 0, minute: 0), endTime: DateComponents(hour: 23, minute: 59)), ShieldConfig(limit: .timeLimit(minutesAllowed: 30)))
    let category = Category(name: "Social", appSelection: FamilyActivitySelection(), color: .blue, configuration: configuration)
    
    CategoryActionView(category: category)
}
