//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryCardView: View {
    let category: Category
    let animate: Bool
    
    init(category: Category, animate: Bool = true) {
        self.category = category
        self.animate = animate
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

                CategoryReportView(category: category)
                Spacer()
            }
            .padding()
        }
        .glass(gradientOpacity: 0.35, shadowOpacity: 0.4)
        .frame(width: UIScreen.main.bounds.width - 60,
               height: UIScreen.main.bounds.height * 0.5)
        .preferredColorScheme(.dark)
    }

}

#Preview {
    let configuration = RestrictionConfiguration.shield(ShieldRestriction.Configuration.timeLimit(.init(appSelection: FamilyActivitySelection(), timeAllowed: 30)))
    let category = Category(name: "Social", color: .blue, configuration: configuration)
    CategoryCardView(category: category)
    
}
