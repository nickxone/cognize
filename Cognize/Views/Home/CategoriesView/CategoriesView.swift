//
//  CategoriesView.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import FamilyControls
// MARK: DON'T load Categories lazily since the system stops rendering DeviceActivityReportExtension at some point
// as an option lazily load CardViews that will take CategoryReportView as parameters (and load CategoryReportView-s eagerly)
import SwiftUI

struct CategoriesView: View {
    @Environment(\.categoryStore) private var store

    @State private var categories: [Category] = []
    @State private var isCreating = false

    @State private var focusedCategory: Category?

    var body: some View {
        NavigationView {
            VStack {
                if categories.isEmpty {
                    Text("No Categories")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    FadingCardScrollView(
                        items: categories,
                        leadingView: {
                            CategoriesOverview(categories: categories)
                        },
                        content: { category in
                            ZStack {
                                if let focusedCategory, focusedCategory.id == category.id {
                                    CategoryBackgroundView(color: focusedCategory.color)
                                        .padding(-200)
                                        .allowsHitTesting(false)
                                }
                                VStack {
                                    CategoryCardView(category: category)
                                    Spacer()
                                }
                            }
                        },
                        focusedItem: $focusedCategory
                    )
                }

                Spacer()
            }
            .navigationTitle("Categories")
            .toolbar {
                Button("Add") {
                    isCreating = true
                }
            }
            .sheet(isPresented: $isCreating) {
                CategoryCreationView(categories: $categories)
            }
            .onAppear {
                categories = store.load()
            }
        }
    }

}
