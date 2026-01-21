//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import FamilyControls
import SwiftData

struct CategoryCardView: View {
    let category: Category
    let animate: Bool
    
    @Environment(\.modelContext) private var modelContext
    @Query private var logs: [IntentionLog]
    
    init(category: Category, animate: Bool = true) {
        self.category = category
        self.animate = animate
        
        let categoryId = category.id
        self._logs = Query(filter: #Predicate<IntentionLog> { log in
            log.categoryId == categoryId
        }, sort: \IntentionLog.date, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: category.color, animate: animate)
            
            // Content
            VStack {
                Text(category.name)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .padding()
                
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No Logs Yet",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Create a new log to see history.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(logs) { log in
                                LogRowView(log: log)
                            }
                        }
                    }
                }
                //                CategoryReportView(category: category)
                Spacer()
            }
            .padding()
        }
        .glassEffect(in: .rect(cornerRadius: 20))
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

// MARK: - Subviews

/// A specific row design that looks good inside a glass container
struct LogRowView: View {
    let log: IntentionLog
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(log.reason)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Text(log.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 2) {
                    Image(systemName: "hourglass")
                        .font(.caption2)
                    Text("\(log.duration)m")
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                
                if log.isActive {
                    Text("Active")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.green.opacity(0.8)))
                        .foregroundStyle(.black)
                }
            }
        }
        .padding()
        .glassEffect(.regular.tint(.white.opacity(0.1)).interactive())
        .padding(.horizontal, 7)
        // Inner layer: A thin material to separate the row from the card background
//        .background(.ultraThinMaterial)
//        .cornerRadius(12)
//        // Subtle border to define the row edges
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(.white.opacity(0.1), lineWidth: 0.5)
//        )
    }
}

#Preview(traits: .intentionLogSampleData) {
    let category = Category.sampleData[0]
    
    CategoryCardView(category: category)
    
}
