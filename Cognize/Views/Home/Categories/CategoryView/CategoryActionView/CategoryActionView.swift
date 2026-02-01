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
    
    @Query private var logs: [IntentionLog]
    var latestLog: IntentionLog? {
        logs.first
    }
    
    init(category: Category, showCreateIntentionView: Bool = false) {
        self.category = category
        self.showCreateIntentionView = showCreateIntentionView
        self._logs = Query(filter: #Predicate<IntentionLog> { log in
            log.categoryId == category.id
        }, sort: \IntentionLog.startDate, order: .reverse)
    }
    
    
    var body: some View {
        ZStack {
            ColorfulBackground(color: category.color, animate: false)
            if let latestLog, latestLog.isActive {
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("Time Remaining")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text(latestLog.endDate, style: .timer)
                            .font(.system(size: 46, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .foregroundStyle(.white)
                            .shadow(color: category.color.opacity(0.5), radius: 10, x: 0, y: 0)
                    }
                    .padding(.top, 10)
                    
                    Button {
                        stopIntention()
                    } label: {
                        Label("Stop Intention", systemImage: "stop.fill")
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
            else {
                switch category.configuration {
                case .shield(let shieldConfig):
                    ShieldActionView(category: category, shieldConfig: shieldConfig, showCreateIntentionView: $showCreateIntentionView)
                case .interval(let intervalConfig):
                    IntervalActionView(category: category, intervalConfig: intervalConfig, showCreateIntentionView: $showCreateIntentionView)
                case .open( _):
                    Text("Open")
                }
            }
        }
        .glassEffect(in: .rect(cornerRadius: 20))
        .sheet(isPresented: $showCreateIntentionView) {
            IntentionCreationView(category: category)
        }
        .preferredColorScheme(.dark)
    }
    
    private func stopIntention() {
        print("Stop Intention button pressed")
        guard let log = latestLog else { return }
        withAnimation {
            log.duration = Date().timeIntervalSince(log.startDate)
            category.relock()
        }
    }
    
}

#Preview(traits: .intentionLogSampleData) {
    let category = Category.sampleData[1]
    GeometryReader { geometry in
        CategoryActionView(category: category)
            .frame(height: geometry.size.height / 3.5)
    }
}

#Preview(traits: .intentionLogActiveSampleData) {
    let category = Category.sampleData[0]
    
    CategoryActionView(category: category)
}

