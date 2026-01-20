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
        })
    }

    var body: some View {
        ZStack {
            // Background
            ColorfulBackground(color: category.color, animate: animate)

            // Content
            List {
                ForEach(logs) { log in
                    Text(log.date.description)
                }
            }
//            VStack {
//                Text(category.name)
//                    .font(.title2.bold())
//                    .foregroundStyle(.primary)
//                    .padding()
//
//                CategoryReportView(category: category)
//                Spacer()
//            }
//            .padding()
            .glassEffect(in: .rect(cornerRadius: 20))
        }
        .preferredColorScheme(.dark)
    }

}

#Preview {
    let configuration = RestrictionConfiguration.shield( ShieldConfig(limit: .timeLimit(minutesAllowed: 30)))
    let category = Category(name: "Social", appSelection: FamilyActivitySelection(), color: .blue, configuration: configuration)
    
    CategoryCardView(category: category)
    
}
