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
    @State private var newName = ""
    @State private var newType: Category.RestrictionType = .shield
    @State private var newSelection = FamilyActivitySelection()
    @State private var showPicker = false
    
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
                                if newCategory.restrictionType == .shield {
                                    let strategy = newCategory.strategy as! ShieldRestriction
                                    strategy.shield()
                                } else if newCategory.restrictionType == .interval {
                                    let strategy = newCategory.strategy as! IntervalTrackRestriction
                                    strategy.track(thresholdUsageMinutes: 5, duringIntervalMinutes: 15)
                                }
                                print(newCategory)
                                store.save(categories)
                                resetNewInputs()
                                isCreating = false
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
                                isCreating = false
                                resetNewInputs()
                            }
                        }
                    }
                }
            }
            .onAppear {
                categories = store.load()
            }
        }
    }
    
    private func resetNewInputs() {
        newName = ""
        newType = .shield
        newSelection = FamilyActivitySelection()
    }
}

