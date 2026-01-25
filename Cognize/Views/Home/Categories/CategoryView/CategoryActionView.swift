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
        }, sort: \IntentionLog.date, order: .reverse)
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
                        print("Stop Intention button pressed")
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
                    IntervalActionView(category: category, intervalConfig: intervalConfig)
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
}

struct ShieldActionView: View {
    let category: Category
    let shieldConfig: ShieldConfig
    let shieldUsageStore = ShieldUsageStore()
    
    @Binding var showCreateIntentionView: Bool
    
    private var stats: (title: String, used: Float, total: Float, unit: String) {
        switch shieldConfig.limit {
        case .openLimit(let limit, _):
            return (title: "Opens Used", used: Float(shieldUsageStore.used(for: category.id, config: shieldConfig)), total: Float(limit), unit: "")
        case .timeLimit(let minutesAllowed):
            return (title: "Time Used", used: Float(shieldUsageStore.used(for: category.id, config: shieldConfig)), total: Float(minutesAllowed), unit: "min")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 17) {
                HStack {
                    Text(stats.title)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .textCase(.uppercase)
                        .tracking(1)
                    
                    Spacer()
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(stats.used))")
                            .foregroundStyle(.white)
                        Text("/")
                            .foregroundStyle(.white.opacity(0.4))
                        Text("\(Int(stats.total))\(stats.unit)")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .font(.system(.body, design: .rounded).bold())
                }
                
                ProgressView(value: stats.used, total: stats.total)
                    .progressViewStyle(CategoryProgressStyle(color: category.color))
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            Spacer()
            
            Button {
                showCreateIntentionView = true
            } label: {
                Label("New Intention", systemImage: "plus")
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

#Preview(traits: .intentionLogSampleData) {
    let category = Category.sampleData[0]
    GeometryReader { geometry in
        CategoryActionView(category: category)
            .frame(height: geometry.size.height / 3.5)
    }
}

#Preview(traits: .intentionLogActiveSampleData) {
    let category = Category.sampleData[0]
    
    CategoryActionView(category: category)
}

