//
//  CategoryDetailView.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryDetailView: View {
    let category: Category
    
    @Environment(\.dismiss) private var dismiss
    
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
                    .frame(width: UIScreen.main.bounds.width)
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
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                    }
                    .padding(.horizontal, 12)
            }
            .hapticFeedback(.cancelHaptic)
        }
    }
    
}

#Preview {
    let configuration = RestrictionConfiguration.shield(ShieldRestriction.Configuration.timeLimit(.init(appSelection: FamilyActivitySelection(), timeAllowed: 30)))
    let category = Category(name: "Social", color: .blue, configuration: configuration)
    CategoryDetailView(category: category)
        .preferredColorScheme(.dark)
}
