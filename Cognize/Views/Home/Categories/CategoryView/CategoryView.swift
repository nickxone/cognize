//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/01/2026.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    @Binding var focusedCategory: Category?
    
    var body: some View {
        ZStack {
            if let focusedCategory, focusedCategory.id == category.id {
                CategoryBackgroundView(color: focusedCategory.color)
                    .padding(-200)
                    .allowsHitTesting(false)
            }
            GeometryReader { geometry in
                VStack {
                    CategoryCardView(category: category)
                        .frame(height: geometry.size.height * 0.65)
                    
                    //                    .overlay(alignment: .topLeading) {
                    //                        Button {
                    //                            showDetailView = true
                    //                        } label: {
                    //                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                    //                                .font(.callout)
                    //                                .foregroundStyle(.white)
                    //                                .padding(12)
                    //                                .background {
                    //                                    Circle()
                    //                                        .foregroundStyle(.black.opacity(0.3))
                    //                                }
                    //                                .padding(16)
                    //                        }
                    //                        .hapticFeedback()
                    //                    }
                    Spacer()
                    
                    CategoryActionView(category: category)
                        .frame(height: geometry.size.height * 0.3)
                    
                    Spacer()
                    
                }
            }
        }
    }
}	

#Preview(traits: .intentionLogSampleData) {
    @Previewable @State var focusedCategory: Category? = Category.sampleData[0]
    let category = Category.sampleData[0]
    CategoryView(category: category, focusedCategory: $focusedCategory)
}
