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
    @Environment(\.categoryStore) private var store
    
    @Binding var categories: [Category]
    
    @State private var newName = ""
    @State private var newType: Category.RestrictionType = .shield
    @State private var newSelection = FamilyActivitySelection()
    @State private var selectedColor: Color = .black
    @State private var showPicker = false
    
    @State private var presentationDetent: PresentationDetent = .medium
    
    init(categories: Binding<[Category]>) {
        self._categories = categories
    }
    
    var body: some View {
        //        NavigationView {
        //            Form {
        //                Section(header: Text("Name")) {
        //                    TextField("Enter name", text: $newName)
        //                }
        //
        //                Section(header: Text("Restriction Type")) {
        //                    Picker("Type", selection: $newType) {
        //                        Text("Shield").tag(Category.RestrictionType.shield)
        //                        Text("Interval").tag(Category.RestrictionType.interval)
        //                    }
        //                    .pickerStyle(SegmentedPickerStyle())
        //                }
        //
        //                Section(header: Text("App Selection")) {
        //                    Button("Choose Apps") {
        //                        showPicker = true
        //                    }
        //                    Text("\(newSelection.applicationTokens.count) apps selected")
        //                        .font(.footnote)
        //                }
        //
        //                Section(header: Text("Color")) {
        //                    ColorPicker("Choose Color", selection: $selectedColor)
        //                }
        //
        //                Section {
        //                    Button("Save") {
        //                        let newCategory = Category(name: newName, appSelection: newSelection, restrictionType: newType, color: selectedColor)
        //                        categories.append(newCategory)
        //
        //                        // Apply the initial restriction
        //                        switch newCategory.restrictionType {
        //                        case .shield:
        //                            (newCategory.strategy as? ShieldRestriction)?.shield()
        //                        case .interval:
        //                            (newCategory.strategy as? IntervalTrackRestriction)?.track(thresholdUsageMinutes: 2, duringIntervalMinutes: 15)
        //                        case .allow:
        //                            (newCategory.strategy as? ShieldRestriction)?.shield()
        //                        }
        //
        //                        store.save(categories)
        //                        dismiss()
        //                    }
        //                    .disabled(newName.isEmpty)
        //                }
        //            }
        //            .sheet(isPresented: $showPicker) {
        //                CustomActivityPicker(activitySelection: $newSelection)
        //            }
        //            .navigationTitle("New Category")
        //            .toolbar {
        //                ToolbarItem(placement: .cancellationAction) {
        //                    Button("Cancel") {
        //                        dismiss()
        //                    }
        //                }
        //            }
        //        }
        NavigationStack {
            ZStack {
                // Background
                AngularGradient(
                    gradient: Gradient(colors: gradientColors(from: selectedColor)),
                    center: gradientCenter(for: selectedColor),
                    angle: .degrees(360)
                )
                .blur(radius: 20)
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Create New Category")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .padding(.top)
                    
                    TextField("Enter name", text: $newName)
                        .padding()
                        .background(selectedColor == .black ? .white.opacity(0.25) : .black.opacity(0.25))
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    CustomColorPicker(selectedColour: $selectedColor)
//                    ColorPicker("Choose Color", selection: $selectedColor, supportsOpacity: false)
//                        .padding()
                    
                    NavigationLink {
                        appSelection
                    } label: {
                        Text("Next")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                ZStack {
                                    Capsule()
                                        .fill(selectedColor.gradient)
                                    Capsule()
                                        .fill(.black.opacity(0.2))
                                }
                                .clipShape(Capsule())
                            }
                            .foregroundStyle(.white)
                    }
                    .disabled(newName.isEmpty)
                    .opacity(newName.isEmpty ? 0.6 : 1)
                    
                }
                
                .padding()
            }
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                        .padding(12)
                }
                .hapticFeedback(.cancelHaptic)
            }
        }
        .presentationDetents([presentationDetent])
        .onAppear {
            presentationDetent = .medium
        }
    }
    
    var appSelection: some View {
        ZStack {
            AngularGradient(
                gradient: Gradient(colors: gradientColors(from: selectedColor)),
                center: gradientCenter(for: selectedColor),
                angle: .degrees(360)
            )
            .blur(radius: 20)
            .ignoresSafeArea()
            
            VStack {
                CustomActivityPicker(activitySelection: $newSelection, color: selectedColor)
            }
        }
        .presentationDetents([.large])
        .onAppear {
            presentationDetent = .large
        }
    }
    
    // MARK: - Helpers
    private func gradientColors(from base: Color) -> [Color] {
        let uiColor = UIColor(base)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return [base.opacity(0.6), base.opacity(0.3), base.opacity(0.6)]
        }
        
        let c1 = Color(hue: Double(h), saturation: Double(s), brightness: Double(b * 1.1), opacity: 0.3)
        let c2 = Color(hue: Double((h + 0.03).truncatingRemainder(dividingBy: 1)), saturation: Double(s * 0.9), brightness: Double(b), opacity: 0.4)
        let c3 = Color(hue: Double((h + 0.06).truncatingRemainder(dividingBy: 1)), saturation: Double(s * 0.7), brightness: Double(b * 0.9), opacity: 0.25)
        
        return [c1, c2, c3, c1]
    }
    
    private func gradientCenter(for color: Color) -> UnitPoint {
        let uiColor = UIColor(color)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let offset = CGFloat((h - 0.5) * 0.2)
        return UnitPoint(x: 0.5 + offset, y: 0.5 - offset)
    }
}

#Preview {
    @Previewable @State var categories: [Category] = []
    Color.clear
        .sheet(isPresented: .constant(true)) {
            CategoryCreationView(categories: $categories)
        }
}
