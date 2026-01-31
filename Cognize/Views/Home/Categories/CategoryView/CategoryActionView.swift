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

struct ShieldActionView: View {
    let category: Category
    let shieldConfig: ShieldConfig
    
    @Binding var showCreateIntentionView: Bool
    
    @Query private var todayLogs: [IntentionLog]
    
    init(category: Category, shieldConfig: ShieldConfig, showCreateIntentionView: Binding<Bool>) {
        self.category = category
        self.shieldConfig = shieldConfig
        self._showCreateIntentionView = showCreateIntentionView
        
        let categoryId = category.id
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = #Predicate<IntentionLog> { log in
            log.categoryId == categoryId &&
            log.startDate >= start &&
            log.startDate < end
        }
        self._todayLogs = Query(filter: predicate)
    }
    
    private var stats: (title: String, used: Float, total: Float, unit: String) {
        let usedAmount: Double
        switch shieldConfig.limit {
        case .timeLimit:
            usedAmount = todayLogs.reduce(0) { $0 + $1.duration } / 60
        case .openLimit:
            usedAmount = Double(todayLogs.count)
        }
        
        switch shieldConfig.limit {
        case .openLimit(let limit, _):
            return (title: "Opens Used", used: Float(usedAmount), total: Float(limit), unit: "")
        case .timeLimit(let minutesAllowed):
            return (title: "Time Used", used: Float(usedAmount), total: Float(minutesAllowed), unit: "min")
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
            .disabled(stats.used >= stats.total)
            
        }
        .padding()
    }
}

struct IntervalActionView: View {
    let category: Category
    let intervalConfig: IntervalConfig
    
    @Binding var showCreateIntentionView: Bool
    @Query private var todayLogs: [IntentionLog]
    
    init(category: Category, intervalConfig: IntervalConfig, showCreateIntentionView: Binding<Bool>) {
        self.category = category
        self.intervalConfig = intervalConfig
        self._showCreateIntentionView = showCreateIntentionView
        
        let categoryId = category.id
        let start = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        
        let predicate = #Predicate<IntentionLog> { log in
            log.categoryId == categoryId &&
            log.startDate >= start &&
            log.startDate < end
        }
        self._todayLogs = Query(filter: predicate)
    }
    
    private var stats: (title: String, used: Int, unit: String) {
        let totalSeconds = todayLogs.reduce(0) { $0 + $1.duration }
        let minutes = Int(totalSeconds / 60)
        return (title: "Time Spent", used: minutes, unit: "min")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Stats & Config Card
            VStack(alignment: .leading, spacing: 16) {
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(stats.title)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Spacer()
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.caption)
                            .foregroundStyle(category.color.gradient)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(stats.used)")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: category.color.opacity(0.3), radius: 8, x: 0, y: 0)
                        
                        Text(stats.unit)
                            .font(.system(.body, design: .rounded).bold())
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.1), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                
                HStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.open.fill")
                            .foregroundStyle(category.color)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Unlocks for")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.6))
                            Text("\(intervalConfig.thresholdTime) min")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "stopwatch.fill")
                            .foregroundStyle(category.color)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("During")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.6))
                            Text("\(intervalConfig.intervalLength) min")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(20)
            
            Spacer()
            
            // MARK: - Action Button
            Button {
                showCreateIntentionView = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.headline)
                    Text("New Intention")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background {
                    Capsule()
                        .fill(category.color.gradient)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
            }
        }
        .padding()
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

