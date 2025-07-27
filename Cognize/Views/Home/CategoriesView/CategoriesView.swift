//
//  CategoriesView.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoriesView: View {
    @Environment(\.categoryStore) private var store
    
    @State private var categories: [Category] = []
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
            VStack {
                if categories.isEmpty {
                    Text("No Categories")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    GeometryReader { geometry in
                        TabView {
                            ForEach(categories, id: \.id) { category in
                                GeometryReader { cardGeo in
                                    let scale = max(0.9, 1 - abs(cardGeo.frame(in: .global).midX - geometry.size.width / 2) / 500)
                                    
                                    CategoryView(category: category)
                                        .scaleEffect(scale)
                                        .animation(.easeOut(duration: 0.3), value: scale)
                                        .padding(.horizontal, 24)
                                    
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                    }
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
