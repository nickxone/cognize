//
//  CategoryDetailView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import SwiftData
import FamilyControls

struct CategoryDetailView: View {
    let category: Category
    
    @Environment(\.dismiss) private var dismiss
    
    @Query private var logs: [IntentionLog]
    
    init(category: Category) {
        self.category = category
        _logs = Query(
            filter: #Predicate<IntentionLog> { $0.categoryId == category.id },
            sort: [SortDescriptor(\.date, order: .reverse)]
        )
    }
    
    var body: some View {
        ZStack {
            Group {
                Color.white.opacity(0.35)
                ColorfulBackground(color: category.color, animate: true)
                Color.black.opacity(0.2)
            }
            
            ScrollView {
                Spacer(minLength: 80)
                
                CategoryCardView(category: category, animate: false)
                    .padding(.bottom, 24)
                
                // Logs
                VStack(alignment: .leading, spacing: 12) {
                    Text("Intentions")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                    
                    if logs.isEmpty {
                        Text("No intentions yet.")
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .glassEffect()
                            .padding(.horizontal)
                    } else {
                        ForEach(logs) { log in
                            IntentionRow(log: log, tint: category.color)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.down.forward.and.arrow.up.backward")
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Circle().fill(.ultraThinMaterial))
                    .padding(.horizontal, 12)
            }
            .hapticFeedback(.cancelHaptic)
        }
    }
}

private struct IntentionRow: View {
    let log: IntentionLog
    let tint: Color
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text(log.reason.isEmpty ? "No reason provided" : log.reason)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                HStack(spacing: 12) {
                    Label("\(log.duration) min", systemImage: "hourglass")
                    Text(log.date, style: .relative)
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(14)
        .glassEffect()
//        .glass(gradientOpacity: 0.30, gradientStyle: .normal, shadowColor: tint.opacity(0.25))
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(tint.opacity(0.25))
                .frame(width: 8, height: 8)
                .padding(10)
        }
    }
}

#Preview(traits: .intentionLogSampleData) {
//    let configuration = RestrictionConfiguration.shield( ShieldConfig(limit: .timeLimit(minutesAllowed: 30)))
//    let category = Category(name: "Social", appSelection: FamilyActivitySelection(), color: .blue, configuration: configuration)
    
    let category = Category.sampleData[0]
        
    CategoryDetailView(category: category)
        .preferredColorScheme(.dark)
}
