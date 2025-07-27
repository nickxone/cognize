//
//  CategoryCreationView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import FamilyControls

struct CategoryCreationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var categories: [Category]
    
    @State private var newName = ""
    @State private var newType: Category.RestrictionType = .shield
    @State private var newSelection = FamilyActivitySelection()
    @State private var showPicker = false
    
    private var store = CategoryStore.shared
    
    init(categories: Binding<[Category]>) {
        self._categories = categories
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter name", text: $newName)
                }
                
                Section(header: Text("Restriction Type")) {
                    Picker("Type", selection: $newType) {
                        Text("Shield").tag(Category.RestrictionType.shield)
                        Text("Interval").tag(Category.RestrictionType.interval)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("App Selection")) {
                    Button("Choose Apps") {
                        showPicker = true
                    }
                    Text("\(newSelection.applicationTokens.count) apps selected")
                        .font(.footnote)
                }
                
                Section {
                    Button("Save") {
                        let newCategory = Category(name: newName, appSelection: newSelection, restrictionType: newType)
                        categories.append(newCategory)
                        
                        // Apply the initial restriction
                        switch newCategory.restrictionType {
                        case .shield:
                            (newCategory.strategy as? ShieldRestriction)?.shield()
                        case .interval:
                            (newCategory.strategy as? IntervalTrackRestriction)?.track(thresholdUsageMinutes: 2, duringIntervalMinutes: 15)
                        case .allow:
                            (newCategory.strategy as? ShieldRestriction)?.shield()
                        }
                        
                        store.save(categories)
                        dismiss()
                    }
                    .disabled(newName.isEmpty)
                }
            }
            .sheet(isPresented: $showPicker) {
                CustomActivityPicker(activitySelection: $newSelection)
            }
            .navigationTitle("New Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var categories: [Category] = []
    CategoryCreationView(categories: $categories)
}
