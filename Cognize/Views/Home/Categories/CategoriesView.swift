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
    @State private var isEditing = false
    @State private var showDetailView = false
    @State private var focusedCategory: Category? = nil
    
    @Binding var accentColor: Color
    
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
                            CategoryView(category: category, focusedCategory: $focusedCategory, isEditing: $isEditing, onDelete: {
                                if let index = categories.firstIndex(where: { $0.id == category.id }) {
                                    categories.remove(at: index)
                                }
                            })
                        },
                        focusedItem: $focusedCategory
                    )
                    .onChange(of: focusedCategory) { oldValue, newValue in
                        HapticsEngine.shared.hapticFeedback(intensity: 0.3, sharpness: 1.0)
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        isCreating = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Edit", systemImage: "slider.horizontal.3") {
                        withAnimation { isEditing.toggle() }
                    }
                    .disabled(focusedCategory == nil)
                }
            }
            .sheet(isPresented: $isCreating) {
                CategoryCreationView(categories: $categories)
            }
            .fullScreenCover(isPresented: $showDetailView) {
                if let focusedCategory {
                    CategoryDetailView(category: focusedCategory)
                }
            }
            .onAppear {
                categories = store.load()
                accentColor = focusedCategory?.color ?? .blue
            }
            .onChange(of: focusedCategory, { oldValue, newValue in
                accentColor = focusedCategory?.color ?? .blue
            })
            .onDisappear {
                accentColor = .blue
            }
        }
    }
    
}

#Preview(traits: .intentionLogSampleData) {
    @Previewable @State var accentColor: Color = .blue
    let category: Category = Category.sampleData[0]
    let store: CategoryStore = .shared
    let defaults = UserDefaults(suiteName: "group.com.app.cognize")!
    store.save([category])
    
    return CategoriesView(accentColor: $accentColor)
        .environment(\.categoryStore, store)
        .defaultAppStorage(defaults)
        .preferredColorScheme(.dark)
}
