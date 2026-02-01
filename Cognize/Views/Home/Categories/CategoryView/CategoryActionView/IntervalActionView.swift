//
//  IntervalActionView.swift
//  Cognize
//
//  Created by Matvii Ustich on 31/01/2026.
//

import SwiftUI
import SwiftData

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
        VStack() {
            
            // MARK: - Stats & Config Card
            VStack(alignment: .leading) {
            
                
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
                    
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.1), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
            }
            .padding()
            
            
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
