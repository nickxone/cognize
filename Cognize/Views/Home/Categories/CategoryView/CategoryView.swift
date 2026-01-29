//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/01/2026.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    let category: Category
    @Binding var focusedCategory: Category?
    @Binding var isEditing: Bool
    
    var onDelete: (() -> Void)?
    
    @State private var showDeletionAlert = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.categoryStore) private var store
    
    var body: some View {
        ZStack {
            if let focusedCategory, focusedCategory.id == category.id {
                CategoryBackgroundView(color: focusedCategory.color)
                    .padding(-500)
                    .allowsHitTesting(false)
            }
            GeometryReader { geometry in
                VStack {
                    CategoryCardView(category: category)
                        .frame(height: geometry.size.height * 0.65)
                        .overlay(alignment: .topLeading) {
                            if focusedCategory != nil && isEditing {
                                Button {
                                    showDeletionAlert = true
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(12)
                                        .background {
                                            Circle()
                                                .foregroundStyle(.black.opacity(0.3))
                                        }
                                        .padding(16)
                                }
                            }
                        }
                    
                    Spacer()
                    
                    CategoryActionView(category: category)
                        .frame(height: geometry.size.height * 0.3)
                    
                    Spacer()
                    
                }
            }
        }
        .alert("Delete \(category.name) category?", isPresented: $showDeletionAlert) {
            Button("Delete", role: .destructive) {
                withAnimation {
                    deleteCategory()
                }
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
        .tint(.white)
    }
    
    private func deleteCategory() {
        let categoryId = category.id
        
        do {
            let descriptor = FetchDescriptor<IntentionLog>(
                predicate: #Predicate { $0.categoryId == categoryId }
            )
            let logsToDelete = try modelContext.fetch(descriptor)
            
            for log in logsToDelete {
                modelContext.delete(log)
            }
            try modelContext.save()
        } catch {
            print("Failed to delete logs: \(error)")
        }
        // remove the associated restrictions
        category.removeRestrictions()
        // remove the category from UserDefaults
        var allCategories = store.load()
        if let index = allCategories.firstIndex(where: { $0.id == categoryId }) {
            allCategories.remove(at: index)
        }
        store.save(allCategories)
        focusedCategory = nil
        
        onDelete?()
    }
}

#Preview(traits: .intentionLogSampleData) {
    @Previewable @State var focusedCategory: Category? = Category.sampleData[0]
    @Previewable @State var isEditing: Bool = true
    let category = Category.sampleData[0]
    
    CategoryView(category: category, focusedCategory: $focusedCategory, isEditing: $isEditing)
}
