//
//  CategoriesView.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoriesView: View {
    private var store = CategoryStore.shared
    
    @State private var categories: [Category] = []
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.id) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.name)
                                .font(.headline)
                            Text("Type: \(category.restrictionType.rawValue.capitalized)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Apps selected: \(category.appSelection.applicationTokens.count)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
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

