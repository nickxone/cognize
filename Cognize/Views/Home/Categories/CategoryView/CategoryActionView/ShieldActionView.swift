//
//  ShieldActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/01/2026.
//

import SwiftUI
import SwiftData

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
